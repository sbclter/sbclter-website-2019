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
				let measure_parsed = {
					type: measure_type,
					data: []
				};

				switch(measure_type) {
					case 'nominal':
						let measure_domain1 = Object.keys(measurement[measure_type])[0];
						let measure_domain2 = Object.keys(measurement[measure_type][measure_domain1])[0];
						let measure_def_key = Object.keys(measurement[measure_type][measure_domain1][measure_domain2])[0];

						measure_parsed['domain'] = measure_domain2;
						measure_parsed['data'] = extractList(measurement[measure_type][measure_domain1][measure_domain2][measure_def_key]);
						break;

					case 'dateTime':
						let datetime_data = extractList(measurement[measure_type]);

						for (let k in datetime_data) {
							measure_parsed['data'].push({
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

							measure_parsed['data'].push({
								min: min || '',
								max: max || '',
								precision: ratio_data[k]['precision'] || '',
								unit: unit || '',
								type: type || ''
							});
						}
						break;
				}

				let missing_parsed = [];
				let missing_values = extractList(attribute, 'missingValueCode');

				for (let k in missing_values) {
					missing_parsed.push({
						code:        extractString(missing_values[k], 'code'),
						description: extractString(missing_values[k], 'codeExplanation')
					});
				}

				attribute_data.push({
					definition: extractString(attribute, 'attributeDefinition'),
					unit:       extractString(attribute, 'storageType'),
					label:      extractString(attribute, 'attributeLabel'),
					name:       extractString(attribute, 'attributeName'),
					missing_value: missing_parsed,
					measurement: measure_parsed,
					annotation: extractString(attribute, 'annotation', ['propertyURI > _label', 'valueURI > _label'], ' ')
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
			let tableData = this.makeDatatable(tables[i]);

			element.append(`
				<div class="section-title datatable-title" data-toggle="collapse" href="#datatable${ i }" aria-expanded="false" aria-controls="datatable${ i }">
					<div class="title">
						Data Table ${ parseInt(i) + 1 }: ${ tables[i]['name'] }
					</div>

					<img class="collapse-icon icon hidden" src="/assets/img/collapse.png"/>
					<img class="expand-icon icon" src="/assets/img/expand.png"/>
				</div>

				<div class="collapse" id="datatable${ i }">
					<div class="ml-3">${ tables[i]['description'] }</div>
					<div class="ml-3">${ activateLink(tables[i]['url'], 'Download Data File') }</div>
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

		element.find('.datatable-title').on('click', function (e) {
			$(this).find('.icon.collapse-icon').toggleClass('hidden');
			$(this).find('.icon.expand-icon').toggleClass('hidden');
		});
	}


	// ----------------------- Private Functions -------------------------


	makeDatatable(table) {
		let	measure_popup_html = '';
		let	missing_popup_html = '';
		let attr_rows_html = '';

		let attributes = table['attributes'];

		for (let i in attributes) {
			let attribute = attributes[i];

			let measure_html = this.makeMeasure(attribute, i);
			let missing_html = this.makeMissing(attribute, i);

			attr_rows_html += makeTableRow([
				['td', `<strong> ${ attribute['label'] } </strong><br> ${ attribute['name'] }`, 2],
				['td', attribute['definition']                                                , 4],
				['td', attribute['annotation']                                                , 2],
				['td', attribute['unit']                                                      , 1],
				['td', ` ${ measure_html['brief'] } <br/> ${ missing_html['brief'] } `        , 3]
			]);

			measure_popup_html += measure_html['popup'];
			missing_popup_html += missing_html['popup'];
		}

		let title_row = makeTableRow([
			['th', 'Attribute' , 2],
			['th', 'Definition', 4],
			['th', 'Annotation', 2],
			['th', 'Type'      , 1],
			['th', 'Others'    , 3]
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

	makeMeasure(attribute, id) {
		let measurement = attribute['measurement'];
		let measure_type = measurement['type'];

		let table_html = '';
		let popup_html = '';
		let popup_content_html = '';
		let popup_id = id;

		if (measure_type != '') {
			let unit = extractString(measurement, 'data', ['unit']);

			if (unit != '') {
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
			case 'nominal':  popup_content_html = this.makeMeasureNominal(measurement, measure_type); break;
			case 'dateTime': popup_content_html = this.makeMeasureDateTime(measurement, measure_type); break;
			case 'ratio':    popup_content_html = this.makeMeasureRatio(measurement, measure_type); break;
			case 'interval': popup_content_html = this.makeMeasureRatio(measurement, measure_type); break;
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

	makeMissing(attribute, id) {
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

function onMeasureClick(e, id) {
	let container = $(e.target).parent().parent().parent().parent().parent();
	let measure = container.find(`.measurement-section #${ id }`);

	$('#attribute-modal .modal-body').html(measure.clone());
	$('#attribute-modal').modal();
}

function onMissingClick(e, id) {
	let container = $(e.target).parent().parent().parent().parent().parent();
	let missing = container.find(`.missing-section #${ id }`);

	$('#attribute-modal .modal-body').html(missing.clone());
	$('#attribute-modal').modal();
}
