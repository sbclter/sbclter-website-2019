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
table_font_size: 12
page_css:
  - "/assets/css/custom/includes/table.css"
  - "/assets/css/custom/includes/search_bar.css"
category_labels:
  Article:       Articles
  Book:          Books
  Incollection:  Book Chapters
  Inproceedings: Conference Proceedings
  Mastersthesis: Masters Theses
  phdthesis:     PhD Dissertations
  Techreport:    Technical Reports
  Presentation:  Presentations
urlkey: true
---

<h1>SBC LTER Publications</h1>


<div id="table-content" class="small" >
	{% include search_bar.html placeholder=page.placeholder %}

	{% include bookmark_list.html category_labels=page.category_labels %}

	{% assign pub_groups = site.data.Website_citation_export | group_by: "category" | sort: "name" %}

	{% for pubs in pub_groups %}
		{% include table.html columns = page.columns
							  columns_size = page.columns_size
							  data = pubs
							  dataFilter = page.dataFilter
							  category_labels = page.category_labels
							  table_font_size = page.table_font_size
							  urlkey = page.urlkey %}
	{% endfor %}
</div>


<script src="/assets/js/table.js"></script>
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
	    $('.table').DataTable({ retrieve: true }).order([[ 0, "desc"], [1, "asc"]]).draw();
	});
</script>
