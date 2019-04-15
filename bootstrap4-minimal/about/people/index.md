---
layout: article
title: 'SBC LTER People'
description: people invovled in the Santa Barbara Coastal LTER.
columns:
  - Title
  - Role
  - Class
  - Image
  - Bio
---

<h1>People</h1>

<p> people index is a simple list of people, organized by role. content belongs in a yaml file, pulled from postgres db. It's likely that grouping can be done with template logic (ie, PIs at the top, etc)</p>

<p>The pages we are replacing (note the find-people forms):
<ul>
<li>http://sbc.lternet.edu/cgi-bin/ldapweb2012.cgi</li>
<li>http://sbc.lternet.edu/cgi-bin/ldapweb2012.cgi?stage=showindividual&lter_id=dreed</li>
</ul>


<p>Goals for people section:
<ol>
<li> each person's name links to their individual bio-page, with an image. (no pragraph > no link)</li>
<li> there is a form at the top to filter/search for an individual by name, and filter this same list </li>
</ol>
</p>

{% include search_bar.html %}

{% assign bio_groups = site.data.bios | group_by: "employeeType" %}

{% for bios in bio_groups %}
	<h3>{{ bios.name }}</h3>
	{% include table.html columns=page.columns data=bios.items %}
{% endfor %}

<br/>


<script src="/assets/js/table.js"/>


markdown code block: 

```
my @attrs = [ 'surname', 
		'givenName', 
		'commonName', 
		'email', 
                'postalAddress',
		'telephoneNumber', 
                'employeeType',
		'projectRole', 
		'labeledURI',
                'databaseID',
		'scientificDomainStr',
		'scientificDomainText',
		'profileText',
		'degreeProgram',
		'imageFile'		
	      ];
```


```
'surname', 			# used for filter/searching
'givenName',			
'commonName',			
'email',
'postalAddress',		# a string, with line breaks as html <br/>
'telephoneNumber',		# optional
'employeeType',			
'projectRole',			# used for grouping on main page (contr. vocab). 1:many
'labeledURI',			# optional
'databaseID',			# used to deliver profile pages, in a param
'scientificDomainStr',		# short string, for main page
'scientificDomainText',		# longer string, for profile page	
'profileText',			# profile page. must be present to create a anchor tag
'degreeProgram',		# optional, applies to students only
'imageFile'			# optional
              ];
```
