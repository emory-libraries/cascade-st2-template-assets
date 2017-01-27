<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:template name="photo-gallery">
        <xsl:apply-templates select="//slideshow-block/content/system-data-structure/gallery"/>
    </xsl:template>
    
    <xsl:template match="slideshow-block/content/system-data-structure/gallery">
        <ul class="photos" id="galleria">
            <xsl:attribute name="class">photos</xsl:attribute>
            <xsl:apply-templates select="photo"/>
        </ul>
    </xsl:template>
    <xsl:template match="photo">
        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="image/path"/>
                </xsl:attribute>
                <img>
                    <xsl:attribute name="src">
                        <xsl:value-of select="thumb/path"/>
                    </xsl:attribute>
                    <xsl:attribute name="alt">
                        <xsl:value-of select="alt"/>
                    </xsl:attribute>
                </img>
            </a>
            <xsl:if test="credits != ''">
                <p class="credits">
                    <xsl:value-of select="credits"/>
                </p>
            </xsl:if>
            <xsl:if test="title != ''">
                <h3>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="image/path"/>
                        </xsl:attribute>
                        <xsl:value-of select="title"/>
                    </a>
                </h3>
            </xsl:if>
            <xsl:if test="summary != ''">
                <div class="summary">
                    <xsl:value-of select="summary"/>
                </div>
            </xsl:if>
        </li>
    </xsl:template>
</xsl:stylesheet>
