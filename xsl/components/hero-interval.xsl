<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- relative to system-data-structure/toprow/hero/ -->
    <!-- processes basic or random on refresh image -->

    <xsl:variable name="interval"><xsl:value-of select="//toprow/hero/basic-slideshow/interval"/></xsl:variable>
    <xsl:variable name="speed-default">1000</xsl:variable>
    <xsl:variable name="interval-default">5500</xsl:variable>

    <xsl:template match="system-data-structure">
        <xsl:apply-templates select="hero-interval"/>
    </xsl:template>

    <xsl:template name="hero-interval">
        <xsl:param name="span"/>
        <xsl:variable name="width">
            <xsl:choose>
                <xsl:when test="$span = 'span8'">600</xsl:when>
                <xsl:when test="$span = 'span4'">550</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <div class="slides section">
            <ul><!-- class="rslides default" -->
                <xsl:attribute name="class">rslides<xsl:choose><xsl:when test="//toprow/hero/basic-slideshow/slideshow_type='Switch with Arrows'"> paged_arrows</xsl:when><xsl:when test="//toprow/hero/basic-slideshow/slideshow_type='Switch with Numbers'"> paged_numbers</xsl:when><xsl:otherwise> default</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:for-each select="basic-slideshow/image-set">
                    <li>
                         <!-- add optional link to image -->
                        <xsl:choose>
                            <xsl:when test="link/page/name or link/external!='' or link/file/name">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:choose>
                                            <xsl:when test="link/page/name">
                                                <xsl:value-of select="link/page/path"/>
                                            </xsl:when>
                                            <xsl:when test="link/external!=''">
                                                <xsl:value-of select="link/external"/>
                                            </xsl:when>
                                            <xsl:when test="link/file/name">
                                                <xsl:value-of select="link/file/path"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <img>
                                        <xsl:attribute name="alt"/>
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="image/path"/>
                                        </xsl:attribute>
                                    </img>
                                    <xsl:if test="caption != '' and //toprow/hero/basic-slideshow/show_captions = 'Yes'">
                                        <p class="caption hidden-phone"><xsl:value-of select="caption"/></p>
                                    </xsl:if>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <img>
                                    <xsl:attribute name="alt"/>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="image/path"/>
                                    </xsl:attribute>
                                </img>
                                <xsl:if test="caption != '' and //toprow/hero/basic-slideshow/show_captions = 'Yes'">
                                    <p class="caption hidden-phone"><xsl:value-of select="caption"/></p>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </li>
                </xsl:for-each>
            </ul>
           <script src="//template.emory.edu/assets/wdg/js/plugins/jquery.responsiveslides-1.54.min.js"></script>
            <script>
                $(function () {
                <xsl:choose><xsl:when test="//toprow/hero/basic-slideshow/slideshow_type='Switch with Arrows'">
                    $('.<xsl:value-of select="$span"/> .slides ul.paged_arrows').responsiveSlides({
                      timeout: <xsl:choose><xsl:when test="$interval!=''"><xsl:value-of select="$interval * 1000"/></xsl:when><xsl:otherwise><xsl:value-of select="$interval-default"/></xsl:otherwise></xsl:choose>,
                      maxwidth: <xsl:value-of select="$width"/>,
                      speed: <xsl:value-of select="$speed-default"/>,
                      auto: false,
                      nav: true
                    });
                </xsl:when>
                <xsl:when test="//toprow/hero/basic-slideshow/slideshow_type='Switch with Numbers'">
                    $('.<xsl:value-of select="$span"/> .slides ul.paged_numbers').responsiveSlides({
                      timeout: <xsl:choose><xsl:when test="$interval!=''"><xsl:value-of select="$interval * 1000"/></xsl:when><xsl:otherwise><xsl:value-of select="$interval-default"/></xsl:otherwise></xsl:choose>,
                      maxwidth: <xsl:value-of select="$width"/>,
                      speed: <xsl:value-of select="$speed-default"/>,
                      auto: false,
                      pager: true
                    });
                </xsl:when>
                <xsl:otherwise>               
                    $('.<xsl:value-of select="$span"/> .slides ul.default').responsiveSlides({
                      timeout: <xsl:choose><xsl:when test="$interval!=''"><xsl:value-of select="$interval * 1000"/></xsl:when><xsl:otherwise><xsl:value-of select="$interval-default"/></xsl:otherwise></xsl:choose>,
                      maxwidth: <xsl:value-of select="$width"/>,
                      speed: <xsl:value-of select="$speed-default"/>
                    });
                </xsl:otherwise></xsl:choose>
                });
            </script>
        </div>
    </xsl:template>

</xsl:stylesheet>
