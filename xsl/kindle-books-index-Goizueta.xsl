<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/drafts/wysiwyg-strip-tags.xsl"/>
    <xsl:import href="/_cms/xsl/components/photo-gallery.xsl"/>
    <xsl:import href="/_cms/xsl/components/video-gallery.xsl"/>
    <xsl:import href="/_cms/xsl/components/interior-slideshow.xsl"/>
    <xsl:import href="/_cms/xsl/components/content-box.xsl"/>
    <xsl:import href="/_cms/xsl/components/blog-news.xsl"/>
    <xsl:variable name="this-page-path" select="//calling-page/system-page/path"/>
    <!-- alt for main img/media? can't require due to dd structure -->
    <xsl:template match="system-index-block">
        <xsl:apply-templates select="//calling-page/system-page/system-data-structure"/>
        <xsl:for-each select="/descendant::book[category/path = $this-page-path]">
            <xsl:call-template name="book-output">
                <xsl:with-param name="current-book" select="position()"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="book-output">
        <xsl:param name="current-book"/>
            <xsl:if test="($current-book mod 2) != 0">
                <section class="kindle-books-output clearfix">
                    <xsl:apply-templates select="/descendant::book[category/path = $this-page-path][position() = $current-book]"/>
                    <xsl:apply-templates select="/descendant::book[category/path = $this-page-path][position() = $current-book+1]"/>
                </section>
            </xsl:if>
    </xsl:template>
    
    <xsl:template match="system-data-structure">
        <div>
            <!-- add class for wide/no rt col -->
            <xsl:attribute name="class"> data-entry
                <xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'">wide</xsl:if>
            </xsl:attribute>
            <!-- optional overview -->
            <xsl:if test="main-content/descendant::*">
                <div class="overview clearfix">
                    <xsl:apply-templates select="main-content"/>
                </div>
            </xsl:if>
        </div>
        <!-- end outer data-entry div -->
    </xsl:template>
    
    <!-- book output -->
    <xsl:template match="book">
        <article class="equal-height span6 book clearfix" id="{isbn}">
            <h2 class="title">
                    <xsl:value-of select="title"/>
            </h2>
            <p class="author">
                <xsl:for-each select="author">
                    <xsl:sort select="lastname"/>
                    <xsl:value-of select="normalize-space(lastname)"/>, <xsl:value-of select="normalize-space(firstname)"/><xsl:if test="position() != last()">; </xsl:if>
                </xsl:for-each>
            </p>
            <figure class="span5">
                <img class="cover" src="{cover/link}"/>
            </figure>
            <div class="span6">
                <p><xsl:value-of select="description"/></p>
            </div>
        </article>
    </xsl:template>
    <!-- overview/main content -->
    <xsl:template match="main-content">
        <xsl:choose>
            <xsl:when test="main-images/type != 'Do Not Display' and main-images/display = 'Before'">
                <xsl:apply-templates select="main-images"/>
                <xsl:apply-templates select="figure"/>
                <xsl:if test="main !=''">
                    <xsl:apply-templates select="main"/>
                </xsl:if>
                <!--<xsl:copy-of select="main/node()"/>-->
            </xsl:when>
            <xsl:when test="main-images/type != 'Do Not Display' and main-images/display = 'After'">
                <xsl:apply-templates select="figure"/>
                <xsl:if test="main !=''">
                    <xsl:apply-templates select="main"/>
                </xsl:if>
                <!--<xsl:copy-of select="main/node()"/>-->
                <xsl:apply-templates select="main-images"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="figure"/>
                <xsl:if test="main !=''">
                    <xsl:apply-templates select="main"/>
                </xsl:if>
                <!--<xsl:copy-of select="main/node()"/>-->
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="printable-list/link">
            <div class="pull-right">
                <p><small><a href="{printable-list/link}">Download a printable list <span class="fa fa-download"></span></a></small></p>
            </div>
        </xsl:if>
        <xsl:if test="supplemental-block/block/content != ''">
            <xsl:apply-templates select="supplemental-block"/>
        </xsl:if>
    </xsl:template>
    <!-- main visual -->
    <xsl:template match="main-images">
        <!-- add layout options - image only -->
        <xsl:if test="image/path != '/' or slideshow-block/path != '/' or code != ''">
            <figure id="main-visual">
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="layout = 'Full-width' and type = 'Image'">img-wide</xsl:when>
                        <xsl:when test="layout = 'Full-width' and type = 'Video'">img-wide</xsl:when>
                        <!--<xsl:when test="layout='Narrow - Right' and type='Image'">img-half pull-right</xsl:when><xsl:when test="layout='Narrow - Left' and type='Image'">img-half pull-left</xsl:when>-->
                        <xsl:when test="type='Slideshow'">slideshow</xsl:when>
                        <xsl:when test="type='Photo Gallery'">gallery</xsl:when>
                        <xsl:when test="type='Video Gallery'">video-gallery</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="type = 'Image'">
                        <img alt="" src="{image/link}"/>
                        <xsl:if test="caption!=''">
                            <figcaption class="muted">
                                <xsl:value-of select="caption"/>
                            </figcaption>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="type = 'Video'">
                        <xsl:call-template name="video"/>
                    </xsl:when>
                    <xsl:when test="type = 'Slideshow'">
                        <xsl:call-template name="interior-slideshow"/>
                    </xsl:when>
                    <xsl:when test="type = 'Photo Gallery'">
                        <xsl:call-template name="photo-gallery"/>
                    </xsl:when>
                    <xsl:when test="type = 'Video Gallery'">
                        <xsl:call-template name="video-gallery"/>
                    </xsl:when>
                </xsl:choose>
            </figure>
        </xsl:if>
    </xsl:template>
    <!--video-->
    <xsl:template name="video">
        <div class="video">
            <!-- debug YT embed self closing attribute-->
            <xsl:choose>
                <xsl:when test="contains(code, 'allowfullscreen') and contains(code,'youtube')">
                    <xsl:value-of disable-output-escaping="yes" select="substring-before(code,'allowfullscreen')"/>
                    allowfullscreen="true" 
                            
                            
                    <xsl:text/>
                    <xsl:value-of disable-output-escaping="yes" select="substring-after(code,'allowfullscreen')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="code"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="caption!=''">
                <p class="muted">
                    <xsl:value-of select="caption"/>
                </p>
            </xsl:if>
            <!--   <script src="/js/jquery.fitvids.js"><xsl:text/></script><script src="/js/scale-video.js"><xsl:text/></script> -->
        </div>
    </xsl:template>
    <!-- figure element -->
    <xsl:template match="figure">
        <xsl:if test="image/name">
            <figure>
                <xsl:attribute name="class"> structured-inset 
                            
                            
                    <xsl:choose>
                        <xsl:when test="align='Left'">pull-left</xsl:when>
                        <xsl:when test="align='Right'">pull-right</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="link/page/path != '/' or link/external != '' or link/file/path != '/'">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="link/page/path != '/'">
                                        <xsl:value-of select="link/page/path"/>
                                    </xsl:when>
                                    <xsl:when test="link/external != ''">
                                        <xsl:value-of select="link/external"/>
                                    </xsl:when>
                                    <xsl:when test="link/file/path != '/'">
                                        <xsl:value-of select="link/file/path"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                            <img alt="" src="{image/link}"/>
                            <xsl:if test="caption != ''">
                                <figcaption class="muted">
                                    <xsl:value-of select="caption"/>
                                </figcaption>
                            </xsl:if>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <img alt="" src="{image/link}"/>
                        <xsl:if test="caption != ''">
                            <figcaption class="muted">
                                <xsl:value-of select="caption"/>
                            </figcaption>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </figure>
        </xsl:if>
    </xsl:template>
    <!-- Supplemental blocks -->
    <xsl:template match="supplemental-block">
        <xsl:if test="block/content != ''">
            <div>
                <xsl:copy-of select="block/content/node()"/>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- template for adding <p> tags to WYSIWYG content without paragraph tags -->
    <xsl:template match="main">
        <xsl:copy-of select="node()"/>
        <!--<xsl:call-template name="strip-wysiwyg"/>-->
    </xsl:template>
</xsl:stylesheet>
