---
layout: article
title: 'Data Workshop - Data Publication'
description: graduate student workshop on SBC data publication
---


<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SBC Data Access & Download</title>
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
        <h1>Data Publication</h1>
        <p>SBC data workshop, presented by Dr. Li Kui, SBC LTER Information Manager</p>
    </header>

<nav>
    <a href="#reason">Why Publish Your Data</a>
    <a href="#publishing-data">Steps to Prepare Data for Publication</a>
    <a href="#external-data">Alternative Publishing Methods</a>
</nav>

<section id="topics">
    <h2>Objectives</h2>
    <ul>
        <li>Understand the value and impact of publishing your datasets</li>
        <li>Learn the steps to prepare your data for successful publication</li>
        <li>Alternative methods for publishing data/code/software</li>
    </ul>
</section>

<section id="reason">
    <h2>Why Publish Your Data?</h2>
    <div>
    <ul>
        <li><strong>Funding Requirements:</strong> All LTER-funded data must be publicly accessible within two years of collection.</li>
        <li><strong>Journal Policies:</strong> Many journals require data to be published as part of their submission criteria.</li>
        <li><strong>Advance Science:</strong> Sharing data enables new scientific discoveries and fosters collaboration.</li>
        <li><strong>Preservation and Reproducibility:</strong> Publishing data preserves it for future research and supports reproducible results.</li>
        <li><strong>Professional Recognition:</strong> Publishing your data is a valuable achievement you can add to your CV, giving you credit for your work!</li>
    </ul>
</div>

<figure>
    <img src="/assets/img/data_decade.png" alt="Description of the image" style="width: 100%; height: auto;">
</figure>
<hr>
<div class="questions">
        <h3>Questions</h3>
        <p>What is your experience on data publication?</p>
    </div>
</section>

<section id="publishing-data">
        <h2>Steps to Prepare Data for Publication</h2>

<div class="flowchart">
    <div class="step">Format Data Table</div>
    <div class="arrow">➡️</div>
    <div class="step">Document Metadata</div>
    <div class="arrow">➡️</div>
    <div class="step">Publish Data on EDI</div>
    <div class="arrow">➡️</div>
    <div class="step">Cite it!</div>
</div>

<hr>
       
<h4>What is a good data format?</h4>
    <div>
    <ul>
        <li>CSV or TXT format</li>
        <li>Use “;” or “,” as field delimitator</li>
        <li>Avoid special characters in column names: /, space, %, $, #, @, (, )…</li>
        <li>Use “.”, “NA”, “-99999” for missing values</li>
        <li>Prefer long format over wide format</li>
        <li>NetCDF files refer to <a href="https://sbclter.msi.ucsb.edu/data/catalog/package/?package=knb-lter-sbc.74" target="_blank">Landsat kelp biomass dataset</a> for formatting</li>
    </ul>
</div>

<div class="example-section">
    <strong>Bad Example:</strong>
<figure>
    <img src="/assets/img/data_table_example.png" alt="Description of the image" style="width: 100%; height: auto;">
</figure>

<br>
<br>
<strong>Good Example:</strong>
<figure>
    <img src="/assets/img/data_good_example.png" alt="Description of the image" style="width: 100%; height: auto;">
</figure>
</div>



<h4>How to Document Metadata</h4>

<div>
    <ul>
        <li>Fill out <a href="https://sbclter.msi.ucsb.edu/external/Documents/data_help/Metadata_collection.zip" target="_blank"> Metadata Excel Workbook</a> </li>
        <li>Write an abstract and methodology section centered on the dataset (not your research) and include the citation for your potential manuscript. </li>
    </ul>
</div>

<hr>
<h4>Publish data</h4>
      <div>
    <ul>
        <li>Data Manager will publish your data on <a href="https://www.edirepository.org/" target="_blank">Environmental Data Initiative (EDI)</a></li>
        <li>You then receive a link to your data package and the DOI</li>
        <li>Please cite it correctly in your manuscript</li>
    </ul>
</div> 
<hr>
<h4>Planning Your Time</h4>
<p>Completing my part of the data publication tasks typically takes 1 day to 1 month, depending on how well your data aligns with standard formats. In terms of your manuscript's stages, publishing your data during the "Data Analysis" stage is highly encouraged, the "Draft Manuscript" stage is ideal, the "Review" stage is acceptable, but the "Proofread" stage may be too late to complete the task on time.</p>
<div class="flowchart">
    <div class="step">Data analysis</div>
    <div class="arrow">➡️</div>
    <div class="step">Draft manuscript</div>
    <div class="arrow">➡️</div>
    <div class="step">Review</div>
    <div class="arrow">➡️</div>
    <div class="step">Proofread</div>
</div>

<hr>
<div class="questions">
        <h3>Questions</h3>
        <p>What other types of materials do you want to publish? Videos, PowerPoint presentations, figures, codes?</p>
    </div>

</section>

<section id="external-data">
        <h2>Alternative Publishing Methods</h2>
        <div>
    <ul>
        <li>If you want to publish data independently or outside of SBC, try the <a href="https://ezeml.edirepository.org/eml/auth/login" target="_blank">ezEML</a> offerted by Environmental Data Initiative</li>
        <li>If you'd like to share posters, presentations, or videos, consider using <a href="https://figshare.com/" target="_blank">Figshare</a></li>
        <li>If you plan to publish analysis code or software, refer to the detailed guidance below.</li>
        <li>Check repositories recommended by your funder for additional options.</li>
    </ul>
</div>


<hr>
<h4>Guidances for Publishing Code or Software</h4>
<div>
    <ul>
        <li>Ensure your code is clean, well-organized, and includes helpful comments to enhance readability and usability.</li>
        <li>Include test cases or testing scripts to verify the functionality and robustness of your code.</li>
        <li>Utilize version control systems like Git to track changes and maintain a comprehensive history of updates.</li>
        <li>Provide a README file that includes a detailed description of the code, installation and usage instructions, a list of dependencies or requirements, and examples of usage.</li>
        <li>Select a license, such as one approved by the <a href="https://opensource.org/licenses" target="_blank">Open Source Initiative (OSI)</a>, to clarify usage and distribution terms.</li>
        <li>Choose a publication platform suitable for code sharing, such as   <a href="https://github.com/OpenScienceMOOC/Module-5-Open-Research-Software-and-Open-Source/blob/master/content_development/Task_2.md" target="_blank">GitHub ➔ Zenodo</a>, to enable proper archiving and DOI assignment.</li>
    </ul>
</div>
        <hr>
<p>If you have any questions, please contact Dr. Li Kui at the Marine Science Institute, UCSB.</p>
        <p>Email: <a href="mailto:lkui@ucsb.edu">lkui@ucsb.edu</a></p>
    </section>
</div>

</body>
</html>


