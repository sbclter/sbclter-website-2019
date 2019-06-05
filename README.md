# SBC LTER website, 2019

### Installation Instructions
  - For MacOS, please check out file [how_to_install_jekyll.txt](/how_to_install_jekyll.txt).
  - For general installation, please visit [Jekyll Installation Guide](https://jekyllrb.com/docs/installation/).

### Running Instructions
  1. `cd bootstrap4-minimal/`
  2. `jekyll serve --incremental`
  3. Then, open http://localhost:4000 on a browser.
  4. If you get an error "Invalid US-ASCII character "\xE2" on line 6", run `export LANG=en_US.UTF-8` and try again.

### Project Structure
  - Jekyll generates files and folders to `_site/` and serve the folder during runtime.
  - Jekyll skips folders that begin with and an underscore (`_data/`, `_includes`, ...).
  - `bootstrap4-minimal/`

    |Utilities |Descriptions                                                   |
    |----------|---------------------------------------------------------------|
    |_data/    |Storing static data in yaml files (can be accessed from pages).|
    |_includes/|HTML templates for a part or a tool of a page.                 |
    |_layouts/ |HTML templates for a general page layout.                      |
    |_site/    |Folder used by Jekyll to serve the website.                    |
    |_plugins/ |Stores external plugin files / 3rd party libraries.            |
    
    |Pages        |Descriptions                           |
    |-------------|---------------------------------------|
    |about/       |Page templates for about/ route.       |
    |data/        |Page templates for data/ route.        |
    |publications/|Page templates for publications/ route.|
    |education/   |Page templates for education/ route.   |
    |research/    |Page templates for research/ route.    |
    
    |Resources|Descriptions                                                            |
    |---------|------------------------------------------------------------------------|
    |assets/  |Storing all CSS, JavaScript, Image files that can be accessed publicly. |

### CSS Hierarchy
  1. **General CSS**: main.css *(automatically included in `includes/head.html`)*
  2. **Layout CSS**: layout.css *(automatically included in `includes/head.html`)*
  3. **Page-Specific CSS**: include them in the page template's FrontMatter section.

    ---
    page_css:
      - /assets/css/custom/style1.css
      - /assets/css/custom/style2.css
      - /assets/css/custom/style3.css
    ---
    
  
