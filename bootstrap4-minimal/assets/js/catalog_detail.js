var map;
var markers = [];
var bounds = new google.maps.LatLngBounds();

var url = new URL(location);
var package = url.searchParams.get('package');

if (package == null)
	document.location = "/data/catalog";

var packageUrl = `https://pasta.lternet.edu/package/metadata/eml/${ package.replace(/\./g, "/") }/newest`;
showDetail(packageUrl);


// ==============================================================================================================================


// Reset map bound on coverage tab focus
function onCoverageOpen() {
	// Hack to get fitBounds work correctly
	setTimeout(function() {
		map.fitBounds(bounds);
	}, 0);
	return true;
}

function onMeasureClick(e) {
	let nth = $(e.target).closest('tr').index() + 1;
	let measure = $(e.target).parent().parent().parent().parent().parent().find(`.measurement-section div:nth-child(${ nth })`);

	$('#attribute-modal .modal-body').html(measure.clone());
	$('#attribute-modal').modal();
}

function onMissingClick(e) {
	let nth = $(e.target).closest('tr').index() + 1;
	let missing = $(e.target).parent().parent().parent().parent().parent().find(`.missing-section div:nth-child(${ nth })`);

	$('#attribute-modal .modal-body').html(missing.clone());
	$('#attribute-modal').modal();
}

// ==============================================================================================================================


// Create popup window for xml links
function showDetail(url) {
	var template = $('#detail-template').clone();
	template.removeAttr('hidden');
	template.removeAttr('id');

	var loader = $('#loading-template').clone();
	loader.removeAttr('hidden');
	loader.removeAttr('id');

	$('#detail #detail-title').text("Grabbing Data...");
	$('#detail #detail-body').html(loader);

	loadXMLDoc(url, function(xml) {
		try {
			var json = new X2JS().xml2json(xml)['eml'];
			var title = json['dataset']['title'];
			console.log("Raw Data: ", json);

			let data = parseData(json);
			console.log("Parsed Data: ", data);

			initMap();
			makeSummary(template, data['summary']);
			makePeople(template, data['people']);
			makeCoverage(template, data['coverage']);
			makeMethods(template, data['method']);
			makeFiles(template, data['file']);

			$('#detail #detail-title').text(title);
			$('#detail #detail-body').html(template);

			// customize tables: take out first border top of every table
			$('#detail #detail-body table').each(function(index) {
				$(this).find('tr:first td, tr:first th').addClass('no-border-top');
			});

			// Added MathJax script
			var script = document.createElement('script');
			script.src = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML';
			script.setAttribute('id', 'MathJax-script');
			document.head.appendChild(script);
		}
		catch (err) {
			$('#detail #detail-title').text("Error");
			$('#detail #detail-body').html("Sorry, an error has occured! <br> " + err);
		}
	}, function(err) {
		$('#detail #detail-title').text("Error");
		$('#detail #detail-body').html(err);
	});
}


function parseData(json) {
	let data = {
		summary: {
			general: {},
			citation: '',
			keywords: [],
			rights: []
		},
		people: {
			publisher: {},
			owners: [],
			contacts: {},
		},
		coverage: {
			temporal: {},
			geographic: [],
			taxonomic: {}
		},
		method: {
			protocols: [],
		},
		file: {
			datatables: []
		},
	};

	// ============================================ Summary Tab Data ==============================================

	// Parse general
	data['summary']['general'] = {
		name:             extractString(json, 'dataset > shortName'),
		id:               extractString(json, '_packageId'),
		alternate_id:     extractList(json, 'dataset > alternateIdentifier'),
		abstract:         extractList(json, 'dataset > abstract', ['para', 'section > para']),
		publication_date: extractString(json, 'dataset > pubDate'),
		language:         extractString(json, 'dataset > language'),
		time_range: {
			start: extractString(json, 'dataset > coverage > temporalCoverage > rangeOfDates > beginDate > calendarDate'),
			end:   extractString(json, 'dataset > coverage > temporalCoverage > rangeOfDates > endDate > calendarDate')
		}
	};

	// Parse citation
	let citation = '';
	let creators = json['dataset']['creator'];
	for (let i in creators)
		citation += parseName(creators[i]['individualName'], '%L, %f. ');

	citation += extractString(json, 'dataset > pubDate').split('-')[0]      + '. ' +
				extractString(json, 'dataset > title')                      + '. ' +
				extractString(json, 'dataset > publisher > organizationName') + '. ' +
				extractString(json, 'dataset > alternateIdentifier')        + '.';
	data['summary']['citation'] = citation;

	// Parse keywords
	let keywords = json['dataset']['keywordSet'];
	for (let i in keywords) {
		let key = extractString(keywords[i]['keywordThesaurus']);
		let val = extractList(keywords[i]['keyword']);
		data['summary']['keywords'].push([key, val]);
	}

	// Parse rights
	let rights = extractList(json, 'dataset > intellectualRights > para > itemizedlist > listitem', ['para']);

	if (rights.length == 0)
		rights = extractList(json, 'dataset > intellectualRights > para');

	data['summary']['rights'] = rights;


	// ============================================ People Tab Data ==============================================

	// Parse publishers
	let publishers = extractList(json, 'dataset > publisher');
	data['people']['publishers'] = parsePeopleData(publishers);

	// Parse owners
	let owners = extractList(json, 'dataset > creator');
	data['people']['owners'] = parsePeopleData(owners);

	// Parse contacts
	let contacts = extractList(json, 'dataset > contact');
	data['people']['contacts'] = parsePeopleData(contacts);

	// Parse owners
	let associated = extractList(json, 'dataset > associatedParty');
	data['people']['associated'] = parsePeopleData(associated);

	// ============================================ Coverage Tab Data ==============================================

	// Parse timporal coverage
	data['coverage']['temporal'] = {
		start: extractString(json, 'dataset > coverage > temporalCoverage > rangeOfDates > beginDate > calendarDate'),
		end:   extractString(json, 'dataset > coverage > temporalCoverage > rangeOfDates > endDate > calendarDate')
	};

	// Parse geographical coverage
	let points = extractList(json, 'dataset > coverage > geographicCoverage');

	for (let i in points) {
		let title = extractString(points[i], 'geographicDescription');

		let data_entry = [];
		data_entry.push(title);

		let north = parseFloat(extractString(points[i], 'boundingCoordinates > northBoundingCoordinate'));
		data_entry.push(north);

		let south = parseFloat(extractString(points[i], 'boundingCoordinates > southBoundingCoordinate'));
		data_entry.push(south);

		let east = parseFloat(extractString(points[i], 'boundingCoordinates > eastBoundingCoordinate'));
		data_entry.push(east);

		let west = parseFloat(extractString(points[i], 'boundingCoordinates > westBoundingCoordinate'));
		data_entry.push(west);

		data['coverage']['geographic'].push(data_entry);
	}

	// Parse taxonomic coverage
	let tax_data = extractList(json, 'dataset > coverage > taxonomicCoverage > taxonomicClassification');

	for (let i in tax_data) {
		tax_data[i]['commonName'] = extractString(tax_data[i], 'commonName');
		tax_data[i]['taxonRankValue'] = extractString(tax_data[i], 'taxonRankValue');
	}
	data['coverage']['taxonomic'] = tax_data;

	// ============================================ Method Tab Data ==============================================

	let methodList = extractList(json, 'dataset > methods > methodStep');
	let methodDataList = [];

	for (let i in methodList) {
		let methodData = {
			descriptions: [],
			protocols: []
		};

		let descriptions = extractList(methodList[i], 'description > section');
		if (descriptions.length == 0)
			descriptions = extractList(methodList[i], 'description');

		let protocols = extractList(methodList[i], 'protocol');

		for (let j in descriptions) {
			methodData['descriptions'].push({
				title: extractString(descriptions[j], 'title'),
				paragraph: extractList(descriptions[j], 'para')
			});
		}

		// fill method's protocols
		for (let j in protocols) {
			methodData['protocols'].push({
				title: extractString(protocols[j], 'title'),
				name: extractString(protocols[j], 'creator > individualName > surName'),
				url: extractString(protocols[j], 'distribution > online > url')
			});
		}

		methodDataList.push(methodData);
	}
	data['method']['protocols'] = methodDataList;

	// ============================================ File Tab Data ==============================================



	let tables = extractList(json, 'dataset > dataTable');

	for (i in tables) {
		let attributes = extractList(tables[i], 'attributeList > attribute');
		let attribute_data = [];

		for (let j in attributes) {
			let attribute = attributes[j];
			let measurement = attributes[j]['measurementScale'];
			let measure_type = Object.keys(measurement)[0];
			let measure_data = {
				type: measure_type,
				data: []
			};

			switch(measure_type) {
				case 'nominal':
					let measure_domain1 = Object.keys(measurement[measure_type])[0];
					let measure_domain2 = Object.keys(measurement[measure_type][measure_domain1])[0];
					let measure_def_key = Object.keys(measurement[measure_type][measure_domain1][measure_domain2])[0];

					measure_data['domain'] = measure_domain2;
					measure_data['data'] = extractList(measurement[measure_type][measure_domain1][measure_domain2][measure_def_key]);
					break;

				case 'dateTime':
					let datetime_data = extractList(measurement[measure_type]);

					for (let k in datetime_data) {
						measure_data['data'].push({
							format: datetime_data[k]['formatString'],
							precision: datetime_data[k]['dateTimePrecision'],
							domain: datetime_data[k]['dateTimeDomain']
						});
					}
					break;

				case 'ratio':
				case 'interval':
					let ratio_data = extractList(measurement[measure_type]);

					for (let k in ratio_data) {
						let unit = ratio_data[k]['unit'];
						unit = unit[Object.keys(unit)[0]];

						let min = '';
						let max = '';
						let type = '';
						let domain = ratio_data[k]['numericDomain'];

						if (domain) {
							if (domain['bounds']) {
								min = domain['bounds']['minimum'];
								max = domain['bounds']['maximum'];
							}
							type = domain['numberType'];
						}

						measure_data['data'].push({
							min: min || '',
							max: max || '',
							precision: ratio_data[k]['precision'] || '',
							unit: unit || '',
							type: type || ''
						});
					}
					break;
			}

			attribute_data.push({
				definition: extractString(attribute, 'attributeDefinition'),
				unit:       extractString(attribute, 'storageType'),
				label:      extractString(attribute, 'attributeLabel'),
				name:       extractString(attribute, 'attributeName'),
				missing_value: {
					code:        extractString(attribute, 'missingValueCode > code'),
					description: extractString(attribute, 'missingValueCode > codeExplanation')
				},
				measurement: measure_data
			});
		}

		data['file']['datatables'].push({
			name:        extractString(tables[i], 'entityName'),
			description: extractString(tables[i], 'entityDescription'),
			attributes:  attribute_data
		});
	}

	return data;
}


function makeSummary(template, data) {
	let element = template.find('#content-class-summary');
	let content = null;

	// fill shortname field
	content = data['general']['name'];
	element.find('#field-shortname').html(content);

	// fill id field
	content = data['general']['id']
	element.find('#field-id').text(content);

	// fill alternate id field
	content = data['general']['alternate_id'].join('<br>');
	element.find('#field-id-alt').html(content);

	// fill abstract field
	content = data['general']['abstract'].join('<br><br>');
	element.find('#field-abstract').html(content);

	// fill publication date field
	content = data['general']['publication_date'];
	element.find('#field-pubdate').html(content);

	// fill language field
	content = data['general']['language'];
	element.find('#field-language').html(content);

	// fill time period field
	content = data['general']['time_range']['start'] + ' to ' + data['general']['time_range']['end'];
	element.find('#field-daterange').html(content);

	// fill citation field
	content = data['citation'];
	element.find('#field-citation').html(content);

	// fill keywords field
	for (let i in data['keywords']) {
		let key = data['keywords'][i][0];
		let val = data['keywords'][i][1].join(', ');

		let row;
		if (key == "" || key == "none")
			row = makeTableRow([['td', val, 12]]);
		else
			row = makeTableRow([['th', key, 4], [val, 8]]);

		element.find('#field-keywords').append(row);
	}

	// fill rights field
	for (let i in data['rights']) {
		element.find('#field-usage-rights').append(`<li> ${ data['rights'][i] } </li>`);
	}
}

// Make people's page
function makePeople(template, data) {
	let element = template.find('#content-class-people');
	let contents = null;

	// fill publishers field
	contents = makePeopleTables(data['publishers']);
	element.find('#field-publishers').append(contents);

	// fill owners field
	contents = makePeopleTables(data['owners']);
	element.find('#field-owners').append(contents);

	// fill contacts field
	contents = makePeopleTables(data['contacts']);
	element.find('#field-contacts').append(contents);

	// fill associated parties field
	contents = makePeopleTables(data['associated']);
	element.find('#field-associated').append(contents);
}

// Make coverage's page
function makeCoverage(template, data) {
	let element = template.find('#content-class-coverage');
	let content = null;

	// Fill temporal converage data
	content = data['temporal']['start'] + ' to ' + data['temporal']['end'];
	element.find('#field-temporal').text(content);

	// Move map from template to actual popup window
	$("#map").detach().appendTo(template.find('#field-map'));
	plotMarkers(element, data);

	// Fill taxonomic range data
	let row = makeTableRow([
		['th', 'Kingdom'],
		['th', 'Phylum' ],
		['th', 'Class'  ],
		['th', 'Order'  ],
		['th', 'Family' ],
		['th', 'Genus'  ],
		['th', 'Species']
	]);
	row = $(row)
	row.attr('id', 'tax-head');
	row.find('th').attr('class', 'cell tax-cell');
	element.find('#field-taxonomic').append(row);

	fillTaxonomicRow(element.find('#field-taxonomic #tax-head').parent(), data['taxonomic'], null, 0);

	if (element.find('#field-taxonomic').children().length > 1)
		element.find('#section-taxonomic').removeAttr('hidden');
}

// Make method's page
function makeMethods(template, data) {
	let element = template.find('#content-class-methods');
	let methodList = data['protocols'];

	// fill method description table
	for (let i in methodList) {
		let descriptions = methodList[i]['descriptions'];
		let protocols = methodList[i]['protocols'];
		let description_html = [];
		let protocol_html = [];

		// fill method's description
		for (let j in descriptions) {
			let title = descriptions[j]['title'];
			let paraList = descriptions[j]['paragraph'];
			let paragraphs_html = [];

			// fill method's description's paragraphs
			for (let k in paraList) {
				if (paraList[k]['ulink']) {
					paragraphs_html.push(
						extractString(paraList[k]['__text']) + ' ' +
						activateLink(paraList[k]['ulink']['_url'], paraList[k]['ulink'])
					);
				}
				else {
					paragraphs_html.push(paraList[k]);
				}
			}

			description_html.push(`
				<div style="font-weight: normal">
					<strong>${ title }</strong>
					<br>
					${ paragraphs_html.join('<br><br>') }
					<br><br>
				</div>
			`);
		}

		// fill method's protocols
		for (let j in protocols) {
			let protocol = protocols[j];
			protocol_html.push(`
				<table class="table">
					<tbody>
						${ makeTableRow([['th', 'Protocol:',         2], ['td', protocol['title'],             10]]) }
						${ makeTableRow([['th', 'Author:',           2], ['td', protocol['name'],              10]]) }
						${ makeTableRow([['th', 'Available Online:', 2], ['td', activateLink(protocol['url']), 10]]) }
					</tbody>
				</table>
			`);
		}

		let html = `
			<div class="section-title"> Protocol </div>
			<div class="ml-3">
				${ description_html.join('<hr>') }
			</div>
			<br>
			${ protocol_html.join('<hr>') }
		`;
		element.append(html);
	}
}

// Make file's page
function makeFiles(template, data) {
	var element = template.find('#content-class-files');

	// Fill datatable data
	let tables = data['datatables'];
	let html = '';

	for (let i in tables) {
		let tableData = makeFilesTableData(tables[i]);
		html += `
			<div class="section-title" data-toggle="collapse" href="#datatable${ i }" aria-expanded="false" aria-controls="datatable${ i }">
				Data Table ${ i + 1 }: ${ tables[i]['name'] }
			</div>
			<div class="collapse" id="datatable${ i }">
				<div class="ml-3"> ${ tables[i]['description'] } </div>
				${ tableData }
			</div>
			<br/>
		`;
	}

	element.append(html);
}

function makeFilesTableData(table) {
	let attr_rows_html = '';
	let	attr_measure_html = '';
	let	attr_missing_html = '';

	let attributes = table['attributes'];

	for (let i in attributes) {
		let attribute = attributes[i];
		let missingCode = attribute['missing_value'];
		let measurement = attribute['measurement'];
		let measure_type = measurement['type'];
		let measure_content = '';

		attr_rows_html += makeTableRow([
			[
				'td',
				`
					<strong>
						${ attribute['label'] }
					</strong><br>
					${ attribute['name'] }
				`,
				3
			],
			['td', attribute['definition'], 5],
			['td', attribute['unit'], 1],
			[
				'td',
				`
					Measurement Type:
					<span class="measure-btn" onclick="onMeasureClick(event)">
						${ measure_type }
					</span> <br/>
					Missing Value Code:
					<span class="missing-btn" onclick="onMissingClick(event)">
						${ missingCode['code'] }
					</span>
				`,
				3
			]
		]);

		switch(measure_type) {
			case 'nominal': measure_content = makeMeasureNominal(measurement, measure_type); break;
			case 'dateTime': measure_content = makeMeasureDateTime(measurement, measure_type); break;
			case 'ratio': measure_content = makeMeasureRatio(measurement, measure_type); break;
			case 'interval': measure_content = makeMeasureRatio(measurement, measure_type); break;
		}

		attr_measure_html += `
			<div>
				<strong>${ measure_type }: </strong>
				${ measure_content }
			</div>
		`;

		attr_missing_html += `
			<div>
				<strong>${ missingCode['code'] }: </strong>
				<br/>
				${ missingCode['description'] }
			</div>
		`;
	}

	let title_row = makeTableRow([
		['th', 'Attribute', 3],
		['th', 'Definition', 5],
		['th', 'Unit', 1],
		['th', 'Others', 3]
	], 'title-row');

	return `
		<div>
			<table class="table">
				<thead>
					${ title_row }
				</thead>
				<tbody>
					${ attr_rows_html }
				</tbody>
			</table>
			<div class="measurement-section hidden">
				${ attr_measure_html }
			</div>
			<div class="missing-section hidden">
				${ attr_missing_html }
			</div>
		</div>
	`;
}

function makeMeasureNominal(measurement, measure_type) {
	let domain = measurement['domain'];
	let rows = '';

	let data = measurement['data'];
	if (!Array.isArray(data)) data = [data];

	if (domain == 'enumeratedDomain') {

		for (let j in data) {
			rows += makeTableRow([
				['td', data[j]['code'] || ''      , 4],
				['td', data[j]['definition'] || '', 4],
				['td', data[j]['source'] || ''    , 4],
			]);
		}

		let title_row = makeTableRow([
			['th', 'Code'      , 4],
			['th', 'Definition', 4],
			['th', 'Source'    , 4],
		], 'title-row');

		return `
			<table class="table">
				<thead>
					${ title_row }
				</thead>
				<tbody>
					${ rows }
				</tbody>
			</table>
		`;
	}
	else {
		for (let j in data) {
			rows += `${data[j]}, `;
		}

		return rows.substring(0, rows.length - 2);
	}
}

function makeMeasureDateTime(measurement, measure_type) {
	let data = measurement['data'];

	let rows = '';

	for (let j in data) {
		rows += makeTableRow([
			['td', data[j]['format'] || ''   , 4],
			['td', data[j]['precision'] || '', 4],
			['td', data[j]['domain'] || ''   , 4],
		]);
	}

	let title_row = makeTableRow([
		['th', 'Format'   , 4],
		['th', 'Precision', 4],
		['th', 'Domain'   , 4],
	], 'title-row');

	return `
		<table class="table">
			<thead>
				${ title_row }
			</thead>
			<tbody>
				${ rows }
			</tbody>
		</table>
	`;
}

function makeMeasureRatio(measurement, measure_type) {
	let data = measurement['data'];

	let rows = '';

	for (let j in data) {
		rows += makeTableRow([
			['td', data[j]['unit'] || ''     , 3],
			['td', data[j]['precision'] || '', 3],
			['td', data[j]['type'] || ''     , 2],
			['td', data[j]['min'] || ''      , 2],
			['td', data[j]['max'] || ''      , 2],
		]);
	}

	let title_row = makeTableRow([
		['th', 'Unit'     , 3],
		['th', 'Precision', 3],
		['th', 'Type'     , 2],
		['th', 'Min'      , 2],
		['th', 'Max'      , 2],
	], 'title-row');

	return `
		<table class="table">
			<thead>
				${ title_row }
			</thead>
			<tbody>
				${ rows }
			</tbody>
		</table>
	`;
}

// ----------------------- Helper Functions! -------------------------

// Extract object, array, or text from JSON data
function extractString(data, path, keys, delim) {
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
	catch(err) { console.error(err); }

	return str;
}

// Extract object from JSON data
function extractStringHelper(data, keys, delim) {
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
			str += extractString(val, [], delim) + delim;
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
	/*
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

// Make HTML tables from list of people information
function makePeopleTables(people) {
	let contents = '';

	for (let i in people) {
		let person = people[i];
		let rows = '';

		for (let j in person) {

			// parse item information
			let key = person[j][0];
			let value = person[j][1];

			// activate any link
			if (typeof value === 'string') {
				if (value.startsWith('http')) value = activateLink(value);
				if (value.includes('@'))      value = activateLink(`mailto: ${ value }`, value);
			}

			rows += makeTableRow([
				['th', key  ],
				['td', value]
			]);
		}

		contents += `
			<table class="table floatbox people-table">
				<tbody>
				${ rows }
				</tbody>
			</table>`;
	}

	return contents;
}

// Create a table row with specified cells.
// @cells: [ [ tag, content, size (optional) ], ... ]
function makeTableRow(cells, classes) {
	let html = '';

	for (let i in cells) {
		let tag     = cells[i][0] || 'td';
		let content = cells[i][1];
		let size    = cells[i][2];

		if (size) {
			size = `col-${ size }`;
		}

		html += `<${ tag } class="cell ${ size }"> ${ content || '' } </${ tag }>`;
	}

	return `
		<tr class="row ${ classes }">
			${ html }
		</tr>`;
}

// Plot markers for coverage tab
function plotMarkers(element, data) {
	const lat_n = 1;
	const lat_s = 2;
	const lng_e = 3;
	const lng_w = 4;

	let infowindow = new google.maps.InfoWindow();
	let map_data = data['geographic'];

	for (let i in map_data) {
		const m_data = map_data[i];

		// Just a point so draw a marker
		if (m_data[lat_n] == m_data[lat_s] && m_data[lng_e] == m_data[lng_w]){

			const marker = new google.maps.Marker({
				position: {lat: m_data[lat_n], lng: m_data[lng_e]},
				map: map,
				title: m_data[0]
			});

			google.maps.event.addListener(marker, 'click', function() {
				infowindow.setContent(this.title);  // Title
				infowindow.open(map, marker);
			});

			var row = '<tr class="row">';
			row += `<td class="cell col-9"> ${ m_data[0] } </td>`;
			row += `<td class="cell col-3 text-right"> (${ m_data[lat_n] + ", " + m_data[lng_e] }) </td>`;
			row += '</tr>';
			element.find('#field-geographic').append(row);
		}
		else {
			var rectangle = new google.maps.Rectangle({
				strokeColor: '#FF0000',
				strokeOpacity: 0.8,
				strokeWeight: 2,
				fillColor: '#FF0000',
				fillOpacity: 0.35,
				map: map,
				title: m_data[0],
				bounds: {
					north: m_data[lat_n],
					south: m_data[lat_s],
					east: m_data[lng_e],
					west: m_data[lng_w]
				}
			});

			google.maps.event.addListener(rectangle, 'click', function() {
				infowindow.setContent(this.title);  // Title
				infowindow.setPosition({lat: m_data[lat_n], lng: m_data[lng_e]});
				infowindow.open(map);
			});

			var row = '<tr class="row">';
			row += `<td class="cell col-10"> ${ m_data[0] } </td>`;
			row += `<td class="cell col-2"> ${ m_data[lat_n] + ", " + m_data[lng_e] } </td>`;
			row += '</tr>';
			element.find('#field-geographic').append(row);
		}

		bounds.extend(new google.maps.LatLng(m_data[lat_s], m_data[lng_w]));
		bounds.extend(new google.maps.LatLng(m_data[lat_n], m_data[lng_e]));
	}

	map.fitBounds(bounds);
}

// Gets called by Google Maps API to set up map (one map for all popup windows)
function initMap() {
	map = new google.maps.Map(document.getElementById("map"), {
		center:new google.maps.LatLng(34.3, - 120.000),
		zoom: 9,
		maxZoom: 12,
		mapTypeId: google.maps.MapTypeId.TERRAIN
	});
}

// Fill taxonomic rows for coverage
function fillTaxonomicRow(table, data, row, column) {
	if (!data) return;
	if (!Array.isArray(data)) data = [data];

	let first_row = row;

	for (let i in data) {
		let text = data[i]['taxonRankValue'];

		if (data[i]['commonName'])
			text += `<br>(${ data[i]['commonName'] })`;

		// Create new row if 1) new kingdom, or 2) more than 1 data for each column
		if (i == 0 && row == null || i > 0) {
			row = makeTableRow([[], [], [], [], [], [], []]);
			row = $(row);
			row.find('td').attr('class', 'cell tax-cell');

			// Append row at end of table if it's new kingdom
			if (column == 0) {
				table.append(row);
				first_row = row;
			}
			else {
				row.insertAfter(first_row);
			}

			// Add spacing when creating new kingdom
			if (column == 0) {
				let space_row = makeTableRow([[], [], [], [], [], [], []]);
				space_row = $(space_row);
				space_row.insertBefore(row);
			}
		}

		row.children().eq(column).addClass('colored');
		row.children().eq(column).html(text);
		fillTaxonomicRow(table, data[i]['taxonomicClassification'], row, column + 1);
	}
}


function parsePeopleData(people) {
	let result = [];

	for (let i in people) {
		let person = people[i];
		let row = [];

		for (let key in person) {
			let value = person[key];

			if (typeof value === 'object') {
				if      (key === 'address')        value = parseAddress(value);
				else if (key === 'individualName') value = parseName(value, '%F %L');
				else if (key === 'phone')          value = extractString(value, '', [], '<br/>');
				else                               value = extractString(value, '', [], ', ');
			}

			key = camelToWords(key);
			switch (key) {
				case 'Organization Name':       key = 'Organization'; break;
				case 'Individual Name':         key = 'Individual'; break;
				case 'Electronic Mail Address': key = 'Email'; break;
				case '_id':                     key = 'ID'; break;
				case 'Online Url':              key = 'Website'; break;
				case 'Position Name':           key = 'Position'; break;
			}

			row.push([key, value]);
		}

		result.push(row);
	}

	return result;
}