<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" method="xml"/>
    <xsl:template match="system-index-block">
    
        
        <xsl:if test="calling-page/system-page/system-data-structure/related!=''">
            <p>
                <strong>More Databases Like This:&#160;</strong>
                <xsl:apply-templates select="calling-page/system-page/system-data-structure/related"/>
            </p>
        </xsl:if>
      
    </xsl:template>
    
    <xsl:template match="related">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="link"/>
            </xsl:attribute>
            <xsl:value-of select="title"/>
            <xsl:choose>
                <xsl:when test="position() != last()">, </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
