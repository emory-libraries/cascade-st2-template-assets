<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:atom="http://www.w3.org/2005/Atom">
 <!-- process simple and complex homepage data def options 
     process and calculate grid spans needed
     most functionality is imported from separate stylesheets
 -->
    
    <xsl:import href="/_cms/xsl/components/hero-search-box.xsl"/>
    <xsl:import href="/_cms/xsl/components/hero-static-or-random.xsl"/>
    <xsl:import href="/_cms/xsl/components/hero-interval.xsl"/>      
    <xsl:import href="/_cms/xsl/components/content-box.xsl"/>
    <xsl:import href="/_cms/xsl/components/home-slider.xsl"/>
    <xsl:import href="/_cms/xsl/components/home-featured-links.xsl"/>
    <xsl:import href="/_cms/xsl/components/books-slider.xsl"/>

    
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/callout-import.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/wysiwyg-home.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/testimonial.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/feature.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/featured-bio.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/short-stack.xsl"/>

    <xsl:import href="site://Standard Template v2/_cms/xsl/components/calendar-trumba.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/widget-code-import.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/feed-generic.xsl"/>

    <xsl:import href="/_cms/xsl/standard-modified/homepage-gbl.xsl"/>
    
    
    <xsl:variable name="remove-gutters">
        <xsl:choose>
            <xsl:when test="//calling-page/system-page/dynamic-metadata[name='remove-gutters']/value='Yes'">true</xsl:when>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:output indent="yes"/>
    <xsl:template match="system-index-block">
        <xsl:apply-templates mode="homepage" select="calling-page/system-page/system-data-structure"/>   
    </xsl:template>
    
    <xsl:template match="system-data-structure" mode="homepage">
        <xsl:if test="$remove-gutters = 'true'">
            <remove-gutters><xsl:value-of select="$remove-gutters"/></remove-gutters>
        </xsl:if>
        <xsl:if test="insert-notice = 'Yes'">
            <xsl:variable name="alert-type">
                <xsl:choose>
                    <xsl:when test="notice/notice-type = 'Warning'">alert-error</xsl:when>
                    <xsl:when test="notice/notice-type = 'Information'">alert-info</xsl:when>
                </xsl:choose>
            </xsl:variable>
            <div><xsl:attribute name="class">library-notice alert <xsl:value-of select="$alert-type"/></xsl:attribute>
                <h2><xsl:value-of select="notice/heading"/></h2>
                <xsl:copy-of select="notice/message/node()"/>
            </div>
        </xsl:if>
        <xsl:if test="top-row">
            <xsl:call-template name="goizueta-homepage"/>
        </xsl:if>
        <xsl:if test="//site-id = 'oxford'">
            <xsl:apply-templates mode="oxford" select="toprow"/>
        </xsl:if>
        <xsl:if test="toprow and not(//site-id)">
            <xsl:apply-templates mode="default" select="toprow"/>
        </xsl:if>
        <xsl:if test="feature-row">
            <xsl:apply-templates select="feature-row"/>
        </xsl:if>
        <xsl:if test="intro-row">
            <xsl:apply-templates select="intro-row"/>
        </xsl:if>
        <xsl:if test="slider/component/path != '/'">
            <xsl:apply-templates select="slider"/>
        </xsl:if>
        <xsl:apply-templates select="row"/>
    </xsl:template>
    
    <!-- Old top row -->
    <xsl:template match="toprow" mode="default">
        <div>
            <xsl:attribute name="class">hero span12</xsl:attribute>
            <xsl:if test="background/path != '/'">
                <div class="background">
                    <img>
                        <xsl:attribute name="src">[system-asset]<xsl:value-of select="background/path"/>[/system-asset]</xsl:attribute>
                        <xsl:attribute name="alt"/>
                    </img>
                </div>
            </xsl:if>
            <xsl:if test="search">
                <xsl:call-template name="search-form-home">
                    <xsl:with-param name="placement" select="'toprow'"/>
                    <xsl:with-param name="background" select="'true'"/>
                    <xsl:with-param name="library" select="'woodruff'"/>
                    <xsl:with-param name="span" select="'span7'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="hero">
                <xsl:apply-templates mode="small-right" select="hero"/>
            </xsl:if>
            <xsl:if test="hero-large">
                <xsl:apply-templates mode="large-left" select="hero-large"/>
            </xsl:if>
            <xsl:if test="link-box">
                <xsl:call-template name="featured-links-home">
                    <xsl:with-param name="placement" select="'toprow'"/>
                    <xsl:with-param name="library" select="'whsc'"/>
                    <xsl:with-param name="span" select="'span4'"/>
                </xsl:call-template>
            </xsl:if>
        </div>
        <!-- /first row -->
    </xsl:template>

    <!--oxford top row -->
    <xsl:template match="toprow" mode="oxford">
        <xsl:comment>Start the top row</xsl:comment>
        <div><xsl:attribute name="class">hero span12 oxford</xsl:attribute>
            <xsl:if test="hero">
                <xsl:apply-templates mode="oxford" select="hero"/>
            </xsl:if>
        </div>
    </xsl:template>
    
    <!-- small hero on right - woodruff and old oxford -->
    <xsl:template match="hero" mode="small-right">
        <aside class="span4">
            <xsl:choose>
                <xsl:when test="type='Basic Image'">
                    <xsl:call-template name="hero-static"/>
                </xsl:when>
                <xsl:when test="type='Random Image on Refresh'">
                    <xsl:call-template name="hero-static"/>
                </xsl:when>
                <xsl:when test="type='Timed Slideshow'">
                    <xsl:call-template name="hero-interval">
                        <xsl:with-param name="span">span4</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="type='Content Box'">
                    <xsl:apply-templates select="descendant::content-box"><xsl:with-param name="page-type" select="'homepage'"/></xsl:apply-templates>
                </xsl:when>
            </xsl:choose>
        </aside>
    </xsl:template>

    <!-- large hero on left - whsc -->
    <xsl:template match="hero-large" mode="large-left">
        <div class="span8">
            <xsl:choose>
                <xsl:when test="type='Basic Image'">
                    <xsl:call-template name="hero-static"/>
                </xsl:when>
                <xsl:when test="type='Random Image on Refresh'">
                    <xsl:call-template name="hero-static"/>
                </xsl:when>
                <xsl:when test="type='Timed Slideshow'">
                    <xsl:call-template name="hero-interval">
                        <xsl:with-param name="span">span8</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>

    <!-- large hero on left - oxford -->
    <xsl:template match="hero" mode="oxford">
        <xsl:comment>Insert the hero</xsl:comment>
        <div class="span8">
            <xsl:choose>
                <xsl:when test="type='Basic Image'">
                    <xsl:call-template name="hero-static"/>
                </xsl:when>
                <xsl:when test="type='Random Image on Refresh'">
                    <xsl:call-template name="hero-static"/>
                </xsl:when>
                <xsl:when test="type='Timed Slideshow'">
                    <xsl:call-template name="hero-interval">
                        <xsl:with-param name="span">span8</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </div>
        <div class="cta-box library-search span4">
            <xsl:apply-templates mode="oxford" select="resource-links"/>
        </div>
    </xsl:template>

    <!-- Resource links for Oxford -->
    <xsl:template match="resource-links" mode="oxford">
        <!--insert resource links-->
        <xsl:if test="heading != ''"><h2><xsl:value-of select="heading"/></h2></xsl:if>
        <xsl:for-each select="link">
            <!-- define appropriate link as variable -->
            <xsl:variable name="link-url">
                <xsl:choose>
                    <xsl:when test="link-type = 'Internal Cascade Page'"><xsl:value-of select="page/link"/></xsl:when>
                    <xsl:when test="link-type = 'External URL'"><xsl:value-of select="external"/></xsl:when>
                    <xsl:when test="link-type = 'File or Document'"><xsl:value-of select="file/link"/></xsl:when>
                </xsl:choose>
            </xsl:variable>
            <!-- define appropriate new window/tab or same window/tab -->
            <xsl:variable name="link-target">
                <xsl:choose>
                    <xsl:when test="link-type = 'External URL' or link-type = 'File or Document'">_blank</xsl:when>
                    <xsl:otherwise>_self</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- define text of link -->
            <xsl:variable name="link-label">
                <xsl:choose>
                    <!-- use custom link label if 'Override Title' is turned on or link type is external or file/document-->
                    <xsl:when test="options[value = 'Override Title'] or link-type = 'External URL' or link-type = 'File or Document'"><xsl:value-of select="link-label"/></xsl:when>
                    <!-- otherwise assume it's a page with a title -->
                    <xsl:otherwise><xsl:value-of select="page/title"/></xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- Write Link -->
            <a href="{$link-url}" target="{$link-target}">
                <h3><xsl:value-of select="$link-label"/></h3>
            </a>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="feature-row">
        <section class="cta-box marbl-exhibits span12 equal-height-row thumbnails">
            <xsl:apply-templates select="feature"/>
        </section>
        <!-- /first row -->
    </xsl:template>

    <xsl:template match="feature">
        <article class="span3 equal-height">
            <xsl:choose>
                <xsl:when test="link/page/path != '/' or link/external != ''">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="link/page/path != '/'">
                                    <xsl:value-of select="link/page/link"/>
                                </xsl:when>
                                <xsl:when test="link/external != ''">
                                    <xsl:value-of select="link/external"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <figure>
                            <img>
                                <xsl:attribute name="src">[system-asset]<xsl:value-of select="image/path"/>[/system-asset]</xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:if test="alt != ''">
                                        <xsl:value-of select="alt"/>
                                    </xsl:if>
                                </xsl:attribute>
                            </img>
                        </figure>
                        <xsl:if test="title != '' or subtitle != ''">
                            <div class="info">
                                <h3>
                                    <xsl:if test="title != ''">
                                        <strong><xsl:value-of select="title"/></strong>
                                    </xsl:if>
                                    <xsl:if test="subtitle != ''">
                                        <xsl:choose>
                                            <xsl:when test="italicize-subtitle = 'Yes'">
                                                <em><xsl:value-of select="subtitle"/></em>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="subtitle"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                </h3>
                            </div>
                        </xsl:if>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <figure>
                        <img>
                            <xsl:attribute name="src">[system-asset]<xsl:value-of select="image/path"/>[/system-asset]</xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:if test="alt != ''">
                                    <xsl:value-of select="alt"/>
                                </xsl:if>
                            </xsl:attribute>
                        </img>
                    </figure>
                    <xsl:if test="title != '' or subtitle != ''">
                        <div class="info">
                            <h3>
                                <xsl:if test="title != ''">
                                    <strong><xsl:value-of select="title"/></strong>
                                </xsl:if>
                                <xsl:if test="subtitle != ''">
                                    <xsl:choose>
                                        <xsl:when test="italicize-subtitle = 'Yes'">
                                            <em><xsl:value-of select="subtitle"/></em>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="subtitle"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </h3>
                        </div>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </article>
    </xsl:template>

    <xsl:template match="intro-row">
        <div>
            <xsl:attribute name="class">home-intro span12</xsl:attribute>
            <xsl:if test="search">
                <xsl:call-template name="search-form-home">
                    <xsl:with-param name="placement" select="'intro-row'"/>
                    <xsl:with-param name="library" select="'marbl'"/>
                    <xsl:with-param name="span" select="'span6'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="content-box/component/path != '/'">
                <xsl:apply-templates mode="what-is-marbl" select="content-box/component/content/system-data-structure/content-box/entry"/>
            </xsl:if>
        </div>
        <!-- /first row -->
    </xsl:template>

    <xsl:template match="slider">
        <section class="utility">
            <xsl:call-template name="home-slider"/>
        </section>
    </xsl:template>

    <xsl:template match="content-box/component/content/system-data-structure/content-box/entry" mode="what-is-marbl">
        <aside class="intro span6">
            <h2><xsl:value-of select="heading"/></h2>
            <xsl:copy-of select="body-content/node()"/>
        </aside>
    </xsl:template>
    
    <!-- process the individual item types and apply correctly classed divs -->
    <xsl:template match="item" mode="toprow">
        <xsl:call-template name="content-item"/>
    </xsl:template>
    
    <!-- lower row(s) -->
    <xsl:template match="row">
        <xsl:variable name="row-number">row<xsl:value-of select="position()"/></xsl:variable>
        <xsl:variable name="row-item-count"><xsl:value-of select="count(item[type2!='Select an option'])"/></xsl:variable>
        <xsl:variable name="row-callouts-count"><xsl:value-of select="count(item[type2='Callouts']/callout)"/></xsl:variable><!-- we need the sub-item here for the even/odd count -->
        <!-- test user adjusted widths prior to applying -->
        <!--<xsl:variable name="row-manual-span-count"><xsl:value-of select="substring-before(width-span, ' -')"/></xsl:variable>
            user spans = <xsl:value-of select="$row-manual-span-count"/>-->
        <div>
            <xsl:attribute name="class">row home-row<xsl:if test="row-height='Yes'"> equal-height-row</xsl:if><xsl:if test="item[type2='Callouts'][callout-location='Horizontal row'] and $row-item-count = 1"> callouts-horiz-row</xsl:if></xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="$row-number"/></xsl:attribute>
            <xsl:for-each select="item[type2!='Select an option']">
                <xsl:call-template name="content-item">
                    <xsl:with-param name="row-number"><xsl:value-of select="$row-number"/></xsl:with-param>
                    <xsl:with-param name="row-item-count"><xsl:value-of select="$row-item-count"/></xsl:with-param>
                    <xsl:with-param name="row-callouts-count"><xsl:value-of select="$row-callouts-count"/></xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    
    <xsl:template name="content-item">
        <xsl:param name="row-item-count"/>
        <xsl:param name="row-callouts-count"/>
        <xsl:param name="row-number"/>
        <div>
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="ancestor::toprow">hero-col</xsl:when>
                    <xsl:otherwise><xsl:value-of select="$row-number"/>-group<xsl:value-of select="position()"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <!-- calculate span# needed for bootstrap grid -->
            <xsl:attribute name="class">component span<xsl:choose>
                <xsl:when test="type2='Callouts' and callout-location='Horizontal row'">12</xsl:when>
                <xsl:when test="type2='Callouts'">3</xsl:when><!-- must be close to first -->
                <!-- hero col: always span3 if enabled -->
                <xsl:when test="ancestor::toprow">3</xsl:when>
                <!-- equally divided spans - no callouts -->
                <xsl:when test="not(ancestor::toprow) and $row-callouts-count=0">
                    <xsl:value-of select="12 div $row-item-count"/>
                </xsl:when>
                <!-- 4 items w/w/o callouts -->
                <xsl:when test="not(ancestor::toprow) and $row-item-count = 4">3 </xsl:when>
                <!-- stacked item -->
                <!-- no way to know how many? need to be nested -->
                <!-- adjust spans for callouts + 2 other elements -->
                <xsl:when test="position() = 1 and (preceding-sibling::item[type2='Callouts'] or following-sibling::item[type2='Callouts']) and $row-item-count = 3">4 </xsl:when>
                <xsl:when test="position() = 2 and (preceding-sibling::item[type2='Callouts'] or following-sibling::item[type2='Callouts']) and $row-item-count = 3">5 </xsl:when>
                <xsl:when test="position() = 3 and (preceding-sibling::item[type2='Callouts'] or following-sibling::item[type2='Callouts']) and $row-item-count = 3">4 </xsl:when>
                <xsl:when test="(preceding-sibling::item[type2='Callouts'] or following-sibling::item[type2='Callouts']) and $row-item-count = 2">9</xsl:when>           
                <xsl:otherwise>-nospan</xsl:otherwise>
                <!-- <xsl:otherwise><xsl:value-of select="$non-callout-span-calc1 div $bottom-row-noncallouts-count"/></xsl:otherwise>-->
            </xsl:choose>
                <!-- confirm news, calendar, and social media classes as appropriate -->
                <xsl:if test="(type2='Callouts')"> callout-set</xsl:if>
                <xsl:if test="type2='Testimonial'"> testimonial feature</xsl:if><xsl:if test="type2='Feature'"> feature</xsl:if>
                <xsl:if test="type2='News Center Widget'"> news-feed<xsl:choose>
                    <xsl:when test="descendant::news-center-widget/layout = 'Feature Story Above'"> news-widget-feature</xsl:when>
                    <xsl:when test="descendant::news-center-widget/layout = 'Headlines Only'"> news-widget-simple</xsl:when>
                    <xsl:when test="descendant::news-center-widget/layout = 'Headlines with Dates'"> news-widget-simple-dates</xsl:when>
                </xsl:choose></xsl:if><xsl:if test="type2='Calendar'">
                    calendar</xsl:if><xsl:if test="type2 = 'Misc Feed'"> news-feed feed-block</xsl:if>
                <xsl:if test="position()=1 and not(ancestor::toprow) and not($row-item-count = 1)"> first</xsl:if>
                <xsl:if test="position()=last() and not(ancestor::toprow) and not($row-item-count = 1)"> last</xsl:if>
                <xsl:if test="ancestor::row/row-height='Yes'"> equal-height</xsl:if>
                <!--<xsl:if test="ancestor::row/row-height='Yes' and type2!='Stacked Boxes'"> equal-height</xsl:if>-->
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="type2='Books Slider'">
                    <xsl:apply-templates select="descendant::books-slider"/>
                </xsl:when>
                <xsl:when test="type2='Content Box'">
                    <xsl:apply-templates select="descendant::content-box"><xsl:with-param name="page-type" select="'homepage'"/></xsl:apply-templates>
                </xsl:when>
                <xsl:when test="type2='Flexible Entry'">
                    <xsl:call-template name="wysiwyg-home"/>
                </xsl:when>
                <xsl:when test="type2='Testimonial'">
                    <xsl:apply-templates select="block/content/system-data-structure/testimonial"/>
                </xsl:when>
                <xsl:when test="type2='Feature'">
                    <xsl:apply-templates select="block/content/system-data-structure/feature"/>
                </xsl:when>
                <xsl:when test="type2='Profile'">
                    <xsl:apply-templates select="block/content/system-data-structure/featured-bio"/>
                </xsl:when>
                <xsl:when test="type2='News Center Widget'"><!-- JS parser vs other types -->
                    <xsl:apply-templates select="block/content/system-data-structure/news-center-widget">
                        <xsl:with-param name="row-number">news-<xsl:value-of select="$row-number"/>-group<xsl:value-of select="position()"/></xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="type2='Calendar - Trumba'">
                    <xsl:apply-templates select="block/content/system-data-structure/calendar-trumba"/>
                </xsl:when>
                <xsl:when test="type2='Misc Feed'">
                    <xsl:apply-templates select="block/content/rss | block/content/atom:feed">
                        <xsl:with-param name="summary"><xsl:value-of select="block/dynamic-metadata[name='story-summary']/value"/></xsl:with-param>
                        <xsl:with-param name="show-dates"><xsl:value-of select="block/dynamic-metadata[name='dates']/value"/></xsl:with-param>
                        <xsl:with-param name="limit"><xsl:value-of select="block/dynamic-metadata[name='max-headlines']/value"/></xsl:with-param>
                        <xsl:with-param name="heading"><xsl:value-of select="block/dynamic-metadata[name='heading']/value"/></xsl:with-param>
                        <xsl:with-param name="feed-link"><xsl:value-of select="block/dynamic-metadata[name='feed-more-url']/value"/></xsl:with-param>
                         <xsl:with-param name="subscribe-link"><xsl:value-of select="block/dynamic-metadata[name='feed-icon-subscribe']/value"/></xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="type2='Stacked Boxes'">
                    <xsl:apply-templates select="block/content/system-data-structure/stacked-element"/>
                </xsl:when>
                <xsl:when test="type2='Callouts'">
                    <xsl:if test="heading!='' and not(ancestor::toprow)">
                        <h2 class="boxed-heading callout-heading">
                            <xsl:value-of select="heading"/>
                        </h2>
                    </xsl:if>
                    <ul>
                        <xsl:attribute name="class">callouts-list<xsl:if test="heading!=''"> callouts-heading</xsl:if><xsl:if test="callout-location='Horizontal row'"> callouts-horiz</xsl:if>
                            <xsl:choose><!-- alternate list styles for mobile views -->
                                <xsl:when test="$row-callouts-count mod 2 = 1">
                                    callouts-odd</xsl:when>
                                <xsl:otherwise> callouts-even</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:for-each select="callout">
                            <li>
                                <xsl:apply-templates select="descendant::system-data-structure/callout"/><!-- this is dodgy using exact xpath; why? -->
                            </li>
                        </xsl:for-each>
                    </ul>
                    <!-- imported -->
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>
    
    
</xsl:stylesheet>
