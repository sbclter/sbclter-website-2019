---
layout: article
title: 'Page title here'
description: page description here.
columns:
  - Habitat
  - Measurements
dataFilter:
  - label
page_css:
  - "/assets/css/custom/layouts/gmap.css"
  - "/assets/css/custom/includes/layers_table.css"
---

<h1>H1 header</h1>

<p>page will be a map of sampling sites - using google (javascript). map info can come from _content dir.  </p>


<p>The page we are replacing:
<ul>
<li>http://sbc.lternet.edu/sites/sampling/</li>
</ul>
<p>TBD: is content in XML (as used by current map), or yaml (which might be easier to generate from postgres. </p>
<p>It would be best if it the content is in yaml as this cooperate better with jekyll</p>

{% include gmap.html %}


{% assign layer_groups = site.data.research.sampling.sbcMapLayers | group_by:"habitatName" %}
{% include layers_table.html columns=page.columns data=layer_groups dataFilter=page.dataFilter%}


<!-- Current API is just for development, need a new key -->
<script src="/assets/js/gmap.js"/>
<script async defer
src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap">
</script>