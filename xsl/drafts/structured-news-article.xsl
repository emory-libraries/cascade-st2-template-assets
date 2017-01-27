<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="date-converter" version="1.0" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:xalan="http://xml.apache.org/xalan">
    <xsl:import href="/_cms/xsl/drafts/wysiwyg-strip-tags.xsl"/>
    <xsl:import href="/_cms/xsl/components/photo-gallery.xsl"/>
    <xsl:import href="/_cms/xsl/components/video-gallery.xsl"/>
    <xsl:import href="/_cms/xsl/components/interior-slideshow.xsl"/>
    <xsl:import href="/_cms/xsl/components/content-box.xsl"/>
    <xsl:import href="/_cms/xsl/components/blog-news.xsl"/>
    <xsl:variable name="from-rss"><xsl:text>No</xsl:text></xsl:variable>
    <xsl:variable name="domain">
        <!--set variable for replacement domain; might need to include GBL and WHSC later-->
        <xsl:choose>
            <xsl:when test="descendant::calling-page/system-page/site = 'Library - MARBL'">
                <xsl:text>http://marbl.library.emory.edu/</xsl:text>
            </xsl:when>
            <xsl:when test="descendant::calling-page/system-page/site = 'Library - Woodruff'">
                <xsl:text>http://web.library.emory.edu/</xsl:text>
            </xsl:when>
            <xsl:when test="descendant::calling-page/system-page/site = 'Library - Oxford'">
                <xsl:text>http://oxford.library.emory.edu/</xsl:text>
            </xsl:when>
            <xsl:when test="descendant::calling-page/system-page/site = 'Library Template'">
                <xsl:text>http://staging.web.emory.edu/librariestemplate/</xsl:text>
            </xsl:when>
</xsl:choose>           
    </xsl:variable>
    <xsl:variable name="website_prefix">
        <xsl:value-of select="$domain"/>
    </xsl:variable>
    <!-- change me! -->
    <xsl:variable name="src_website_prefix">
        <xsl:value-of select="$domain"/>
    </xsl:variable>
    <!-- Path in the CMS -->
    <xsl:variable name="site_path">/</xsl:variable>

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:template match="/">
        <xsl:apply-templates mode="structured" select="/system-index-block/calling-page/system-page"/>
    </xsl:template>
    <xsl:template match="system-page" mode="structured">
        <article class="data-entry">
            <xsl:if test="$from-rss = 'No'">
                <xsl:if test="descendant::subheadline != ''">
                    <h2><xsl:value-of select="descendant::subheadline"/></h2>
                </xsl:if>
                <p class="publication-date">Published <xsl:value-of select="date-converter:convertDate(number(start-date))"/></p>
            </xsl:if>
            <!-- <xsl:if test="summary !=''">
                <p class="summary">
                    <xsl:value-of select="summary"/>
                </p>
            </xsl:if>-->
            <xsl:apply-templates mode="structured" select="descendant::article-details"/>
        </article>
    </xsl:template>
    
    <!-- Transform article details -->
    <xsl:template match="article-details" mode="structured">
        <xsl:if test="author !=''">
            <p class="author"> by 
                <xsl:apply-templates mode="structured" select="author"/>
            </p>
        </xsl:if>
        <xsl:apply-templates mode="structured" select="content"/>
        <xsl:if test="related-links/link/page/link or related-links/link/external != '' or related-links/link/file/link">
            <section class="related-links">
                <h3>Related Links:</h3>
                <ul class="links">
                    <xsl:apply-templates mode="structured" select="related-links/link"/>
                </ul>
            </section>
        </xsl:if>
        <xsl:if test="contact-info/name != ''">
            <section class="contact-info">
                <h3>For media inquiries, contact:</h3>
                <xsl:apply-templates mode="structured" select="contact-info"/>
            </section>
        </xsl:if>
    </xsl:template>
    
    <!-- Parse through authors and format based on number of authors accordingly -->
    <xsl:template match="author" mode="structured">
        <!-- If there is more than one author... -->
        <xsl:if test="count(../author) &gt; 1">
            <!-- If there are exactly two authors, and this is the last one, prefix with " and "... -->
            <xsl:if test="count(../author) = 2 and current() = //author[last()]">
                &#32;and&#32; </xsl:if>
            <!-- If there are more than two authors... -->
            <xsl:if test="count(../author) &gt; 2">
                <!-- If this is not the first or last, prefix with ", " -->
                <xsl:if test="current() != //author[position() = 1] and current() != //author[last()]">,&#32;</xsl:if>
                <!-- If this is the last of 3 or more, prefix with ", and " -->
                <xsl:if test="current() = //author[last()]">,&#32;and&#32;</xsl:if>
            </xsl:if>
        </xsl:if>
        <!-- Output the current author -->
        <xsl:value-of select="current()"/>
    </xsl:template>
    
    <!-- Parse through related links and build list items -->
    <xsl:template match="link" mode="structured">
        <xsl:variable name="url">
            <xsl:choose>
                <xsl:when test="page/link">
                    <xsl:value-of select="page/link"/>
                </xsl:when>
                <xsl:when test="external != ''">
                    <xsl:value-of select="external"/>
                </xsl:when>
                <xsl:when test="file/link">
                    <xsl:value-of select="file/link"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$url != ''">
            <li><a href="{$url}"><xsl:value-of select="label"/></a></li>
        </xsl:if>
    </xsl:template>
    
    <!-- Parse through contacts and output info if available -->
    <xsl:template match="contact-info" mode="structured">
        <ul class="contact">
            <xsl:if test="name !=''">
                <li class="name">
                    <strong><xsl:value-of select="name"/></strong>
                </li>
            </xsl:if>
            <xsl:if test="title !=''">
                <li class="contact-title">
                    <xsl:value-of select="title"/>
                </li>
            </xsl:if>
            <xsl:if test="phone !=''">
                <li class="contact-phone">
                    Phone: 
                    <xsl:value-of select="phone"/>
                </li>
            </xsl:if>
            <xsl:if test="e-mail !=''">
                <li class="contact-email">
                    Email: 
                    <a href="mailto:{e-mail}"><xsl:value-of select="e-mail"/></a>
                </li>
            </xsl:if>
        </ul>
    </xsl:template>
    
    <!-- xalan date converter required -->
    <xalan:component functions="convertDate,getYear" prefix="date-converter">
        <xalan:script lang="javascript">
            function getYear(date) {
            var d = new Date(date);
            var showyear = d.getUTCFullYear();
            return showyear;
            }
            
            function convertDate(date) {
            var d = new Date(date);
            var month= String(d.getUTCMonth() + 101);
            <!-- jan starts at 0, add one. add 100 for extra digits -->
            var month2 = month.substr(1);
            <!-- converts to 2 digit format -->
            var day= String(d.getUTCDate() + 100);
            var day2 = day.substr(1);
            <!-- convert year to 2012-06-12 -->
            var showdate = d.getUTCFullYear() + '-' + month2 + '-' + day2; 
            var showdate = month2 + '-' + day2 + '-' +  d.getUTCFullYear() ; 
            return showdate;
            }
        </xalan:script>
    </xalan:component>
    
    <xsl:template match="content" mode="structured">
        <div>
            <!-- add class for wide/no rt col -->
            <xsl:attribute name="class"> data-entry <xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'">wide</xsl:if>
            </xsl:attribute>
            <!-- optional overview -->
            <xsl:if test="main-content/descendant::*">
                <div class="overview clearfix">
                    <xsl:apply-templates mode="structured" select="main-content"/>
                </div>
            </xsl:if>
            <xsl:if test="section-content/section-heading/heading != '' or section-content/section-images/type != 'Do Not Display' or section-content/main !='' or section-content/figure/image/path != '/'">
                <xsl:apply-templates mode="standard" select="section-content"/>
            </xsl:if>
        </div>
        <!-- end outer data-entry div -->
    </xsl:template>
    
    <xsl:template match="main-content" mode="structured">
        <xsl:if test="main-images/type != 'Do Not Display' and main-images/display = 'Before'">
            <xsl:apply-templates mode="structured" select="main-images"/>
        </xsl:if>
        <xsl:if test="figure/image/name">
            <xsl:apply-templates mode="structured" select="figure"/>
        </xsl:if>
        <xsl:if test="main !=''">
            <xsl:choose>
                <xsl:when test="$from-rss = 'Yes'">
                    <xsl:apply-templates mode="rss" select="main/node()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="structured" select="main/node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="main-images/type != 'Do Not Display' and main-images/display = 'After'">
            <xsl:apply-templates select="main-images"/>
        </xsl:if>
    </xsl:template>

    <!-- main visual -->
    <xsl:template match="main-images" mode="structured">
       <!-- add layout options - image only -->
        <xsl:if test="image/path != '/' or slideshow-block/path != '/' or code != ''">
            <xsl:variable name="img_src">
                <xsl:apply-templates mode="image" select="image/link"/>
            </xsl:variable>
            <figure id="main-visual">
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="layout = 'Full-width' and type = 'Image'">img-wide</xsl:when>
                        <xsl:when test="layout = 'Full-width' and type = 'Video'">img-wide</xsl:when>
                        <xsl:when test="type='Slideshow'">slideshow</xsl:when>
                        <xsl:when test="type='Photo Gallery'">gallery</xsl:when>
                        <xsl:when test="type='Video Gallery'">video-gallery</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$from-rss = 'Yes'">
                        <xsl:if test="type = 'Image'">
                            <img alt="" src="{$img_src}"/>
                            <xsl:if test="credit != '' ">
                                <p class="photo-credit">Photo credit: <xsl:value-of select="credit"/></p>
                            </xsl:if>
                            <xsl:if test="caption!=''">
                                <figcaption>
                                    <xsl:value-of select="caption"/>
                                </figcaption>
                            </xsl:if>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="type = 'Image'">
                                <img alt="" src="{$img_src}"/>
                                <xsl:if test="credit != '' ">
                                    <p class="photo-credit">Photo credit: <xsl:value-of select="credit"/></p>
                                </xsl:if>
                                <xsl:if test="caption!=''">
                                    <figcaption>
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
                    </xsl:otherwise>
                </xsl:choose>

            </figure>
        </xsl:if>
    </xsl:template>
    <!-- section content -->
    <xsl:template match="section-content" mode="standard">
        <section class="clearfix" id="section{position()}">
            <xsl:if test="section-heading/heading != ''">
                <xsl:choose>
                    <xsl:when test="section-heading/section-heading-level = 'Heading 2'">
                        <h2><xsl:value-of select="section-heading/heading"/></h2>
                    </xsl:when>
                    <xsl:when test="section-heading/section-heading-level = 'Heading 3'">
                        <h3><xsl:value-of select="section-heading/heading"/></h3>
                    </xsl:when>
                    <xsl:when test="section-heading/section-heading-level = 'Heading 4'">
                        <h4><xsl:value-of select="section-heading/heading"/></h4>
                    </xsl:when>
                    <xsl:when test="section-heading/section-heading-level = 'Heading 5'">
                        <h5><xsl:value-of select="section-heading/heading"/></h5>
                    </xsl:when>
                    <xsl:when test="section-heading/section-heading-level = 'Heading 6'">
                        <h6><xsl:value-of select="section-heading/heading"/></h6>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:call-template name="section-inner"/>
        </section>
    </xsl:template>

    <!-- section images -->
    <xsl:template match="section-images" mode="structured">
        <!-- add layout options - image only -->
        <xsl:if test="image/path != '/' or code != ''">
            <figure class="img-wide section-visual">
                <!--            <xsl:attribute name="class">
                <xsl:choose>
                <xsl:when test="layout='Full-width' and type='Image'">img-wide</xsl:when>
                <xsl:when test="layout='Full-width' and type='Video'">img-wide</xsl:when>
                <xsl:when test="layout='Narrow - Right' and type='Image'">img-half pull-right</xsl:when>
                <xsl:when test="layout='Narrow - Left' and type='Image'">img-half pull-left</xsl:when>
                </xsl:choose>
                </xsl:attribute> -->
                <xsl:variable name="img_src">
                    <xsl:apply-templates mode="image" select="image/link"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$from-rss = 'Yes'">
                        <xsl:if test="type = 'Image'">
                            <img alt="" src="{$img_src}"/>
                            <xsl:if test="credit != '' ">
                                <p class="photo-credit">Photo credit: <xsl:value-of select="credit"/></p>
                            </xsl:if>
                            <xsl:if test="caption!=''">
                                <figcaption>
                                    <xsl:value-of select="caption"/>
                                </figcaption>
                            </xsl:if>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="type = 'Image'">
                                <img alt="" src="{$img_src}"/>
                                <xsl:if test="credit != '' ">
                                    <p class="photo-credit">Photo credit: <xsl:value-of select="credit"/></p>
                                </xsl:if>
                                <xsl:if test="caption!=''">
                                    <figcaption>
                                        <xsl:value-of select="caption"/>
                                    </figcaption>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="type = 'Video'">
                                <xsl:call-template name="video"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </figure>
        </xsl:if>
    </xsl:template>
    <!-- end section -->

    <!--subsection content for lower level headings -->
    <xsl:template name="sub-section">
        <xsl:if test="section-heading/heading!=''">
            <xsl:choose>
                <xsl:when test="section-heading/section-heading-level = 'Heading 3'">
                    <h3><xsl:value-of select="section-heading/heading"/></h3>
                </xsl:when>
                <xsl:when test="section-heading/section-heading-level = 'Heading 4'">
                    <h4><xsl:value-of select="section-heading/heading"/></h4>
                </xsl:when>
                <xsl:when test="section-heading/section-heading-level = 'Heading 5'">
                    <h5><xsl:value-of select="section-heading/heading"/></h5>
                </xsl:when>
                <xsl:when test="section-heading/section-heading-level = 'Heading 6'">
                    <h6><xsl:value-of select="section-heading/heading"/></h6>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:call-template name="section-inner"/>
        <!-- or call template for more indepth options? -->
    </xsl:template>

    <!-- inner section content -->
    <xsl:template name="section-inner">
        <xsl:if test="section-images/type != 'Do Not Display' and section-images/display = 'Before'">
            <xsl:apply-templates mode="structured" select="section-images"/>
        </xsl:if>
        <xsl:if test="figure/image/name">
            <xsl:apply-templates mode="structured" select="figure"/>
        </xsl:if>
        <xsl:if test="main !=''">
            <xsl:choose>
                <xsl:when test="$from-rss = 'Yes'">
                    <xsl:apply-templates mode="rss" select="main/node()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="structured" select="main/node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="section-images/type != 'Do Not Display' and section-images/display = 'After'">
            <xsl:apply-templates mode="structured" select="section-images"/>
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
    <xsl:template match="figure" mode="structured">
        <xsl:variable name="span">
            <xsl:choose>
                <xsl:when test="width = '30%'">thirty-percent</xsl:when>
                <xsl:when test="width = '40%'">forty-percent</xsl:when>
                <xsl:when test="width = '50%'">fifty-percent</xsl:when>
                <xsl:when test="width = '60%'">sixty-percent</xsl:when>                    
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="float">
            <xsl:choose>
                <xsl:when test="align='Left'">pull-left</xsl:when>
                <xsl:when test="align='Right'">pull-right</xsl:when>    
            </xsl:choose>
        </xsl:variable>
        <figure class="structured-inset {$span} {$float}">
        <xsl:variable name="img_src">
            <xsl:apply-templates mode="image" select="image/link"/>
        </xsl:variable>
            <xsl:choose>
                <xsl:when test="link/page/path != '/' or link/external != '' or link/file/path != '/'">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="link/page/path != '/'"><xsl:value-of select="link/page/link"/></xsl:when>
                                <xsl:when test="link/external != ''"><xsl:value-of select="link/external"/></xsl:when>
                                <xsl:when test="link/file/path != '/'"><xsl:value-of select="link/file/link"/></xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <img alt="" src="{$img_src}"/>
                        <xsl:if test="credit != '' ">
                            <p class="photo-credit">Photo credit: <xsl:value-of select="credit"/></p>
                        </xsl:if>
                        <xsl:if test="caption != ''">
                            <figcaption>
                                <xsl:value-of select="caption"/>
                            </figcaption>
                        </xsl:if>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <img alt="" src="{$img_src}"/>
                    <xsl:if test="credit != '' ">
                        <p class="photo-credit">Photo credit: <xsl:value-of select="credit"/></p>
                    </xsl:if>
                    <xsl:if test="caption != ''">
                        <figcaption>
                            <xsl:value-of select="caption"/>
                        </figcaption>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </figure>
    </xsl:template>
    
    <xsl:template match="link" mode="image">
        <xsl:variable name="src_domain">
            <xsl:choose>
                <xsl:when test="contains(.,'site://Library - MARBL')">
                    <xsl:text>http://marbl.library.emory.edu/</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'site://Library - Woodruff')">
                    <xsl:text>http://web.library.emory.edu/</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'site://Library - Oxford')">
                    <xsl:text>http://oxford.library.emory.edu/</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!--<xsl:choose>-->
        <!--    <xsl:when test="$from-rss = 'Yes'">-->
        <!--        <xsl:value-of select="concat($src_domain,substring-after(../path,$site_path))"/>-->
        <!--    </xsl:when>-->
        <!--    <xsl:otherwise>-->
        <!--        <xsl:value-of select="."/>-->
        <!--    </xsl:otherwise>-->
        <!--</xsl:choose>-->
                <xsl:value-of select="concat($src_domain,substring-after(../path,$site_path))"/>
    </xsl:template>
    
    <!-- template for adding <p> tags to WYSIWYG content without paragraph tags -->
    <xsl:template match="main/node()" mode="structured">
        <xsl:copy-of select="."/>
        <!--<xsl:call-template name="strip-wysiwyg"/>-->
    </xsl:template>

</xsl:stylesheet>
