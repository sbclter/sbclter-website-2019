<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- 2019-05-07 margaret obrien, EDI & SBC LTER -->
    
    <!--
    Stylesheet combines all the imports from the original EML 2 transformation files into
    one large file, that can be passed to javascript for client-side transform to HTML.
    This means that individual files can still be module-based, and contributed by anyone.
    
    To create a merged file of all imports use an XSLT processor, e.g.,  
    bash-3.2$ xsltproc merge_imports.xsl eml2.xsl > ../eml2-templates-all.xsl

    -->
      
    <!-- when you have time, or there are major changes ... 
    you could build up the list of files (imports), to loop thru and copy templates from 
     but this way, you have better control over the order, 
     which might matter. (although they appear to be aphabetical). 
    also note the settings.xsl, which if client side transform is in javascript, 
    would be kept elsewhere (yaml) and variables fed in. for now, it's here, as a placeholder -->
    
    
<!--     <xsl:variable name="eml-TODO" select="document('filename.xsl')"/> -->
    <xsl:variable name="eml-access" select="document('eml2-access.xsl')"/>
    <xsl:variable name="eml-additionalmetadata" select="document('eml2-additionalmetadata.xsl')"/>
    <xsl:variable name="eml-attribute" select="document('eml2-attribute.xsl')"/>
    <xsl:variable name="eml-attribute-enumeratedDomain"
        select="document('eml2-attribute-enumeratedDomain.xsl')"/>
    <xsl:variable name="eml-constraint" select="document('eml2-constraint.xsl')"/>
    <xsl:variable name="eml-coverage" select="document('eml2-coverage.xsl')"/>
    <xsl:variable name="eml-dataset" select="document('eml2-dataset.xsl')"/>
    <xsl:variable name="eml-datatable" select="document('eml2-datatable.xsl')"/>
    <xsl:variable name="eml-distribution" select="document('eml2-distribution.xsl')"/>
    <xsl:variable name="eml-entity" select="document('eml2-entity.xsl')"/>
    <xsl:variable name="eml-identifier" select="document('eml2-identifier.xsl')"/>
    <xsl:variable name="eml-literature" select="document('eml2-literature.xsl')"/>
    <xsl:variable name="eml-method" select="document('eml2-method.xsl')"/>
    <xsl:variable name="eml-otherentity" select="document('eml2-otherentity.xsl')"/>
    <xsl:variable name="eml-party" select="document('eml2-party.xsl')"/>
    <xsl:variable name="eml-physical" select="document('eml2-physical.xsl')"/>
    <xsl:variable name="eml-project" select="document('eml2-project.xsl')"/>
    <xsl:variable name="eml-protocol" select="document('eml2-protocol.xsl')"/>
    <xsl:variable name="eml-resource" select="document('eml2-resource.xsl')"/>
    <xsl:variable name="eml-software" select="document('eml2-software.xsl')"/>
    <xsl:variable name="eml-spatialraster" select="document('eml2-spatialraster.xsl')"/>
    <xsl:variable name="eml-spatialvector" select="document('eml2-spatialvector.xsl')"/>
    <xsl:variable name="eml-storedprocedure" select="document('eml2-storedprocedure.xsl')"/>
    <xsl:variable name="eml-text" select="document('eml2-text.xsl')"/>
    <xsl:variable name="eml-view" select="document('eml2-view.xsl')"/>
    <xsl:variable name="eml-howtoCite" select="document('eml2-howtoCite.xsl')"/>
    <xsl:variable name="eml-geoCov_draw_map" select="document('eml2-geoCov_draw_map.xsl')"/>
   
    
    <xsl:variable name="eml-settings" select="document('eml2-settings.xsl')"/>
    
      

    <!-- copy paradigm 
  copy the amin eml2.xsl, then change as appropriate -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node() [not(self::xsl:import)]" />
        </xsl:copy>
    </xsl:template>


    <!--template matches the last template in eml2.xsl.
      copy it explictly, then add templates from imports below
  -->
    <xsl:template match="xsl:stylesheet/xsl:template[last()]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>

        <xsl:comment>
       ********************************************************
             adding ACCESS templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-access//xsl:stylesheet/xsl:template"/>
        
        <xsl:comment>
       ********************************************************
             adding ADDITIONAL METADATA templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-additionalmetadata//xsl:stylesheet/xsl:template"/>
        
        <xsl:comment>
       ********************************************************
             adding ATTRIBUTE templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-attribute//xsl:stylesheet/xsl:template"/>
        
        <xsl:comment>
       ********************************************************
             adding ATTRIBUTE ENUM DOMAIN templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-attribute-enumeratedDomain//xsl:stylesheet/xsl:template"/>
        
        <xsl:comment>
       ********************************************************
             adding CONSTRAINT templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-constraint//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding COVERAGE templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-coverage//xsl:stylesheet/xsl:template"/>
        
        <xsl:comment>
       ********************************************************
             adding DATASET templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-dataset//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding DATATABLE templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-datatable//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding DISTRIBTUION templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-distribution//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding ENTITY templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-entity//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding IDENTIFIER templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-identifier//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding LITERATURE templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-literature//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding METHOD templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-method//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding OTHERENTITY templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-otherentity//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding PARTY templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-party//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding PHSYICAL templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-physical//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding PROJECT templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-project//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding PROTOCOL templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-protocol//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding RESOURCE templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-resource//xsl:stylesheet/xsl:template"/>
         
        
        <xsl:comment>
       ********************************************************
             adding SOFTWARE templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-software//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding SPATIAL RASTER templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-spatialraster//xsl:stylesheet/xsl:template"/>
        
        <xsl:comment>
       ********************************************************
             adding SPATIAL VECTOR templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-spatialvector//xsl:stylesheet/xsl:template"/>
   
   
        <xsl:comment>
       ********************************************************
             adding TEXT templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-text//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding VEIW templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-view//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding HOW TO CITE templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-howtoCite//xsl:stylesheet/xsl:template"/>
        
        
        <xsl:comment>
       ********************************************************
             adding GEOCOV DRAW MAP templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-geoCov_draw_map//xsl:stylesheet/xsl:template"/>
        
        <xsl:comment>
       ********************************************************
             SETTING may go here  
             Generally these are configuration settings, 
             so probably better elsewhere. for now, a place holder.
       ********************************************************
         </xsl:comment>
        <!-- 
        <xsl:copy-of select="$eml-settings//xsl:stylesheet/xsl:template"/>
        -->
        
  <!-- template for a new set       
        <xsl:comment>
       ********************************************************
             adding TODO templates 
       ********************************************************
         </xsl:comment>
        <xsl:copy-of select="$eml-TODO//xsl:stylesheet/xsl:template"/>
        
        -->
        
        
        <!-- end of main template. -->
    </xsl:template>

</xsl:stylesheet>
