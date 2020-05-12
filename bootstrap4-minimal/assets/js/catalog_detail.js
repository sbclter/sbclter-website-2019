var map;
var markers = [];
var bounds = new google.maps.LatLngBounds();

var url = new URL(location);
var package = url.searchParams.get('package');

if (package == null)
	document.location = "/data/catalog";

var packageUrl = `https://pasta.lternet.edu/package/metadata/eml/${ package.replace(/\./g, "/") }/newest`;
showDetail(packageUrl);

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
			var data = new X2JS().xml2json(xml);
			var title = data['eml']['dataset']['title'];
			console.log(data);

			initMap();
			makeSummary(template, data);
			makePeople(template, data);
			makeCoverage(template, data);
			makeMethods(template, data);
			makeFiles(template, data);

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

// Make coverage's page
function makeCoverage(template, data) {
	var element = template.find('#content-class-coverage');

	// Fill temporal converage data
	try {
		var dateText = extractData(data['eml']['dataset']['coverage']['temporalCoverage']['rangeOfDates'], ' to ', ['beginDate/calendarDate', 'endDate/calendarDate']);
		element.find('#field-temporal').text(dateText);
	} catch(err) { console.error(err); }

	// Move map from template to actual popup window
	try {
		var mapElement = template.find('#field-map');
		$("#map").detach().appendTo(mapElement);
		plotMarkers(element, data);
	} catch(err) { console.error(err); }

	// Fill taxonomic range data
	try {
		$(`<tr id="tax-head" class="row">\
			 <th class="cell tax-cell"> Kingdom </th>\
			 <th class="cell tax-cell"> Phylum </th>\
			 <th class="cell tax-cell"> Class </th>\
			 <th class="cell tax-cell"> Order </th>\
			 <th class="cell tax-cell"> Family </th>\
			 <th class="cell tax-cell"> Genus </th>\
			 <th class="cell tax-cell"> Species </th>\
		   </tr>`).appendTo(element.find('#field-taxonomic'));
		fillTaxonomicRow(data['eml']['dataset']['coverage']['taxonomicCoverage']['taxonomicClassification'], element.find('#field-taxonomic #tax-head'), 0);
		element.find('#section-taxonomic').removeAttr('hidden');
	} catch(err) { console.error(err); }

}

// Make people's page
function makePeople(template, data) {
	var element = template.find('#content-class-people');

	// fill publishers field
	try {
		var publisher = data['eml']['dataset']['publisher'];
		var row = '<tr class="row">';

		for(var key in publisher) {
			row += `<th class="cell col-2"> ${ camelToWords(key) } </th>`;

			if (key == 'onlineUrl')
				row += `<td class="cell col-10"> ${ activateLink(publisher[key]) } </td>`;
			else if (key == 'address')
				row += `<td class="cell col-10"> ${ parseAddress(publisher[key]) } </td>`;
			else
				row += `<td class="cell col-10"> ${ publisher[key] } </td>`;
		}

		row += '</tr>';
		element.find('#field-publishers').append(row);

	} catch(err) { console.error(err); }

	// fill owners field
	try {
		var creators = data['eml']['dataset']['creator'];
		var contents = makePeopleTables(creators);
		element.find('#field-owners').append(contents);
	} catch(err) { console.error(err); }

	// fill contacts field
	try {
		var contacts = data['eml']['dataset']['contact'];
		var contents = makePeopleTables(contacts);
		element.find('#field-contacts').append(contents);
	} catch(err) { console.error(err); }

	// fill associated parties field
	try {
		var contacts = data['eml']['dataset']['associatedParty'];
		var contents = makePeopleTables(contacts);
		element.find('#field-associated').append(contents);
	} catch(err) { console.error(err); }

}

function makeSummary(template, data) {
	var element = template.find('#content-class-summary');

	// fill shortname field
	try {
		var text = extractData(data['eml']['dataset']['shortName']);
		element.find('#field-shortname').html(text);
	} catch(err) { console.error(err); }

	// fill id field
	try {
		var text = extractData(data['eml']['_packageId']);
		element.find('#field-id').text(text);
	} catch(err) { console.error(err); }

	// fill alternate id field
	try {
		var text = extractData(data['eml']['dataset']['alternateIdentifier'], '<br>');
		element.find('#field-id-alt').html(text);
	} catch(err) { console.error(err); }

	// fill abstract paragraph field
	try {
		var text = extractData(data['eml']['dataset']['abstract']['para'], '<br><br>', ['#text']);
		element.find('#field-abstract').html(text);
	} catch(err) { console.error(err); }

	// fill publication date field
	try {
		var text = extractData(data['eml']['dataset']['pubDate']);
		element.find('#field-pubdate').html(text);
	} catch(err) { console.error(err); }

	// fill language field
	try {
		var text = extractData(data['eml']['dataset']['language']);
		element.find('#field-language').html(text);
	} catch(err) { console.error(err); }

	// fill time period field
	try {
		var text = extractData(data['eml']['dataset']['coverage']['temporalCoverage']['rangeOfDates'], ' to ', ['beginDate/calendarDate', 'endDate/calendarDate']);
		element.find('#field-daterange').html(text);
	} catch(err) { console.error(err); }

	// fill pasta xml origin
	try {
		element.find('#field-pasta-xml').html(activateLink(packageUrl));
	} catch(err) { console.error(err); }

	// fill citation field
	try {
		var text = '';
		var creators = data['eml']['dataset']['creator'];
		for (var i = 0; i < creators.length; i++)
			if (creators[i]['individualName'] !== undefined)
				text += parseName(creators[i]['individualName'], '%L, %f. ');

		text += extractData(data['eml']['dataset']['pubDate']).split('-')[0] + '. ';
		text += extractData(data['eml']['dataset']['title']) + '. ';
		text += extractData(data['eml']['dataset']['publisher']['organizationName']) + '. ';
		text += extractData(data['eml']['dataset']['alternateIdentifier']) + '.';

		element.find('#field-citation').html(text);
	} catch(err) { console.error(err); }

	// fill keywords field
	try {
		var keywordList = data['eml']['dataset']['keywordSet'];
		for (var i = 0; i < keywordList.length; i++) {
			let keywordItem = keywordList[i];
			let key = extractData(keywordItem['keywordThesaurus']);
			let val = extractData(keywordItem['keyword'], ', ', ['#text']);
			let row;
			if (key == "") {
				row = '<tr class="row">' +
					`<td class="cell col-12"> ${ val } </td>` +
				'</tr>';
			}
			else {
				row = '<tr class="row">' +
					`<th class="cell col-4"> ${ key } </th>` +
					`<td class="cell col-8"> ${ val } </td>` +
				'</tr>';
			}
			element.find('#field-keywords').append(row);
		}
	} catch(err) { console.error(err); }

	// fill usage rights field
	try {
		var rights = extractData(data['eml']['dataset']['intellectualRights']['para'], '</li>\n<li>');
		if (rights === '[object Object]')
			rights = extractData(data['eml']['dataset']['intellectualRights']['para']['itemizedlist']['listitem'], '</li>\n<li>', ['para']);

		var text = '<li>' + rights + '</li>';
		element.find('#field-usage-rights').html(text);
	} catch(err) { console.error(err); }
}

function makeMethods(template, data) {
	let element = template.find('#content-class-methods');

	// fill method description table
	try {
		let methodList = data['eml']['dataset']['methods']['methodStep'];
		if (!Array.isArray(methodList)) methodList = [methodList];

		for (let i = 0; i < methodList.length; i++) {
			let descriptions = methodList[i]['description'];
			if (descriptions['section']) descriptions = descriptions['section'] 

			let protocols = methodList[i]['protocol'];
			if (!Array.isArray(descriptions)) descriptions = [descriptions];
			if (!Array.isArray(protocols)) protocols = [protocols];

			// fill method's description
			let html =
				`<div class="section-title"> Protocol </div>` +
				`	<div class="ml-3">`;
			for (let j = 0; j < descriptions.length; j++) {
				let description = descriptions[j];
				let title = extractData(description['title']);
				try {
					let paraList = description['para'];
					if (!Array.isArray(paraList)) paraList = [paraList];
					html += `<div style="font-weight: normal"><strong>${ title ? title + '' : '' }</strong><br/>`;

					for (let k = 0; k < paraList.length; k++) {
						if (typeof paraList[k] == "object") {
							html += extractData(paraList[k], ' ') + ' ';

							if (paraList[k] && paraList[k]['ulink'])
								html += activateLink(paraList[k]['ulink']['_url'], paraList[k]['ulink']);
						}
						else {
							html += paraList[k];
						}
						html += (k != paraList.length - 1) ? '<br><br>' : '';
					}

					html += `</div>`;
					html += (j != descriptions.length - 1) ? '<hr>' : '';
				} catch(err) { console.error(err); }
			}
			html += `</div> <br/>`;

			// fill method's protocols
			for (let j = 0; j < protocols.length; j++) {
				let protocol = protocols[j];
				try {
					html +=
						`<table class="table">` +
						`	<tr class="row"><th class="cell col-2">Protocol:</th> <td class="cell col-10">${ protocol['title'] }</td></tr>` +
						`	<tr class="row"><th class="cell col-2">Author:</th> <td class="cell col-10">${ protocol['creator']['individualName']['surName'] }</td></tr>` +
						`	<tr class="row"><th class="cell col-2">Available Online:</th> <td class="cell col-10">${ activateLink(protocol['distribution']['online']['url']) }</td></tr>` +
						`</table>`;
					html += (j != protocols.length - 1) ? '<hr>' : '<br>';
				} catch(err) { console.error(err); }
			}

			element.append(html);
		}

	} catch(err) { console.error(err); }

}

// Make file's page
function makeFiles(template, data) {
	var element = template.find('#content-class-files');

	// Fill datatable data
	try {
		let tableList = data['eml']['dataset']['dataTable'];
		if (!Array.isArray(tableList)) tableList = [tableList];

		let html = ``;
		for (let i = 0; i < tableList.length; i++) {
			let table = tableList[i];
			let tableData = makeFilesTableData(table);
			html += `
				<div class="section-title" data-toggle="collapse" href="#datatable${ i }" aria-expanded="false" aria-controls="datatable${ i }">
					Data Table ${i + 1}: ${ table['entityName'] }
				</div>
				<div class="collapse" id="datatable${ i }">
					<div class="ml-3"> ${ table['entityDescription'] } </div>
					${ tableData }
				</div>
				<br/>`;
		}

		element.append(html);
	} catch(err) { console.error(err); }
}

function makeFilesTableData(table) {
	let attr_rows_html = '';
	let	attr_measure_html = '';
	let	attr_missing_html = '';

	let attributes = table['attributeList']['attribute'];
	if (!Array.isArray(attributes)) attributes = [attributes];

	for (let i in attributes) {
		let attribute = attributes[i];
		let missingCode = attribute['missingValueCode'];
		let measurement = attribute['measurementScale'];
		let measure_type = Object.keys(measurement)[0];
		let measure_content = '';

		attr_rows_html += `
			<tr class="row">
				<td class="cell col-3">
					<strong>${ attribute['attributeLabel'] }</strong>
					<br/>
					${ attribute['attributeName'] }
				</td>
				<td class="cell col-5">${ attribute['attributeDefinition'] }</td>
				<td class="cell col-1">${ attribute['storageType'] }</td>
				<td class="cell col-3">
					Measurement Type: <span class="measure-btn" onclick="onMeasureClick(event)">${ measure_type }</span><br/>
					Missing Value Code: <span class="missing-btn" onclick="onMissingClick(event)">${ missingCode['code'] }</span>
				</td>
			</tr>
		`;

		switch(measure_type) {
			case 'nominal':
				measure_content = makeMeasureNominal(measurement, measure_type);
				break;

			case 'dateTime':
				measure_content = makeMeasureDateTime(measurement, measure_type);
				break;

			case 'ratio':
				measure_content = makeMeasureRatio(measurement, measure_type);
				break;

			case 'interval':
				measure_content = makeMeasureRatio(measurement, measure_type);
				break;
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
				${ missingCode['codeExplanation'] }
			</div>
		`;
	}

	return `
		<div>
			<table class="table">
				<thead>
					<tr class="row title-row">
						<th class="cell col-3">Attribute</th>
						<th class="cell col-5">Definition</th>
						<th class="cell col-1">Type</th>
						<th class="cell col-3">Others</th>
					</tr>
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
	let measure_domain1 = Object.keys(measurement[measure_type])[0];
	let measure_domain2 = Object.keys(measurement[measure_type][measure_domain1])[0];
	let measure_def_key = Object.keys(measurement[measure_type][measure_domain1][measure_domain2])[0];
	let rows = '';

	let data = measurement[measure_type][measure_domain1][measure_domain2][measure_def_key];
	if (!Array.isArray(data)) data = [data];

	if (measure_domain2 == 'enumeratedDomain') {

		for (let j in data) {
			rows += `
				<tr class="row">
					<td class="col-4">${ data[j]['code'] || '' }</td>
					<td class="col-4">${ data[j]['definition'] || '' }</td>
					<td class="col-4">${ data[j]['source'] || '' }</td>
				</tr>
			`;
		}

		return `
			<table class="table">
				<thead>
					<tr class="row title-row">
						<th class="col-4">Code</th>
						<th class="col-4">Definition</th>
						<th class="col-4">Source</th>
					</tr>
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
	let data = measurement[measure_type];
	if (!Array.isArray(data)) data = [data];

	let rows = '';

	for (let j in data) {
		rows += `
			<tr class="row">
				<td class="col-4">${ data[j]['formatString'] || '' }</td>
				<td class="col-4">${ data[j]['dateTimePrecision'] || '' }</td>
				<td class="col-4">${ data[j]['dateTimeDomain'] || '' }</td>
			</tr>
		`;
	}

	return `
		<table class="table">
			<thead>
				<tr class="row title-row">
					<th class="col-4">Format</th>
					<th class="col-4">Precision</th>
					<th class="col-4">Domain</th>
				</tr>
			</thead>
			<tbody>
				${ rows }
			</tbody>
		</table>
	`;
}

function makeMeasureRatio(measurement, measure_type) {
	let data = measurement[measure_type];
	if (!Array.isArray(data)) data = [data];

	let rows = '';

	for (let j in data) {
		let unit = data[j]['unit'];
		unit = unit[Object.keys(unit)[0]];

		let min = '';
		let max = '';
		let type = '';
		let domain = data[j]['numericDomain'];

		if (domain) {
			if (domain['bounds']) {
				min = domain['bounds']['minimum'];
				max = domain['bounds']['maximum'];
			}
			type = domain['numberType'];
		}

		rows += `
			<tr class="row">
				<td class="col-3">${ unit || '' }</td>
				<td class="col-3">${ data[j]['precision'] || '' }</td>
				<td class="col-2">${ type || '' }</td>
				<td class="col-2">${ min || '' }</td>
				<td class="col-2">${ max || '' }</td>
			</tr>
		`;
	}


	return `
		<table class="table">
			<thead>
				<tr class="row title-row">
					<th class="col-3">Unit</th>
					<th class="col-3">Precision</th>
					<th class="col-2">Type</th>
					<th class="col-2">Min</th>
					<th class="col-2">Max</th>
				</tr>
			</thead>
			<tbody>
				${ rows }
			</tbody>
		</table>
	`;
}

// ----------------------- Helper Functions! -------------------------

// Extract object, array, or text from JSON data
function extractData(data, delim, keys) {
	if (data === undefined || data === null) return '';

	var str = '';
	if (Array.isArray(data))
		for (var i = 0; i < data.length; i++) {
			if (i >= data.length - 1) delim = '';
			str += extractDataObject(data[i], ', ', keys) + delim;
		}

	else if (typeof data == "object")
		str += extractDataObject(data, delim, keys);

	else
		str = data;

	return str;
}

// Extract object from JSON data
function extractDataObject(data, delim, keys) {
	if (data === undefined || data === null) return '';
	if (keys === undefined) return data;

	var str = '';
	for (var i = 0; i < keys.length; i++) {
		var val = data;

		// replace path '/' with actual dom
		var keyPath = keys[i];
		if (keyPath !== undefined) {
			var keyList = keyPath.split('/');
			for (var j = 0; j < keyList.length; j++) {
				if (val[keyList[j]] === undefined)
					break;
				val = val[keyList[j]];
			}
		}

		if (i >= keys.length - 1) delim = '';
		str += val + delim;
	}

	return str;
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
	var fname = json['givenName'];
	var lname = json['surName'];
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
	return format;
}

// Turns text to HTML link
function activateLink(url, title) {
	if (title === undefined) title = url;
	return `<a href='${ url }'>${ title }</a>`;
}

// Make HTML tables from list of people information
function makePeopleTables(data) {
	if (!data) return null;
	if (!Array.isArray(data)) data = [data];
	var contents = '';

	for (var i = 0; i < data.length; i++) {
		var item = data[i];
		contents += '<table class="table floatbox people-table"><tbody>';

		// fill information for each item
		for(var key in item) {
			var row = `<tr>` +
					  `<th class="cell"> ${ camelToWords(key) } </th>`;

			// parse item information
			var value = item[key];
			if (typeof value === 'object') {
				if      (key === 'address')        value = parseAddress(value);
				else if (key === 'individualName') value = parseName(value, '%F %L');
				else if (key === 'phone')          value = extractData(value, '<br/>');
				else                               value = extractData(value, ', ');
			}

			// activate any link
			if (typeof value === 'string') {
				if (value.startsWith('http')) value = activateLink(value);
				if (value.includes('@'))      value = activateLink(`mailto: ${ value }`, value);
			}

			row += `<td class="cell"> ${ value } </td> </tr>`;
			contents += row;
		}

		contents += '</tbody></table>';
	}

	return contents;
}

// Plot markers for coverage tab
function plotMarkers(element, data) {
	var points = data['eml']['dataset']['coverage']['geographicCoverage'];
	if (!Array.isArray(points))
		points = [points];

	var infowindow = new google.maps.InfoWindow();
	var map_data = [];
	const lat_n = 1;
	const lat_s = 2;
	const lng_e = 3;
	const lng_w = 4;

	for (var i = 0; i < points.length; i++) {
		var data_entry = [];
		var title = points[i]['geographicDescription'];
		data_entry.push(title);

		var north = parseFloat(points[i]['boundingCoordinates']['northBoundingCoordinate']);
		data_entry.push(north);

		var south = parseFloat(points[i]['boundingCoordinates']['southBoundingCoordinate']);
		data_entry.push(south);

		var east = parseFloat(points[i]['boundingCoordinates']['eastBoundingCoordinate']);
		data_entry.push(east);

		var west = parseFloat(points[i]['boundingCoordinates']['westBoundingCoordinate']);
		data_entry.push(west);

		map_data.push(data_entry);
		bounds.extend(new google.maps.LatLng(south, west));
		bounds.extend(new google.maps.LatLng(north, east));
	}

	map.fitBounds(bounds);

	for (var i = 0; i < map_data.length; i++) {
		// Just a point so draw a marker
		const m_data = map_data[i];
		if(m_data[lat_n] == m_data[lat_s] && m_data[lng_e] == m_data[lng_w]){
			const marker = new google.maps.Marker({
				position: {lat: m_data[lat_n], lng: m_data[lng_e]},
				map: map,
				title: m_data[0]
			});
			google.maps.event.addListener(marker, 'click', function() {
				infowindow.setContent(this.title);  // Title
				infowindow.open(map, marker);
			});

			//markers.push(marker);

			var row = '<tr class="row">';
			row += `<td class="cell col-9"> ${ m_data[0] } </td>`;
			row += `<td class="cell col-3 text-right"> (${ m_data[lat_n] + ", " + m_data[lng_e] }) </td>`;
			row += '</tr>';
			element.find('#field-geographic').append(row);
		}else{
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

			//markers.push(marker);

			var row = '<tr class="row">';
			row += `<td class="cell col-10"> ${ m_data[0] } </td>`;
			row += `<td class="cell col-2"> ${ m_data[lat_n] + ", " + m_data[lng_e] } </td>`;
			row += '</tr>';
			element.find('#field-geographic').append(row);
		}
	}
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
function fillTaxonomicRow(data, prevRow, index) {
	if (data === undefined)
		return;

	if (!Array.isArray(data))
		data = [data];

	for (var i = 0; i < data.length; i++) {
		var dataItem = data[i];

		var text = dataItem['taxonRankValue'];
		if (dataItem['commonName']) text += ` (${ dataItem['commonName'] })`;

		var cols = "";
		for (var j = 0; j < 7; j++) {
			if (j == index)	cols += `<td class="cell tax-cell colored">${ text }</td>`;
			else			cols += '<td class="cell tax-cell"></td>';
		}

		$(`<tr class="row">${ cols }</tr>`).insertAfter(prevRow);
		fillTaxonomicRow(dataItem['taxonomicClassification'], prevRow.next(), index + 1);
	}
}