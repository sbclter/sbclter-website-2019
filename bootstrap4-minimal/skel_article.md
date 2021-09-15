---
layout: article
title: 'Page tltle here'
description: page description here.

---

<h1>H1 header</h1>
	
<!-- how to col: individual articles can vary the col widths; for full-width total should = 12. 
	col-md scales up (med to large desktops), and automatically stacks on phones and tablets (within the row). -->

<p>site has two layouts: "articles", and "posts". Most pages are articles (like this one); posts are for news. </p>

<div id="main-container">
	<div class="row">
	       <div class="col-md-4">
           <p>Sample col with a list </p>
            <ul>
                <li>list 1</li>
                <li>list 2</li>
                <li>list 3</li>
                <li>list 4</li>
            </ul>
        </div>

       <div class="col-md-8">
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure 
dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit 
anim id est laborum.
          </p>
        </div>
   </div>
    
    <!-- possibly could add a clear here instead of row. see getbootstrap.com/docs/ examples grid -->
    
    <div class="row"> 
        <div class="col-md-4">
           <p>this is row 2 </p>
          <p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium 
            voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati 
            cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id 
            est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. 
            Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus 
            id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor 
            repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus 
            saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque 
            earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores 
            alias consequatur aut perferendis doloribus asperiores repellat.
          </p>
        </div>

       <div class="col-md-8">
       <p>block has an image. </p>
       
    <img class="featurette-image img-responsive center-block" src="/assets/img/avatar.png"  alt="Generic placeholder image" style="float:right; PADDING-LEFT: 15px" />       
     </div>
     
        <hr />
        
        <div>
        <img class="featurette-image img-responsive center-block" src="/assets/img/avatar.png" alt="Generic placeholder image" style="float:right; PADDING-LEFT: 15px" />
        <p>Example of a section with a float-right image. size is fixed.</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure 
dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit 
anim id est laborum.</p>
        </div>
        
     
    </div>
</div>