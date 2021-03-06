<?xml version="1.0" encoding="utf-8"?>
<!--
  *  '$RCSfile: eml-2.0.0.xsl,v $'
  *      Authors: Matt Jones
  *    Copyright: 2000 Regents of the University of California and the
  *         National Center for Ecological Analysis and Synthesis
  *  For Details: http://www.nceas.ucsb.edu/
  *
  *   '$Author: cjones $'
  *     '$Date: 2004/10/05 23:50:34 $'
  * '$Revision: 1.1 $'
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
  * This is an XSLT (http://www.w3.org/TR/xslt) stylesheet designed to
  * convert an XML file that is valid with respect to the eml-dataset.dtd
  * module of the Ecological Metadata Language (EML) into an HTML format
  * suitable for rendering with modern web browsers.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- These import paths will be replaced by config settings
  -->
  <!-- 
  
  <xsl:import href="/var/www/vhosts/sbclter.msi.ucsb.edu/lib/xslt/pageheader.xsl"/>
  <xsl:import href="/var/www/vhosts/sbclter.msi.ucsb.edu/lib/xslt/pagefooter.xsl"/>
  <xsl:import href="/var/www/vhosts/sbclter.msi.ucsb.edu/lib/xslt/page_leftsidebar.xsl"/>
  <xsl:import href="/var/www/vhosts/sbclter.msi.ucsb.edu/lib/xslt/page_rightsidebar.xsl"/>
  <xsl:import href="/var/www/vhosts/sbclter.msi.ucsb.edu/lib/xslt/page_rightsidebar.xsl"/>
-->
  <!-- mob: 2010-03-19 
    note on encoding: These stylesheets use &#160; for a non-breaking space, which is utf-8. 
    So setting encoding to iso-8859 renders these incorrectly. Metacat seems to map between the two
    character sets (ie, no unreadable characters appear when rendered by Metacat, but other 
    transformers do not. Would it be most polite to settle on one encoding?  or is character-set mapping 
    expected of all transformers or applications?
  -->
  <xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
  <!-- global variables to store id node set in case to be referenced-->
  <xsl:variable name="ids" select="//*[@id != '']"/>
  
  
  
  
  
  
  
  <!-- 
    
    
    
    
    
    
    
    
    will paste in the settings file here -->
  
  
  
  
  <!--
    /**
    *   The filename of the default css stylesheet to be used
    *   (filename only - not the whole path, and no ".css" extension.  The
    *   example below would look for a file named "default.css" in the same
    *   directory as the stylesheets
    */
-->
  
  <xsl:param name="qformat">default</xsl:param>
  <!-- 
  mob added 2015-03-27
  we no longer use metacat to serve up EML. using local storage instead.
  TO DO: please depreate anything with "metacat" in it in these settings, and in the site_config.tmpl
  -->
  <xsl:param name="httpserver">[% site.httpserver %]</xsl:param>
  <!-- 
    mob added 2010-03-24 (previously empty) 
  the contextURL variable is used in stylesheets to build urls. It had been used for all URLs, but
  SBC is using it to retrive only XML (see xmlURI var below) -->
  
  <!-- mob TO DO: hunt down this param and kill it. start with eml-dataset, line 432, 2015-03-27
  <xsl:param name="contextURL">[% site.url.metacatserver %]</xsl:param> -->
  <xsl:param name="contextURL">[% site.httpserver %]</xsl:param>
  <!-- 
    mob edited 2010-03-24 (previously empty) 
    the default stylesheets used "cgi-prefix" to point to the register-dataset.cgi. I am not sure where it 
    was set, since it was empty here. It is now set here (although this may not have been necessary) 
    because SBC uses this for the "tripleURI" below, to build URLs to the application handling the 
    xslt parameters, which is now a perl cgi. -->
  <xsl:param name="cgi-prefix">[% site.url.cgi_bin %]</xsl:param>
  
  <!-- the calling app passed its name in  -->
  
  <!-- maybe a dupe 
  <xsl:param name="referrer" ></xsl:param> -->
  
  
  <!--
    /**
    *   The module which need to be display in eml2 document. The default
    *   value is dataset
    */
-->
  <xsl:param name="displaymodule">dataset</xsl:param>
  
  
  <!--
    /**
    *   To show the links for the Entities in the dataset display module.
    */
-->
  <xsl:param name="withEntityLinks">1</xsl:param>
  
  
  <!--
    /**
    *   To show the link for Additional Metadata in the dataset display module.
    */
-->
  <xsl:param name="withAdditionalMetadataLink">1</xsl:param>
  
  
  <!--
    /**
    *   To show the link for the Original XML in the dataset display module.
    */
-->
  <xsl:param name="withOriginalXMLLink">1</xsl:param>
  
  
  <!--
    /**
    *   To show the Attributes table in the entity display.
    */
-->
  <xsl:param name="withAttributes">1</xsl:param>
  
  
  <!--
   /**
    *   the path of the directory where the XSL and CSS files reside - starts
    *   with context name, eg: /myContextRoot/styleDirectory.
    *   (As found in "http://hostname:port/myContextRoot/styleDirectory").
    *   Needs leading slash but not trailing slash
    *
    *   EXAMPLE:
    *       <xsl:param name="stylePath">/brooke/style</xsl:param>
    */
-->
  
  <!-- TO DO: confirm SBC is not using this, then remove, please! -->
  <xsl:param name="stylePath">{$contextURL}/style/skins</xsl:param>
  
  
  <!--
   /*
    *   the path of the directory where the common javascript and css files
    *   reside - i.e the files that are not skin-specific. Starts
    *   with context name, eg: /myContextRoot/styleCommonDirectory.
    *   (As found in "http://hostname:port/myContextRoot/styleCommonDirectory").
    *
    *   EXAMPLE
    *       <xsl:param name="styleCommonPath">/brooke/style/common</xsl:param>
    */
-->
  
  <!-- TO DO: confirm SBC is not using this, then remove, please! -->
  <xsl:param name="styleCommonPath">{$contextURL}/style/common</xsl:param>
  
  
  <!--the docid of xml which is processed-->
  <!-- maybe a dupe
  <xsl:param name="docid"/> -->
  <!-- type of entity, data table or spacial raster or others-->
  <xsl:param name="entitytype"></xsl:param>
  <!-- the index of entity in same entity type -->
  <xsl:param name="entityindex"/>
  <!-- the index of physical part in entity part-->
  <xsl:param name="physicalindex"/>
  <!-- the index of distribution in physical part  -->
  <xsl:param name="distributionindex"/>
  <!-- the levle of distribution -->
  <xsl:param name="distributionlevel"/>
  <!-- the index of attribute in attribute list-->
  <xsl:param name="attributeindex"/>
  <!-- the index of additional metadata-->
  <xsl:param name="additionalmetadataindex"/>
  <!-- attribute set to get rid of cell spacing-->
  <xsl:attribute-set name="cellspacing">
    <xsl:attribute name="cellpadding">0</xsl:attribute>
    <xsl:attribute name="cellspacing">0</xsl:attribute>
  </xsl:attribute-set>
  
  
  <!--
    /**
    *   The base URI to be used for the href link to each document in a
    *   "subject-relationaship-object" triple
    *
    *   EXAMPLE:
    *       <xsl:param name="tripleURI">
    *         <![CDATA[/brooke/catalog/metacat?action=read&qformat=knb&docid=]]>
    *       </xsl:param>
    *
    *   (Note in the above case the "qformat=knb" parameter in the url; a system
    *   could pass this parameter to the XSLT engine to override the local
    *   <xsl:param name="qformat"> tags defined earlier in this document.)
    */
-->
  <!-- 
    <xsl:param name="tripleURI"><xsl:value-of select="$contextURL" /><![CDATA[/metacat?action=read&qformat=]]><xsl:value-of select="$qformat" /><![CDATA[&docid=]]></xsl:param>
 -->
  <!-- URL for xmlformat
    <xsl:param name="xmlURI"><xsl:value-of select="$contextURL" /><![CDATA[/metacat?action=read&qformat=xml&docid=]]></xsl:param>
    -->
  
  <!-- 
  
  
  mob edited when SBC began using a cgi script to transform XML instead of metacat. 
  the "tripleURI" should point to the program which provides the XSLT stylesheets with their parameters.
  This is now SBC's cgi dir, with the script name added. So use the "cgi-prefix" param above instead.
  These strings should be parameterized somewhere!  -->
  <!-- URL for the app which suppies the xslt with their parameters 
  <xsl:param name="tripleURI"><xsl:value-of select="$cgi-prefix" /><![CDATA[/showDataset.cgi?docid=]]></xsl:param> -->
  
  <xsl:param name="tripleURI"><xsl:value-of select="$cgi-prefix" /><![CDATA[/]]><xsl:value-of select="$referrer" /><![CDATA[?docid=]]></xsl:param>
  
  
  <xsl:param name="tripleURI_showDataset"><xsl:value-of select="$cgi-prefix" /><![CDATA[/showDataset.cgi?docid=]]></xsl:param> 
  
  
  
  <!-- URL for xmlformat -->
  <!-- as of march 2015, no longer used. -->
  <!--  <xsl:param name="xmlURI"><xsl:value-of select="$contextURL" /><![CDATA[/knb/metacat?action=read&qformat=xml&docid=]]></xsl:param>
  -->
  <xsl:param name="xmlURI"><xsl:value-of select="$httpserver" /><![CDATA[/data/eml/files/]]></xsl:param>
  
  
  <!-- URL for the app which suppies the xslt with their parameters  -->
  <xsl:param name="useridDirectoryApp1_URI"><xsl:value-of select="$cgi-prefix" /><![CDATA[/ldapweb2012.cgi?stage=showindividual&lter_id=]]></xsl:param>
  <xsl:param name="useridDirectory1">sbclter-directory</xsl:param>
  <xsl:param name="useridDirectoryLabel1">SBC LTER</xsl:param>
  
  <!--
    /**
    *   Most of the html pages are currently laid out as a 2-column table, with
    *   highlights for more-major rows containing subsection titles etc.
    *   The following parameters are used within the
    *           <td width="whateverWidth" class="whateverClass">
    *   tags to define the column widths and (css) styles.
    *
    *   The values of the "xxxColWidth" parameters can be percentages (need to
    *   include % sign) or pixels (number only). Note that if a width is defined
    *   in the CSS stylesheet (see next paragraph), it will override this local
    *   width setting in browsers newer than NN4
    *
    *   The values of the "xxxColStyle" parameters refer to style definitions
    *   listed in the *.css stylesheet that is defined in this xsl document,
    *   above (in the <xsl:param name="qformat"> tag).
    *
    *   (Note that if the "qformat" is changed from the default by passing a
    *   value in the url (see notes for <xsl:param name="qformat"> tag, above),
    *   then the params below must match style names in the "new" CSS stylesheet
    */
-->
  
  <!--    the style for major rows containing subsection titles etc. -->
  <xsl:param name="subHeaderStyle" select="'tablehead'"/>
  
  <!--    the style for major rows containing links, such as additional metadata, 
        original xml file etc. -->
  <xsl:param name="linkedHeaderStyle" select="'linkedHeaderStyle'"/>
  
  <!--    the width for the first column (but see note above) -->
  <xsl:param name="firstColWidth" select="'15%'"/>
  
  <!-- the style for the first column -->
  <xsl:param name="firstColStyle" select="'rowodd'"/>
  
  <!--    the width for the second column (but see note above) -->
  <xsl:param name="secondColWidth" select="'85%'"/>
  
  <!-- the style for the second column -->
  <xsl:param name="secondColStyle" select="'roweven'"/>
  
  <!-- the style for the attribute table -->
  <xsl:param name="tableattributeStyle" select="'tableattribute'"/>
  
  <!-- the style for the border -->
  <xsl:param name="borderStyle" select="'bordered'"/>
  
  <!-- the style for the even col in attributes table -->
  <xsl:param name="colevenStyle" select="'coleven'"/>
  
  <!-- the style for the inner even col in attributes table -->
  <xsl:param name="innercolevenStyle" select="'innercoleven'"/>
  
  <!-- the style for the odd col in attributes table -->
  <xsl:param name="coloddStyle" select="'colodd'"/>
  
  <!-- the style for the inner odd col in attributes table -->
  <xsl:param name="innercoloddStyle" select="'innercolodd'"/>
  
  
  <!-- the default alignment style for the wrapper around the main tables -->
  <!--
  <xsl:param name="mainTableAligmentStyle" select="'mainTableAligmentStyle'"/>
  -->
  <xsl:param name="mainTableAligmentStyle" select="'content'"/>
  
  <!-- the default style for the main container table -->
  <xsl:param name="mainContainerTableStyle" select="'group group_border'"/>
  
  <!-- the default style for all other tables -->
  <xsl:param name="tabledefaultStyle" select="'subGroup subGroup_border onehundred_percent'"/>
  
  <!-- the style for table party -->
  <xsl:param name="tablepartyStyle" select="'tableparty'"/>
  
  <!-- Some html pages use a nested table in the second column.
     Some of these nested tables set their first column to
     the following width: -->
  <xsl:param name="secondColIndent" select="'10%'"/>
  
  <!-- the first column width of attribute table-->
  <xsl:param name="attributefirstColWidth" select="'15%'"/>
  
  
  
  
  
  
  
  
  
  
  
  <!-- end of pasted settings file 
  
  
  
  
  
  
  
  
  
  
  
  -->
  
  
  
  
  
    
  
  
  
  
  
  
  <!-- 
    
    mob 2010-03-23
    calling program passes in value for requested docid  -->
  <xsl:param name="docid" select="''"/>
  <!-- calling app passes in it's own name -->
  <xsl:param name="referrer" select="''"/>
  <xsl:template match="/">
    <xsl:param name="docid" select="$docid"/>
    <xsl:param name="referrer" select="$referrer"/>
    <html>
      <head>
        <!-- to be inserted at install -->
        <!--    <link rel="stylesheet" type="text/css" href="[% site.url.root %]/w3_recommended.css"/>
        <link rel="stylesheet" type="text/css" href="[% site.url.root %]/css/navigation.css"/>
        <link rel="stylesheet" type="text/css" href="[% site.url.root %]/css/sbclter.css"/> -->
        <!-- 2016-10-08, 
          in which mob tests latex rendering -->
        <script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML"/>
        <!-- end mobs test -->
        <title>Data package, Santa Barbara Coastal LTER, id <xsl:value-of select="$docid"/></title>
      </head>
      <xsl:element name="body">
        <!-- coverage pages have a map -->
        <xsl:if test="$displaymodule = 'coverageall'">
          <xsl:attribute name="onload">initialize_map()</xsl:attribute>
        </xsl:if>
        <!-- begin the header area -->

        <!-- removed manually, 2019-05-08
        
        <xsl:call-template name="pageheader"/> -->

        <!-- end the header area -->
        <!-- begin the content area -->
        <!--
           
           If calling script is the showDraftDataset script, then the div element includes 
           a style attribute (for border color) plus the extra label. This stuff could go into params, too.
         -->
        <xsl:element name="div">
          <xsl:attribute name="id">{$mainTableAligmentStyle}</xsl:attribute>
          <xsl:if test="$referrer = 'showDraftDataset.cgi'">
            <xsl:attribute name="style">border: 4px orange solid</xsl:attribute>
            <div style="color: orange; font-weight: bold ">
              <xsl:text> DRAFT</xsl:text>
            </div>
          </xsl:if>
          <xsl:apply-templates select="*[local-name() = 'eml']"/>
        </xsl:element>
        <!-- closes the div element around the page. -->
        <!-- mob 2010-03-24 mob added to catch error msgs. -->
        <div>
          <xsl:apply-templates select="error"/>
        </div>

        <!-- commented out manually, mob 2019-05-08 -->
        <!-- end the content area -->
        <!-- begin the right sidebar area -->
        <!--       <xsl:call-template name="page_rightsidebar"/> -->
        <!-- end the right sidebar area -->
        <!-- begin the left sidebar area -->
        <!--      <xsl:call-template name="page_leftsidebar"/>  -->
        <!-- end the left sidebar area -->
        <!-- begin the footer area -->
        <!--       <xsl:call-template name="pagefooter"/>  -->
        <!-- end the footer area -->
      </xsl:element>
    </html>
  </xsl:template>
  <!-- mob 2010-03-24
  TO DO: add a template with a form to let the user log in and then resend the dp. -->
  <xsl:template match="error">
    <xsl:value-of select="."/>
  </xsl:template>
  
  
  <xsl:template match="*[local-name() = 'eml']">
    <!-- hang onto first title to pass to child pages -->
    <xsl:param name="resourcetitle">
      <xsl:text>FOO FOO FOO</xsl:text>
     <!--  <xsl:value-of select="*/title"/> -->
    </xsl:param>
    <xsl:param name="packageID">
      <xsl:value-of select="@packageId"/>
    </xsl:param>
    <xsl:for-each select="dataset">
      <!--  debug: <xsl:value-of select="$packageID"/>  :eml.xsl line 153  -->
      <xsl:call-template name="emldataset">
        <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
        <xsl:with-param name="packageID" select="$packageID"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="citation">
      <xsl:call-template name="emlcitation"/>
    </xsl:for-each>
    <xsl:for-each select="software">
      <xsl:call-template name="emlsoftware"/>
    </xsl:for-each>
    <xsl:for-each select="protocol">
      <xsl:call-template name="emlprotocol"/>
    </xsl:for-each>
    <!-- Additional metadata-->
    <xsl:choose>
      <xsl:when test="$displaymodule = 'additionalmetadata'">
        <xsl:for-each select="additionalMetadata">
          <xsl:if test="$additionalmetadataindex = position()">
            <div class="{$tabledefaultStyle}">
              <xsl:call-template name="additionalmetadata"/>
            </div>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$displaymodule = 'dataset'">
          <xsl:if test="$withAdditionalMetadataLink = '1'">
            <xsl:for-each select="additionalMetadata">
              <div class="{$tabledefaultStyle}">
                <xsl:call-template name="additionalmetadataURL">
                  <xsl:with-param name="index" select="position()"/>
                </xsl:call-template>
              </div>
            </xsl:for-each>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <!-- xml format-->
    <xsl:if test="$displaymodule = 'dataset'">
      <xsl:if test="$withOriginalXMLLink = '1'">
        <xsl:call-template name="xml"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <!--********************************************************
                       dataset part
       ********************************************************-->
  <xsl:template name="emldataset">
  <!--   <xsl:param name="resourcetitle" select="$resourcetitle"/> -->
    <xsl:param name="entitytype" select="$entitytype"/>
    <xsl:param name="entityindex" select="$entityindex"/>
    <xsl:param name="packageID"/>
    <!-- when you put the select here, it broke. understand why, please.  -->
    <!-- <div class="{$mainContainerTableStyle}"> -->
    <xsl:if test="$displaymodule = 'dataset'">
      <xsl:call-template name="datasetpart">
        <xsl:with-param name="packageID" select="$packageID"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$displaymodule = 'entity'">
      <xsl:call-template name="entitypart"/>
    </xsl:if>
    <!-- mob added 2010-03-26 -->
    <xsl:if test="$displaymodule = 'responsibleparties'">
      <xsl:call-template name="responsiblepartiespart">
        <xsl:with-param name="docid" select="$docid"/>
 <!--        <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
        <xsl:with-param name="packageID" select="$packageID"/> --> 
      </xsl:call-template>
    </xsl:if>
    <!-- mob added 2010-03-26. this one only used by attribute-level coverage  -->
    <xsl:if test="$displaymodule = 'coverage'">
      <xsl:call-template name="coveragepart">
        <xsl:with-param name="docid" select="$docid"/>
        <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
      </xsl:call-template>
    </xsl:if>
    <!-- mob added 2010-03-26  -->
    <xsl:if test="$displaymodule = 'coverageall'">
      <xsl:call-template name="ifcoverage">
        <xsl:with-param name="docid" select="$docid"/>
        <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
        <xsl:with-param name="packageID" select="$packageID"/>
      </xsl:call-template>
    </xsl:if>
    <!-- mob added 2010-03-26  -->
    <xsl:if test="$displaymodule = 'methodsall'">
      <xsl:call-template name="ifmethods">
        <xsl:with-param name="docid" select="$docid"/>
        <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
        <xsl:with-param name="packageID" select="$packageID"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$displaymodule = 'attribute'">
      <xsl:call-template name="attributepart"/>
    </xsl:if>
    <xsl:if test="$displaymodule = 'attributedomain'">
      <xsl:call-template name="datasetattributedomain"/>
    </xsl:if>
    <xsl:if test="$displaymodule = 'attributecoverage'">
      <xsl:call-template name="datasetattributecoverage">
        <xsl:with-param name="entitytype" select="$entitytype"/>
        <xsl:with-param name="entityindex" select="$entityindex"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$displaymodule = 'attributemethod'">
      <xsl:call-template name="datasetattributemethod"/>
    </xsl:if>
    <xsl:if test="$displaymodule = 'inlinedata'">
      <xsl:call-template name="emlinlinedata"/>
    </xsl:if>
    <xsl:if test="$displaymodule = 'attributedetail'">
      <xsl:call-template name="entityparam"/>
    </xsl:if>
    <!--   </div> -->
  </xsl:template>
  <!--*************** Data set diaplay *************-->
  <xsl:template name="datasetpart">
    <xsl:param name="packageID"/>
    <xsl:apply-templates select="." mode="dataset">
      <xsl:with-param name="packageID" select="$packageID"/>
    </xsl:apply-templates>
  </xsl:template>
  <!--************ Entity diplay *****************-->
  <xsl:template name="entitypart">
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <xsl:call-template name="entitypartcommon"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="entitypartcommon"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="entitypartcommon">
    <!--      <tr><th colspan="2">
      Entity Description
      </th></tr> -->
    <xsl:call-template name="identifier">
      <xsl:with-param name="packageID" select="../@packageId"/>
      <xsl:with-param name="system" select="../@system"/>
    </xsl:call-template>
    <tr>
      <td colspan="2">
        <!-- find the subtree to process -->
        <xsl:call-template name="entityparam"/>
      </td>
    </tr>
  </xsl:template>
  <!--************ Responsible Parties display *****************-->
  <xsl:template name="responsiblepartiespart">
    <xsl:param name="docid" select="$docid"/>
 <!--    <xsl:param name="resourcetitle" select="$resourcetitle"/>
    <xsl:param name="packageID" select="$packageID"/> --> 
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <xsl:call-template name="responsibleparties">
            <xsl:with-param name="docid" select="$docid"/>
   <!--          <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
            <xsl:with-param name="packageID" select="$packageID"/> --> 
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="responsibleparties">
          <xsl:with-param name="docid" select="$docid"/>
  <!--         <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
          <xsl:with-param name="packageID" select="$packageID"/> --> 
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="responsibleparties">
    <xsl:param name="docid" select="$docid"/>
  <!--   <xsl:param name="resourcetitle" select="$resourcetitle"/>
    <xsl:param name="packageID" select="$packageID"/> --> 
    <xsl:call-template name="datasettitle">
   <!--      <xsl:with-param name="packageID" select="$packageID"/>  --> 
    </xsl:call-template>
    <table class="onehundred_percent">
      <tr>
        <td>
          <xsl:call-template name="datasetmenu">
            <xsl:with-param name="currentmodule">responsibleparties</xsl:with-param>
 <!--            <xsl:with-param name="packageID" select="$packageID"/> --> 
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td>
          <!-- 
      
      a 2-column table with the involved parties in boxes across the entire page -->
          <table class="subGroup onehundred_percent">
            <xsl:if test="publisher">
              <th colspan="2">Publishers:</th>
              <xsl:for-each select="publisher">
                <tr>
                  <xsl:if test="position() mod 2 = 1">
                    <td class="fortyfive_percent">
                      <xsl:call-template name="party">
                        <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
                        <xsl:with-param name="partysecondColStyle" select="$secondColStyle"/>
                      </xsl:call-template>
                    </td>
                    <xsl:for-each select="following-sibling::publisher[position() = 1]">
                      <td class="fortyfive_percent">
                        <xsl:call-template name="party">
                          <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
                          <xsl:with-param name="partysecondColStyle" select="$secondColStyle"/>
                        </xsl:call-template>
                      </td>
                    </xsl:for-each>
                  </xsl:if>
                </tr>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="creator">
              <th colspan="2">Owners:</th>
              <xsl:for-each select="creator">
                <tr>
                  <xsl:if test="position() mod 2 = 1">
                    <td class="fortyfive_percent">
                      <xsl:call-template name="party">
                        <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
                        <xsl:with-param name="partysecondColStyle" select="$secondColStyle"/>
                      </xsl:call-template>
                    </td>
                    <xsl:for-each select="following-sibling::creator[position() = 1]">
                      <td class="fortyfive_percent">
                        <xsl:call-template name="party">
                          <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
                          <xsl:with-param name="partysecondColStyle" select="$secondColStyle"/>
                        </xsl:call-template>
                      </td>
                    </xsl:for-each>
                  </xsl:if>
                </tr>
              </xsl:for-each>
            </xsl:if>
            <!-- add in the contacts using a two column table -->
            <xsl:if test="contact">
              <th colspan="2">Contacts:</th>
              <xsl:for-each select="contact">
                <tr>
                  <xsl:if test="position() mod 2 = 1">
                    <td class="fortyfive_percent">
                      <xsl:call-template name="party">
                        <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
                        <xsl:with-param name="partysecondColStyle" select="$secondColStyle"/>
                      </xsl:call-template>
                    </td>
                    <xsl:for-each select="following-sibling::contact[position() = 1]">
                      <td class="fortyfive_percent">
                        <xsl:call-template name="party">
                          <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
                          <xsl:with-param name="partysecondColStyle" select="$secondColStyle"/>
                        </xsl:call-template>
                      </td>
                    </xsl:for-each>
                  </xsl:if>
                </tr>
              </xsl:for-each>
            </xsl:if>
            <!-- add in the associatedParty using a two column table -->
            <xsl:if test="associatedParty">
              <th colspan="2">Associated Parties:</th>
              <xsl:for-each select="associatedParty">
                <tr>
                  <xsl:if test="position() mod 2 = 1">
                    <td class="fortyfive_percent">
                      <xsl:call-template name="party">
                        <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
                        <xsl:with-param name="partysecondColStyle" select="$secondColStyle"/>
                      </xsl:call-template>
                    </td>
                    <xsl:for-each select="following-sibling::associatedParty[position() = 1]">
                      <td class="fortyfive_percent">
                        <xsl:call-template name="party">
                          <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
                          <xsl:with-param name="partysecondColStyle" select="$secondColStyle"/>
                        </xsl:call-template>
                      </td>
                    </xsl:for-each>
                  </xsl:if>
                </tr>
              </xsl:for-each>
            </xsl:if>
            <!-- add in the metadataProviders using a two column table -->
            <xsl:if test="metadataProvider">
              <th colspan="2">Metadata Providers:</th>
              <xsl:for-each select="metadataProvider">
                <tr>
                  <xsl:if test="position() mod 2 = 1">
                    <td class="fortyfive_percent">
                      <xsl:call-template name="party">
                        <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
                        <xsl:with-param name="partysecondColStyle" select="$secondColStyle"/>
                      </xsl:call-template>
                    </td>
                    <xsl:for-each select="following-sibling::metadataProvider[position() = 1]">
                      <td class="fortyfive_percent">
                        <xsl:call-template name="party">
                          <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
                          <xsl:with-param name="partysecondColStyle" select="$secondColStyle"/>
                        </xsl:call-template>
                      </td>
                    </xsl:for-each>
                  </xsl:if>
                </tr>
              </xsl:for-each>
            </xsl:if>
          </table>
        </td>
      </tr>
    </table>
    <!-- closes the table wrapping the dataset-menu  -->
  </xsl:template>
  <xsl:template name="coveragepart">
    <xsl:param name="docid" select="$docid"/>
  <!--   <xsl:param name="resourcetitle" select="$resourcetitle"/> --> 
    <h3>Data Set Coverage</h3>
  <!--   <h4><xsl:value-of select="$resourcetitle"/>  (<a><xsl:attribute name="href"><xsl:value-of
            select="$tripleURI"/><xsl:value-of select="$docid"/></xsl:attribute>return to dataset
        summary</a>) </h4> --> 
    <!-- add in the coverage info -->
    <table class="subGroup onehundred_percent">
      <tr>
        <!-- add in the geographic coverage info -->
        <td class="fortyfive_percent">
          <xsl:if test="./coverage/geographicCoverage">
            <xsl:for-each select="./coverage/geographicCoverage">
              <xsl:call-template name="geographicCoverage">
                <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:if>
        </td>
        <!-- mob 2010-03-24: moved up to general information area -->
        <!-- add in the temporal coverage info
          <td class="fortyfive_percent">
          <xsl:if test="./coverage/temporalCoverage">
          <xsl:for-each select="./coverage/temporalCoverage">
          <xsl:call-template name="temporalCoverage">
          <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
          <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
          </xsl:call-template>
          </xsl:for-each>
          </xsl:if>
          </td> -->
      </tr>
      <tr>
        <!-- add in the taxonomic coverage info -->
        <td colspan="2" class="onehundred_percent">
          <xsl:if test="./coverage/taxonomicCoverage">
            <xsl:for-each select="./coverage/taxonomicCoverage">
              <xsl:call-template name="taxonomicCoverage">
                <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:if>
        </td>
      </tr>
    </table>
  </xsl:template>
  <!-- 
    
    
  template to show comprehensive coverage info from resource, entity and attribute modules.
  not from project tree.
  added by mob 2010-apr
  -->
  <xsl:template name="coverageall">
    <xsl:param name="docid" select="$docid"/>
 <!--    <xsl:param name="resourcetitle" select="$resourcetitle"/>
    <xsl:param name="packageID" select="$packageID"/>  -->
    <xsl:call-template name="datasettitle">
 <!--      <xsl:with-param name="packageID" select="$packageID"/> --> 
    </xsl:call-template>
    <table>
      <tr>
        <td>
          <xsl:call-template name="datasetmenu">
            <xsl:with-param name="currentmodule">coverageall</xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td>
          <!-- 
        <xsl:call-template name="datasetmixed"/> -->
          <h4>
            <xsl:text>Temporal, Geographic and/or Taxonomic information that applies to all data in this dataset: </xsl:text>
          </h4>
          <table class="subGroup onehundred_percent">
            <tr>
              <!-- add in the resource-level temporal coverage info -->
              <td class="fortyfive_percent">
                <xsl:if test="./coverage">
                  <!-- print the type of parent element, and title or description -->
                  <xsl:for-each select="./coverage/temporalCoverage">
                    <xsl:call-template name="temporalCoverage">
                      <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                      <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                    </xsl:call-template>
                  </xsl:for-each>
                  <!-- mob: wrap all the geocov in a table to be treated as a unit. -->
                  <xsl:if test="./coverage/geographicCoverage">
                    <table class="subGroup subGroup_border onehundred_percent">
                      <!-- header for the geographic coverage area -->
                      <tr>
                        <th colspan="2">Geographic Coverage</th>
                      </tr>
                      <tr>
                        <!-- <td class="fortyfive_percent"> -->
                        <td class="">
                          <xsl:for-each select="./coverage/geographicCoverage">
                            <xsl:call-template name="geographicCoverage">
                              <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                              <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                            </xsl:call-template>
                          </xsl:for-each>
                        </td>
                        <!-- td class=" fortyfive_percent"> -->
                        <td class="">
                          <div class="eml_map">
                            <div id="map_canvas" style="width: 400px; height: 300px;"/>
                          </div>
                          <xsl:call-template name="geoCovMap">
                            <xsl:with-param name="currentmodule">coverageall</xsl:with-param>
                          </xsl:call-template>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                  <xsl:for-each select="./coverage/taxonomicCoverage">
                    <xsl:call-template name="taxonomicCoverage">
                      <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                      <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:if>
              </td>
            </tr>
          </table>
          <!-- 
      next comes the entity level coverages. attribute-level stuff under it's entity name -->
          <!--     <table class="subGroup onehundred_percent">
      <tr> -->
          <!--  TO DO: this needs to work for all entity types. choose label based on element name  -->
          <xsl:for-each select="dataTable">
            <xsl:if test="coverage or *//attribute/coverage">
              <h4>
                <xsl:text>Temporal, Geographic and/or Taxonomic information that applies to Data Table: </xsl:text>
                <xsl:value-of select="entityName"/>
              </h4>
              <!--    <table     class="subGroup onehundred_percent">
            <tr>
                     <th>
         <xsl:text>Applies to Data Table: </xsl:text>
          <xsl:value-of select="entityName"/>
        </th>
            </tr>  -->
              <xsl:if test="coverage">
                <!-- if an entity-level cov tree -->
                <xsl:for-each select="./coverage/temporalCoverage">
                  <xsl:call-template name="temporalCoverage">
                    <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                    <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                  </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="./coverage/geographicCoverage">
                  <xsl:call-template name="geographicCoverage">
                    <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                    <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                  </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="./coverage/taxonomicCoverage">
                  <xsl:call-template name="taxonomicCoverage">
                    <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                    <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test=".//attribute/coverage">
                <!-- an attribute descendant has a cov tree -->
                <xsl:for-each select=".//attribute/coverage">
                  <table class="subGroup">
                    <tr>
                      <th>
                        <!-- create a label for that attribute's coverage info. use the orientation and attr label if it has one -->
                        <xsl:choose>
                          <xsl:when test="ancestor::dataTable/*//attributeOrientation = 'column'">
                            <xsl:text>Temporal, Geographic and/or Taxonomic information that applies to the data table column: </xsl:text>
                          </xsl:when>
                          <xsl:when test="ancestor::dataTable/*//attributeOrientation = 'row'">
                            <xsl:text>Temporal, Geographic and/or Taxonomic information that applies to the data table row: </xsl:text>
                          </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="../attributeLabel">
                            <xsl:value-of select="../attributeLabel"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="../attributeName"/>
                            <xsl:text>)</xsl:text>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="../attributeName"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <!-- end of cov info label  -->
                      </th>
                    </tr>
                    <tr>
                      <td>
                        <xsl:for-each select="temporalCoverage">
                          <xsl:call-template name="temporalCoverage">
                            <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                            <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                          </xsl:call-template>
                        </xsl:for-each>
                        <xsl:for-each select="geographicCoverage">
                          <xsl:call-template name="geographicCoverage">
                            <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                            <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                          </xsl:call-template>
                        </xsl:for-each>
                        <xsl:for-each select="taxonomicCoverage">
                          <xsl:call-template name="taxonomicCoverage">
                            <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                            <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                          </xsl:call-template>
                        </xsl:for-each>
                      </td>
                    </tr>
                  </table>
                  <!-- closes the table for the attribute -->
                </xsl:for-each>
              </xsl:if>
              <!-- </table>  closes the table for the data entity  -->
            </xsl:if>
          </xsl:for-each>
          <!--      </tr>
 </table> -->
        </td>
      </tr>
    </table>
    <!-- closes the table wrapping the dataset-menu  -->
  </xsl:template>
  <!-- 
    
    
    template to show comprehensive methods info from resource, entity and attribute modules.
    not from project tree.
    added by mob 2010-apr
  -->
  <xsl:template name="ifmethods">
    <xsl:param name="packageID"/>
    <xsl:choose>
      <xsl:when test="(//method) or (//methods)">
        <xsl:call-template name="methodsall">
          <xsl:with-param name="docid"/>
          <xsl:with-param name="resourcetitle"/>
          <xsl:with-param name="packageID" select="$packageID"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="nodemissing">
          <xsl:with-param name="resourcetitle"/>
          <xsl:with-param name="nodemissing_message">No methods information
            available</xsl:with-param>
          <xsl:with-param name="currentmodule" select="$displaymodule"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="ifcoverage">
    <xsl:param name="packageID"/>
    <xsl:choose>
      <xsl:when test="(//coverage) or (//coverage)">
        <xsl:call-template name="coverageall">
          <xsl:with-param name="docid"/>
          <xsl:with-param name="resourcetitle"/>
          <xsl:with-param name="packageID" select="$packageID"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="nodemissing">
          <xsl:with-param name="resourcetitle"/>
          <xsl:with-param name="nodemissing_message">No coverage information
            available</xsl:with-param>
          <xsl:with-param name="currentmodule" select="$displaymodule"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="nodemissing">
    <xsl:text>TO DO, or reinstate</xsl:text>
    <!-- 
    <xsl:param name="docid" select="$docid"/>
    <xsl:param name="resourcetitle" select="$resourcetitle"/>
    <xsl:param name="nodemissing_message"/>
    <xsl:param name="currentmodule" select="$currentmodule"/>
    <xsl:call-template name="datasettitle"/>
    <table class="onehundred_percent">
      <tr>
        <td>
          <xsl:call-template name="datasetmenu">
            <xsl:with-param name="currentmodule" select="$currentmodule"/>
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td align="center">
          <h4>
            <xsl:value-of select="$nodemissing_message"/>
          </h4>
        </td>
      </tr>
    </table>
    -->
    
  </xsl:template>
  <xsl:template name="methodsall">
    <xsl:param name="docid" select="$docid"/>
 <!--    <xsl:param name="resourcetitle" select="$resourcetitle"/>
    <xsl:param name="packageID" select="$packageID"/> 
    <xsl:call-template name="datasettitle">
      <xsl:with-param name="packageID" select="$packageID"/>
    </xsl:call-template>--> 
    
    <table class="onehundred_percent">
      <tr>
        <td>
          <xsl:call-template name="datasetmenu">
            <xsl:with-param name="currentmodule">methodsall</xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td>
          <h4>
            <xsl:text>These methods, instrumentation and/or protocols apply to all data in this dataset: </xsl:text>
          </h4>
          <table class="subGroup onehundred_percent">
            <tr>
              <!-- add in the resource-level temporal coverage info -->
              <td class="fortyfive_percent">
                <xsl:if test="./methods">
                  <!-- print the type of parent element, and title or description -->
                  <xsl:for-each select="./methods">
                    <xsl:call-template name="datasetmethod">
                      <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                      <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:if>
              </td>
            </tr>
          </table>
          <!-- 
          next comes the entity level coverages. attribute-level stuff under it's entity name -->
          <!--     <table class="subGroup onehundred_percent">
          <tr> -->
          <!--  TO DO: this needs to work for all entity types. choose label based on element name  -->
          <xsl:for-each select="dataTable">
            <xsl:if
              test="(./methods) or (*//attribute/methods) or (./method) or (*//attribute/method)">
              <h4>
                <xsl:text>These methods, instrumentation and/or protocols apply  to Data Table: </xsl:text>
                <xsl:value-of select="entityName"/>
              </h4>
              <xsl:if test="(./method) or (./methods)">
                <!-- first find an entity-level methods tree -->
                <!--  this becomes METHODS in eml 2.1 -->
                <xsl:for-each select="method | methods">
                  <xsl:call-template name="datasetmethod">
                    <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                    <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="(*//attribute/methods) or (*//attribute/method)">
                <!-- an attribute descendant has a method tree -->
                <xsl:for-each select="*//attribute/method | *//attribute/methods">
                  <!-- mob fixed 2011-12-23 - missing 'or'  -->
                  <table class="subGroup">
                    <tr>
                      <th>
                        <!-- create a label for that attribute's coverage info. use the orientation and attr label if it has one -->
                        <xsl:choose>
                          <xsl:when test="ancestor::dataTable/*//attributeOrientation = 'column'">
                            <xsl:text>These methods, instrumentation and/or protocols apply  to the data table column: </xsl:text>
                          </xsl:when>
                          <xsl:when test="ancestor::dataTable/*//attributeOrientation = 'row'">
                            <xsl:text>These methods, instrumentation and/or protocols apply  to the data table row: </xsl:text>
                          </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="../attributeLabel">
                            <xsl:value-of select="../attributeLabel"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="../attributeName"/>
                            <xsl:text>)</xsl:text>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="../attributeName"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <!-- end of cov info label  -->
                      </th>
                    </tr>
                    <tr>
                      <td>
                        <xsl:for-each select=".">
                          <xsl:call-template name="datasetmethod">
                            <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                            <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                          </xsl:call-template>
                        </xsl:for-each>
                      </td>
                    </tr>
                  </table>
                  <!-- closes the table for the attribute -->
                </xsl:for-each>
              </xsl:if>
              <!-- </table>  closes the table for the data entity  -->
            </xsl:if>
          </xsl:for-each>
          <!--      </tr>
          </table> -->
        </td>
      </tr>
    </table>
    <!-- closes the table wrapping the dataset-menu  -->
  </xsl:template>
  <!--************ Attribute display *****************-->
  <xsl:template name="attributedetailpart"/>
  <xsl:template name="attributepart">
    <tr>
      <td>
        <h3>Attributes Description</h3>
      </td>
    </tr>
    <tr>
      <td>
        <!-- find the subtree to process -->
        <xsl:if test="$entitytype = 'dataTable'">
          <xsl:for-each select="dataTable">
            <xsl:if test="position() = $entityindex">
              <xsl:for-each select="attributeList">
                <xsl:call-template name="attributelist">
                  <xsl:with-param name="docid" select="$docid"/>
                  <xsl:with-param name="entitytype" select="$entitytype"/>
                  <xsl:with-param name="entityindex" select="$entityindex"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </td>
    </tr>
  </xsl:template>
  <!--************************Attribute Domain display module************************-->
  <xsl:template name="datasetattributedomain">
    <!-- 
       
       these params are used to construct links back , and to provide the attribute name or label as a variable -->
    <xsl:param name="entityindex" select="$entityindex"/>
    <xsl:param name="entitytype" select="$entitytype"/>
    <xsl:param name="attributeindex" select="$attributeindex"/>
    <xsl:variable name="attribute_label">
      <xsl:choose>
        <xsl:when test="*/attributeList/attribute[number($attributeindex)]/attributeLabel">
          <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeLabel"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName"/>
          <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- 
       begin the display -->
    <tr>
      <td>
        <!--  
          
          Include the label, and a link back to the dataset, or the data table. -->
        <table class="dataset-entity-part">
          <tr>
            <td class="dataset-entity-part-header">
              <h3>Codes and Definitions for: <xsl:value-of select="$attribute_label"/></h3>
            </td>
            <td>
              <div class="dataset-entity-part-backtos">
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$tripleURI"/>
                    <xsl:value-of select="$docid"/>
                  </xsl:attribute>
                  <xsl:attribute name="class">datasetmenu</xsl:attribute>
                  <xsl:text>Back to Dataset  Summary  and Tabbed View</xsl:text>
                </xsl:element>
              </div>
              <div class="dataset-entity-part-backtos">
                <xsl:element name="a">
                  <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                      select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of
                      select="$entitytype"/>&amp;entityindex=<xsl:value-of select="$entityindex"
                    /></xsl:attribute>
                  <xsl:attribute name="class">datasetmenu</xsl:attribute>
                  <xsl:text>Back to Data Table Description</xsl:text>
                </xsl:element>
              </div>
            </td>
          </tr>
        </table>
        <!-- <h3>Attribute Domain</h3> -->
      </td>
    </tr>
    <tr>
      <td>
        <!--
         
         find the subtree to process -->
        <xsl:call-template name="entityparam"/>
      </td>
    </tr>
  </xsl:template>
  <!--************************Attribute Method display module************************-->
  <xsl:template name="datasetattributemethod">
    <!-- 
       
       these params are used to construct links back , and to provide the attribute name or label as a variable -->
    <xsl:param name="entityindex" select="$entityindex"/>
    <xsl:param name="entitytype" select="$entitytype"/>
    <xsl:param name="attributeindex" select="$attributeindex"/>
    <xsl:variable name="attribute_label">
      <xsl:choose>
        <xsl:when test="*/attributeList/attribute[number($attributeindex)]/attributeLabel">
          <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeLabel"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName"/>
          <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- 
       begin the display -->
    <tr>
      <td>
        <!--  
         
         Include the label, and a link back to the dataset, or the data table. -->
        <table class="dataset-entity-part">
          <tr>
            <td class="dataset-entity-part-header">
              <h3>Method for Attribute: <xsl:value-of select="$attribute_label"/></h3>
            </td>
            <td>
              <div class="dataset-entity-part-backtos">
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$tripleURI"/>
                    <xsl:value-of select="$docid"/>
                  </xsl:attribute>
                  <xsl:attribute name="class">datasetmenu</xsl:attribute>
                  <xsl:text>Back to Dataset  Summary  and Tabbed View</xsl:text>
                </xsl:element>
              </div>
              <div class="dataset-entity-part-backtos">
                <xsl:element name="a">
                  <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                      select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of
                      select="$entitytype"/>&amp;entityindex=<xsl:value-of select="$entityindex"
                    /></xsl:attribute>
                  <xsl:attribute name="class">datasetmenu</xsl:attribute>
                  <xsl:text>Back to Data Table Description</xsl:text>
                </xsl:element>
              </div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <!-- 
         
         find the subtree to process -->
        <xsl:call-template name="entityparam"/>
      </td>
    </tr>
  </xsl:template>
  <!--************************Attribute Coverage display module************************-->
  <xsl:template name="datasetattributecoverage">
    <!-- 
       
       these params are used to construct links back , and to provide the attribute name or label as a variable -->
    <xsl:param name="entityindex" select="$entityindex"/>
    <xsl:param name="entitytype" select="$entitytype"/>
    <xsl:param name="attributeindex" select="$attributeindex"/>
    <xsl:variable name="attribute_label">
      <xsl:choose>
        <xsl:when test="*/attributeList/attribute[number($attributeindex)]/attributeLabel">
          <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeLabel"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName"/>
          <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- 
       begin the display -->
    <tr>
      <td>
        <!--  
         
         Include the label, and a link back to the dataset, or the data table. -->
        <table class="dataset-entity-part">
          <tr>
            <td class="dataset-entity-part-header">
              <h3>Coverage for Attribute: <xsl:value-of select="$attribute_label"/></h3>
            </td>
            <td>
              <div class="dataset-entity-part-backtos">
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$tripleURI"/>
                    <xsl:value-of select="$docid"/>
                  </xsl:attribute>
                  <xsl:attribute name="class">datasetmenu</xsl:attribute>
                  <xsl:text>Back to Dataset  Summary  and Tabbed View</xsl:text>
                </xsl:element>
              </div>
              <div class="dataset-entity-part-backtos">
                <xsl:element name="a">
                  <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                      select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of
                      select="$entitytype"/>&amp;entityindex=<xsl:value-of select="$entityindex"
                    /></xsl:attribute>
                  <xsl:attribute name="class">datasetmenu</xsl:attribute>
                  <xsl:text>Back to Data Table Description</xsl:text>
                </xsl:element>
              </div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <!-- 
         
         find the subtree to process -->
        <xsl:call-template name="entityparam"/>
      </td>
    </tr>
  </xsl:template>
  <!-- TO DO:
  I think that the sorting of the entities based on type instead of keeping them in document-order
  happens here. In march 2014, mob tested a few things without success, but did not dig into refactoring. -->
  <xsl:template name="entityparam">
    <xsl:choose>
      <xsl:when test="$entitytype = ''">
        <xsl:variable name="dataTableCount" select="0"/>
        <xsl:variable name="spatialRasterCount" select="0"/>
        <xsl:variable name="spatialVectorCount" select="0"/>
        <xsl:variable name="storedProcedureCount" select="0"/>
        <xsl:variable name="viewCount" select="0"/>
        <xsl:variable name="otherEntityCount" select="0"/>
        <xsl:for-each
          select="dataTable | spatialRaster | spatialVector | storedProcedure | view | otherEntity">
          <xsl:if test="'dataTable' = name()">
            <xsl:variable name="currentNode" select="."/>
            <xsl:variable name="dataTableCount">
              <xsl:for-each select="../dataTable">
                <xsl:if test=". = $currentNode">
                  <xsl:value-of select="position()"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:variable>
            <xsl:if test="position() = $entityindex">
              <xsl:choose>
                <xsl:when test="$displaymodule = 'attributedetail'">
                  <xsl:for-each select="attributeList">
                    <xsl:call-template name="singleattribute">
                      <xsl:with-param name="attributeindex" select="$attributeindex"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="'dataTable'"/>
                      <xsl:with-param name="entityindex" select="$dataTableCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="../.">
                    <xsl:call-template name="chooseentity">
                      <xsl:with-param name="entitytype" select="'dataTable'"/>
                      <xsl:with-param name="entityindex" select="$dataTableCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:if>
          <xsl:if test="'spatialRaster' = name()">
            <xsl:variable name="currentNode" select="."/>
            <xsl:variable name="spatialRasterCount">
              <xsl:for-each select="../spatialRaster">
                <xsl:if test=". = $currentNode">
                  <xsl:value-of select="position()"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:variable>
            <xsl:if test="position() = $entityindex">
              <xsl:choose>
                <xsl:when test="$displaymodule = 'attributedetail'">
                  <xsl:for-each select="attributeList">
                    <xsl:call-template name="singleattribute">
                      <xsl:with-param name="attributeindex" select="$attributeindex"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="'spatialRaster'"/>
                      <xsl:with-param name="entityindex" select="$spatialRasterCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="../.">
                    <xsl:call-template name="chooseentity">
                      <xsl:with-param name="entitytype" select="'spatialRaster'"/>
                      <xsl:with-param name="entityindex" select="$spatialRasterCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:if>
          <xsl:if test="'spatialVector' = name()">
            <xsl:variable name="currentNode" select="."/>
            <xsl:variable name="spatialVectorCount">
              <xsl:for-each select="../spatialVector">
                <xsl:if test=". = $currentNode">
                  <xsl:value-of select="position()"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:variable>
            <xsl:if test="position() = $entityindex">
              <xsl:choose>
                <xsl:when test="$displaymodule = 'attributedetail'">
                  <xsl:for-each select="attributeList">
                    <xsl:call-template name="singleattribute">
                      <xsl:with-param name="attributeindex" select="$attributeindex"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="'spatialVector'"/>
                      <xsl:with-param name="entityindex" select="$spatialVectorCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="../.">
                    <xsl:call-template name="chooseentity">
                      <xsl:with-param name="entitytype" select="'spatialVector'"/>
                      <xsl:with-param name="entityindex" select="$spatialVectorCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:if>
          <xsl:if test="'storedProcedure' = name()">
            <xsl:variable name="currentNode" select="."/>
            <xsl:variable name="storedProcedureCount">
              <xsl:for-each select="../storedProcedure">
                <xsl:if test=". = $currentNode">
                  <xsl:value-of select="position()"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:variable>
            <xsl:if test="position() = $entityindex">
              <xsl:choose>
                <xsl:when test="$displaymodule = 'attributedetail'">
                  <xsl:for-each select="attributeList">
                    <xsl:call-template name="singleattribute">
                      <xsl:with-param name="attributeindex" select="$attributeindex"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="'storedProcedure'"/>
                      <xsl:with-param name="entityindex" select="$storedProcedureCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="../.">
                    <xsl:call-template name="chooseentity">
                      <xsl:with-param name="entitytype" select="'storedProcedure'"/>
                      <xsl:with-param name="entityindex" select="$storedProcedureCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:if>
          <xsl:if test="'view' = name()">
            <xsl:variable name="currentNode" select="."/>
            <xsl:variable name="viewCount">
              <xsl:for-each select="../view">
                <xsl:if test=". = $currentNode">
                  <xsl:value-of select="position()"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:variable>
            <xsl:if test="position() = $entityindex">
              <xsl:choose>
                <xsl:when test="$displaymodule = 'attributedetail'">
                  <xsl:for-each select="attributeList">
                    <xsl:call-template name="singleattribute">
                      <xsl:with-param name="attributeindex" select="$attributeindex"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="'view'"/>
                      <xsl:with-param name="entityindex" select="$viewCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="../.">
                    <xsl:call-template name="chooseentity">
                      <xsl:with-param name="entitytype" select="'view'"/>
                      <xsl:with-param name="entityindex" select="$viewCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:if>
          <xsl:if test="'otherEntityTable' = name()">
            <xsl:variable name="currentNode" select="."/>
            <xsl:variable name="otherEntityCount">
              <xsl:for-each select="../otherEntity">
                <xsl:if test=". = $currentNode">
                  <xsl:value-of select="position()"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:variable>
            <xsl:if test="position() = $entityindex">
              <xsl:choose>
                <xsl:when test="$displaymodule = 'attributedetail'">
                  <xsl:for-each select="attributeList">
                    <xsl:call-template name="singleattribute">
                      <xsl:with-param name="attributeindex" select="$attributeindex"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="'otherEntity'"/>
                      <xsl:with-param name="entityindex" select="$otherEntityCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="../.">
                    <xsl:call-template name="chooseentity">
                      <xsl:with-param name="entitytype" select="'otherEntity'"/>
                      <xsl:with-param name="entityindex" select="$otherEntityCount"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$displaymodule = 'attributedetail'">
            <xsl:for-each select="attributeList">
              <xsl:call-template name="singleattribute">
                <xsl:with-param name="attributeindex" select="$attributeindex"/>
                <xsl:with-param name="docid" select="$docid"/>
                <xsl:with-param name="entitytype" select="$entitytype"/>
                <xsl:with-param name="entityindex" select="$entityindex"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="chooseentity">
              <xsl:with-param name="entitytype" select="$entitytype"/>
              <xsl:with-param name="entityindex" select="$entityindex"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="chooseentity" match="dataset">
    <xsl:param name="entityindex"/>
    <xsl:param name="entitytype"/>
    <xsl:if test="$entitytype = 'dataTable'">
      <xsl:for-each select="dataTable">
        <xsl:if test="position() = $entityindex">
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="$displaymodule = 'entity'">
                    <xsl:call-template name="dataTable">
                      <xsl:with-param name="datatablefirstColStyle" select="$firstColStyle"/>
                      <xsl:with-param name="datatablesubHeaderStyle" select="$subHeaderStyle"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="$entitytype"/>
                      <xsl:with-param name="entityindex" select="$entityindex"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="chooseattributelist"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$displaymodule = 'entity'">
                  <xsl:call-template name="dataTable">
                    <xsl:with-param name="datatablefirstColStyle" select="$firstColStyle"/>
                    <xsl:with-param name="datatablesubHeaderStyle" select="$subHeaderStyle"/>
                    <xsl:with-param name="docid" select="$docid"/>
                    <xsl:with-param name="entitytype" select="$entitytype"/>
                    <xsl:with-param name="entityindex" select="$entityindex"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="chooseattributelist"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$entitytype = 'spatialRaster'">
      <xsl:for-each select="spatialRaster">
        <xsl:if test="position() = $entityindex">
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="$displaymodule = 'entity'">
                    <xsl:call-template name="spatialRaster">
                      <xsl:with-param name="spatialrasterfirstColStyle" select="$firstColStyle"/>
                      <xsl:with-param name="spatialrastersubHeaderStyle" select="$subHeaderStyle"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="$entitytype"/>
                      <xsl:with-param name="entityindex" select="$entityindex"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="chooseattributelist"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$displaymodule = 'entity'">
                  <xsl:call-template name="spatialRaster">
                    <xsl:with-param name="spatialrasterfirstColStyle" select="$firstColStyle"/>
                    <xsl:with-param name="spatialrastersubHeaderStyle" select="$subHeaderStyle"/>
                    <xsl:with-param name="docid" select="$docid"/>
                    <xsl:with-param name="entitytype" select="$entitytype"/>
                    <xsl:with-param name="entityindex" select="$entityindex"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="chooseattributelist"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$entitytype = 'spatialVector'">
      <xsl:for-each select="spatialVector">
        <xsl:if test="position() = $entityindex">
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="$displaymodule = 'entity'">
                    <xsl:call-template name="spatialVector">
                      <xsl:with-param name="spatialvectorfirstColStyle" select="$firstColStyle"/>
                      <xsl:with-param name="spatialvectorsubHeaderStyle" select="$subHeaderStyle"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="$entitytype"/>
                      <xsl:with-param name="entityindex" select="$entityindex"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="chooseattributelist"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$displaymodule = 'entity'">
                  <xsl:call-template name="spatialVector">
                    <xsl:with-param name="spatialvectorfirstColStyle" select="$firstColStyle"/>
                    <xsl:with-param name="spatialvectorsubHeaderStyle" select="$subHeaderStyle"/>
                    <xsl:with-param name="docid" select="$docid"/>
                    <xsl:with-param name="entitytype" select="$entitytype"/>
                    <xsl:with-param name="entityindex" select="$entityindex"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="chooseattributelist"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$entitytype = 'storedProcedure'">
      <xsl:for-each select="storedProcedure">
        <xsl:if test="position() = $entityindex">
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="$displaymodule = 'entity'">
                    <xsl:call-template name="storedProcedure">
                      <xsl:with-param name="storedprocedurefirstColStyle" select="$firstColStyle"/>
                      <xsl:with-param name="storedproceduresubHeaderStyle" select="$subHeaderStyle"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="$entitytype"/>
                      <xsl:with-param name="entityindex" select="$entityindex"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="chooseattributelist"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$displaymodule = 'entity'">
                  <xsl:call-template name="storedProcedure">
                    <xsl:with-param name="storedprocedurefirstColStyle" select="$firstColStyle"/>
                    <xsl:with-param name="storedproceduresubHeaderStyle" select="$subHeaderStyle"/>
                    <xsl:with-param name="docid" select="$docid"/>
                    <xsl:with-param name="entitytype" select="$entitytype"/>
                    <xsl:with-param name="entityindex" select="$entityindex"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="chooseattributelist"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$entitytype = 'view'">
      <xsl:for-each select="view">
        <xsl:if test="position() = $entityindex">
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="$displaymodule = 'entity'">
                    <xsl:call-template name="view">
                      <xsl:with-param name="viewfirstColStyle" select="$firstColStyle"/>
                      <xsl:with-param name="viewsubHeaderStyle" select="$subHeaderStyle"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="$entitytype"/>
                      <xsl:with-param name="entityindex" select="$entityindex"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="chooseattributelist"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$displaymodule = 'entity'">
                  <xsl:call-template name="view">
                    <xsl:with-param name="viewfirstColStyle" select="$firstColStyle"/>
                    <xsl:with-param name="viewsubHeaderStyle" select="$subHeaderStyle"/>
                    <xsl:with-param name="docid" select="$docid"/>
                    <xsl:with-param name="entitytype" select="$entitytype"/>
                    <xsl:with-param name="entityindex" select="$entityindex"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="chooseattributelist"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$entitytype = 'otherEntity'">
      <xsl:for-each select="otherEntity">
        <xsl:if test="position() = $entityindex">
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="$displaymodule = 'entity'">
                    <xsl:call-template name="otherEntity">
                      <xsl:with-param name="otherentityfirstColStyle" select="$firstColStyle"/>
                      <xsl:with-param name="otherentitysubHeaderStyle" select="$subHeaderStyle"/>
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="$entitytype"/>
                      <xsl:with-param name="entityindex" select="$entityindex"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="chooseattributelist"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$displaymodule = 'entity'">
                  <xsl:call-template name="otherEntity">
                    <xsl:with-param name="otherentityfirstColStyle" select="$firstColStyle"/>
                    <xsl:with-param name="otherentitysubHeaderStyle" select="$subHeaderStyle"/>
                    <xsl:with-param name="docid" select="$docid"/>
                    <xsl:with-param name="entitytype" select="$entitytype"/>
                    <xsl:with-param name="entityindex" select="$entityindex"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="chooseattributelist"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name="chooseattributelist">
    <xsl:for-each select="attributeList">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="chooseattribute"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="chooseattribute"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="chooseattribute">
    <xsl:for-each select="attribute">
      <xsl:if test="position() = $attributeindex">
        <xsl:if test="$displaymodule = 'attributedomain'">
          <xsl:for-each select="measurementScale/*/*">
            <xsl:call-template name="nonNumericDomain">
              <xsl:with-param name="nondomainfirstColStyle" select="$firstColStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="$displaymodule = 'attributecoverage'">
          <xsl:for-each select="coverage">
            <xsl:call-template name="coverage">
              <xsl:with-param name="coveragefirstColStyle" select="$firstColStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="$displaymodule = 'attributemethod'">
          <xsl:for-each select="method | methods">
            <!-- mob kludge for eml2.1 -->
            <xsl:call-template name="method">
              <xsl:with-param name="methodfirstColStyle" select="$firstColStyle"/>
              <xsl:with-param name="methodsubHeaderStyle" select="$firstColStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!--*************************Distribution Inline Data display module*****************-->
  <xsl:template name="emlinlinedata">
    <tr>
      <td>
        <h3>Data (inline):</h3>
      </td>
    </tr>
    <tr>
      <td>
        <xsl:if test="$distributionlevel = 'toplevel'">
          <xsl:for-each select="distribution">
            <xsl:if test="position() = $distributionindex">
              <xsl:choose>
                <xsl:when test="references != ''">
                  <xsl:variable name="ref_id1" select="references"/>
                  <xsl:variable name="references1" select="$ids[@id = $ref_id1]"/>
                  <xsl:for-each select="$references1">
                    <xsl:for-each select="inline">
                      <pre>
                        <xsl:value-of select="." xml:space="preserve"/>
                      </pre>
                      <!--   <xsl:value-of select="."/> -->
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="inline">
                    <pre>
                      <xsl:value-of select="." xml:space="preserve"/>
                    </pre>
                    <!--    <xsl:value-of select="."/> -->
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="$distributionlevel = 'entitylevel'">
          <xsl:if test="$entitytype = 'dataTable'">
            <xsl:for-each select="dataTable">
              <xsl:if test="position() = $entityindex">
                <xsl:choose>
                  <xsl:when test="references != ''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id = $ref_id2]"/>
                    <xsl:for-each select="$references2">
                      <xsl:call-template name="choosephysical"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="choosephysical"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="$entitytype = 'spatialRaster'">
            <xsl:for-each select="spatialRaster">
              <xsl:if test="position() = $entityindex">
                <xsl:choose>
                  <xsl:when test="references != ''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id = $ref_id2]"/>
                    <xsl:for-each select="$references2">
                      <xsl:call-template name="choosephysical"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="choosephysical"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="$entitytype = 'spatialVector'">
            <xsl:for-each select="spatialVector">
              <xsl:if test="position() = $entityindex">
                <xsl:choose>
                  <xsl:when test="references != ''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id = $ref_id2]"/>
                    <xsl:for-each select="$references2">
                      <xsl:call-template name="choosephysical"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="choosephysical"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="$entitytype = 'storedProcedure'">
            <xsl:for-each select="storedProcedure">
              <xsl:if test="position() = $entityindex">
                <xsl:choose>
                  <xsl:when test="references != ''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id = $ref_id2]"/>
                    <xsl:for-each select="$references2">
                      <xsl:call-template name="choosephysical"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="choosephysical"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="$entitytype = 'view'">
            <xsl:for-each select="view">
              <xsl:if test="position() = $entityindex">
                <xsl:choose>
                  <xsl:when test="references != ''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id = $ref_id2]"/>
                    <xsl:for-each select="$references2">
                      <xsl:call-template name="choosephysical"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="choosephysical"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="$entitytype = 'otherEntity'">
            <xsl:for-each select="otherEntity">
              <xsl:if test="position() = $entityindex">
                <xsl:choose>
                  <xsl:when test="references != ''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id = $ref_id2]"/>
                    <xsl:for-each select="$references2">
                      <xsl:call-template name="choosephysical"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="choosephysical"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
        </xsl:if>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="choosephysical">
    <xsl:for-each select="physical">
      <xsl:if test="position() = $physicalindex">
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <xsl:call-template name="choosedistribution"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="choosedistribution"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="choosedistribution">
    <xsl:for-each select="distribution">
      <xsl:if test="$distributionindex = position()">
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <xsl:for-each select="inline">
                <pre>
                  <xsl:value-of select="." xml:space="preserve"/>
                </pre>
                <!--  <xsl:value-of select="."/> -->
              </xsl:for-each>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="inline">
              <pre>
                <xsl:value-of select="." xml:space="preserve"/>
              </pre>
              <!--  <xsl:value-of select="."/> -->
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!--********************************************************
               Citation part
       ********************************************************-->
  <xsl:template name="emlcitation">
    <xsl:choose>
      <xsl:when test="$displaymodule = 'inlinedata'">
        <xsl:call-template name="emlinlinedata"/>
      </xsl:when>
      <xsl:otherwise>
        <table xsl:use-attribute-sets="cellspacing" class="{$tabledefaultStyle}">
          <tr>
            <td colspan="2">
              <h3>Citation Description</h3>
            </td>
          </tr>
          <xsl:call-template name="identifier">
            <xsl:with-param name="packageID" select="../@packageId"/>
            <xsl:with-param name="system" select="../@system"/>
          </xsl:call-template>
          <tr>
            <td colspan="2">
              <xsl:call-template name="citation">
                <xsl:with-param name="citationfirstColStyle" select="$firstColStyle"/>
                <xsl:with-param name="citationsubHeaderStyle" select="$subHeaderStyle"/>
              </xsl:call-template>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--********************************************************
              Software part
       ********************************************************-->
  <xsl:template name="emlsoftware">
    <xsl:choose>
      <xsl:when test="$displaymodule = 'inlinedata'">
        <xsl:call-template name="emlinlinedata"/>
      </xsl:when>
      <xsl:otherwise>
        <table xsl:use-attribute-sets="cellspacing" class="{$tabledefaultStyle}">
          <tr>
            <td colspan="2">
              <h3>Software Description</h3>
            </td>
          </tr>
          <xsl:call-template name="identifier">
            <xsl:with-param name="packageID" select="../@packageId"/>
            <xsl:with-param name="system" select="../@system"/>
          </xsl:call-template>
          <tr>
            <td colspan="2">
              <xsl:call-template name="software">
                <xsl:with-param name="softwarefirstColStyle" select="$firstColStyle"/>
                <xsl:with-param name="softwaresubHeaderStyle" select="$subHeaderStyle"/>
              </xsl:call-template>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--********************************************************
              Protocol part
       ********************************************************-->
  <xsl:template name="emlprotocol">
    <xsl:choose>
      <xsl:when test="$displaymodule = 'inlinedata'">
        <xsl:call-template name="emlinlinedata"/>
      </xsl:when>
      <xsl:otherwise>
        <table xsl:use-attribute-sets="cellspacing" class="{$tabledefaultStyle}">
          <tr>
            <td colspan="2">
              <h3>Protocal Description</h3>
            </td>
          </tr>
          <xsl:call-template name="identifier">
            <xsl:with-param name="packageID" select="../@packageId"/>
            <xsl:with-param name="system" select="../@system"/>
          </xsl:call-template>
          <tr>
            <td colspan="2">
              <xsl:call-template name="protocol">
                <xsl:with-param name="protocolfirstColStyle" select="$firstColStyle"/>
                <xsl:with-param name="protocolsubHeaderStyle" select="$subHeaderStyle"/>
              </xsl:call-template>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--********************************************************
             additionalmetadata part
       ********************************************************-->
  <xsl:template name="additionalmetadataURL">
    <xsl:param name="index"/>
    <table class="{$tabledefaultStyle}">
      <tr>
        <td>
          <a><xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                select="$docid"
                />&amp;displaymodule=additionalmetadata&amp;additionalmetadataindex=<xsl:value-of
                select="$index"/></xsl:attribute> Additional Metadata </a>
        </td>
      </tr>
    </table>
  </xsl:template>
  <!--********************************************************
             download xml part
       ********************************************************-->
  <xsl:template name="xml"><xsl:param name="index"/><br/><a><xsl:attribute name="href"><xsl:value-of
          select="$xmlURI"/><xsl:value-of select="$docid"/></xsl:attribute> Download the original
      XML file (in Ecological Metadata Language) </a> Viewable in <a href="http://www.oxygenxml.com"
      title="Oxygen XML Editor"><img src="http://www.oxygenxml.com/img/resources/oxygen190x62.png"
        width="95" height="31" alt="Oxygen XML Editor" border="0"/></a></xsl:template>
  <!--
       ********************************************************
             adding ACCESS templates 
       ********************************************************
         -->
  <xsl:template name="access">
    <xsl:param name="accessfirstColStyle"/>
    <xsl:param name="accesssubHeaderStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="accessCommon">
              <xsl:with-param name="accessfirstColStyle" select="$accessfirstColStyle"/>
              <xsl:with-param name="accesssubHeaderStyle" select="$accesssubHeaderStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="accessCommon">
            <xsl:with-param name="accessfirstColStyle" select="$accessfirstColStyle"/>
            <xsl:with-param name="accesssubHeaderStyle" select="$accesssubHeaderStyle"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="accessCommon">
    <xsl:param name="accessfirstColStyle"/>
    <xsl:param name="accesssubHeaderStyle"/>
    <xsl:call-template name="accesssystem">
      <xsl:with-param name="accessfirstColStyle" select="$accessfirstColStyle"/>
      <xsl:with-param name="accesssubHeaderStyle" select="$accesssubHeaderStyle"/>
    </xsl:call-template>
    <xsl:if test="normalize-space(./@order) = 'allowFirst' and (allow)">
      <xsl:call-template name="allow_deny">
        <xsl:with-param name="permission" select="'allow'"/>
        <xsl:with-param name="accessfirstColStyle" select="$accessfirstColStyle"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="(deny)">
      <xsl:call-template name="allow_deny">
        <xsl:with-param name="permission" select="'deny'"/>
        <xsl:with-param name="accessfirstColStyle" select="$accessfirstColStyle"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="normalize-space(acl/@order) = 'denyFirst' and (allow)">
      <xsl:call-template name="allow_deny">
        <xsl:with-param name="permission" select="'allow'"/>
        <xsl:with-param name="accessfirstColStyle" select="$accessfirstColStyle"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name="allow_deny">
    <xsl:param name="permission"/>
    <xsl:param name="accessfirstColStyle"/>
    <xsl:choose>
      <xsl:when test="$permission = 'allow'">
        <xsl:for-each select="allow">
          <tr>
            <td class="{$accessfirstColStyle}"> Allow: </td>
            <td class="{$accessfirstColStyle}">
              <xsl:for-each select="./permission">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>] </xsl:text>
              </xsl:for-each>
            </td>
            <td class="{$accessfirstColStyle}">
              <xsl:for-each select="principal">
                <xsl:value-of select="."/>
                <br/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="deny">
          <tr>
            <td class="{$accessfirstColStyle}"> Deny: </td>
            <td class="{$accessfirstColStyle}">
              <xsl:for-each select="./permission">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>] </xsl:text>
              </xsl:for-each>
            </td>
            <td class="{$accessfirstColStyle}">
              <xsl:for-each select="principal">
                <xsl:value-of select="."/>
                <br/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="accesssystem">
    <xsl:param name="accessfirstColStyle"/>
    <tr>
      <th colspan="3">
        <xsl:text>Access Control:</xsl:text>
      </th>
    </tr>
    <tr>
      <td class="{$accessfirstColStyle}">Auth System:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="./@authSystem"/>
      </td>
    </tr>
    <tr>
      <td class="{$accessfirstColStyle}">Order:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="./@order"/>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding ADDITIONAL METADATA templates 
       ********************************************************
         -->
  <xsl:template name="additionalmetadata">
    <h3>Additional Metadata</h3>
    <pre>
      <xsl:text>additionalMetadata
</xsl:text>
      <xsl:apply-templates mode="ascii-art"/>
    </pre>
  </xsl:template>
  <xsl:template match="*" mode="ascii-art"><xsl:call-template name="ascii-art-hierarchy"
    /><xsl:text/>___element '<xsl:value-of select="local-name()"/>'<xsl:text/><xsl:if
      test="namespace-uri()"> in ns '<xsl:value-of select="namespace-uri()"/>' ('<xsl:value-of
        select="name()"/>')</xsl:if><xsl:text/><xsl:apply-templates select="@*" mode="ascii-art"
      /><xsl:if test="$show_ns"><xsl:for-each select="namespace::*"><xsl:call-template
          name="ascii-art-hierarchy"/><xsl:text/> \___namespace '<xsl:value-of select="name()"/>' =
          '<xsl:value-of select="."/>' <xsl:text/></xsl:for-each></xsl:if><xsl:apply-templates
      mode="ascii-art"/></xsl:template>
  <xsl:template match="@*" mode="ascii-art"><xsl:call-template name="ascii-art-hierarchy"
    /><xsl:text/> \___attribute '<xsl:value-of select="local-name()"/>'<xsl:text/><xsl:if
      test="namespace-uri()"> in ns '<xsl:value-of select="namespace-uri()"/>' ('<xsl:value-of
        select="name()"/>')</xsl:if><xsl:text/> = '<xsl:text/><xsl:call-template name="escape-ws"
        ><xsl:with-param name="text" select="."/></xsl:call-template><xsl:text/>'
    <xsl:text/></xsl:template>
  <xsl:template match="text()" mode="ascii-art">
    <xsl:call-template name="ascii-art-hierarchy"/>
    <xsl:text>___text '</xsl:text>
    <xsl:call-template name="escape-ws">
      <xsl:with-param name="text" select="."/>
    </xsl:call-template>
    <xsl:text>'
</xsl:text>
  </xsl:template>
  <xsl:template match="comment()" mode="ascii-art"><xsl:call-template name="ascii-art-hierarchy"
    /><xsl:text/>___comment '<xsl:value-of select="."/>' <xsl:text/></xsl:template>
  <xsl:template match="processing-instruction()" mode="ascii-art"><xsl:call-template
      name="ascii-art-hierarchy"/><xsl:text/>___processing instruction target='<xsl:value-of
      select="name()"/>' instruction='<xsl:value-of select="."/>' <xsl:text/></xsl:template>
  <xsl:template name="ascii-art-hierarchy">
    <xsl:for-each select="ancestor::*">
      <xsl:choose>
        <xsl:when test="local-name() != 'additionalMetadata'">
          <xsl:choose>
            <xsl:when test="following-sibling::node()"> | </xsl:when>
            <xsl:otherwise>
              <xsl:text/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="parent::node() and ../child::node()"> |</xsl:when>
      <xsl:otherwise>
        <xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="escape-ws">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text, '\')">
        <xsl:call-template name="escape-ws">
          <xsl:with-param name="text" select="substring-before($text, '\')"/>
        </xsl:call-template>
        <xsl:text>\\</xsl:text>
        <xsl:call-template name="escape-ws">
          <xsl:with-param name="text" select="substring-after($text, '\')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, $apos)">
        <xsl:call-template name="escape-ws">
          <xsl:with-param name="text" select="substring-before($text, $apos)"/>
        </xsl:call-template>
        <xsl:text>\'</xsl:text>
        <xsl:call-template name="escape-ws">
          <xsl:with-param name="text" select="substring-after($text, $apos)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, '&#10;')">
        <xsl:call-template name="escape-ws">
          <xsl:with-param name="text" select="substring-before($text, '&#10;')"/>
        </xsl:call-template>
        <xsl:text>\n</xsl:text>
        <xsl:call-template name="escape-ws">
          <xsl:with-param name="text" select="substring-after($text, '&#10;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, '&#9;')">
        <xsl:value-of select="substring-before($text, '&#9;')"/>
        <xsl:text>\t</xsl:text>
        <xsl:call-template name="escape-ws">
          <xsl:with-param name="text" select="substring-after($text, '&#9;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
       ********************************************************
             adding ATTRIBUTE templates 
       ********************************************************
         -->
  <xsl:template name="attributelist">
    <xsl:param name="docid"/>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="attributecommon">
              <xsl:with-param name="docid" select="$docid"/>
              <xsl:with-param name="entitytype" select="$entitytype"/>
              <xsl:with-param name="entityindex" select="$entityindex"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="attributecommon">
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="entitytype" select="$entitytype"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="attributecommon">
    <xsl:param name="docid"/>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <!-- First row for headers (attributeLabel) the pretty one. Element is optional,
   so could be empty. -->
    <!-- upper left cell has nbsp -->
    <tr>
      <th> </th>
      <xsl:for-each select="attribute">
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <th>
                <xsl:value-of select="attributeLabel"/>
              </th>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <th>
              <xsl:value-of select="attributeLabel"/>
            </th>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
    <!-- Second row for attribute label, the ugly one, element required -->
    <tr>
      <th class="rowodd">Column Name</th>
      <xsl:for-each select="attribute">
        <xsl:variable name="stripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$colevenStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$coloddStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <xsl:choose>
                <xsl:when test="attributeName != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="attributeName"><xsl:value-of select="."/>
                       <br/></xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">  <br/></td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="attributeName != ''">
                <td colspan="1" align="center" class="{$stripes}">
                  <xsl:for-each select="attributeName"><xsl:value-of select="."/>
                     <br/></xsl:for-each>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td colspan="1" align="center" class="{$stripes}">  <br/></td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
    <!-- Third row for attribute defination-->
    <tr>
      <th class="rowodd">Definition</th>
      <xsl:for-each select="attribute">
        <xsl:variable name="stripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$coloddStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$colevenStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <td colspan="1" align="center" class="{$stripes}">
                <xsl:value-of select="attributeDefinition"/>
              </td>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <td colspan="1" align="center" class="{$stripes}">
              <xsl:value-of select="attributeDefinition"/>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
    <!-- The fourth row for attribute storage type-->
    <tr>
      <th class="rowodd">Storage Type</th>
      <xsl:for-each select="attribute">
        <xsl:variable name="stripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$colevenStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$coloddStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <xsl:choose>
                <xsl:when test="storageType != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="storageType"><xsl:value-of select="."/>
                       <br/></xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="storageType != ''">
                <td colspan="1" align="center" class="{$stripes}">
                  <xsl:for-each select="storageType"><xsl:value-of select="."/>
                     <br/></xsl:for-each>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td colspan="1" align="center" class="{$stripes}">   </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
    <!-- The fifth row for meaturement type-->
    <tr>
      <th class="rowodd">Measurement Type</th>
      <xsl:for-each select="attribute">
        <xsl:variable name="stripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$coloddStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$colevenStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <td colspan="1" align="center" class="{$stripes}">
                <xsl:for-each select="measurementScale">
                  <xsl:value-of select="local-name(./*)"/>
                </xsl:for-each>
              </td>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <td colspan="1" align="center" class="{$stripes}">
              <xsl:for-each select="measurementScale">
                <xsl:value-of select="local-name(./*)"/>
              </xsl:for-each>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
    <!-- The sixth row for meaturement domain-->
    <tr>
      <!--    <th class="rowodd">Description of Allowed Values</th>-->
      <th class="rowodd">Measurement Values Domain</th>
      <xsl:for-each select="attribute">
        <!-- mob added, pass this index to measurementscale, not position. should move this earlier? -->
        <xsl:variable name="attributeindex" select="position()"/>
        <xsl:variable name="stripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$colevenStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$coloddStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="innerstripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$innercolevenStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$innercoloddStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <td colspan="1" align="center" class="{$stripes}">
                <xsl:for-each select="measurementScale">
                  <xsl:call-template name="measurementscale">
                    <xsl:with-param name="docid" select="$docid"/>
                    <xsl:with-param name="entitytype" select="$entitytype"/>
                    <xsl:with-param name="entityindex" select="$entityindex"/>
                    <xsl:with-param name="attributeindex" select="$attributeindex"/>
                    <xsl:with-param name="stripes" select="$innerstripes"/>
                  </xsl:call-template>
                </xsl:for-each>
              </td>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <td colspan="1" align="center" class="{$stripes}">
              <xsl:for-each select="measurementScale">
                <xsl:call-template name="measurementscale">
                  <xsl:with-param name="docid" select="$docid"/>
                  <xsl:with-param name="entitytype" select="$entitytype"/>
                  <xsl:with-param name="entityindex" select="$entityindex"/>
                  <xsl:with-param name="attributeindex" select="$attributeindex"/>
                  <xsl:with-param name="stripes" select="$innerstripes"/>
                </xsl:call-template>
              </xsl:for-each>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
    <!-- The seventh row for missing value code-->
    <tr>
      <th class="rowodd">Missing Value Code</th>
      <xsl:for-each select="attribute">
        <xsl:variable name="stripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$colevenStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$coloddStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="innerstripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$innercolevenStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$innercoloddStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <xsl:choose>
                <xsl:when test="missingValueCode != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <table>
                      <xsl:for-each select="missingValueCode">
                        <tr>
                          <td class="{$innerstripes}">
                            <b>Code</b>
                          </td>
                          <td class="{$innerstripes}">
                            <xsl:value-of select="code"/>
                          </td>
                        </tr>
                        <tr>
                          <td class="{$innerstripes}">
                            <b>Expl</b>
                          </td>
                          <td class="{$innerstripes}">
                            <xsl:value-of select="codeExplanation"/>
                          </td>
                        </tr>
                      </xsl:for-each>
                    </table>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="missingValueCode != ''">
                <td colspan="1" align="center" class="{$stripes}">
                  <table>
                    <xsl:for-each select="missingValueCode">
                      <tr>
                        <td class="{$innerstripes}">
                          <b>Code</b>
                        </td>
                        <td class="{$innerstripes}">
                          <xsl:value-of select="code"/>
                        </td>
                      </tr>
                      <tr>
                        <td class="{$innerstripes}">
                          <b>Expl</b>
                        </td>
                        <td class="{$innerstripes}">
                          <xsl:value-of select="codeExplanation"/>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </table>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td colspan="1" align="center" class="{$stripes}">   </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
    <!-- The eighth row for accuracy report-->
    <tr>
      <th class="rowodd">Accuracy Report</th>
      <xsl:for-each select="attribute">
        <xsl:variable name="stripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$coloddStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$colevenStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <xsl:choose>
                <xsl:when test="accuracy != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="accuracy">
                      <xsl:value-of select="attributeAccuracyReport"/>
                    </xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="accuracy != ''">
                <td colspan="1" align="center" class="{$stripes}">
                  <xsl:for-each select="accuracy">
                    <xsl:value-of select="attributeAccuracyReport"/>
                  </xsl:for-each>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td colspan="1" align="center" class="{$stripes}">   </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
    <!-- The nineth row for quality accuracy accessment -->
    <tr>
      <th class="rowodd">Accuracy Assessment</th>
      <xsl:for-each select="attribute">
        <xsl:variable name="stripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$coloddStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$colevenStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="innerstripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$innercolevenStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$innercoloddStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <xsl:choose>
                <xsl:when test="accuracy/quantitativeAttributeAccuracyAssessment != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="accuracy">
                      <table>
                        <xsl:for-each select="quantitativeAttributeAccuracyAssessment">
                          <tr>
                            <td class="{$innerstripes}">
                              <b>Value</b>
                            </td>
                            <td class="{$innerstripes}">
                              <xsl:value-of select="attributeAccuracyValue"/>
                            </td>
                          </tr>
                          <tr>
                            <td class="{$innerstripes}">
                              <b>Expl</b>
                            </td>
                            <td class="{$innerstripes}">
                              <xsl:value-of select="attributeAccuracyExplanation"/>
                            </td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="accuracy/quantitativeAttributeAccuracyAssessment != ''">
                <td colspan="1" align="center" class="{$stripes}">
                  <xsl:for-each select="accuracy">
                    <table>
                      <xsl:for-each select="quantitativeAttributeAccuracyAssessment">
                        <tr>
                          <td class="{$innerstripes}">
                            <b>Value</b>
                          </td>
                          <td class="{$innerstripes}">
                            <xsl:value-of select="attributeAccuracyValue"/>
                          </td>
                        </tr>
                        <tr>
                          <td class="{$innerstripes}">
                            <b>Expl</b>
                          </td>
                          <td class="{$innerstripes}">
                            <xsl:value-of select="attributeAccuracyExplanation"/>
                          </td>
                        </tr>
                      </xsl:for-each>
                    </table>
                  </xsl:for-each>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td colspan="1" align="center" class="{$stripes}">   </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
    <!-- The tenth row for coverage-->
    <tr>
      <th class="rowodd">Coverage</th>
      <xsl:for-each select="attribute">
        <xsl:variable name="index" select="position()"/>
        <xsl:variable name="stripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$colevenStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$coloddStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <xsl:choose>
                <xsl:when test="coverage != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="coverage">
                      <xsl:call-template name="attributecoverage">
                        <xsl:with-param name="docid" select="$docid"/>
                        <xsl:with-param name="entitytype" select="$entitytype"/>
                        <xsl:with-param name="entityindex" select="$entityindex"/>
                        <xsl:with-param name="attributeindex" select="$index"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="coverage != ''">
                <td colspan="1" align="center" class="{$stripes}">
                  <xsl:for-each select="coverage">
                    <xsl:call-template name="attributecoverage">
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="$entitytype"/>
                      <xsl:with-param name="entityindex" select="$entityindex"/>
                      <xsl:with-param name="attributeindex" select="$index"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td colspan="1" align="center" class="{$stripes}">   </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
    <!-- The eleventh row for method-->
    <tr>
      <th class="rowodd">Methods</th>
      <xsl:for-each select="attribute">
        <xsl:variable name="index" select="position()"/>
        <xsl:variable name="stripes">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">
              <xsl:value-of select="$colevenStyle"/>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:value-of select="$coloddStyle"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="references != ''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
            <xsl:for-each select="$references">
              <xsl:choose>
                <xsl:when test="method != '' or methods != ''">
                  <!-- another mob kludge for eml 2.1 -->
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="method | methods">
                      <xsl:call-template name="attributemethod">
                        <xsl:with-param name="docid" select="$docid"/>
                        <xsl:with-param name="entitytype" select="$entitytype"/>
                        <xsl:with-param name="entityindex" select="$entityindex"/>
                        <xsl:with-param name="attributeindex" select="$index"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <!-- Most SBC datasets end up here. No references, so test method!='' -->
            <!-- gotch! in a test, using pipe '|' for 'or'  does not work for testing for content. but
             ONLY the '|' works in a select! ! ouch! 
             Also works: when test="method | methods", but used test-for-content for consistency.
            -->
            <xsl:choose>
              <xsl:when test="method != '' or methods != ''">
                <!-- another mob kludge for eml 2.1 -->
                <td colspan="1" align="center" class="{$stripes}">
                  <xsl:for-each select="method | methods">
                    <xsl:call-template name="attributemethod">
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="$entitytype"/>
                      <xsl:with-param name="entityindex" select="$entityindex"/>
                      <xsl:with-param name="attributeindex" select="$index"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td colspan="1" align="center" class="{$stripes}">   </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </tr>
  </xsl:template>
  <xsl:template name="singleattribute">
    <xsl:param name="docid"/>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="attributeindex"/>
    <table class="{$tableattributeStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="singleattributecommon">
              <xsl:with-param name="docid" select="$docid"/>
              <xsl:with-param name="entitytype" select="$entitytype"/>
              <xsl:with-param name="entityindex" select="$entityindex"/>
              <xsl:with-param name="attributeindex" select="$attributeindex"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="singleattributecommon">
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="entitytype" select="$entitytype"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
            <xsl:with-param name="attributeindex" select="$attributeindex"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="singleattributecommon">
    <xsl:param name="docid"/>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="attributeindex"/>
    <!-- First row for attribute name-->
    <tr>
      <th class="rowodd">Column Name</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <th>
                  <xsl:value-of select="attributeName"/>
                </th>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <th>
                <xsl:value-of select="attributeName"/>
              </th>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
    <!-- Second row for attribute label-->
    <tr>
      <th class="rowodd">Column Label</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:variable name="stripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$colevenStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$coloddStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="attributeLabel != ''">
                    <td colspan="1" align="center" class="{$stripes}">
                      <xsl:for-each select="attributeLabel"><xsl:value-of select="."/>
                         <br/></xsl:for-each>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td colspan="1" align="center" class="{$stripes}">  <br/></td>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="attributeLabel != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="attributeLabel"><xsl:value-of select="."/>
                       <br/></xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">  <br/></td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
    <!-- Third row for attribute defination-->
    <tr>
      <th class="rowodd">Definition</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:variable name="stripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$coloddStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$colevenStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <td colspan="1" align="center" class="{$stripes}">
                  <xsl:value-of select="attributeDefinition"/>
                </td>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <td colspan="1" align="center" class="{$stripes}">
                <xsl:value-of select="attributeDefinition"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
    <!-- The fourth row for attribute storage type-->
    <tr>
      <th class="rowodd">Type of Value</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:variable name="stripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$colevenStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$coloddStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="storageType != ''">
                    <td colspan="1" align="center" class="{$stripes}">
                      <xsl:for-each select="storageType"><xsl:value-of select="."/>
                         <br/></xsl:for-each>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td colspan="1" align="center" class="{$stripes}">   </td>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="storageType != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="storageType"><xsl:value-of select="."/>
                       <br/></xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
    <!-- The fifth row for meaturement type-->
    <tr>
      <th class="rowodd">Measurement Type</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:variable name="stripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$coloddStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$colevenStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <td colspan="1" align="center" class="{$stripes}">
                  <xsl:for-each select="measurementScale">
                    <xsl:value-of select="local-name(./*)"/>
                  </xsl:for-each>
                </td>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <td colspan="1" align="center" class="{$stripes}">
                <xsl:for-each select="measurementScale">
                  <xsl:value-of select="local-name(./*)"/>
                </xsl:for-each>
              </td>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
    <!-- The sixth row for meaturement domain-->
    <tr>
      <th class="rowodd">Measurement Domain</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:variable name="stripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$colevenStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$coloddStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="innerstripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$innercolevenStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$innercoloddStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <td colspan="1" align="center" class="{$stripes}">
                  <xsl:for-each select="measurementScale">
                    <xsl:call-template name="measurementscale">
                      <xsl:with-param name="docid" select="$docid"/>
                      <xsl:with-param name="entitytype" select="$entitytype"/>
                      <xsl:with-param name="entityindex" select="$entityindex"/>
                      <xsl:with-param name="attributeindex" select="position()"/>
                      <xsl:with-param name="stripes" select="$innerstripes"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </td>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <td colspan="1" align="center" class="{$stripes}">
                <xsl:for-each select="measurementScale">
                  <xsl:call-template name="measurementscale">
                    <xsl:with-param name="docid" select="$docid"/>
                    <xsl:with-param name="entitytype" select="$entitytype"/>
                    <xsl:with-param name="entityindex" select="$entityindex"/>
                    <xsl:with-param name="attributeindex" select="position()"/>
                    <xsl:with-param name="stripes" select="$innerstripes"/>
                  </xsl:call-template>
                </xsl:for-each>
              </td>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
    <!-- The seventh row for missing value code-->
    <tr>
      <th class="rowodd">Missing Value Code</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:variable name="stripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$colevenStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$coloddStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="innerstripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$innercolevenStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$innercoloddStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="missingValueCode != ''">
                    <td colspan="1" align="center" class="{$stripes}">
                      <table>
                        <xsl:for-each select="missingValueCode">
                          <tr>
                            <td class="{$innerstripes}">
                              <b>Code</b>
                            </td>
                            <td class="{$innerstripes}">
                              <xsl:value-of select="code"/>
                            </td>
                          </tr>
                          <tr>
                            <td class="{$innerstripes}">
                              <b>Expl</b>
                            </td>
                            <td class="{$innerstripes}">
                              <xsl:value-of select="codeExplanation"/>
                            </td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td colspan="1" class="{$stripes}">   </td>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="missingValueCode != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <table>
                      <xsl:for-each select="missingValueCode">
                        <tr>
                          <td class="{$innerstripes}">
                            <b>Code</b>
                          </td>
                          <td class="{$innerstripes}">
                            <xsl:value-of select="code"/>
                          </td>
                        </tr>
                        <tr>
                          <td class="{$innerstripes}">
                            <b>Expl</b>
                          </td>
                          <td class="{$innerstripes}">
                            <xsl:value-of select="codeExplanation"/>
                          </td>
                        </tr>
                      </xsl:for-each>
                    </table>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
    <!-- The eighth row for accuracy report-->
    <tr>
      <th class="rowodd">Accuracy Report</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:variable name="stripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$coloddStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$colevenStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="accuracy != ''">
                    <td colspan="1" align="center" class="{$stripes}">
                      <xsl:for-each select="accuracy">
                        <xsl:value-of select="attributeAccuracyReport"/>
                      </xsl:for-each>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td colspan="1" align="center" class="{$stripes}">   </td>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="accuracy != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="accuracy">
                      <xsl:value-of select="attributeAccuracyReport"/>
                    </xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
    <!-- The nineth row for quality accuracy accessment -->
    <tr>
      <th class="rowodd">Accuracy Assessment</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:variable name="stripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$coloddStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$colevenStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="innerstripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$innercolevenStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$innercoloddStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="accuracy/quantitativeAttributeAccuracyAssessment != ''">
                    <td colspan="1" align="center" class="{$stripes}">
                      <xsl:for-each select="accuracy">
                        <table>
                          <xsl:for-each select="quantitativeAttributeAccuracyAssessment">
                            <tr>
                              <td class="{$innerstripes}">
                                <b>Value</b>
                              </td>
                              <td class="{$innerstripes}">
                                <xsl:value-of select="attributeAccuracyValue"/>
                              </td>
                            </tr>
                            <tr>
                              <td class="{$innerstripes}">
                                <b>Expl</b>
                              </td>
                              <td class="{$innerstripes}">
                                <xsl:value-of select="attributeAccuracyExplanation"/>
                              </td>
                            </tr>
                          </xsl:for-each>
                        </table>
                      </xsl:for-each>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td colspan="1" align="center" class="{$stripes}">   </td>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="accuracy/quantitativeAttributeAccuracyAssessment != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="accuracy">
                      <table>
                        <xsl:for-each select="quantitativeAttributeAccuracyAssessment">
                          <tr>
                            <td class="{$innerstripes}">
                              <b>Value</b>
                            </td>
                            <td class="{$innerstripes}">
                              <xsl:value-of select="attributeAccuracyValue"/>
                            </td>
                          </tr>
                          <tr>
                            <td class="{$innerstripes}">
                              <b>Expl</b>
                            </td>
                            <td class="{$innerstripes}">
                              <xsl:value-of select="attributeAccuracyExplanation"/>
                            </td>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
    <!-- The tenth row for coverage-->
    <tr>
      <th class="rowodd">Coverage</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:variable name="index" select="position()"/>
          <xsl:variable name="stripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$colevenStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$coloddStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="coverage != ''">
                    <td colspan="1" align="center" class="{$stripes}">
                      <xsl:for-each select="coverage">
                        <xsl:call-template name="attributecoverage">
                          <xsl:with-param name="docid" select="$docid"/>
                          <xsl:with-param name="entitytype" select="$entitytype"/>
                          <xsl:with-param name="entityindex" select="$entityindex"/>
                          <xsl:with-param name="attributeindex" select="$index"/>
                        </xsl:call-template>
                      </xsl:for-each>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td colspan="1" align="center" class="{$stripes}">   </td>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="coverage != ''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="coverage">
                      <xsl:call-template name="attributecoverage">
                        <xsl:with-param name="docid" select="$docid"/>
                        <xsl:with-param name="entitytype" select="$entitytype"/>
                        <xsl:with-param name="entityindex" select="$entityindex"/>
                        <xsl:with-param name="attributeindex" select="$index"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
    <!-- The eleventh row for method-->
    <tr>
      <th class="rowodd">Methods</th>
      <xsl:for-each select="attribute">
        <xsl:if test="position() = $attributeindex">
          <xsl:variable name="index" select="position()"/>
          <xsl:variable name="stripes">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:value-of select="$colevenStyle"/>
              </xsl:when>
              <xsl:when test="position() mod 2 = 1">
                <xsl:value-of select="$coloddStyle"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="references != ''">
              <xsl:variable name="ref_id" select="references"/>
              <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
              <xsl:for-each select="$references">
                <xsl:choose>
                  <xsl:when test="method!='' | methods!='' ">
                    <!-- another mob kludge for eml2.1 -->
                    <td colspan="1" align="center" class="{$stripes}">
                      <xsl:for-each select="method | methods">
                        <xsl:call-template name="attributemethod">
                          <xsl:with-param name="docid" select="$docid"/>
                          <xsl:with-param name="entitytype" select="$entitytype"/>
                          <xsl:with-param name="entityindex" select="$entityindex"/>
                          <xsl:with-param name="attributeindex" select="$index"/>
                        </xsl:call-template>
                      </xsl:for-each>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td colspan="1" align="center" class="{$stripes}">   </td>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="method!=''  | methods!=''">
                  <td colspan="1" align="center" class="{$stripes}">
                    <xsl:for-each select="method | methods">
                      <xsl:call-template name="attributemethod">
                        <xsl:with-param name="docid" select="$docid"/>
                        <xsl:with-param name="entitytype" select="$entitytype"/>
                        <xsl:with-param name="entityindex" select="$entityindex"/>
                        <xsl:with-param name="attributeindex" select="$index"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td colspan="1" align="center" class="{$stripes}">   </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </tr>
  </xsl:template>
  <xsl:template name="measurementscale">
    <xsl:param name="stripes"/>
    <xsl:param name="docid"/>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="attributeindex"/>
    <table>
      <xsl:for-each select="nominal">
        <xsl:call-template name="attributenonnumericdomain">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entitytype" select="$entitytype"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
          <xsl:with-param name="attributeindex" select="$attributeindex"/>
          <xsl:with-param name="stripes" select="$stripes"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="ordinal">
        <xsl:call-template name="attributenonnumericdomain">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entitytype" select="$entitytype"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
          <xsl:with-param name="attributeindex" select="$attributeindex"/>
          <xsl:with-param name="stripes" select="$stripes"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="interval">
        <xsl:call-template name="intervalratio">
          <xsl:with-param name="stripes" select="$stripes"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="ratio">
        <xsl:call-template name="intervalratio">
          <xsl:with-param name="stripes" select="$stripes"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="datetime | dateTime">
        <xsl:call-template name="datetime">
          <xsl:with-param name="stripes" select="$stripes"/>
        </xsl:call-template>
      </xsl:for-each>
    </table>
  </xsl:template>
  <xsl:template name="attributenonnumericdomain">
    <xsl:param name="stripes"/>
    <xsl:param name="docid"/>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="attributeindex"/>
    <xsl:for-each select="nonNumericDomain">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="attributenonnumericdomaincommon">
              <xsl:with-param name="docid" select="$docid"/>
              <xsl:with-param name="entitytype" select="$entitytype"/>
              <xsl:with-param name="entityindex" select="$entityindex"/>
              <xsl:with-param name="attributeindex" select="$attributeindex"/>
              <xsl:with-param name="stripes" select="$stripes"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="attributenonnumericdomaincommon">
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="entitytype" select="$entitytype"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
            <xsl:with-param name="attributeindex" select="$attributeindex"/>
            <xsl:with-param name="stripes" select="$stripes"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="attributenonnumericdomaincommon">
    <xsl:param name="stripes"/>
    <xsl:param name="docid"/>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="attributeindex"/>
    <!-- if numericdomain only has one test domain,
        it will be displayed inline otherwith will be show a link-->
    <xsl:choose>
      <xsl:when test="count(textDomain) = 1 and not(enumeratedDomain)">
        <tr>
          <td class="{$stripes}">
            <b>Definition</b>
          </td>
          <td class="{$stripes}">
            <xsl:value-of select="textDomain/definition"/>
          </td>
        </tr>
        <xsl:if test="textDomain/pattern">
          <!-- if added by mob. -->
          <xsl:for-each select="textDomain/pattern">
            <tr>
              <td class="{$stripes}">
                <b>Pattern</b>
              </td>
              <td class="{$stripes}">
                <xsl:value-of select="."/>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="textDomain/source">
          <!-- if added by mob. -->
          <xsl:for-each select=".">
            <tr>
              <td class="{$stripes}">
                <b>Source</b>
              </td>
              <td class="{$stripes}">
                <xsl:value-of select="textDomain/source"/>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:if>
        <!-- -->
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td colspan="2" align="center" class="{$stripes}">
            <a>
              <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                  select="$docid"/>&amp;displaymodule=attributedomain&amp;entitytype=<xsl:value-of
                  select="$entitytype"/>&amp;entityindex=<xsl:value-of select="$entityindex"
                  />&amp;attributeindex=<xsl:value-of select="$attributeindex"/></xsl:attribute>
              <b>Allowed values and definitions</b>
            </a>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="intervalratio">
    <xsl:param name="stripes"/>
    <xsl:if test="unit/standardUnit">
      <tr>
        <td class="{$stripes}">
          <b>Unit</b>
        </td>
        <td class="{$stripes}">
          <xsl:value-of select="unit/standardUnit"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="unit/customUnit">
      <tr>
        <td class="{$stripes}">
          <b>Unit</b>
        </td>
        <td class="{$stripes}">
          <xsl:value-of select="unit/customUnit"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="precision">
      <tr>
        <td class="{$stripes}">
          <b>Precision</b>
        </td>
        <td class="{$stripes}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="numericDomain">
      <xsl:call-template name="numericDomain">
        <xsl:with-param name="stripes" select="$stripes"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="numericDomain">
    <xsl:param name="stripes"/>
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <tr>
            <td class="{$stripes}">
              <b>Type</b>
            </td>
            <td class="{$stripes}">
              <xsl:value-of select="numberType"/>
            </td>
          </tr>
          <xsl:for-each select="bounds">
            <tr>
              <td class="{$stripes}">
                <b>Min</b>
              </td>
              <td class="{$stripes}">
                <xsl:for-each select="minimum"><xsl:value-of select="."/>  </xsl:for-each>
              </td>
            </tr>
            <tr>
              <td class="{$stripes}">
                <b>Max</b>
              </td>
              <td class="{$stripes}">
                <xsl:for-each select="maximum"><xsl:value-of select="."/>  </xsl:for-each>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td class="{$stripes}">
            <b>Type</b>
          </td>
          <td class="{$stripes}">
            <xsl:value-of select="numberType"/>
          </td>
        </tr>
        <xsl:for-each select="bounds">
          <tr>
            <td class="{$stripes}">
              <b>Min</b>
            </td>
            <td class="{$stripes}">
              <xsl:for-each select="minimum"><xsl:value-of select="."/>  </xsl:for-each>
            </td>
          </tr>
          <tr>
            <td class="{$stripes}">
              <b>Max</b>
            </td>
            <td class="{$stripes}">
              <xsl:for-each select="maximum"><xsl:value-of select="."/>  </xsl:for-each>
            </td>
          </tr>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="datetime">
    <xsl:param name="stripes"/>
    <tr>
      <td class="{$stripes}">
        <b>Format</b>
      </td>
      <td class="{$stripes}">
        <xsl:value-of select="formatString"/>
      </td>
    </tr>
    <tr>
      <td class="{$stripes}">
        <b>Precision</b>
      </td>
      <td class="{$stripes}">
        <xsl:value-of select="dateTimePrecision"/>
      </td>
    </tr>
    <xsl:call-template name="timedomain"/>
  </xsl:template>
  <xsl:template name="timedomain">
    <xsl:param name="stripes"/>
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <xsl:for-each select="bounds">
            <tr>
              <td class="{$stripes}">
                <b>Min</b>
              </td>
              <td class="{$stripes}">
                <xsl:for-each select="minimum"><xsl:value-of select="."/>  </xsl:for-each>
              </td>
            </tr>
            <tr>
              <td class="{$stripes}">
                <b>Max</b>
              </td>
              <td class="{$stripes}">
                <xsl:for-each select="maximum"><xsl:value-of select="."/>  </xsl:for-each>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="bounds">
          <tr>
            <td class="{$stripes}">
              <b>Min</b>
            </td>
            <td class="{$stripes}">
              <xsl:for-each select="minimum"><xsl:value-of select="."/>  </xsl:for-each>
            </td>
          </tr>
          <tr>
            <td class="{$stripes}">
              <b>Max</b>
            </td>
            <td class="{$stripes}">
              <xsl:for-each select="maximum"><xsl:value-of select="."/>  </xsl:for-each>
            </td>
          </tr>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="attributecoverage">
    <xsl:param name="docid"/>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="attributeindex"/>
    <a>
      <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"
          />&amp;displaymodule=attributecoverage&amp;entitytype=<xsl:value-of select="$entitytype"
          />&amp;entityindex=<xsl:value-of select="$entityindex"/>&amp;attributeindex=<xsl:value-of
          select="$attributeindex"/></xsl:attribute>
      <b>Coverage Info</b>
    </a>
  </xsl:template>
  <xsl:template name="attributemethod">
    <xsl:param name="docid"/>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="attributeindex"/>
    <a>
      <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"
          />&amp;displaymodule=attributemethod&amp;entitytype=<xsl:value-of select="$entitytype"
          />&amp;entityindex=<xsl:value-of select="$entityindex"/>&amp;attributeindex=<xsl:value-of
          select="$attributeindex"/></xsl:attribute>
      <b>Method Info</b>
    </a>
  </xsl:template>
  <!--
       ********************************************************
             adding ATTRIBUTE ENUM DOMAIN templates 
       ********************************************************
         -->
  <xsl:template name="nonNumericDomain">
    <xsl:param name="nondomainfirstColStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="nonNumericDomainCommon">
              <xsl:with-param name="nondomainfirstColStyle" select="$nondomainfirstColStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="nonNumericDomainCommon">
            <xsl:with-param name="nondomainfirstColStyle" select="$nondomainfirstColStyle"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="nonNumericDomainCommon">
    <xsl:param name="nondomainfirstColStyle"/>
    <xsl:for-each select="enumeratedDomain">
      <xsl:call-template name="enumeratedDomain">
        <xsl:with-param name="nondomainfirstColStyle" select="$nondomainfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="textDomain">
      <xsl:call-template name="enumeratedDomain">
        <xsl:with-param name="nondomainfirstColStyle" select="$nondomainfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="textDomain">
    <xsl:param name="nondomainfirstColStyle"/>
    <tr>
      <td class="{$nondomainfirstColStyle}">
        <b>Text Domain</b>
      </td>
      <td class="{$secondColStyle}">  </td>
    </tr>
    <tr>
      <td class="{$nondomainfirstColStyle}">Definition</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="definition"/>
      </td>
    </tr>
    <xsl:for-each select="parttern">
      <tr>
        <td class="{$nondomainfirstColStyle}">Pattern</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="source">
      <tr>
        <td class="{$nondomainfirstColStyle}">Source</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="source"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="enumeratedDomain">
    <xsl:param name="nondomainfirstColStyle"/>
    <xsl:if test="codeDefinition">
      <tr>
        <td class="{$nondomainfirstColStyle}">
          <b>Enumerated Domain</b>
        </td>
        <td class="{$secondColStyle}">  </td>
      </tr>
      <xsl:for-each select="codeDefinition">
        <tr>
          <td class="{$nondomainfirstColStyle}">Code Definition</td>
          <td>
            <table class="{$tabledefaultStyle}">
              <tr>
                <td class="{$nondomainfirstColStyle}"> Code </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="code"/>
                </td>
              </tr>
              <tr>
                <td class="{$nondomainfirstColStyle}"> Definition </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="definition"/>
                </td>
              </tr>
              <tr>
                <td class="{$nondomainfirstColStyle}"> Source </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="source"/>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="externalCodeSet">
      <tr>
        <td class="{$nondomainfirstColStyle}">
          <b>Enumerated Domain(External Set)</b>
        </td>
        <td>  </td>
      </tr>
      <tr>
        <td class="{$nondomainfirstColStyle}">Set Name:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="externalCodeSet/codesetName"/>
        </td>
      </tr>
      <xsl:for-each select="externalCodeSet/citation">
        <tr>
          <td class="{$nondomainfirstColStyle}">Citation:</td>
          <td>
            <xsl:call-template name="citation">
              <xsl:with-param name="citationfirstColStyle" select="$nondomainfirstColStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="externalCodeSet/codesetURL">
        <tr>
          <td class="{$nondomainfirstColStyle}">URL</td>
          <td class="{$secondColStyle}">
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="."/>
              </xsl:attribute>
              <xsl:value-of select="."/>
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
    <!-- 
     <xsl:if test="entityCodeList">
        <tr><td class="{$nondomainfirstColStyle}"><b>Enumerated Domain (Entity)</b></td>
            <td class="{$secondColStyle}">&#160;
            </td>
       </tr>
        <tr><td class="{$nondomainfirstColStyle}">Entity Reference</td>
            <td class="{$secondColStyle}"><xsl:value-of select="entityCodeList/entityReference"/>
            </td>
       </tr>
       <tr><td class="{$nondomainfirstColStyle}">Attribute Value Reference</td>
            <td class="{$secondColStyle}"><xsl:value-of select="entityCodeList/valueAttributeReference"/>
            </td>
       </tr>
       <tr><td class="{$nondomainfirstColStyle}">Attribute Definition Reference</td>
            <td class="{$secondColStyle}"><xsl:value-of select="entityCodeList/definitionAttributeReference"/>
            </td>
       </tr>
     </xsl:if>
-->
    <!-- mob, 2012-06-04 -->
    <xsl:if test="entityCodeList">
      <tr>
        <td class="{$nondomainfirstColStyle}" colspan="2">
          <b>The allowed values and their definitions can be found in another data entity in this
            package. Please follow link to description, then download:</b>
        </td>
        <!--   <td class="{$secondColStyle}">&#160;
        </td> -->
      </tr>
      <tr>
        <td class="{$nondomainfirstColStyle}">Data link:</td>
        <td>
          <table class="subGroup onehundred_percent {$tabledefaultStyle}">
            <!-- when you call the entityurl template, include a param to label the type of entity  -->
            <!-- also, need 
          http://stackoverflow.com/questions/4449810/using-position-function-in-xslt
          http://www.w3schools.com/xsl/el_number.asp
          remember: The <xsl:number> element is used to determine the integer position 
          of the current node in the source. It is also used to format a number.
          -->
            <!-- one more note: tested with dataTable only
          -->
            <xsl:variable name="entity_ref" select="entityCodeList/entityReference"/>
            <xsl:for-each select="//dataTable[@id = $entity_ref]">
              <xsl:variable name="entity_position">
                <xsl:number/>
              </xsl:variable>
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">dataTable</xsl:with-param>
                <xsl:with-param name="showtype">Data Table</xsl:with-param>
                <xsl:with-param name="index" select="$entity_position"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="//spatialRaster[@id = $entity_ref]">
              <xsl:variable name="entity_position">
                <xsl:number/>
              </xsl:variable>
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">spatialRaster</xsl:with-param>
                <xsl:with-param name="showtype">Spatial Raster</xsl:with-param>
                <xsl:with-param name="index" select="$entity_position"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="//spatialVector[@id = $entity_ref]">
              <xsl:variable name="entity_position">
                <xsl:number/>
              </xsl:variable>
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">spatialVector</xsl:with-param>
                <xsl:with-param name="showtype">Spatial Vector</xsl:with-param>
                <xsl:with-param name="index" select="$entity_position"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="//storedProcedure[@id = $entity_ref]">
              <xsl:variable name="entity_position">
                <xsl:number/>
              </xsl:variable>
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">storedProcedure</xsl:with-param>
                <xsl:with-param name="showtype">Stored Procedure</xsl:with-param>
                <xsl:with-param name="index" select="$entity_position"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="//view[@id = $entity_ref]">
              <xsl:variable name="entity_position">
                <xsl:number/>
              </xsl:variable>
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">view</xsl:with-param>
                <xsl:with-param name="showtype">View</xsl:with-param>
                <xsl:with-param name="index" select="$entity_position"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="//otherEntity[@id = $entity_ref]">
              <xsl:variable name="entity_position">
                <xsl:number/>
              </xsl:variable>
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">otherEntity</xsl:with-param>
                <xsl:with-param name="showtype">Other</xsl:with-param>
                <xsl:with-param name="index" select="$entity_position"/>
              </xsl:call-template>
            </xsl:for-each>
          </table>
        </td>
      </tr>
      <tr>
        <td class="{$nondomainfirstColStyle}">Code value can be found in:</td>
        <td class="{$secondColStyle}">
          <xsl:variable name="attribute_val_ref" select="entityCodeList/valueAttributeReference"/>
          <xsl:choose>
            <xsl:when test="//*/attributeLabel[../@id = $attribute_val_ref]">
              <xsl:value-of select="//*/attributeLabel[../@id = $attribute_val_ref]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//*/attributeName[../@id = $attribute_val_ref]"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="{$nondomainfirstColStyle}">Code definition can be found in</td>
        <td class="{$secondColStyle}">
          <xsl:variable name="attribute_def_ref"
            select="entityCodeList/definitionAttributeReference"/>
          <xsl:choose>
            <xsl:when test="//*/attributeLabel[../@id = $attribute_def_ref]">
              <xsl:value-of select="//*/attributeLabel[../@id = $attribute_def_ref]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//*/attributeName[../@id = $attribute_def_ref]"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <!--
       ********************************************************
             adding CONSTRAINT templates 
       ********************************************************
         -->
  <xsl:template name="constraint">
    <xsl:param name="constraintfirstColStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="constraintCommon">
              <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="constraintCommon">
            <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="constraintCommon">
    <xsl:param name="constraintfirstColStyle"/>
    <xsl:for-each select="primaryKey">
      <xsl:call-template name="primaryKey">
        <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="uniqueKey">
      <xsl:call-template name="uniqueKey">
        <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="checkConstraint">
      <xsl:call-template name="checkConstraint">
        <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="foreignKey">
      <xsl:call-template name="foreignKey">
        <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="joinCondition">
      <xsl:call-template name="joinCondition">
        <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="notNullConstraint">
      <xsl:call-template name="notNullConstraint">
        <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="primaryKey">
    <xsl:param name="constraintfirstColStyle"/>
    <tr>
      <td class="{$constraintfirstColStyle}"> Primary Key:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:call-template name="constraintBaseGroup">
            <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
          </xsl:call-template>
          <xsl:for-each select="key/attributeReference">
            <tr>
              <td class="{$constraintfirstColStyle}">
                <xsl:text>Key:</xsl:text>
              </td>
              <td class="{$secondColStyle}">
                <xsl:value-of select="."/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="uniqueKey">
    <xsl:param name="constraintfirstColStyle"/>
    <tr>
      <td class="{$constraintfirstColStyle}"> Unique Key:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:call-template name="constraintBaseGroup">
            <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
          </xsl:call-template>
          <xsl:for-each select="key/attributeReference">
            <tr>
              <td class="{$constraintfirstColStyle}">
                <xsl:text>Key:</xsl:text>
              </td>
              <td class="{$secondColStyle}">
                <xsl:value-of select="."/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="checkConstraint">
    <xsl:param name="constraintfirstColStyle"/>
    <tr>
      <td class="{$constraintfirstColStyle}"> Checking Constraint: </td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:call-template name="constraintBaseGroup">
            <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
          </xsl:call-template>
          <xsl:for-each select="checkCondition">
            <tr>
              <td class="{$constraintfirstColStyle}">
                <xsl:text>Check Condition:</xsl:text>
              </td>
              <td class="{$secondColStyle}">
                <xsl:value-of select="."/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="foreignKey">
    <xsl:param name="constraintfirstColStyle"/>
    <tr>
      <td class="{$constraintfirstColStyle}"> Foreign Key:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:call-template name="constraintBaseGroup">
            <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
          </xsl:call-template>
          <xsl:for-each select="key/attributeReference">
            <tr>
              <td class="{$constraintfirstColStyle}">
                <xsl:text>Key:</xsl:text>
              </td>
              <td class="{$secondColStyle}">
                <xsl:value-of select="."/>
              </td>
            </tr>
          </xsl:for-each>
          <tr>
            <td class="{$constraintfirstColStyle}">
              <xsl:text>Entity Reference:</xsl:text>
            </td>
            <td class="{$secondColStyle}">
              <xsl:value-of select="entityReference"/>
            </td>
          </tr>
          <xsl:if test="relationshipType and normalize-space(relationshipType) != ''">
            <tr>
              <td class="{$constraintfirstColStyle}">
                <xsl:text>Relationship:</xsl:text>
              </td>
              <td class="{$secondColStyle}">
                <xsl:value-of select="relationshipType"/>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="cardinality and normalize-space(cardinality) != ''">
            <tr>
              <td class="{$constraintfirstColStyle}">
                <xsl:text>Cardinality:</xsl:text>
              </td>
              <td>
                <table class="{$tabledefaultStyle}">
                  <tr>
                    <td class="{$constraintfirstColStyle}">
                      <xsl:text>Parent:</xsl:text>
                    </td>
                    <td class="{$secondColStyle}">
                      <xsl:value-of select="cardinality/parentOccurences"/>
                    </td>
                  </tr>
                  <tr>
                    <td class="{$constraintfirstColStyle}">
                      <xsl:text>Children</xsl:text>
                    </td>
                    <td class="{$secondColStyle}">
                      <xsl:value-of select="cardinality/childOccurences"/>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </xsl:if>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="joinCondition">
    <xsl:param name="constraintfirstColStyle"/>
    <tr>
      <td class="{$constraintfirstColStyle}"> Join Condition:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:call-template name="foreignKey">
            <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
          </xsl:call-template>
          <xsl:for-each select="referencedKey/attributeReference">
            <tr>
              <td class="{$constraintfirstColStyle}">
                <xsl:text>Referenced Key:</xsl:text>
              </td>
              <td class="{$secondColStyle}">
                <xsl:value-of select="."/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="notNullConstraint">
    <xsl:param name="constraintfirstColStyle"/>
    <tr>
      <td class="{$constraintfirstColStyle}"> Not Null Constraint:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:call-template name="constraintBaseGroup">
            <xsl:with-param name="constraintfirstColStyle" select="$constraintfirstColStyle"/>
          </xsl:call-template>
          <xsl:for-each select="key/attributeReference">
            <tr>
              <td class="{$constraintfirstColStyle}">
                <xsl:text>Key:</xsl:text>
              </td>
              <td class="{$secondColStyle}">
                <xsl:value-of select="."/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="constraintBaseGroup">
    <xsl:param name="constraintfirstColStyle"/>
    <tr>
      <td class="{$constraintfirstColStyle}">
        <xsl:text>Name:</xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="constraintName"/>
      </td>
    </tr>
    <xsl:if test="constraintDescription and normalize-space(constraintDescription) != ''">
      <tr>
        <td class="{$constraintfirstColStyle}">
          <xsl:text>Description:</xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="constraintDescription"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <!--
       ********************************************************
             adding COVERAGE templates 
       ********************************************************
         -->
  <xsl:template name="coverage">
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <!--	  <table class="{$tabledefaultStyle}">  -->
          <xsl:for-each select="geographicCoverage">
            <xsl:call-template name="geographicCoverage"/>
          </xsl:for-each>
          <!--  </table>  -->
          <!--  <table class="{$tabledefaultStyle}">  -->
          <xsl:for-each select="temporalCoverage">
            <xsl:call-template name="temporalCoverage"/>
          </xsl:for-each>
          <!-- </table>  -->
          <!-- <table class="{$tabledefaultStyle}">  -->
          <xsl:for-each select="taxonomicCoverage">
            <xsl:call-template name="taxonomicCoverage"/>
          </xsl:for-each>
          <!--  </table>  -->
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!--   <table class="{$tabledefaultStyle}">  -->
        <xsl:for-each select="geographicCoverage">
          <xsl:call-template name="geographicCoverage"/>
        </xsl:for-each>
        <!--  </table>  -->
        <!--   <table class="{$tabledefaultStyle}"> -->
        <xsl:for-each select="temporalCoverage">
          <xsl:call-template name="temporalCoverage"/>
        </xsl:for-each>
        <!-- </table> -->
        <!--  <table class="{$tabledefaultStyle}"> -->
        <xsl:for-each select="taxonomicCoverage">
          <xsl:call-template name="taxonomicCoverage"/>
        </xsl:for-each>
        <!--  </table>  -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="geographicCoverage">
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <!-- <xsl:for-each select="geographicCoverage"> -->
          <!-- letting the foreach select the current node instead of geographicCoverage lets this work for
          either dataset/coverage or attribute/coverage, but I do not know why (oh no!).  -->
          <xsl:for-each select=".">
            <table class="{$tabledefaultStyle}">
              <xsl:call-template name="geographicCovCommon"/>
            </table>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <table class="{$tabledefaultStyle}">
          <xsl:call-template name="geographicCovCommon"/>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="geographicCovCommon">
    <!-- use the bounding coordinates to determine if  lats and longs are alike. 
    set a boolean  that can be used to choose labels -->
    <xsl:variable name="west" select="./boundingCoordinates/westBoundingCoordinate"/>
    <xsl:variable name="east" select="./boundingCoordinates/eastBoundingCoordinate"/>
    <xsl:variable name="north" select="./boundingCoordinates/northBoundingCoordinate"/>
    <xsl:variable name="south" select="./boundingCoordinates/southBoundingCoordinate"/>
    <xsl:variable name="lat-lon-identical">
      <xsl:choose>
        <xsl:when test="($west = $east) and ($north = $south)">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <th colspan="2">
        <!-- label for geoCov group chosen based on lat-lon boolean -->
        <xsl:choose>
          <xsl:when test="$lat-lon-identical = 'true'">
            <xsl:text>Sampling Site: </xsl:text>
            <xsl:if test="(contains(@system, 'sbclter')) and (not(contains(@id, 'boilerplate')))">
              <xsl:value-of select="@id"/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Geographic Region:</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </th>
    </tr>
    <tr>
      <td class="fortyfive_percent">
        <xsl:apply-templates select="geographicDescription"/>
      </td>
      <td class="fortyfive_percent">
        <!-- <xsl:apply-templates select="geographicDescription"/> -->
        <xsl:apply-templates select="boundingCoordinates">
          <xsl:with-param name="lat-lon-identical" select="$lat-lon-identical"/>
        </xsl:apply-templates>
      </td>
    </tr>
    <xsl:for-each select="datasetGPolygon">
      <xsl:if test="datasetGPolygonOuterGRing">
        <xsl:apply-templates select="datasetGPolygonOuterGRing"/>
      </xsl:if>
      <xsl:if test="datasetGPolygonExclusionGRing">
        <xsl:apply-templates select="datasetGPolygonExclusionGRing"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="geographicDescription">
    <table>
      <tr>
        <td class="{$firstColStyle}">Description:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template match="boundingCoordinates">
    <xsl:param name="lat-lon-identical"/>
    <table>
      <tr>
        <td class="{$firstColStyle}">
          <xsl:choose>
            <xsl:when test="$lat-lon-identical = 'true'">Site Coordinates:</xsl:when>
            <xsl:otherwise>Bounding Coordinates:</xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="$lat-lon-identical = 'true'">
              <xsl:call-template name="boundingCoordinatesSingleLatLon"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="boundingCoordinatesBox"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template name="boundingCoordinatesSingleLatLon">
    <table>
      <tr>
        <td class="{$firstColStyle}">
          <xsl:text>Longitude (degree): </xsl:text>
        </td>
        <td>
          <xsl:value-of select="westBoundingCoordinate"/>
        </td>
        <td class="{$firstColStyle}">
          <xsl:text>Latitude (degree): </xsl:text>
        </td>
        <td>
          <xsl:value-of select="northBoundingCoordinate"/>
        </td>
      </tr>
      <xsl:apply-templates select="boundingAltitudes"/>
    </table>
  </xsl:template>
  <xsl:template name="boundingCoordinatesBox">
    <table>
      <tr>
        <td class="{$firstColStyle}">
          <xsl:text>Northern:  </xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="northBoundingCoordinate"/>
        </td>
        <td class="{$firstColStyle}">
          <xsl:text>Southern:  </xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="southBoundingCoordinate"/>
        </td>
      </tr>
      <tr>
        <td class="{$firstColStyle}">
          <xsl:text>Western:  </xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="westBoundingCoordinate"/>
        </td>
        <td class="{$firstColStyle}">
          <xsl:text>Eastern:  </xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="eastBoundingCoordinate"/>
        </td>
      </tr>
      <xsl:apply-templates select="boundingAltitudes"/>
    </table>
  </xsl:template>
  <xsl:template match="boundingAltitudes">
    <xsl:variable name="altitude-minimum" select="./altitudeMinimum"/>
    <xsl:variable name="altitude-maximum" select="./altitudeMaximum"/>
    <xsl:variable name="min-max-identical">
      <xsl:choose>
        <xsl:when test="$altitude-minimum = $altitude-maximum">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$min-max-identical = 'true'">
        <td class="{$firstColStyle}">Altitude (<xsl:value-of select="altitudeUnits"/>):</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="altitudeMinimum"/>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td class="{$firstColStyle}">Altitude Minimum:</td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="altitudeMinimum"/>
          </td>
          <!--   </tr>
           <tr>  -->
          <td class="{$firstColStyle}">Altitude Maximum:</td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="altitudeMaximum"/>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="datasetGPolygonOuterGRing">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>G-Ploygon(Outer Ring): </xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:apply-templates select="gRingPoint"/>
        <xsl:apply-templates select="gRing"/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="datasetGPolygonExclusionGRing">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>G-Ploygon(Exclusion Ring): </xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:apply-templates select="gRingPoint"/>
        <xsl:apply-templates select="gRing"/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="gRing"
      ><xsl:text>(GRing)  </xsl:text><xsl:text>Latitude: </xsl:text><xsl:value-of
      select="gRingLatitude"/>, <xsl:text>Longitude: </xsl:text><xsl:value-of
      select="gRingLongitude"/><br/></xsl:template>
  <xsl:template match="gRingPoint"><xsl:text>Latitude: </xsl:text><xsl:value-of
      select="gRingLatitude"/>, <xsl:text>Longitude: </xsl:text><xsl:value-of
      select="gRingLongitude"/><br/></xsl:template>
  <xsl:template name="temporalCoverage">
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <table class="{$tabledefaultStyle}">
            <xsl:call-template name="temporalCovCommon"/>
          </table>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <table class="{$tabledefaultStyle}">
          <xsl:call-template name="temporalCovCommon"/>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="temporalCovCommon">
    <tr>
      <th colspan="2">
        <xsl:text>Time Period:</xsl:text>
      </th>
    </tr>
    <xsl:apply-templates select="singleDateTime"/>
    <xsl:apply-templates select="rangeOfDates"/>
  </xsl:template>
  <xsl:template match="singleDateTime">
    <tr>
      <td class="{$firstColStyle}"> Date: </td>
      <td>
        <xsl:call-template name="singleDateType"/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="rangeOfDates">
    <tr>
      <td class="{$firstColStyle}"> Begin: </td>
      <td>
        <xsl:apply-templates select="beginDate"/>
      </td>
    </tr>
    <tr>
      <td class="{$firstColStyle}"> End: </td>
      <td>
        <xsl:apply-templates select="endDate"/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="beginDate">
    <xsl:call-template name="singleDateType"/>
  </xsl:template>
  <xsl:template match="endDate">
    <xsl:call-template name="singleDateType"/>
  </xsl:template>
  <xsl:template name="singleDateType">
    <table>
      <xsl:if test="calendarDate">
        <tr>
          <td colspan="2" class="{$secondColStyle}">
            <xsl:value-of select="calendarDate"/>
            <xsl:if test="./time and normalize-space(./time) != ''">
              <xsl:text>  at  </xsl:text>
              <xsl:apply-templates select="time"/>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="alternativeTimeScale">
        <xsl:apply-templates select="alternativeTimeScale"/>
      </xsl:if>
    </table>
  </xsl:template>
  <xsl:template match="alternativeTimeScale">
    <tr>
      <td class="{$firstColStyle}"> Timescale:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="timeScaleName"/>
      </td>
    </tr>
    <tr>
      <td class="{$firstColStyle}"> Time estimate:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="timeScaleAgeEstimate"/>
      </td>
    </tr>
    <xsl:if test="timeScaleAgeUncertainty and normalize-space(timeScaleAgeUncertainty) != ''">
      <tr>
        <td class="{$firstColStyle}"> Time uncertainty:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="timeScaleAgeUncertainty"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="timeScaleAgeExplanation and normalize-space(timeScaleAgeExplanation) != ''">
      <tr>
        <td class="{$firstColStyle}"> Time explanation:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="timeScaleAgeExplanation"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="timeScaleCitation and normalize-space(timeScaleCitation) != ''">
      <tr>
        <td class="{$firstColStyle}"> Citation:</td>
        <td class="{$secondColStyle}">
          <xsl:apply-templates select="timeScaleCitation"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="timeScaleCitation">
    <!-- Using citation module here -->
    <xsl:call-template name="citation"/>
  </xsl:template>
  <xsl:template name="taxonomicCoverage">
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <table class="{$tabledefaultStyle}">
            <xsl:call-template name="taxonomicCovCommon"/>
          </table>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <table class="{$tabledefaultStyle}">
          <xsl:call-template name="taxonomicCovCommon"/>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="taxonomicCovCommon">
    <tr>
      <th colspan="2">
        <xsl:text>Taxonomic Range:</xsl:text>
      </th>
    </tr>
    <xsl:apply-templates select="taxonomicSystem"/>
    <xsl:apply-templates select="generalTaxonomicCoverage"/>
    <xsl:for-each select="taxonomicClassification">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="taxonomicSystem">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>Taxonomic System:</xsl:text>
      </td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:apply-templates select="./*"/>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="classificationSystem">
    <xsl:for-each select="classificationSystemCitation">
      <tr>
        <td class="{$firstColStyle}">Classification Citation:</td>
        <td>
          <xsl:call-template name="citation">
            <xsl:with-param name="citationfirstColStyle" select="$firstColStyle"/>
            <xsl:with-param name="citationsubHeaderStyle" select="$subHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if
      test="classificationSystemModifications and normalize-space(classificationSystemModifications) != ''">
      <tr>
        <td class="{$firstColStyle}">Modification:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="classificationSystemModifications"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="identificationReference">
    <tr>
      <td class="{$firstColStyle}">ID Reference:</td>
      <td>
        <xsl:call-template name="citation">
          <xsl:with-param name="citationfirstColStyle" select="$firstColStyle"/>
          <xsl:with-param name="citationsubHeaderStyle" select="$subHeaderStyle"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="identifierName">
    <tr>
      <td class="{$firstColStyle}">ID Name:</td>
      <td>
        <xsl:call-template name="party">
          <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="taxonomicProcedures">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>Procedures:</xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="taxonomicCompleteness">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>Completeness:</xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="vouchers">
    <tr>
      <td class="{$firstColStyle}">Vouchers:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:apply-templates select="specimen"/>
          <xsl:apply-templates select="repository"/>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="specimen">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>Specimen:</xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="repository">
    <tr>
      <td class="{$firstColStyle}">Repository:</td>
      <td>
        <xsl:for-each select="originator">
          <xsl:call-template name="party">
            <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
          </xsl:call-template>
        </xsl:for-each>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="generalTaxonomicCoverage">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>General Coverage:</xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="taxonomicClassification">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>Classification:</xsl:text>
      </td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:apply-templates select="./*" mode="nest"/>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="taxonRankName" mode="nest">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>Rank Name:</xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="taxonRankValue" mode="nest">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>Rank Value:</xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="commonName" mode="nest">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>Common Name:</xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="taxonomicClassification" mode="nest">
    <tr>
      <td class="{$firstColStyle}">
        <xsl:text>Classification:</xsl:text>
      </td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:apply-templates select="./*" mode="nest"/>
        </table>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding DATASET templates 
       ********************************************************
         -->
  <xsl:template match="dataset" mode="dataset">
    <xsl:param name="packageID"/>
    <div itemscope="" itemtype="http://schema.org/Dataset">
      <!--  debug:  <xsl:value-of select="$packageID"/> line 43 dataset.xsl -->
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="datasetheader"/>
            <xsl:call-template name="datasetmixed"/>
            <!--
             <xsl:call-template name="datasetresource"/>
             <xsl:call-template name="datasetaccess"/>
             <xsl:call-template name="datasetpurpose"/>
             <xsl:call-template name="datasetmaintenance"/>
             <xsl:call-template name="datasetcontact"/>
             <xsl:call-template name="datasetpublisher"/>
             <xsl:call-template name="datasetpubplace"/>
             <xsl:call-template name="datasetmethod"/>
             <xsl:call-template name="datasetproject"/>
             <xsl:if test="$withEntityLinks='1'">
               <xsl:call-template name="datasetentity"/>
             </xsl:if>
             -->
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="datasettitle">
            <xsl:with-param name="packageID" select="$packageID"/>
          </xsl:call-template>
          <table>
            <tr>
              <td>
                <xsl:call-template name="datasetmenu">
                  <xsl:with-param name="currentmodule">datasetmixed</xsl:with-param>
                  <xsl:with-param name="packageID" select="$packageID"/>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td>
                <xsl:call-template name="datasetmixed">
                  <xsl:with-param name="packageID" select="$packageID"/>
                </xsl:call-template>
              </td>
            </tr>
          </table>
          <!--
             <xsl:call-template name="datasetresource"/>
             <xsl:call-template name="datasetaccess"/>
             <xsl:call-template name="datasetpurpose"/>
             <xsl:call-template name="datasetmaintenance"/>
             <xsl:call-template name="datasetcontact"/>
             <xsl:call-template name="datasetpublisher"/>
             <xsl:call-template name="datasetpubplace"/>
             <xsl:call-template name="datasetmethod"/>
             <xsl:call-template name="datasetproject"/>
             <xsl:if test="$withEntityLinks='1'">
               <xsl:call-template name="datasetentity"/>
             </xsl:if>
             -->
        </xsl:otherwise>
      </xsl:choose>
    </div>
    <!-- closes schema.org micromarkup itemscope, itemtype -->
  </xsl:template>
  <xsl:template name="datasettitle">
    <xsl:param name="packageID"/>
    <h4 class="EML-dataset-supratitle">Data Set (<xsl:value-of select="$packageID"/>)</h4>
    <h3 class="EML-datasettitle">
      <xsl:for-each select="./title">
        <xsl:value-of select="."/>
      </xsl:for-each>
    </h3>
  </xsl:template>
  <xsl:template name="datasetmenu">
    <xsl:param name="currentmodule"/>
    <table class="emltopmenu onehundred_percent ">
      <tr>
        <td width="1%" class="empty"> </td>
        <td width="20%" class="datasetmixed">
          <xsl:choose>
            <xsl:when test="$currentmodule = 'datasetmixed'"><xsl:attribute name="class"
                >highlight</xsl:attribute> Summary and Data Links </xsl:when>
            <xsl:otherwise>
              <a class="datasetmenu"><xsl:attribute name="href"><xsl:value-of select="$tripleURI"
                    /><xsl:value-of select="$docid"/></xsl:attribute>Summary and Data Links </a>
            </xsl:otherwise>
          </xsl:choose>
          <!--  
          <xsl:if test="$currentmodule='datasetmixed' ">
            <xsl:attribute name="class">highlight</xsl:attribute>
          </xsl:if>
          <a class="datasetmenu">
            <xsl:attribute name="href">
              <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/>
            </xsl:attribute>Summary and Data Links
        </a>  -->
        </td>
        <td width="20%" class="responsibleparties">
          <xsl:choose>
            <xsl:when test="$currentmodule = 'responsibleparties'"><xsl:attribute name="class"
                >highlight</xsl:attribute> People and Organizations </xsl:when>
            <xsl:otherwise>
              <a class="datasetmenu"><xsl:attribute name="href"><xsl:value-of select="$tripleURI"
                    /><xsl:value-of select="$docid"
                  /><xsl:text>&amp;displaymodule=responsibleparties</xsl:text></xsl:attribute>People
                and Organizations </a>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td width="38%" class="coverageall">
          <xsl:choose>
            <xsl:when test="$currentmodule = 'coverageall'"><xsl:attribute name="class"
                >highlight</xsl:attribute> Temporal, Geographic and Taxonomic Coverage </xsl:when>
            <xsl:otherwise>
              <a class="datasetmenu"><xsl:attribute name="href"><xsl:value-of select="$tripleURI"
                    /><xsl:value-of select="$docid"
                  /><xsl:text>&amp;displaymodule=coverageall</xsl:text></xsl:attribute>Temporal,
                Geographic and Taxonomic Coverage </a>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td width="20%" class="methodsall">
          <xsl:choose>
            <xsl:when test="$currentmodule = 'methodsall'"><xsl:attribute name="class"
                >highlight</xsl:attribute> Methods and Protocols </xsl:when>
            <xsl:otherwise>
              <a class="datasetmenu"><xsl:attribute name="href"><xsl:value-of select="$tripleURI"
                    /><xsl:value-of select="$docid"
                  /><xsl:text>&amp;displaymodule=methodsall</xsl:text></xsl:attribute>Methods and
                Protocols </a>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td width="1%" class="empty"> </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template name="datasetmixed">
    <table class="subGroup onehundred_percent">
      <tr>
        <td class="fortyfive_percent">
          <!-- style the identifying information into a small table -->
          <table class="{$tabledefaultStyle}">
            <tr>
              <th colspan="2">Data Set General Information:</th>
            </tr>
            <!-- put in the title -->
            <!--        <xsl:if test="./title">
               <xsl:for-each select="./title">
                 <xsl:call-template name="resourcetitle">
                   <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                   <xsl:with-param name="ressecondColStyle" select="$secondColStyle"/>
                 </xsl:call-template>
               </xsl:for-each>
             </xsl:if> -->
            <!-- put in the identifier and system that the ID belongs to -->
            <xsl:if test="../@packageId">
              <xsl:for-each select="../@packageId">
                <xsl:call-template name="identifier">
                  <xsl:with-param name="packageID" select="../@packageId"/>
                  <xsl:with-param name="system" select="../@system"/>
                  <xsl:with-param name="IDfirstColStyle" select="$firstColStyle"/>
                  <xsl:with-param name="IDsecondColStyle" select="$secondColStyle"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:if>
            <!-- put in the alternate identifiers -->
            <xsl:if test="alternateIdentifier">
              <xsl:for-each select="alternateIdentifier">
                <xsl:call-template name="resourcealternateIdentifier">
                  <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                  <xsl:with-param name="ressecondColStyle" select="$secondColStyle"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:if>
            <!-- put in the text of the abstract-->
            <xsl:if test="./abstract">
              <xsl:for-each select="./abstract">
                <xsl:call-template name="resourceabstract">
                  <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                  <xsl:with-param name="ressecondColStyle" select="$secondColStyle"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:if>
            <!-- put in the purpose of the dataset-->
            <xsl:if test="./purpose">
              <xsl:for-each select="./purpose">
                <xsl:call-template name="datasetpurpose">
                  <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                  <xsl:with-param name="ressecondColStyle" select="$secondColStyle"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:if>
            <!-- put in the short name -->
            <xsl:if test="shortName">
              <xsl:for-each select="./shortName">
                <xsl:call-template name="resourceshortName">
                  <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                  <xsl:with-param name="ressecondColStyle" select="$secondColStyle"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:if>
            <!-- put in the keyword sets -->
            <!-- 
             <xsl:if test="keywordSet">
               <tr>
                 <td class="{$firstColStyle}">
                   <xsl:text>Keywords:</xsl:text>
                 </td>
                 <td class="{$secondColStyle}">
                 <xsl:for-each select="keywordSet">
                   <xsl:call-template name="resourcekeywordSet" >
                     <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                     <xsl:with-param name="ressecondColStyle" select="$secondColStyle"/>
                   </xsl:call-template>
                 </xsl:for-each>
                 </td>
               </tr>
             </xsl:if>
-->
            <!-- put in the publication date -->
            <xsl:if test="./pubDate">
              <xsl:for-each select="pubDate">
                <xsl:call-template name="resourcepubDate">
                  <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:if>
            <!-- put in the language -->
            <xsl:if test="./language">
              <xsl:for-each select="language">
                <xsl:call-template name="resourcelanguage">
                  <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:if>
            <!-- put in the series -->
            <xsl:if test="./series">
              <xsl:for-each select="series">
                <xsl:call-template name="resourceseries">
                  <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:if>
            <!-- the dataset-level distribution tag. for ours,
               it is function=information. the link to the data entity itself will be in the
               entity's tree.  -->
            <xsl:if test="distribution/@id">
              <tr>
                <td colspan="2">
                  <table class="subGroup onehundred_percent">
                    <tr>
                      <td>
                        <table class="{$tabledefaultStyle}">
                          <th colspan="2">For more information:</th>
                          <xsl:for-each select="distribution">
                            <tr>
                              <td class="{$firstColStyle}">
                                <!-- <xsl:value-of select="@id"/> -->
                                <xsl:text>Visit: </xsl:text>
                              </td>
                              <td class="{$secondColStyle}">
                                <a>
                                  <xsl:attribute name="href">
                                    <xsl:value-of select="online/url"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="online/url"/>
                                </a>
                              </td>
                            </tr>
                          </xsl:for-each>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </xsl:if>
          </table>
          <!-- add in the temporal coverage info  
           temporal coverage template includes a table, so it needs to be inside the left td -->
          <xsl:if test="./coverage/temporalCoverage">
            <xsl:for-each select="./coverage/temporalCoverage">
              <xsl:call-template name="temporalCoverage">
                <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:if>
        </td>
        <!-- 



begin the right column of the top section for the data table's descriptions  -->
        <td class="fortyfive_percent">
          <!-- create a second easy access table listing the data entities -->
          <!-- the second part of this td is a short list of people. so include the creator node in the test
          so people can show even if there is no entity yet (probably only in a draft) -->
          <xsl:if
            test="dataTable | spatialRaster | spatialVector | storedProcedure | view | otherEntity or creator">
            <!-- mob added, March 2014, count up the entities so you can vary how you display them 
             usual ordering is data-links first, then people
             -->
            <!-- TO DO: CUSTOMIZE THESE LIMITS (set limits high to not use) -->
            <!-- limit #1 -->
            <xsl:variable name="max_entities_limit1">100</xsl:variable>
            <!-- limit #2 -->
            <xsl:variable name="max_entities_limit2">6</xsl:variable>
            <!-- 
              variable to hold number of entities the dataset has, of any type -->
            <xsl:variable name="entity_count"
              select="count(dataTable | spatialRaster | spatialVector | storedProcedure | view | otherEntity)"/>
            <!-- 
              set some booleans using these values  -->
            <xsl:variable name="show_entity_description">
              <xsl:choose>
                <xsl:when test="$entity_count &gt; $max_entities_limit1">false</xsl:when>
                <xsl:otherwise>true</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="add_entity_scrollbar">
              <xsl:choose>
                <xsl:when test="$entity_count &gt; $max_entities_limit2">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!--   TEST: show_entity_description = <xsl:value-of select="$show_entity_description"/> -->
            <xsl:if
              test="dataTable | spatialRaster | spatialVector | storedProcedure | view | otherEntity">
              <table class="{$tabledefaultStyle}">
                <xsl:call-template name="datasetentity">
                  <xsl:with-param name="show_entity_description" select="$show_entity_description"/>
                  <xsl:with-param name="add_entity_scrollbar" select="$add_entity_scrollbar"/>
                </xsl:call-template>
              </table>
            </xsl:if>
            <!-- the if statement above altered so that a dataset with no entity still shows its creators (usually a draft) -->
            <xsl:if test="creator">
              <table class="{$tabledefaultStyle}">
                <xsl:call-template name="datasetpeople_summary"/>
              </table>
            </xsl:if>
          </xsl:if>
          <!-- closes if dataTable, etc -->
          <br/>
          <!--  find the table class with correct spacing! -->
        </td>
      </tr>
    </table>
    <!-- 
  
  END OF FIRST SECTION
  -->
    <!-- 
      
      
      
      
      dataset citation  -->
    <h3>Data Set Citation</h3>
    <xsl:if test="$displaymodule = 'dataset'">
      <xsl:call-template name="howtoCite">
        <xsl:with-param name="citetabledefaultStyle" select="$tabledefaultStyle"/>
        <xsl:with-param name="citefirstColStyle" select="$firstColStyle"/>
        <xsl:with-param name="citesecondColStyle" select="$secondColStyle"/>
        <xsl:with-param name="contextURL" select="$contextURL"/>
      </xsl:call-template>
    </xsl:if>
    <!--
      
      
      
      the keywords table. -->
    <h3>Key Words and Terms</h3>
    <xsl:if test="keywordSet">
      <table class="{$tabledefaultStyle}">
        <tr>
          <th colspan="2">By Thesaurus:</th>
        </tr>
        <tr>
          <td>
            <xsl:for-each select="keywordSet">
              <table class="{$tabledefaultStyle}">
                <tr>
                  <td class="{$firstColStyle}">
                    <xsl:choose>
                      <xsl:when test="keywordThesaurus">
                        <xsl:value-of select="keywordThesaurus"/>
                      </xsl:when>
                      <xsl:otherwise/>
                    </xsl:choose>
                  </td>
                  <td class="{$secondColStyle}">
                    <xsl:call-template name="resourcekeywordsAsPara">
                      <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                      <xsl:with-param name="ressecondColStyle" select="$secondColStyle"/>
                    </xsl:call-template>
                  </td>
                </tr>
              </table>
            </xsl:for-each>
          </td>
        </tr>
      </table>
    </xsl:if>
    <!-- add in the method info
     <h3>Sampling, Processing and Quality Control Methods</h3>
     <table class="subGroup onehundred_percent">  
       <tr>
         <td colspan="2" class="onehundred_percent">
           <xsl:if test="./methods">
             <xsl:for-each select="./methods">
               <xsl:call-template name="datasetmethod">
                 <xsl:with-param name="methodfirstColStyle" select="$firstColStyle"/>
                 <xsl:with-param name="methodsecondColStyle" select="$secondColStyle"/>
               </xsl:call-template>
             </xsl:for-each>
           </xsl:if>
         </td>
       </tr>
     </table> 
     -->
    <h3>Data Set Usage Rights</h3>
    <!-- add in the intellectiual rights info -->
    <table class="subGroup onehundred_percent">
      <tr>
        <td>
          <xsl:if test="intellectualRights">
            <xsl:for-each select="intellectualRights">
              <xsl:call-template name="resourceintellectualRights">
                <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
                <xsl:with-param name="ressecondColStyle" select="$secondColStyle"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:if>
        </td>
      </tr>
    </table>
    <!-- add in the access control info -->
    <table class="subGroup onehundred_percent">
      <tr>
        <td>
          <xsl:if test="access">
            <xsl:for-each select="access">
              <xsl:call-template name="access">
                <xsl:with-param name="accessfirstColStyle" select="$firstColStyle"/>
                <xsl:with-param name="accesssecondColStyle" select="$secondColStyle"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:if>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template name="datasetpeople_summary">
    <!-- left the table element behind, to be a little more consistent with other templates which are mainly rows. -->
    <tr>
      <th colspan="2">People and Organizations:</th>
    </tr>
    <tr>
      <td colspan="2">
        <a><xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
              select="$docid"
            /><xsl:text>&amp;displaymodule=responsibleparties</xsl:text></xsl:attribute>View
          complete information for all parties </a>
      </td>
    </tr>
    <!-- 
                   
                   Put the contact first -->
    <xsl:for-each select="contact">
      <tr>
        <td class="{$firstColStyle}">Contact:</td>
        <td class="{$secondColStyle}">
          <xsl:choose>
            <xsl:when test="individualName">
              <!--  if creator has an individual, so it and make creator's  with other labels subordinate  -->
              <xsl:for-each select="individualName">
                <xsl:value-of select="surName"/>
                <xsl:if test="givenName">
                  <xsl:text>, </xsl:text>
                  <xsl:for-each select="givenName">
                    <xsl:value-of select="."/>
                    <xsl:text> </xsl:text>
                  </xsl:for-each>
                </xsl:if>
                <xsl:if test="../organizationName or ../positionName">
                  <xsl:text>(</xsl:text>
                  <xsl:choose>
                    <xsl:when test="../organizationName and ../positionName">
                      <xsl:value-of select="../organizationName"/>
                      <xsl:text>, </xsl:text>
                      <xsl:value-of select="../positionName"/>
                    </xsl:when>
                    <xsl:when test="../organizationName and not(../positionName)">
                      <xsl:value-of select="../organizationName"/>
                    </xsl:when>
                    <xsl:when test="not(../organizationName) and ../positionName">
                      <xsl:value-of select="../positionName"/>
                    </xsl:when>
                  </xsl:choose>
                  <xsl:text>)</xsl:text>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <!--  the contact has no individual.   -->
              <xsl:choose>
                <xsl:when test="positionName">
                  <!-- next most important is a position, with org subordinate -->
                  <xsl:value-of select="positionName"/>
                  <xsl:if test="organizationName">
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="organizationName"/>
                    <xsl:text>)</xsl:text>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="organizationName and not(positionName)">
                    <!-- Organization appears alone if alone  -->
                    <xsl:value-of select="organizationName"/>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text> </xsl:text>
          <xsl:if test="electronicMailAddress">[  <a><xsl:attribute name="href"
                  ><xsl:text>mailto:</xsl:text><xsl:value-of select="electronicMailAddress"
                /></xsl:attribute>email</a> ] </xsl:if>
        </td>
      </tr>
    </xsl:for-each>
    <!--  
                  
                  second is creators, in document order. -->
    <xsl:for-each select="creator">
      <tr>
        <xsl:choose>
          <xsl:when test="individualName">
            <!--  if creator has an individual, so it and make creator's  with other labels subordinate  -->
            <td class="{$firstColStyle}">Owner:</td>
            <td class="{$secondColStyle}">
              <xsl:for-each select="individualName">
                <xsl:value-of select="surName"/>
                <xsl:if test="givenName">
                  <xsl:text>, </xsl:text>
                  <xsl:for-each select="givenName">
                    <xsl:value-of select="."/>
                    <xsl:text> </xsl:text>
                  </xsl:for-each>
                </xsl:if>
                <xsl:if test="../organizationName or ../positionName">
                  <xsl:text>(</xsl:text>
                  <xsl:choose>
                    <xsl:when test="../organizationName and ../positionName">
                      <xsl:value-of select="../organizationName"/>
                      <xsl:text>, </xsl:text>
                      <xsl:value-of select="../positionName"/>
                    </xsl:when>
                    <xsl:when test="../organizationName and not(../positionName)">
                      <xsl:value-of select="../organizationName"/>
                    </xsl:when>
                    <xsl:when test="not(../organizationName) and ../positionName">
                      <xsl:value-of select="../positionName"/>
                    </xsl:when>
                  </xsl:choose>
                  <xsl:text>)</xsl:text>
                </xsl:if>
              </xsl:for-each>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <!--  the creator has no individual.   -->
            <xsl:if test="positionName">
              <!-- next most important is a position, with org subordinate -->
              <td class="{$firstColStyle}">Position:</td>
              <td class="{$secondColStyle}">
                <xsl:value-of select="positionName"/>
                <xsl:if test="../organizationName">
                  <xsl:text>(</xsl:text>
                  <xsl:value-of select="../organizationName"/>
                  <xsl:text>)</xsl:text>
                </xsl:if>
              </td>
            </xsl:if>
            <xsl:if test="organizationName">
              <!-- Organization appears alone if alone under creator -->
              <td class="{$firstColStyle}">Organization</td>
              <td class="{$secondColStyle}">
                <xsl:value-of select="organizationName"/>
              </td>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
    </xsl:for-each>
    <!-- close creator-rows  -->
    <xsl:if test="associatedParty">
      <!-- 
                     
                     then everyone else -->
      <xsl:for-each select="associatedParty">
        <tr>
          <xsl:choose>
            <xsl:when test="individualName">
              <!--  associatedParty has an individual, so  other labels are subordinate  -->
              <td class="{$firstColStyle}">Associate:</td>
              <td class="{$secondColStyle}">
                <xsl:for-each select="individualName">
                  <xsl:value-of select="surName"/>
                  <xsl:if test="givenName">
                    <xsl:text>, </xsl:text>
                    <xsl:for-each select="givenName">
                      <xsl:value-of select="."/>
                      <xsl:text> </xsl:text>
                    </xsl:for-each>
                  </xsl:if>
                  <xsl:if test="../organizationName or ../positionName">
                    <xsl:text>(</xsl:text>
                    <xsl:choose>
                      <xsl:when test="../organizationName and ../positionName">
                        <xsl:value-of select="../organizationName"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="../positionName"/>
                      </xsl:when>
                      <xsl:when test="../organizationName and not(../positionName)">
                        <xsl:value-of select="../organizationName"/>
                      </xsl:when>
                      <xsl:when test="not(../organizationName) and ../positionName">
                        <xsl:value-of select="../positionName"/>
                      </xsl:when>
                    </xsl:choose>
                    <xsl:text>)</xsl:text>
                  </xsl:if>
                </xsl:for-each>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <!--  the party has no individual.   -->
              <xsl:if test="positionName">
                <!-- next most important is a position, with org subordinate -->
                <td>position</td>
                <td>
                  <xsl:value-of select="positionName"/>
                  <xsl:if test="../organizationName">
                    <xsl:text>(</xsl:text>
                    <xsl:value-of select="../organizationName"/>
                    <xsl:text>)</xsl:text>
                  </xsl:if>
                </td>
              </xsl:if>
              <xsl:if test="organizationName">
                <!-- Organization appears alone if alone under party -->
                <td>Organization</td>
                <td>
                  <xsl:value-of select="organizationName"/>
                </td>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </tr>
      </xsl:for-each>
      <!-- close associatedParty-rows  -->
    </xsl:if>
  </xsl:template>
  <xsl:template name="datasetresource">
    <tr>
      <td colspan="2">
        <xsl:call-template name="resource">
          <xsl:with-param name="resfirstColStyle" select="$firstColStyle"/>
          <xsl:with-param name="ressubHeaderStyle" select="$subHeaderStyle"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="datasetpurpose">
    <xsl:for-each select="purpose">
      <tr>
        <td colspan="2">
          <xsl:text>Purpose:</xsl:text>
        </td>
      </tr>
      <tr>
        <td class="{$firstColStyle}">   </td>
        <td>
          <xsl:call-template name="text">
            <xsl:with-param name="textfirstColStyle" select="$firstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="datasetmaintenance">
    <xsl:for-each select="maintenance">
      <tr>
        <td colspan="2">
          <xsl:text>Maintenance:</xsl:text>
        </td>
      </tr>
      <xsl:call-template name="mantenancedescription"/>
      <tr>
        <td class="{$firstColStyle}"> Frequency: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="maintenanceUpdateFrequency"/>
        </td>
      </tr>
      <xsl:call-template name="datasetchangehistory"/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="mantenancedescription">
    <xsl:for-each select="description">
      <tr>
        <td class="{$firstColStyle}"> Description: </td>
        <td>
          <xsl:call-template name="text">
            <xsl:with-param name="textfirstColStyle" select="$firstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="datasetchangehistory">
    <xsl:if test="changeHistory">
      <tr>
        <td class="{$firstColStyle}"> History: </td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:for-each select="changeHistory">
              <xsl:call-template name="historydetails"/>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="historydetails">
    <tr>
      <td class="{$firstColStyle}"> scope:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="changeScope"/>
      </td>
    </tr>
    <tr>
      <td class="{$firstColStyle}"> old value:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="oldValue"/>
      </td>
    </tr>
    <tr>
      <td class="{$firstColStyle}"> change date:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="changeDate"/>
      </td>
    </tr>
    <xsl:if test="comment and normalize-space(comment) != ''">
      <tr>
        <td class="{$firstColStyle}"> comment:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="comment"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="datasetcontact">
    <tr>
      <td colspan="2">
        <xsl:text>Contact:</xsl:text>
      </td>
    </tr>
    <xsl:for-each select="contact">
      <tr>
        <td colspan="2">
          <xsl:call-template name="party">
            <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="datasetpublisher">
    <xsl:for-each select="publisher">
      <tr>
        <td colspan="2">
          <xsl:text>Publisher:</xsl:text>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <xsl:call-template name="party">
            <xsl:with-param name="partyfirstColStyle" select="$firstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="datasetpubplace">
    <xsl:for-each select="pubPlace">
      <tr>
        <td class="{$firstColStyle}"> Publish Place:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="datasetmethod">
    <xsl:for-each select=".">
      <xsl:call-template name="method">
        <xsl:with-param name="methodfirstColStyle" select="$firstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="datasetproject">
    <xsl:for-each select="project">
      <tr>
        <td colspan="2">
          <h3>
            <xsl:text>Parent Project Information:</xsl:text>
          </h3>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <xsl:call-template name="project">
            <xsl:with-param name="projectfirstColStyle" select="$firstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="datasetaccess">
    <xsl:for-each select="access">
      <tr>
        <td colspan="2">
          <xsl:call-template name="access">
            <xsl:with-param name="accessfirstColStyle" select="$firstColStyle"/>
            <xsl:with-param name="accesssubHeaderStyle" select="$subHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="datasetentity">
    <xsl:param name="show_entity_description"/>
    <xsl:param name="add_entity_scrollbar"/>
    <!-- a header for all entities. -->
    <tr>
      <th colspan="2">
        <xsl:text>Detailed Data Description and Download:</xsl:text>
      </th>
    </tr>
    <tr>
      <td>
        <xsl:element name="div">
          <xsl:if test="$add_entity_scrollbar = 'true'">
            <xsl:attribute name="class">scroll-if-too-long</xsl:attribute>
          </xsl:if>
          <table>
            <!-- you can't factor out the type. indexes have to be within type. order within dataset is preserved elsewhere. -->
            <xsl:for-each select="dataTable">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">dataTable</xsl:with-param>
                <xsl:with-param name="typelabel">Data Table</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"/>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="spatialRaster">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">spatialRaster</xsl:with-param>
                <xsl:with-param name="typelabel">Spatial Raster</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"/>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="spatialVector">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">spatialVector</xsl:with-param>
                <xsl:with-param name="typelabel">Spatial Vector</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"/>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="storedProcedure">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">storedProcedure</xsl:with-param>
                <xsl:with-param name="typelabel">Stored Procedure</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"/>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="view">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">view</xsl:with-param>
                <xsl:with-param name="typelabel">View</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"/>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="otherEntity">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">otherEntity</xsl:with-param>
                <xsl:with-param name="typelabel">Other</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"/>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <!-- the below code preserves the document order of the entites. but it needs to pass the within-type order on.
          I'm not sure where the dependency on within-type order is though! I think it's because the entity files are per-type,
          and the url param type passed by the cgi sets up that nodeset.
          -->
            <!-- 
          <xsl:for-each select="dataTable | spatialRaster | spatialVector | storedProcedure | view | otherEntity">
            <xsl:variable name="type" select="name()"/>
            <xsl:variable name="typelabel">
              <xsl:choose>
                <xsl:when test="$type='dataTable'">Data Table</xsl:when>
                <xsl:when test="$type='spatialRaster'">Spatial Raster</xsl:when>
                <xsl:when test="$type='spatialVector'">Spatial Vector</xsl:when>
                <xsl:when test="$type='storedProcedure'">Stored Procedure</xsl:when>
                <xsl:when test="$type='view'">View</xsl:when>
                <xsl:when test="$type='otherEntity'">Other</xsl:when>
              </xsl:choose>
            </xsl:variable>
            
            <xsl:call-template name="entityurl">
              <xsl:with-param name="typelabel" select="$typelabel"/>
              <xsl:with-param name="show_entity_description" select="$show_entity_description"></xsl:with-param>
              <xsl:with-param name="index" select="position()"/>
              <xsl:with-param name="type" select="$type"/>
            </xsl:call-template>
            
          </xsl:for-each>
          -->
          </table>
        </xsl:element>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="entityurl">
    <xsl:param name="typelabel"/>
    <xsl:param name="type"/>
    <xsl:param name="index"/>
    <xsl:param name="show_entity_description"/>
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <tr>
            <td class="{$firstColStyle}">
              <em class="bold">
                <xsl:value-of select="$typelabel"/>
                <xsl:text>: </xsl:text>
              </em>
              <br/>
              <!--    <xsl:text>(Follow link)</xsl:text> -->
            </td>
            <td class="{secondColStyle}">
              <a>
                <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                    select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of
                    select="$type"/>&amp;entityindex=<xsl:value-of select="$index"/></xsl:attribute>
                <xsl:value-of select="./entityName"/>
              </a>
              <br/>
              <xsl:if test="$show_entity_description = 'true'">
                <xsl:value-of select="./entityDescription"/>
              </xsl:if>
            </td>
          </tr>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td class="{$firstColStyle}">
            <form class="entity-link" action="{$cgi-prefix}/{$referrer}" method="GET">
              <input type="hidden" name="docid">
                <xsl:attribute name="value">
                  <xsl:value-of select="$docid"/>
                </xsl:attribute>
              </input>
              <input type="hidden" name="displaymodule">
                <xsl:attribute name="value">entity</xsl:attribute>
              </input>
              <input type="hidden" name="entitytype">
                <xsl:attribute name="value">
                  <xsl:value-of select="$type"/>
                </xsl:attribute>
              </input>
              <input type="hidden" name="entityindex">
                <xsl:attribute name="value">
                  <xsl:value-of select="$index"/>
                </xsl:attribute>
              </input>
              <input type="submit" class="view-data-button">
                <!-- a label for the button -->
                <xsl:attribute name="value">
                  <xsl:value-of select="$typelabel"/>
                </xsl:attribute>
              </input>
            </form>
            <!--  this is the simple label-only version, instead of the form button.
              <em class="bold"><xsl:value-of select="$showtype"/><xsl:text>: </xsl:text></em>
              <br></br>-->
            <!--    <xsl:text>(Follow link)</xsl:text>   -->
          </td>
          <td class="{secondColStyle}">
            <a>
              <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                  select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of
                  select="$type"/>&amp;entityindex=<xsl:value-of select="$index"/></xsl:attribute>
              <xsl:value-of select="./entityName"/>
            </a>
            <br/>
            <xsl:if test="$show_entity_description = 'true'">
              <xsl:value-of select="./entityDescription"/>
            </xsl:if>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="text()" mode="dataset"/>
  <xsl:template match="text()" mode="resource"/>
  <xsl:template name="datasetentity_old">
    <xsl:param name="show_entity_description"/>
    <xsl:if
      test="dataTable or spatialRaster or spatialVector or storedProcedures or view or otherEntity">
      <xsl:choose>
        <xsl:when test="dataTable">
          <tr>
            <th colspan="2">
              <xsl:text>Detailed Data Description and Download:</xsl:text>
            </th>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <tr>
            <th colspan="2">
              <xsl:text>Detailed Data Description and Download:</xsl:text>
            </th>
          </tr>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- 
    
    when you call the entityurl template, include a label for type of entity  -->
    <xsl:for-each select="dataTable">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">dataTable</xsl:with-param>
        <xsl:with-param name="showtype">Data Table</xsl:with-param>
        <xsl:with-param name="show_entity_description"/>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="spatialRaster">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">spatialRaster</xsl:with-param>
        <xsl:with-param name="showtype">Spatial Raster</xsl:with-param>
        <xsl:with-param name="show_entity_description"/>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="spatialVector">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">spatialVector</xsl:with-param>
        <xsl:with-param name="showtype">Spatial Vector</xsl:with-param>
        <xsl:with-param name="show_entity_description"/>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="storedProcedure">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">storedProcedure</xsl:with-param>
        <xsl:with-param name="showtype">Stored Procedure</xsl:with-param>
        <xsl:with-param name="show_entity_description"/>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="view">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">view</xsl:with-param>
        <xsl:with-param name="showtype">View</xsl:with-param>
        <xsl:with-param name="show_entity_description"/>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="otherEntity">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">otherEntity</xsl:with-param>
        <xsl:with-param name="showtype">Other</xsl:with-param>
        <xsl:with-param name="show_entity_description"/>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="entityurl_old">
    <xsl:param name="showtype"/>
    <xsl:param name="type"/>
    <xsl:param name="index"/>
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <tr>
            <td class="{$firstColStyle}">
              <em class="bold">
                <xsl:value-of select="$showtype"/>
                <xsl:text>: </xsl:text>
              </em>
              <br/>
              <!--    <xsl:text>(Follow link)</xsl:text> -->
            </td>
            <td class="{secondColStyle}">
              <a>
                <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                    select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of
                    select="$type"/>&amp;entityindex=<xsl:value-of select="$index"/></xsl:attribute>
                <xsl:value-of select="./entityName"/>
              </a>
              <br/>
              <xsl:value-of select="./entityDescription"/>
            </td>
          </tr>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td class="{$firstColStyle}">
            <form class="entity-link" action="{$cgi-prefix}/{$referrer}" method="GET">
              <input type="hidden" name="docid">
                <xsl:attribute name="value">
                  <xsl:value-of select="$docid"/>
                </xsl:attribute>
              </input>
              <input type="hidden" name="displaymodule">
                <xsl:attribute name="value">entity</xsl:attribute>
              </input>
              <input type="hidden" name="entitytype">
                <xsl:attribute name="value">
                  <xsl:value-of select="$type"/>
                </xsl:attribute>
              </input>
              <input type="hidden" name="entityindex">
                <xsl:attribute name="value">
                  <xsl:value-of select="$index"/>
                </xsl:attribute>
              </input>
              <input type="submit" class="view-data-button">
                <!-- a label for the button -->
                <xsl:attribute name="value">
                  <xsl:value-of select="$showtype"/>
                </xsl:attribute>
              </input>
            </form>
            <!--  this is the simple label-only version, instead of the form button.
              <em class="bold"><xsl:value-of select="$showtype"/><xsl:text>: </xsl:text></em>
              <br></br>-->
            <!--    <xsl:text>(Follow link)</xsl:text>   -->
          </td>
          <td class="{secondColStyle}">
            <a>
              <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                  select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of
                  select="$type"/>&amp;entityindex=<xsl:value-of select="$index"/></xsl:attribute>
              <xsl:value-of select="./entityName"/>
            </a>
            <br/>
            <xsl:value-of select="./entityDescription"/>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
       ********************************************************
             adding DATATABLE templates 
       ********************************************************
         -->
  <xsl:template name="dataTable">
    <xsl:param name="datatablefirstColStyle"/>
    <xsl:param name="datatablesubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entityindex"/>
    <!-- mob added this -->
    <xsl:param name="numberOfColumns">
      <xsl:if test="$withAttributes = '1'">
        <xsl:value-of select="count(attributeList/attribute/attributeName)"/>
      </xsl:if>
    </xsl:param>
    <table class="dataset-entity-part">
      <tr>
        <td class="dataset-entity-part-header">
          <h3>Data Table </h3>
        </td>
        <td>
          <div class="dataset-entity-part-backtos">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$tripleURI"/>
                <xsl:value-of select="$docid"/>
              </xsl:attribute>
              <xsl:attribute name="class">datasetmenu</xsl:attribute>
              <xsl:text>Back to Dataset  Summary  and Tabbed View</xsl:text>
            </xsl:element>
          </div>
        </td>
      </tr>
    </table>
    <table class="subGroup onehundred_percent">
      <tr>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:choose>
              <xsl:when test="references != ''">
                <xsl:variable name="ref_id" select="references"/>
                <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
                <xsl:for-each select="$references">
                  <xsl:call-template name="datatablecommon">
                    <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
                    <xsl:with-param name="datatablesubHeaderStyle" select="$datatablesubHeaderStyle"/>
                    <xsl:with-param name="docid" select="$docid"/>
                    <xsl:with-param name="entityindex" select="$entityindex"/>
                    <xsl:with-param name="numberOfColumns" select="$numberOfColumns"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="datatablecommon">
                  <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
                  <xsl:with-param name="datatablesubHeaderStyle" select="$datatablesubHeaderStyle"/>
                  <xsl:with-param name="docid" select="$docid"/>
                  <xsl:with-param name="entityindex" select="$entityindex"/>
                  <xsl:with-param name="numberOfColumns" select="$numberOfColumns"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </table>
        </td>
        <td>
          <table class="{$tabledefaultStyle}">
            <!-- moved this out of datatablecommon, to break up linear arrangment  -->
            <xsl:if test="physical">
              <tr>
                <th colspan="2"> Table Structure: </th>
              </tr>
              <!-- distrubution is still under datatablecommon 
        <xsl:for-each select="physical">
       <xsl:call-template name="showdistribution">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
          <xsl:with-param name="physicalindex" select="position()"/>
          <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
          <xsl:with-param name="datatablesubHeaderStyle" select="$datatablesubHeaderStyle"/>
       </xsl:call-template>
    </xsl:for-each>-->
            </xsl:if>
            <xsl:for-each select="physical">
              <tr>
                <td colspan="2">
                  <xsl:call-template name="physical">
                    <xsl:with-param name="physicalfirstColStyle" select="$datatablefirstColStyle"/>
                    <xsl:with-param name="notshowdistribution">yes</xsl:with-param>
                  </xsl:call-template>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </table>
    <!-- a second table for the attributeList -->
    <table class="{$tabledefaultStyle}">
      <tr>
        <th colspan="2">Table Column Descriptions</th>
      </tr>
      <tr>
        <td>
          <xsl:if test="$withAttributes = '1'">
            <xsl:for-each select="attributeList">
              <xsl:call-template name="datatableattributeList">
                <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
                <xsl:with-param name="datatablesubHeaderStyle" select="$datatablesubHeaderStyle"/>
                <xsl:with-param name="docid" select="$docid"/>
                <xsl:with-param name="entityindex" select="$entityindex"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:if>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template name="datatablecommon">
    <xsl:param name="datatablefirstColStyle"/>
    <xsl:param name="datatablesubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="numberOfColumns"/>
    <xsl:for-each select="physical">
      <xsl:call-template name="showdistribution">
        <xsl:with-param name="docid" select="$docid"/>
        <xsl:with-param name="entityindex" select="$entityindex"/>
        <xsl:with-param name="physicalindex" select="position()"/>
        <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
        <xsl:with-param name="datatablesubHeaderStyle" select="$datatablesubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- only one entityName is allowed, so is foreach superfluous  -->
    <xsl:for-each select="entityName">
      <xsl:call-template name="entityName">
        <xsl:with-param name="entityfirstColStyle" select="$datatablefirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="alternateIdentifier">
      <xsl:call-template name="entityalternateIdentifier">
        <xsl:with-param name="entityfirstColStyle" select="$datatablefirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="entityDescription">
      <xsl:call-template name="entityDescription">
        <xsl:with-param name="entityfirstColStyle" select="$datatablefirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="additionalInfo">
      <xsl:call-template name="entityadditionalInfo">
        <xsl:with-param name="entityfirstColStyle" select="$datatablefirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="numberOfRecords">
      <xsl:call-template name="datatablenumberOfRecords">
        <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- show the number of columns, too -->
    <xsl:call-template name="datatablenumberOfColumns">
      <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
      <xsl:with-param name="numberOfColumns" select="$numberOfColumns"/>
    </xsl:call-template>
    <!-- move the rest of physical module to second col -->
    <!--           <xsl:for-each select="physical">
       <xsl:call-template name="showdistribution">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
          <xsl:with-param name="physicalindex" select="position()"/>
          <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
          <xsl:with-param name="datatablesubHeaderStyle" select="$datatablesubHeaderStyle"/>
       </xsl:call-template>
    </xsl:for-each>
-->
    <!-- could move this element down? it's boring -->
    <!--
    <xsl:for-each select="caseSensitive">
       <xsl:call-template name="datatablecaseSensitive">
          <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
       </xsl:call-template>
    </xsl:for-each>
    -->
    <!-- Moved this to above distribution -->
    <!--
    <xsl:for-each select="numberOfRecords">
       <xsl:call-template name="datatablenumberOfRecords">
          <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
       </xsl:call-template>
    </xsl:for-each>
    -->
    <xsl:if test="coverage">
      <tr>
        <td class="{$datatablesubHeaderStyle}" colspan="2">
          <!-- label removed by mob, 16apr2010 
           Coverage Description: -->
        </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="coverage">
      <tr>
        <td colspan="2">
          <xsl:call-template name="coverage"/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="method">
      <tr>
        <td class="{$datatablesubHeaderStyle}" colspan="2">
          <!-- label removed by mob, 16apr2010 
        Method Description: -->
        </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="method">
      <tr>
        <td colspan="2">
          <xsl:call-template name="method">
            <xsl:with-param name="methodfirstColStyle" select="$datatablefirstColStyle"/>
            <xsl:with-param name="methodsubHeaderStyle" select="$datatablesubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="constraint">
      <tr>
        <td class="{$datatablesubHeaderStyle}" colspan="2"> Constraint: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="constraint">
      <tr>
        <td colspan="2">
          <xsl:call-template name="constraint">
            <xsl:with-param name="constraintfirstColStyle" select="$datatablefirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <!-- copied this snippet to the second table in template=dataTable -->
    <!-- 

     <xsl:if test="$withAttributes='1'">
      <xsl:for-each select="attributeList">
       <xsl:call-template name="datatableattributeList">
         <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
         <xsl:with-param name="datatablesubHeaderStyle" select="$datatablesubHeaderStyle"/>
         <xsl:with-param name="docid" select="$docid"/>
         <xsl:with-param name="entityindex" select="$entityindex"/>
       </xsl:call-template>
      </xsl:for-each>
     </xsl:if>

     -->
    <!-- copied this snippet up to display url sooner. move phys later? -->
    <!-- Here to display distribution info-->
    <!--
    <xsl:for-each select="physical">
       <xsl:call-template name="showdistribution">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
          <xsl:with-param name="physicalindex" select="position()"/>
          <xsl:with-param name="datatablefirstColStyle" select="$datatablefirstColStyle"/>
          <xsl:with-param name="datatablesubHeaderStyle" select="$datatablesubHeaderStyle"/>
       </xsl:call-template>
    </xsl:for-each>
-->
  </xsl:template>
  <xsl:template name="datatablecaseSensitive">
    <xsl:param name="datatablefirstColStyle"/>
    <tr>
      <td class="{$datatablefirstColStyle}"> Case Sensitive?</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="datatablenumberOfRecords">
    <xsl:param name="datatablefirstColStyle"/>
    <tr>
      <td class="{$datatablefirstColStyle}"> Number of Records:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="datatablenumberOfColumns">
    <xsl:param name="numberOfColumns"/>
    <xsl:param name="datatablefirstColStyle"/>
    <tr>
      <td class="{$datatablefirstColStyle}"> Number of Columns:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="$numberOfColumns"/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="showdistribution">
    <xsl:param name="datatablefirstColStyle"/>
    <xsl:param name="datatablesubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="level">entitylevel</xsl:param>
    <xsl:param name="entitytype">dataTable</xsl:param>
    <xsl:param name="entityindex"/>
    <xsl:param name="physicalindex"/>
    <xsl:if test="distribution">
      <tr>
        <th colspan="2">REQUEST DATA:</th>
      </tr>
    </xsl:if>
    <xsl:for-each select="distribution">
      <tr>
        <td colspan="2">
          <xsl:call-template name="distribution">
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="level" select="$level"/>
            <xsl:with-param name="entitytype" select="$entitytype"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
            <xsl:with-param name="physicalindex" select="$physicalindex"/>
            <xsl:with-param name="distributionindex" select="position()"/>
            <xsl:with-param name="disfirstColStyle" select="$datatablefirstColStyle"/>
            <xsl:with-param name="dissubHeaderStyle" select="$datatablesubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="datatableattributeList">
    <xsl:param name="datatablefirstColStyle"/>
    <xsl:param name="datatablesubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entitytype">dataTable</xsl:param>
    <xsl:param name="entityindex"/>
    <tr>
      <td class="{$datatablesubHeaderStyle}" colspan="2">
        <!-- <xsl:text>Attribute(s) Info:</xsl:text> -->
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <xsl:call-template name="attributelist">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entitytype" select="$entitytype"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding DISTRIBTUION templates 
       ********************************************************
         -->
  <xsl:template name="distribution">
    <xsl:param name="disfirstColStyle"/>
    <xsl:param name="dissubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="level">entitylevel</xsl:param>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="physicalindex"/>
    <xsl:param name="distributionindex"/>
    <!-- 
      2010-06-01 mob added  for the data use agreement form. prefix is in the eml-settings. 
      -->
    <xsl:param name="cgi-prefix"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:apply-templates select="online">
              <xsl:with-param name="dissubHeaderStyle" select="$dissubHeaderStyle"/>
              <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="offline">
              <xsl:with-param name="dissubHeaderStyle" select="$dissubHeaderStyle"/>
              <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="inline">
              <xsl:with-param name="dissubHeaderStyle" select="$dissubHeaderStyle"/>
              <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
              <xsl:with-param name="docid" select="$docid"/>
              <xsl:with-param name="level" select="$level"/>
              <xsl:with-param name="entitytype" select="$entitytype"/>
              <xsl:with-param name="entityindex" select="$entityindex"/>
              <xsl:with-param name="physicalindex" select="$physicalindex"/>
              <xsl:with-param name="distributionindex" select="$distributionindex"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="online">
            <xsl:with-param name="dissubHeaderStyle" select="$dissubHeaderStyle"/>
            <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="offline">
            <xsl:with-param name="dissubHeaderStyle" select="$dissubHeaderStyle"/>
            <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="inline">
            <xsl:with-param name="dissubHeaderStyle" select="$dissubHeaderStyle"/>
            <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="level" select="$level"/>
            <xsl:with-param name="entitytype" select="$entitytype"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
            <xsl:with-param name="physicalindex" select="$physicalindex"/>
            <xsl:with-param name="distributionindex" select="$distributionindex"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template match="online">
    <xsl:param name="disfirstColStyle"/>
    <xsl:param name="dissubHeaderStyle"/>
    <tr>
      <td class="{$dissubHeaderStyle}" colspan="2">
        <xsl:text>Available Online:</xsl:text>
      </td>
    </tr>
    <xsl:apply-templates select="url">
      <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="connection">
      <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="connectionDefinition">
      <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="url">
    <xsl:param name="disfirstColStyle"/>
    <xsl:variable name="URL" select="."/>
    <xsl:variable name="entity_name">
      <xsl:value-of select="../../../../entityName"/>
    </xsl:variable>
    <!-- added by mob jan 2014 -->
    <xsl:variable name="object_name">
      <xsl:value-of select="../../../objectName"/>
    </xsl:variable>
    <xsl:variable name="package_id">
      <xsl:value-of select="../../../../../../@packageId"/>
    </xsl:variable>
    <tr>
      <!-- contents of this row depends on resource being downloaded
             if it's in a dataTable tree, url is intercepted by data-use-agreement-form which asks
             for some info via cgi script.
        -->
      <!-- 2010 feb mob: changed to always push users through the data use agreement. -->
      <!-- BAD IDEA. only data urls should be pushed through the agreement. not protocol urls. -->
      <xsl:choose>
        <xsl:when test="not(ancestor::methods)">
          <!-- <xsl:when test="0=1"> -->
          <td class="{$disfirstColStyle}">
            <xsl:text> </xsl:text>
            <xsl:text>Download data after acceptance of SBC LTER Data Use Agreement:</xsl:text>
          </td>
          <td class="{$secondColStyle}">
            <!--     create links to each of this package's data entities. 
                   edit the url first, then pass it to the form template with param. -->
            <xsl:choose>
              <!-- 
                      if the content of url is to external data table -->
              <xsl:when test="starts-with($URL, 'http')">
                <xsl:variable name="URL1" select="$URL"/>
                <xsl:call-template name="data_use_agreement_form">
                  <xsl:with-param name="entity_name" select="$entity_name"/>
                  <xsl:with-param name="URL1" select="$URL1"/>
                  <!-- added by mob 2014 -->
                  <xsl:with-param name="object_name" select="$object_name"/>
                  <xsl:with-param name="package_id" select="$package_id"/>
                </xsl:call-template>
              </xsl:when>
              <!-- 
                      if URL uses ecogrid protocol, strip off table name, then create metacat query  -->
              <xsl:when test="starts-with($URL, 'ecogrid')">
                <xsl:variable name="URLsubstr" select="substring-after($URL, 'ecogrid://')"/>
                <xsl:variable name="docID" select="substring-after($URLsubstr, '/')"/>
                <xsl:variable name="URL1">
                  <xsl:value-of select="$contextURL"/>
                  <xsl:text>/knb/metacat?action=read&amp;qformat=default</xsl:text>
                  <xsl:text>&amp;docid=</xsl:text>
                  <xsl:value-of select="$docID"/>
                </xsl:variable>
                <xsl:call-template name="data_use_agreement_form">
                  <xsl:with-param name="entity_name" select="$entity_name"/>
                  <xsl:with-param name="URL1" select="$URL1"/>
                  <!-- added by mob 2014 -->
                  <xsl:with-param name="object_name" select="$object_name"/>
                  <xsl:with-param name="package_id" select="$package_id"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <!-- 
                         else, assume the "url content" is just the name of a metacat table -->
                <xsl:variable name="URL1">
                  <xsl:value-of select="$contextURL"/>
                  <xsl:text>/knb/metacat?action=read&amp;qformat=default</xsl:text>
                  <xsl:text>&amp;docid=</xsl:text>
                  <xsl:value-of select="$URL"/>
                </xsl:variable>
                <xsl:call-template name="data_use_agreement_form">
                  <xsl:with-param name="entity_name" select="$entity_name"/>
                  <xsl:with-param name="URL1" select="$URL1"/>
                  <!-- added by mob 2014 -->
                  <xsl:with-param name="object_name" select="$object_name"/>
                  <xsl:with-param name="package_id" select="$package_id"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <!-- the original content, url shows as a link. -->
          <td class="{$disfirstColStyle}">
            <xsl:text> </xsl:text>
            <xsl:text>View:</xsl:text>
          </td>
          <td class="{$secondColStyle}">
            <a>
              <xsl:choose>
                <xsl:when test="starts-with($URL, 'ecogrid')">
                  <xsl:variable name="URL1" select="substring-after($URL, 'ecogrid://')"/>
                  <xsl:variable name="docID" select="substring-after($URL1, '/')"/>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$tripleURI"/>
                    <xsl:value-of select="$docID"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$URL"/>
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:attribute name="target">_blank</xsl:attribute>
              <xsl:value-of select="."/>
            </a>
          </td>
        </xsl:otherwise>
      </xsl:choose>
    </tr>
    <xsl:if
      test="ancestor::otherEntity[physical/dataFormat/externallyDefinedFormat/formatName = 'KML']">
      <tr>
        <td>View KML content with Google Maps:</td>
        <td>
          <xsl:element name="a"><xsl:attribute name="href"
                ><xsl:text>http://maps.google.com/?q=</xsl:text><xsl:value-of select="$URL"
              /></xsl:attribute> CLICK HERE FOR MAP (leaves sbc.lternet.edu) </xsl:element>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="connection">
    <xsl:param name="disfirstColStyle"/>
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <xsl:call-template name="connectionCommon">
            <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="connectionCommon">
          <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="connectionCommon">
    <xsl:param name="disfirstColStyle"/>
    <xsl:if test="parameter">
      <tr>
        <td class="{$disfirstColStyle}">
          <xsl:text>Parameter(s):</xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:text> </xsl:text>
        </td>
      </tr>
      <xsl:call-template name="renderParameters">
        <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates select="connectionDefinition">
      <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template name="renderParameters">
    <xsl:param name="disfirstColStyle"/>
    <xsl:for-each select="parameter">
      <tr>
        <td class="{$disfirstColStyle}">
          <xsl:text>     </xsl:text>
          <xsl:value-of select="name"/>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="value"/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="connectionDefinition">
    <xsl:param name="disfirstColStyle"/>
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <xsl:call-template name="connectionDefinitionCommon">
            <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="connectionDefinitionCommon">
          <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="connectionDefinitionCommon">
    <xsl:param name="disfirstColStyle"/>
    <tr>
      <td class="{$disfirstColStyle}">
        <xsl:text>Schema Name:</xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="schemeName"/>
      </td>
    </tr>
    <tr>
      <td class="{$disfirstColStyle}">
        <xsl:text>Description:</xsl:text>
      </td>
      <td>
        <xsl:apply-templates select="description">
          <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
        </xsl:apply-templates>
      </td>
    </tr>
    <xsl:for-each select="parameterDefinition">
      <xsl:call-template name="renderParameterDefinition">
        <xsl:with-param name="disfirstColStyle" select="$disfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="description">
    <xsl:param name="disfirstColStyle"/>
    <xsl:call-template name="text">
      <xsl:with-param name="textfirstColStyle" select="$secondColStyle"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="renderParameterDefinition">
    <xsl:param name="disfirstColStyle"/>
    <tr>
      <td class="{$disfirstColStyle}">
        <xsl:text>     </xsl:text>
        <xsl:value-of select="name"/>
        <xsl:text>:</xsl:text>
      </td>
      <td>
        <table class="{$tabledefaultStyle}">
          <tr>
            <td class="{$disfirstColStyle}">
              <xsl:choose>
                <xsl:when test="defaultValue">
                  <xsl:value-of select="defaultValue"/>
                </xsl:when>
                <xsl:otherwise>   </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="{$secondColStyle}">
              <xsl:value-of select="definition"/>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="offline">
    <xsl:param name="disfirstColStyle"/>
    <xsl:param name="dissubHeaderStyle"/>
    <tr>
      <td class="{$dissubHeaderStyle}" colspan="2">
        <xsl:text>Data are Offline:</xsl:text>
      </td>
    </tr>
    <xsl:if test="(mediumName) and normalize-space(mediumName) != ''">
      <tr>
        <td class="{$disfirstColStyle}">
          <xsl:text>Medium:</xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="mediumName"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="(mediumDensity) and normalize-space(mediumDensity) != ''">
      <tr>
        <td class="{$disfirstColStyle}">
          <xsl:text>Medium Density:</xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="mediumDensity"/>
          <xsl:if test="(mediumDensityUnits) and normalize-space(mediumDensityUnits) != ''">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="mediumDensityUnits"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="(mediumVol) and normalize-space(mediumVol) != ''">
      <tr>
        <td class="{$disfirstColStyle}">
          <xsl:text>Volume:</xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="mediumVol"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="(mediumFormat) and normalize-space(mediumFormat) != ''">
      <tr>
        <td class="{$disfirstColStyle}">
          <xsl:text>Format:</xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="mediumFormat"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="(mediumNote) and normalize-space(mediumNote) != ''">
      <tr>
        <td class="{$disfirstColStyle}">
          <xsl:text>Notes:</xsl:text>
        </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="mediumNote"/>
        </td>
      </tr>
    </xsl:if>
    <!-- added the request-data button oct 2012 mob -->
    <tr>
      <td class="{$disfirstColStyle}">
        <xsl:text>Request data:</xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <!-- as a simple link: -->
        <!--  <a><xsl:attribute name="href">mailto:<xsl:value-of select="//dataset/contact[1]/electronicMailAddress"/>
          <xsl:text>?subject=Request for dataset: </xsl:text>
          <xsl:value-of select="//dataset/title[1]"/>
        </xsl:attribute>
          <xsl:value-of select="./entityName"/>Send email request to primary contact (<xsl:value-of select="//dataset/contact[1]/electronicMailAddress"/>)
          </a>
        <br /> -->
        <!-- as a form button. -->
        <form method="GET" class="entity-link">
          <xsl:attribute name="action"> mailto:<xsl:value-of
              select="//dataset/contact[1]/electronicMailAddress"/></xsl:attribute>
          <input type="hidden">
            <xsl:attribute name="value">
              <xsl:value-of select="../../../entityName"/>
            </xsl:attribute>
            <xsl:attribute name="name">subject</xsl:attribute>
          </input>
          <!-- some mail clients will embed plus signs. icky 
          <input type="hidden">
            <xsl:attribute name="value">
              <xsl:value-of select="//dataset/title"/> 
            </xsl:attribute>       
            <xsl:attribute name="name" >body</xsl:attribute>        
          </input> -->
          <input type="submit" class="view-data-button">
            <xsl:attribute name="value">Request via email to <xsl:value-of
                select="//dataset/contact[1]/electronicMailAddress"/></xsl:attribute>
          </input>
        </form>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="inline">
    <xsl:param name="disfirstColStyle"/>
    <xsl:param name="dissubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="level">entity</xsl:param>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="physicalindex"/>
    <xsl:param name="distributionindex"/>
    <tr>
      <td class="{$dissubHeaderStyle}" colspan="2">
        <xsl:text>Data:</xsl:text>
      </td>
    </tr>
    <tr>
      <td class="{$disfirstColStyle}">
        <xsl:text> </xsl:text>
      </td>
      <td class="{$secondColStyle}">
        <!-- for top top distribution-->
        <xsl:if test="$level = 'toplevel'">
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                select="$docid"/>&amp;displaymodule=inlinedata&amp;distributionlevel=<xsl:value-of
                select="$level"/>&amp;distributionindex=<xsl:value-of select="$distributionindex"
              /></xsl:attribute>
            <b>Inline Data</b>
          </a>
        </xsl:if>
        <xsl:if test="$level = 'entitylevel'">
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of
                select="$docid"/>&amp;displaymodule=inlinedata&amp;distributionlevel=<xsl:value-of
                select="$level"/>&amp;entitytype=<xsl:value-of select="$entitytype"
                />&amp;entityindex=<xsl:value-of select="$entityindex"
                />&amp;physicalindex=<xsl:value-of select="$physicalindex"
                />&amp;distributionindex=<xsl:value-of select="$distributionindex"/></xsl:attribute>
            <b>Inline Data</b>
          </a>
        </xsl:if>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="data_use_agreement_form">
    <xsl:param name="cgi-prefix"/>
    <xsl:param name="entity_name"/>
    <xsl:param name="URL1"/>
    <!-- added these params jan 2014 -->
    <xsl:param name="object_name"/>
    <xsl:param name="package_id"/>
    <form method="POST" class="entity-link">
      <xsl:attribute name="action">[% site.url.cgi_bin %]/data-use-agreement.cgi</xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="translate($entity_name, '()-.', '')"/>
      </xsl:attribute>
      <input type="hidden" name="qformat"/>
      <input type="hidden" name="sessionid"/>
      <input type="hidden" name="url">
        <xsl:attribute name="value">
          <xsl:value-of select="$URL1"/>
        </xsl:attribute>
      </input>
      <input type="hidden" name="entityName">
        <xsl:attribute name="value">
          <xsl:value-of select="$entity_name"/>
        </xsl:attribute>
      </input>
      <!-- send along these 2 inputs also, jan 2014 -->
      <input type="hidden" name="objectName">
        <xsl:attribute name="value">
          <xsl:value-of select="$object_name"/>
        </xsl:attribute>
      </input>
      <input type="hidden" name="packageID">
        <xsl:attribute name="value">
          <xsl:value-of select="$package_id"/>
        </xsl:attribute>
      </input>
      <input type="submit" name="data" class="view-data-button">
        <!-- char &#10; is a new line  -->
        <xsl:attribute name="value">DOWNLOAD DATA: <xsl:text/><xsl:value-of select="$entity_name"
          /><!-- open for testing.
              <xsl:value-of select="$object_name"/>
               <xsl:value-of select="$package_id"/> --></xsl:attribute>
      </input>
      <br/>
    </form>
  </xsl:template>
  <!--
       ********************************************************
             adding ENTITY templates 
       ********************************************************
         -->
  <xsl:template name="entityName">
    <xsl:param name="entityfirstColStyle"/>
    <tr>
      <td class="{$entityfirstColStyle}"> Name:</td>
      <td class="{$secondColStyle}">
        <b>
          <xsl:value-of select="."/>
        </b>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="entityalternateIdentifier">
    <xsl:param name="entityfirstColStyle"/>
    <tr>
      <td class="{$entityfirstColStyle}"> Identifier:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="entityDescription">
    <xsl:param name="entityfirstColStyle"/>
    <tr>
      <td class="{$entityfirstColStyle}"> Description:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="entityadditionalInfo">
    <xsl:param name="entityfirstColStyle"/>
    <tr>
      <td class="{$entityfirstColStyle}"> Additional Info:</td>
      <td>
        <xsl:call-template name="text"/>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding IDENTIFIER templates 
       ********************************************************
         -->
  <xsl:template name="identifier">
    <xsl:param name="IDfirstColStyle"/>
    <xsl:param name="IDsecondColStyle"/>
    <xsl:param name="packageID"/>
    <xsl:param name="system"/>
    <xsl:if test="normalize-space(.)">
      <tr>
        <td class="{$IDfirstColStyle}">Identifier:</td>
        <td class="{$IDsecondColStyle}">
          <xsl:value-of select="$packageID"/>
          <xsl:if test="normalize-space(../@system) != ''">
            <xsl:text> (in the </xsl:text>
            <em class="italic">
              <xsl:value-of select="$system"/>
            </em>
            <xsl:text> Catalog System)</xsl:text>
          </xsl:if>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <!--
       ********************************************************
             adding LITERATURE templates 
       ********************************************************
         -->
  <xsl:template name="citation">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="citationCommon">
              <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
              <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="citationCommon">
            <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
            <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="citationCommon">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2">
        <xsl:call-template name="resource">
          <xsl:with-param name="resfirstColStyle" select="$citationfirstColStyle"/>
          <xsl:with-param name="ressubHeaderStyle" select="$citationsubHeaderStyle"/>
          <xsl:with-param name="creator">Author(s):</xsl:with-param>
        </xsl:call-template>
      </td>
    </tr>
    <xsl:for-each select="article">
      <xsl:call-template name="citationarticle">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="book">
      <xsl:call-template name="citationbook">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="chapter">
      <xsl:call-template name="citationchapter">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="editedBook">
      <xsl:call-template name="citationeditedBook">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="manuscript">
      <xsl:call-template name="citationmanuscript">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="report">
      <xsl:call-template name="citationreport">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="thesis">
      <xsl:call-template name="citationthesis">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="conferenceProceedings">
      <xsl:call-template name="citationconferenceProceedings">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="personalCommunication">
      <xsl:call-template name="citationpersonalCommunication">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="map">
      <xsl:call-template name="citationmap">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="generic">
      <xsl:call-template name="citationgeneric">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="audioVisual">
      <xsl:call-template name="citationaudioVisual">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="presentation">
      <xsl:call-template name="citationpresentation">
        <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
        <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="access and normalize-space(access) != ''">
      <tr>
        <td colspan="2">
          <xsl:for-each select="access">
            <xsl:call-template name="access">
              <xsl:with-param name="accessfirstColStyle" select="$citationfirstColStyle"/>
              <xsl:with-param name="accesssubHeaderStyle" select="$citationsubHeaderStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="citationarticle">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td class="{$citationsubHeaderStyle}" colspan="2">
        <xsl:text>ARTICLE:</xsl:text>
      </td>
    </tr>
    <tr>
      <td class="{$citationfirstColStyle}"> Journal:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="journal"/>
      </td>
    </tr>
    <tr>
      <td class="{$citationfirstColStyle}"> Volume:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="volume"/>
      </td>
    </tr>
    <xsl:if test="issue and normalize-space(issue) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Issue:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="issue"/>
        </td>
      </tr>
    </xsl:if>
    <tr>
      <td class="{$citationfirstColStyle}"> Page Range:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="pageRange"/>
      </td>
    </tr>
    <xsl:if test="publisher and normalize-space(publisher) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Publisher:</td>
        <td class="{$secondColStyle}">  </td>
      </tr>
      <xsl:for-each select="publisher">
        <tr>
          <td colspan="2">
            <xsl:call-template name="party">
              <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
              <xsl:with-param name="partysubHeaderStyle" select="$citationsubHeaderStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="publicationPlace and normalize-space(publicationPlace) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Publication Place:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="publicationPlace"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="ISSN and normalize-space(ISSN) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> ISSN:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="ISSN"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="citationbook">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <xsl:param name="notshow"/>
    <xsl:if test="$notshow = ''">
      <tr>
        <td colspan="2" class="{$citationsubHeaderStyle}">
          <xsl:text>BOOK:</xsl:text>
        </td>
      </tr>
    </xsl:if>
    <tr>
      <td class="{$citationfirstColStyle}"> Publisher:</td>
      <td>
        <xsl:for-each select="publisher">
          <xsl:call-template name="party">
            <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
          </xsl:call-template>
        </xsl:for-each>
      </td>
    </tr>
    <xsl:if test="publicationPlace and normalize-space(publicationPlace) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Publication Place:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="publicationPlace"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="edition and normalize-space(edition) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Edition:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="edition"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="volume and normalize-space(volume) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Volume:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="volume"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="numberOfVolumes and normalize-space(numberOfVolumes) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Number of Volumes:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="numberOfVolumes"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="totalPages and normalize-space(totalPages) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Total Pages:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="totalPages"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="totalFigures and normalize-space(totalFigures) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Total Figures:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="totalFigures"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="totalTables and normalize-space(totalTables) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Total Tables:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="totalTables"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="ISBN and normalize-space(ISBN) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> ISBN:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="ISBN"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="citationchapter">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2" class="{$citationsubHeaderStyle}">
        <xsl:text>CHAPTER:</xsl:text>
      </td>
    </tr>
    <xsl:if test="chapterNumber and normalize-space(chapterNumber) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Chapter Number:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="chapterNumber"/>
        </td>
      </tr>
    </xsl:if>
    <tr>
      <td class="{$citationfirstColStyle}"> Book Editor:</td>
      <td class="{$secondColStyle}">  </td>
    </tr>
    <xsl:for-each select="editor">
      <tr>
        <td colspan="2">
          <xsl:call-template name="party">
            <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <tr>
      <td class="{$citationfirstColStyle}"> Book Title:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="bookTitle"/>
      </td>
    </tr>
    <xsl:if test="pageRange and normalize-space(pageRange) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Page Range:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="pageRange"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:call-template name="citationbook">
      <xsl:with-param name="notshow" select="yes"/>
      <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
      <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="citationeditedBook">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <xsl:call-template name="citationbook">
      <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
      <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="citationmanuscript">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2" class="{$citationsubHeaderStyle}">
        <xsl:text>MANUSCRIPT:</xsl:text>
      </td>
    </tr>
    <tr>
      <td class="{$citationfirstColStyle}"> Institution: </td>
      <td class="{$secondColStyle}">   </td>
    </tr>
    <xsl:for-each select="institution">
      <tr>
        <td colspan="2">
          <xsl:call-template name="party">
            <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="totalPages and normalize-space(totalPages) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Total Pages:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="totalPages"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="citationreport">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2" class="{$citationsubHeaderStyle}">
        <xsl:text>REPORT:</xsl:text>
      </td>
    </tr>
    <xsl:if test="reportNumber and normalize-space(reportNumber) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Report Number:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="reportNumber"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="publisher and normalize-space(publisher) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Publisher:</td>
        <td class="{$secondColStyle}">  </td>
      </tr>
      <xsl:for-each select="publisher">
        <tr>
          <td colspan="2">
            <xsl:call-template name="party">
              <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="publicationPlace and normalize-space(publicationPlace) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Publication Place:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="publicationPlace"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="totalPages and normalize-space(totalPages) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Total Pages:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="totalPages"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="citationthesis">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2" class="{$citationsubHeaderStyle}">
        <xsl:text>THESIS:</xsl:text>
      </td>
    </tr>
    <tr>
      <td class="{$citationfirstColStyle}"> Degree:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="degree"/>
      </td>
    </tr>
    <tr>
      <td class="{$citationfirstColStyle}"> Degree Institution:</td>
      <td class="{$secondColStyle}">  </td>
    </tr>
    <xsl:for-each select="institution">
      <tr>
        <td colspan="2">
          <xsl:call-template name="party">
            <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
            <xsl:with-param name="partysubHeaderStyle" select="$citationsubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="totalPages and normalize-space(totalPages) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Total Pages:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="totalPages"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="citationconferenceProceedings">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2" class="{$citationsubHeaderStyle}">
        <xsl:text>CONFERENCE PROCEEDINGS:</xsl:text>
      </td>
    </tr>
    <xsl:if test="conferenceName and normalize-space(conferenceName) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Conference Name:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="conferenceName"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="conferenceDate and normalize-space(conferenceDate) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Date:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="conferenceDate"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="conferenceLocation and normalize-space(conferenceLocation) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Location:</td>
        <td class="{$secondColStyle}">  </td>
      </tr>
      <tr>
        <td colspan="2">
          <xsl:for-each select="conferenceLocation">
            <xsl:call-template name="party">
              <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>
    <xsl:call-template name="citationchapter">
      <xsl:with-param name="notshow" select="yes"/>
      <xsl:with-param name="citationfirstColStyle" select="$citationfirstColStyle"/>
      <xsl:with-param name="citationsubHeaderStyle" select="$citationsubHeaderStyle"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="citationpersonalCommunication">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2" class="{$citationsubHeaderStyle}">
        <xsl:text>PERSONAL COMMUNICATION:</xsl:text>
      </td>
    </tr>
    <xsl:if test="publisher and normalize-space(publisher) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Publisher:</td>
        <td class="{$secondColStyle}">  </td>
      </tr>
      <xsl:for-each select="publisher">
        <tr>
          <td colspan="2">
            <xsl:call-template name="party">
              <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="publicationPlace and normalize-space(publicationPlace) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Publication Place:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="publicationPlace"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="communicationType and normalize-space(communicationType) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Communication Type:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="communicationType"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="recipient and normalize-space(recipient) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Recipient:</td>
        <td class="{$secondColStyle}">  </td>
      </tr>
      <xsl:for-each select="recipient">
        <tr>
          <td colspan="2">
            <xsl:call-template name="party">
              <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name="citationmap">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2" class="{$citationsubHeaderStyle}">
        <xsl:text>MAP:</xsl:text>
      </td>
    </tr>
    <xsl:if test="publisher and normalize-space(publisher) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Publisher:</td>
        <td class="{$secondColStyle}">  </td>
      </tr>
      <xsl:for-each select="publisher">
        <tr>
          <td colspan="2">
            <xsl:call-template name="party">
              <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="edition and normalize-space(edition) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Edition:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="edition"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="geographicCoverage and normalize-space(geographicCoverage) != ''">
      <xsl:for-each select="geographicCoverage">
        <xsl:call-template name="geographicCoverage"/>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="scale and normalize-space(scale) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Scale:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="scale"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="citationgeneric">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2" class="{$citationsubHeaderStyle}">
        <xsl:text>Generic Citation:</xsl:text>
      </td>
    </tr>
    <tr>
      <td class="{$citationfirstColStyle}"> Publisher:</td>
      <td class="{$secondColStyle}">   </td>
    </tr>
    <xsl:for-each select="publisher">
      <tr>
        <td colspan="2">
          <xsl:call-template name="party">
            <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="publicationPlace and normalize-space(publicationPlace) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Publication Place:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="publicationPlace"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="referenceType and normalize-space(referenceType) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Reference Type:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="referenceType"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="volume and normalize-space(volume) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Volume:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="volume"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="numberOfVolumes and normalize-space(numberOfVolumes) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Number of Volumes:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="numberOfVolumes"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="totalPages and normalize-space(totalPages) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Total Pages:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="totalPages"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="totalFigures and normalize-space(totalFigures) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Total Figures:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="totalFigures"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="totalTables and normalize-space(totalTables) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Total Tables:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="totalTables"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="edition and normalize-space(edition) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Edition:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="edition"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="originalPublication and normalize-space(originalPublication) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Supplemental Info for Original Publication:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="originalPublication"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="reprintEdition and normalize-space(reprintEdition) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Reprint Edition:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="reprintEdition"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="reviewedItem and normalize-space(reviewedItem) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Review Item:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="reviewedItem"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="ISBN and normalize-space(ISBN) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> ISBN:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="ISBN"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="ISSN and normalize-space(ISSN) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> ISSN:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="ISSN"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="citationaudioVisual">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2" class="{$citationsubHeaderStyle}">
        <xsl:text>Media Citation:</xsl:text>
      </td>
    </tr>
    <tr>
      <td class="{$citationfirstColStyle}"> Publisher:</td>
      <td class="{$secondColStyle}">   </td>
    </tr>
    <xsl:for-each select="publisher">
      <tr>
        <td colspan="2">
          <xsl:call-template name="party">
            <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="publicationPlace and normalize-space(publicationPlace) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Publication Place:</td>
        <td class="{$secondColStyle}">  </td>
      </tr>
      <xsl:for-each select="publicationPlace">
        <tr>
          <td class="{$citationfirstColStyle}">  </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="performer and normalize-space(performer) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Performer:</td>
        <td class="{$secondColStyle}">  </td>
      </tr>
      <xsl:for-each select="performer">
        <tr>
          <td colspan="2">
            <xsl:call-template name="party">
              <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="ISBN and normalize-space(ISBN) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> ISBN:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="ISBN"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="citationpresentation">
    <xsl:param name="citationfirstColStyle"/>
    <xsl:param name="citationsubHeaderStyle"/>
    <tr>
      <td colspan="2" class="{$citationsubHeaderStyle}">
        <xsl:text>Presentation:</xsl:text>
      </td>
    </tr>
    <xsl:if test="conferenceName and normalize-space(conferenceName) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Conference Name:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="conferenceName"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="conferenceDate and normalize-space(conferenceDate) != ''">
      <tr>
        <td class="{$citationfirstColStyle}"> Date:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="conferenceDate"/>
        </td>
      </tr>
    </xsl:if>
    <tr>
      <td class="{$citationfirstColStyle}"> Location:</td>
      <td class="{$secondColStyle}">  </td>
    </tr>
    <tr>
      <td colspan="2">
        <xsl:for-each select="conferenceLocation">
          <xsl:call-template name="party">
            <xsl:with-param name="partyfirstColStyle" select="$citationfirstColStyle"/>
          </xsl:call-template>
        </xsl:for-each>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding METHOD templates 
       ********************************************************
         -->
  <xsl:template name="method">
    <xsl:param name="methodfirstColStyle"/>
    <xsl:param name="methodsubHeaderStyle"/>
    <!-- <table class="{$tabledefaultStyle}">  
	 use this class to unbox the table  -->
    <table class="subGroup onehundred_percent">
      <tr>
        <th colspan="2"
          ><!-- changed table title. usually protocol refs, sometimes procedural steps --><!-- Step by Step Procedures  -->
          Protocols and/or Procedures </th>
      </tr>
      <xsl:for-each select="methodStep">
        <!-- methodStep (defined below) calls step (defined in protocol.xsl).  -->
        <!-- mob added a table element to the step template so that each methodStep 
		is boxed, but without position labels. Could add step labels back in, or just 
		for subSteps with 'if test=substep'? proceduralStep? -->
        <tr>
          <td>
            <xsl:call-template name="methodStep">
              <xsl:with-param name="methodfirstColStyle" select="$methodfirstColStyle"/>
              <xsl:with-param name="methodsubHeaderStyle" select="$methodsubHeaderStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
      <!-- SAMPLING descr, extent -->
      <xsl:if test="sampling">
        <xsl:for-each select="sampling">
          <!-- <table class="{$tabledefaultStyle}">  
			use this class to unbox the table  -->
          <table class="subGroup onehundred_percent">
            <tr>
              <th colspan="2"> Sampling Area and Study Extent </th>
            </tr>
            <tr>
              <td>
                <xsl:call-template name="sampling">
                  <xsl:with-param name="methodfirstColStyle" select="$methodfirstColStyle"/>
                  <xsl:with-param name="methodsubHeaderStyle" select="$methodsubHeaderStyle"/>
                </xsl:call-template>
              </td>
            </tr>
          </table>
        </xsl:for-each>
      </xsl:if>
      <!-- QUALITY CONTROL -->
      <!-- dont have any files to test this on yet, working? -->
      <xsl:if test="qualityControl">
        <table class="{$tabledefaultStyle}">
          <tr>
            <th colspan="2"> Quality Control </th>
          </tr>
          <xsl:for-each select="qualityControl">
            <tr>
              <td class="{$methodfirstColStyle}">
                <b>Quality Control Step<xsl:text/><xsl:value-of select="position()"/>:</b>
              </td>
              <td width="${secondColWidth}" class="{$secondColStyle}">   </td>
            </tr>
            <xsl:call-template name="qualityControl">
              <xsl:with-param name="methodfirstColStyle" select="$methodfirstColStyle"/>
              <xsl:with-param name="methodsubHeaderStyle" select="$methodsubHeaderStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </table>
      </xsl:if>
    </table>
    <!-- matches table onehundredpercent, entire methodStep-->
  </xsl:template>
  <xsl:template name="methodStep">
    <xsl:param name="methodfirstColStyle"/>
    <xsl:param name="methodsubHeaderStyle"/>
    <xsl:call-template name="step">
      <xsl:with-param name="protocolfirstColStyle" select="$methodfirstColStyle"/>
      <xsl:with-param name="protocolsubHeaderStyle" select="$methodsubHeaderStyle"/>
    </xsl:call-template>
    <xsl:for-each select="dataSource">
      <tr>
        <td colspan="2">
          <xsl:apply-templates mode="dataset"/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="sampling">
    <xsl:param name="methodfirstColStyle"/>
    <xsl:param name="methodsubHeaderStyle"/>
    <xsl:for-each select="samplingDescription">
      <table class="{$tabledefaultStyle}">
        <tr>
          <td class="{$methodfirstColStyle}"> Sampling Description: </td>
          <td width="${secondColWidth}">
            <xsl:call-template name="text">
              <xsl:with-param name="textfirstColStyle" select="$methodfirstColStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </table>
    </xsl:for-each>
    <xsl:for-each select="studyExtent">
      <xsl:call-template name="studyExtent">
        <xsl:with-param name="methodfirstColStyle" select="$methodfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="spatialSamplingUnits">
      <xsl:call-template name="spatialSamplingUnits">
        <xsl:with-param name="methodfirstColStyle" select="$methodfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="citation">
      <tr>
        <td class="{$methodfirstColStyle}"> Sampling Citation: </td>
        <td width="${secondColWidth}">
          <xsl:call-template name="citation">
            <xsl:with-param name="citationfirstColStyle" select="$methodfirstColStyle"/>
            <xsl:with-param name="citationsubHeaderStyle" select="$methodsubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="studyExtent">
    <xsl:param name="methodfirstColStyle"/>
    <xsl:param name="methodsubHeaderStyle"/>
    <xsl:for-each select="coverage">
      <!-- this table call puts each coverage node in a box -->
      <table class="{$tabledefaultStyle}">
        <tr>
          <td class="{$methodfirstColStyle}"> Sampling Extent: </td>
          <td width="${secondColWidth}">
            <xsl:call-template name="coverage"/>
          </td>
        </tr>
      </table>
    </xsl:for-each>
    <xsl:for-each select="description">
      <tr>
        <td class="{$methodfirstColStyle}"> Sampling Area And Frequency: </td>
        <td width="${secondColWidth}">
          <xsl:call-template name="text">
            <xsl:with-param name="textfirstColStyle" select="$methodfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="spatialSamplingUnits">
    <xsl:param name="methodfirstColStyle"/>
    <xsl:for-each select="referenceEntityId">
      <tr>
        <td class="{$methodfirstColStyle}"> Sampling Unit Reference: </td>
        <td width="${secondColWidth}" class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="coverage">
      <tr>
        <td class="{$methodfirstColStyle}"> Sampling Unit Location: </td>
        <td width="${secondColWidth}">
          <xsl:call-template name="coverage"/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="qualityControl">
    <xsl:param name="methodfirstColStyle"/>
    <xsl:param name="methodsubHeaderStyle"/>
    <xsl:call-template name="step">
      <xsl:with-param name="protocolfirstColStyle" select="$methodfirstColStyle"/>
      <xsl:with-param name="protocolsubHeaderStyle" select="$methodsubHeaderStyle"/>
    </xsl:call-template>
  </xsl:template>
  <!--
       ********************************************************
             adding OTHERENTITY templates 
       ********************************************************
         -->
  <xsl:template name="otherEntity">
    <xsl:param name="otherentityfirstColStyle"/>
    <xsl:param name="otherentitysubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entityindex"/>
    <!-- mob added the back to -->
    <table class="dataset-entity-part">
      <tr>
        <td class="dataset-entity-part-header">
          <h3>Data Resource, other</h3>
        </td>
        <td>
          <div class="dataset-entity-part-backtos">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$tripleURI"/>
                <xsl:value-of select="$docid"/>
              </xsl:attribute>
              <xsl:attribute name="class">datasetmenu</xsl:attribute>
              <xsl:text>Back to Dataset  Summary  and Tabbed Views</xsl:text>
            </xsl:element>
          </div>
        </td>
      </tr>
    </table>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="otherEntityCommon">
              <xsl:with-param name="otherentityfirstColStyle" select="$otherentityfirstColStyle"/>
              <xsl:with-param name="otherentitysubHeaderStyle" select="$otherentitysubHeaderStyle"/>
              <xsl:with-param name="docid" select="$docid"/>
              <xsl:with-param name="entityindex" select="$entityindex"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="otherEntityCommon">
            <xsl:with-param name="otherentityfirstColStyle" select="$otherentityfirstColStyle"/>
            <xsl:with-param name="otherentitysubHeaderStyle" select="$otherentitysubHeaderStyle"/>
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="otherEntityCommon">
    <xsl:param name="otherentityfirstColStyle"/>
    <xsl:param name="otherentitysubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entityindex"/>
    <xsl:for-each select="entityName">
      <xsl:call-template name="entityName">
        <xsl:with-param name="entityfirstColStyle" select="$otherentityfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="entityType">
      <tr>
        <td class="{$otherentityfirstColStyle}"> Entity Type: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="alternateIdentifier">
      <xsl:call-template name="entityalternateIdentifier">
        <xsl:with-param name="entityfirstColStyle" select="$otherentityfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="entityDescription">
      <xsl:call-template name="entityDescription">
        <xsl:with-param name="entityfirstColStyle" select="$otherentityfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="additionalInfo">
      <xsl:call-template name="entityadditionalInfo">
        <xsl:with-param name="entityfirstColStyle" select="$otherentityfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- call physical moduel without show distribution(we want see it later)-->
    <xsl:if test="physical">
      <tr>
        <td class="{$otherentitysubHeaderStyle}" colspan="2"/>
      </tr>
      <tr>
        <td class="{$otherentitysubHeaderStyle}" colspan="2"> Physical Structure Description: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="physical">
      <tr>
        <td colspan="2">
          <xsl:call-template name="physical">
            <xsl:with-param name="physicalfirstColStyle" select="$otherentityfirstColStyle"/>
            <xsl:with-param name="notshowdistribution">yes</xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="coverage">
      <tr>
        <td class="{$otherentitysubHeaderStyle}" colspan="2"> Coverage Description: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="coverage">
      <tr>
        <td colspan="2">
          <xsl:call-template name="coverage"/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="method">
      <tr>
        <td class="{$otherentitysubHeaderStyle}" colspan="2"> Method Description: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="method">
      <tr>
        <td colspan="2">
          <xsl:call-template name="method">
            <xsl:with-param name="methodfirstColStyle" select="$otherentityfirstColStyle"/>
            <xsl:with-param name="methodsubHeaderStyle" select="$otherentitysubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="constraint">
      <tr>
        <td class="{$otherentitysubHeaderStyle}" colspan="2"> Constraint: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="constraint">
      <tr>
        <td colspan="2">
          <xsl:call-template name="constraint">
            <xsl:with-param name="constraintfirstColStyle" select="$otherentityfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="$withAttributes = '1'">
      <xsl:for-each select="attributeList">
        <xsl:call-template name="otherEntityAttributeList">
          <xsl:with-param name="otherentityfirstColStyle" select="$otherentityfirstColStyle"/>
          <xsl:with-param name="otherentitysubHeaderStyle" select="$otherentitysubHeaderStyle"/>
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
    <!-- Here to display distribution info-->
    <xsl:for-each select="physical">
      <xsl:call-template name="otherEntityShowDistribution">
        <xsl:with-param name="docid" select="$docid"/>
        <xsl:with-param name="entityindex" select="$entityindex"/>
        <xsl:with-param name="physicalindex" select="position()"/>
        <xsl:with-param name="otherentityfirstColStyle" select="$otherentityfirstColStyle"/>
        <xsl:with-param name="otherentitysubHeaderStyle" select="$otherentitysubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="otherEntityShowDistribution">
    <xsl:param name="otherentityfirstColStyle"/>
    <xsl:param name="otherentitysubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="level">entitylevel</xsl:param>
    <xsl:param name="entitytype">otherEntity</xsl:param>
    <xsl:param name="entityindex"/>
    <xsl:param name="physicalindex"/>
    <xsl:for-each select="distribution">
      <tr>
        <td colspan="2">
          <xsl:call-template name="distribution">
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="level" select="$level"/>
            <xsl:with-param name="entitytype" select="$entitytype"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
            <xsl:with-param name="physicalindex" select="$physicalindex"/>
            <xsl:with-param name="distributionindex" select="position()"/>
            <xsl:with-param name="disfirstColStyle" select="$otherentityfirstColStyle"/>
            <xsl:with-param name="dissubHeaderStyle" select="$otherentitysubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="otherEntityAttributeList">
    <xsl:param name="otherentityfirstColStyle"/>
    <xsl:param name="otherentitysubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entitytype">otherEntity</xsl:param>
    <xsl:param name="entityindex"/>
    <tr>
      <td class="{$otherentitysubHeaderStyle}" colspan="2">
        <xsl:text>Attribute(s) Info:</xsl:text>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <xsl:call-template name="attributelist">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entitytype" select="$entitytype"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding PARTY templates 
       ********************************************************
         -->
  <xsl:template name="party">
    <!-- added these params so that the display of a persons profile page can use different apps -->
    <xsl:param name="useridDirectory1"/>
    <xsl:param name="useridDirectoryApp1"/>
    <xsl:param name="useridDirectoryLabel1"/>
    <xsl:param name="partyfirstColStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:apply-templates mode="party">
              <xsl:with-param name="partyfirstColStyle" select="$partyfirstColStyle"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="party">
            <xsl:with-param name="partyfirstColStyle" select="$partyfirstColStyle"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template match="individualName" mode="party">
    <xsl:param name="partyfirstColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$partyfirstColStyle}"> Individual:</td>
        <td class="{$secondColStyle}">
          <b>
            <xsl:value-of select="./salutation"/>
            <xsl:text/>
            <xsl:value-of select="./givenName"/>
            <xsl:text/>
            <xsl:value-of select="./surName"/>
          </b>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="organizationName" mode="party">
    <xsl:param name="partyfirstColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$partyfirstColStyle}"> Organization:</td>
        <td class="{$secondColStyle}">
          <b>
            <xsl:value-of select="."/>
          </b>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="positionName" mode="party">
    <xsl:param name="partyfirstColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$partyfirstColStyle}"> Position:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="address" mode="party">
    <xsl:param name="partyfirstColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <xsl:call-template name="addressCommon">
        <xsl:with-param name="partyfirstColStyle" select="$partyfirstColStyle"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name="address">
    <xsl:param name="partyfirstColStyle"/>
    <table class="{$tablepartyStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="addressCommon">
              <xsl:with-param name="partyfirstColStyle" select="$partyfirstColStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="addressCommon">
            <xsl:with-param name="partyfirstColStyle" select="$partyfirstColStyle"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="addressCommon">
    <xsl:param name="partyfirstColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$partyfirstColStyle}"> Address:</td>
        <td>
          <table class="{$tablepartyStyle}">
            <xsl:for-each select="deliveryPoint">
              <tr>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                  <xsl:text>, </xsl:text>
                </td>
              </tr>
            </xsl:for-each>
            <!-- TO DO: fix template to only include comma after deliveryPoint (above) if a city exists. or since these are all in table rows, you don't need the commas at all. -->
            <tr>
              <td class="{$secondColStyle}">
                <xsl:if test="normalize-space(city) != ''">
                  <xsl:value-of select="city"/>
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:if
                  test="normalize-space(administrativeArea) != '' or normalize-space(postalCode) != ''">
                  <xsl:value-of select="administrativeArea"/>
                  <xsl:text/>
                  <xsl:value-of select="postalCode"/>
                  <xsl:text/>
                </xsl:if>
                <xsl:if test="normalize-space(country) != ''">
                  <xsl:value-of select="country"/>
                </xsl:if>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="phone" mode="party">
    <xsl:param name="partyfirstColStyle"/>
    <tr>
      <td class="{$partyfirstColStyle}"> Phone: </td>
      <td>
        <table class="{$tablepartyStyle}">
          <tr>
            <td class="{$secondColStyle}">
              <xsl:value-of select="."/>
              <xsl:if test="normalize-space(./@phonetype) != ''">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="./@phonetype"/>
                <xsl:text>)</xsl:text>
              </xsl:if>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="electronicMailAddress" mode="party">
    <xsl:param name="partyfirstColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$partyfirstColStyle}"> Email Address: </td>
        <td>
          <table class="{$tablepartyStyle}">
            <tr>
              <td class="{$secondColStyle}">
                <a>
                  <xsl:attribute name="href">mailto:<xsl:value-of select="."/></xsl:attribute>
                  <xsl:value-of select="./entityName"/>
                  <xsl:value-of select="."/>
                </a>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="onlineUrl" mode="party">
    <xsl:param name="partyfirstColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$partyfirstColStyle}"> Web Address: </td>
        <td>
          <table class="{$tablepartyStyle}">
            <tr>
              <td class="{$secondColStyle}">
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                  <xsl:value-of select="./entityName"/>
                  <xsl:value-of select="."/>
                </a>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="userId" mode="party">
    <xsl:param name="useridDirectory1" select="$useridDirectory1"/>
    <xsl:param name="useridDirectoryApp1_URI" select="$useridDirectoryApp1_URI"/>
    <xsl:param name="useridDirectoryLabel1" select="$useridDirectoryLabel1"/>
    <xsl:param name="partyfirstColStyle"/>
    <xsl:choose>
      <xsl:when test="@directory = $useridDirectory1">
        <xsl:if test="normalize-space(.) != ''">
          <tr>
            <td class="{$partyfirstColStyle}"> Profile:</td>
            <td class="{$secondColStyle}">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="$useridDirectoryApp1_URI"/>
                  <xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:value-of select="$useridDirectoryLabel1"/>
                <xsl:text> Profile for </xsl:text>
                <xsl:value-of select="../individualName/surName"/>
              </xsl:element>
            </td>
          </tr>
        </xsl:if>
      </xsl:when>
      <xsl:when test="@directory = 'LTERnetwork-directory'">
        <!-- finish when lter dir available by ID.
            <xsl:if test="normalize-space(.)!=''">
              <tr><td class="{$partyfirstColStyle}" >
                Link to Profile:</td><td class="{$secondColStyle}">
                  <xsl:value-of select="."/>LTER Network Personnel Directory</td></tr>
            </xsl:if>
            -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="normalize-space(.) != ''">
          <tr>
            <td class="{$partyfirstColStyle}"> Id:</td>
            <td class="{$secondColStyle}">
              <xsl:value-of select="."/>
            </td>
          </tr>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="role" mode="party">
    <!-- mob added 2014, web3 -->
    <xsl:param name="partyfirstColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$partyfirstColStyle}"> Role:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="text()" mode="party"/>
  <!--
       ********************************************************
             adding PHSYICAL templates 
       ********************************************************
         -->
  <xsl:template name="physical">
    <xsl:param name="docid"/>
    <xsl:param name="level">entity</xsl:param>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="physicalindex"/>
    <xsl:param name="distributionindex"/>
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:param name="notshowdistribution"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="physicalcommon">
              <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
              <xsl:with-param name="notshowdistribution" select="$notshowdistribution"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="physicalcommon">
            <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
            <xsl:with-param name="notshowdistribution" select="$notshowdistribution"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="physicalcommon">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:param name="notshowdistribution"/>
    <xsl:param name="docid"/>
    <xsl:param name="level">entity</xsl:param>
    <xsl:param name="entitytype"/>
    <xsl:param name="entityindex"/>
    <xsl:param name="physicalindex"/>
    <xsl:param name="distributionindex"/>
    <xsl:call-template name="physicalobjectName">
      <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="physicalsize">
      <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="physicalauthentication">
      <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="physicalcompressionMethod">
      <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="physicalencodingMethod">
      <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="physicalcharacterEncoding">
      <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="physicaltextFormat">
      <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="physicalexternallyDefinedFormat">
      <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="physicalbinaryRasterFormat">
      <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
    </xsl:call-template>
    <xsl:if test="$notshowdistribution = ''">
      <xsl:for-each select="distribution">
        <xsl:call-template name="distribution">
          <xsl:with-param name="disfirstColStyle" select="$physicalfirstColStyle"/>
          <xsl:with-param name="dissubHeaderStyle" select="$subHeaderStyle"/>
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="level">entitylevel</xsl:with-param>
          <xsl:with-param name="entitytype" select="$entitytype"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
          <xsl:with-param name="physicalindex" select="$physicalindex"/>
          <xsl:with-param name="distributionindex" select="position()"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name="physicalobjectName">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:for-each select="objectName">
      <tr>
        <td class="{$physicalfirstColStyle}"> Object Name:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="physicalsize">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:for-each select="size">
      <tr>
        <td class="{$physicalfirstColStyle}"> Size:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
          <xsl:text/>
          <xsl:value-of select="./@unit"/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="physicalauthentication">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:for-each select="authentication">
      <tr>
        <td class="{$physicalfirstColStyle}"> Authentication:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
          <xsl:text/>
          <xsl:if test="./@method"> Caculated By<xsl:text/><xsl:value-of select="./@method"
            /></xsl:if>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="physicalcompressionMethod">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:for-each select="compressionMethod">
      <tr>
        <td class="{$physicalfirstColStyle}"> Compression Method:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="physicalencodingMethod">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:for-each select="encodingMethod">
      <tr>
        <td class="{$physicalfirstColStyle}"> Encoding Method:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="physicalcharacterEncoding">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:for-each select="characterEncoding">
      <tr>
        <td class="{$physicalfirstColStyle}"> Character Encoding:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="physicaltextFormat">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:for-each select="dataFormat/textFormat">
      <tr>
        <td class="{$physicalfirstColStyle}"> Text Format:</td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:apply-templates>
              <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
            </xsl:apply-templates>
          </table>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="numHeaderLines">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Number of Header Lines:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="numFooterLines">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Number of Footer Lines:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="recordDelimiter">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Record Delimiter:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="physicalLineDelimiter">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Line Delimiter:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="numPhysicalLinesPerRecord">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Line Number For One Record:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="maxRecordLength">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Maximum Record Length:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="attributeOrientation">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Orientation:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="simpleDelimited">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Simple Delimited:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:apply-templates>
            <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
          </xsl:apply-templates>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="complex">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Complex Delimited:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:call-template name="textFixed">
            <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
          </xsl:call-template>
          <xsl:call-template name="textDelimited">
            <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
          </xsl:call-template>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="textFixed">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Text Fixed:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:apply-templates>
            <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
          </xsl:apply-templates>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="textDelimited">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Text Delimited:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <xsl:apply-templates>
            <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
          </xsl:apply-templates>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="quoteCharacter">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Quote Character:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="literalCharacter">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Literal Character:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="collapseDelimiters">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Collapse Delimiters:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="fieldDelimiter">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Field Delimiter:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="fieldWidth">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Field Width:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="lineNumber">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Line Number:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="fieldStartColumn">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Field Start Column:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="physicalexternallyDefinedFormat">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:for-each select="dataFormat/externallyDefinedFormat">
      <tr>
        <td class="{$physicalfirstColStyle}"> Externally Defined Format:</td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:apply-templates>
              <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
            </xsl:apply-templates>
          </table>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="formatName">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$firstColStyle}">Format Name:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="formatVersion">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Format Version:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="citation">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$physicalfirstColStyle}">Citation: </td>
      <td>
        <xsl:call-template name="citation">
          <xsl:with-param name="citationfirstColStyle" select="$physicalfirstColStyle"/>
          <xsl:with-param name="citationsubHeaderStyle" select="$subHeaderStyle"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="physicalbinaryRasterFormat">
    <xsl:param name="physicalfirstColStyle"/>
    <xsl:for-each select="dataFormat/binaryRasterFormat">
      <tr>
        <td class="{$physicalfirstColStyle}"> Binary Raster Format:</td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:apply-templates>
              <xsl:with-param name="physicalfirstColStyle" select="$physicalfirstColStyle"/>
            </xsl:apply-templates>
          </table>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="rowColumnOrientation">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Orientation:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="multiBand">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Multiple Bands:</td>
      <td>
        <table class="{$tabledefaultStyle}">
          <tr>
            <td class="{$firstColStyle}">Number of Spectral Bands:</td>
            <td class="{$secondColStyle}">
              <xsl:value-of select="./nbands"/>
            </td>
          </tr>
          <tr>
            <td class="{$firstColStyle}">Layout:</td>
            <td class="{$secondColStyle}">
              <xsl:value-of select="./layout"/>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="nbits">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Number of Bits (/pixel/band):</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="byteorder">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Byte Order:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="skipbytes">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Skipped Bytes:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="bandrowbytes">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Number of Bytes (/band/row):</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="totalrowbytes">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Total Number of Byte (/row):</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="bandgapbytes">
    <xsl:param name="physicalfirstColStyle"/>
    <tr>
      <td class="{$firstColStyle}">Number of Bytes between Bands:</td>
      <td class="{$secondColStyle}">
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding PROJECT templates 
       ********************************************************
         -->
  <xsl:template name="project">
    <xsl:param name="projectfirstColStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="projectcommon">
              <xsl:with-param name="projectfirstColStyle" select="$projectfirstColStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="projectcommon">
            <xsl:with-param name="projectfirstColStyle" select="$projectfirstColStyle"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="projectcommon">
    <xsl:param name="projectfirstColStyle"/>
    <xsl:call-template name="projecttitle">
      <xsl:with-param name="projectfirstColStyle" select="$projectfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="projectpersonnel">
      <xsl:with-param name="projectfirstColStyle" select="$projectfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="projectabstract">
      <xsl:with-param name="projectfirstColStyle" select="$projectfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="projectfunding">
      <xsl:with-param name="projectfirstColStyle" select="$projectfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="projectstudyareadescription">
      <xsl:with-param name="projectfirstColStyle" select="$projectfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="projectdesigndescription">
      <xsl:with-param name="projectfirstColStyle" select="$projectfirstColStyle"/>
    </xsl:call-template>
    <xsl:call-template name="projectrelatedproject">
      <xsl:with-param name="projectfirstColStyle" select="$projectfirstColStyle"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="projecttitle">
    <xsl:param name="projectfirstColStyle"/>
    <xsl:for-each select="title">
      <tr>
        <td class="{$projectfirstColStyle}"> Title: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="../title"/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="projectpersonnel">
    <xsl:param name="projectfirstColStyle"/>
    <tr>
      <td class="{$projectfirstColStyle}"> Personnel: </td>
      <td>
        <table>
          <xsl:for-each select="personnel">
            <tr>
              <td colspan="2">
                <xsl:call-template name="party">
                  <xsl:with-param name="partyfirstColStyle" select="$projectfirstColStyle"/>
                </xsl:call-template>
              </td>
            </tr>
            <xsl:for-each select="role">
              <tr>
                <td class="{$projectfirstColStyle}"> Role: </td>
                <td>
                  <table class="{$tablepartyStyle}">
                    <tr>
                      <td class="{$secondColStyle}">
                        <xsl:value-of select="."/>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="projectabstract">
    <xsl:param name="projectfirstColStyle"/>
    <xsl:for-each select="abstract">
      <tr>
        <td class="{$projectfirstColStyle}"> Abstract: </td>
        <td>
          <xsl:call-template name="text">
            <xsl:with-param name="textfirstColStyle" select="$projectfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="projectfunding">
    <xsl:param name="projectfirstColStyle"/>
    <xsl:for-each select="funding">
      <tr>
        <td class="{$projectfirstColStyle}"> Funding: </td>
        <td>
          <xsl:call-template name="text">
            <xsl:with-param name="textfirstColStyle" select="$projectfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="projectstudyareadescription">
    <xsl:param name="projectfirstColStyle"/>
    <xsl:for-each select="studyAreaDescription">
      <tr>
        <td class="{$projectfirstColStyle}">
          <xsl:text>Study Area:</xsl:text>
        </td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:for-each select="descriptor">
              <xsl:for-each select="descriptorValue">
                <tr>
                  <td class="{$projectfirstColStyle}">
                    <xsl:value-of select="../@name"/>
                  </td>
                  <td class="{$secondColStyle}">
                    <xsl:choose>
                      <xsl:when test="./@citableClassificationSystem"><xsl:value-of select="."
                          /> <xsl:value-of select="./@name_or_id"/></xsl:when>
                      <xsl:otherwise><xsl:value-of select="."/> <xsl:value-of select="./@name_or_id"
                        /> (No Citable Classification System) </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </xsl:for-each>
              <xsl:for-each select="citation">
                <tr>
                  <td class="{$projectfirstColStyle}"> Citation: </td>
                  <td>
                    <xsl:call-template name="citation">
                      <xsl:with-param name="citationfirstColStyle" select="projectfirstColStyle"/>
                    </xsl:call-template>
                  </td>
                </tr>
              </xsl:for-each>
            </xsl:for-each>
          </table>
        </td>
      </tr>
      <xsl:for-each select="citation">
        <tr>
          <td class="{$projectfirstColStyle}"> Study Area Citation: </td>
          <td>
            <xsl:call-template name="citation">
              <xsl:with-param name="citationfirstColStyle" select="projectfirstColStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="coverage">
        <tr>
          <td class="{$projectfirstColStyle}"> Study Area Coverage: </td>
          <td>
            <xsl:call-template name="coverage"/>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="projectdesigndescription">
    <xsl:param name="projectfirstColStyle"/>
    <xsl:for-each select="designDescription">
      <xsl:for-each select="description">
        <tr>
          <td class="{$projectfirstColStyle}"> Design Description: </td>
          <td>
            <xsl:call-template name="text"/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="citation">
        <tr>
          <td class="{$projectfirstColStyle}"> Design Citation: </td>
          <td>
            <xsl:call-template name="citation"/>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="projectrelatedproject">
    <xsl:param name="projectfirstColStyle"/>
    <xsl:for-each select="relatedProject">
      <tr>
        <td class="{$projectfirstColStyle}"> Related Project: </td>
        <td>
          <xsl:call-template name="project">
            <xsl:with-param name="projectfirstColStyle" select="$projectfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <!--
       ********************************************************
             adding PROTOCOL templates 
       ********************************************************
         -->
  <xsl:template name="protocol">
    <xsl:param name="protocolfirstColStyle"/>
    <xsl:param name="protocolsubHeaderStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="protocolcommon">
              <xsl:with-param name="protocolfirstColStyle" select="$protocolfirstColStyle"/>
              <xsl:with-param name="protocolsubHeaderStyle" select="$protocolsubHeaderStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="protocolcommon">
            <xsl:with-param name="protocolfirstColStyle" select="$protocolfirstColStyle"/>
            <xsl:with-param name="protocolsubHeaderStyle" select="$protocolsubHeaderStyle"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="protocolcommon">
    <xsl:param name="protocolfirstColStyle"/>
    <xsl:param name="protocolsubHeaderStyle"/>
    <!-- template for protocol shows minimum elements (author, title, dist) -->
    <xsl:call-template name="protocol_simple">
      <xsl:with-param name="protocolfirstColStyle" select="$protocolfirstColStyle"/>
      <xsl:with-param name="protocolsubHeaderStyle" select="$protocolsubHeaderStyle"/>
    </xsl:call-template>
    <xsl:for-each select="proceduralStep">
      <tr>
        <td colspan="2" class="{$protocolsubHeaderStyle}"> Step<xsl:text/><xsl:value-of
            select="position()"/>: </td>
      </tr>
      <xsl:call-template name="step">
        <xsl:with-param name="protocolfirstColStyle" select="$protocolfirstColStyle"/>
        <xsl:with-param name="protocolsubHeaderStyle" select="$protocolsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:call-template name="protocolAccess">
      <xsl:with-param name="protocolfirstColStyle" select="$protocolfirstColStyle"/>
      <xsl:with-param name="protocolsubHeaderStyle" select="$protocolsubHeaderStyle"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="protocol_simple">
    <xsl:param name="protocolfirstColStyle"/>
    <xsl:param name="protocolsubHeaderStyle"/>
    <!--	<table class="{$tabledefaultStyle}">  -->
    <xsl:for-each select="creator/individualName/surName">
      <tr>
        <td class="{$protocolfirstColStyle}">
          <xsl:text>Author: </xsl:text>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="title">
      <tr>
        <td class="{$protocolfirstColStyle}">
          <xsl:text>Title: </xsl:text>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="distribution">
      <!--<tr>
        <td>
         the template 'distribution' in eml2-distribution.xsl. seems to be for
				data tables. use the resourcedistribution template instead (eml2-resource.xsl)  -->
      <xsl:call-template name="resourcedistribution">
        <xsl:with-param name="resfirstColStyle" select="$protocolfirstColStyle"/>
        <xsl:with-param name="ressubHeaderStyle" select="$protocolsubHeaderStyle"/>
      </xsl:call-template>
      <!-- </td>
      </tr>  -->
    </xsl:for-each>
    <!-- </table> -->
  </xsl:template>
  <xsl:template name="step">
    <xsl:param name="protocolfirstColStyle"/>
    <xsl:param name="protocolsubHeaderStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:for-each select="description">
        <tr>
          <td class="{$protocolfirstColStyle}"> Description: </td>
          <td>
            <xsl:call-template name="text">
              <xsl:with-param name="textfirstColStyle" select="$protocolfirstColStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="citation">
        <tr>
          <td class="{$protocolfirstColStyle}"> Citation: </td>
          <td class="{$secondColStyle}">   </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="citation">
              <xsl:with-param name="citationfirstColStyle" select="$protocolfirstColStyle"/>
              <xsl:with-param name="citationsubHeaderStyle" select="$protocolsubHeaderStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="protocol">
        <tr>
          <td class="{$protocolfirstColStyle}"> Protocol: </td>
          <td class="{$secondColStyle}">
            <!-- mob nested this table in col2, instead of new row. -->
            <xsl:call-template name="protocol">
              <xsl:with-param name="protocolfirstColStyle" select="$protocolfirstColStyle"/>
              <xsl:with-param name="protocolsubHeaderStyle" select="$protocolsubHeaderStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="instrumentation">
        <tr>
          <td class="{$protocolfirstColStyle}"> Instrument(s): </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="software">
        <tr>
          <td colspan="2">
            <xsl:call-template name="software">
              <xsl:with-param name="softwarefirstColStyle" select="$protocolfirstColStyle"/>
              <xsl:with-param name="softwaresubHeaderStyle" select="$protocolsubHeaderStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="subStep">
        <tr>
          <td class="{$protocolfirstColStyle}"> Substep<xsl:text/><xsl:value-of select="position()"
            /></td>
          <td class="{$secondColStyle}">   </td>
          <td>
            <!-- correct? was outside of table -->
            <xsl:call-template name="step">
              <xsl:with-param name="protocolfirstColStyle" select="$protocolfirstColStyle"/>
              <xsl:with-param name="protocolsubHeaderStyle" select="$protocolsubHeaderStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <!-- matches table at start of step -->
  </xsl:template>
  <xsl:template name="protocolAccess">
    <xsl:param name="protocolfirstColStyle"/>
    <xsl:param name="protocolsubHeaderStyle"/>
    <xsl:for-each select="access">
      <tr>
        <td colspan="2">
          <xsl:call-template name="access">
            <xsl:with-param name="accessfirstColStyle" select="$protocolfirstColStyle"/>
            <xsl:with-param name="accesssubHeaderStyle" select="$protocolsubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <!--
       ********************************************************
             adding RESOURCE templates 
       ********************************************************
         -->
  <xsl:template name="resource">
    <xsl:param name="resfirstColStyle"/>
    <xsl:param name="ressubHeaderStyle"/>
    <xsl:param name="creator">Data Set Owner(s):</xsl:param>
    <!--
      <xsl:for-each select="alternateIdentifier">
        <xsl:call-template name="resourcealternateIdentifier">
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:for-each select="shortName">
        <xsl:call-template name="resourceshortName">
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
         </xsl:call-template>
      </xsl:for-each>

      <xsl:for-each select="title">
        <xsl:call-template name="resourcetitle">
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
          <xsl:with-param name="ressubHeaderStyle" select="$ressubHeaderStyle"/>
        </xsl:call-template>
      </xsl:for-each>

       <xsl:for-each select="pubDate">
        <xsl:call-template name="resourcepubDate" >
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
         </xsl:call-template>
      </xsl:for-each>

      <xsl:for-each select="language">
        <xsl:call-template name="resourcelanguage" >
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
         </xsl:call-template>
      </xsl:for-each>

      <xsl:for-each select="series">
        <xsl:call-template name="resourceseries" >
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:if test="creator">
        <tr>
          <td class="{$ressubHeaderStyle}" colspan="2">
            <h3><xsl:value-of select="$creator"/></h3>
          </td>
        </tr>
      </xsl:if>
      <xsl:for-each select="creator">
        <xsl:call-template name="resourcecreator">
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:if test="metadataProvider">
        <tr><td class="{$ressubHeaderStyle}" colspan="2">
        <xsl:text>Metadata Provider(s):</xsl:text>
      </td></tr>
      </xsl:if>
       <xsl:for-each select="metadataProvider">
        <xsl:call-template name="resourcemetadataProvider">
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:if test="associatedParty">
        <tr>
          <td class="{$ressubHeaderStyle}" colspan="2">
            <h3><xsl:text>Associated Parties:</xsl:text></h3>
          </td>
        </tr>
      </xsl:if>
      <xsl:for-each select="associatedParty">
        <xsl:call-template name="resourceassociatedParty">
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:for-each select="abstract">
        <xsl:call-template name="resourceabstract" >
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
          <xsl:with-param name="ressubHeaderStyle" select="$ressubHeaderStyle"/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:if test="keywordSet">
        <tr><td class="{$ressubHeaderStyle}" colspan="2">
             <xsl:text>Keywords:</xsl:text></td></tr>
      </xsl:if>
      <xsl:for-each select="keywordSet">
        <xsl:call-template name="resourcekeywordSet" >
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:for-each select="additionalInfo">
        <xsl:call-template name="resourceadditionalInfo" >
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
          <xsl:with-param name="ressubHeaderStyle" select="$ressubHeaderStyle"/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:for-each select="intellectualRights">
        <xsl:call-template name="resourceintellectualRights" >
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
          <xsl:with-param name="ressubHeaderStyle" select="$ressubHeaderStyle"/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:for-each select="distribution">
        <xsl:call-template name="resourcedistribution">
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
          <xsl:with-param name="ressubHeaderStyle" select="$ressubHeaderStyle"/>

	 <xsl:with-param name="index" select="position()"/>
          <xsl:with-param name="docid" select="$docid"/>
        </xsl:call-template>
      </xsl:for-each>

    <xsl:for-each select="coverage">
      <xsl:call-template name="resourcecoverage">
          <xsl:with-param name="resfirstColStyle" select="$resfirstColStyle"/>
          <xsl:with-param name="ressubHeaderStyle" select="$ressubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    -->
  </xsl:template>
  <xsl:template name="resourcealternateIdentifier">
    <xsl:param name="resfirstColStyle"/>
    <xsl:param name="ressecondColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$resfirstColStyle}">Alternate Identifier:</td>
        <td class="{$ressecondColStyle}">
          <xsl:choose>
            <xsl:when test="contains(@system, 'doi')">DOI: </xsl:when>
          </xsl:choose>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="resourceshortName">
    <xsl:param name="resfirstColStyle"/>
    <xsl:param name="ressecondColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$resfirstColStyle}">Short Name:</td>
        <td class="{$ressecondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="resourcetitle">
    <xsl:param name="resfirstColStyle"/>
    <xsl:param name="ressecondColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$resfirstColStyle}">Title:</td>
        <td class="{$ressecondColStyle}">
          <em class="bold">
            <xsl:value-of select="."/>
          </em>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="resourcecreator">
    <xsl:param name="resfirstColStyle"/>
    <tr>
      <td colspan="2">
        <xsl:call-template name="party">
          <xsl:with-param name="partyfirstColStyle" select="$resfirstColStyle"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="resourcemetadataProvider">
    <xsl:param name="resfirstColStyle"/>
    <tr>
      <td colspan="2">
        <xsl:call-template name="party">
          <xsl:with-param name="partyfirstColStyle" select="$resfirstColStyle"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="resourceassociatedParty">
    <xsl:param name="resfirstColStyle"/>
    <tr>
      <td colspan="2">
        <xsl:call-template name="party">
          <xsl:with-param name="partyfirstColStyle" select="$resfirstColStyle"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="resourcepubDate">
    <xsl:param name="resfirstColStyle"/>
    <xsl:if test="normalize-space(../pubDate) != ''">
      <tr>
        <td class="{$resfirstColStyle}"> Publication Date:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="../pubDate"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="resourcelanguage">
    <xsl:param name="resfirstColStyle"/>
    <xsl:if test="normalize-space(.) != ''">
      <tr>
        <td class="{$resfirstColStyle}"> Language:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="resourceseries">
    <xsl:param name="resfirstColStyle"/>
    <xsl:if test="normalize-space(../series) != ''">
      <tr>
        <td class="{$resfirstColStyle}"> Series:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="../series"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="resourceabstract">
    <xsl:param name="resfirstColStyle"/>
    <xsl:param name="ressecondColStyle"/>
    <tr>
      <td class="{$resfirstColStyle}">
        <xsl:text>Abstract:</xsl:text>
      </td>
      <td>
        <xsl:call-template name="abstracttext">
          <xsl:with-param name="textfirstColStyle" select="$resfirstColStyle"/>
          <xsl:with-param name="textsecondColStyle" select="$ressecondColStyle"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="resourcekeywordSet">
    <xsl:for-each select="keywordThesaurus">
      <!--
	 <xsl:if test="normalize-space(.)!=''">
          <xsl:value-of select="."/>
          <xsl:text>: </xsl:text>
        </xsl:if>
-->
      <xsl:if test="normalize-space(keyword) != ''">
        <ul>
          <xsl:for-each select="keyword">
            <li>
              <xsl:value-of select="."/>
              <!--
            <xsl:if test="./@keywordType and normalize-space(./@keywordType)!=''">
              (<xsl:value-of select="./@keywordType"/>)
            </xsl:if>
-->
            </li>
          </xsl:for-each>
        </ul>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="normalize-space(keyword) != ''">
      <ul>
        <xsl:for-each select="keyword">
          <li>
            <xsl:value-of select="."/>
            <!--            <xsl:if test="./@keywordType and normalize-space(./@keywordType)!=''">
              (<xsl:value-of select="./@keywordType"/>)
            </xsl:if>
-->
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>
  <xsl:template name="resourcekeywordsAsPara">
    <xsl:if test="normalize-space(keyword) != ''">
      <xsl:for-each select="keyword">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <!-- don't print the icky-looking attribute!            
              <xsl:if test="./@keywordType and normalize-space(./@keywordType)!=''">
              (<xsl:value-of select="./@keywordType"/>)
              </xsl:if>
            -->
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name="resourceadditionalInfo">
    <xsl:param name="ressubHeaderStyle"/>
    <xsl:param name="resfirstColStyle"/>
    <tr>
      <td class="{$ressubHeaderStyle}" colspan="2">
        <xsl:text>Additional Information:</xsl:text>
      </td>
    </tr>
    <tr>
      <td class="{$resfirstColStyle}"> </td>
      <td>
        <xsl:call-template name="text">
          <xsl:with-param name="textfirstColStyle" select="$resfirstColStyle"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="resourceintellectualRights">
    <xsl:param name="resfirstColStyle"/>
    <xsl:param name="ressecondColStyle"/>
    <xsl:call-template name="text">
      <xsl:with-param name="textsecondColStyle" select="$ressecondColStyle"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="resourcedistribution">
    <xsl:param name="ressubHeaderStyle"/>
    <xsl:param name="resfirstColStyle"/>
    <xsl:param name="index"/>
    <xsl:param name="docid"/>
    <tr>
      <td colspan="2">
        <xsl:call-template name="distribution">
          <xsl:with-param name="disfirstColStyle" select="$resfirstColStyle"/>
          <xsl:with-param name="dissubHeaderStyle" select="$ressubHeaderStyle"/>
          <xsl:with-param name="level">toplevel</xsl:with-param>
          <xsl:with-param name="distributionindex" select="$index"/>
          <xsl:with-param name="docid" select="$docid"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="resourcecoverage">
    <xsl:param name="ressubHeaderStyle"/>
    <xsl:param name="resfirstColStyle"/>
    <tr>
      <td colspan="2">
        <xsl:call-template name="coverage"/>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding SOFTWARE templates 
       ********************************************************
         -->
  <xsl:template name="software">
    <xsl:param name="softwarefirstColStyle"/>
    <xsl:param name="softwaresubHeaderStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="softwarecommon">
              <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
              <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="softwarecommon">
            <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
            <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="softwarecommon">
    <xsl:param name="softwarefirstColStyle"/>
    <xsl:param name="softwaresubHeaderStyle"/>
    <tr>
      <td class="{$softwaresubHeaderStyle}" colspan="2">
        <xsl:text>Software:</xsl:text>
      </td>
    </tr>
    <xsl:call-template name="resource">
      <xsl:with-param name="resfirstColStyle" select="$softwarefirstColStyle"/>
      <xsl:with-param name="ressubHeaderStyle" select="$softwaresubHeaderStyle"/>
      <xsl:with-param name="creator">Author(s):</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="implementation">
      <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
      <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
    </xsl:call-template>
    <xsl:for-each select="dependency">
      <tr>
        <td class="{$softwarefirstColStyle}"> Dependency </td>
        <td class="{$secondColStyle}">   </td>
      </tr>
      <xsl:call-template name="dependency">
        <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
        <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:call-template name="licenseURL">
      <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
      <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
    </xsl:call-template>
    <xsl:call-template name="license">
      <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
      <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
    </xsl:call-template>
    <xsl:call-template name="version">
      <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
      <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
    </xsl:call-template>
    <xsl:call-template name="softwareAccess">
      <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
      <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
    </xsl:call-template>
    <xsl:call-template name="softwareProject">
      <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
      <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="implementation">
    <xsl:param name="softwarefirstColStyle"/>
    <xsl:param name="softwaresubHeaderStyle"/>
    <xsl:for-each select="implementation">
      <tr>
        <td colspan="2" class="{$softwaresubHeaderStyle}"> Implementation Info: </td>
      </tr>
      <xsl:for-each select="distribution">
        <tr>
          <td class="{$softwarefirstColStyle}"> Distribution: </td>
          <td>
            <xsl:call-template name="distribution">
              <xsl:with-param name="disfirstColStyle" select="$softwarefirstColStyle"/>
              <xsl:with-param name="dissubHeaderStyle" select="$softwaresubHeaderStyle"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="size">
        <tr>
          <td class="{$softwarefirstColStyle}"> Size: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="language">
        <tr>
          <td class="{$softwarefirstColStyle}"> Language: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="LanguageValue"/>
          </td>
        </tr>
        <xsl:if test="LanguageCodeStandard">
          <tr>
            <td class="{$softwarefirstColStyle}"> Language Code Standard: </td>
            <td class="{$secondColStyle}">
              <xsl:value-of select="LanguageValue"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="operatingSystem">
        <tr>
          <td class="{$softwarefirstColStyle}"> Operating System: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="machineProcessor">
        <tr>
          <td class="{$softwarefirstColStyle}"> Operating System: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="virtualMachine">
        <tr>
          <td class="{$softwarefirstColStyle}"> Virtual Machine: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="diskUsage">
        <tr>
          <td class="{$softwarefirstColStyle}"> Disk Usage: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="runtimeMemoryUsage">
        <tr>
          <td class="{$softwarefirstColStyle}"> Run Time Memory Usage: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="programmingLanguage">
        <tr>
          <td class="{$softwarefirstColStyle}"> Programming Language: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="checksum">
        <tr>
          <td class="{$softwarefirstColStyle}"> Check Sum: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="dependency">
        <tr>
          <td class="{$softwarefirstColStyle}"> Dependency: </td>
          <td class="{$secondColStyle}">   </td>
        </tr>
        <xsl:call-template name="dependency">
          <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
          <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="dependency">
    <xsl:param name="softwarefirstColStyle"/>
    <xsl:param name="softwaresubHeaderStyle"/>
    <xsl:for-each select="../dependency">
      <tr>
        <td class="{$softwarefirstColStyle}">
          <b>
            <xsl:value-of select="action"/>
          </b>
          <xsl:text> Depend on</xsl:text>
        </td>
        <td>
          <xsl:for-each select="software">
            <xsl:call-template name="software">
              <xsl:with-param name="softwarefirstColStyle" select="$softwarefirstColStyle"/>
              <xsl:with-param name="softwaresubHeaderStyle" select="$softwaresubHeaderStyle"/>
            </xsl:call-template>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="version">
    <xsl:param name="softwarefirstColStyle"/>
    <xsl:for-each select="version">
      <tr>
        <td class="{$firstColStyle}"> Version Number:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="licenseURL">
    <xsl:param name="softwarefirstColStyle"/>
    <xsl:for-each select="licenseURL">
      <tr>
        <td class="{$firstColStyle}"> License URL:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="license">
    <xsl:param name="softwarefirstColStyle"/>
    <xsl:for-each select="license">
      <tr>
        <td class="{$firstColStyle}"> License:</td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="softwareAccess">
    <xsl:param name="softwarefirstColStyle"/>
    <xsl:param name="softwaresubHeaderStyle"/>
    <xsl:for-each select="access">
      <tr>
        <td colspan="2">
          <xsl:call-template name="access">
            <xsl:with-param name="accessfirstColStyle" select="$softwarefirstColStyle"/>
            <xsl:with-param name="accesssubHeaderStyle" select="$softwaresubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="softwareProject">
    <xsl:param name="softwarefirstColStyle"/>
    <xsl:param name="softwaresubHeaderStyle"/>
    <xsl:for-each select="project">
      <tr>
        <td class="{$softwaresubHeaderStyle}" colspan="2">
          <xsl:text>Project Info:</xsl:text>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <xsl:call-template name="project">
            <xsl:with-param name="projectfirstColStyle" select="$softwarefirstColStyle"/>
            <xsl:with-param name="projectsubHeaderStyle" select="$softwaresubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <!--
       ********************************************************
             adding SPATIAL RASTER templates 
       ********************************************************
         -->
  <xsl:template name="spatialRaster">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <xsl:param name="spatialrastersubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entityindex"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="spatialRastercommon">
              <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
              <xsl:with-param name="spatialrastersubHeaderStyle"
                select="$spatialrastersubHeaderStyle"/>
              <xsl:with-param name="docid" select="$docid"/>
              <xsl:with-param name="entityindex" select="$entityindex"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="spatialRastercommon">
            <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
            <xsl:with-param name="spatialrastersubHeaderStyle" select="$spatialrastersubHeaderStyle"/>
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="spatialRastercommon">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <xsl:param name="spatialrastersubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entityindex"/>
    <xsl:for-each select="entityName">
      <xsl:call-template name="entityName">
        <xsl:with-param name="entityfirstColStyle" select="$spatialrasterfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="alternateIdentifier">
      <xsl:call-template name="entityalternateIdentifier">
        <xsl:with-param name="entityfirstColStyle" select="$spatialrasterfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="entityDescription">
      <xsl:call-template name="entityDescription">
        <xsl:with-param name="entityfirstColStyle" select="$spatialrasterfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="additionalInfo">
      <xsl:call-template name="entityadditionalInfo">
        <xsl:with-param name="entityfirstColStyle" select="$spatialrasterfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- call physical moduel without show distribution(we want see it later)-->
    <xsl:if test="physical">
      <tr>
        <td class="{$spatialrastersubHeaderStyle}" colspan="2"> Physical Structure Description:
        </td>
      </tr>
      <xsl:for-each select="physical">
        <tr>
          <td colspan="2">
            <xsl:call-template name="physical">
              <xsl:with-param name="physicalfirstColStyle" select="$spatialrasterfirstColStyle"/>
              <xsl:with-param name="notshowdistribution">yes</xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="coverage">
      <tr>
        <td class="{$spatialrastersubHeaderStyle}" colspan="2"> Coverage Description: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="coverage">
      <tr>
        <td colspan="2">
          <xsl:call-template name="coverage"/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="method">
      <tr>
        <td class="{$spatialrastersubHeaderStyle}" colspan="2"> Method Description: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="method">
      <tr>
        <td colspan="2">
          <xsl:call-template name="method">
            <xsl:with-param name="methodfirstColStyle" select="$spatialrasterfirstColStyle"/>
            <xsl:with-param name="methodsubHeaderStyle" select="$spatialrastersubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="constraint">
      <tr>
        <td class="{$spatialrastersubHeaderStyle}" colspan="2"> Constraint: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="constraint">
      <tr>
        <td colspan="2">
          <xsl:call-template name="constraint">
            <xsl:with-param name="constraintfirstColStyle" select="$spatialrasterfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="spatialReference">
      <tr>
        <td class="{$spatialrastersubHeaderStyle}" colspan="2"> Spatial Reference: </td>
      </tr>
      <xsl:call-template name="spatialReference">
        <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="georeferenceInfo">
      <tr>
        <td class="{$spatialrastersubHeaderStyle}" colspan="2"> Grid Postion: </td>
      </tr>
      <xsl:call-template name="georeferenceInfo">
        <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="horizontalAccuracy">
      <tr>
        <td class="{$spatialrastersubHeaderStyle}" colspan="2"> Horizontal Accuracy: </td>
      </tr>
      <xsl:call-template name="dataQuality">
        <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="verticalAccuracy">
      <tr>
        <td class="{$spatialrastersubHeaderStyle}" colspan="2"> Vertical Accuracy: </td>
      </tr>
      <xsl:call-template name="dataQuality">
        <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="cellSizeXDirection">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Cell Size(X): </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="cellSizeYDirection">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Cell Size(Y): </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="numberOfBands">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Number of Bands: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="rasterOrigin">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Origin: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="columns">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Max Raster Objects(X): </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="rows">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Max Raster Objects(Y): </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="verticals">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Max Raster Objects(Z): </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="cellGeometry">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Cell Geometry: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="toneGradation">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Number of Colors: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="scaleFactor">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Scale Factor: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="offset">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Offset: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="imageDescription">
      <tr>
        <td class="{$spatialrastersubHeaderStyle}" colspan="2"> Image Info: </td>
      </tr>
      <xsl:call-template name="imageDescription">
        <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="$withAttributes = '1'">
      <xsl:for-each select="attributeList">
        <xsl:call-template name="spatialRasterAttributeList">
          <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
          <xsl:with-param name="spatialrastersubHeaderStyle" select="$spatialrastersubHeaderStyle"/>
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
    <!-- Here to display distribution info-->
    <xsl:for-each select="physical">
      <xsl:call-template name="spatialRasterShowDistribution">
        <xsl:with-param name="docid" select="$docid"/>
        <xsl:with-param name="entityindex" select="$entityindex"/>
        <xsl:with-param name="physicalindex" select="position()"/>
        <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
        <xsl:with-param name="spatialrastersubHeaderStyle" select="$spatialrastersubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="spatialReference">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <xsl:choose>
      <xsl:when test="references != ''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
        <xsl:for-each select="$references">
          <xsl:call-template name="spatialReferenceCommon">
            <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="spatialReferenceCommon">
          <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="spatialReferenceCommon">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <xsl:for-each select="horizCoordSysName">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Name of Coordinate System: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="horizCoordSysDef/geogCoordSys">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Definition of <xsl:text/><xsl:value-of
            select="../@name"/><xsl:text/> (Geographic Coordinate System): </td>
        <td>
          <xsl:call-template name="geogCoordSysType">
            <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="horizCoordSysDef/projCoordSys">
      <xsl:for-each select="geogCoordSys">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> Definition of<xsl:text/><xsl:value-of
              select="../../@name"/><xsl:text/>(Geographic Coordinate System): </td>
          <td>
            <xsl:call-template name="geogCoordSysType">
              <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"
              />
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="projection">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> Projection in Geo Coord. System: </td>
          <td>
            <table class="{$tabledefaultStyle}">
              <xsl:for-each select="parameter">
                <tr>
                  <td class="{$spatialrasterfirstColStyle}"><xsl:value-of select="./@name"/>: </td>
                  <td>
                    <table class="{$tabledefaultStyle}">
                      <tr>
                        <td class="{$secondColStyle}">
                          <xsl:value-of select="./@value"/>
                        </td>
                        <td class="{$secondColStyle}">
                          <xsl:value-of select="./@description"/>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </xsl:for-each>
              <xsl:for-each select="unit">
                <tr>
                  <td class="{$spatialrasterfirstColStyle}"> Unit: </td>
                  <td class="{$secondColStyle}">
                    <xsl:value-of select="./@name"/>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:for-each select="vertCoordSys/altitudeSysDef">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Altitude System Definition: </td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:for-each select="altitudeDatumName">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Datum: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="altitudeResolution">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Resolution: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="altitudeDistanceUnits">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Distance Unit: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="altitudeEncodingMethod">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Encoding Method: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="vertCoordSys/depthSysDef">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Depth System Definition: </td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:for-each select="depthDatumName">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Datum: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="depthResolution">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Resolution: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="depthDistanceUnits">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Distance Unit: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="depthEncodingMethod">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Encoding Method: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="geogCoordSysType">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:for-each select="datum">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> Datum: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="./@name"/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="spheroid">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> Spheroid: </td>
          <td>
            <table class="{$tabledefaultStyle}">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Name: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="./@name"/>
                </td>
              </tr>
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Semi Axis Major: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="./@semiAxisMajor"/>
                </td>
              </tr>
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Denom Flat Ratio: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="./@denomFlatRatio"/>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="primeMeridian">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> Prime Meridian: </td>
          <td>
            <table class="{$tabledefaultStyle}">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Name: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="./@name"/>
                </td>
              </tr>
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Longitude: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="./@longitude"/>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="unit">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> Unit: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="./@name"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  <xsl:template name="georeferenceInfo">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <xsl:for-each select="cornerPoint">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Corner Point: </td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:for-each select="corner">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Corner: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="xCoordinate">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> xCoordinate: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="yCoordinate">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> yCoordinate: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="pointInPixel">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Point in Pixel: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="controlPoint">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Control Point: </td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:for-each select="column">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Column Location: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="row">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Row Location: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="xCoordinate">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> xCoordinate: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="yCoordinate">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> yCoordinate: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="pointInPixel">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Point in Pixel: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="bilinearFit">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Bilinear Fit: </td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:for-each select="xIntercept">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> X Intercept: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="xSlope">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> X Slope: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="yIntercept">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Y Intercept: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:for-each select="ySlope">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Y Slope: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="dataQuality">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <xsl:for-each select="accuracyReport">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Report: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="quantitativeAccuracyReport">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Quantitative Report: </td>
        <td>
          <table class="{$tabledefaultStyle}">
            <xsl:for-each select="quantitativeAccuracyReport">
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Accuracy Value: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="quantitativeAccuracyValue"/>
                </td>
              </tr>
              <tr>
                <td class="{$spatialrasterfirstColStyle}"> Method: </td>
                <td class="{$secondColStyle}">
                  <xsl:value-of select="quantitativeAccuracyMethod"/>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template name="imageDescription">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <xsl:for-each select="illuminationElevationAngle">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Illumination Elevation: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="illuminationAzimuthAngle">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Illumination Azimuth: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="imageOrientationAngle">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Image Orientation: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="imagingCondition">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Code Affectting Quality of Image: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="imageQualityCode">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Quality: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="cloudCoverPercentage">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Cloud Coverage: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="preProcessingTypeCode">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> PreProcessing: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="compressionGenerationQuality">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Compression Quality: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="triangulationIndicator">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Triangulation Indicator: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="radionmetricDataAvailability">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Availability of Radionmetric Data: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="cameraCalibrationInformationAvailability">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Availability of Camera Calibration Correction: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="filmDistortionInformationAvailability">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Availability of Calibration Reseau: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="lensDistortionInformationAvailability">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Availability of Lens Aberration Correction: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="bandDescription">
      <tr>
        <td class="{$spatialrasterfirstColStyle}"> Availability of Lens Aberration Correction: </td>
        <td>
          <xsl:call-template name="bandDescription">
            <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialrasterfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="bandDescription">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <table class="{$tabledefaultStyle}">
      <xsl:for-each select="sequenceIdentifier">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> Sequence Identifier: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="highWavelength">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> High Wave Length: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="lowWaveLength">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> High Wave Length: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="waveLengthUnits">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> Wave Length Units: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="peakResponse">
        <tr>
          <td class="{$spatialrasterfirstColStyle}"> Peak Response: </td>
          <td class="{$secondColStyle}">
            <xsl:value-of select="."/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  <xsl:template name="spatialRasterShowDistribution">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <xsl:param name="spatialrastersubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="level">entitylevel</xsl:param>
    <xsl:param name="entitytype">spatialRaster</xsl:param>
    <xsl:param name="entityindex"/>
    <xsl:param name="physicalindex"/>
    <xsl:for-each select="distribution">
      <tr>
        <td colspan="2">
          <xsl:call-template name="distribution">
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="level" select="$level"/>
            <xsl:with-param name="entitytype" select="$entitytype"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
            <xsl:with-param name="physicalindex" select="$physicalindex"/>
            <xsl:with-param name="distributionindex" select="position()"/>
            <xsl:with-param name="disfirstColStyle" select="$spatialrasterfirstColStyle"/>
            <xsl:with-param name="dissubHeaderStyle" select="$spatialrastersubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="spatialRasterAttributeList">
    <xsl:param name="spatialrasterfirstColStyle"/>
    <xsl:param name="spatialrastersubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entitytype">spatialRaster</xsl:param>
    <xsl:param name="entityindex"/>
    <tr>
      <td class="{$spatialrastersubHeaderStyle}" colspan="2">
        <xsl:text>Attribute(s) Info:</xsl:text>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <xsl:call-template name="attributelist">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entitytype" select="$entitytype"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding SPATIAL VECTOR templates 
       ********************************************************
         -->
  <xsl:template name="spatialVector">
    <xsl:param name="spatialvectorfirstColStyle"/>
    <xsl:param name="spatialvectorsubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entityindex"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="spatialVectorcommon">
              <xsl:with-param name="spatialvectorfirstColStyle" select="$spatialvectorfirstColStyle"/>
              <xsl:with-param name="spatialvectorsubHeaderStyle"
                select="$spatialvectorsubHeaderStyle"/>
              <xsl:with-param name="docid" select="$docid"/>
              <xsl:with-param name="entityindex" select="$entityindex"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="spatialVectorcommon">
            <xsl:with-param name="spatialvectorfirstColStyle" select="$spatialvectorfirstColStyle"/>
            <xsl:with-param name="spatialvectorsubHeaderStyle" select="$spatialvectorsubHeaderStyle"/>
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="spatialVectorcommon">
    <xsl:param name="spatialvectorfirstColStyle"/>
    <xsl:param name="spatialvectorsubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entityindex"/>
    <xsl:for-each select="entityName">
      <xsl:call-template name="entityName">
        <xsl:with-param name="entityfirstColStyle" select="$spatialvectorfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="alternateIdentifier">
      <xsl:call-template name="entityalternateIdentifier">
        <xsl:with-param name="entityfirstColStyle" select="$spatialvectorfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="entityDescription">
      <xsl:call-template name="entityDescription">
        <xsl:with-param name="entityfirstColStyle" select="$spatialvectorfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="additionalInfo">
      <xsl:call-template name="entityadditionalInfo">
        <xsl:with-param name="entityfirstColStyle" select="$spatialvectorfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- call physical moduel without show distribution(we want see it later)-->
    <xsl:if test="physical">
      <tr>
        <td class="{$spatialvectorsubHeaderStyle}" colspan="2"> Physical Structure Description:
        </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="physical">
      <tr>
        <td colspan="2">
          <xsl:call-template name="physical">
            <xsl:with-param name="physicalfirstColStyle" select="$spatialvectorfirstColStyle"/>
            <xsl:with-param name="notshowdistribution">yes</xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="coverage">
      <tr>
        <td class="{$spatialvectorsubHeaderStyle}" colspan="2"> Coverage Description: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="coverage">
      <tr>
        <td colspan="2">
          <xsl:call-template name="coverage"/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="method">
      <tr>
        <td class="{$spatialvectorsubHeaderStyle}" colspan="2"> Method Description: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="method">
      <tr>
        <td colspan="2">
          <xsl:call-template name="method">
            <xsl:with-param name="methodfirstColStyle" select="$spatialvectorfirstColStyle"/>
            <xsl:with-param name="methodsubHeaderStyle" select="$spatialvectorsubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="constraint">
      <tr>
        <td class="{$spatialvectorsubHeaderStyle}" colspan="2"> Constraint: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="constraint">
      <tr>
        <td colspan="2">
          <xsl:call-template name="constraint">
            <xsl:with-param name="constraintfirstColStyle" select="$spatialvectorfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="geometry">
      <tr>
        <td class="{$spatialvectorfirstColStyle}"> Geometry: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="geometricObjectCount">
      <tr>
        <td class="{$spatialvectorfirstColStyle}"> Number of Geometric Objects: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="topologyLevel">
      <tr>
        <td class="{$spatialvectorfirstColStyle}"> Topolgy Level: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="spatialReference">
      <tr>
        <td class="{$spatialvectorsubHeaderStyle}" colspan="2"> Spatial Reference: </td>
      </tr>
      <xsl:call-template name="spatialReference">
        <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialvectorfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="horizontalAccuracy">
      <tr>
        <td class="{$spatialvectorsubHeaderStyle}" colspan="2"> Horizontal Accuracy: </td>
      </tr>
      <xsl:call-template name="dataQuality">
        <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialvectorfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="verticalAccuracy">
      <tr>
        <td class="{$spatialvectorsubHeaderStyle}" colspan="2"> Vertical Accuracy: </td>
      </tr>
      <xsl:call-template name="dataQuality">
        <xsl:with-param name="spatialrasterfirstColStyle" select="$spatialvectorfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="$withAttributes = '1'">
      <xsl:for-each select="attributeList">
        <xsl:call-template name="spatialVectorAttributeList">
          <xsl:with-param name="spatialvectorfirstColStyle" select="$spatialvectorfirstColStyle"/>
          <xsl:with-param name="spatialvectorsubHeaderStyle" select="$spatialvectorsubHeaderStyle"/>
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
    <!-- Here to display distribution info-->
    <xsl:for-each select="physical">
      <xsl:call-template name="spatialVectorShowDistribution">
        <xsl:with-param name="docid" select="$docid"/>
        <xsl:with-param name="entityindex" select="$entityindex"/>
        <xsl:with-param name="physicalindex" select="position()"/>
        <xsl:with-param name="spatialvectorfirstColStyle" select="$spatialvectorfirstColStyle"/>
        <xsl:with-param name="spatialvectorsubHeaderStyle" select="$spatialvectorsubHeaderStyle"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="spatialVectorShowDistribution">
    <xsl:param name="spatialvectorfirstColStyle"/>
    <xsl:param name="spatialvectorsubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="level">entitylevel</xsl:param>
    <xsl:param name="entitytype">spatialVector</xsl:param>
    <xsl:param name="entityindex"/>
    <xsl:param name="physicalindex"/>
    <xsl:for-each select="distribution">
      <tr>
        <td colspan="2">
          <xsl:call-template name="distribution">
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="level" select="$level"/>
            <xsl:with-param name="entitytype" select="$entitytype"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
            <xsl:with-param name="physicalindex" select="$physicalindex"/>
            <xsl:with-param name="distributionindex" select="position()"/>
            <xsl:with-param name="disfirstColStyle" select="$spatialvectorfirstColStyle"/>
            <xsl:with-param name="dissubHeaderStyle" select="$spatialvectorsubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="spatialVectorAttributeList">
    <xsl:param name="spatialvectorfirstColStyle"/>
    <xsl:param name="spatialvectorsubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entitytype">spatialVector</xsl:param>
    <xsl:param name="entityindex"/>
    <tr>
      <td class="{$spatialvectorsubHeaderStyle}" colspan="2">
        <xsl:text>Attribute(s) Info:</xsl:text>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <xsl:call-template name="attributelist">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entitytype" select="$entitytype"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding TEXT templates 
       ********************************************************
         -->
  <xsl:template name="text">
    <xsl:param name="textfirstColStyle"/>
    <xsl:param name="textsecondColStyle"/>
    <xsl:if
      test="(section and normalize-space(section) != '') or (para and normalize-space(para) != '')">
      <xsl:apply-templates mode="text">
        <xsl:with-param name="textfirstColStyle" select="$textfirstColStyle"/>
        <xsl:with-param name="textsecondColStyle" select="$textsecondColStyle"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  <xsl:template name="abstracttext">
    <xsl:param name="textfirstColStyle"/>
    <xsl:param name="textsecondColStyle"/>
    <xsl:if
      test="(section and normalize-space(section) != '') or (para and normalize-space(para) != '')">
      <!-- was <xsl:apply-templates mode="text"> (mgb 7Jun2011) use mode="lowlevel" to make abstract use p for para -->
      <div class="abstract-text">
        <xsl:apply-templates mode="text">
          <xsl:with-param name="textfirstColStyle" select="$textfirstColStyle"/>
          <xsl:with-param name="textsecondColStyle" select="$textsecondColStyle"/>
        </xsl:apply-templates>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template match="section" mode="text">
    <xsl:if test="normalize-space(.) != ''">
      <xsl:if test="title and normalize-space(title) != ''">
        <!-- <h4 class="bold"><xsl:value-of select="title"/></h4> -->
        <h4>
          <xsl:value-of select="title"/>
        </h4>
      </xsl:if>
      <xsl:if test="para and normalize-space(para) != ''">
        <xsl:apply-templates select="para" mode="text"/>
      </xsl:if>
      <xsl:if test="section and normalize-space(section) != ''">
        <xsl:apply-templates select="section" mode="text"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <xsl:template match="section" mode="lowlevel">
    <div>
      <xsl:if test="title and normalize-space(title) != ''">
        <!-- <h4 class="bold"><xsl:value-of select="title"/></h4>  -->
        <h5>
          <xsl:value-of select="title"/>
        </h5>
      </xsl:if>
      <xsl:if test="para and normalize-space(para) != ''">
        <xsl:apply-templates select="para" mode="lowlevel"/>
      </xsl:if>
      <xsl:if test="section and normalize-space(section) != ''">
        <xsl:apply-templates select="section" mode="lowlevel"/>
      </xsl:if>
    </div>
  </xsl:template>
  <xsl:template match="para" mode="text">
    <xsl:param name="textfirstColStyle"/>
    <p>
      <xsl:apply-templates/>
    </p>
    <!-- 
         <xsl:apply-templates mode="lowlevel"/>
         -->
  </xsl:template>
  <xsl:template match="para" mode="lowlevel">
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>
  <xsl:template match="itemizedlist">
    <ul>
      <xsl:for-each select="listitem">
        <li>
          <xsl:apply-templates select="."/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
  <xsl:template match="orderedlist">
    <ol>
      <xsl:for-each select="listitem">
        <li>
          <xsl:value-of select="."/>
        </li>
      </xsl:for-each>
    </ol>
  </xsl:template>
  <xsl:template match="emphasis">
    <em>
      <xsl:value-of select="."/>
    </em>
  </xsl:template>
  <xsl:template match="superscript">
    <sup>
      <xsl:value-of select="."/>
    </sup>
  </xsl:template>
  <xsl:template match="subscript">
    <sub>
      <xsl:value-of select="."/>
    </sub>
  </xsl:template>
  <xsl:template match="ulink">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="@url"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="citetitle">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <xsl:template match="literalLayout">
    <pre>
      <xsl:value-of select="." xml:space="preserve"/>
    </pre>
  </xsl:template>
  <!--
       ********************************************************
             adding VEIW templates 
       ********************************************************
         -->
  <xsl:template name="view">
    <xsl:param name="viewfirstColStyle"/>
    <xsl:param name="viewsubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entityindex"/>
    <table class="{$tabledefaultStyle}">
      <xsl:choose>
        <xsl:when test="references != ''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id = $ref_id]"/>
          <xsl:for-each select="$references">
            <xsl:call-template name="viewCommon">
              <xsl:with-param name="viewfirstColStyle" select="$viewfirstColStyle"/>
              <xsl:with-param name="viewsubHeaderStyle" select="$viewsubHeaderStyle"/>
              <xsl:with-param name="docid" select="$docid"/>
              <xsl:with-param name="entityindex" select="$entityindex"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="viewCommon">
            <xsl:with-param name="viewfirstColStyle" select="$viewfirstColStyle"/>
            <xsl:with-param name="viewsubHeaderStyle" select="$viewsubHeaderStyle"/>
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>
  <xsl:template name="viewCommon">
    <xsl:param name="viewfirstColStyle"/>
    <xsl:param name="viewsubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entityindex"/>
    <xsl:for-each select="entityName">
      <xsl:call-template name="entityName">
        <xsl:with-param name="entityfirstColStyle" select="$viewfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="queryStatement">
      <tr>
        <td class="{$viewfirstColStyle}"> Query Statement: </td>
        <td class="{$secondColStyle}">
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="alternateIdentifier">
      <xsl:call-template name="entityalternateIdentifier">
        <xsl:with-param name="entityfirstColStyle" select="$viewfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="entityDescription">
      <xsl:call-template name="entityDescription">
        <xsl:with-param name="entityfirstColStyle" select="$viewfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="additionalInfo">
      <xsl:call-template name="entityadditionalInfo">
        <xsl:with-param name="entityfirstColStyle" select="$viewfirstColStyle"/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- call physical moduel without show distribution(we want see it later)-->
    <xsl:if test="physical">
      <tr>
        <td class="{$viewsubHeaderStyle}" colspan="2"> Physical Structure Description: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="physical">
      <tr>
        <td colspan="2">
          <xsl:call-template name="physical">
            <xsl:with-param name="physicalfirstColStyle" select="$viewfirstColStyle"/>
            <xsl:with-param name="notshowdistribution">yes</xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="coverage">
      <tr>
        <td class="{$viewsubHeaderStyle}" colspan="2"> Coverage Description: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="coverage">
      <tr>
        <td colspan="2">
          <xsl:call-template name="coverage"/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="method">
      <tr>
        <td class="{$viewsubHeaderStyle}" colspan="2"> Method Description: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="method">
      <tr>
        <td colspan="2">
          <xsl:call-template name="method">
            <xsl:with-param name="methodfirstColStyle" select="$viewfirstColStyle"/>
            <xsl:with-param name="methodsubHeaderStyle" select="$viewsubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="constraint">
      <tr>
        <td class="{$viewsubHeaderStyle}" colspan="2"> Constraint: </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="constraint">
      <tr>
        <td colspan="2">
          <xsl:call-template name="constraint">
            <xsl:with-param name="constraintfirstColStyle" select="$viewfirstColStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:if test="$withAttributes = '1'">
      <xsl:for-each select="attributeList">
        <xsl:call-template name="viewAttributeList">
          <xsl:with-param name="viewfirstColStyle" select="$viewfirstColStyle"/>
          <xsl:with-param name="viewsubHeaderStyle" select="$viewsubHeaderStyle"/>
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$withAttributes = '1'">
      <!-- Here to display distribution info-->
      <xsl:for-each select="physical">
        <xsl:call-template name="viewShowDistribution">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
          <xsl:with-param name="physicalindex" select="position()"/>
          <xsl:with-param name="viewfirstColStyle" select="$viewfirstColStyle"/>
          <xsl:with-param name="viewsubHeaderStyle" select="$viewsubHeaderStyle"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name="viewShowDistribution">
    <xsl:param name="viewfirstColStyle"/>
    <xsl:param name="viewsubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="level">entitylevel</xsl:param>
    <xsl:param name="entitytype">view</xsl:param>
    <xsl:param name="entityindex"/>
    <xsl:param name="physicalindex"/>
    <xsl:for-each select="distribution">
      <tr>
        <td colspan="2">
          <xsl:call-template name="distribution">
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="level" select="$level"/>
            <xsl:with-param name="entitytype" select="$entitytype"/>
            <xsl:with-param name="entityindex" select="$entityindex"/>
            <xsl:with-param name="physicalindex" select="$physicalindex"/>
            <xsl:with-param name="distributionindex" select="position()"/>
            <xsl:with-param name="disfirstColStyle" select="$viewfirstColStyle"/>
            <xsl:with-param name="dissubHeaderStyle" select="$viewsubHeaderStyle"/>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="viewAttributeList">
    <xsl:param name="viewfirstColStyle"/>
    <xsl:param name="viewsubHeaderStyle"/>
    <xsl:param name="docid"/>
    <xsl:param name="entitytype">view</xsl:param>
    <xsl:param name="entityindex"/>
    <tr>
      <td class="{$viewsubHeaderStyle}" colspan="2">
        <xsl:text>Attribute(s) Info:</xsl:text>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <xsl:call-template name="attributelist">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="entitytype" select="$entitytype"/>
          <xsl:with-param name="entityindex" select="$entityindex"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  <!--
       ********************************************************
             adding HOW TO CITE templates 
       ********************************************************
         -->
  <xsl:template xmlns:ext="http://exslt.org/common" name="howtoCite">
    <xsl:param name="index"/>
    <xsl:param name="citetabledefaultStyle"/>
    <xsl:param name="citefirstColStyle"/>
    <xsl:param name="citesecondColStyle"/>
    <xsl:param name="contextURL"/>
    <xsl:param name="packageID">
      <xsl:value-of select="../@packageId"/>
    </xsl:param>
    <xsl:param name="datasetTitle">
      <xsl:value-of select="title"/>
      <!-- xpath must be relative to dataset.  This is /dataset/title so select="title" (mgb) -->
    </xsl:param>
    <xsl:param name="publisherOrganizationName">
      <xsl:value-of select="publisher/organizationName"/>
    </xsl:param>
    <xsl:param name="organizationName">
      <xsl:value-of select="creator/organizationName"/>
    </xsl:param>
    <xsl:param name="pubDate">
      <!-- <xsl:value-of select="year-from-date(pubDate)"/>   -->
      <xsl:value-of select="pubDate"/>
    </xsl:param>
    <xsl:param name="givenName"/>
    <table class="{$citetabledefaultStyle}" id="howToCite">
      <tr>
        <td class="{$citefirstColStyle}">How to cite this data set:</td>
        <td class="{$citesecondColStyle}"><!-- count the creators, set a var --><xsl:variable
            name="creator_count" select="count(creator/individualName)"/><xsl:for-each
            select="creator/individualName"
              ><!-- if this is the last author in a list, and not the first then prefix an "and" --><xsl:if
              test="position() = last() and not(position() = 1)"> and </xsl:if><xsl:if
              test="not(position() = last()) and not(position() = 1)"
              ><xsl:text>, </xsl:text></xsl:if><xsl:if test="position() = 1"
                ><!-- for first author, put surname before initial(s) --><xsl:value-of
                select="surName"/><xsl:if test="givenName"><xsl:text>, </xsl:text><xsl:for-each
                  select="givenName"><xsl:value-of select="substring(., 1, 1)"
                  /><xsl:text>. </xsl:text><!-- first initial followed by period --></xsl:for-each></xsl:if></xsl:if><xsl:if
              test="not(position() = 1)"
                ><!-- for any except first author, put initial(s) before surname --><xsl:if
                test="givenName"><xsl:for-each select="givenName"
                    ><!-- the dot in the substring arg below is the givenName value --><xsl:value-of
                    select="substring(., 1, 1)"
                  /><!-- first initial --></xsl:for-each><xsl:text>. </xsl:text><xsl:value-of
                  select="surName"
              /></xsl:if></xsl:if></xsl:for-each><!-- 
            
            GET LOGIC FROM YOUR PUBS DISPLAY!!!   --><xsl:choose><xsl:when
              test="creator_count = '1'"><xsl:choose><xsl:when
                  test="creator/individualName/givenName"
                  ><!-- do nothing. the period following the initial will suffice.--></xsl:when><xsl:otherwise><!-- there is one creator, and no given name. eew. ugly, but oh well. add a period. --><xsl:text>. </xsl:text></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise><!-- more than one creator. --><xsl:text>. </xsl:text></xsl:otherwise></xsl:choose><xsl:value-of
            select="substring($pubDate, 1, 4)"/>. <xsl:value-of select="$datasetTitle"
              /><xsl:text>. </xsl:text><xsl:choose><xsl:when
              test="string-length($publisherOrganizationName) = 0"><xsl:value-of
                select="$organizationName"
                /><xsl:text>.</xsl:text></xsl:when><xsl:otherwise><xsl:value-of
                select="$publisherOrganizationName"
            /><xsl:text>. </xsl:text></xsl:otherwise></xsl:choose><!-- 
            
            
            
            add 1 or more DOIs, if available, or some other default.. --><xsl:variable
            name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/><xsl:variable name="uppercase"
            select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/><!-- count up the number of DOIs --><xsl:variable
            name="doi_count"><xsl:value-of
              select="count(alternateIdentifier[contains(translate(@system, $uppercase, $lowercase), 'doi') or contains(translate(@system, $uppercase, $lowercase), 'digital object identifier')])"
            /><!-- if you have other patterns that identify a doi, add them to this list with 'or' --></xsl:variable><!-- 
            
            save for future testing.
          <xsl:text> DOI COUNT:</xsl:text>
          <xsl:value-of select="$doi_count"/>
          --><!-- 
            
            depending on the number of DOIs found, call a display template with params. --><xsl:choose><xsl:when
              test="$doi_count = 0"><xsl:call-template name="display_default_id"><xsl:with-param
                  name="contextURL" select="$contextURL"/><xsl:with-param name="packageID"
                  select="$packageID"/></xsl:call-template><xsl:call-template name="request_doi"
                  ><xsl:with-param name="packageID" select="$packageID"/><xsl:with-param
                  name="datasetTitle" select="$datasetTitle"
                /></xsl:call-template></xsl:when><xsl:otherwise><!-- at least one DOI found. --><xsl:call-template
                name="display_dois"><xsl:with-param name="doi_count" select="$doi_count"
                  /><xsl:with-param name="lowercase" select="$lowercase"/><xsl:with-param
                  name="uppercase" select="$uppercase"
            /></xsl:call-template></xsl:otherwise></xsl:choose></td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template xmlns:ext="http://exslt.org/common" name="display_dois">
    <xsl:param name="doi_count"/>
    <xsl:param name="uppercase"/>
    <xsl:param name="lowercase"/>
    <xsl:for-each
      select="alternateIdentifier[contains(translate(@system, $uppercase, $lowercase), 'doi') or contains(translate(@system, $uppercase, $lowercase), 'digital object identifier')]">
      <xsl:text>doi:</xsl:text>
      <xsl:value-of select="."/>
      <!-- 
       separate with a comma if not the last doi in a list. -->
      <xsl:if test="not(position() = last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template xmlns:ext="http://exslt.org/common" name="display_default_id">
    <xsl:param name="packageID"/>
    <xsl:param name="contextURL"/>
    <!-- now: a metacat URL, per current practice -->
    <xsl:value-of select="$packageID"/>
    <!--(<a>
      <xsl:attribute name="href">
        <xsl:value-of select="$contextURL"/>/knb/metacat/<xsl:value-of select="$packageID"
        />/lter</xsl:attribute>
      <xsl:value-of select="$contextURL"/>/knb/metacat/<xsl:value-of select="$packageID"
    />/lter</a>). 
    -->
    <!-- later: 
      repeat the package ID, with a statement that no permaent id exists 
      or whatever the local catalog chooses, some other url, etc. -->
  </xsl:template>
  <xsl:template xmlns:ext="http://exslt.org/common" name="request_doi">
    <xsl:param name="packageID"/>
    <xsl:param name="datasetTitle"/>
    <br/>
    <br/>
    <xsl:text>No permanent identifer exists yet for this data package. For more information, send an </xsl:text>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:text>mailto:sbclter@msi.ucsb.edu?subject=Requesting%20DOI%20information%20for%20dataset%20</xsl:text>
        <xsl:value-of select="$packageID"/>
        <xsl:text>&amp;body=I%20would%20like%20to%20cite%20this%20dataset:%20"</xsl:text>
        <xsl:value-of select="$datasetTitle"/>
        <xsl:text>".%20Please send information about a pending DOI for this data package.</xsl:text>
      </xsl:attribute>
      <xsl:text>email request for more information about this package's identifiers</xsl:text>
    </xsl:element>
    <xsl:text> to use in a citation.</xsl:text>
    <!-- 
  <a href="mailto:email@example.com?subject=Requesting%20DOI%20for%20dataset%20citation&amp;body=Yo%20Zaposphere%20I%20love%20your%20work">REQUEST this pkg's DOI</a>
-->
  </xsl:template>
  <!--
       ********************************************************
             adding GEOCOV DRAW MAP templates 
       ********************************************************
         -->
  <xsl:template name="geoCovMap">
    <xsl:param name="index"/>
    <xsl:param name="maptabledefaultStyle"/>
    <xsl:param name="mapfirstColStyle"/>
    <xsl:param name="mapsecondColStyle"/>
    <xsl:param name="contextURL"/>
    <xsl:param name="currentmodule"/>
    <xsl:param name="packageID">
      <xsl:value-of select="../@packageId"/>
    </xsl:param>
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"/>
    <script type="text/javascript">
  
  var map; 
  var infowindow;  
  var curr_infowindow;

  var marker;
  var markers = [];
  var pt_locations = [];
  var pt_titles = [];
  var pt_info =[];
  
  var boundingPolygon;
  var boundingPolygons = [];
  var poly_locations = [];
  var poly_titles = [];
  var poly_info =[];

  // get the data into arrays.
  <xsl:for-each select="coverage/geographicCoverage">
    var nbc = <xsl:value-of select="boundingCoordinates/northBoundingCoordinate"/>;
    var sbc = <xsl:value-of select="boundingCoordinates/southBoundingCoordinate"/>;
    var wbc = <xsl:value-of select="boundingCoordinates/westBoundingCoordinate"/>;
    var ebc = <xsl:value-of select="boundingCoordinates/eastBoundingCoordinate"/>;
    
    var gc_id = '<xsl:value-of select="@id"/>';
    var gc_descr = "<xsl:value-of select="normalize-space(geographicDescription)"/>";
    
    //logic to determine if we are dealing with a single point or a polygon
    if (nbc == sbc &amp;&amp; wbc == ebc) {
      // single point, will use a marker
      myLat = nbc; 
      myLon = wbc;
      var point = new google.maps.LatLng(myLat,myLon);
      pt_locations.push(point);
      
      // the id if there is one - id is optional
      if( gc_id ) {
      pt_titles.push(gc_id);
      } else {
      // if no id, titles[i] will be null 
      pt_titles.push(' ');
      }
      
      // the description for the info bubble
      pt_info.push(gc_descr);

    } else {
     // not a point, will use a polygon
    var boundingCoordinates = [
      new google.maps.LatLng(nbc,wbc),
      new google.maps.LatLng(nbc,ebc),
      new google.maps.LatLng(sbc,ebc),
      new google.maps.LatLng(sbc,wbc)
    ];
    poly_locations.push(boundingCoordinates);
    
      // the id if there is one - id is optional
      if( gc_id ) {
      poly_titles.push(gc_id);
      } else {
      // if no id, titles[i] will be null 
      poly_titles.push(' ');
      }
      
      // the description for the info bubble
      poly_info.push(gc_descr);
    
    } // closes if n=s and w=s 

  </xsl:for-each>

  
  // MAP FUNCTIONS BELOW HERE.
  function initialize_map() {
    var myCenter = new google.maps.LatLng(34.25,-120.00);
    var myOptions = {
      zoom: 8,
      center: myCenter,
      mapTypeId: google.maps.MapTypeId.TERRAIN,
      streetViewControl: false 
    };
    
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  
    // add the site-markers 
    for (var i = 0; i &lt; pt_locations.length; i++) {
      markers[i] = createMarker(pt_locations[i], pt_info[i], pt_titles[i], map);      
    } 
    
    // add the polygons
    for (var j = 0; j &lt; poly_locations.length; j++) {
      boundingPolygons[j] = createPolygon(poly_locations[j], poly_info[j], poly_titles[j], map);      
    } 
    
  } 
        
        
   function createMarker(point, pt_info, pt_title, map) {
     var marker = new google.maps.Marker({
       position: point,
       map: map,         
       title: pt_title       
     });
             
     var infowindow = new google.maps.InfoWindow({
       content: pt_info
     });
        
     google.maps.event.addListener(marker, "click", function() {
       if (curr_infowindow) {curr_infowindow.close(); }
       curr_infowindow = infowindow;
       infowindow.open(map, marker); 
     });
     
     return marker;
   }   
   
   
   function createPolygon (poly_coords, poly_info, poly_title, map) {      
     var boundingPolygon = new google.maps.Polygon({
       paths: poly_coords,
       strokeColor: "#FF0000",
       strokeOpacity: 0.8,
       strokeWeight: 2,
       fillColor: "#FF0000",
       fillOpacity: 0.1
     });
  
     var infowindow = new google.maps.InfoWindow({
       content: poly_info
     });
  
     // add a listener 
     google.maps.event.addListener(boundingPolygon, 'click', function(event) {
       if ( curr_infowindow) {curr_infowindow.close(); }
       curr_infowindow = infowindow;
       infowindow.setPosition(event.latLng);
       infowindow.open(map);
     });
    
     boundingPolygon.setMap(map); 
   }
   
   
    </script>
  </xsl:template>
  <!--
       ********************************************************
             SETTING may go here  
             Generally these are configuration settings, 
             so probably better elsewhere. for now, a place holder.
       ********************************************************
         -->
</xsl:stylesheet>
