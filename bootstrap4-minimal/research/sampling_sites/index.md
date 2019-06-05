---
layout: article
title: 'Page title here'
description: page description here.
columns:
  - Habitat
  - Measurements
  - Show
dataFilter:
  - label
page_css:
  - "/assets/css/custom/layouts/gmap.css"
  - "/assets/css/custom/includes/layers_table.css"
---

<h1>Time Series Sampling Sites</h1>


<p>The page we are replacing:
<ul>
<li>http://sbc.lternet.edu/sites/sampling/</li>
</ul>

{% include gmap.html %}


{% assign layer_groups = site.data.sbcMapLayers | group_by:"habitatName" %}
{% include layers_table.html columns=page.columns data=layer_groups dataFilter=page.dataFilter%}

<br/>
<!-- Current API is just for development, need a new key -->
<script src="/assets/js/gmap.js"/></script>

<script async defer
src="https://maps.googleapis.com/maps/api/js?key={{site.google_maps_api_key}}&callback=initMap">
// </script>
