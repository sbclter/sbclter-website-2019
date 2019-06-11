# Readme

## To generate website

1. copy "_config_dummy.yml" to "_config.yml"
2. add your API key to _config.yml

The file _config.yml is ignored by git


## before starting the jekyll server
` export LANG=en_US.UTF-8 `

Mac mojave does not autmatically set character sets.


## other Instructions and tutorials
1. https://experimentingwithcode.com/creating-a-jekyll-blog-with-bootstrap-4-and-sass-part-1/

General setup

2. https://experimentingwithcode.com/creating-a-jekyll-blog-with-bootstrap-4-and-sass-part-2/
boilerplate, and getting started with css, includes, etc. 

Footer styling:
did not do the footer styling and social media links. 
used minimal so far. if you need to add more, eg, NSF logo, links, look in part-2

3. https://experimentingwithcode.com/creating-a-jekyll-blog-with-bootstrap-4-and-sass-part-3/

adding blog posts, and showing titles on the first page. you coudl copy all this from
the bon style (and use for news). bon site has two types, posts and articles.

used this to set up the basic dirs, and index pages for sections (with articles) 

pagination: this lesson has info about adding pagination. a news section can use that. later.

hint: its a plugin, which is a config-reload.

4. https://experimentingwithcode.com/creating-a-jekyll-blog-with-bootstrap-4-and-sass-part-4/

lotsa styling for code blocks in the post layout (so there is a _post.css). and a start on javascript.

### Bootstrap:
General:
https://getbootstrap.com/docs/4.3/getting-started/introduction/


Using css classes for row, columns

https://getbootstrap.com/docs/4.0/layout/grid/ (edited) 

The row size is 12 units. And row put inner divs horizontally.
So you can do something like this, and the 3 divs will be on the same row (unless you set min-width to some pixel value.)
``` 
<div class="row">
    <div class="col-6"></div>
    <div class="col-1"></div>
    <div class="col-5"></div>
</div> 
```
