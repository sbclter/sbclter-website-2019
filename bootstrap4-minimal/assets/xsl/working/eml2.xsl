<?xml version="1.0"?>
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
  <xsl:import href="eml2-access.xsl"/>
  <xsl:import href="eml2-additionalmetadata.xsl"/>
  <xsl:import href="eml2-attribute.xsl"/>
  <xsl:import href="eml2-attribute-enumeratedDomain.xsl"/>
  <xsl:import href="eml2-constraint.xsl"/>
  <xsl:import href="eml2-coverage.xsl"/>
  <xsl:import href="eml2-dataset.xsl"/>
  <xsl:import href="eml2-datatable.xsl"/>
  <xsl:import href="eml2-distribution.xsl"/>
  <xsl:import href="eml2-entity.xsl"/>
  <xsl:import href="eml2-identifier.xsl"/>
  <xsl:import href="eml2-literature.xsl"/>
  <xsl:import href="eml2-method.xsl"/>
  <xsl:import href="eml2-otherentity.xsl"/>
  <xsl:import href="eml2-party.xsl"/>
  <xsl:import href="eml2-physical.xsl"/>
  <xsl:import href="eml2-project.xsl"/>
  <xsl:import href="eml2-protocol.xsl"/>
  <xsl:import href="eml2-resource.xsl"/>
  <xsl:import href="eml2-settings.xsl"/>
  <xsl:import href="eml2-software.xsl"/>
  <xsl:import href="eml2-spatialraster.xsl"/>
  <xsl:import href="eml2-spatialvector.xsl"/>
  <xsl:import href="eml2-storedprocedure.xsl"/>
  <xsl:import href="eml2-text.xsl"/>
  <xsl:import href="eml2-view.xsl"/>
  <xsl:import href="eml2-howtoCite.xsl"/>
  <xsl:import href="eml2-geoCov_draw_map.xsl"/>
  
  <!-- These import paths will be replaced by config settings
  -->
  <xsl:import href="[% site.path.xslt %]/pageheader.xsl"/>
  <xsl:import href="[% site.path.xslt %]/pagefooter.xsl"/>
  <xsl:import href="[% site.path.xslt %]/page_leftsidebar.xsl"/>
  <xsl:import href="[% site.path.xslt %]/page_rightsidebar.xsl"/>
  <xsl:import href="[% site.path.xslt %]/page_rightsidebar.xsl"/>
  
  
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
  
  <xsl:output method="html" encoding="utf-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    indent="yes" />  
  
  
  
  
  <!-- global variables to store id node set in case to be referenced-->
  <xsl:variable name="ids" select="//*[@id!='']"/>
  <!-- 
    
    mob 2010-03-23
    calling program passes in value for requested docid  -->
  <xsl:param name="docid" select=" '' "></xsl:param>
 
 <!-- calling app passes in it's own name -->
 <xsl:param name="referrer" select=" '' "></xsl:param>
 
  <xsl:template match="/">
    <xsl:param name="docid" select="$docid"></xsl:param>
    <xsl:param name="referrer" select="$referrer"></xsl:param>

    
 
    <html>
      <head>
        <link rel="stylesheet" type="text/css"
          href="[% site.url.root %]/w3_recommended.css" />
        <link rel="stylesheet" type="text/css"
          href="[% site.url.root %]/css/navigation.css" />
        <link rel="stylesheet" type="text/css"
        href="[% site.url.root %]/css/sbclter.css" />
        <!-- 2016-10-08, 
          in which mob tests latex rendering -->
        <script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML"></script>
        <!-- end mobs test -->
        
        <title>Data package, Santa Barbara Coastal LTER, id <xsl:value-of select="$docid"/></title>
      </head>
      
      <xsl:element name="body">
       <!-- coverage pages have a map --> 
          <xsl:if test="$displaymodule='coverageall'">
            <xsl:attribute name="onload">initialize_map()</xsl:attribute>
          </xsl:if>
      
        <!-- begin the header area -->
        <xsl:call-template name="pageheader" />
        
        <!-- end the header area -->
   
   
        <!-- begin the content area -->
         <!--
           
           If calling script is the showDraftDataset script, then the div element includes 
           a style attribute (for border color) plus the extra label. This stuff could go into params, too.
         -->
        <xsl:element name="div">
          <xsl:attribute name="id">{$mainTableAligmentStyle}</xsl:attribute>
          <xsl:if test="$referrer='showDraftDataset.cgi' ">
             <xsl:attribute name="style">border: 4px orange solid</xsl:attribute>
             <div  style="color: orange; font-weight: bold "><xsl:text>&#160;DRAFT</xsl:text></div>
          </xsl:if>
          
          <xsl:apply-templates select="*[local-name()='eml']"/>
                
        </xsl:element> <!-- closes the div element around the page. -->
        
        <!-- mob 2010-03-24 mob added to catch error msgs. -->
        <div> 
          <xsl:apply-templates select="error"/>
        </div>
        <!-- end the content area -->
   
        <!-- begin the right sidebar area -->
        <xsl:call-template name="page_rightsidebar" />
        <!-- end the right sidebar area -->
        
        <!-- begin the left sidebar area -->
        <xsl:call-template name="page_leftsidebar" />
        <!-- end the left sidebar area -->
        
        <!-- begin the footer area -->
        <xsl:call-template name="pagefooter" />
        <!-- end the footer area -->
   
      </xsl:element>
    </html>
  </xsl:template>
  
  <!-- mob 2010-03-24
  TO DO: add a template with a form to let the user log in and then resend the dp. -->
  <xsl:template match="error">
    <xsl:value-of select="."/>
  </xsl:template>

   <xsl:template match="*[local-name()='eml']">
     <!-- hang onto first title to pass to child pages -->
     <xsl:param name="resourcetitle">
      <xsl:value-of select="*/title"/> 
     </xsl:param>
     <xsl:param name="packageID">
       <xsl:value-of select="@packageId"/>
     </xsl:param>
   
     <xsl:for-each select="dataset">
 <!--  debug: <xsl:value-of select="$packageID"/>  :eml.xsl line 153  -->
       <xsl:call-template name="emldataset">
         <xsl:with-param name="resourcetitle" select="$resourcetitle"></xsl:with-param>
         <xsl:with-param name="packageID" select="$packageID"></xsl:with-param>
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
       <xsl:when test="$displaymodule='additionalmetadata'">
         <xsl:for-each select="additionalMetadata">
           <xsl:if test="$additionalmetadataindex=position()">
              <div class="{$tabledefaultStyle}">
                 <xsl:call-template name="additionalmetadata"/>
               </div>
            </xsl:if>
         </xsl:for-each>
       </xsl:when>
       <xsl:otherwise>
         <xsl:if test="$displaymodule='dataset'">
           <xsl:if test="$withAdditionalMetadataLink='1'">
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
     <xsl:if test="$displaymodule='dataset'">
       <xsl:if test="$withOriginalXMLLink='1'">
         <xsl:call-template name="xml"/>
       </xsl:if>
     </xsl:if>
   </xsl:template>

   <!--********************************************************
                       dataset part
       ********************************************************-->

   <xsl:template name="emldataset">
     <xsl:param name="resourcetitle" select="$resourcetitle"/>
     <xsl:param name="entitytype" select="$entitytype"/>
     <xsl:param name="entityindex" select="$entityindex"/> 
     <xsl:param name="packageID"/>  <!-- when you put the select here, it broke. understand why, please.  -->
   <!-- <div class="{$mainContainerTableStyle}"> -->
    <xsl:if test="$displaymodule='dataset'">
       <xsl:call-template name="datasetpart">
         <xsl:with-param name="packageID" select="$packageID"></xsl:with-param>
       </xsl:call-template>
    </xsl:if>
     <xsl:if test="$displaymodule='entity'">
       <xsl:call-template name="entitypart"/>
     </xsl:if>
     <!-- mob added 2010-03-26 -->
     <xsl:if test="$displaymodule='responsibleparties'">
       <xsl:call-template name="responsiblepartiespart">
         <xsl:with-param name="docid" select="$docid"/>
         <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
        <xsl:with-param name="packageID" select="$packageID"/> 
       </xsl:call-template>
     </xsl:if>
     <!-- mob added 2010-03-26. this one only used by attribute-level coverage  -->
     <xsl:if test="$displaymodule='coverage' ">
       <xsl:call-template name="coveragepart">
         <xsl:with-param name="docid" select="$docid"/>
         <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
       </xsl:call-template>
     </xsl:if>
     <!-- mob added 2010-03-26  -->
     <xsl:if test="$displaymodule='coverageall' ">
       <xsl:call-template name="ifcoverage">
         <xsl:with-param name="docid" select="$docid"/>
         <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
         <xsl:with-param name="packageID" select="$packageID"/>
       </xsl:call-template>
     </xsl:if>
     <!-- mob added 2010-03-26  -->
     <xsl:if test="$displaymodule='methodsall' ">
       <xsl:call-template name="ifmethods">
         <xsl:with-param name="docid" select="$docid"/>
         <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
         <xsl:with-param name="packageID" select="$packageID"/>
       </xsl:call-template>
     </xsl:if>
    <xsl:if test="$displaymodule='attribute'">
       <xsl:call-template name="attributepart"/>
    </xsl:if>
    <xsl:if test="$displaymodule='attributedomain'">
       <xsl:call-template name="datasetattributedomain"/>
    </xsl:if>
    <xsl:if test="$displaymodule='attributecoverage'">
       <xsl:call-template name="datasetattributecoverage">
        <xsl:with-param name="entitytype" select="$entitytype"/>
         <xsl:with-param name="entityindex" select="$entityindex"/>
       </xsl:call-template>
    </xsl:if>
    <xsl:if test="$displaymodule='attributemethod'">
       <xsl:call-template name="datasetattributemethod"/>

       
    </xsl:if>
    <xsl:if test="$displaymodule='inlinedata'">
       <xsl:call-template name="emlinlinedata"/>
    </xsl:if>
    <xsl:if test="$displaymodule='attributedetail'">
       <xsl:call-template name="entityparam"/>
    </xsl:if>
    <!--   </div> -->
   </xsl:template>

   <!--*************** Data set diaplay *************-->
   <xsl:template name="datasetpart">
       <xsl:param name="packageID"/>  
       <xsl:apply-templates select="." mode="dataset">
        <xsl:with-param name="packageID" select="$packageID"></xsl:with-param> 
       </xsl:apply-templates> 
   </xsl:template>

   <!--************ Entity diplay *****************-->
   <xsl:template name="entitypart">
       <xsl:choose>
         <xsl:when test="references!=''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id=$ref_id]" />
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
    <xsl:param name="docid" select="$docid"></xsl:param>
    <xsl:param name="resourcetitle" select="$resourcetitle"></xsl:param>
     <xsl:param name="packageID" select="$packageID"/> 
    <xsl:choose>
      <xsl:when test="references!=''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id=$ref_id]" />
        <xsl:for-each select="$references">
          <xsl:call-template name="responsibleparties">
            <xsl:with-param name="docid" select="$docid"/>
            <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
           
            <xsl:with-param name="packageID" select="$packageID"/> 
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="responsibleparties">
          <xsl:with-param name="docid" select="$docid"/>
          <xsl:with-param name="resourcetitle" select="$resourcetitle"/>
           <xsl:with-param name="packageID" select="$packageID"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="responsibleparties">
    <xsl:param name="docid" select="$docid"></xsl:param>
    <xsl:param name="resourcetitle" select="$resourcetitle"></xsl:param>
    <xsl:param name="packageID" select="$packageID"/> 
    
    
    <xsl:call-template name="datasettitle">
                  <xsl:with-param name="packageID" select="$packageID"/> 
      
    </xsl:call-template>
    <table class="onehundred_percent">            
      <tr><td>
        <xsl:call-template name="datasetmenu">
          <xsl:with-param name="currentmodule">responsibleparties</xsl:with-param>
                     <xsl:with-param name="packageID" select="$packageID"/> 
          
        </xsl:call-template>
      </td></tr>
      <tr><td>
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
              <xsl:for-each select="following-sibling::publisher[position()=1]">
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
            <xsl:for-each select="following-sibling::creator[position()=1]">
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
              <xsl:for-each select="following-sibling::contact[position()=1]">
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
              <xsl:for-each select="following-sibling::associatedParty[position()=1]">
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
              <xsl:for-each select="following-sibling::metadataProvider[position()=1]">
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
        
      </td></tr>
    </table> <!-- closes the table wrapping the dataset-menu  -->
  </xsl:template>
  
  
  <xsl:template name="coveragepart">
    <xsl:param name="docid" select="$docid"></xsl:param>
    <xsl:param name="resourcetitle" select="$resourcetitle"></xsl:param>
    <h3>Data Set Coverage</h3>
    <h4><xsl:value-of select="$resourcetitle"/>
      &#160;(<a><xsl:attribute name="href">
        <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/>
      </xsl:attribute>return to dataset summary</a>)
    </h4>
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
    <xsl:param name="docid" select="$docid"></xsl:param>
    <xsl:param name="resourcetitle" select="$resourcetitle"></xsl:param>
    <xsl:param name="packageID" select="$packageID"/>
    
    <xsl:call-template name="datasettitle">
      <xsl:with-param name="packageID" select="$packageID"/>
    </xsl:call-template>
    <table>            
      <tr><td>
        <xsl:call-template name="datasetmenu">
          <xsl:with-param name="currentmodule">coverageall</xsl:with-param>
        </xsl:call-template>
      </td></tr>
      <tr><td>
        <!-- 
        <xsl:call-template name="datasetmixed"/> -->
    <h4>
      <xsl:text>Temporal, Geographic and/or Taxonomic information that applies to all data in this dataset: </xsl:text></h4>
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
                <table  class="subGroup subGroup_border onehundred_percent">
                  <!-- header for the geographic coverage area -->
                  <tr><th colspan="2">Geographic Coverage</th></tr>
                  <tr>
                    <!-- <td class="fortyfive_percent"> -->
                    <td class="">
            <xsl:for-each select="./coverage/geographicCoverage">
              <xsl:call-template name="geographicCoverage">
                <xsl:with-param  name="firstColStyle" select="$firstColStyle"/>
                <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
              </xsl:call-template>
            </xsl:for-each>
                </td>
                    <!-- td class=" fortyfive_percent"> -->
                    <td class="">
                      
                    <div class="eml_map">
                      <div id="map_canvas" style="width: 400px; height: 300px;"></div>
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
                      <xsl:if test="coverage"> <!-- if an entity-level cov tree -->
                        <xsl:for-each select="./coverage/temporalCoverage">
                          <xsl:call-template name="temporalCoverage">
                            <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                            <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                          </xsl:call-template>
                        </xsl:for-each>
                        <xsl:for-each select="./coverage/geographicCoverage">
                          <xsl:call-template name="geographicCoverage">
                            <xsl:with-param  name="firstColStyle" select="$firstColStyle"/>
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
            <xsl:if test=".//attribute/coverage"> <!-- an attribute descendant has a cov tree -->
               <xsl:for-each select=".//attribute/coverage">
                 <table  class="subGroup">
                <tr>
                  <th>
                    <!-- create a label for that attribute's coverage info. use the orientation and attr label if it has one -->                 
                <xsl:choose>
                  <xsl:when test="ancestor::dataTable/*//attributeOrientation ='column' ">
                    <xsl:text>Temporal, Geographic and/or Taxonomic information that applies to the data table column:&#160;</xsl:text>
                  </xsl:when>
                  <xsl:when test="ancestor::dataTable/*//attributeOrientation ='row' ">
                    <xsl:text>Temporal, Geographic and/or Taxonomic information that applies to the data table row:&#160;</xsl:text>
                   </xsl:when>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="../attributeLabel">
                    <xsl:value-of select="../attributeLabel"/>
                    <xsl:text>&#160;(</xsl:text><xsl:value-of select="../attributeName"/><xsl:text>)</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="../attributeName"/>
                  </xsl:otherwise>
                </xsl:choose> <!-- end of cov info label  -->
                  </th>
                </tr>
                   <tr><td>
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
                   </td></tr>
                   </table>    <!-- closes the table for the attribute -->
               </xsl:for-each> 
            </xsl:if>
         <!-- </table>  closes the table for the data entity  -->
         </xsl:if>
      </xsl:for-each>
 <!--      </tr>
 </table> -->
    
    
      </td></tr>
    </table> <!-- closes the table wrapping the dataset-menu  -->
    
    
    
    
     </xsl:template>
  
  
  
  
  <!-- 
    
    
    template to show comprehensive methods info from resource, entity and attribute modules.
    not from project tree.
    added by mob 2010-apr
  --> 
  <xsl:template name="ifmethods">
    <xsl:param name="packageID"></xsl:param>
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
          <xsl:with-param name="resourcetitle"></xsl:with-param>
          <xsl:with-param name="nodemissing_message">No methods information available</xsl:with-param>
          <xsl:with-param name="currentmodule" select="$displaymodule"></xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:template>
  
  <xsl:template name="ifcoverage">
    <xsl:param name="packageID"></xsl:param>
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
          <xsl:with-param name="resourcetitle"></xsl:with-param>
          <xsl:with-param name="nodemissing_message">No coverage information available</xsl:with-param>
          <xsl:with-param name="currentmodule" select="$displaymodule"></xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  <xsl:template name="nodemissing">
    <xsl:param name="docid" select="$docid"></xsl:param>
    <xsl:param name="resourcetitle" select="$resourcetitle"></xsl:param>
    <xsl:param name="nodemissing_message"></xsl:param>
    <xsl:param name="currentmodule" select="$currentmodule"/>
    <xsl:call-template name="datasettitle"/>
    <table  class="onehundred_percent">            
      <tr><td>
        <xsl:call-template name="datasetmenu">
          <xsl:with-param name="currentmodule" select="$currentmodule"></xsl:with-param>
        </xsl:call-template>
      </td></tr>
      <tr><td align="center">
        <h4>
        <xsl:value-of select="$nodemissing_message"/>
        </h4>
      </td>
      </tr>
      </table>
  </xsl:template>
  
  
  <xsl:template name="methodsall">
    <xsl:param name="docid" select="$docid"></xsl:param>
    <xsl:param name="resourcetitle" select="$resourcetitle"></xsl:param>
    <xsl:param name="packageID" select="$packageID"/>
    
    <xsl:call-template name="datasettitle">
      <xsl:with-param name="packageID" select="$packageID"></xsl:with-param>
    </xsl:call-template>
    <table  class="onehundred_percent">            
      <tr><td>
        <xsl:call-template name="datasetmenu">
          <xsl:with-param name="currentmodule">methodsall</xsl:with-param>
        </xsl:call-template>
      </td></tr>
      <tr><td>
        
        <h4>
          <xsl:text>These methods, instrumentation and/or protocols apply to all data in this dataset: </xsl:text></h4>
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
          <xsl:if test="(./methods) or (*//attribute/methods) or (./method) or (*//attribute/method) ">
            <h4>
              <xsl:text>These methods, instrumentation and/or protocols apply  to Data Table: </xsl:text>
              <xsl:value-of select="entityName"/> 
            </h4>
            
            <xsl:if test="(./method) or (./methods) "> <!-- first find an entity-level methods tree -->
             <!--  this becomes METHODS in eml 2.1 -->
              <xsl:for-each select="method | methods">
                
                <xsl:call-template name="datasetmethod">
                  <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                  <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="(*//attribute/methods)  or (*//attribute/method)"> <!-- an attribute descendant has a method tree -->
             
              <xsl:for-each select="*//attribute/method | *//attribute/methods"> <!-- mob fixed 2011-12-23 - missing 'or'  -->
                 
                <table  class="subGroup">
                  <tr>
                    <th>
                      <!-- create a label for that attribute's coverage info. use the orientation and attr label if it has one -->                 
                      <xsl:choose>
                        <xsl:when test="ancestor::dataTable/*//attributeOrientation ='column' ">
                          <xsl:text>These methods, instrumentation and/or protocols apply  to the data table column:&#160;</xsl:text>
                        </xsl:when>
                        <xsl:when test="ancestor::dataTable/*//attributeOrientation ='row' ">
                          <xsl:text>These methods, instrumentation and/or protocols apply  to the data table row:&#160;</xsl:text>
                        </xsl:when>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="../attributeLabel">
                          <xsl:value-of select="../attributeLabel"/>
                          <xsl:text>&#160;(</xsl:text><xsl:value-of select="../attributeName"/><xsl:text>)</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="../attributeName"/>
                        </xsl:otherwise>
                      </xsl:choose> <!-- end of cov info label  -->
                    </th>
                  </tr>
                  <tr><td>
                    <xsl:for-each select=".">            
                      <xsl:call-template name="datasetmethod">
                        <xsl:with-param name="firstColStyle" select="$firstColStyle"/>
                        <xsl:with-param name="secondColStyle" select="$secondColStyle"/>
                      </xsl:call-template>
                    </xsl:for-each>
                    
                  </td></tr>
                </table>    <!-- closes the table for the attribute -->
              </xsl:for-each> 
            </xsl:if>
            <!-- </table>  closes the table for the data entity  -->
          </xsl:if>
        </xsl:for-each>
        <!--      </tr>
          </table> -->
        
        
      </td></tr>
    </table> <!-- closes the table wrapping the dataset-menu  -->
    
    
    
    
  </xsl:template>
  
  
  
  
  
  
  
  
  
  
  
  
  
  

   <!--************ Attribute display *****************-->
   <xsl:template name="attributedetailpart">
   </xsl:template>

    <xsl:template name="attributepart">
      <tr><td>
      <h3>Attributes Description</h3>
      </td></tr>
      <tr>
     <td>
        <!-- find the subtree to process -->
      <xsl:if test="$entitytype='dataTable'">
        <xsl:for-each select="dataTable">
            <xsl:if test="position()=$entityindex">
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
         <xsl:when test="*/attributeList/attribute[number($attributeindex)]/attributeLabel ">
           <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeLabel "/>
           <xsl:text>&#160;(</xsl:text><xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName "/><xsl:text>)</xsl:text>
         </xsl:when>
         <xsl:otherwise>
           <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName "/>
         </xsl:otherwise>
       </xsl:choose>
     </xsl:variable>
     <!-- 
       begin the display -->
      <tr><td>
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
                  <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/></xsl:attribute>
                  <xsl:attribute name="class">datasetmenu</xsl:attribute>
                  <xsl:text>Back to Dataset  Summary  and Tabbed View</xsl:text>
                </xsl:element>
              </div>
              <div class="dataset-entity-part-backtos">
                <xsl:element name="a"> 
                  <xsl:attribute name="href">
                    <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of select="$entitytype"/>&amp;entityindex=<xsl:value-of select="$entityindex"/>
                  </xsl:attribute>
                  <xsl:attribute name="class">datasetmenu</xsl:attribute>
                  <xsl:text>Back to Data Table Description</xsl:text>
                </xsl:element>
              </div> 
            </td>
          </tr>
        </table>  
        
     <!-- <h3>Attribute Domain</h3> -->
      </td></tr>
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
         <xsl:when test="*/attributeList/attribute[number($attributeindex)]/attributeLabel ">
           <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeLabel "/>
           <xsl:text>&#160;(</xsl:text><xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName "/><xsl:text>)</xsl:text>
         </xsl:when>
         <xsl:otherwise>
           <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName "/>
         </xsl:otherwise>
       </xsl:choose>
     </xsl:variable>
     <!-- 
       begin the display -->
     <tr><td>
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
                 <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/></xsl:attribute>
                 <xsl:attribute name="class">datasetmenu</xsl:attribute>
                 <xsl:text>Back to Dataset  Summary  and Tabbed View</xsl:text>
               </xsl:element>
             </div>
             <div class="dataset-entity-part-backtos">
               <xsl:element name="a"> 
                 <xsl:attribute name="href">
                   <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of select="$entitytype"/>&amp;entityindex=<xsl:value-of select="$entityindex"/>
                 </xsl:attribute>
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
         <xsl:when test="*/attributeList/attribute[number($attributeindex)]/attributeLabel ">
           <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeLabel "/>
           <xsl:text>&#160;(</xsl:text><xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName "/><xsl:text>)</xsl:text>
         </xsl:when>
         <xsl:otherwise>
           <xsl:value-of select="*/attributeList/attribute[number($attributeindex)]/attributeName "/>
         </xsl:otherwise>
       </xsl:choose>
     </xsl:variable>
     <!-- 
       begin the display -->
     <tr><td>
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
                 <xsl:attribute name="href"><xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/></xsl:attribute>
                 <xsl:attribute name="class">datasetmenu</xsl:attribute>
                 <xsl:text>Back to Dataset  Summary  and Tabbed View</xsl:text>
               </xsl:element>
              </div>
             <div class="dataset-entity-part-backtos">
             <xsl:element name="a"> 
             <xsl:attribute name="href">
             <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of select="$entitytype"/>&amp;entityindex=<xsl:value-of select="$entityindex"/>
             </xsl:attribute>
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
      <xsl:when test="$entitytype=''">
        <xsl:variable name="dataTableCount" select="0"/>
        <xsl:variable name="spatialRasterCount" select="0"/>
        <xsl:variable name="spatialVectorCount" select="0"/>
        <xsl:variable name="storedProcedureCount" select="0"/>
        <xsl:variable name="viewCount" select="0"/>
        <xsl:variable name="otherEntityCount" select="0"/>
        <xsl:for-each select="dataTable|spatialRaster|spatialVector|storedProcedure|view|otherEntity">

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
               <xsl:when test="$displaymodule='attributedetail'">
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
               <xsl:when test="$displaymodule='attributedetail'">
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
               <xsl:when test="$displaymodule='attributedetail'">
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
               <xsl:when test="$displaymodule='attributedetail'">
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
               <xsl:when test="$displaymodule='attributedetail'">
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
               <xsl:when test="$displaymodule='attributedetail'">
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
     <xsl:when test="$displaymodule='attributedetail'">
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


   <xsl:template name="chooseentity" match='dataset'>
      <xsl:param name="entityindex"/>
      <xsl:param name="entitytype"/>
     <xsl:if test="$entitytype='dataTable'">
        <xsl:for-each select="dataTable">
            <xsl:if test="position()=$entityindex">
                   <xsl:choose>
                     <xsl:when test="references!=''">
                        <xsl:variable name="ref_id" select="references"/>
                        <xsl:variable name="references" select="$ids[@id=$ref_id]" />
                          <xsl:for-each select="$references">
                              <xsl:choose>
                                 <xsl:when test="$displaymodule='entity'">
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
                                 <xsl:when test="$displaymodule='entity'">
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
      <xsl:if test="$entitytype='spatialRaster'">
        <xsl:for-each select="spatialRaster">
            <xsl:if test="position()=$entityindex">
                   <xsl:choose>
                     <xsl:when test="references!=''">
                        <xsl:variable name="ref_id" select="references"/>
                        <xsl:variable name="references" select="$ids[@id=$ref_id]" />
                          <xsl:for-each select="$references">
                              <xsl:choose>
                                 <xsl:when test="$displaymodule='entity'">
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
                                 <xsl:when test="$displaymodule='entity'">
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
      <xsl:if test="$entitytype='spatialVector'">
        <xsl:for-each select="spatialVector">
            <xsl:if test="position()=$entityindex">
                   <xsl:choose>
                     <xsl:when test="references!=''">
                        <xsl:variable name="ref_id" select="references"/>
                        <xsl:variable name="references" select="$ids[@id=$ref_id]" />
                          <xsl:for-each select="$references">
                              <xsl:choose>
                                 <xsl:when test="$displaymodule='entity'">
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
                                 <xsl:when test="$displaymodule='entity'">
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
      <xsl:if test="$entitytype='storedProcedure'">
        <xsl:for-each select="storedProcedure">
            <xsl:if test="position()=$entityindex">
                   <xsl:choose>
                     <xsl:when test="references!=''">
                        <xsl:variable name="ref_id" select="references"/>
                        <xsl:variable name="references" select="$ids[@id=$ref_id]" />
                          <xsl:for-each select="$references">
                              <xsl:choose>
                                 <xsl:when test="$displaymodule='entity'">
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
                                 <xsl:when test="$displaymodule='entity'">
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
      <xsl:if test="$entitytype='view'">
        <xsl:for-each select="view">
            <xsl:if test="position()=$entityindex">
                   <xsl:choose>
                     <xsl:when test="references!=''">
                        <xsl:variable name="ref_id" select="references"/>
                        <xsl:variable name="references" select="$ids[@id=$ref_id]" />
                          <xsl:for-each select="$references">
                              <xsl:choose>
                                 <xsl:when test="$displaymodule='entity'">
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
                                 <xsl:when test="$displaymodule='entity'">
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
      <xsl:if test="$entitytype='otherEntity'">
        <xsl:for-each select="otherEntity">
            <xsl:if test="position()=$entityindex">
                   <xsl:choose>
                     <xsl:when test="references!=''">
                        <xsl:variable name="ref_id" select="references"/>
                        <xsl:variable name="references" select="$ids[@id=$ref_id]" />
                          <xsl:for-each select="$references">
                              <xsl:choose>
                                 <xsl:when test="$displaymodule='entity'">
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
                                 <xsl:when test="$displaymodule='entity'">
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
         <xsl:when test="references!=''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id=$ref_id]" />
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
    <xsl:if test="position()=$attributeindex">
      <xsl:if test="$displaymodule='attributedomain'">
        <xsl:for-each select="measurementScale/*/*">
          <xsl:call-template name="nonNumericDomain">
              <xsl:with-param name="nondomainfirstColStyle" select="$firstColStyle"/>
           </xsl:call-template>
        </xsl:for-each>
     </xsl:if>
     <xsl:if test="$displaymodule='attributecoverage'">
        <xsl:for-each select="coverage">
          <xsl:call-template name="coverage">
            <xsl:with-param name="coveragefirstColStyle" select="$firstColStyle"/>
          </xsl:call-template>
        </xsl:for-each>
     </xsl:if>
     <xsl:if test="$displaymodule='attributemethod'">
        <xsl:for-each select="method | methods"> <!-- mob kludge for eml2.1 -->
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
      <tr><td>
      <h3>Data (inline):</h3>
      </td></tr>
      <tr>
     <td>
      <xsl:if test="$distributionlevel='toplevel'">
         <xsl:for-each select="distribution">
            <xsl:if test="position()=$distributionindex">
               <xsl:choose>
                 <xsl:when test="references!=''">
                    <xsl:variable name="ref_id1" select="references"/>
                    <xsl:variable name="references1" select="$ids[@id=$ref_id1]" />
                    <xsl:for-each select="$references1">
                        <xsl:for-each select="inline">
                          <pre>
                            <xsl:value-of  select="." xml:space="preserve"/>
                          </pre>
                          <!--   <xsl:value-of select="."/> -->
                        </xsl:for-each>
                    </xsl:for-each>
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:for-each select="inline">
                       <pre>
                            <xsl:value-of  select="." xml:space="preserve"/>
                          </pre>
                        <!--    <xsl:value-of select="."/> -->
                     </xsl:for-each>
                 </xsl:otherwise>
               </xsl:choose>
            </xsl:if>
         </xsl:for-each>
      </xsl:if>
      <xsl:if test="$distributionlevel='entitylevel'">
        <xsl:if test="$entitytype='dataTable'">
          <xsl:for-each select="dataTable">
            <xsl:if test="position()=$entityindex">
                <xsl:choose>
                 <xsl:when test="references!=''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id=$ref_id2]" />
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
        <xsl:if test="$entitytype='spatialRaster'">
          <xsl:for-each select="spatialRaster">
            <xsl:if test="position()=$entityindex">
                <xsl:choose>
                 <xsl:when test="references!=''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id=$ref_id2]" />
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
        <xsl:if test="$entitytype='spatialVector'">
          <xsl:for-each select="spatialVector">
            <xsl:if test="position()=$entityindex">
                <xsl:choose>
                 <xsl:when test="references!=''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id=$ref_id2]" />
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
        <xsl:if test="$entitytype='storedProcedure'">
          <xsl:for-each select="storedProcedure">
            <xsl:if test="position()=$entityindex">
                <xsl:choose>
                 <xsl:when test="references!=''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id=$ref_id2]" />
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
        <xsl:if test="$entitytype='view'">
          <xsl:for-each select="view">
            <xsl:if test="position()=$entityindex">
                <xsl:choose>
                 <xsl:when test="references!=''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id=$ref_id2]" />
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
        <xsl:if test="$entitytype='otherEntity'">
          <xsl:for-each select="otherEntity">
            <xsl:if test="position()=$entityindex">
                <xsl:choose>
                 <xsl:when test="references!=''">
                    <xsl:variable name="ref_id2" select="references"/>
                    <xsl:variable name="references2" select="$ids[@id=$ref_id2]" />
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
   <xsl:if test="position()=$physicalindex">
      <xsl:choose>
         <xsl:when test="references!=''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id=$ref_id]" />
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
   <xsl:if test="$distributionindex=position()">
      <xsl:choose>
         <xsl:when test="references!=''">
            <xsl:variable name="ref_id" select="references"/>
            <xsl:variable name="references" select="$ids[@id=$ref_id]" />
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
       <xsl:when test="$displaymodule='inlinedata'">
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
       <xsl:when test="$displaymodule='inlinedata'">
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
       <xsl:when test="$displaymodule='inlinedata'">
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
           <a><xsl:attribute name="href">
             <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/>&amp;displaymodule=additionalmetadata&amp;additionalmetadataindex=<xsl:value-of select="$index"/>
           </xsl:attribute>
             Additional Metadata
           </a>
         </td>
       </tr>
     </table>
   </xsl:template>
     <!--********************************************************
             download xml part
       ********************************************************-->
   <xsl:template name="xml">
     <xsl:param name="index"/>
        <br />
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$xmlURI"/>
            <xsl:value-of select="$docid"/>
          </xsl:attribute>
          Download the original XML file (in Ecological Metadata Language)
        </a>
		Viewable in <a href="http://www.oxygenxml.com" title="Oxygen XML Editor"><img src="http://www.oxygenxml.com/img/resources/oxygen190x62.png" width="95" height="31" alt="Oxygen XML Editor" border="0"/></a>
   </xsl:template>
</xsl:stylesheet>
