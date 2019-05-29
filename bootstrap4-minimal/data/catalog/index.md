---
layout: article
title: 'Page tltle here'
description: page description here.
page_css:
  - /assets/css/custom/data/catalog.css
placeholder: "Search datasets ..."
---

<h1>Data Catalog</h1>

<!--
plan:
intro page with browse, search forms
individidual dataset display pulls XML from pasta, uses local XSL to transform to XML.
probably most complex part of the website.
-->

<div id="filter-container">
	{% include data/data_filter.html data=site.data.dataFilters %}
</div>
<!-- {% include search_bar.html placeholder=page.placeholder %} -->
<div id="display-container">
	{% include data/data_table.html data=site.data.dataCollections %}
</div>

<script src="/assets/js/catalog.js"/></script>
