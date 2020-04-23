---
layout: article
title: 'Current Conditions - Stearns Wharf'
description: page description here.
page_css:
  - /assets/css/custom/data/visuals.css
---

	
	
	 
<div id="main-container" hidden>
<div class="row">
    <div class="col-md-2">
        <p>These groups collaborate with SBC LTER on collection of data at Stearns Wharf</p>
        <ul>                                                                                                                                                                    
            <li class="">                                                                                                 
                <a href="http://piscoweb.org" onmouseover="PISCO">Partnership for Interdisciplinary Studies of Coastal Oceans (PISCO)</a>
                <br />
                <a href=""><img src="/assets/img/pisco_sm2.png"/></a>                                                    
            </li>                                                                                                                       
            <li class="">                                                                                                 
                <a href="http://sccoos.org" onmouseover="SCCOOS">Southern California Coastal Ocean Observing System (SCCOOS)</a>       
                <br />                                                                                                                  
                <a href=""><img src="/assets/img/sccoos_sm2.jpg"/></a>                                                   
            </li>                                                                                                                       
        </ul>
    </div>                                                                                                                 
        <div class="col-md-6"> 
            <h2>Under Construction</h2>
              <img class="img-thumbnail img-responsive img-center" src="/assets/img/under_construction.jpg"  alt="Coming soon..." />
        </div>  
        <div class="col-md-4 my-auto">
        <p>Custom view coming soon. Please visit SCCOOS at: 
    <a href="http://www.sccoos.org/data/autoss/timeline/?main=single&station=stearns_wharf">http://www.sccoos.org/data/autoss/timeline/?main=single&station=stearns_wharf</a>
    </p>
        </div>
               
 <!-- iframe to sccoos no longer works (we are on https, they are not) -->                                                
  <!--                                       
    <div class="col-md-10">                                                                                                                                                                    
        <iframe  height="800px" width="1000px" src="http://www.sccoos.org/data/autoss/timeline/?main=single&station=stearns_wharf">
                                                                    
        </iframe>                                                                                                 
    </div>

 -->
</div>
</div>

<div id="graph-container">
    <h1>{{ page.title }}</h1>

    <div id="graph-time-range">
        <div id="one-day"       class="btn" onclick="updateData(event.target, 1)"> 1 Day </div>
        <div id="one-week"      class="btn" onclick="updateData(event.target, 7)"> 1 Week </div>
        <div id="one-month"     class="btn" onclick="updateData(event.target, 31)"> 1 Month </div>
        <div id="three-months"  class="btn" onclick="updateData(event.target, 93)"> 3 Months </div>

        <div id="current-time" class="absolute-right"></div>
    </div>

    <div id="graph-lines">
        <div id="pressure-btn"     class="btn btn-color" onclick="toggleGraph('pressure')"> Pressure (Decibars) </div>
        <div id="temperature-btn"  class="btn btn-color" onclick="toggleGraph('temperature')"> Temperature (°C) </div>
        <div id="chlorophyll-btn"  class="btn btn-color" onclick="toggleGraph('chlorophyll')"> Chlorophyll (&mu;g / Liter) </div>
        <div id="salinity-btn"     class="btn btn-color" onclick="toggleGraph('salinity')"> Salinity (PSU, ~ppt) </div>

        <div id="temp-change-panel" class="btn-group btn-group-toggle absolute-right" data-toggle="buttons">
            <label class="btn btn-primary active" onclick="toggleCelsius(true)">
                <input type="radio" name="options" autocomplete="off" checked> °C
            </label>
            <label class="btn btn-primary" onclick="toggleCelsius(false)">
                <input type="radio" name="options" autocomplete="off"> °F
            </label>
        </div>
    </div>

    <div id="shore-graph"></div>

    <p>Tide predictions for Santa Barbara: <a href="https://tidesandcurrents.noaa.gov/noaatidepredictions.html?id=9411340&legacy=1">Tides and currennts at NOAA</a></p>
</div>

<script src="https://d3js.org/d3.v5.min.js"></script>
<script src="/assets/js/shore_graph.js"/></script>
