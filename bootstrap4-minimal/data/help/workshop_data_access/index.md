---
layout: article
title: 'Data Workshop - Data Access and Download'
description: graduate student workshop on SBC data access and download
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
    </style>
</head>
<body>


<div id="main-container">

<header>
        <h1>Data Discovery</h1>
        <p>SBC data workshop, presented by Dr. Li Kui, SBC LTER Information Manager</p>
    </header>

<nav>
        <a href="#data-discovery">SBC Data Catalog</a>
        <a href="#downloading-data">Data Download and Citation</a>
        <a href="#external-data">Other Data Repositories</a>
    </nav>





<section id="topics">
        <h2>Objectives</h2>
        <div class="guidelines">
    <ul>
            <li>Navigate the SBC data catalog and understand metadata structure</li>
            <li>Learn methods for downloading data and proper citation practices</li>
            <li>Explore and access external data repositories</li>
    </ul>
</div>
        <p><em>If you have any questions, feel free to raise your hand at any time, or add them to the <a href="https://docs.google.com/document/d/1XieUYxrydRJfJb--yUrSoiO9KVOgaaJta7Z2jF6FlUM/edit?usp=sharing" target="_blank">Note Document</a>.</em></p>
    </section>

<section id="data-discovery">
        <h2>SBC Data Catalog</h2>
        <p>The SBC data catalog provides a centralized resource where students and researchers can discover, download, and cite datasets necessary for studying coastal ecosystems, facilitating a streamlined and reliable approach to data-driven research. Familiarity with this catalog empowers researchers to leverage a wealth of SBC data for analyses, modeling, and understanding ecological trends.</p>

        <hr>
<h4>How to Find an SBC Dataset?</h4>
        <p>If you know the habitat or measurement type, visit the 
            <a href="https://sbclter.msi.ucsb.edu/data/catalog/" target="_blank">SBC Data Catalog</a>.
        </p>
        <p>If you know specific details like the title, author, or temporal coverage, explore the  
            <a href="https://sbclter.msi.ucsb.edu/data/catalog/search/" target="_blank">data search page</a>.
        </p>
        <p>If data have been published by SBC but are not in the catalog, browse the <a href="https://www.edirepository.org/" target="_blank">Environmental Data Initiative (EDI)</a>. 
        </p> 

        <hr>
<h4>How to Understand the Data?</h4>
    <ul>
        <li><strong>Terminology:</strong> Familiarize yourself with key terms such as "collection", "data package", and "data table."</li>
        <li><strong>Metadata View:</strong> Metadata helps you assess the quality and relevance of data before you dive into complex analysis. Review important metadata elements like the title, abstract, methods, and column definitions.</li>
        <li><strong>Explore Data Table Values:</strong> Examine the values within each data table to understand the dataset's structure and content. Look for the "Explore Data" button on each dataset's landing page in the EDI repository.</li>
    </ul>


<hr>
<div class="questions">
        <h3>Exercise</h3>
        <ul>
            <li>What data did you find that could be useful for your research?</li>
            <li>Were there any challenges in accessing or understanding the data?</li>
        </ul>
    </div>

<hr>
<h4>Integrating physical and biological marine data often presents several challenges:</h4>

<ul>
        <li><strong>Site Name and Location:</strong> Biological surveys typically use 4-letter site codes, whereas physical measurements use 3-letter site codes.</li>
        <li><strong>Resolution Mismatch:</strong> Physical data (like temperature, salinity, and currents) are often collected at high temporal resolutions, while biological data (such as species counts or biomass) may be available at coarser scales.</li>
        <li><strong>Temporal and Spatial Dynamics of Biological Systems:</strong> Biological systems often display significant temporal lags in response to physical changes, while oceanographic conditions can shift abruptly.</li>
    </ul>

    </section>

<section id="downloading-data">
        <h2>Data Download and Citation</h2>
        <p>Once you find the data that you want, downloading data from the SBC catalog or EDI repository is simple, with options for direct downloads or programmatic access via EDI-generated codes.</p>

        <hr>
<h4>How to Download Data Package</h4>
        <ol>
            <li><strong>Direct Download:</strong> Download individual data tables or the entire package as a zipped file.</li>
            <li><strong>Use EDI-Generated Code:</strong> Utilize code snippets provided by the EDI repository for programmatic access to the data package. Look for the "Code Generation" section on each dataset's landing page in the EDI repository.</li>
        </ol>

        <hr>

<h4>Why Do We Cite a Data Package?</h4>

<ul>
    <li>Keep track of the data version used in your analysis</li>
    <li>Credit the data source and its creators</li>
    <li>Link your publication and the cited data package</li>
</ul>

<hr>
<h4>How to Cite the Data Package</h4>
        <p><strong>Incorrect:</strong> Citing only the SBC data catalog page or SBC website.</p>
        <p><strong>Correct:</strong> Cite the dataset used in your analysis, including authors, year, title, repository, and DOI.</p>

<div class="example-section">
<strong>Example:</strong>
<p>In the main manuscript: "Data were published in the Environmental Data Initiative repository (Reed and Miller 2024)."</p>
<p>Data Availability Statement: "Data were published in the Environmental Data Initiative repository, with DOI 10.6073/pasta/ff9a71788471df002469598b432f3cae."</p>
<p>Reference: <a href="https://doi.org/10.6073/pasta/ff9a71788471df002469598b432f3cae">Reed, D, R. Miller. 2024. SBC LTER: Reef: Kelp Forest Community Dynamics: Fish abundance. Environmental Data Initiative. https://doi.org/10.6073/pasta/92003d368dfe121f6709ad1507412f66</a>
</p>
 </div>
    </section>

<section id="external-data">
        <h2>External Data Repositories</h2>
         <p>Dr. Li Kui, the SBC information manager, has co-taught <a href="https://lter.github.io/ssecr/" target="_blank">SSECR short course</a> via <a href="https://www.nceas.ucsb.edu/" target="_blank">NCEAS</a>. The Data Discovery module includes a range of <a href="https://lter.github.io/ssecr/mod_data-disc.html#data-repositories" target="_blank">Data Repositories</a> and various <a href="https://lter.github.io/ssecr/mod_data-disc.html#downloading-data" target="_blank"> Data Downloading Guide</a>. 
        </p>
        
        <hr>

<div class="questions">
        <h3>Exercise</h3>
        <p>We have a hypothetical research scenario examining the effects of marine heatwaves on kelp forest dynamics. Which data repositories would be most useful for this research? </p>
    </div>
    <hr>
<p>If you have any questions, please contact <a href="mailto:lkui@ucsb.edu">Dr. Li Kui</a> at the Marine Science Institute, UCSB.</p>
 </section>

</div>
    
</body>
</html>


