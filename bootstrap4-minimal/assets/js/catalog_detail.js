function showDetail(url) {
	var template = $('#detail-modal-template').clone();
	template.removeAttr('hidden');
	template.removeAttr('id');

	var loader = $('#loading-modal-template').clone();
	loader.removeAttr('hidden');
	loader.removeAttr('id');

	$('#detail-modal').modal();
	$('#detail-modal-title').text("Loading...");
	$('#detail-modal .modal-body').html(loader);

	loadXMLDoc(url, function(xml) {
		try {
			var dataString = xml2json(xml, "	");
			var data = JSON.parse(dataString);
			var title = data['eml:eml']['dataset']['title'];

			makeSummary(template, data);
			makePeople(template, data);
			$('#detail-modal-title').text(title);
			$('#detail-modal .modal-body').html(template);
		}
		catch (err) {
			$('#detail-modal .modal-body').html("Sorry, an error has occured! <br> " + err);
		}
	});
}

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

function loadXMLDoc(filename, onReady) {
	var xhttp;
	if (window.ActiveXObject)
		xhttp = new ActiveXObject("Msxml2.XMLHTTP");
	else
		xhttp = new XMLHttpRequest();
	xhttp.open("GET", filename, true);
	try { xhttp.responseType = "msxml-document" } catch(err) {} // Helping IE11

	xhttp.onload = function (e) {
		if (xhttp.readyState === 4 && xhttp.status === 200)
			onReady(xhttp.responseXML);
	};

	xhttp.send("");
	return xhttp.responseXML;
}

function camelToWords(text) {
	// https://stackoverflow.com/a/7225450/8443192
	var result = text.replace( /([A-Z])/g, " $1" );
	return result.charAt(0).toUpperCase() + result.slice(1);
}

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

function activateLink(url, title) {
	if (title === undefined) title = url;
	return `<a href='${ url }'>${ title }</a>`;
}

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
