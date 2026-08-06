---
layout: article
title: 'Data Package'
description: detail of a single data package.
page_css:
  - /assets/css/custom/data/package.css
---

<div id="detail-container">
	{% include data/package.html %}
</div>


<script src="https://maps.googleapis.com/maps/api/js?key={{site.google_maps_api_key}}"></script>
<script>var EDI_API_KEY = "{{site.edi_api_key}}";</script>
<script src="{{ site.baseurl }}/assets/js/ext/xml2json.js"></script>

<script src="{{ site.baseurl }}/assets/js/package/summary.js"></script>
<script src="{{ site.baseurl }}/assets/js/package/people.js"></script>
<script src="{{ site.baseurl }}/assets/js/package/coverage.js"></script>
<script src="{{ site.baseurl }}/assets/js/package/method.js"></script>
<script src="{{ site.baseurl }}/assets/js/package/file.js"></script>
<script src="{{ site.baseurl }}/assets/js/package/main.js"></script>