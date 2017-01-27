<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    

    <xsl:template match="system-index-block">
        <xsl:apply-templates select="calling-page/system-page"/>
    </xsl:template>
    <xsl:template match="system-page">

    <img>

    <xsl:attribute name="src">
    <xsl:choose><xsl:when test="system-data-structure/thumbnail/section-icon!='---'">
    
    <xsl:value-of select="system-data-structure/thumbnail/section-icon"/>
    
    </xsl:when>
    <xsl:otherwise>
        <xsl:value-of select="system-data-structure/thumbnail/image/path"/>
        </xsl:otherwise></xsl:choose>
    </xsl:attribute></img>
      <p><strong>URL: </strong>
     <a href="{system-data-structure/url}">
      <xsl:value-of select="system-data-structure/url"/></a>
      
      </p>
      
       <p><strong>Summary: </strong>
       <xsl:choose>
       <xsl:when test="system-data-structure/summary!=' '">
       <xsl:value-of select="system-data-structure/summary"/>
       </xsl:when><xsl:otherwise>
      <xsl:value-of select="summary"/></xsl:otherwise></xsl:choose></p>

    </xsl:template>
</xsl:stylesheet>
