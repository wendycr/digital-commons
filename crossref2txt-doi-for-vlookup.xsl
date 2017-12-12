<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <!-- remove namespaces etc from doi_batch of xml file -->
       
    <!-- Transform Crossref DOI submission to csv for doing a batch change in Digital Commons -->
    
    <xsl:output method="text" version="1.0" encoding="UTF-8"/>
     
    <xsl:template match="/">      
       
        <xsl:text>URL&#9;DOI&#9;Title&#xa;</xsl:text>
        
        <xsl:for-each select="doi_batch/body/conference/conference_paper">
        <!--<xsl:for-each select="doi_batch/body/journal/journal_article">-->
        
            <xsl:value-of select="doi_data/resource"/>
            <xsl:text>&#9;</xsl:text>

            <xsl:value-of select="doi_data/doi"/>
            <xsl:text>&#9;</xsl:text>

            <xsl:value-of select="titles/title"/>    
            <xsl:text>&#xa;</xsl:text>
            
        <!--</xsl:for-each>-->
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>