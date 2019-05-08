<?xml version="1.0"?>
<!--
  *  '$RCSfile: eml-text-2.0.0.xsl,v $'
  *      Authors: Matthew Brooke
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
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    indent="yes" />  

  <xsl:preserve-space elements="literalLayout"/>
  
<!-- This module is for text module in eml2 document. It is a table and self contained-->
  
  <!-- note: text type is mixed content, so template should be able to handle simple string content, too.
  maybe, if only text children, then use mode=lowlevel? NEED A REAL XSLT PROGRAMMER!
  -->

  <xsl:template name="text">
        <xsl:param name="textfirstColStyle" />
        <xsl:param name="textsecondColStyle" />
        <xsl:if test="(section and normalize-space(section)!='') or (para and normalize-space(para)!='')">
          <xsl:apply-templates mode="text">
            <xsl:with-param name="textfirstColStyle" select="$textfirstColStyle"/>
            <xsl:with-param name="textsecondColStyle" select="$textsecondColStyle" />
          </xsl:apply-templates>
      </xsl:if>
  </xsl:template>
  
  <xsl:template name="abstracttext">
    <xsl:param name="textfirstColStyle" />
    <xsl:param name="textsecondColStyle" />
    
    <xsl:if test="(section and normalize-space(section)!='') or (para and normalize-space(para)!='')">
  <!-- was <xsl:apply-templates mode="text"> (mgb 7Jun2011) use mode="lowlevel" to make abstract use p for para -->
    <div class="abstract-text">
      <xsl:apply-templates mode="text">
        <xsl:with-param name="textfirstColStyle" select="$textfirstColStyle"/>
        <xsl:with-param name="textsecondColStyle" select="$textsecondColStyle" />
      </xsl:apply-templates>
    </div>  
    </xsl:if>
    
  </xsl:template>


  <!-- *********************************************************************** -->
  <!-- Template for section-->
   <xsl:template match="section" mode="text">
      <xsl:if test="normalize-space(.)!=''">
        <xsl:if test="title and normalize-space(title)!=''">
          <!-- <h4 class="bold"><xsl:value-of select="title"/></h4> -->
	  <h4><xsl:value-of select="title"/></h4>
        </xsl:if>
        <xsl:if test="para and normalize-space(para)!=''">
              <xsl:apply-templates select="para" mode="text"/>
         </xsl:if>
         <xsl:if test="section and normalize-space(section)!=''">
              <xsl:apply-templates select="section" mode="text"/>
        </xsl:if>
      </xsl:if>
  </xsl:template>

  <!-- Section template for low level. Cteate a nested table and second column -->
  <xsl:template match="section" mode="lowlevel">
     <div>
      <xsl:if test="title and normalize-space(title)!=''">
        <!-- <h4 class="bold"><xsl:value-of select="title"/></h4>  -->
        <h5><xsl:value-of select="title"/></h5>
      </xsl:if>
      <xsl:if test="para and normalize-space(para)!=''">
        <xsl:apply-templates select="para" mode="lowlevel"/>
      </xsl:if>
      <xsl:if test="section and normalize-space(section)!=''">
        <xsl:apply-templates select="section" mode="lowlevel"/>
      </xsl:if>
     </div>
  </xsl:template>

  <!-- para template for text mode-->
   <xsl:template match="para" mode="text">
    <xsl:param name="textfirstColStyle"/>
     <p>
          <xsl:apply-templates/>
     </p>
     
     <!-- 
         <xsl:apply-templates mode="lowlevel"/>
         -->
  </xsl:template>

  <!-- para template without any other structure. It does actually transfer.
       Currently, only get the text and it need more revision-->
  <xsl:template match="para" mode="lowlevel">
      <p>
        <xsl:value-of select="."/>
      </p>
  </xsl:template>
  
  
  
   <xsl:template match="itemizedlist">
      <ul>
      <xsl:for-each select="listitem">
        <li><xsl:apply-templates select="."/></li>
      </xsl:for-each>
      </ul>
  </xsl:template>
  
  <xsl:template match="orderedlist">
    <ol>
      <xsl:for-each select="listitem">
        <li><xsl:value-of select="."/></li>
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
  
  
  <!-- note: EML is using docbook 4, citetitle is optional, unbounded. -->
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
     <xsl:value-of  select="." xml:space="preserve"/>
   </pre>
 </xsl:template>
  
</xsl:stylesheet>
