# SBC LTER website, 2019

### Installation Instructions
  - For MacOS, please check out file [how_to_install_jekyll.txt](/how_to_install_jekyll.txt).
  - For general installation, please visit [Jekyll Installation Guide](https://jekyllrb.com/docs/installation/).

### Running Instructions
  1. `cd bootstrap4-minimal/`
  1. Find the google-API key and create a valid config file.
     1. Site Admins have access to the API key
     1. see readme alongside `_config_dummy.yml` (API KEY MUST NOT BE CHECKED INTO GIT)
  1. `jekyll serve --incremental`
  1. Open http://localhost:4000 on a browser.
  1. If you get an error "Invalid US-ASCII character "\xE2" on line 6", run `export LANG=en_US.UTF-8` and try again.

### Project Structure
  - See the README in the bootstrap directory for instructions on using the config and google API key
  - Jekyll generates files and folders to `_site/` and serve the folder during runtime.
  - Jekyll skips folders that begin with and an underscore (`_data/`, `_includes`, ...).
  - `bootstrap4-minimal/`

    |Folders   |Descriptions                                                   |
    |----------|---------------------------------------------------------------|
    |_data/    |Storing static data in yaml files (can be accessed from pages).|
    |_includes/|HTML templates for a part or a tool of a page.                 |
    |_layouts/ |HTML templates for a general page layout.                      |
    |_site/    |Folder used by Jekyll to serve the website.                    |
    |_plugins/ |Stores external plugin files / 3rd party libraries.            |
    
    |Folders      |Descriptions                           |
    |-------------|---------------------------------------|
    |about/       |Page templates for about/ route.       |
    |data/        |Page templates for data/ route.        |
    |publications/|Page templates for publications/ route.|
    |education/   |Page templates for education/ route.   |
    |research/    |Page templates for research/ route.    |
    
    |Folders  |Descriptions                                                            |
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

### Data Package Page

**HTML**

-   **Main:** `data/catalog/package/index.md`
-   **Template:**`_includes/data/package.html`

**CSS File**

-   **Main** (`assets/css/custom/data/package.scss`)
    -   Utilizing SCSS's hierarchical structure, we can organize styling based on tabs and sections within each tab.

**JavaScript**

These files query Pasta XML data and pick them one by one into building the HTML package page. The Pasta XML data structure is difficult to predict (data may or may not exist, can be at different places, can exist as an object or list of objects...). To ensure we build an error free page, there are **2 phases** involved to safely produce each tab:

-   **Phase 1 - Parsing:** In this phase, we take the raw Pasta object and safely parse it, and create a new data object that **guarantees** every field is consistent and present (ie. always an object, always a string, or always a list). The new object is all the data we need to build the package page.
-   **Phase 2 - Building:** In this phase, we take the parsed data from phase 1, and insert them into different places of HTML. We can solely focus on building the HTML page, and don't need to worry about any missing data or inconsistent type. 

All JavaScript files are inside `assets/js/package/` folder, which includes:

-   **Main File**
  1.  Initialize a new HTML template.
  2.  Query Pasta API to get XML data.
  3.  Convert XML to Json object.
  4.  Call <u>parse</u> and <u>build</u> functions for each tab page.
  5.  Copy HTML template to actual page.
-   **Tab Files** (Summary, People, Coverage, Method, File). Each of them includes **parse()** and **build()** and other helper functions.

All general **helper functions** live inside the main file. They are used everywhere in the **main** and **tab** files.

-   **extractString(data, path, keys, delim='')**

    This function extracts string from the given data. It will safely traverse down the path starting from the root data. Then, it uses keys to extract each string. Finally, it joins and returns the strings with the delimiter.

    -   **data - object:** root data
    -   **path - string:** data path relative to root to start extraction. *Ex: "path > to > extraction"*
    -   **keys - list:** (optional) list of keys to extract string at the starting point of extraction. If the starting point of extraction is a list, keys will be tried at every list item. *Each key is a path as well.*
    -   **delim - string:** (optional) delimiter for combining multiple string values (usually due to having multiple keys).

-   **extractStringObject(data, keys, delim='')**

    This function extracts string from the given data object. It uses keys to extract each string, and joins and returns the strings with the delimiter. *Please use **extractString()** instead for most use cases.*

    -   **data - object:** root data.
    -   **keys - list:** (optional) list of keys to extract string at the starting point of extraction. *Each key is a path as well.*
    -   **delim - string:** (optional) delimiter for combining multiple string values (usually due to having multiple keys).

-   **extractList(data, path, keys, to_string)**

    This function extracts a list of objects from the given data. It will safely traverse down the path starting from the root data. Then, it uses keys to extract each item from the list and returns a new list.

    -   **data - object:** root data.
    -   **path - string:** data path relative to root to start extraction. *Ex: "path > to > extraction"*.
    -   **keys - list:** (optional) list of keys to extract string at the starting point of extraction. *Each key is a path as well.*
    -   **to_string - boolean:** (optional) If set to **true**, each list item will become a string.

-   **loadXMLDoc(fileUrl, onReady, onError)**

    This function loads XML data from the given fileUrl, and calls onReady or onError functions when the process is finished.

    -   **fileUrl - string:** XML document's URL or file path.
    -   **onReady - function:** Function triggered when xml data is ready.
    -   **onError - function:** Function triggered when something goes wrong.

-   **camelToWords(text)**

    This function converts given camel string to actual words. *Ex: "dogIsCute" -> "Dog Is Cute"* 

    -   **text - string:** any camel string.

-   **parseAddress(json)**

    This function parses mail address from the Pasta data, and returns an address-formatted string.

    -   **json - object:** raw address data from Pasta.

-   **parseName(json, format)**

    This function parses names from the Pasta data, and returns a name string.

    -   **json - object:** raw name data from Pasta.
    -   **format - string:** dictates the format of the name string returned. *Ex: "%F %L is a cool person."*
        -   `%F` = first name, `%f` = first initial.
        -   `%L` = last name, `%l` = last initial.
        -   `%M` = middle name, `%m` = middle initial.

-   **activateLink(url, title)**

    This function turns given url and title to a HTML link tag.

    -   **url - string:** link address.
    -   **title - string:** title of the link.

-   **makeTableRow(cells, classes)**

    This function takes a list of cells and row classes to form a HTML table row.

    -   **cells - list:** a list of `th` and `td` cells. *Ex: [ [ 'th', 'col-4', 'name' ], [ 'td', 'col-8', 'value' ] ]*
        -   cell format: [ tag, classes, content ]
    -   **classes - string:** (optional) classes of the table row

-   **updateView(title, body)**

    This function updates the title and body of the package page.

    -   **title - html:** page title html.
    -   **body - html:** page body html.

-   **loadMathJax()**

    This function dynamically loads MathJax script onto the page's head tag.

-   **removeLastDelim(str, delim, ending='')**

    This function removes the ending delimiter of a string, if it exists. It then appends the given string ending.

    -   **str - string:** any string.
    -   **delim - string:** delimiter string.
    -   **ending - string:** (optional) additional string ending.
