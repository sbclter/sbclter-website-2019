---
layout: article
title: 'Data Package Search'
description: page description here.
page_css:
  - /assets/css/custom/data/catalog.css
placeholder: "Search datasets ..."

# Excluding footer search because the URL parameters PASTA uses interfere with the ones footer search uses
exclude_footer_search: true
---


<h1>{{ page.title }}</h1>

<div id="search-container">
        {% include data/PASTA_search.html %}
</div>

<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU"
  crossorigin="anonymous">
<link href="{{ site.baseurl }}/assets/css/custom/data/search.css" rel="stylesheet" type="text/css">
<link href="{{ site.baseurl }}/assets/css/custom/data/auto-complete.scss" rel="stylesheet" type="text/css">
<script src="{{ site.baseurl }}/assets/js/pasta/cors.js"></script>
<script src="{{ site.baseurl }}/assets/js/pasta/pagination.js"></script>
<script src="{{ site.baseurl }}/assets/js/pasta/auto-complete.min.js"></script>
<script src="{{ site.baseurl }}/assets/js/pasta/ucsv-1.2.0.min.js"></script>
<script src="{{ site.baseurl }}/assets/js/pasta/pasta_lookup.js"></script>
<script src="{{ site.baseurl }}/assets/js/pasta/pasta.js"></script>

<script>
	// Set the API key from Jekyll config if available
	if (typeof PASTA_CONFIG !== 'undefined') {
		PASTA_CONFIG["EdiApiAccessKey"] = "{{ site.edi_api_key }}";
	}
</script>

<script>
$(function() {
	console.log(window.location);
	$('#search-url-section .text').val(window.location.href);
})
</script>