<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/components/photo-gallery.xsl"/>
    <xsl:import href="/_cms/xsl/components/video-gallery.xsl"/>
    <xsl:import href="/_cms/xsl/components/interior-slideshow.xsl"/>
    <xsl:import href="/_cms/xsl/components/content-box.xsl"/>
    <xsl:import href="/_cms/xsl/components/blog-news.xsl"/>
    <!-- alt for main img/media? can't require due to dd structure -->
    <xsl:template match="system-index-block">
        <xsl:apply-templates select="calling-page/system-page/system-data-structure"/>
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
            <xsl:choose>
                <!-- Standard/Accordions/Tabs? -->
                <xsl:when test="page-options/layout='Standard'">
                    <xsl:apply-templates mode="standard" select="section-content"/>
                </xsl:when>
                <xsl:when test="page-options/layout='Tabs'">
                    <ul class="nav nav-tabs clearfix" id="section-tabs">
                        <xsl:for-each select="section-content">
                            <xsl:if test="section-heading/section-heading-level = 'Heading 2'">
                                <!--<xsl:choose>-->
                                <xsl:if test="section-heading/heading!=''">
                                    <li>
                                        <xsl:attribute name="class">
                                            <xsl:if test="position() = 1">active</xsl:if>
                                        </xsl:attribute>
                                        <a data-toggle="tab" href="#tab{position()}">
                                            <xsl:value-of select="section-heading/heading"/>
                                        </a>
                                    </li>
                                </xsl:if>
                                <!--<xsl:otherwise> [system-view:internal]Please provide a
                                                heading for: [/system-view:internal]Section
                                                <xsl:value-of select="position()" /></xsl:otherwise>-->
                                <!-- fallback if user doens't populate -->
                                <!--</xsl:choose>-->
                            </xsl:if>
                        </xsl:for-each>
                    </ul>
                    <div class="tab-content">
                        <xsl:for-each select="section-content">
                            <xsl:if test="section-heading/section-heading-level = 'Heading 2'">
                                <xsl:call-template name="section-content-tabs"/>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </xsl:when>
                <!-- accordion -->
                <xsl:when test="page-options/layout='Accordions'">
                    <div class="accordion clearfix" id="accordion">
                        <xsl:for-each select="section-content[section-heading/section-heading-level = 'Heading 2']">
                            <section class="accordion-group clearfix" id="section{position()}">
                                <xsl:call-template name="section-content-accordion"/>
                            </section>
                        </xsl:for-each>
                    </div>
                    <!-- end #accordion1 -->
                </xsl:when>
            </xsl:choose>
            <xsl:if test="books/book/isbn != ''">
                <xsl:call-template name="books-api-script"/>
                <section class="books">
                    <xsl:if test="books/overview != ''">
                        <section class="new-books clearfix" id="books-overview">
                            <xsl:if test="books/heading != ''">
                                <xsl:choose>
                                    <xsl:when test="books/heading-level = 'Heading 2'">
                                        <h2>
                                            <xsl:value-of select="books/heading"/>
                                        </h2>
                                    </xsl:when>
                                    <xsl:when test="books/heading-level = 'Heading 3'">
                                        <h3>
                                            <xsl:value-of select="books/heading"/>
                                        </h3>
                                    </xsl:when>
                                    <xsl:when test="books/heading-level = 'Heading 4'">
                                        <h4>
                                            <xsl:value-of select="books/heading"/>
                                        </h4>
                                    </xsl:when>
                                    <xsl:when test="books/heading-level = 'Heading 5'">
                                        <h5>
                                            <xsl:value-of select="books/heading"/>
                                        </h5>
                                    </xsl:when>
                                    <xsl:when test="books/heading-level = 'Heading 6'">
                                        <h6>
                                            <xsl:value-of select="books/heading"/>
                                        </h6>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:copy-of select="books/overview/node()"/>
                        </section>
                    </xsl:if>
                    <xsl:apply-templates select="descendant::book[featured/featured/value = 'Yes']"/>
                </section>
            </xsl:if>
        </div>
        <!-- end outer data-entry div -->
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
    <xsl:template match="section-content" mode="standard">
        <section class="clearfix" id="section{position()}">
            <xsl:if test="section-heading/heading != ''">
                <xsl:choose>
                    <xsl:when test="section-heading/section-heading-level = 'Heading 2'">
                        <h2>
                            <xsl:value-of select="section-heading/heading"/>
                        </h2>
                    </xsl:when>
                    <xsl:when test="section-heading/section-heading-level = 'Heading 3'">
                        <h3>
                            <xsl:value-of select="section-heading/heading"/>
                        </h3>
                    </xsl:when>
                    <xsl:when test="section-heading/section-heading-level = 'Heading 4'">
                        <h4>
                            <xsl:value-of select="section-heading/heading"/>
                        </h4>
                    </xsl:when>
                    <xsl:when test="section-heading/section-heading-level = 'Heading 5'">
                        <h5>
                            <xsl:value-of select="section-heading/heading"/>
                        </h5>
                    </xsl:when>
                    <xsl:when test="section-heading/section-heading-level = 'Heading 6'">
                        <h6>
                            <xsl:value-of select="section-heading/heading"/>
                        </h6>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:copy-of select="main/node()"/>
            <xsl:apply-templates select="section-content-boxes"/>
        </section>
    </xsl:template>
    <!-- section visual -->
    <xsl:template match="section-images">
        <!-- add layout options - image only -->
        <xsl:if test="image/path != '/' or code != ''">
            <div class="img-wide" id="section-visual">
                <!--            <xsl:attribute name="class"><xsl:choose><xsl:when test="layout='Full-width' and type='Image'">img-wide</xsl:when><xsl:when test="layout='Full-width' and type='Video'">img-wide</xsl:when><xsl:when test="layout='Narrow - Right' and type='Image'">img-half pull-right</xsl:when><xsl:when test="layout='Narrow - Left' and type='Image'">img-half pull-left</xsl:when></xsl:choose></xsl:attribute> -->
                <xsl:choose>
                    <xsl:when test="type = 'Image'">
                        <img alt="" src="{image/link}"/>
                        <xsl:if test="caption != ''">
                            <p class="muted">
                                <xsl:value-of select="caption"/>
                            </p>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="type = 'Video'">
                        <xsl:call-template name="video"/>
                    </xsl:when>
                </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- end section -->
    <xsl:template name="section-content-accordion">
        <xsl:variable name="current" select="."/>
        <!--<xsl:choose>-->
        <xsl:if test="section-heading/heading!=''">
            <h2 class="accordion-heading">
                <a class="accordion-toggle" data-parent="#accordion" data-toggle="collapse" href="#collapse{position()}">
                    <span class="icon-angle-right"></span>
                    <xsl:value-of select="section-heading/heading"/>
                </a>
            </h2>
        </xsl:if>
        <!--<xsl:otherwise> [system-view:internal]Please provide a heading for:
                [/system-view:internal]Section <xsl:value-of select="position()" /></xsl:otherwise>-->
        <!-- fallback if user doens't populate -->
        <!--</xsl:choose>-->
        <div id="collapse{position()}">
            <!-- additional class "in" if expanded -->
            <xsl:attribute name="class"> accordion-body collapse 
                <xsl:if test="expanded/value = 'Yes'">in</xsl:if>
            </xsl:attribute>
            <div class="accordion-inner">
                
                <xsl:choose>
                    <xsl:when test="section-images/type != 'Do Not Display' and section-images/display = 'Before'">
                        <xsl:apply-templates select="section-images"/>
                        <xsl:apply-templates select="figure"/>
                        <xsl:if test="main !=''">
                            <xsl:copy-of select="main/node()"/>
                        </xsl:if>
                        <!--<xsl:copy-of select="main/node()"/>-->
                    </xsl:when>
                    <xsl:when test="section-images/type != 'Do Not Display' and section-images/display = 'After'">
                        <xsl:apply-templates select="figure"/>
                        <xsl:if test="main !=''">
                            <xsl:copy-of select="main/node()"/>
                        </xsl:if>
                        <xsl:apply-templates select="section-images"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="figure"/>
                        <xsl:if test="main !=''">
                            <xsl:copy-of select="main/node()"/>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:apply-templates select="section-content-boxes"/>
                <!-- or call template for more indepth options? -->
                <xsl:for-each select="following-sibling::section-content[(section-heading/section-heading-level != 'Heading 2' or section-heading/heading = '') and preceding-sibling::section-content[section-heading/section-heading-level = 'Heading 2'][1] = $current]">
                    <xsl:call-template name="sub-section"/>
                </xsl:for-each>
            </div>
        </div>
        <!-- end section -->
    </xsl:template>
    <xsl:template name="section-content-tabs">
        <xsl:variable name="current" select="."/>
        <section id="tab{position()}">
            <xsl:attribute name="class"> tab-pane 
                <xsl:if test="position() = 1">active</xsl:if>
            </xsl:attribute>
            
            <xsl:choose>
                <xsl:when test="section-images/type != 'Do Not Display' and section-images/display = 'Before'">
                    <xsl:apply-templates select="section-images"/>
                    <xsl:apply-templates select="figure"/>
                    <xsl:if test="main !=''">
                        <xsl:copy-of select="main/node()"/>
                    </xsl:if>
                    <!--<xsl:copy-of select="main/node()"/>-->
                </xsl:when>
                <xsl:when test="section-images/type != 'Do Not Display' and section-images/display = 'After'">
                    <xsl:apply-templates select="figure"/>
                    <xsl:if test="main !=''">
                        <xsl:copy-of select="main/node()"/>
                    </xsl:if>
                    <xsl:apply-templates select="section-images"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="figure"/>
                    <xsl:if test="main !=''">
                        <xsl:copy-of select="main/node()"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="section-content-boxes"/>
            <xsl:for-each select="following-sibling::section-content[(section-heading/section-heading-level != 'Heading 2' or section-heading/heading = '') and preceding-sibling::section-content[section-heading/section-heading-level = 'Heading 2'][1] = $current]">
                <xsl:call-template name="sub-section"/>
            </xsl:for-each>
        </section>
    </xsl:template>
    <!--subsection content for lower level headings -->
    <xsl:template name="sub-section">
        <xsl:if test="section-heading/heading!=''">
            <xsl:choose>
                <xsl:when test="section-heading/section-heading-level = 'Heading 3'">
                    <h3>
                        <xsl:value-of select="section-heading/heading"/>
                    </h3>
                </xsl:when>
                <xsl:when test="section-heading/section-heading-level = 'Heading 4'">
                    <h4>
                        <xsl:value-of select="section-heading/heading"/>
                    </h4>
                </xsl:when>
                <xsl:when test="section-heading/section-heading-level = 'Heading 5'">
                    <h5>
                        <xsl:value-of select="section-heading/heading"/>
                    </h5>
                </xsl:when>
                <xsl:when test="section-heading/section-heading-level = 'Heading 6'">
                    <h6>
                        <xsl:value-of select="section-heading/heading"/>
                    </h6>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        
        <xsl:choose>
            <xsl:when test="section-images/type != 'Do Not Display' and section-images/display = 'Before'">
                <xsl:apply-templates select="section-images"/>
                <xsl:apply-templates select="figure"/>
                <xsl:if test="main !=''">
                    <xsl:copy-of select="main/node()"/>
                </xsl:if>
                <!--<xsl:copy-of select="main/node()"/>-->
            </xsl:when>
            <xsl:when test="section-images/type != 'Do Not Display' and section-images/display = 'After'">
                <xsl:apply-templates select="figure"/>
                <xsl:if test="main !=''">
                    <xsl:copy-of select="main/node()"/>
                </xsl:if>
                <xsl:apply-templates select="section-images"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="figure"/>
                <xsl:if test="main !=''">
                    <xsl:copy-of select="main/node()"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:apply-templates select="section-content-boxes"/>
        <!-- or call template for more indepth options? -->
    </xsl:template>
    <!-- inner section content -->
    <xsl:template name="section-inner">
        <xsl:choose>
            <xsl:when test="section-images/type != 'Do Not Display' and section-images/display = 'Before'">
                <xsl:apply-templates select="section-images"/>
                <xsl:apply-templates select="figure"/>
                <xsl:if test="main !=''">
                    <xsl:copy-of select="main/node()"/>
                </xsl:if>
                <!--<xsl:copy-of select="main/node()"/>-->
            </xsl:when>
            <xsl:when test="section-images/type != 'Do Not Display' and section-images/display = 'After'">
                <xsl:apply-templates select="figure"/>
                <xsl:if test="main !=''">
                    <xsl:copy-of select="main/node()"/>
                </xsl:if>
                <xsl:apply-templates select="section-images"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="figure"/>
                <xsl:if test="main !=''">
                    <xsl:copy-of select="main/node()"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
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
    <!-- content-box row -->
    <xsl:template match="section-content-boxes">
        <xsl:if test="component/path != '/'">
            <div>
                <xsl:attribute name="class">
                    content-box-row clearfix equal-height-row
                    
                    <xsl:if test="distinguish/value = 'Yes'">distinguished</xsl:if>
                </xsl:attribute>
                <xsl:apply-templates select="descendant::content-box"/>
            </div>
        </xsl:if>
        <div>
            <xsl:if test="descendant::rss">
                <xsl:apply-templates select="descendant::rss"/>
            </xsl:if>
        </div>
    </xsl:template>
    <!-- Featured Book -->
    <xsl:template match="book">
        <xsl:if test="featured/featured/value = 'Yes'">
            <section class="new-books clearfix equal-row-height content-box-row distinguished" id="section-1">
                <xsl:variable name="featured-heading">
                    <xsl:choose>
                        <xsl:when test="featured/faculty/value = 'Yes'">
                            <xsl:text>Faculty Featured Book</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Featured Book</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <h2>
                    <xsl:value-of select="$featured-heading"/>
                </h2>
                <article id="featured-book">
                    <div class="span8">
                        <xsl:copy-of select="featured/summary/node()"/>
                    </div>
                </article>
            </section>
        </xsl:if>
    </xsl:template>
    <!-- Google Books API -->
    <xsl:template name="books-api-script">
        <script>
            //Array of ISBNS to maintain order
            var isbnsArray = [
            <xsl:for-each select="descendant::books/book">
                <xsl:if test="isbn != '' and not(preceding-sibling::book/isbn = isbn)">'
                    <xsl:value-of select="isbn"/>'
                    <xsl:if test="position() != last()">,</xsl:if>
                </xsl:if>
            </xsl:for-each>];
            //Object of ISBNS to store manual and capture API response data
            var isbnsObj = {
            <xsl:for-each select="descendant::books/book">
                <xsl:if test="isbn != '' and not(preceding-sibling::book/isbn = isbn)">
                "
                    <xsl:value-of select="isbn"/>":{
                    "featured":"
                    <xsl:value-of select="featured/featured/value"/>",
                    "faculty":"
                    <xsl:value-of select="featured/faculty/value"/>",
                    "call number":"
                    <xsl:value-of select="call-number"/>",
                    "ebook link":"
                    <xsl:value-of select="ebook-link"/>",
                    "hardcopy link":"
                    <xsl:value-of select="hard-copy-link"/>",
                    "data source":
                    <xsl:choose>
                        <xsl:when test="not(manual-entry/title='')">"manual"</xsl:when>
                        <xsl:otherwise>"API"</xsl:otherwise>
                    </xsl:choose>,
                    "title":"
                    <xsl:value-of select="manual-entry/title"/>",
                    "authors":"
                    <xsl:for-each select="manual-entry/authors/author">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">; </xsl:if>
                    </xsl:for-each>",
                    "cover url":"
                    <xsl:choose>
                        <xsl:when test="not(manual-entry/cover/path = '/')">[system-asset]
                            <xsl:value-of select="manual-entry/cover/path"/>[/system-asset]
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="manual-entry/cover/path"/>
                        </xsl:otherwise>
                    </xsl:choose>",
                    "preview link":"
                    <xsl:value-of select="preview-link"/>",
                    "categories":{
                    <xsl:for-each select="categories/category-page">
                        "
                        <xsl:value-of select="title"/>":"
                        <xsl:value-of select="link"/>"
                        <xsl:if test="position() != last()">,</xsl:if>
                    </xsl:for-each>
                    }
                }
                    <xsl:if test="position() != last()">,</xsl:if>
                </xsl:if>
            </xsl:for-each>
            };
            
            var reqISBNSArray = [];
            for(isbn in isbnsObj){
            if(isbnsObj[isbn]['data source'] === 'API'){
            reqISBNSArray.push(isbn);            
            }
            }
            
            //This will be sent to PHP Cache
            var reqISBNS = {isbns:reqISBNSArray.join(',')};
            
        
        </script>
        <script src="https://web.library.emory.edu/_includes/google-books/books-ajax.js"></script>
    </xsl:template>
</xsl:stylesheet>
