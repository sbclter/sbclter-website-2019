class PackageFile {

	parse(json) {
		this.data = {
			datatables: []
		};

		let tables = extractList(json, 'dataset > dataTable');

		for (let i in tables) {
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

			this.data['datatables'].push({
				name:        extractString(tables[i], 'entityName'),
				description: extractString(tables[i], 'entityDescription'),
				url:         extractString(tables[i], 'physical > distribution > online > url'),
				orientation: extractString(tables[i], 'physical > dataFormat > textFormat > attributeOrientation'),
				attributes:  attribute_data
			});
		}
	}

	build(template) {
		var element = template.find('#content-class-files');

		// Fill datatable data
		let tables = this.data['datatables'];

		for (let i in tables) {
			let tableData = this.makeFilesTableData(tables[i]);

			element.append(`
				<div class="section-title" data-toggle="collapse" href="#datatable${ i }" aria-expanded="false" aria-controls="datatable${ i }">
					Data Table ${ parseInt(i) + 1 }: ${ tables[i]['name'] }
				</div>

				<div class="collapse" id="datatable${ i }">
					<div class="ml-3">${ tables[i]['description'] }</div>
					<div class="ml-3">${ activateLink(tables[i]['url'], 'Download CSV File') }</div>
					${ tableData }
				</div>
				<br>
			`);

			// Flip rows and columns if it's column orientation
			if (tables[i]['orientation'] == 'column') {
				element.find(`#datatable${ i } .datatable`).each(function() {
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
	}


	// ----------------------- Private Functions -------------------------


	makeFilesTableData(table) {
		let attr_rows_html = '';
		let	attr_measure_html = '';
		let	attr_missing_html = '';

		let attributes = table['attributes'];

		for (let i in attributes) {
			let attribute = attributes[i];

			let measurement = attribute['measurement'];
			let measure_type = measurement['type'];

			let missing_value = attribute['missing_value'];
			let missing_code = missing_value['code'];

			let measure_table_html = '';
			let measure_type_html = '';
			let missing_value_html = '';

			if (measure_type != '') {
				let unit = extractString(measurement, 'data', ['unit']);

				if (unit != '') {
					measure_type_html = `
						Measurement Unit:
						<span class="measure-btn" onclick="onMeasureClick(event)">
							${ unit }
						</span>
					`;
				}
				else {
					measure_type_html = `
						Measurement Type:
						<span class="measure-btn" onclick="onMeasureClick(event)">
							${ measure_type }
						</span>
					`;
				}
			}

			if (missing_value['code'] != '') {
				missing_value_html = `
					Missing Value Code:
					<span class="missing-btn" onclick="onMissingClick(event)">
						${ missing_value['code'] }
					</span>`
				;
			}

			attr_rows_html += makeTableRow([
				['td', `<strong> ${ attribute['label'] } </strong><br> ${ attribute['name'] }`, 3],
				['td', attribute['definition'], 5],
				['td', attribute['unit'], 1],
				['td', ` ${ measure_type_html } <br/> ${ missing_value_html } `, 3]
			]);

			switch(measure_type) {
				case 'nominal':  measure_table_html = this.makeMeasureNominal(measurement, measure_type); break;
				case 'dateTime': measure_table_html = this.makeMeasureDateTime(measurement, measure_type); break;
				case 'ratio':    measure_table_html = this.makeMeasureRatio(measurement, measure_type); break;
				case 'interval': measure_table_html = this.makeMeasureRatio(measurement, measure_type); break;
			}

			attr_measure_html += `
				<div>
					<strong>${ measure_type }: </strong>
					${ measure_table_html }
				</div>
			`;

			attr_missing_html += `
				<div>
					<strong>${ missing_value['code'] }: </strong>
					<br/>
					${ missing_value['description'] }
				</div>
			`;
		}

		let title_row = makeTableRow([
			['th', 'Attribute', 3],
			['th', 'Definition', 5],
			['th', 'Type', 1],
			['th', 'Others', 3]
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
					${ attr_measure_html }
				</div>
				<div class="missing-section hidden">
					${ attr_missing_html }
				</div>
			</div>
		`;
	}

	makeMeasureNominal(measurement, measure_type) {
		let domain = measurement['domain'];
		let rows = '';

		let data = measurement['data'];
		if (!Array.isArray(data)) data = [data];

		if (domain == 'enumeratedDomain') {

			for (let j in data) {
				rows += makeTableRow([
					['td', data[j]['code']      , 4],
					['td', data[j]['definition'], 4],
					['td', data[j]['source']    , 4],
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

	makeMeasureDateTime(measurement, measure_type) {
		let data = measurement['data'];

		let rows = '';

		for (let j in data) {
			rows += makeTableRow([
				['td', data[j]['format']   , 4],
				['td', data[j]['precision'], 4],
				['td', data[j]['domain']   , 4],
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

	makeMeasureRatio(measurement, measure_type) {
		let data = measurement['data'];

		let rows = '';

		for (let j in data) {
			rows += makeTableRow([
				['td', data[j]['unit']     , 3],
				['td', data[j]['precision'], 3],
				['td', data[j]['type']     , 2],
				['td', data[j]['min']      , 2],
				['td', data[j]['max']      , 2],
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
}

function onMeasureClick(e) {
	let container = $(e.target).parent().parent().parent().parent().parent();
	let nth = $(e.target).closest('tr').index() + 1;

	if (container.find('table').hasClass('column-orientation')) {
		nth = $(e.target).closest('td').index() + 1;
	}

	let measure = container.find(`.measurement-section div:nth-child(${ nth })`);

	$('#attribute-modal .modal-body').html(measure.clone());
	$('#attribute-modal').modal();
}

function onMissingClick(e) {
	let container = $(e.target).parent().parent().parent().parent().parent();
	let nth = $(e.target).closest('tr').index() + 1;

	if (container.find('table').hasClass('column-orientation')) {
		nth = $(e.target).closest('td').index() + 1;
	}

	let missing = container.find(`.missing-section div:nth-child(${ nth })`);

	$('#attribute-modal .modal-body').html(missing.clone());
	$('#attribute-modal').modal();
}
