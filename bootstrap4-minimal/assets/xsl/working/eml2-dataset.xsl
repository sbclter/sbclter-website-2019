<!--
  *  '$RCSfile: eml-dataset-2.0.0.xsl,v $'
  *      Authors: Matt Jones
  *    Copyright: 2000 Regents of the University of California and the
  *               National Center for Ecological Analysis and Synthesis
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


  <xsl:output method="html" encoding="iso-8859-1"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>

  <xsl:template match="dataset" mode="dataset">    
    <xsl:param name="packageID"/>
    <div itemscope="" itemtype="http://schema.org/Dataset">
    <!--  debug:  <xsl:value-of select="$packageID"/> line 43 dataset.xsl -->
    <xsl:choose>
      <xsl:when test="references!=''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id=$ref_id]"/>
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
      </div> <!-- closes schema.org micromarkup itemscope, itemtype -->
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
        <td width="1%" class="empty">&#160;</td>

        <td width="20%" class="datasetmixed">
          <xsl:choose>
            <xsl:when test="$currentmodule='datasetmixed' ">
              <xsl:attribute name="class">highlight</xsl:attribute> Summary and Data Links </xsl:when>
            <xsl:otherwise>
              <a class="datasetmenu">
                <xsl:attribute name="href">
                  <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/>
                </xsl:attribute>Summary and Data Links </a>
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
            <xsl:when test="$currentmodule='responsibleparties' ">
              <xsl:attribute name="class">highlight</xsl:attribute> People and Organizations </xsl:when>
            <xsl:otherwise>
              <a class="datasetmenu">
                <xsl:attribute name="href">
                  <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"
                  /><xsl:text>&amp;displaymodule=responsibleparties</xsl:text>
                </xsl:attribute>People and Organizations </a>
            </xsl:otherwise>
          </xsl:choose>

        </td>

        <td width="38%" class="coverageall">
          <xsl:choose>
            <xsl:when test="$currentmodule='coverageall'  ">
              <xsl:attribute name="class">highlight</xsl:attribute> Temporal, Geographic and
              Taxonomic Coverage </xsl:when>
            <xsl:otherwise>
              <a class="datasetmenu">
                <xsl:attribute name="href">
                  <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"
                  /><xsl:text>&amp;displaymodule=coverageall</xsl:text>
                </xsl:attribute>Temporal, Geographic and Taxonomic Coverage </a>
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <td width="20%" class="methodsall">
          <xsl:choose>
            <xsl:when test="$currentmodule='methodsall'  ">
              <xsl:attribute name="class">highlight</xsl:attribute> Methods and Protocols </xsl:when>
            <xsl:otherwise>
              <a class="datasetmenu">
                <xsl:attribute name="href">
                  <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"
                  /><xsl:text>&amp;displaymodule=methodsall</xsl:text>
                </xsl:attribute>Methods and Protocols </a>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td width="1%" class="empty">&#160;</td>
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
          <xsl:if test="dataTable|spatialRaster|spatialVector|storedProcedure|view|otherEntity or creator">
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
              select="count(dataTable|spatialRaster|spatialVector|storedProcedure|view|otherEntity)"/>
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
            <xsl:if test="dataTable|spatialRaster|spatialVector|storedProcedure|view|otherEntity">
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
          </xsl:if>          <!-- closes if dataTable, etc -->
          <br/>          <!--  find the table class with correct spacing! -->
        </td>        
      </tr>
      
    </table>
    <!-- 
  
  END OF FIRST SECTION
  -->
  <!-- 
      
      
      
      
      dataset citation  -->
    <h3>Data Set Citation</h3>
    <xsl:if test="$displaymodule='dataset'">
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
                      <xsl:otherwise> </xsl:otherwise>
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




<!-- 
    march 2014. moved this to its own template 
    a template to show the people in a small table, for the main page. this one shows only names, in sbc's prefered order -->
<xsl:template name="datasetpeople_summary">
<!-- left the table element behind, to be a little more consistent with other templates which are mainly rows. -->
    <tr>
      <th colspan="2">People and Organizations:</th>
    </tr>
    <tr>
      <td colspan="2">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"
            /><xsl:text>&amp;displaymodule=responsibleparties</xsl:text>
          </xsl:attribute>View complete information for all parties </a>
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
                  <xsl:text>,&#160;</xsl:text>
                  <xsl:for-each select="givenName">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                  </xsl:for-each>
                </xsl:if>
                <xsl:if test="../organizationName or ../positionName">
                  <xsl:text>(</xsl:text>
                  <xsl:choose>
                    <xsl:when test="../organizationName and ../positionName">
                      <xsl:value-of select="../organizationName"/>
                      <xsl:text>,&#160;</xsl:text>
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
                    <xsl:text>&#160;(</xsl:text>
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
          <xsl:text>&#160;</xsl:text>
          <xsl:if test="electronicMailAddress">[&#160; <a>
            <xsl:attribute name="href"><xsl:text>mailto:</xsl:text>
              <xsl:value-of select="electronicMailAddress"/>
            </xsl:attribute>email</a>&#160;] </xsl:if>
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
                  <xsl:text>,&#160;</xsl:text>
                  <xsl:for-each select="givenName">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                  </xsl:for-each>
                </xsl:if>
                <xsl:if test="../organizationName or ../positionName">
                  <xsl:text>(</xsl:text>
                  <xsl:choose>
                    <xsl:when test="../organizationName and ../positionName">
                      <xsl:value-of select="../organizationName"/>
                      <xsl:text>,&#160;</xsl:text>
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
                    <xsl:text>,&#160;</xsl:text>
                    <xsl:for-each select="givenName">
                      <xsl:value-of select="."/>
                      <xsl:text>&#160;</xsl:text>
                    </xsl:for-each>
                  </xsl:if>
                  <xsl:if test="../organizationName or ../positionName">
                    <xsl:text>(</xsl:text>
                    <xsl:choose>
                      <xsl:when test="../organizationName and ../positionName">
                        <xsl:value-of select="../organizationName"/>
                        <xsl:text>,&#160;</xsl:text>
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
        <td class="{$firstColStyle}"> &#160; </td>
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
    <xsl:if test="comment and normalize-space(comment)!=''">
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
 
  
 
  <!-- 
  
  
  
  
  TO DO
  
  Refactored this template . rename when done.
  -->
  <xsl:template name="datasetentity">
    <xsl:param name="show_entity_description"></xsl:param>
    <xsl:param name="add_entity_scrollbar"></xsl:param>
     
    <!-- a header for all entities. -->
    <tr>
      <th colspan="2">
        <xsl:text>Detailed Data Description and Download:</xsl:text>
      </th>
    </tr>   
    <tr>
      <td>
        <xsl:element name="div">
          <xsl:if test="$add_entity_scrollbar='true'">
            <xsl:attribute name="class">scroll-if-too-long</xsl:attribute>
          </xsl:if>     
          <table>    
            <!-- you can't factor out the type. indexes have to be within type. order within dataset is preserved elsewhere. -->
            <xsl:for-each select="dataTable">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">dataTable</xsl:with-param>
                <xsl:with-param name="typelabel">Data Table</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"></xsl:with-param>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="spatialRaster">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">spatialRaster</xsl:with-param>
                <xsl:with-param name="typelabel">Spatial Raster</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"></xsl:with-param>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="spatialVector">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">spatialVector</xsl:with-param>
                <xsl:with-param name="typelabel">Spatial Vector</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"></xsl:with-param>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="storedProcedure">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">storedProcedure</xsl:with-param>
                <xsl:with-param name="typelabel">Stored Procedure</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"></xsl:with-param>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="view">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">view</xsl:with-param>
                <xsl:with-param name="typelabel">View</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"></xsl:with-param>
                <xsl:with-param name="index" select="position()"/>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="otherEntity">
              <xsl:call-template name="entityurl">
                <xsl:with-param name="type">otherEntity</xsl:with-param>
                <xsl:with-param name="typelabel">Other</xsl:with-param>
                <xsl:with-param name="show_entity_description" select="$show_entity_description"></xsl:with-param>
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
  

  <!-- 
    
    2 col structure,  a link to dataTable in col2-->
  <xsl:template name="entityurl">
     <xsl:param name="typelabel"/> 
    <xsl:param name="type"/>
    <xsl:param name="index"/>
    <xsl:param name="show_entity_description"/>
    
  
    <xsl:choose>
      <xsl:when test="references!=''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id=$ref_id]"/>
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
                <xsl:attribute name="href">
                  <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"
                    />&amp;displaymodule=entity&amp;entitytype=<xsl:value-of select="$type"
                    />&amp;entityindex=<xsl:value-of select="$index"/>
                </xsl:attribute>
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
              <xsl:attribute name="href">
                <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"
                  />&amp;displaymodule=entity&amp;entitytype=<xsl:value-of select="$type"
                  />&amp;entityindex=<xsl:value-of select="$index"/>
              </xsl:attribute>
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


<!-- 
  
  
  
  ORIGINALS-->
 
  <xsl:template name="datasetentity_old">
    <xsl:param name="show_entity_description"></xsl:param>
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
        <xsl:with-param name="show_entity_description"></xsl:with-param>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="spatialRaster">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">spatialRaster</xsl:with-param>
        <xsl:with-param name="showtype">Spatial Raster</xsl:with-param>
        <xsl:with-param name="show_entity_description"></xsl:with-param>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="spatialVector">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">spatialVector</xsl:with-param>
        <xsl:with-param name="showtype">Spatial Vector</xsl:with-param>
        <xsl:with-param name="show_entity_description"></xsl:with-param>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="storedProcedure">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">storedProcedure</xsl:with-param>
        <xsl:with-param name="showtype">Stored Procedure</xsl:with-param>
        <xsl:with-param name="show_entity_description"></xsl:with-param>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="view">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">view</xsl:with-param>
        <xsl:with-param name="showtype">View</xsl:with-param>
        <xsl:with-param name="show_entity_description"></xsl:with-param>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="otherEntity">
      <xsl:call-template name="entityurl">
        <xsl:with-param name="type">otherEntity</xsl:with-param>
        <xsl:with-param name="showtype">Other</xsl:with-param>
        <xsl:with-param name="show_entity_description"></xsl:with-param>
        <xsl:with-param name="index" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  
  <xsl:template name="entityurl_old">
    <xsl:param name="showtype"/>
    <xsl:param name="type"/>
    <xsl:param name="index"/>
    <xsl:choose>
      <xsl:when test="references!=''">
        <xsl:variable name="ref_id" select="references"/>
        <xsl:variable name="references" select="$ids[@id=$ref_id]" />
        <xsl:for-each select="$references">
          <tr>
            <td class="{$firstColStyle}">
              <em class="bold"><xsl:value-of select="$showtype"/><xsl:text>: </xsl:text></em>
              <br></br>
              <!--    <xsl:text>(Follow link)</xsl:text> --> 
            </td>
            <td class="{secondColStyle}">
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of select="$type"/>&amp;entityindex=<xsl:value-of select="$index"/>
                </xsl:attribute>
                <xsl:value-of select="./entityName"/>
              </a>
              <br></br>
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
                <xsl:attribute name="value"><xsl:value-of select="$docid"/></xsl:attribute>
              </input>
              <input type="hidden" name="displaymodule" >
                <xsl:attribute name="value">entity</xsl:attribute></input>
              <input type="hidden" name="entitytype">
                <xsl:attribute name="value"><xsl:value-of select="$type"/></xsl:attribute>
              </input>
              <input type="hidden" name="entityindex">
                <xsl:attribute name="value"> <xsl:value-of select="$index"/></xsl:attribute>
              </input>
              
              <input type="submit"  class="view-data-button">
                
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
              <xsl:attribute name="href">
                <xsl:value-of select="$tripleURI"/><xsl:value-of select="$docid"/>&amp;displaymodule=entity&amp;entitytype=<xsl:value-of select="$type"/>&amp;entityindex=<xsl:value-of select="$index"/>
              </xsl:attribute>
              <xsl:value-of select="./entityName"/>
            </a>
            <br></br>
            <xsl:value-of select="./entityDescription"/>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
