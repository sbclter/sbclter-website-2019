class PackageSummary {

	parse(json) {
		this.data = {
			general: {},
			citation: '',
			keywords: [],
			rights: []
		};

		// Parse general
		this.data['general'] = {
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
		this.data['citation'] = citation;

		// Parse keywords
		let keywords = json['dataset']['keywordSet'];
		for (let i in keywords) {
			let key = extractString(keywords[i]['keywordThesaurus']);
			let val = extractList(keywords[i]['keyword']);
			this.data['keywords'].push([key, val]);
		}

		// Parse rights
		let rights = extractList(json, 'dataset > intellectualRights > para > itemizedlist > listitem', ['para']);

		if (rights.length == 0)
			rights = extractList(json, 'dataset > intellectualRights > para');

		this.data['rights'] = rights;
	}

	build(template) {
		let element = template.find('#content-class-summary');
		let content = null;

		// fill shortname field
		content = this.data['general']['name'];
		element.find('#field-shortname').html(content);

		// fill id field
		content = this.data['general']['id']
		element.find('#field-id').text(content);

		// fill alternate id field
		content = this.data['general']['alternate_id'].join('<br>');
		element.find('#field-id-alt').html(content);

		// fill abstract field
		content = this.data['general']['abstract'].join('<br><br>');
		element.find('#field-abstract').html(content);

		// fill publication date field
		content = this.data['general']['publication_date'];
		element.find('#field-pubdate').html(content);

		// fill language field
		content = this.data['general']['language'];
		element.find('#field-language').html(content);

		// fill time period field
		content = this.data['general']['time_range']['start'] + ' to ' + this.data['general']['time_range']['end'];
		element.find('#field-daterange').html(content);

		// fill citation field
		content = this.data['citation'];
		element.find('#field-citation').html(content);

		// fill keywords field
		for (let i in this.data['keywords']) {
			let key = this.data['keywords'][i][0];
			let val = this.data['keywords'][i][1].join(', ');

			let row;
			if (key == "" || key == "none")
				row = makeTableRow([['td', val, 12]]);
			else
				row = makeTableRow([['th', key, 4], ['td', val, 8]]);

			element.find('#field-keywords').append(row);
		}

		// fill rights field
		for (let i in this.data['rights']) {
			element.find('#field-usage-rights').append(`<li> ${ this.data['rights'][i] } </li>`);
		}
	}
}
