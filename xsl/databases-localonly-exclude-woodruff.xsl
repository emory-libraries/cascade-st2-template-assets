<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
               <xsl:value-of select="count(system-index-block/system-page[system-data-structure/whsc/exclude/value='Yes'])"/>
        <xsl:for-each select="system-index-block/system-page">
     
            <xsl:if test="system-data-structure/whsc/exclude/value='Yes'">
    
                <p><a href="{path}"><xsl:value-of select="name"/></a></p> 
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
