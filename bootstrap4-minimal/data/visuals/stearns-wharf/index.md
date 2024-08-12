---
layout: article
title: 'Current tide and ocean conditions '
description: page description here.
page_css:
  - /assets/css/custom/data/visuals.css
---
<!-- head is for tide chart only-->
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tide Predictions</title>
    <!-- Include Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Include the Date Adapter for Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns"></script>
    <!-- Include the Chart.js Annotation Plugin -->
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation"></script>
    <!-- Include the external JavaScript file -->
    <script src="/assets/js/tideChart.js"></script>
</head>


<div id="graph-container">
    <h2>Current Conditions - Stearns Wharf</h2>
    <div class="row-container">
        <div class="full-width">
            <div id="shore-graph">
                <div id="graph-loader" class="loader"></div>
            </div>
            <div class="tooltip"></div>
        </div>
        <div id="graph-lines">
            <div class="row-container line-section" >
                <div id="current-time" class="absolute-right">&nbsp;</div>
                <div class="latest-value">Current Values</div>
            </div>
            <div class="row-container line-section" >
                <div style="width: 100%; display: flex; column-gap: 0.5rem;">
                    <div id="temperature-btn" class="btn btn-color line-btn" onclick="toggleGraph('temperature')">
                        Temperature
                    </div>
                    <input type="checkbox" data-toggle="toggle" data-on="°F" data-off="°C" data-onstyle="temperature" data-offstyle="temperature" onchange="toggleCelsius(event)">
                </div>
                <div id="temperature-latest" class="latest-value btn">&nbsp;</div>
            </div>
            <div class="row-container line-section">
                <div id="chlorophyll-btn" class="btn btn-color line-btn" onclick="toggleGraph('chlorophyll')">
                    Chlorophyll (&mu;g / Liter)
                </div>
                <div id="chlorophyll-latest" class="latest-value btn">&nbsp;</div>
            </div>
            <div class="row-container line-section">
                <div id="pressure-btn" class="btn btn-color line-btn" onclick="toggleGraph('pressure')">
                    Pressure (Decibars)
                </div>
                <div id="pressure-latest" class="latest-value btn">&nbsp;</div>
            </div>
            <div class="row-container line-section">
                <div id="salinity-btn" class="btn btn-color line-btn" onclick="toggleGraph('salinity')">
                    Salinity (PSU, ~ppt)
                </div>
                <div id="salinity-latest" class="latest-value btn">&nbsp;</div>
            </div>
            <div>
                Click label to turn a display on/off. Y-axis scaling is automatic
            </div>       
        </div>
    </div>
        <br>
    <p><a href="http://piscoweb.org" onmouseover="PISCO">Partnership for Interdisciplinary Studies of Coastal Oceans (PISCO)</a> and <a href="http://sccoos.org" onmouseover="SCCOOS">Southern California Coastal Ocean Observing System (SCCOOS)</a> collaborate with SBC LTER on collection of data at Stearns Wharf</p>
    <br>
    <hr>
   <h2>Tide Predictions - Santa Barbara</h2>
    <canvas id="tideChart" width="400" height="200"></canvas>
    <br>
 <p><a href="https://tidesandcurrents.noaa.gov/noaatidepredictions.html?id=9411340" >NOAA Tides & Currents</a> provides tide predictions for Santa Barbara</p>


</div>


<script src="https://code.highcharts.com/stock/highstock.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
<script src="https://d3js.org/d3.v5.min.js"></script>
<script src="/assets/js/shore_graph.js"/></script>

