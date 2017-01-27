<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
               <xsl:value-of select="count(system-index-block/system-page[system-data-structure/subjects/subject/featured='Yes'])"/>
        <xsl:for-each select="system-index-block/system-page">
     
            <xsl:if test="system-data-structure/subjects/subject/featured='Yes'">
    
                <p><a href="{path}"><xsl:value-of select="name"/></a><br/>
                    <xsl:value-of select="system-data-structure/subjects/subject/name"/></p> 
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
