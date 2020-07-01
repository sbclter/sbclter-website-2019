---
---

// Javascript for creating google maps

var map;
var cluster;
var layers = {};  // Holds all layer objects that map to URL's
var layerCollections = {
	// layer: [{name, packages}, {name, packages}, ...]
};

function initMap() {
	// Set up google map
	map = new google.maps.Map(document.getElementById("map"),
		{
			center:new google.maps.LatLng(34.3, - 120.000),
			zoom: 9,
			mapTypeId: google.maps.MapTypeId.TERRAIN
		}
	);

	let infowindow = new google.maps.InfoWindow();
	let boxes = document.getElementsByClassName("layer_box");

	// Add markers to each layer (defined by checkbox)
	for (let i in boxes) {
		let elements = $(`.${ boxes[i].id }-geodata-list .geodata`);
		console.log(`.${ boxes[i].id }-geodata-list .geodata`);
		layers[boxes[i].id] = {
			markers: [],
			visible: false
		};

		elements.each(function(index, value) {
			let data = $(this).data();
			let south = parseFloat(data.southbound);
			let north = parseFloat(data.northbound);
			let west = parseFloat(data.westbound);
			let east = parseFloat(data.eastbound);

			if (Number.isNaN(south) || Number.isNaN(north) || Number.isNaN(east) || Number.isNaN(west)) {
				return;
			}


			// Draw marker
			if (south == north && east == west) {

				const marker = new google.maps.Marker({
					position: {
						lat: north,
						lng: east
					},
					map: map,
					title: data.title,
					visible: false,
					icon: {
						url: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
					}
				});

				// Initialize popup window
				google.maps.event.addListener(marker, 'click', function() {
					infowindow.setContent(`
						<h4> ${ data.title } </h4>
						<strong>Description: </strong> ${ data.description }   <br><br>
						<strong>Habitat:     </strong> ${ data.habitat }       <br>
						<strong>LatLng:      </strong> (${ north }, ${ east }) <br>
					`);
					infowindow.open(map, marker);
				});

				layers[boxes[i].id]['markers'].push(marker);
			}
			// Draw rectangle
			else {

				const marker = new google.maps.Rectangle({
					strokeColor: '#0000FF',
					strokeOpacity: 0.8,
					strokeWeight: 2,
					fillColor: '#0000FF',
					fillOpacity: 0.35,
					map: map,
					title: data.title,
					visible: false,
					bounds: {
						north: north,
						south: south,
						east: east,
						west: west
					}
				});

				// Initialize popup window
				google.maps.event.addListener(marker, 'click', function() {
					infowindow.setContent(`
						<h4> ${ data.title } </h4>
						<strong>Description:   </strong> ${ data.description } <br><br>
						<strong>Habitat:       </strong> ${ data.habitat }     <br>
						<strong>LatLng Bounds: </strong> NE (${ north }, ${ east }), SW (${ south }, ${ west }) <br>
					`);
					infowindow.setPosition({lat: north, lng: west});
					infowindow.open(map, marker);
				});

				layers[boxes[i].id]['markers'].push(marker);
			}
		});
	}
}

// Reset map zoom on toggle
function zoomMap() {
	var bounds = new google.maps.LatLngBounds();

	if (cluster)
		cluster.clearMarkers();

	let all_markers = [];

	for (let i in layers) {
		let layer = layers[i];

		// Collect bounds of active layers
		if (layer.visible) {

			for (let j in layer.markers) {
				let marker = layer.markers[j];

				if (typeof marker.getPosition === "function") {
					bounds.extend(marker.getPosition());
					all_markers.push(marker);
				}
				else {
					bounds.extend(marker.getBounds().getNorthEast());
					bounds.extend(marker.getBounds().getSouthWest());
				}
			}
		}
	}

	if (!bounds.isEmpty())
		map.fitBounds(bounds);

	// Add cluster
	cluster = new MarkerClusterer(map, all_markers, {
		imagePath: '/assets/img/gmap/m',
		maxZoom: 13
	});
}

// Display the layer with the given id on the map
function show_layer(id) {
	let layer = layers[id];
	layer.visible = true;

	for (let i in layer['markers']) {
		layer['markers'][i].setVisible(true);
	}

	zoomMap();
}

// Hide the layer with given id on the map
function hide_layer(id) {
	let layer = layers[id];
	layer.visible = false;

	for (let i in layer['markers']) {
		layer['markers'][i].setVisible(false);
	}

	zoomMap();
}

// This will toggle the boxes layer on the map
function toggle_layer(on, id){
	if (on)
		show_layer(id);
	else
		hide_layer(id);
}

$(function() {
	// Tracks changes to any of the boxes on the page
	$('.layer_box').change(function() {
		toggle_layer(this.checked, this.id);
	});

	// Toggles on all checkboxes of specific id to on
	$('.group-toggle').change(function() {
		let check_class = ".chkbox_" + this.id;
		let boxes = $(check_class);

		if (this.checked) {
			$(check_class).prop('checked', true);
			// $(check_class).parent().attr('class', "toggle btn btn-info");

			// Show layers on map
			boxes.each((i) => {
				toggle_layer(true, boxes[i].id);
			});
		}
		else {
			$(check_class).prop('checked', false);
			// $(check_class).parent().attr('class', "toggle btn btn-secondary off");

			// Hide layers on map
			boxes.each((i) => {
				toggle_layer(false, boxes[i].id);
			});
		}
	});

	// Onclick event for "See collections"
	$('.collection-btn').click(function(e) {
		e.preventDefault();
		let info = $(this).parent().attr('id').split('-');
		let habitat = info[0];
		let measurement = info[1];
		let html = '';

		// Build popup HTML for each collection
		$(`.${ habitat }-${ measurement }-package-list`).each(function() {

			// Build collection packages HTML
			let packages_html = $.map($(this).find('.package'), item => {
				let p = $(item).data();
				return `
					<div class="package-link">
						<a href="/data/catalog/package/?package=${ p.docid }" target="_blank">
							${ p.shorttitle }
						</a>
					</div>
				`;
			});

			// Build collection HTML
			html += `
				<div class="collection-section">
					<h3>${ $(this).data().collection }</h3>
					<div class="package-section">
						${ packages_html.join('') }
					</div>
				</div>
			`;
		});

		// Insert popup HTML
		$('#layer-modal .modal-body').html(html);
		$('#layer-modal').modal();
	});
});
