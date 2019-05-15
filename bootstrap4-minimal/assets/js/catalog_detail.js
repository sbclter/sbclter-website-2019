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

function showDetail(url) {
	var xml = loadXMLDoc(url);
	var dataString = xml2json(xml, "	");
	var data = JSON.parse(dataString);

	var template = $('#detail-modal-template').clone();
	template.removeAttr('hidden');
	makeSummary(template, data);

	$('#detail-modal .modal-body').html(template);
	$('#detail-modal').modal();
}

function makeSummary(template, data) {
	var element = template.find('#content-class-summary');
	
	// fill id field
	try {
		element.find('#field-id').text(data['eml:eml']['@packageId']);
	}
	catch(err) { console.err("ID not found."); }

	// fill alternate id field
	try {
		var altIDs = data['eml:eml']['dataset']['alternateIdentifier'];
		var altIDText = '';
		altIDs.forEach(function(item) {
			if (item['#text'] !== undefined)
				altIDText += item['#text'] + '<br><br>';
			else
				altIDText += item + '<br><br>';
		});
		element.find('#field-id-alt').html(altIDText);
	}
	catch(err) { console.err("Alternate ID not found."); }

	// fill abstract paragraph field
	try {
		var abstracts = data['eml:eml']['dataset']['abstract']['para'];
		var abstractText = '';
		abstracts.forEach(function(item) {
			abstractText += item + '<br><br>';
		});
		element.find('#field-abstract').html(abstractText);
	}
	catch(err) { console.err("Abstract not found."); }
}

// function displayResult() {
// 	// xml = loadXMLDoc("/assets/test2/cdcatalog.xml");
// 	// xsl = loadXMLDoc("/assets/test2/cdcatalog_client.xsl");
// 	xml = loadXMLDoc("http://sbc.lternet.edu/data/eml/files/knb-lter-sbc.13");
// 	xsl = loadXMLDoc("/assets/xsl/eml2-HTMLtemplates.xsl");
// 	console.log(xml);
// 	console.log(xsl);

// 	// code for IE
// 	if (window.ActiveXObject || xhttp.responseType == "msxml-document") {
// 		ex = xml.transformNode(xsl);
// 		document.getElementById("external-display-container").innerHTML = ex;
// 	}
// 	// code for Chrome, Firefox, Opera, etc.
// 	else if (document.implementation && document.implementation.createDocument) {
// 		xsltProcessor = new XSLTProcessor();
// 		xsltProcessor.importStylesheet(xsl);
// 		resultDocument = xsltProcessor.transformToFragment(xml, document);
// 		console.log(resultDocument);
// 		document.getElementById("external-display-container").appendChild(resultDocument);
// 	}
// }
// displayResult();