var map;
var markers = [];
var bounds = new google.maps.LatLngBounds();

const TAX_COLUMNS = {
	kingdom: 0,
	phylum:  1,
	class:   2,
	order:   3,
	family:  4,
	genus:   5,
	species: 6
};

class PackageCoverage {

	parse(json) {
		this.data = {
			temporal: {},
			geographic: [],
			taxonomic: {}
		};

		// Parse timporal coverage
		this.data['temporal'] = {
			start: extractString(json, 'dataset > coverage > temporalCoverage > rangeOfDates > beginDate > calendarDate'),
			end:   extractString(json, 'dataset > coverage > temporalCoverage > rangeOfDates > endDate > calendarDate')
		};

		// Parse geographical coverage
		let points = extractList(json, 'dataset > coverage > geographicCoverage');

		for (let i in points) {
			let title = extractString(points[i], 'geographicDescription');
			let north = parseFloat(extractString(points[i], 'boundingCoordinates > northBoundingCoordinate'));
			let south = parseFloat(extractString(points[i], 'boundingCoordinates > southBoundingCoordinate'));
			let east  = parseFloat(extractString(points[i], 'boundingCoordinates > eastBoundingCoordinate'));
			let west  = parseFloat(extractString(points[i], 'boundingCoordinates > westBoundingCoordinate'));

			this.data['geographic'].push([title, north, south, east, west]);
		}

		// Parse taxonomic coverage
		let tax_data = extractList(json, 'dataset > coverage > taxonomicCoverage > taxonomicClassification');

		for (let i in tax_data) {
			tax_data[i]['commonName'] = extractString(tax_data[i], 'commonName');
			tax_data[i]['taxonRankValue'] = extractString(tax_data[i], 'taxonRankValue');
		}
		this.data['taxonomic'] = tax_data;
	}

	build(template) {
		let element = template.find('#content-class-coverage');
		let content = null;

		// Build temporal converage data
		content = this.data['temporal']['start'] + ' to ' + this.data['temporal']['end'];
		element.find('#field-temporal').text(content);

		// Build map from template to actual popup window
		this.initMap();
		$("#map").detach().appendTo(template.find('#field-map'));
		this.plotMarkers(element);

		// Build taxonomic title row
		let row = makeTableRow([
			['th', 'tax-cell', 'Kingdom'],
			['th', 'tax-cell', 'Phylum' ],
			['th', 'tax-cell', 'Class'  ],
			['th', 'tax-cell', 'Order'  ],
			['th', 'tax-cell', 'Family' ],
			['th', 'tax-cell', 'Genus'  ],
			['th', 'tax-cell', 'Species']
		]);
		row = $(row)
		row.attr('id', 'tax-head');
		element.find('#field-taxonomic').append(row);

		// Build taxonomic data rows
		this.fillTaxonomicRow(element.find('#field-taxonomic #tax-head').parent(), this.data['taxonomic'], null, 0);

		// Show taxonomic section if there are data rows
		if (element.find('#field-taxonomic').children().length > 1) {
			element.find('#section-taxonomic').removeAttr('hidden');
		}
	}


	// ----------------------- Private Functions -------------------------


	// Fill taxonomic rows for coverage
	fillTaxonomicRow(table, data, row, column) {
		if (!data) return;
		if (!Array.isArray(data)) data = [data];

		let first_row = row;

		for (let i in data) {
			let text = '';

			if (data[i]['taxonRankValue'])
				text += '<strong>' + data[i]['taxonRankValue'] + '</strong><br>';

			if (data[i]['commonName'])
				text += `${ data[i]['commonName'] }`;

			// Create new row if 1) new kingdom, or 2) more than 1 data for each column
			if (i == 0 && row == null || i > 0) {
				row = makeTableRow([[], [], [], [], [], [], []], 'tax-row');
				row = $(row);
				row.find('td').attr('class', 'cell tax-cell');

				// Append row at end of table if it's new kingdom
				if (column == 0) {
					table.append(row);
					first_row = row;
				}
				else {
					row.insertAfter(first_row);
				}

				// Add spacing when creating new kingdom
				if (column == 0) {
					let space_row = makeTableRow([[], [], [], [], [], [], []]);
					space_row = $(space_row);
					space_row.insertBefore(row);
				}
			}

			let chosen_column = column;

			let rank = data[i]['taxonRankName'] || '';
			rank = rank.toLowerCase();

			// Change column if rank is different from column name
			if (rank && TAX_COLUMNS[rank] != chosen_column) {
				chosen_column = TAX_COLUMNS[rank];
			}

			// Color every cell up to current column
			for (let c = 0; c <= chosen_column; c++)
				row.children().eq(c).addClass('colored');

			row.children().eq(chosen_column).html(text);
			this.fillTaxonomicRow(table, data[i]['taxonomicClassification'], row, chosen_column + 1);
		}
	}

	// Plot markers for coverage tab
	plotMarkers(element) {
		const lat_n = 1;
		const lat_s = 2;
		const lng_e = 3;
		const lng_w = 4;

		let infowindow = new google.maps.InfoWindow();
		let map_data = this.data['geographic'];

		for (let i in map_data) {
			const m_data = map_data[i];

			// Just a point so draw a marker
			if (m_data[lat_n] == m_data[lat_s] && m_data[lng_e] == m_data[lng_w]) {

				const marker = new google.maps.Marker({
					position: {lat: m_data[lat_n], lng: m_data[lng_e]},
					map: map,
					title: m_data[0]
				});

				google.maps.event.addListener(marker, 'click', function() {
					infowindow.setContent(this.title);  // Title
					infowindow.open(map, marker);
				});
			}
			else {
				let rectangle = new google.maps.Rectangle({
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
			}

			let latlng = `(${ m_data[lat_n] }, ${ m_data[lng_e] })`;
			let row = makeTableRow([
				['td', 'col-9'           , m_data[0]],
				['td', 'col-3 text-right', latlng],
			]);

			element.find('#field-geographic').append(row);

			bounds.extend(new google.maps.LatLng(m_data[lat_s], m_data[lng_w]));
			bounds.extend(new google.maps.LatLng(m_data[lat_n], m_data[lng_e]));
		}

		map.fitBounds(bounds);
	}

	// Gets called by Google Maps API to set up map (one map for all popup windows)
	initMap() {
		map = new google.maps.Map(document.getElementById("map"), {
			center:new google.maps.LatLng(34.3, - 120.000),
			zoom: 9,
			maxZoom: 12,
			mapTypeId: google.maps.MapTypeId.TERRAIN
		});
	}
}

// Reset map bound on coverage tab focus
function onCoverageOpen() {
	// Hack to get fitBounds work correctly
	setTimeout(function() {
		map.fitBounds(bounds);
	}, 0);
	return true;
}
