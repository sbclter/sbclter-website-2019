<?xml version="1.0"?>

<!-- add a google map using geoCov info mob 10Oct2012 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" encoding="iso-8859-1"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    indent="yes" />  
    
  <!-- javascript example:  
  http://jamestombs.co.uk/2011-05-05/creating-markers-info-windows-using-google-maps-javascript-api-v3 -->
  
  <!-- as of oct2012, handles only bounding boxes at the dataset level. 
    if N=S and E=W, a marker is displayed. otherwise, a polygon.
  still to add: 1) datasetGPolygonOuterRing and ExclusionRing (for MCR). EML does not seem to handle lines 
  2) the KML file that some people (GCE) add via references. might be a different template.
  -->
  
    
    <!-- style the identifier and system -->
  <xsl:template name="geoCovMap">
    <xsl:param name="index"/>
    <xsl:param name="maptabledefaultStyle"/>
    <xsl:param name="mapfirstColStyle"/>
    <xsl:param name="mapsecondColStyle"/>
    <xsl:param name="contextURL"/>
    <xsl:param name="currentmodule"/>
    <xsl:param name="packageID">
      <xsl:value-of select="../@packageId"/>
    </xsl:param>
    
         
    <script type="text/javascript"
      src="http://maps.googleapis.com/maps/api/js?sensor=false">
    </script>
    
    <script type="text/javascript">
  
  var map; 
  var infowindow;  
  var curr_infowindow;

  var marker;
  var markers = [];
  var pt_locations = [];
  var pt_titles = [];
  var pt_info =[];
  
  var boundingPolygon;
  var boundingPolygons = [];
  var poly_locations = [];
  var poly_titles = [];
  var poly_info =[];

  // get the data into arrays.
  <xsl:for-each select="coverage/geographicCoverage">
    var nbc = <xsl:value-of select="boundingCoordinates/northBoundingCoordinate"/>;
    var sbc = <xsl:value-of select="boundingCoordinates/southBoundingCoordinate"/>;
    var wbc = <xsl:value-of select="boundingCoordinates/westBoundingCoordinate"/>;
    var ebc = <xsl:value-of select="boundingCoordinates/eastBoundingCoordinate"/>;
    
    var gc_id = '<xsl:value-of select="@id"/>';
    var gc_descr = "<xsl:value-of select="normalize-space(geographicDescription)"/>";
    
    //logic to determine if we are dealing with a single point or a polygon
    if (nbc == sbc &amp;&amp; wbc == ebc) {
      // single point, will use a marker
      myLat = nbc; 
      myLon = wbc;
      var point = new google.maps.LatLng(myLat,myLon);
      pt_locations.push(point);
      
      // the id if there is one - id is optional
      if( gc_id ) {
      pt_titles.push(gc_id);
      } else {
      // if no id, titles[i] will be null 
      pt_titles.push(' ');
      }
      
      // the description for the info bubble
      pt_info.push(gc_descr);

    } else {
     // not a point, will use a polygon
    var boundingCoordinates = [
      new google.maps.LatLng(nbc,wbc),
      new google.maps.LatLng(nbc,ebc),
      new google.maps.LatLng(sbc,ebc),
      new google.maps.LatLng(sbc,wbc)
    ];
    poly_locations.push(boundingCoordinates);
    
      // the id if there is one - id is optional
      if( gc_id ) {
      poly_titles.push(gc_id);
      } else {
      // if no id, titles[i] will be null 
      poly_titles.push(' ');
      }
      
      // the description for the info bubble
      poly_info.push(gc_descr);
    
    } // closes if n=s and w=s 

  </xsl:for-each>

  
  // MAP FUNCTIONS BELOW HERE.
  function initialize_map() {
    var myCenter = new google.maps.LatLng(34.25,-120.00);
    var myOptions = {
      zoom: 8,
      center: myCenter,
      mapTypeId: google.maps.MapTypeId.TERRAIN,
      streetViewControl: false 
    };
    
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  
    // add the site-markers 
    for (var i = 0; i &lt; pt_locations.length; i++) {
      markers[i] = createMarker(pt_locations[i], pt_info[i], pt_titles[i], map);      
    } 
    
    // add the polygons
    for (var j = 0; j &lt; poly_locations.length; j++) {
      boundingPolygons[j] = createPolygon(poly_locations[j], poly_info[j], poly_titles[j], map);      
    } 
    
  } 
        
        
   function createMarker(point, pt_info, pt_title, map) {
     var marker = new google.maps.Marker({
       position: point,
       map: map,         
       title: pt_title       
     });
             
     var infowindow = new google.maps.InfoWindow({
       content: pt_info
     });
        
     google.maps.event.addListener(marker, "click", function() {
       if (curr_infowindow) {curr_infowindow.close(); }
       curr_infowindow = infowindow;
       infowindow.open(map, marker); 
     });
     
     return marker;
   }   
   
   
   function createPolygon (poly_coords, poly_info, poly_title, map) {      
     var boundingPolygon = new google.maps.Polygon({
       paths: poly_coords,
       strokeColor: "#FF0000",
       strokeOpacity: 0.8,
       strokeWeight: 2,
       fillColor: "#FF0000",
       fillOpacity: 0.1
     });
  
     var infowindow = new google.maps.InfoWindow({
       content: poly_info
     });
  
     // add a listener 
     google.maps.event.addListener(boundingPolygon, 'click', function(event) {
       if ( curr_infowindow) {curr_infowindow.close(); }
       curr_infowindow = infowindow;
       infowindow.setPosition(event.latLng);
       infowindow.open(map);
     });
    
     boundingPolygon.setMap(map); 
   }
   
   
    </script> 

  </xsl:template>
    
    
 </xsl:stylesheet>
