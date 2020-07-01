var url = new URL(location);
var package = url.searchParams.get('package');

if (package == null)
	document.location = "/data/catalog";

var packageUrl = `https://pasta.lternet.edu/package/metadata/eml/${ package.replace(/\./g, "/") }/newest`;
var repoUrl = `https://portal.edirepository.org/nis/mapbrowse?scope=${ package.split('.')[0] }&identifier=${ package.split('.')[1] }`;

var summary  = new PackageSummary();
var people   = new PackagePeople();
var coverage = new PackageCoverage();
var method   = new PackageMethod();
var file     = new PackageFile();

main(packageUrl);

// Create popup window for xml links
function main(url) {

	// Load package template
	var template = $('#detail-template').clone();
	template.removeAttr('hidden');
	template.removeAttr('id');

	// Load loader template
	var loader = $('#loading-template').clone();
	loader.removeAttr('hidden');
	loader.removeAttr('id');
	updateView("Loading Data...", loader);

	// Load xml from pasta
	loadXMLDoc(url, async function(xml) {
		try {
			let json = new X2JS().xml2json(xml)['eml'];
			let title = json['dataset']['title'];
			console.log("Raw Data: ", json);

			// Get citation text
			let packageId = json['_packageId'];
			let citation = await fetch('https://cite.edirepository.org/cite/' + packageId + '?style=RAW');
			citation = await citation.text();
			citation = JSON.parse(citation.replace(/'/g, '"'));

			// Load json data onto each page
			summary .parse(json, citation);
			people  .parse(json);
			coverage.parse(json);
			method  .parse(json);
			file    .parse(json);

			console.log("Parsed Data: ", {
				summary:  summary.data,
				people:   people.data,
				coverage: coverage.data,
				method:   method.data,
				file:     file.data,
			});

			// Build page onto template
			summary .build(template);
			people  .build(template);
			coverage.build(template);
			method  .build(template);
			file    .build(template);

			let edi_logo = `
				<img src="https://portal.edirepository.org/nis/images/EDI-logo-300DPI_5.png"
					 height=70
					 width=70 />
				<br>
				Package Origin
			`;

			let subtitle = `
				<a href="${ repoUrl }"
					id="edirepo-link"
					target="_blank"
					data-toggle="tooltip" data-placement="right" title="Repository display for this package has links to earlier revisions, provenance, code-generation and other tools.">
					${ edi_logo }
				</a>`;

			// Load template onto actual HTML
			updateView(
				makeTableRow([
					['th', 'col-10 title', title],
					['td', 'col-2 subtitle', subtitle]
				]),
				template
			);

			// customize tables: take out first border top of every table
			$('#detail #detail-body table').each(function(index) {
				$(this).find('tr:first td, tr:first th').addClass('no-border-top');
			});

			// Tooltip for hovering over edi repo link
			$('#edirepo-link').tooltip();

			// Added MathJax script
			loadMathJax();
		}
		catch (err) {
			updateView("Sorry, an error has occured! <br> " + err.stack);
		}
	}, function(err) {
		updateView("Error", err);
	});
}


// ----------------------- Helper Functions -------------------------


// Extract object, array, or text from JSON data
function extractString(data, path, keys, delim='') {
	if (data === undefined || data === null) return '';

	// Safely traverse down the JSON path
	if (path !== undefined && path.length > 0) {
		let pathList = path.split(' > ');

		for (let i in pathList) {
			let pathNode = pathList[i];
			if (data[pathNode] === undefined)
				return '';
			data = data[pathNode];
		}
	}

	var str = '';

	try {
		if (Array.isArray(data)) {
			for (let i in data) {
				if (i >= data.length - 1)
					str += extractStringObject(data[i], keys, ', ');
				else
					str += extractStringObject(data[i], keys, ', ') + delim;
			}
		}
		else if (data.ulink) {
			str += activateLink(data.ulink._url, extractStringObject(data.ulink, keys, delim));
		}
		else if (data.emphasis) {
			str += extractStringObject(data.__text.replace(/([^a-z0-9]\s*)\n(\s*[^a-z0-9])/i, '$1<i>' + data.emphasis + '</i>$2'), keys, delim);
		}
		else if (data.subscript) {
			str += extractStringObject(data.__text.replace(/([^a-z0-9]\s*)\n(\s*[^a-z0-9])/i, '$1<sub>' + data.subscript + '</sub>$2'), keys, delim);
		}
		else if (data.superscript) {
			str += extractStringObject(data.__text.replace(/([^a-z0-9]\s*)\n(\s*[^a-z0-9])/i, '$1<sup>' + data.superscript + '</sup>$2'), keys, delim);
		}
		else if (data.itemizedlist && data.itemizedlist.listitem) {
			str += '<ul>' + extractList(data.itemizedlist.listitem).map(item => '<li>' + extractString(item) + '</li>').join('') + '</ul>';
		}
		else if (data.para) {
			str += extractList(data, 'para').map(para => extractString(para)).join('<br><br>');
		}
		else if (data.__text !== undefined && (!keys || !keys.includes('__text'))) {
			str += extractStringObject(data.__text, keys, delim);
		}
		else if (typeof data === 'object' && !(keys && keys.length > 0)) {
			str += JSON.stringify(extractStringObject(data, keys, delim));
		}
		else {
			str += extractStringObject(data, keys, delim);
		}
	}
	catch(err) { console.error(err.stack); }

	return str;
}

// Extract object from JSON data
function extractStringObject(data, keys, delim='') {
	if (data === undefined || data === null) return '';
	if (keys === undefined || keys.length == 0) return data;

	let str = '';
	for (let i in keys) {
		let val = data;
		let key = keys[i];
		let keyList = key.split(' > ');

		for (let j in keyList) {

			if (key == '') {
				val = val;
			}
			else if (val[keyList[j]] === undefined) {
				val = '';
				break;
			}
			else {
				val = val[keyList[j]];
			}
		}

		if (val != '') {
			str += extractString(val, '', [], delim) + delim;
		}
	}

	// Remove last delimeter
	str = removeLastDelim(str, delim);
	return str;
}

// Extract list from JSON data
function extractList(data, paths, keys, to_string) {
	if (data === undefined || data === null) return [];
	if (!Array.isArray(paths)) paths = [paths];

	let result_all = [];

	for (let p in paths) {
		let result = [];
		let dataList = data;
		let path = paths[p];

		// Safely traverse down the JSON path
		if (path !== undefined && path.length > 0) {
			let pathList = path.split(' > ');

			for (let i in pathList) {
				let pathNode = pathList[i];

				if (dataList[pathNode] === undefined) {
					dataList = [];
					break;
				}

				dataList = dataList[pathNode];
			}
		}

		// Always convert to a data list
		if (!Array.isArray(dataList))
			dataList = [dataList];

		// Return data list if no specific key is specified
		if (keys === undefined || keys.length <= 0) {
			result = dataList;
		}
		else {
			// Parse specific data in datalist, by keys
			for (let i in dataList) {

				for (let j in keys) {
					let data_item = dataList[i];
					let keyPath = keys[j].split(' > ');

					try {
						for (let k in keyPath) {
							let key = keyPath[k];

							if (key == '') {
								data_item = data_item;
							}
							else if (data_item[key] === undefined) {
								data_item = undefined;
								break;
							}
							else {
								data_item = data_item[key];
							}
						}

						if (data_item !== undefined) {
							result.push(...extractList(data_item, '', []));
						}
					}
					catch(err) { console.error(err); }
				}
			}
		}

		result_all = result_all.concat(result);
	}

	// Convert all list items to string
	if (to_string) {
		for (let i in result_all)
			result_all[i] = extractString(result_all[i]);
	}
	return result_all;
}

// Load XML document
function loadXMLDoc(fileUrl, onReady, onError) {
	var xhttp;
	if (window.ActiveXObject)
		xhttp = new ActiveXObject("Msxml2.XMLHTTP");
	else
		xhttp = new XMLHttpRequest();
	xhttp.timeout = 5000;
	xhttp.open("GET", fileUrl, true);

	if (false || !!document.documentMode)
		try { xhttp.responseType = "msxml-document" } catch(err) {} // Helping IE11

	xhttp.onload = function (e) {
		if (xhttp.readyState === 4 && xhttp.status === 200)
			onReady(xhttp.responseXML);
		else
			onError(`File ${ fileUrl } not found.`);
	};

	xhttp.onerror = xhttp.ontimeout = function (e) {
		onError(`Repository is not responding. Please try again later.`);
	};

	xhttp.send("");
	return xhttp.responseXML;
}

// Convert camelCaseWord to a sentence (source: https://stackoverflow.com/a/7225450/8443192)
function camelToWords(text) {
	var result = text.replace('_', '').replace(/([A-Z])/g, " $1");
	return result.charAt(0).toUpperCase() + result.slice(1);
}

// Parse address to text
function parseAddress(json) {
	var deliveryPoint = json['deliveryPoint'];

	if (typeof deliveryPoint === 'string')
		deliveryPoint = deliveryPoint.split(',');

	return deliveryPoint[0] + ',<br>' +
		   deliveryPoint[1] + ',<br>' +
		   json['city'] + ', ' +
		   json['administrativeArea'] + ' ' +
		   json['postalCode'] + ', ' +
		   json['country'];
}

// Parse and format name
function parseName(json, format) {
	/**
	 * format:
	 *     %F = first name
	 *     %L = last name
	 *     %M = middle name
	 *     % with lowercase letter is initial 
	 */

	if (json === undefined)
		return '';

	try {
		var fname = json['givenName'] || (json['given_names'] ? json['given_names'].join(' ') : '') || ' ';
		var lname = json['surName'] || json['sur_name'] || ' ';
		var mname = '';

		if (Array.isArray(fname)) {
			fname = fname[0];
			mname = fname[1];
		}

		format = format.replace('%F', fname);
		format = format.replace('%f', fname[0]);
		format = format.replace('%L', lname);
		format = format.replace('%l', lname[0]);
		format = format.replace('%M', mname);
		format = format.replace('%m', mname[0]);
	}
	catch(err) { console.error(err); }
	return format;
}

// Turns text to HTML link
function activateLink(url, title) {
	if (url['_url']) {
		if (!title)
			title = url['__text'];
		url = url['_url'];
	}

	if (title === undefined) title = url;
	return `<a href='${ url }'>${ title }</a>`;
}

// Create a table row with specified cells.
function makeTableRow(cells, classes) {
	/**
	 * @cells    Table row cells    [[tag, classes, content], ...]
	 * @classes  Table row classes  "class1 class2 ..."
	 */

	let html = '';

	for (let i in cells) {
		let tag          = cells[i][0] || 'td';
		let cell_classes = cells[i][1] || '';
		let content      = cells[i][2];

		html += `<${ tag } class="cell ${ cell_classes }"> ${ content || '' } </${ tag }>\n`;
	}

	return `
		<tr class="row ${ classes }">
			${ html }
		</tr>`;
}

// Update package's main view
function updateView(title, body) {
	$('#detail #detail-title').html(title);
	$('#detail #detail-body').html(body);
}

// Load mathjax script dynamically
function loadMathJax() {
	let script = document.createElement('script');
	script.src = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML';
	script.setAttribute('id', 'MathJax-script');
	document.head.appendChild(script);
}

function removeLastDelim(str, delim, ending='') {
	let substr = str.slice(str.length - delim.length);
	if (substr == delim)
		str = str.slice(0, str.length - delim.length) + ending;

	return str;
}
