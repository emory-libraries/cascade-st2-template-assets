<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!--This will check to see if here is an alternative title (via alt-subnav-title) and it will use that. If there is not a alt, it will use the title-->
    <xsl:template match="title">
        <xsl:variable name="alt-title">
            <xsl:value-of select="parent::system-page/dynamic-metadata[name='alt-subnav-title']/value"/>
        </xsl:variable>
        
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="$alt-title!=''"><xsl:value-of select="$alt-title"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$title"/>
    </xsl:template>
</xsl:stylesheet>
