---
layout: article
title: 'Current Conditions - Stearns Wharf'
description: page description here.
page_css:
  - /assets/css/custom/data/visuals.css
---

<div id="graph-container">
    <h1>{{ page.title }}</h1>

    <div class="row-container">

        <div id="collab-section">
            <p>These groups collaborate with SBC LTER on collection of data at Stearns Wharf</p>
            <div>
                <a href="http://piscoweb.org" onmouseover="PISCO">Partnership for Interdisciplinary Studies of Coastal Oceans (PISCO)</a>
                <br />
                <a href=""><img src="/assets/img/pisco_sm2.png"/></a>
            </div>
            <div>
                <a href="http://sccoos.org" onmouseover="SCCOOS">Southern California Coastal Ocean Observing System (SCCOOS)</a>
                <br />
                <a href=""><img src="/assets/img/sccoos_sm2.jpg"/></a>
            </div>
        </div>

        <div class="full-width">
            <div id="time-change-panel" class="btn-group btn-group-toggle" data-toggle="buttons">
                <label id="one-day"      class="btn btn-primary"        onclick="updateData(1)">  <input type="radio" name="options" autocomplete="off"> 1 Day </label>
                <label id="one-week"     class="btn btn-primary active" onclick="updateData(7)">  <input type="radio" name="options" autocomplete="off" checked> 1 Week </label>
                <label id="one-month"    class="btn btn-primary"        onclick="updateData(31)"> <input type="radio" name="options" autocomplete="off"> 1 Month </label>
                <label id="three-months" class="btn btn-primary"        onclick="updateData(93)"> <input type="radio" name="options" autocomplete="off"> 3 Months </label>
            </div>
            <div id="shore-graph">
                <div id="graph-loader" class="loader"></div>
            </div>

            <p><a href="https://tidesandcurrents.noaa.gov/noaatidepredictions.html?id=9411340&legacy=1"> Tide predictions for Santa Barbara from NOAA</a></p>
            <div class="tooltip"></div>
        </div>

        <div id="graph-lines">
            <div class="row-container line-section" >
                <div id="current-time" class="absolute-right">&nbsp;</div>
                <div class="latest-value">Latest</div>
            </div>

            <div class="row-container line-section" >
                <div style="width: 100%">
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
        </div>
    </div>
</div>

<script src="https://d3js.org/d3.v5.min.js"></script>
<script src="/assets/js/shore_graph.js"/></script>
