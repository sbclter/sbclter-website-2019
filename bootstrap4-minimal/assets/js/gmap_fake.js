// Javascript for creating google maps

var map;
var layers = {};  // Holds all layer objects that map to URL's

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
		let elements = $(`.${ boxes[i].id }-geodata`);
		layers[boxes[i].id] = {
			markers: [],
			visible: false
		};

		elements.each(function(index, value) {
			let data = $(this).data();

			// Initialize marker
			const marker = new google.maps.Marker({
				position: {
					lat: data.lat,
					lng: data.lng
				},
				map: map,
				title: data.title,
				visible: false,
				icon: {
					url: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
				}
			});

			// Initialize marker popup window
			google.maps.event.addListener(marker, 'click', function() {
				infowindow.setContent(`
					<h4> ${ data.title } </h4>
					<strong>Description: </strong> ${ data.description } <br>
					<strong>Habitat:     </strong> ${ data.habitat }     <br>
					<strong>Lat:         </strong> ${ data.lat }         <br>
					<strong>Lng:         </strong> ${ data.lng }         <br>
					<strong>Sampling:    </strong> ${ data.sampling }    <br>
				`);
				infowindow.open(map, marker);
			});

			layers[boxes[i].id]['markers'].push(marker);
		});
	}
}

function zoomMap() {
	var bounds = new google.maps.LatLngBounds();

	for (let i in layers) {
		let layer = layers[i];

		if (layer.visible) {
			for (let j in layer.markers) {
				let marker = layer.markers[j];
				bounds.extend(marker.getPosition());
			}
		}	
	}

	if (!bounds.isEmpty())
		map.fitBounds(bounds);
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

		if (this.checked) {
			let check_class = "chkbox_" + this.id;
			$("." + check_class).prop('checked', true);

			// For bootstrap to show toggle
			$("." + check_class).parent().attr('class', "toggle btn btn-info");

			// Show data on map
			boxes = document.getElementsByClassName(check_class);
			for (let i in boxes) {  // Show all layers
				toggle_layer(true, boxes[i].id);
			}
		}
		else {
			let check_class = "chkbox_" + this.id;
			$("." + check_class).prop('checked', false);

			// For bootstrap to show toggle
			$("." + check_class).parent().attr('class', "toggle btn btn-secondary off");

			// Show data on map
			boxes = document.getElementsByClassName(check_class);
			for (let i in boxes){  // Show all layers
				toggle_layer(false, boxes[i].id);
			}
		}
	})

})
