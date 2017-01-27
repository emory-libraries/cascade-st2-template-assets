<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- relative to system-data-structure/toprow/hero/ -->
    <!-- processes basic or random on refresh image -->
    <xsl:template name="hero-static">
        <div class="slides section">
            <ul class="rslides">
                <xsl:attribute name="class">rslides<xsl:if test="//hero/type='Random Image on Refresh'">
                    randomizer</xsl:if></xsl:attribute>
                <xsl:for-each select="basic-slideshow/image-set">
                    <li>
                        <!-- add optional link to image -->
                        <xsl:choose>
                            <xsl:when test="page/name or external!='' or file/name">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:choose>
                                            <xsl:when test="page/name">
                                                <xsl:value-of select="page/path"/>
                                            </xsl:when>
                                            <xsl:when test="external!=''">
                                                <xsl:value-of select="external"/>
                                            </xsl:when>
                                            <xsl:when test="file/name">
                                                <xsl:value-of select="file/path"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <img>
                                        <xsl:attribute name="alt"/>
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="image/path"/>
                                        </xsl:attribute>
                                        
                                    </img>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <img>
                                    <xsl:attribute name="alt"/>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="image/path"/>
                                    </xsl:attribute>
                                    
                                </img> 
                            </xsl:otherwise>
                        </xsl:choose>


                        <xsl:if test="caption!=''">
                            <p class="caption hidden-phone">
                                <xsl:choose>
                                    <xsl:when test="page/name">
                                        <a href="{page/path}">
                                            <xsl:value-of select="caption"/>
                                        </a>
                                    </xsl:when>
                                    <xsl:when test="external!=''">
                                        <a href="{external}">
                                            <xsl:value-of select="caption"/>
                                        </a>
                                    </xsl:when>
                                    <xsl:when test="file/name">
                                        <a href="{file/path}">
                                            <xsl:value-of select="caption"/>
                                        </a>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="caption"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </p>
                        </xsl:if>
                    </li>
                </xsl:for-each>
            </ul>
            <xsl:if test="//hero/type='Random Image on Refresh'">
                <script src="https://template.emory.edu/assets/js/config/hero-randomizer.min.js"></script>
            </xsl:if>
        </div>
    </xsl:template>
</xsl:stylesheet>
