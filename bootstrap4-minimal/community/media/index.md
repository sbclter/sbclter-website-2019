---
layout: article
title: 'News and Events'
description: news and event in SBCLTER
---

<style>
  body { font-family: Arial, sans-serif; padding: 20px; background: #f4f4f4; }
  .section { margin-bottom: 40px; }
  .gallery-three { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
  .gallery-four { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
  .video { cursor: pointer; position: relative; display: flex; flex-direction: column; align-items: center; background: #fff; padding: 10px; }
  .video img { width: 100%; height: auto; }
  .video-desc { margin-top: 10px; text-align: center; }
  .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgb(0,0,0,0.9); }
  .modal-content { background-color: #fefefe; margin: 15% auto; padding: 20px; border: 1px solid #888; width: 60%; }
  .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; }
  .close:hover, .close:focus { color: black; text-decoration: none; cursor: pointer; }
  .video-player { width: 100%; height: auto; max-height: 60vh; }

.photo-gallery {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
  margin-top: 40px;
}

.photo-gallery a {
  position: relative;
  display: block;
  border: 1px solid #ddd;
  overflow: hidden;
}

.photo-gallery img {
  width: 100%;
  height: auto;
  display: block;
}

.overlay {
  position: absolute;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5); /* Black background with opacity */
  color: #ffffff;
  width: 100%;
  text-align: center;
  padding: 20px 0;
}
</style>



<h2>SBC LTER Video Gallery</h2>
<br>
<div class="section">
  <h3>Life at SBC LTER</h3>
  <div class="gallery-three">
    <!-- Thumbnails for three videos -->
    <div class="video" onclick="openModal('https://sbclter.msi.ucsb.edu/external/Documents/SBCLTER_videos/SBCLTER_Overview.mp4')">
    <img src="/assets/img/video/overview.jpg" alt="Thumbnail for Video 1">
     <p class="video-desc">SBC LTER overview</p>
  </div>

  <!-- Video 1 Thumbnail -->
  <div class="video" onclick="openModal('https://sbclter.msi.ucsb.edu/external/Documents/SBCLTER_videos/SBCLTER_Education_Outreach.mp4')">
    <img src="/assets/img/video/education.jpg" alt="Thumbnail for Video 1">
     <p class="video-desc">SBC LTER Education and Outreach</p>
  </div>

  <!-- Video 1 Thumbnail -->
  <div class="video" onclick="openModal('https://sbclter.msi.ucsb.edu/external/Documents/SBCLTER_videos/SBCLTER_Beach_Field_Work.mp4')">
    <img src="/assets/img/video/beach.jpg" alt="Thumbnail for Video 1">
     <p class="video-desc">SBCLTER Beach Field Work</p>
  </div>
  </div>
</div>

<div class="section">
  <h3>Lightning talks from graduate students and researchers</h3>
  <div class="gallery-four">
    <!-- Thumbnails for four videos -->
    <!-- Repeat this structure for each of the four videos -->
     <div class="video" onclick="openModal('https://sbclter.msi.ucsb.edu/external/Documents/SBCLTER_videos/Group1.mp4')">
    <img src="/assets/img/video/gp1.jpg" alt="Thumbnail for Video 1">
     <p class="video-desc">Bart DiFiore, Raine Detmer, Kristen Michaud</p>
  </div>

  <!-- Video 1 Thumbnail -->
  <div class="video" onclick="openModal('https://sbclter.msi.ucsb.edu/external/Documents/SBCLTER_videos/Group2.mp4')">
    <img src="/assets/img/video/gp2.jpg" alt="Thumbnail for Video 1">
     <p class="video-desc">Xochitl Clare, Katrina Malakhoff</p>
  </div>

  <!-- Video 1 Thumbnail -->
 <div class="video" onclick="openModal('https://sbclter.msi.ucsb.edu/external/Documents/SBCLTER_videos/Group3.mp4')">
    <img src="/assets/img/video/gp3.jpg" alt="Thumbnail for Video 1">
     <p class="video-desc">Natalie Dornan, Heili Lowman</p>
  </div>

   <div class="video" onclick="openModal('https://sbclter.msi.ucsb.edu/external/Documents/SBCLTER_videos/Group4.mp4')">
    <img src="/assets/img/video/gp4.jpg" alt="Thumbnail for Video 1">
     <p class="video-desc">Jordan Snyder, Chance English</p>
  </div>

   <div class="video" onclick="openModal('https://sbclter.msi.ucsb.edu/external/Documents/SBCLTER_videos/Group5.mp4')">
    <img src="/assets/img/video/gp5.jpg" alt="Thumbnail for Video 1">
     <p class="video-desc">Sam Bogan, Logan Kozal, Terence Leach</p>
  </div>


   <div class="video" onclick="openModal('https://sbclter.msi.ucsb.edu/external/Documents/SBCLTER_videos/Group6.mp4')">
    <img src="/assets/img/video/gp6.jpg" alt="Thumbnail for Video 1">
     <p class="video-desc">Kate Cavanaugh, Kyle Emery, Jessica Madden</p>
  </div>

   <div class="video" onclick="openModal('https://sbclter.msi.ucsb.edu/external/Documents/SBCLTER_videos/Group7.mp4')">
    <img src="/assets/img/video/gp7.jpg" alt="Thumbnail for Video 1">
     <p class="video-desc">Karina Johnston, Thomas Lamy, Paige Miller</p>
  </div>


  </div>
</div>

<!-- The Modal -->
<div id="videoModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <video id="videoPlayer" class="video-player" controls>
      <!-- The source is set dynamically when a video thumbnail is clicked -->
    </video>
  </div>
</div>

<!--
<hr/>
<br>

<h2>SBC LTER Photos</h2>


<p>Since SBC's inception, we've amassed a vast collection of images. Below, we've curated a selection showcasing various themes for your exploration. </p> 
<div class="photo-gallery">
     <a href="/external/photo/Logos" target="_blank">
    <img src="/assets/img/photo_thumbnail/logo.jpg" alt="">
     <div class="overlay">SBC LTER logos</div>
  </a>
  <a href="/external/photo/Species" target="_blank">
    <img src="/assets/img/photo_thumbnail/species.jpg" alt="">
     <div class="overlay">Marine species</div>
  </a>
   <a href="/external/photo/Boats_and_Vehicles" target="_blank">
    <img src="/assets/img/photo_thumbnail/boats.JPG" alt="">
     <div class="overlay">Boat and Vehicles</div>
  </a>
   <a href="/external/photo/LTER_landscapes" target="_blank">
    <img src="/assets/img/photo_thumbnail/landscape.jpg" alt="">
     <div class="overlay">Landscape</div>
  </a>

   <a href="/external/photo/Meetings" target="_blank">
    <img src="/assets/img/photo_thumbnail/meetings.jpg" alt="">
     <div class="overlay">Meetings</div>
  </a>
     <a href="/external/photo/Outreach_images" target="_blank">
    <img src="/assets/img/photo_thumbnail/outreach.jpg" alt="">
     <div class="overlay">Outreach and Education</div>
  </a>
    <a href="/external/photo/People" target="_blank">
    <img src="/assets/img/photo_thumbnail/people.jpg" alt="">
     <div class="overlay">Our people</div>
  </a>
    <a href="/external/photo/Research_project_images" target="_blank">
    <img src="/assets/img/photo_thumbnail/research_project.jpg" alt="">
     <div class="overlay">Research projects</div>
  </a>
</div>
-->
<hr/>
<br>

<h2> YouTube channels</h2>

<div style="position: bottom: 5px;">
     <p><a href="https://www.youtube.com/channel/UCF9VmuIO6jlzjrz8CnKc3eQ" target="_blank">SBC LTER YouTube Channel</a> includes videos on how SBC biological surveys were conducted and how we deployed the ocean instruments</p>
</div>

<div style="position: bottom: 5px;">
     <p><a href="https://www.youtube.com/channel/UCzNC-IK5BNlgY3cZrGrWEqQ/videos" target="_blank">VirtualREEF team</a> offers virtual classes on Santa Barbara Channel and Beach</p>
</div>


<script>
function openModal(videoUrl) {
  var videoPlayer = document.getElementById('videoPlayer');
  videoPlayer.src = videoUrl;
  videoPlayer.play(); // Automatically start playing the video
  document.getElementById('videoModal').style.display = "block";
}

function closeModal() {
  var modal = document.getElementById('videoModal');
  modal.style.display = "none";
  var videoPlayer = document.getElementById('videoPlayer');
  videoPlayer.pause(); // Pause the video
  videoPlayer.src = ""; // Clear the video source to ensure it stops playing
}

window.onclick = function(event) {
  if (event.target == document.getElementById('videoModal')) {
    closeModal();
  }
}
</script>

