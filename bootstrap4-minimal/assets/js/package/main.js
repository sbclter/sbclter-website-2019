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
	loadXMLDoc(url, function(xml) {
		try {
			let json = new X2JS().xml2json(xml)['eml'];
			let title = json['dataset']['title'];

			console.log("Raw Data: ", json);

			// Load json data onto each page
			summary .parse(json);
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

			let subtitle = `<a href="${ repoUrl }" target="_blank">${ edi_logo }</a>`;

			// Load template onto actual HTML
			updateView(
				makeTableRow([
					['th', title   , 10,     'title'],
					['td', subtitle,  2, 'sub-title']
				]),
				template
			);

			// customize tables: take out first border top of every table
			$('#detail #detail-body table').each(function(index) {
				$(this).find('tr:first td, tr:first th').addClass('no-border-top');
			});

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
					str += extractStringHelper(data[i], keys, ', ');
				else
					str += extractStringHelper(data[i], keys, ', ') + delim;
			}
		}
		else if (data.__text !== undefined) {
			str += extractStringHelper(data.__text, keys, delim);
		}
		else {
			str += extractStringHelper(data, keys, delim);
		}
	}
	catch(err) { console.error(err.stack); }

	return str;
}

// Extract object from JSON data
function extractStringHelper(data, keys, delim='') {
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
	let str1 = str.slice(str.length - delim.length);
	if (str1 == delim) str = str.slice(0, str.length - delim.length);

	return str;
}

// Extract list from JSON data
function extractList(json, path, keys, to_string) {
	if (json === undefined || json === null) return [];

	let dataList = json;
	let result = [];

	// Safely traverse down the JSON path
	if (path !== undefined && path.length > 0) {
		let pathList = path.split(' > ');

		for (let i in pathList) {
			let pathNode = pathList[i];
			if (dataList[pathNode] === undefined)
				return [];
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
				let data = dataList[i];
				let keyPath = keys[j].split(' > ');

				try {
					for (let k in keyPath) {
						let key = keyPath[k];

						if (key == '') {
							data = data;
						}
						else if (data[key] === undefined) {
							data = undefined;
							break;
						}
						else {
							data = data[key];
						}
					}

					if (data !== undefined) {
						result.push(...extractList(data, '', []));
					}
				}
				catch(err) { console.error(err); }
			}
		}
	}

	// Convert all list items to string
	if (to_string) {
		for (let i in result)
			result[i] = extractString(result[i]);
	}
	return result;
}

// Load XML document
function loadXMLDoc(filename, onReady, onError) {
	var xhttp;
	if (window.ActiveXObject)
		xhttp = new ActiveXObject("Msxml2.XMLHTTP");
	else
		xhttp = new XMLHttpRequest();
	xhttp.open("GET", filename, true);

	if (false || !!document.documentMode)
		try { xhttp.responseType = "msxml-document" } catch(err) {} // Helping IE11

	xhttp.onload = function (e) {
		if (xhttp.readyState === 4 && xhttp.status === 200)
			onReady(xhttp.responseXML);
		else
			onError(`File ${ filename } not found.`);
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
		var fname = json['givenName'] || ' ';
		var lname = json['surName'] || ' ';
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
	if (title === undefined) title = url;
	return `<a href='${ url }'>${ title }</a>`;
}

// Create a table row with specified cells.
function makeTableRow(cells, classes) {
	/**
	 * @cells    Table row cells    [[tag, content, size (optional), classes (optional)], ...]
	 * @classes  Table row classes  "class1 class2 ..."
	 */

	let html = '';

	for (let i in cells) {
		let tag     = cells[i][0] || 'td';
		let content = cells[i][1];
		let size    = cells[i][2];
		let cell_classes = cells[i][3] || '';

		if (size) {
			size = `col-${ size }`;
		}

		html += `<${ tag } class="cell ${ size } ${ cell_classes }"> ${ content || '' } </${ tag }>`;
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
