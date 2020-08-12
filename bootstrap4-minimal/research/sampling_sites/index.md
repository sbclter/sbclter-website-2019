---
layout: article
title: 'Page title here'
description: page description here.
columns:
  - Habitat
  - Measurements
  - Frequency
  - Initiated
  - Show
dataFilter: label
collections:
  sbcMapLayer_test:

page_css:
  - "/assets/css/custom/layouts/gmap.css"
  - "/assets/css/custom/includes/layers_table.css"
  - "/assets/css/custom/includes/table.css"
---

<h1>Time Series Sampling Sites</h1>

<div id="secondary-container">
  {% include gmap.html %}

  {% assign layer_groups = site.data.sbcMapLayer | sort: "id" | sort: "habitatLabel" | group_by:"habitatName" %}

  <div class="table-section pull-left">
    <table class="table">
      <thead id="table_header_{{layer_groups.name}}">
        <tr class="title-row">
          {% for column in page.columns %}
            <th>{{ column }}</th>
          {% endfor %}
        </tr>
      </thead>
      <tbody id="myTable">
        {% for group in layer_groups %}
          {% if group.name == 'watershed' %}
            {% include layers_table.html
              group=group
              dataFilter=page.dataFilter %}
          {% endif %}
        {% endfor %}
        {% for group in layer_groups %}
          {% if group.name == 'reef' %}
            {% include layers_table.html
              group=group
              dataFilter=page.dataFilter %}
          {% endif %}
        {% endfor %}
        {% for group in layer_groups %}
          {% if group.name == 'nearshore' %}
            {% include layers_table.html
              group=group
              dataFilter=page.dataFilter %}
          {% endif %}
        {% endfor %}
        {% for group in layer_groups %}
          {% if group.name == 'beach' %}
            {% include layers_table.html
              group=group
              dataFilter=page.dataFilter %}
          {% endif %}
        {% endfor %}
      </tbody>
    </table>
  </div>

  <!-- Popup Modal -->
  <div id="layer-modal" class="modal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-body">
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://unpkg.com/@google/markerclustererplus@4.0.1/dist/markerclustererplus.min.js"></script>
<script src="/assets/js/gmap.js"></script>

<!-- Current API is just for development, need a new key -->
<script src="https://maps.googleapis.com/maps/api/js?key={{site.google_maps_api_key}}&callback=initMap"></script>
