var map;
var src = 'https://developers.google.com/maps/documentation/javascript/examples/kml/westcampus.kml';

function initMap() {
  var layers = []

  for()


  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 2,
    mapTypeId: 'terrain'
  });

  var kmlLayer = new google.maps.KmlLayer(src, {
    suppressInfoWindows: true,
    preserveViewport: false,
    map: map
  });
  kmlLayer.addListener('click', function(event) {
    var content = event.featureData.infoWindowHtml;
    var testimonial = document.getElementById('capture');
    testimonial.innerHTML = content;
  });
}
