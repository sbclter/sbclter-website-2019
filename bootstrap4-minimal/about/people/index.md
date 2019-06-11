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
  - 3
  - 4
  - 3
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
category_labels:
  Project Lead Investigator: Project Lead Investigator
  Project Co-Investigator: Project Co-Investigators
  Investigator: Investigators
  Project Affiliated Investigator: Affiliated Investigators
  Project Coordinator: Project Coordinators
  Information Manager: Information Management
  Education Manager: Education and Outreach
  Post Doctoral Associate: Postdoctoral Associates
  Graduate Student: Graduate Students
  Staff: Staff
---

<div id="table-content" style="display: none;">
	{% include search_bar.html placeholder=page.placeholder %}

	{% assign bio_groups = site.data.people_bios | group_by: "projectRole" %}

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

