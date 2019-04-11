---
layout: article
title: 'SBC LTER People'
description: people invovled in the Santa Barbara Coastal LTER.

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

<div class="row">
    <div class="col-md-7">
        <div id="people" class="internal-link"></div>
        {% include people_list.html %}
    </div>
</div>

