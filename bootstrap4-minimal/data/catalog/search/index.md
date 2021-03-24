---
layout: article
title: 'Data Package Search'
description: page description here.
page_css:
  - /assets/css/custom/data/catalog.css
placeholder: "Search datasets ..."
---


<h1>{{ page.title }}</h1>

<div id="search-container">
        {% include data/PASTA_search.html %}
</div>

<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU"
  crossorigin="anonymous">
<link href="/assets/css/custom/data/search.css" rel="stylesheet" type="text/css">
<link href="/assets/css/custom/data/auto-complete.scss" rel="stylesheet" type="text/css">
<script src="/assets/js/pasta/cors.js"></script>
<script src="/assets/js/pasta/pagination.js"></script>
<script src="/assets/js/pasta/auto-complete.min.js"></script>
<script src="/assets/js/pasta/ucsv-1.2.0.min.js"></script>
<script src="/assets/js/pasta/pasta_lookup.js"></script>
<script src="/assets/js/pasta/pasta.js"></script>

<script>
$(function() {
	console.log(window.location);
	$('#search-url-section .text').val(window.location.href);
})
</script>
