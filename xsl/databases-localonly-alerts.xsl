<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="/">
        <xsl:for-each select="system-index-block/system-page">
            
                <xsl:if test="system-data-structure/alert != ''">
                    <div style="padding-bottom: 1.5em;">
                        <h3>
                            <a><xsl:attribute name="href"><xsl:value-of select="path"/></xsl:attribute><xsl:value-of select="title"/></a></h3>
                        <div>
                            <xsl:attribute name="class">
                                <xsl:choose>
                                    <xsl:when test="system-data-structure/alert-type='Note'"> alert-info</xsl:when>
                                    <xsl:when test="system-data-structure/alert-type='Alert'"> alert-error</xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:copy-of select="system-data-structure/alert/node()"/>
                        </div>
                    </div>
                </xsl:if>
            
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
