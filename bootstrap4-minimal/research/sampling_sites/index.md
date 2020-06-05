---
layout: article
title: 'Page title here'
description: page description here.
columns:
  - Habitat
  - Measurements
  - Frequency
  - Initiated
  - Show
dataFilter: label
page_css:
  - "/assets/css/custom/layouts/gmap.css"
  - "/assets/css/custom/includes/layers_table.css"
  - "/assets/css/custom/includes/table.css"
---

<h1>Time Series Sampling Sites</h1>


{% include gmap.html %}

{% assign layer_groups = site.data.sbcMapLayer_test | sort: "id" | sort: "habitatLabel" | group_by:"habitatName" %}
{% include layers_table.html
	columns=page.columns
	data=layer_groups
	dataFilter=page.dataFilter %}

<script src="/assets/js/gmap.js"></script>

<!-- Current API is just for development, need a new key -->
<script src="https://maps.googleapis.com/maps/api/js?key={{site.google_maps_api_key}}&callback=initMap"></script>
