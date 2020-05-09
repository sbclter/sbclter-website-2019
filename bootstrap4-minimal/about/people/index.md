---
layout: article
title: 'SBC LTER People'
description: people invovled in the Santa Barbara Coastal LTER.
placeholder: "Search LTER People ..."
columns:
  - Name
  - Scientific Domain
  - Email
  - Phone
columns_size:
  - 2
  - 4
  - 4
  - 2
dataFilter:
  - commonName
  - scientificDomainString
  - email
  - telephoneNumber
urlkey: databaseID
page_css:
  - "/assets/css/custom/includes/table.css"
  - "/assets/css/custom/includes/search_bar.css"
  - "/assets/css/custom/includes/back_to_top.css"
category_labels:
  Project Lead Investigator: Project Lead Investigator
  Project Co-Investigator: Project Co-Investigators
  Investigator: Investigators
  Project Affiliated Investigator: Affiliated Investigators
  Project Coordinator: Project Coordination
  Information Manager: Information Management
  Education Manager: Education and Outreach
  Post Doctoral Associate: Postdoctoral Associates
  Graduate Student: Graduate Students
  Staff: Staff
---

<div id="table-content" style="display: none;">

  <h1 class="text-long">SBC LTER People</h1>
  <h1 class="text-short">People</h1>

  {% include back_to_top.html %}

	{% include search_bar.html placeholder=page.placeholder %}

	{% assign bio_groups = site.data.people_bios | group_by: "projectRole"| sort: "projectRole" |sort: "commonName" %}

	{% for bios in bio_groups %}
		{% include table.html columns = page.columns
							  columns_size = page.columns_size
							  data = bios
							  dataFilter = page.dataFilter
							  urlkey = page.urlkey
							  category_labels = page.category_labels %}
	{% endfor %}
</div>

<br/>

<script src="/assets/js/table.js"/>

