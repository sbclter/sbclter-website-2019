class PackageFile {

	parse(json) {
		this.data = {
			datatables: [],
			entities: []
		};

		let tables = extractList(json, 'dataset > dataTable');
		let entities = extractList(json, 'dataset > otherEntity');

		// Parse datatables
		for (let i in tables) {
			let attributes = extractList(tables[i], 'attributeList > attribute');
			let attribute_data = [];

			// Parse table attributes
			for (let j in attributes) {
				let attribute = attributes[j];

				let missing_parsed = this.parseMissing(attribute);
				let measure_parsed = this.parseMeasure(attribute);

				attribute_data.push({
					definition: extractString(attribute, 'attributeDefinition'),
					unit:       extractString(attribute, 'storageType'),
					label:      extractString(attribute, 'attributeLabel'),
					name:       extractString(attribute, 'attributeName'),
					missing_value: missing_parsed,
					measurement:   measure_parsed,
					annotation: extractString(attribute, 'annotation', ['propertyURI > _label', 'valueURI > _label'], ' ')
				});
			}

			// Parse constraints
			let constraints = extractList(tables[i], 'constraint', ['primaryKey']);
			let constraint_data = [];

			for (let j in constraints) {
				let constraint = constraints[j];

				constraint_data.push({
					name: extractString(constraint, 'constraintName'),
					keys: extractList(constraint, 'key > attributeReference', [], true)
				});
			}

			this.data['datatables'].push({
				name:        extractString(tables[i], 'entityName'),
				description: extractString(tables[i], 'entityDescription'),
				url:         extractString(tables[i], 'physical > distribution > online > url'),
				orientation: extractString(tables[i], 'physical > dataFormat > textFormat > attributeOrientation'),
				attributes:  attribute_data,
				constraints: constraint_data
			});
		}

		// Parse entities
		for (let i in entities) {
			this.data['entities'].push({
				name:        extractString(entities[i], 'entityName'),
				description: extractString(entities[i], 'entityDescription'),
				url:         extractString(entities[i], 'physical > distribution > online > url')
			});
		}
	}

	build(template) {
		let element = template.find('#content-class-files');
		let tables = this.data['datatables'];
		let entities = this.data['entities'];
		let onlyone = (tables.length + entities.length == 1);

		// Build datatables
		for (let i in tables) {

			// Build attribute table
			let tableData = this.buildAttributeTable(tables[i]);

			let constraints_data = tables[i].constraints;
			let constraints_html = "";

			for (let j in constraints_data) {
				constraints_html += `<strong>Primary Key (${ constraints_data[i].name }): </strong>${ constraints_data[i].keys.join(', ') }<br>`;
			}

			// Build datatable section
			element.append(`
				<div class="section-title datatable-title clickable" data-toggle="collapse" href="#datatable${ i }" aria-expanded="false" aria-controls="datatable${ i }">
					<div class="title">
						Data Table ${ parseInt(i) + 1 }: ${ tables[i]['name'] }
					</div>

					<img class="collapse-icon icon hidden" src="/assets/img/collapse.png"/>
					<img class="expand-icon icon" src="/assets/img/expand.png"/>
				</div>

				<div class="collapse ${ onlyone ? 'show' : '' }" id="datatable${ i }">
					<div class="ml-3"> <strong>Description: </strong>${ tables[i]['description'] }</div>
					<div class="ml-3"> ${ constraints_html } </div>
					<div class="ml-3"> <strong>${ activateLink(tables[i]['url'], 'Download Data File') }</strong> </div>

					${ tableData }
				</div>
				<br>
			`);

			// Flip rows and columns if it's column oriented
			if (tables[i]['orientation'] == 'column') {
				this.flipTable(element.find(`#datatable${ i } .datatable`));
			}
		}

		// Build entities
		for (let i in entities) {

			// Build entity section
			element.append(`
				<div class="section-title entities-title clickable" data-toggle="collapse" href="#entities${ i }" aria-expanded="false" aria-controls="entities${ i }">
					<div class="title">
						Entity ${ parseInt(i) + 1 }: ${ entities[i]['name'] }
					</div>

					<img class="collapse-icon icon hidden" src="/assets/img/collapse.png"/>
					<img class="expand-icon icon" src="/assets/img/expand.png"/>
				</div>

				<div class="collapse ${ onlyone ? 'show' : '' }" id="entities${ i }">
					<div class="ml-3">${ entities[i]['description'] }</div>
					<div class="ml-3">${ activateLink(entities[i]['url'], 'Download Data File') }</div>
				</div>
				<br>
			`);
		}

		// Add click event for section titles
		element.find('.datatable-title').on('click', function (e) {
			$(this).find('.icon.collapse-icon').toggleClass('hidden');
			$(this).find('.icon.expand-icon').toggleClass('hidden');
		});
	}


	// ----------------------- Parse Functions -------------------------


	parseMissing(attribute) {
		let parsed = [];
		let values = extractList(attribute, 'missingValueCode');

		for (let k in values) {
			parsed.push({
				code:        extractString(values[k], 'code'),
				description: extractString(values[k], 'codeExplanation')
			});
		}

		return parsed;
	}

	parseMeasure(attribute) {
		let measurement = attribute['measurementScale'];
		let measure_type = Object.keys(measurement)[0];

		let parsed = {
			type: measure_type,
			data: []
		};

		switch(measure_type) {
			case 'nominal':
				let nominal_parsed = this.parseMeasureNominal(measurement, measure_type);
				parsed['domain'] = nominal_parsed['domain'];
				parsed['data'] = nominal_parsed['data'];
				break;

			case 'dateTime':
				parsed['data'] = this.parseMeasureDateTime(measurement, measure_type);
				break;

			case 'ratio':
			case 'interval':
				parsed['data'] = this.parseMeasureRatio(measurement, measure_type);
				break;
		}

		return parsed;
	}

	parseMeasureNominal(measurement, measure_type) {
		let measure_domain1 = Object.keys(measurement[measure_type])[0];
		let measure_domain2 = Object.keys(measurement[measure_type][measure_domain1])[0];
		let measure_def_key = Object.keys(measurement[measure_type][measure_domain1][measure_domain2])[0];

		return {
			domain: measure_domain2,
			data: extractList(measurement[measure_type][measure_domain1][measure_domain2][measure_def_key])
		}
	}

	parseMeasureDateTime(measurement, measure_type) {
		let datetime_data = extractList(measurement[measure_type]);
		let result = [];

		for (let k in datetime_data) {
			result.push({
				format: datetime_data[k]['formatString'],
				precision: datetime_data[k]['dateTimePrecision'],
				domain: datetime_data[k]['dateTimeDomain']
			});
		}

		return result;
	}

	parseMeasureRatio(measurement, measure_type) {
		let ratio_data = extractList(measurement[measure_type]);
		let result = [];

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

			result.push({
				min: min || '',
				max: max || '',
				precision: ratio_data[k]['precision'] || '',
				unit: unit || '',
				type: type || ''
			});
		}

		return result;
	}


	// ----------------------- Build Functions -------------------------


	buildAttributeTable(table) {
		let	measure_popup_html = '';
		let	missing_popup_html = '';
		let attr_rows_html = '';

		let attributes = table['attributes'];

		for (let i in attributes) {
			let attribute = attributes[i];

			let measure_html = this.buildMeasure(attribute, i);
			let missing_html = this.buildMissing(attribute, i);

			attr_rows_html += makeTableRow([
				['td', 'col-2', `<strong> ${ attribute['label'] } </strong><br> ${ attribute['name'] }`],
				['td', 'col-4', attribute['definition']],
				['td', 'col-2', attribute['annotation']],
				['td', 'col-1', attribute['unit']],
				['td', 'col-3', `${ measure_html['brief'] }<br>${ missing_html['brief'] }`]
			]);

			measure_popup_html += measure_html['popup'];
			missing_popup_html += missing_html['popup'];
		}

		let title_row = makeTableRow([
			['th', 'col-2', 'Attribute'],
			['th', 'col-4', 'Definition'],
			['th', 'col-2', 'Annotation'],
			['th', 'col-1', 'Type'],
			['th', 'col-3', 'Others']
		], 'title-row');

		return `
			<div class="table-wrap">
				<table class="table datatable">
					<tbody>
						${ title_row }
						${ attr_rows_html }
					</tbody>
				</table>
				<div class="measurement-section hidden">
					${ measure_popup_html }
				</div>
				<div class="missing-section hidden">
					${ missing_popup_html }
				</div>
			</div>
		`;
	}

	buildMissing(attribute, id) {
		let missing_values = attribute['missing_value'];
		let table_html = '';
		let popup_html = '';

		for (let j in missing_values) {
			let popup_id = id + '-' + j;

			if (missing_values[j]['code'] != '') {
				table_html += `
					<span class="missing-btn" onclick="onMissingClick(event, '${ popup_id }')">
						${ missing_values[j]['code'] }
					</span>
				`;

				if (j < missing_values.length - 1) {
					table_html += ', ';
				}

				popup_html += `
					<div id="${ popup_id }">
						<strong>${ missing_values[j]['code'] }: </strong>
						<br/>
						${ missing_values[j]['description'] }
					</div>
				`;
			}
		}

		if (table_html != '') {
			table_html = 'Missing Value Code: ' + table_html;
		}

		return {
			brief: table_html,
			popup: popup_html
		}
	}

	buildMeasure(attribute, id) {
		let measurement = attribute['measurement'];
		let measure_type = measurement['type'];

		let table_html = '';
		let popup_html = '';
		let popup_content_html = '';
		let popup_id = id;

		if (measure_type != '') {
			let unit = extractString(measurement, 'data', ['unit']);

			if (measurement['domain'] == 'textDomain') {
				table_html = `
					Measurement Unit: ${ extractString(measurement, 'data', [], ', ') }
				`;
			}
			else if (unit != '') {
				table_html = `
					Measurement Unit:
					<span class="measure-btn" onclick="onMeasureClick(event, ${ popup_id })">
						${ unit }
					</span>
				`;
			}
			else {
				table_html = `
					Measurement Type:
					<span class="measure-btn" onclick="onMeasureClick(event, ${ popup_id })">
						${ measure_type }
					</span>
				`;
			}
		}

		switch(measure_type) {
			case 'nominal':  popup_content_html = this.buildMeasureNominal(measurement, measure_type); break;
			case 'dateTime': popup_content_html = this.buildMeasureDateTime(measurement, measure_type); break;
			case 'ratio':    popup_content_html = this.buildMeasureRatio(measurement, measure_type); break;
			case 'interval': popup_content_html = this.buildMeasureRatio(measurement, measure_type); break;
		}

		popup_html += `
			<div id="${ popup_id }">
				<strong>${ measure_type }: </strong>
				${ popup_content_html }
			</div>
		`;

		return {
			brief: table_html,
			popup: popup_html
		}
	}

	buildMeasureNominal(measurement, measure_type) {
		let domain = measurement['domain'];
		let rows = '';

		let data = measurement['data'];
		if (!Array.isArray(data)) data = [data];

		if (domain == 'enumeratedDomain') {

			for (let j in data) {
				rows += makeTableRow([
					['td', 'col-4', data[j]['code']],
					['td', 'col-4', data[j]['definition']],
					['td', 'col-4', data[j]['source']]
				]);
			}

			let title_row = makeTableRow([
				['th', 'col-4', 'Code'],
				['th', 'col-4', 'Definition'],
				['th', 'col-4', 'Source']
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
				rows += data[j] + ', ';
			}

			return rows.substring(0, rows.length - 2);
		}
	}

	buildMeasureDateTime(measurement, measure_type) {
		let data = measurement['data'];

		let rows = '';

		for (let j in data) {
			rows += makeTableRow([
				['td', 'col-4', data[j]['format']],
				['td', 'col-4', data[j]['precision']],
				['td', 'col-4', data[j]['domain']]
			]);
		}

		let title_row = makeTableRow([
			['th', 'col-4', 'Format'],
			['th', 'col-4', 'Precision'],
			['th', 'col-4', 'Domain']
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

	buildMeasureRatio(measurement, measure_type) {
		let data = measurement['data'];

		let rows = '';

		for (let j in data) {
			rows += makeTableRow([
				['td', 'col-3', data[j]['unit']],
				['td', 'col-3', data[j]['precision']],
				['td', 'col-2', data[j]['type']],
				['td', 'col-2', data[j]['min']],
				['td', 'col-2', data[j]['max']]
			]);
		}

		let title_row = makeTableRow([
			['th', 'col-3', 'Unit'],
			['th', 'col-3', 'Precision'],
			['th', 'col-2', 'Type'],
			['th', 'col-2', 'Min'],
			['th', 'col-2', 'Max']
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


	// ----------------------- Other Functions -------------------------


	// Change row <-> column of a table
	flipTable(table) {
		table.each(function() {
			let $this = $(this);

			$this.addClass('column-orientation');

			let newrows = [];
			$this.find("tr").each(function() {

				let j = 0;
				$(this).find("td, th").each(function(){
					j++;
					if(newrows[j] === undefined) { newrows[j] = $("<tr class='row'></tr>"); }
					newrows[j].append($(this));
				});
			});

			$this.find("tr").remove();
			$.each(newrows, function(){
				$this.append(this);
			});
		});
	}
}


// Open popup (modal) on missing link clicked.
function onMissingClick(e, id) {
	let container = $(e.target).parent().parent().parent().parent().parent();
	let missing = container.find(`.missing-section #${ id }`);

	$('#attribute-modal .modal-body').html(missing.clone());
	$('#attribute-modal').modal();
}

// Open popup (modal) on measure link clicked.
function onMeasureClick(e, id) {
	let container = $(e.target).parent().parent().parent().parent().parent();
	let measure = container.find(`.measurement-section #${ id }`);

	$('#attribute-modal .modal-body').html(measure.clone());
	$('#attribute-modal').modal();
}
