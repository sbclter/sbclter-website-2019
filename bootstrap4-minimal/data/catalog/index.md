---
layout: article
title: 'Page tltle here'
description: page description here.
page_css:
  - /assets/css/custom/data/catalog.css
placeholder: "Search datasets ..."
---

<div id="main-container">

	<div id="title-container">
		<h1>Data Catalog</h1>
		<a id="advance-search-btn" class="btn" href="{{page.url}}search"> Advanced Search </a>
	</div>

	<!--
	plan:
	intro page with browse, search forms
	individidual dataset display pulls XML from pasta, uses local XSL to transform to XML.
	probably most complex part of the website.
	-->

	<div id="filter-container">
		{% include data/data_filter.html data=site.data.dataFilters %}
	</div>
	<div id="display-container" class="hide">
		{% include data/data_table.html data=site.data.dataCollections %}
	</div>
</div>

<script src="/assets/js/catalog.js"/></script>
<script src="/assets/js/simple_search.js"/></script>
