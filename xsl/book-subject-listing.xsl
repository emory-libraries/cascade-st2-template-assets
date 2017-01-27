<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/drafts/wysiwyg-strip-tags.xsl"/>
    <xsl:import href="/_cms/xsl/components/photo-gallery.xsl"/>
    <xsl:import href="/_cms/xsl/components/video-gallery.xsl"/>
    <xsl:import href="/_cms/xsl/components/interior-slideshow.xsl"/>
    <xsl:import href="/_cms/xsl/components/content-box.xsl"/>
    <xsl:import href="/_cms/xsl/components/blog-news.xsl"/>

   <!-- alt for main img/media? can't require due to dd structure -->
    <xsl:template match="system-index-block">
        <div>
            <!-- add class for wide/no rt col -->
            <xsl:attribute name="class"> data-entry <xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'">wide</xsl:if>
            </xsl:attribute>
            <!-- optional overview -->
            <xsl:if test="calling-page/system-page/system-data-structure/main-content/descendant::*">
                <div class="overview clearfix">
                    <xsl:apply-templates select="calling-page/system-page/system-data-structure/main-content"/>
                </div>
            </xsl:if>
            <section class="books">
            </section>
        </div>
            <xsl:variable name="batch-size">
                <xsl:value-of select="calling-page/system-page/system-data-structure/books-display-settings/batch-size"/>
            </xsl:variable>
            <xsl:variable name="batch-length">
                <xsl:choose>
                    <xsl:when test="$batch-size mod 2 != 0">
                        <xsl:value-of select="$batch-size + 1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$batch-size"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
        <xsl:if test="count(descendant::books/book[subjects/category-page/path = /system-index-block/calling-page/system-page/path]) &gt; $batch-length">
            <div class="span-12 clearfix alert alert-info" id="load-more">Show more books...</div>
        </xsl:if>
        <!-- end outer data-entry div -->
        
        <!--<xsl:apply-templates select="system-folder/system-page/system-data-structure"/>-->
        <xsl:call-template name="books-api-script"/>
        [cascade:cdata]#protect<xsl:comment>[if lte IE 9 ]&gt;
        &lt;script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-ajaxtransport-xdomainrequest/1.0.2/jquery.xdomainrequest.min.js"&gt;&lt;/script&gt;
        &lt;![endif]</xsl:comment>#protect[/cascade:cdata]
        <script src="https://web.library.emory.edu/_includes/google-books/book-subjects-ajax.js"></script>
    </xsl:template>
    
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
    </xsl:template>
    <!-- main visual -->
    <xsl:template match="main-images">
        <!-- add layout options - image only -->
        <xsl:if test="image/path != '/' or slideshow-block/path != '/' or code != ''">
            <div id="main-visual">
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="layout = 'Full-width' and type = 'Image'">img-wide</xsl:when>
                        <xsl:when test="layout = 'Full-width' and type = 'Video'">img-wide</xsl:when>
                        <!--<xsl:when test="layout='Narrow - Right' and type='Image'">img-half pull-right</xsl:when>
                        <xsl:when test="layout='Narrow - Left' and type='Image'">img-half pull-left</xsl:when>-->
                        <xsl:when test="type='Slideshow'">slideshow</xsl:when>
                        <xsl:when test="type='Photo Gallery'">gallery</xsl:when>
                        <xsl:when test="type='Video Gallery'">video-gallery</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="type = 'Image'">
                        <img alt="" src="{image/link}"/>
                        <xsl:if test="caption!=''">
                            <p class="muted">
                                <xsl:value-of select="caption"/>
                            </p>
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
            </div>
        </xsl:if>
    </xsl:template>
    <!--video-->
    <xsl:template name="video">
        <div class="video">
            <!-- debug YT embed self closing attribute-->
            <xsl:choose>
                <xsl:when test="contains(code, 'allowfullscreen') and contains(code,'youtube')">
                    <xsl:value-of disable-output-escaping="yes" select="substring-before(code,'allowfullscreen')"/>
                    allowfullscreen="true" <xsl:text/>
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
            <!--   <script src="/js/jquery.fitvids.js"><xsl:text/></script>
                        <script src="/js/scale-video.js"><xsl:text/></script> -->
        </div>
    </xsl:template>
    <!-- figure element -->
    <xsl:template match="figure">
        <xsl:if test="image/name">
            <figure>
                <xsl:attribute name="class"> structured-inset <xsl:choose>
                        <xsl:when test="align='Left'">pull-left</xsl:when>
                        <xsl:when test="align='Right'">pull-right</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="link/page/path != '/' or link/external != '' or link/file/path != '/'">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="link/page/path != '/'"><xsl:value-of select="link/page/path"/></xsl:when>
                                    <xsl:when test="link/external != '/'"><xsl:value-of select="link/external"/></xsl:when>
                                    <xsl:when test="link/file/path != '/'"><xsl:value-of select="link/file/path"/></xsl:when>
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

    <!-- template for adding <p> tags to WYSIWYG content without paragraph tags -->
    <xsl:template match="main">
        <xsl:copy-of select="node()"/>
        <!--<xsl:call-template name="strip-wysiwyg"/>-->
    </xsl:template>
    
    <!-- Google Books API -->
    <xsl:template name="books-api-script">
        <script>
            //Array of ISBNS to maintain order
            var isbnsArray = [<xsl:for-each select="descendant::books/book[subjects/category-page/path = /system-index-block/calling-page/system-page/path]"><xsl:if test="isbn != '' and not(preceding-sibling::book/isbn = isbn)">'<xsl:value-of select="isbn"/>'<xsl:if test="position() != last()">,</xsl:if></xsl:if></xsl:for-each>];
            //Object of ISBNS to store manual and capture API response data
            isbnsObj = {<xsl:for-each select="descendant::books/book[subjects/category-page/path = /system-index-block/calling-page/system-page/path]"><xsl:if test="isbn != '' and not(preceding-sibling::book/isbn = isbn)">
                "<xsl:value-of select="isbn"/>":{
                    <xsl:if test="featured/featured/value = 'Yes'">"featured":"<xsl:value-of select="featured/featured/value"/>",
                    <xsl:if test="featured/faculty/value = 'Yes'">"faculty":"<xsl:value-of select="featured/faculty/value"/>",</xsl:if></xsl:if>
                    "call number":"<xsl:value-of select="call-number"/>",
                    "ebook link":"<xsl:value-of select="ebook-link"/>",
                    "hardcopy link":"<xsl:value-of select="hard-copy-link"/>",
                    "data source":<xsl:choose><xsl:when test="not(manual-entry/title='')">"manual"</xsl:when><xsl:otherwise>"API"</xsl:otherwise></xsl:choose>,
                    "title":"<xsl:value-of select="manual-entry/title"/>",
                    "authors":"<xsl:for-each select="manual-entry/authors/author"><xsl:value-of select="."/><xsl:if test="position() != last()">; </xsl:if></xsl:for-each>",
                    "cover url":"<xsl:choose><xsl:when test="not(manual-entry/cover/path = '/')">[system-asset]<xsl:value-of select="manual-entry/cover/path"/>[/system-asset]</xsl:when><xsl:otherwise><xsl:value-of select="manual-entry/cover/path"/></xsl:otherwise></xsl:choose>",
                    "preview link":"<xsl:value-of select="preview-link"/>",
                    "categories":{<xsl:for-each select="subjects/category-page">
                        "<xsl:value-of select="title"/>":"<xsl:value-of select="link"/>"<xsl:if test="position() != last()">,</xsl:if>
                    </xsl:for-each>
                    }
                }<xsl:if test="position() != last()">,</xsl:if></xsl:if></xsl:for-each>
            };
            <xsl:variable name="batch-size">
                <xsl:value-of select="calling-page/system-page/system-data-structure/books-display-settings/batch-size"/>
            </xsl:variable>
            <xsl:variable name="batch-length">
                <xsl:choose>
                    <xsl:when test="$batch-size mod 2 != 0">
                        <xsl:value-of select="$batch-size + 1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$batch-size"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            var batch_length = <xsl:value-of select="$batch-length"/>;
        </script>        
    </xsl:template>
</xsl:stylesheet>
