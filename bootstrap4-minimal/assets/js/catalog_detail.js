function showDetail(url) {
	var xml = loadXMLDoc(url);
	var dataString = xml2json(xml, "	");
	var data = JSON.parse(dataString);
	// var data = sample_data;
	console.log(data);

	var template = $('#detail-modal-template').clone();
	template.removeAttr('hidden');
	var id = makeSummary(template, data);

	$('#detail-modal-title').text(`Data Set (${id})`);
	$('#detail-modal .modal-body').html(template);
	$('#detail-modal').modal();
}

function makeSummary(template, data) {
	var element = template.find('#content-class-summary');
	var id;

	// fill id field
	try {
		id = extractData(data['eml:eml']['@packageId']);
		element.find('#field-id').text(id);
	} catch(err) { console.error(err); }

	// fill alternate id field
	try {
		var text = extractData(data['eml:eml']['dataset']['alternateIdentifier'], '<br>', ['#text']);
		element.find('#field-id-alt').html(text);
	} catch(err) { console.error(err); }

	// fill abstract paragraph field
	try {
		var text = extractData(data['eml:eml']['dataset']['abstract']['para'], '<br><br>');
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






	// fill usage rights field
	try {
		var text = '<li>';
		text += extractData(data['eml:eml']['dataset']['intellectualRights']['para'], '</li>\n<li>');
		text += '</li>';
		element.find('#field-usage-rights').html(text);
	} catch(err) { console.error(err); }

	return id;
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

function loadXMLDoc(filename) {
	var xhttp;
	if (window.ActiveXObject)
		xhttp = new ActiveXObject("Msxml2.XMLHTTP");
	else
		xhttp = new XMLHttpRequest();
	xhttp.open("GET", filename, false);
	try { xhttp.responseType = "msxml-document" } catch(err) {} // Helping IE11
	xhttp.send("");
	return xhttp.responseXML;
}
