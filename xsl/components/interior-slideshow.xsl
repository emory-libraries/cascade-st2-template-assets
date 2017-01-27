<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:template name="interior-slideshow">
        <xsl:apply-templates select="//slideshow-block/content/system-data-structure/hero"/>
    </xsl:template>

    <xsl:template match="slideshow-block/content/system-data-structure/hero">
        <xsl:variable name="interval"><xsl:value-of select="interval * 1000"/></xsl:variable>
    <xsl:variable name="interval-default">800</xsl:variable>
        <div class="slides section">
        <ul>
            <xsl:attribute name="class">rslides default</xsl:attribute>
            <xsl:for-each select="basic-slideshow/image-set">
                <li>
                    <img>
                                            <xsl:attribute name="src">
                                                <xsl:value-of select="image/path"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:if test="alt-text != ''">
                                                    <xsl:value-of select="alt-text"/>
                                                </xsl:if>
                                            </xsl:attribute>
                    </img>
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
       <script src="https://template.emory.edu/assets/js/plugins/jquery.responsiveslides-1.32.min.js"></script>
        <script>
            $(function () {
                $('.slides ul.default').responsiveSlides({
                  speed: <xsl:choose><xsl:when test="$interval!=''"><xsl:value-of select="$interval"/></xsl:when><xsl:otherwise><xsl:value-of select="$interval-default"/></xsl:otherwise></xsl:choose>,
                      maxwidth: 716
                });
              });
        </script>
    </div>
    </xsl:template>

</xsl:stylesheet>
