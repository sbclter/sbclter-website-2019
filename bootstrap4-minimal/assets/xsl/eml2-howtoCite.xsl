<?xml version="1.0"?>
<!--
  *  '$RCSfile: eml-identifier-2.0.0.xsl,v $'
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
<!-- How to cite a dataset  mgb 31May2011 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:ext="http://exslt.org/common">

  <xsl:output method="html" encoding="iso-8859-1"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>

  <!-- style the identifier and system -->
  <xsl:template name="howtoCite">
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
        <td class="{$citesecondColStyle}">
          <!-- count the creators, set a var -->
          <xsl:variable name="creator_count" select="count(creator/individualName)"/>
          <xsl:for-each select="creator/individualName">
            <!-- if this is the last author in a list, and not the first then prefix an "and" -->
            <xsl:if test="position()=last() and not(position()=1)"> and </xsl:if>
            <xsl:if test="not(position()=last()) and not(position()=1)">
              <xsl:text>,&#160;</xsl:text>
            </xsl:if>
            <xsl:if test="position()=1">
              <!-- for first author, put surname before initial(s) -->
              <xsl:value-of select="surName"/>
              <xsl:if test="givenName">
                <xsl:text>,&#160;</xsl:text>
                <xsl:for-each select="givenName">
                  <xsl:value-of select="substring(., 1, 1)"
                  /><xsl:text>.&#160;</xsl:text><!-- first initial followed by period -->
                </xsl:for-each>
              </xsl:if>
            </xsl:if>
            <xsl:if test="not(position()=1)">
              <!-- for any except first author, put initial(s) before surname -->
              <xsl:if test="givenName">
                <xsl:for-each select="givenName"><!-- the dot in the substring arg below is the givenName value -->
                  <xsl:value-of select="substring(., 1, 1)"/>
                  <!-- first initial -->
                </xsl:for-each>
                <xsl:text>.&#160;</xsl:text>
                <xsl:value-of select="surName"/>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
          <!-- 
            
            GET LOGIC FROM YOUR PUBS DISPLAY!!!   -->
          <xsl:choose>
            <xsl:when test="creator_count='1'">
              <xsl:choose>
                <xsl:when test="creator/individualName/givenName">
                  <!-- do nothing. the period following the initial will suffice.-->
                </xsl:when>
                <xsl:otherwise>
                  <!-- there is one creator, and no given name. eew. ugly, but oh well. add a period. -->
                  <xsl:text>.&#160;</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <!-- more than one creator. -->
              <xsl:text>.&#160;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="substring($pubDate,1,4)"/>. <xsl:value-of select="$datasetTitle"/><xsl:text>.&#160;</xsl:text>
          <xsl:choose>
            <xsl:when test="string-length($publisherOrganizationName)=0">
              <xsl:value-of select="$organizationName"/><xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$publisherOrganizationName"/>
              <xsl:text>.&#160;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <!-- 
            
            
            
            add 1 or more DOIs, if available, or some other default.. -->
          <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
          <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
          <!-- count up the number of DOIs -->
          <xsl:variable name="doi_count">
            <xsl:value-of
              select="count(alternateIdentifier[
              contains(translate(@system, $uppercase, $lowercase), 'doi') or 
              contains(translate(@system, $uppercase, $lowercase), 'digital object identifier')
              ])"/>
            <!-- if you have other patterns that identify a doi, add them to this list with 'or' -->
          </xsl:variable>
          <!-- 
            
            save for future testing.
          <xsl:text> DOI COUNT:</xsl:text>
          <xsl:value-of select="$doi_count"/>
          -->
          <!-- 
            
            depending on the number of DOIs found, call a display template with params. -->
          <xsl:choose>
            <xsl:when test="$doi_count=0">
              <xsl:call-template name="display_default_id">
                <xsl:with-param name="contextURL" select="$contextURL"/>
                <xsl:with-param name="packageID" select="$packageID"/>
              </xsl:call-template>
              <xsl:call-template name="request_doi">
                <xsl:with-param name="packageID" select="$packageID"/>
                <xsl:with-param name="datasetTitle" select="$datasetTitle"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <!-- at least one DOI found. -->
              <xsl:call-template name="display_dois">
                <xsl:with-param name="doi_count" select="$doi_count"/>
                <xsl:with-param name="lowercase" select="$lowercase"/>
                <xsl:with-param name="uppercase" select="$uppercase"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </xsl:template>
  <!-- 
  
  
  temolate for displaying a DOI  -->
  <xsl:template name="display_dois">
    <xsl:param name="doi_count"/>
    <xsl:param name="uppercase"/>
    <xsl:param name="lowercase"/>

    <xsl:for-each
      select="alternateIdentifier[
      contains(translate(@system, $uppercase, $lowercase), 'doi') or 
      contains(translate(@system, $uppercase, $lowercase), 'digital object identifier')
      ]">
      <xsl:text>doi:</xsl:text>
      <xsl:value-of select="."/>
      <!-- 
       separate with a comma if not the last doi in a list. -->
      <xsl:if test="not(position()=last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!-- 
    
    a template for a default message or url if no DOI. -->
  <xsl:template name="display_default_id">
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


<!-- 
  
  template adds an email link with the pkg id and title so the person can ask for the doi -->
<xsl:template name="request_doi">
  <xsl:param name="packageID"/>
  <xsl:param name="datasetTitle"/>
  <br/><br/>
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
  
  
</xsl:stylesheet>
