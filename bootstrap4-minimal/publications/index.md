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
  - "/assets/css/custom/includes/bookmark_list.css"
  - "/assets/css/custom/includes/back_to_top.css"
  - "/assets/css/custom/publications.css"
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


<div id="table-content" class="small" >

	<h1>SBC LTER Publications</h1>

	{% include back_to_top.html %}

	{% include search_bar.html placeholder=page.placeholder %}

	{% include bookmark_list.html category_labels=page.category_labels %}

	{% assign pub_groups = site.data.Website_citation_export | sort: "citation" | reverse | sort: "year" | reverse | group_by: "category" %}

	<div class="tab-content">
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
</div>


<script src="/assets/js/table.js"></script>
<script>
	$(document).ready(function() {
		$('#bookmark-list .nav-link:first').addClass('active');
		$('.section:first').addClass('active');

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
