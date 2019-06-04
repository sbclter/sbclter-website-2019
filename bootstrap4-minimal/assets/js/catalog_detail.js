var map;
var markers = [];

var url = new URL(location);
var package = url.searchParams.get('package');

if (package == null)
	document.location = "/data/catalog";

var packageUrl = `https://pasta.lternet.edu/package/metadata/eml/${ package.replace(/\./g, "/") }/newest`;
showDetail(packageUrl);

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
			var dataString = xml2json(xml, "	");
			var data = JSON.parse(dataString);
			var title = data['eml:eml']['dataset']['title'];
			console.log(data);

			makeSummary(template, data);
			makePeople(template, data);
			makeCoverage(template, data);

			$('#detail #detail-title').text(title);
			$('#detail #detail-body').html(template);

			// customize tables: take out first border top of every table
			$('#detail #detail-body table').each(function(index) {
				$(this).find('tr:first td, tr:first th').addClass('no-border-top');
			});
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
		var dateText = extractData(data['eml:eml']['dataset']['coverage']['temporalCoverage']['rangeOfDates'], ' to ', ['beginDate/calendarDate', 'endDate/calendarDate']);
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
		fillTaxonomicRow(data['eml:eml']['dataset']['coverage']['taxonomicCoverage']['taxonomicClassification'], element.find('#field-taxonomic #tax-head'), 0);
	} catch(err) { console.error(err); }

}

// Make people's page
function makePeople(template, data) {
	var element = template.find('#content-class-people');

	// fill publishers field
	try {
		var publisher = data['eml:eml']['dataset']['publisher'];
		var row = '<tr class="row">';

		for(var key in publisher) {
			row += `<th class="cell col-2"> ${ camelToWords(key) } </th>`;
			row += `<td class="cell col-10"> ${ publisher[key] } </td>`;
		}

		row += '</tr>';
		element.find('#field-publishers').append(row);

	} catch(err) { console.error(err); }

	// fill owners field
	try {
		var creators = data['eml:eml']['dataset']['creator'];
		var contents = makePeopleTables(creators);
		element.find('#field-owners').append(contents);
	} catch(err) { console.error(err); }

	// fill contacts field
	try {
		var contacts = data['eml:eml']['dataset']['contact'];
		var contents = makePeopleTables(contacts);
		element.find('#field-contacts').append(contents);
	} catch(err) { console.error(err); }

}

function makeSummary(template, data) {
	var element = template.find('#content-class-summary');

	// fill id field
	try {
		var text = extractData(data['eml:eml']['@packageId']);
		element.find('#field-id').text(text);
	} catch(err) { console.error(err); }

	// fill alternate id field
	try {
		var text = extractData(data['eml:eml']['dataset']['alternateIdentifier'], '<br>', ['#text']);
		element.find('#field-id-alt').html(text);
	} catch(err) { console.error(err); }

	// fill abstract paragraph field
	try {
		var text = extractData(data['eml:eml']['dataset']['abstract']['para'], '<br><br>', ['#text']);
		element.find('#field-abstract').html(text);
	} catch(err) { console.error(err); }

	// fill shortname field
	try {
		var text = extractData(data['eml:eml']['dataset']['shortName']);
		element.find('#field-shortname').html(text);
	} catch(err) { console.error(err); }

	// fill publication date field
	try {
		var text = extractData(data['eml:eml']['dataset']['pubDate']);
		element.find('#field-pubdate').html(text);
	} catch(err) { console.error(err); }

	// fill language field
	try {
		var text = extractData(data['eml:eml']['dataset']['language']);
		element.find('#field-language').html(text);
	} catch(err) { console.error(err); }

	// fill time period field
	try {
		var text = extractData(data['eml:eml']['dataset']['coverage']['temporalCoverage']['rangeOfDates'], ' to ', ['beginDate/calendarDate', 'endDate/calendarDate']);
		element.find('#field-daterange').html(text);
	} catch(err) { console.error(err); }

	// fill citation field
	try {
		var text = '';
		var creators = data['eml:eml']['dataset']['creator'];
		for (var i = 0; i < creators.length; i++)
			if (creators[i]['individualName'] !== undefined)
				text += parseName(creators[i]['individualName'], '%L, %f. ');

		text += extractData(data['eml:eml']['dataset']['pubDate']).split('-')[0] + '. ';
		text += extractData(data['eml:eml']['dataset']['title']) + '. ';
		text += extractData(data['eml:eml']['dataset']['publisher']['organizationName']) + '. ';
		text += extractData(data['eml:eml']['dataset']['alternateIdentifier'][1]['#text']) + '.';

		element.find('#field-citation').html(text);
	} catch(err) { console.error(err); }

	// fill keywords field
	try {
		var keywordList = data['eml:eml']['dataset']['keywordSet'];
		for (var i = 0; i < keywordList.length; i++) {
			var keywordItem = keywordList[i];
			var row =
			'<tr class="row">' +
				`<th class="cell col-4"> ${ extractData(keywordItem['keywordThesaurus']) } </th>` +
				`<td class="cell col-8"> ${ extractData(keywordItem['keyword'], ', ', ['#text']) } </td>` +
			'</tr>';
			element.find('#field-keywords').append(row);
		}
	} catch(err) { console.error(err); }

	// fill usage rights field
	try {
		var rights = extractData(data['eml:eml']['dataset']['intellectualRights']['para'], '</li>\n<li>');
		if (rights === '[object Object]')
			rights = extractData(data['eml:eml']['dataset']['intellectualRights']['para']['itemizedlist']['listitem'], '</li>\n<li>', ['para']);

		var text = '<li>' + rights + '</li>';
		element.find('#field-usage-rights').html(text);
	} catch(err) { console.error(err); }
}



// ----------------------- Helper Functions! -------------------------

// Extract object, array, or text from JSON data
function extractData(data, delim, keys) {
	if (data === undefined) return '';

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
	if (data === undefined) return '';
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
	var result = text.replace( /([A-Z])/g, " $1" );
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
	if (!Array.isArray(data)) data = [data];
	var contents = '';

	for (var i = 0; i < data.length; i++) {
		var item = data[i];
		contents += '<table class="table floatbox"><tbody>';

		// fill information for each item
		for(var key in item) {
			var row = `<tr class="row">` +
					  `<th class="cell col-4"> ${ camelToWords(key) } </th>`;

			// parse item information
			var value = item[key];
			if (typeof value === 'object') {
				if      (key === 'address')        value = parseAddress(value);
				else if (key === 'individualName') value = parseName(value, '%F %L');
				else if (key === 'phone')          value = extractData(value, '; ', ['#text', '@phonetype']);
				else                               value = extractData(value, ', ', ['#text']);
			}

			// activate any link
			if (typeof value === 'string') {
				if (value.startsWith('http')) value = activateLink(value);
				if (value.includes('@'))      value = activateLink(`mailto: ${ value }`, value);
			}

			row += `<td class="cell col-8"> ${ value } </td> </tr>`;
			contents += row;
		}

		contents += '</tbody></table>';
	}

	return contents;
}

// Plot markers for coverage tab
function plotMarkers(element, data) {
	var points = data['eml:eml']['dataset']['coverage']['geographicCoverage'];
	var prevWindow = null;

	for (var i = 0; i < points.length; i++) {
		var title = points[i]['geographicDescription'];
		var lat = points[i]['boundingCoordinates']['northBoundingCoordinate'];
		var lng = points[i]['boundingCoordinates']['eastBoundingCoordinate'];

		const infowindow = new google.maps.InfoWindow({
			content: title
		});

		const marker = new google.maps.Marker({
			position: {lat: parseFloat(lat), lng: parseFloat(lng)},
			map: map,
			title: title
		});

		marker.addListener('click', function() {
			if (prevWindow != null)
				prevWindow.close();

			infowindow.open(map, marker);
			prevWindow = infowindow;
		});

		markers.push(marker);

		var row = '<tr class="row">';
		row += `<td class="cell col-10"> ${ title } </td>`;
		row += `<td class="cell col-2"> ${ lat + ", " + lng } </td>`;
		row += '</tr>';
		element.find('#field-geographic').append(row);
	}
}

// Gets called by Google Maps API to set up map (one map for all popup windows)
function initMap() {
	map = new google.maps.Map(document.getElementById("map"), {
		center:new google.maps.LatLng(34.3, - 120.000),
		zoom: 9,
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