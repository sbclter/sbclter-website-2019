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

			var title = makeSummary(template, data);
			$('#detail-modal-title').text(title);
			$('#detail-modal .modal-body').html(template);
		}
		catch (err) {
			$('#detail-modal .modal-body').html("Sorry, an error has occured! <br> " + err);
		}
	});
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
				text += creators[i]['individualName']['surName'] + ', ' + creators[i]['individualName']['givenName'][0][0] + '. ';

		text += data['eml:eml']['dataset']['pubDate'].split('-')[0] + '. ';
		text += data['eml:eml']['dataset']['title'] + '. ';
		text += data['eml:eml']['dataset']['publisher']['organizationName'] + '. ';
		text += data['eml:eml']['dataset']['publisher']['organizationName'] + '. ';
		text += data['eml:eml']['dataset']['alternateIdentifier'][1]['#text'] + '.';

		element.find('#field-citation').html(text);
	} catch(err) { console.error(err); }

	// fill keywords field
	try {
		var keywordList = data['eml:eml']['dataset']['keywordSet'];
		for (var i = 0; i < keywordList.length; i++) {
			var keywordItem = keywordList[i];
			var row = '<tr class="row">' +
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

	return data['eml:eml']['dataset']['title'];
}

function extractData(data, delim, keys) {
	if (data === undefined) return '';

	var str = '';
	if (Array.isArray(data))
		for (var i = 0; i < data.length; i++) {
			if (i >= data.length - 1) delim = '';
			str += extractDataObject(data[i], keys, ', ') + delim;
		}

	else if (typeof data == "object")
		str += extractDataObject(data, keys, delim);

	else
		str = data;

	return str;
}

function extractDataObject(data, keys, delim) {
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
