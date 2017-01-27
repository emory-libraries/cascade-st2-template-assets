<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/drafts/wysiwyg-strip-tags.xsl"/>
    <xsl:import href="/_cms/xsl/components/photo-gallery.xsl"/>
    <xsl:import href="/_cms/xsl/components/video-gallery.xsl"/>
    <xsl:import href="/_cms/xsl/components/interior-slideshow.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/calendar-trumba.xsl"/>
    <!--<xsl:import href="site://Standard Template v2/_cms/xsl/components/widget-code-import.xsl"/>-->
    <!-- alt for main img/media? can't require due to dd structure -->
    <xsl:template match="system-index-block">
        <xsl:apply-templates select="calling-page/system-page/system-data-structure"/>
    </xsl:template>
    <xsl:template match="system-data-structure">
        <div>
            <!-- add class for wide/no rt col -->
            <xsl:attribute name="class"> data-entry <xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'">wide</xsl:if>
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
                                                <xsl:value-of select="position()" />
                                            </xsl:otherwise>-->
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
            <xsl:call-template name="section-inner"/>
            <xsl:apply-templates select="section-content-boxes"/>
        </section>
    </xsl:template>
    <!-- section visual -->
    <xsl:template match="section-images">
        <!-- add layout options - image only -->
        <div class="img-wide" id="section-visual">
            <!--            <xsl:attribute name="class">
            <xsl:choose>
            <xsl:when test="layout='Full-width' and type='Image'">img-wide</xsl:when>
            <xsl:when test="layout='Full-width' and type='Video'">img-wide</xsl:when>
            <xsl:when test="layout='Narrow - Right' and type='Image'">img-half pull-right</xsl:when>
            <xsl:when test="layout='Narrow - Left' and type='Image'">img-half pull-left</xsl:when>
            </xsl:choose>
            </xsl:attribute> -->
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
    </xsl:template>
    <!-- end section -->
    <xsl:template name="section-content-accordion">
        <xsl:variable name="current" select="."/>
        <!--<xsl:choose>-->
        <xsl:if test="section-heading/heading!=''">
            <h2 class="accordion-heading">
                <a class="accordion-toggle" data-parent="#accordion" data-toggle="collapse" href="#collapse{position()}">
                    <span class="icon-angle-right"></span><xsl:value-of select="section-heading/heading"/>
                </a>
            </h2>
        </xsl:if>
        <!--<xsl:otherwise> [system-view:internal]Please provide a heading for:
                [/system-view:internal]Section <xsl:value-of select="position()" />
            </xsl:otherwise>-->
        <!-- fallback if user doens't populate -->
        <!--</xsl:choose>-->
        <div id="collapse{position()}">
            <!-- additional class "in" if expanded -->
            <xsl:attribute name="class"> accordion-body collapse <xsl:if test="expanded/value = 'Yes'">in</xsl:if>
            </xsl:attribute>
            <div class="accordion-inner">
                <xsl:call-template name="section-inner"/>
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
            <xsl:attribute name="class"> tab-pane <xsl:if test="position() = 1">active</xsl:if>
            </xsl:attribute>
            <xsl:call-template name="section-inner"/>
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
        <xsl:call-template name="section-inner"/>
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
                    <xsl:apply-templates select="main"/>
                </xsl:if>
                <!--<xsl:copy-of select="main/node()"/>-->
            </xsl:when>
            <xsl:when test="section-images/type != 'Do Not Display' and section-images/display = 'After'">
                <xsl:apply-templates select="figure"/>
                <xsl:if test="main !=''">
                    <xsl:apply-templates select="main"/>
                </xsl:if>
                <xsl:apply-templates select="section-images"/>
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
                <img alt="" src="{image/link}"/>
                <xsl:if test="caption != ''">
                    <figcaption class="muted">
                        <xsl:value-of select="caption"/>
                    </figcaption>
                </xsl:if>
            </figure>
        </xsl:if>
    </xsl:template>
    <!-- content-box row -->
    <xsl:template match="section-content-boxes">
   
        <xsl:if test="component/path != '/'">
            <div>
                <xsl:attribute name="class">
                    <xsl:text>content-box-row clearfix</xsl:text>
                    <xsl:if test="distinguish/value = 'Yes'"><xsl:text> distinguished</xsl:text></xsl:if>
                </xsl:attribute>
                <xsl:apply-templates select="component"/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="component">
        <div>
            <xsl:attribute name="class">content-box
                <xsl:choose>
                    <xsl:when test="count(preceding-sibling::component[path != '/']) + count(following-sibling::component[path != '/']) = 0"> span12</xsl:when>
                    <xsl:otherwise> span6 equal-height</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="descendant::news-center-widget">
                    <xsl:apply-templates select="descendant::news-center-widget"/>
                </xsl:when>
                <xsl:when test="descendant::calendar-trumba">
                    <xsl:apply-templates select="descendant::calendar-trumba"/>
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <!-- template for adding <p> tags to WYSIWYG content without paragraph tags -->
    <xsl:template match="main">
        <xsl:copy-of select="node()"/>
        <!--<xsl:call-template name="strip-wysiwyg"/>-->
    </xsl:template>
    <!--Most of this is copied directly from site://Standard Template v2/_cms/xsl/components/widget-code-import.xsl, but a lot of it has been hardcoded for this page type -->
   <xsl:template match="news-center-widget">
           <!-- use final path and name for script -->
        <script src="https://www.emory.edu/template_shared/oit_wdg/js/news_center/jquery.emoryfeed.min.js"></script>
        
        <script>
            $(document).ready(function () {
            <!--
                conditions here//-->

                                url = encodeURIComponent('<xsl:value-of select="feed_source"/>');
                                url = url.replace('amp%3B','');
                                
                                var newsWidget = {
            <xsl:choose>
                <xsl:when test="layout = 'Feature Story Above'">
                        preset: "1 - Emory Homepage",
                        url: url,
                                                addClass: ["emory-feed", "home-news"]
                </xsl:when>

                <xsl:when test="layout = '2 - Right Rail'">
                        preset: "2 - Emory Right Rail",
                        url: url,
                        title: {linkURL:'http://news.emory.edu', text: "Today\'s News »"},
                        viewAll: {linkURL:"http://news.emory.edu", text:"More News »"}
                </xsl:when>
                
                <xsl:when test="layout = '3 - Interior Narrow News - Feature Above'">
                        preset: "3 - Interior Narrow News - Feature Above",
                        url: url
                </xsl:when>
                
                 <xsl:when test="layout = '7 - Interior Narrow News - Feature Above - Alternate'">
                        preset: "3 - Interior Narrow News - Feature Above",
                        url: url,
                     <!-- check no RSS icon customizations to avoid conflict on alternate icon stuff later in script -->
                     <xsl:if test="custom_options/icon_alternate_feed_source='' and custom_options/icon_URL='' and not(custom_options/icon_internal/name)">
                        headingIcon: {src: "//www.emory.edu/home/img/rss.gif"},
                        </xsl:if>
                        alsoIcon: null               
                </xsl:when>
                
                <xsl:when test="layout = 'Headlines Only'">
                        preset: "4 - Simple Headlines Only",
                        url: url,
                        addClass: ["emory-feed", "simple-headlines"]
                </xsl:when>
               
                <xsl:when test="layout = '5 - Interior Wide News - Feature - Latest Headlines'">
                        preset: "5 - WHSC Wide News - Feature - Latest Headlines",
                        url: url
                </xsl:when>
                
                <xsl:when test="layout = 'Headlines with Dates'">
                        preset: "6 - Interior Narrow News - No Feature",
                        url: url,
                        addClass: ["emory-feed", 'interior-narrow-no-feature']
                </xsl:when>
                
                <xsl:when test="layout = '8 - Interior Audience News'">
                        preset: "1 - Emory Homepage",
                        url: url,
                        addClass: ["emory-feed", "home-news", "home-news-alt"]
                </xsl:when>               
            </xsl:choose>
          
            <!--
                apply custom options.always add prefix comma for IE//-->
                    
             <!--
                FEATURE READ MORE LINK TEXT//-->

               <xsl:if test="custom_options/feature_continue_text!=''">
                , 
                feature: {readMoreText: '<xsl:value-of select="custom_options/feature_continue_text"/>'}
               </xsl:if> 
            
            <!-- * ALSO HEADING TEXT - MAP TO LAYOUT TYPES?//-->
                    <xsl:if test="custom_options/heading_reg_headlines!=''">
                        ,
                        alsoTitle: {text:"<xsl:value-of select="custom_options/heading_reg_headlines"/>"}
                    </xsl:if>
            
            <!--
                OVERRIDE FEED HTML SOURCE LINK, FEED TITLE, VIEW ALL LINK AND TITLE//-->
             <xsl:if test="(custom_options/view_all_text!='' or custom_options/view_all_URL!='' or feed_heading_text!='') and (layout!='2 - Right Rail')">

            <xsl:choose>
                <xsl:when test="layout = '5 - Interior Wide News - Feature - Latest Headlines' and custom_options/whsc_viewall_addtl!=''">
                    ,
                    viewAll: [ { text: '<xsl:value-of select="custom_options/view_all_text"/>'}, { linkURL: '<xsl:value-of select="custom_options/whsc_viewall_addtl_url"/>', text: '<xsl:value-of select="custom_options/whsc_viewall_addtl"/>' } ]
                </xsl:when>
                 <!-- if not #5, and feed title, link url and link text overrides -->
                <xsl:when test="layout!='5 - Interior Wide News - Feature - Latest Headlines' and custom_options/view_all_text!='' and custom_options/view_all_URL!='' and feed_heading_text!=''">
                    ,
                    title: {linkURL:'<xsl:value-of select="custom_options/view_all_URL"/>', text: "<xsl:value-of select="feed_heading_text"/>"},
                    viewAll: { linkURL: '<xsl:value-of select="custom_options/view_all_URL"/>', text: '<xsl:value-of select="custom_options/view_all_text"/>' }
                </xsl:when>

                 <!-- if not #5, and feed title and link url overrides -->
                <xsl:when test="layout!='5 - Interior Wide News - Feature - Latest Headlines' and custom_options/view_all_text='' and custom_options/view_all_URL!='' and feed_heading_text!=''">
                    ,
                    title: {linkURL:'<xsl:value-of select="custom_options/view_all_URL"/>', text: "<xsl:value-of select="feed_heading_text"/>"},
                    viewAll: { linkURL: '<xsl:value-of select="custom_options/view_all_URL"/>'}
                </xsl:when>
                <!-- if not #5, and both link url and link text overrides -->
                <xsl:when test="layout!='5 - Interior Wide News - Feature - Latest Headlines' and custom_options/view_all_text!='' and custom_options/view_all_URL!=''">
                    ,
                    title: {linkURL:'<xsl:value-of select="custom_options/view_all_URL"/>'},
                    viewAll: { linkURL: '<xsl:value-of select="custom_options/view_all_URL"/>', text: '<xsl:value-of select="custom_options/view_all_text"/>' }
                </xsl:when>

                <!-- if not #5, and only link text overrides -->
                <xsl:when test="layout!='5 - Interior Wide News - Feature - Latest Headlines'  and custom_options/view_all_text!='' and custom_options/view_all_URL=''">
                    ,
                    viewAll: {text:"<xsl:value-of select="custom_options/view_all_text"/>"}                
                </xsl:when>
                
                 <!-- if not #5, and feed title overrides only: heading text  -->
                <xsl:when test="layout!='5 - Interior Wide News - Feature - Latest Headlines' and custom_options/view_all_URL='' and feed_heading_text!=''">
                    ,
                    title: {text: "<xsl:value-of select="feed_heading_text"/>"}
                </xsl:when>

                <!-- title: {linkURL:'url', text: "text"},
                    viewAll: {linkURL:"url", text:"text"} -->
                
                <!-- if not #5, and only link URL overrides -->
                <xsl:when test="layout!='5 - Interior Wide News - Feature - Latest Headlines' and custom_options/view_all_URL!='' and custom_options/view_all_text=''  and feed_heading_text=''">
                    ,
                    title: {linkURL:'<xsl:value-of select="custom_options/view_all_URL"/>'},
                   viewAll: { linkURL: '<xsl:value-of select="custom_options/view_all_URL"/>' }             
                </xsl:when>

                
               
           
            </xsl:choose>
        </xsl:if>
            
             <xsl:if test="max_number!='' and layout!='2 - Right Rail'">
                , 
                maxItems: <xsl:value-of select="max_number"/>
             </xsl:if>                   
                    <xsl:if test="link_target='Yes'">
                        ,
                        openLinksInNewWindow: true
                    </xsl:if>
                    
               <xsl:if test="custom_options/feature_override!='N/A' and layout!='2 - Right Rail'">
                   <xsl:choose>
                       <xsl:when test="custom_options/feature_override='Remove Feature'">
                           , 
                            feature: null</xsl:when>
                       <xsl:when test="custom_options/feature_override='Remove Thumbnail Only'">
                           , 
                            feature: {thumbnail: null}</xsl:when>
                   </xsl:choose>
              
            </xsl:if>
                    
           
          <!--
                #1, #7 #4, #6, #8 only - feed source and icons - headingIcon //-->
            <xsl:if test="(layout = 'Feature Story Above' or layout='7 - Interior Narrow News - Feature Above - Alternate'  or layout = 'Headlines Only' or layout = 'Headlines with Dates' or layout = '8 - Interior Audience News') and (custom_options/icon_alternate_feed_source!='' or custom_options/icon_URL!='' or custom_options/icon_internal/name)">
               ,
                headingIcon: {
                   
                <!-- if switching RSS image -->
                <!-- if #7 chosen, need to recreate the default image src - not in preset -->
                <xsl:if test="(layout='7 - Interior Narrow News - Feature Above - Alternate') and (custom_options/icon_URL='' or custom_options/icon_internal/name)">
                     src: "//www.emory.edu/home/img/rss.gif",
                    </xsl:if>
                
                
              <xsl:if test="custom_options/icon_URL!='' or custom_options/icon_internal/name">
                    src: 
                    '<xsl:choose>
                        <xsl:when test="custom_options/icon_URL!=''"><xsl:value-of select="custom_options/icon_URL"/></xsl:when>
                        <xsl:when test="custom_options/icon_internal/name"><xsl:value-of select="custom_options/icon_internal/path"/></xsl:when>
                        </xsl:choose>' 
                </xsl:if> 
                    
                    <!-- add comma if adding subscribe URL in addition to changing icon -->
                     
                    <xsl:if test="(custom_options/icon_alternate_feed_source!='') and (custom_options/icon_URL!='' or custom_options/icon_internal/name)">,
                    </xsl:if>

                     <xsl:if test="custom_options/icon_alternate_feed_source!=''">
                            linkURL: "<xsl:value-of select="custom_options/icon_alternate_feed_source"/>"
                        </xsl:if>
                    }<!-- close alsoIcon -->
                
            </xsl:if>  
         
             <!--
                #5, #3 feed icon and source override - alsoIcon //-->
            <xsl:if test="(layout = '5 - Interior Wide News - Feature - Latest Headlines' or layout = '3 - Interior Narrow News - Feature Above') and (custom_options/icon_alternate_feed_source!='' or custom_options/icon_URL!='' or custom_options/icon_internal/name)">
               <!-- create alsoIcon object -->
               ,
                alsoIcon: {
                <!-- add alternate feed URL if populated -->

                <xsl:if test="custom_options/icon_alternate_feed_source!=''">
                linkURL: "<xsl:value-of select="custom_options/icon_alternate_feed_source"/>"
                </xsl:if>
             <!-- add comma to separate subobjects if linkURL also needed -->
                     <xsl:if test="(custom_options/icon_alternate_feed_source!='') and (custom_options/icon_URL!='' or custom_options/icon_internal/name)">,
                     </xsl:if>
                <!-- add icon src -->
            <xsl:if test="custom_options/icon_URL!='' or custom_options/icon_internal/name">
                src: 
                "<xsl:choose>

                    <xsl:when test="custom_options/icon_URL!=''"><xsl:value-of select="custom_options/icon_URL"/></xsl:when>
                    <xsl:when test="custom_options/icon_internal/name"><xsl:value-of select="custom_options/icon_internal/path"/></xsl:when>
                </xsl:choose>"
                
            </xsl:if> 
            } <!-- close alsoIcon -->
            </xsl:if>
                     
            
<!-- show dates for feature and stories//-->

             <xsl:if test="custom_options/story_dates='Yes' and layout!='2 - Right Rail'">
                , 
                includeFeatureDate: true, 
                includeHeadlineDate: true  
             </xsl:if>
             }; <!-- close newsWidget object -->
             
             <!-- latest feature customization -->
             <xsl:if test="descendant::custom_options/unique_id = 'latest-feature'">
                 newsWidget.feature.useContentSnippet = true;
                 
             </xsl:if>
             $('#<xsl:value-of select="custom_options/unique_id"/>').emoryFeed(newsWidget);
             
             
             <!--
                close all JQ selectors / functions//-->

            });
            
        </script>

        <div id="{descendant::custom_options/unique_id}">
            <xsl:text> </xsl:text>
        </div>

    </xsl:template>

</xsl:stylesheet>
