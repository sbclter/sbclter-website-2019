---
layout: article
title: 'Page tltle here'
description: page description here.
page_css:
  - /assets/css/custom/data/catalog.css
  - /assets/css/custom/includes/back_to_top.css
placeholder: "Search datasets ..."
---

<div id="main-container">

	{% include back_to_top.html %}

	<div id="title-container">
		<h1>Data Catalog</h1>
		<div>
			<button type="button" id="show_button" class="btn">Show All Collections</button>	
		    <button type="button" id="clear_button" class="btn">Reset</button>
			<a id="advance-search-btn" class="btn" href="{{page.url}}search">Search Datasets Individually</a>
		</div>
	</div>


	<div id="filter-container">
		{% include data/data_filter.html data=site.data.dataFilters %}
	</div>
	<div id="display-container" class="hide">
		{% include data/data_table.html data=site.data.dataCollections %}
	</div>
</div>

<script src="/assets/js/catalog.js"/></script>
<script src="/assets/js/simple_search.js"/></script>
