<?xml version="1.0"?>
<!--
  *  '$RCSfile: eml-attribute-enumeratedDomain-2.0.0.xsl,v $'
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
  * convert an XML file that is valid with respect to the eml-variable.dtd
  * module of the Ecological Metadata Language (EML) into an HTML format
  * suitable for rendering with modern web browsers.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" encoding="iso-8859-1"
              doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
              doctype-system="http://www.w3.org/TR/html4/loose.dtd"
              indent="yes" />  

   <xsl:template name="nonNumericDomain">
     <xsl:param name="nondomainfirstColStyle"/>
     <table class="{$tabledefaultStyle}">
        <xsl:choose>
         <xsl:when test="references!=''">
          <xsl:variable name="ref_id" select="references"/>
          <xsl:variable name="references" select="$ids[@id=$ref_id]" />
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
       <tr><td class="{$nondomainfirstColStyle}"><b>Text Domain</b></td>
            <td class="{$secondColStyle}">&#160;
            </td>
       </tr>
       <tr><td class="{$nondomainfirstColStyle}">Definition</td>
            <td class="{$secondColStyle}"><xsl:value-of select="definition"/>
            </td>
        </tr>
        <xsl:for-each select="parttern">
          <tr><td class="{$nondomainfirstColStyle}">Pattern</td>
            <td class="{$secondColStyle}"><xsl:value-of select="."/>
            </td>
          </tr>
        </xsl:for-each>
        <xsl:if test="source">
          <tr><td class="{$nondomainfirstColStyle}">Source</td>
            <td class="{$secondColStyle}"><xsl:value-of select="source"/>
            </td>
          </tr>
        </xsl:if>
  </xsl:template>

  <xsl:template name="enumeratedDomain">
     <xsl:param name="nondomainfirstColStyle"/>
     <xsl:if test="codeDefinition">
        <tr><td class="{$nondomainfirstColStyle}"><b>Enumerated Domain</b></td>
            <td class="{$secondColStyle}">&#160;
            </td>
       </tr>
       <xsl:for-each select="codeDefinition">
              <tr><td class="{$nondomainfirstColStyle}">Code Definition</td>
                   <td>
                      <table class="{$tabledefaultStyle}">
                          <tr><td class="{$nondomainfirstColStyle}">
                               Code
                              </td>
                               <td class="{$secondColStyle}"><xsl:value-of select="code"/></td>

                           </tr>
                           <tr><td class="{$nondomainfirstColStyle}">
                               Definition
                              </td>
                               <td class="{$secondColStyle}"><xsl:value-of select="definition"/></td>

                           </tr>
                           <tr><td class="{$nondomainfirstColStyle}">
                               Source
                              </td>
                               <td class="{$secondColStyle}"><xsl:value-of select="source"/></td>
                          </tr>
                      </table>
                   </td>
               </tr>
         </xsl:for-each>
     </xsl:if>
     <xsl:if test="externalCodeSet">
        <tr><td class="{$nondomainfirstColStyle}"><b>Enumerated Domain(External Set)</b></td>
            <td>&#160;
           </td>
        </tr>
        <tr><td class="{$nondomainfirstColStyle}">Set Name:</td>
            <td class="{$secondColStyle}"><xsl:value-of select="externalCodeSet/codesetName"/>
           </td>
        </tr>
        <xsl:for-each select="externalCodeSet/citation">
           <tr><td class="{$nondomainfirstColStyle}">Citation:</td>
               <td>
                  <xsl:call-template name="citation">
                      <xsl:with-param name="citationfirstColStyle" select="$nondomainfirstColStyle"/>
                   </xsl:call-template>
               </td>
           </tr>
        </xsl:for-each>
        <xsl:for-each select="externalCodeSet/codesetURL">
           <tr><td class="{$nondomainfirstColStyle}">URL</td>
               <td class="{$secondColStyle}">
                 <a><xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a>
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
      <tr><td class="{$nondomainfirstColStyle}" colspan="2"><b>The allowed values and their definitions can be found in another data entity in this package. 
        Please follow link to description, then download:</b></td>
      <!--   <td class="{$secondColStyle}">&#160;
        </td> -->
      </tr>
 
      <tr>
        <td class="{$nondomainfirstColStyle}">Data link:</td>
        <td>  <table  class="subGroup onehundred_percent {$tabledefaultStyle}">
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
          <xsl:for-each select="//dataTable[@id=$entity_ref]">
            <xsl:variable name="entity_position"><xsl:number/></xsl:variable>
            <xsl:call-template name="entityurl">
              <xsl:with-param name="type">dataTable</xsl:with-param>
              <xsl:with-param name="showtype">Data Table</xsl:with-param>
              <xsl:with-param name="index" select="$entity_position"/>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:for-each select="//spatialRaster[@id=$entity_ref]">
            <xsl:variable name="entity_position"><xsl:number/></xsl:variable>
            <xsl:call-template name="entityurl">
              <xsl:with-param name="type">spatialRaster</xsl:with-param>
              <xsl:with-param name="showtype">Spatial Raster</xsl:with-param>
              <xsl:with-param name="index" select="$entity_position"/>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:for-each select="//spatialVector[@id=$entity_ref]">
            <xsl:variable name="entity_position"><xsl:number/></xsl:variable>
            <xsl:call-template name="entityurl">
              <xsl:with-param name="type">spatialVector</xsl:with-param>
              <xsl:with-param name="showtype">Spatial Vector</xsl:with-param>
              <xsl:with-param name="index" select="$entity_position"/>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:for-each select="//storedProcedure[@id=$entity_ref]">
            <xsl:variable name="entity_position"><xsl:number/></xsl:variable>
            <xsl:call-template name="entityurl">
              <xsl:with-param name="type">storedProcedure</xsl:with-param>
              <xsl:with-param name="showtype">Stored Procedure</xsl:with-param>
              <xsl:with-param name="index" select="$entity_position"/>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:for-each select="//view[@id=$entity_ref]">
            <xsl:variable name="entity_position"><xsl:number/></xsl:variable>
            <xsl:call-template name="entityurl">
              <xsl:with-param name="type">view</xsl:with-param>
              <xsl:with-param name="showtype">View</xsl:with-param>
              <xsl:with-param name="index" select="$entity_position"/>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:for-each select="//otherEntity[@id=$entity_ref]">
            <xsl:variable name="entity_position"><xsl:number/></xsl:variable>
            <xsl:call-template name="entityurl">
              <xsl:with-param name="type">otherEntity</xsl:with-param>
              <xsl:with-param name="showtype">Other</xsl:with-param>
              <xsl:with-param name="index" select="$entity_position"/>
            </xsl:call-template>
          </xsl:for-each>
  
        </table>
  
        </td>
        
      </tr>
      
      
      
      
      
      
      <tr><td class="{$nondomainfirstColStyle}">Code value can be found in:</td>
        <td class="{$secondColStyle}">
           <xsl:variable name="attribute_val_ref" select="entityCodeList/valueAttributeReference"/>
          <xsl:choose>
            <xsl:when test="//*/attributeLabel[../@id=$attribute_val_ref]">
          <xsl:value-of select="//*/attributeLabel[../@id=$attribute_val_ref]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//*/attributeName[../@id=$attribute_val_ref]"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr><td class="{$nondomainfirstColStyle}">Code definition can be found in</td>
        <td class="{$secondColStyle}">
          <xsl:variable name="attribute_def_ref" select="entityCodeList/definitionAttributeReference"/>
          <xsl:choose>
            <xsl:when test="//*/attributeLabel[../@id=$attribute_def_ref]">
              <xsl:value-of select="//*/attributeLabel[../@id=$attribute_def_ref]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//*/attributeName[../@id=$attribute_def_ref]"/>
            </xsl:otherwise>
          </xsl:choose>
          
        </td>
      </tr>
    </xsl:if>
    
    
  </xsl:template>


</xsl:stylesheet>
