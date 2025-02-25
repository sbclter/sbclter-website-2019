---
layout: article
title: 'Data Workshop - Data Publication'
description: graduate student workshop on SBC data Inspection
---


<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        /* Global Styles */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Roboto', sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f3f4f6;
            padding: 20px;
        }

        #main-container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* Header Styling */
        header {
            background-color: #0d47a1;
            color: #fff;
            padding: 20px;
            text-align: center;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        header h1 {
            font-weight: 500;
            font-size: 2rem;
        }

        header p {
            font-size: 1rem;
            font-weight: 300;
        }

        /* Navigation Styling */
        nav {
            background-color: #e3f2fd;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 20px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        nav a {
            color: #0d47a1;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }

        nav a:hover {
            background-color: #bbdefb;
        }

        /* Section Styling */
        section {
            background-color: #fafafa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }

        section h2 {
            color: #0d47a1;
            font-weight: 500;
            margin-bottom: 15px;
            font-size: 1.5rem;
        }

        section h4 {
            color: #1e88e5;
            font-weight: 500;
            margin: 20px 0 10px;
            font-size: 1.2rem;
        }

        section p, section ul, section ol {
            font-size: 1rem;
            color: #555;
            line-height: 1.8;
        }

        ul, ol {
            padding-left: 20px;
            margin-top: 10px;
        }

        hr {
            border: 0;
            height: 1px;
            background: #e0e0e0;
            margin: 20px 0;
        }

        /* Link Styling */
        a {
            color: #1e88e5;
            text-decoration: underline;
        }

        a:hover {
            color: #0d47a1;
            text-decoration: none;
        }
 /* Flowchart container */
        .flowchart {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: row;
            gap: 20px;
        }

        /* Flowchart steps */
        .flowchart .step {
            background-color: #e3f2fd;
            color: #0d47a1;
            padding: 20px;
            border-radius: 8px;
            width: 200px;
            text-align: center;
            font-weight: bold;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        /* Arrows */
        .flowchart .arrow {
            font-size: 2rem;
            color: #0d47a1;
        }
        /* Footer Contact Styling */
        section p:last-child, section p a {
            font-size: 0.9rem;
            color: #0d47a1;
        }
        .example-section {
    background-color: #e3f2fd; /* Light blue background */
    padding: 15px;
    border-radius: 8px;
    margin-top: 10px;
}

  .questions {
            background-color: #fff9c4; /* Light yellow background */
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }

        .questions h3 {
            color: #f57f17; /* Darker yellow for heading */
            margin-bottom: 10px;
            font-size: 1.2rem;
        }

        .questions ul {
            list-style-type: none;
            padding-left: 20px;
        }

        .questions li::before {
            content: "•"; /* Bullet symbol */
            color: #f57f17; /* Dark yellow color for bullet */
            font-weight: bold;
            margin-right: 8px;
            font-size: 1.2rem;
        }

    </style>
</head>
<body>

<div id="main-container">
    <header>
        <h1>Data Inspection</h1>
        <p>SBC data workshop, presented by An Bui (PhD student), Kyle Emery (Assistant Researcher), and Li Kui (SBC Information Manager)</p>
    </header>

<nav>
    <a href="#instructor1">Visualizing biodiversity data</a>
    <a href="#instructor2">Geospatial kelp canopy data</a>
    <a href="#instructor3">ChatGPT application</a>
</nav>

<section id="topics">
    <h2>Objectives</h2>
    <ul>
    <li>Develop skills in inspecting and visualizing data using <strong>R</strong>.</li>
    <li>Subsetting and visualizing geospatial data in NetCDF format.</li>
    <li>Leverage AI tools like <strong>ChatGPT</strong> to enhance data inspection efforts.</li>
    </ul>
</section>

<section id="instructor1">
    <h2>An Bui – Downloading and visually exploring biological datasets using SBCLTER time series data with R</h2>

<div>
       
        <p>By the end of this section, you will be able to:</p>
<ul>
    <li>Use R packages to download LTER data to your own computer.</li>
    <li>Visualize data as a first step to exploring LTER datasets.</li>
</ul>
<p> Participants are provided with an R script and a Quarto document to follow along or live code. The rendered Quarto document is <a href="https://an-bui.github.io/sbc-data-workshop/render/visualizing-quarto_RENDER.html" target="_blank">here</a> .</p>
    </div>
</section>

<section id="instructor2">
        <h2>Kyle Emery – Downloading and processing kelp canopy dataset for a specific area of interest using R</h2>

<div>
            <p>Steps for processing and visualizing dataset: </p>
<ol>
    <li>Download the canopy dataset and extract key variables.</li>
    <li>Set a bounding box and subset data within that area.</li>
    <li>Visualize the extent of the data to ensure the correct area was subset.</li>
    <li>Plot the data as a map and scale the display by canopy biomass.</li>
</ol>

<p> Participants are provided with an <a href="/external/Documents/data_help/Kelp_Canopy.R" download="">R script</a> to follow along or live code.</p>
</div>
</section>


<section id="instructor3">
        <h2> Li Kui – Leveraging the AI tool ChatGPT to broaden and speed up data exploration </h2>
<div>
    <p>Demonstrating how <strong>ChatGPT</strong> can assist with data quality checking, cleaning, and quick visualization — all without writing any code. The showcase includes tasks such as:</p>

<ul>
    <li>Generating column summaries</li>
    <li>Listing unique values</li>
    <li>Creating time series plots with regression lines</li>
    <li>Subsetting data</li>
    <li>Converting data between wide and long formats</li>
</ul>

<p><strong>Key Takeaways:</strong></p>
<ul>
    <li><strong>ChatGPT</strong> serves as a supportive tool, not a standalone solution.</li>
    <li>Effective prompts with sufficient detail are crucial for maximizing <strong>ChatGPT’s</strong> utility.</li>
</ul>
</div>
</section>
<hr>

<p>A previous recording of this workshop is available on the <a href="https://www.youtube.com/watch?v=QUYgRfsyncI">SBC YouTube channel</a>. If you have any questions, please contact <a href="mailto:an_bui@ucsb.edu">An Bui</a>, <a href="mailto:emery@ucsb.edu">
Kyle Emery</a>, or <a href="mailto:lkui@ucsb.edu">Li Kui</a> at the Marine Science Institute, UCSB.</p>

</div>

</body>
</html>


