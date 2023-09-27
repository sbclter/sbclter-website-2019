---
layout: article
title: 'SBCLTER time series data visualization'
description: page description here.

---
<style>
        .image-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }

        .image-grid-item {
            width: 100%;
            height: 100;
        }

        .image-clickable img {
            width: 100%;
            height: 150px;
            display: block;
            object-fit: cover;
        }

        .lightbox {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 9999; /* Place the lightbox above other elements */

        }

        .lightbox img {
            display: block;
            max-width: 90%;
            max-height: 90%;
            margin: auto;
            margin-top: 5%;
            z-index: 10000; /* Place the lightbox above other elements */
        }
         .image-container {
            position: relative;
        }

        .image-description {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            color: #fff;
            padding: 5px;
            font-size: 14px;
            text-align: center;
            opacity:1;
            transition: opacity 0.3s;
        }
          .image-container:hover .image-description {
            opacity: 1;
        }

    </style>



<div id="graph-container">
    <h1>{{ page.title }}</h1>
    <br>
    <p>SBC LTER provides more than 40 long-term time series datasets, which are widely used in student projects and published articles. Below, you can explore the time series figures of commonly used variables. Click on each figure to view more details. </p> 

 <h3 class="">Annual kelp forest community dynamics</h3>
 <br>
  

 <div class="image-grid">
        <div class="image-grid-item">
            <div class="image-container image-clickable" data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Annual_reef_kelp.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Annual_reef_kelp.png" alt="Image 1">
                <div class="image-description">Annual kelp frond density</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Annual_reef_fish.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Annual_reef_fish.png" alt="Image 1" >
                <div class="image-description">Annual fish density</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Annual_reef_species_biomass_all_species.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Annual_reef_species_biomass_all_species.png" alt="Image 3" >
                <div class="image-description">Annual reef species biomass</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Annual_reef_species_biomass_in_functional_groups.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Annual_reef_species_biomass_in_functional_groups.png" alt="Image 4">
                <div class="image-description">Annual reef species biomass in functional group</div>
            </div>
        </div>
        <!-- Add more image-grid-item divs as needed -->
    </div>
         <br>
        <hr>  

  <h3 class="">Kelp net primary production</h3>
 <br>
        

<div class="image-grid">
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Kelp_NPP_Seasonal.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Kelp_NPP_Seasonal.png" alt="Image 1"  height="100">
                <div class="image-description">Kelp NPP Seasonal</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Kelp_lostrate_at_site.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Kelp_lostrate_at_site.png" alt="Image 2"   height="100">
                <div class="image-description">Kelp frond lost rate</div>
            </div>
        </div>
    </div>
       <br>
        <hr>  
  <h3 class="">Key species</h3>
 <br>
        

<div class="image-grid">
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Urchin_settlement.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Urchin_settlement.png" alt="Image 1"  height="100">
                <div class="image-description">Urchin settlement on brushes</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Lobster_abundance.png" >
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Lobster_abundance.png" alt="Image 2"   height="100">
                <div class="image-description">Lobster abundance</div>
            </div>
        </div>
    </div>
       <br>
        <hr>  


 <h3 class="">Beach habitats</h3>
 <br>
        

<div class="image-grid">
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Beach_consumer_at_site.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Beach_consumer_at_site.png" alt="Image 1"  height="100">
                <div class="image-description">Beach consumer</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Beach_shore_bird_at_site.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Beach_shore_bird_at_site.png" alt="Image 2"   height="100">
                <div class="image-description">Beach shore birds</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Beach_wrack_cover_at_site.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Beach_wrack_cover_at_site.png" alt="Image 3"   height="100">
                <div class="image-description">Beach wrack</div>
            </div>
        </div>
    </div>
       <br>
        <hr>  

<h3 class="">Ocean environmental conditions</h3>
 <br>
        

<div class="image-grid">
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Monthly_Ocean_downcast_conductivity.png" >
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Monthly_Ocean_downcast_conductivity.png" alt="Image 1"  height="100">
                <div class="image-description">Conductivity during monthly CTD downcasts </div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Monthly_Ocean_downcast_salinity.png" >
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Monthly_Ocean_downcast_salinity.png" alt="Image 1"  height="100">
                <div class="image-description">Salinity during monthly CTD downcasts </div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Monthly_Ocean_chem_totalChl.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Monthly_Ocean_chem_totalChl.png" alt="Image 2"   height="100">
                <div class="image-description">Total chl during monthly bottle sample</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Monthly_Ocean_chem_PON.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Monthly_Ocean_chem_PON.png" alt="Image 3"   height="100">
                <div class="image-description">PON during monthly bottle sample</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Monthly_Ocean_chem_POC.png" >
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Monthly_Ocean_chem_POC.png" alt="Image 3"   height="100">
                <div class="image-description">POC during monthly bottle sample</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/PH_at_site.png" >
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/PH_at_site.png" alt="Image 3"   height="100">
                <div class="image-description">PH from SEAFET</div>
            </div>
        </div>
          <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/DO_saturation_at_site.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/DO_saturation_at_site.png" alt="Image 3"   height="100">
                <div class="image-description">DO from miniDOT</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Light_at_site.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Light_at_site.png" alt="Image 3"   height="100">
                <div class="image-description">Seaflood irradiation</div>
            </div>
        </div>
        <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Temp_on_mooring_at_site.png" >
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Temp_on_mooring_at_site.png" alt="Image 3"   height="100">
                <div class="image-description">Temperature on mooring</div>
            </div>
        </div>
         <div class="image-grid-item">
            <div class="image-container image-clickable" 
            data-highres="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/figures/Temp_inside_kelp_bed_at_site.png">
                <img src="https://sbclter.msi.ucsb.edu/external/Documents/data_vis/thumb_figures/Temp_inside_kelp_bed_at_site.png" alt="Image 3"   height="100">
                <div class="image-description">Temperature inside kelp beds</div>
            </div>
        </div>
    </div>
       <br>
        <hr>  

<div class="lightbox" onclick="closeLightbox()">
        <img src="" alt="Image" id="lightbox-image">
    </div>


<script>

        const imageClickables = document.querySelectorAll('.image-clickable');
        const lightbox = document.querySelector('.lightbox');
        const lightboxImage = document.querySelector('#lightbox-image');

        imageClickables.forEach((imageClickable) => {
            imageClickable.addEventListener('click', () => {
                const highResUrl = imageClickable.dataset.highres;
                lightbox.style.display = 'block';
                lightboxImage.src = highResUrl;
            });
        });

        function closeLightbox() {
            lightbox.style.display = 'none';
        }
    </script>
</div>