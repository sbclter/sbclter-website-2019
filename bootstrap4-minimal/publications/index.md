---
layout: article
title: Publications
description: publications from the Santa Barbara Coastal LTER.

clickable: 1
placeholder: "Search LTER Publications ..."
columns:
  - Year
  - Citation
columns_size:
  - 1
  - 11
dataFilter:
  - year
  - citation
page_css:
  - "/assets/css/custom/includes/table.css"
  - "/assets/css/custom/includes/search_bar.css"
category_labels:
  Article:       Articles
  phdthesis:     PhD Thesis
  Mastersthesis: Masters Thesis
  Incollection:  Book Chapters
  Book:          Books
  Inproceedings: Conference Proceedings

---

<h1>SBC LTER Publications</h1>


<div id="table-content" >
	{% include search_bar.html placeholder=page.placeholder %}

	{% assign pub_groups = site.data.Website_citation_export | group_by: "category" | sort: "category" %}

	{% for pubs in pub_groups %}
		{% include table.html columns = page.columns
							  columns_size = page.columns_size
							  data = pubs
							  dataFilter = page.dataFilter
							  category_labels = page.category_labels %}
	{% endfor %}
</div>


<script>
	$(document).ready(function() {
		$('tbody').each(function() {
			$(this).find('.row').each(function() {
				var doi = $(this).children().last().text().split("DOI: ")[1];
				if (doi) {
					$(this).addClass('clickable-row');
					$(this).attr('data-href', `http://dx.doi.org/${ doi }`);
					$(this).css('background-color: ');
				}
			});
		});
	});
</script>
<script src="/assets/js/table.js"></script>
