---
layout: article
title: 'Data Package'
description: detail of a single data package.
page_css:
  - /assets/css/custom/data/index.css
---

<!--
notes. this is the page that displays a single dataset.
it accepts a packageId as scope.docid (no revision) so intended for the 
most recent revision only,  

Intended url then, is 
sbclter.msi.ucsb.edu/data/catalog/package/?package=____
or perhaps:
sbclter.msi.ucsb.edu/data/catalog/package/?id=____


to do:
1. complete the data_detail template
2. send requests for a single dataset to this page (currently goes to EDI) 
2. should css be retitled? probably this is package.css

3. consider a different layout, not article.
4. consider the id. we use only scope_docid, not the entire id. may want to think what we call that. 
5. get the package id into the page title. 
-->




<div id="detail-container">
	{% include data/data_detail.html %}
</div>


<script src="https://maps.googleapis.com/maps/api/js?key={{site.google_maps_api_key}}"></script>

<script src="/assets/js/ext/xml2json.js"></script>
<script src="/assets/js/catalog_detail.js"></script>

