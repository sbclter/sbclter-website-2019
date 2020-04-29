---
layout: article
title: 'Current Conditions - Stearns Wharf'
description: page description here.
page_css:
  - /assets/css/custom/data/visuals.css
---

<h1>{{ page.title }}</h1>

	
	 
<div id="main-container">
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
        
        <hr />
    <p><a href="https://tidesandcurrents.noaa.gov/noaatidepredictions.html?id=9411340&legacy=1"> Tide predictions for Santa Barbara from NOAA</a></p>
    </div>                                                                                                                 
        
        
        
               
                                       
    <div class="col-md-10">                                                                                                                                                                    
              <div id="graph-container">

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
              
              
                                                                                  
    </div>


</div>
</div>



</div>

<script src="https://d3js.org/d3.v5.min.js"></script>
<script src="/assets/js/shore_graph.js"/></script>
