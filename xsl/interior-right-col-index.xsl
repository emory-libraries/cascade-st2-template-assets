<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- generates right column entries based on folder index block of all components
    wraps some items in divs for css classes as needed (if not added via imported template
    -->

    <xsl:import href="site://Standard Template v2/_cms/xsl/components/hero-static-or-random.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/audience-nav.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/callout-import.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/wysiwyg-home.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/testimonial.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/feature.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/site-social-media-list.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/calendar-trumba.xsl"/>
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/widget-code-import.xsl"/>
    <xsl:import href="/_cms/xsl/components/link-set.xsl"/>
    <xsl:import href="/_cms/xsl/components/featured-bio.xsl"/>
    <xsl:import href="/_cms/xsl/components/hours-specific-content-box.xsl"/>
    <xsl:import href="/_cms/xsl/components/content-box.xsl"/>
    <xsl:import href="/_cms/xsl/components/ask-a-librarian.xsl"/>
    <!--
    process the index block.
    users control visual sequence via folder order.
    -->
    <xsl:variable name="thisPage" select="system-index-block/calling-page/system-page/path"/>
    <xsl:variable name="placement-add">Add to existing site-wide set</xsl:variable>
    <xsl:variable name="placement-replace">Replace site-wide set</xsl:variable>
    <xsl:variable name="placement-disable">Do not display this type on this page</xsl:variable>
    <xsl:template match="system-index-block">
        <xsl:apply-templates mode="toplevel" select="system-folder"/>
        <!-- process in order of subfolders -->
    </xsl:template>
    <xsl:template match="system-folder" mode="toplevel">
        <!-- <p><strong><xsl:value-of select="name"/>: order <xsl:value-of select="position()"/></strong></p> -->
        <!--Exclude 'search' folder-->
        <xsl:if test="name != 'search'">
            <xsl:call-template name="priority"/>
        </xsl:if>
        <!-- needs to be on a per type basis -->
    </xsl:template>
    <xsl:template name="priority">
        <!-- callouts -->
        <xsl:variable name="count-callouts">
            <xsl:value-of select="count(//system-page[system-data-structure/callout/placement/location='Site-wide Right'] | //system-page[system-data-structure/callout/placement/publish_to/path=$thisPage] | //calling-page/system-page/system-data-structure/side/item[type2='Callouts'])"/>
        </xsl:variable>
        <!-- relative to system folder. if there are callouts in the folder: -->
        <xsl:if test="descendant::system-page/system-data-structure/callout and $count-callouts!=0">
            <!-- debug -->
            <!-- <xsl:if test="//calling-page/system-page/system-data-structure/side/item[type2='Callouts']/item-priority=$placement-disable"> are disabled </xsl:if>-->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Callouts']/item-priority=$placement-disable)">
                <!-- APPLY CALLOUTS-->
                <!-- <xsl:value-of select="$count-callouts"/> -->
                <!-- troubleshoot how to not output UL if no callouts exist or are assigned -->
                <div class="component callout-set">
                    <ul>
                        <xsl:attribute name="class">callouts-list</xsl:attribute>
                        <!-- priority -->
                        <xsl:choose>
                            <!-- when local page items are set to replace the global ones: -->
                            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Callouts']/item-priority=$placement-replace">
                                <!--  replace callouts -->
                                <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Callouts']/callout-page/content">
                                    <li>
                                        <xsl:apply-templates select="system-data-structure/callout"/>
                                    </li>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- when local page items are additive: -->
                            <xsl:otherwise>
                                <!--  add callouts to the global ones -->
                                <xsl:if test="//system-page[not(ancestor::calling-page)][system-data-structure/callout/placement/location='Site-wide Right']">
                                    <!-- SITEWIDE-->
                                    <xsl:for-each select="//system-page[system-data-structure/callout/placement/location='Site-wide Right']">
                                        <li>
                                            <xsl:apply-templates select="system-data-structure/callout"/>
                                        </li>
                                    </xsl:for-each>
                                </xsl:if>
                                <xsl:if test="//system-page[not(ancestor::calling-page)][system-data-structure/callout/placement/location = 'Selected Pages Right']">
                                    <!-- SELECTED-->
                                    <xsl:for-each select="//system-page[not(ancestor::calling-page)][system-data-structure/callout/placement/location = 'Selected Pages Right'][system-data-structure/callout/placement/publish_to/path = $thisPage]">
                                        <li>
                                            <xsl:apply-templates select="system-data-structure/callout"/>
                                        </li>
                                    </xsl:for-each>
                                </xsl:if>
                                <!-- add-on callouts -->
                                <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Callouts']/callout-page/content">
                                    <!--  ADD ONs-->
                                    <li>
                                        <xsl:apply-templates select="system-data-structure/callout"/>
                                    </li>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </ul>
                </div>
            </xsl:if>
            <!-- end processing callouts -->
        </xsl:if>
        <!-- end callouts -->

        <!-- social -->
        <xsl:if test="descendant::system-data-structure/social-media-site-settings">

            <!-- debugging -->
            <!--SOCIAL MEDIA  <xsl:choose>
            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Social Media Icons']/item-priority=$placement-disable"> is disabled.</xsl:when>
            <xsl:when test="not(//calling-page/system-page/system-data-structure/side/item[type2='Social Media Icons']/item-priority=$placement-disable)"> is enabled.</xsl:when>
            </xsl:choose> Debug value of item-priority: <xsl:value-of select="//calling-page/system-page/system-data-structure/side/item[type2='Social Media Icons']/item-priority"/>
            -->
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Social Media Icons']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[social-media-site-settings] and //calling-page/system-page/system-data-structure/side/item[type2='Social Media Icons']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/social-media-site-settings]">
                            <!-- LOCAL SOCIAL - REPLACE GLOBAL SET-->
                            <div class="component social-icons-set">
                                <xsl:apply-templates select="block/content/system-data-structure/social-media-site-settings"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/social-media-site-settings/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/social-media-site-settings/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2B.1when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/social-media-site-settings/placement/publish_to/path = $thisPage][system-data-structure/social-media-site-settings/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES SOCIAL - add priority-->
                                <xsl:for-each select="descendant::system-block[system-data-structure/social-media-site-settings/placement/publish_to/path = $thisPage][system-data-structure/social-media-site-settings/placement/location='Selected Pages Right']">
                                    <div class="component social-icons-set">
                                        <xsl:apply-templates select="system-data-structure/social-media-site-settings"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- 2B.2 hen Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/social-media-site-settings/placement/location='Site-wide Right']">
                                <!--  SITEWIDE PAGES SOCIAL - add priority-->
                                <xsl:for-each select="descendant::system-block[system-data-structure/social-media-site-settings/placement/location='Site-wide Right']">
                                    <div class="component social-icons-set">
                                        <xsl:apply-templates select="system-data-structure/social-media-site-settings"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Social Media Icons']">
                            <!-- LOCAL SOCIAL - ADD TO GLOBAL SET-->
                            <div class="component social-icons-set">
                                <xsl:apply-templates select="block/content/system-data-structure/social-media-site-settings"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2C add local only - no globals exist-->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Social Media Icons']/item-priority=$placement-add">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Social Media Icons']">
                            <div class="component social-icons-set">
                                <xsl:apply-templates select="block/content/system-data-structure/social-media-site-settings"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
        <!-- feature -->
        <xsl:if test="descendant::system-data-structure/feature">
            <!-- debugging -->
            <!-- ITEM TYPE  <xsl:choose>
            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Feature']/item-priority=$placement-disable"> is disabled.</xsl:when>
            <xsl:when test="not(//calling-page/system-page/system-data-structure/side/item[type2='Feature']/item-priority=$placement-disable)"> is enabled.</xsl:when>
            </xsl:choose> Debug value of item-priority: <xsl:value-of select="//calling-page/system-page/system-data-structure/side/item[type2='Feature']/item-priority"/>
            -->
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Feature']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[feature] and //calling-page/system-page/system-data-structure/side/item[type2='Feature']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/feature]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="component">
                                <xsl:apply-templates select="block/content/system-data-structure/feature"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>

                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/feature/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/feature/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2B.1when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/feature/placement/publish_to/path = $thisPage][system-data-structure/feature/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/feature/placement/publish_to/path = $thisPage][system-data-structure/feature/placement/location='Selected Pages Right']">
                                    <div class="component">
                                        <xsl:apply-templates select="system-data-structure/feature"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- 2B.2 hen Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/feature/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/feature/placement/location='Site-wide Right']">
                                    <div class="component">
                                        <xsl:apply-templates select="system-data-structure/feature"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Feature']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="component">
                                <xsl:apply-templates select="block/content/system-data-structure/feature"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2C add local only - no globals exist -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Feature']/item-priority=$placement-add">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Feature']">
                            <div class="component">
                                <xsl:apply-templates select="block/content/system-data-structure/feature"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!--  profile -->
        <xsl:if test="descendant::system-data-structure/featured-bio">
            <!-- debugging -->
            <!-- profile  <xsl:choose>
            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Profile']/item-priority=$placement-disable"> is disabled.</xsl:when>
            <xsl:when test="not(//calling-page/system-page/system-data-structure/side/item[type2='Profile']/item-priority=$placement-disable)"> is enabled.</xsl:when>
            </xsl:choose> Debug value of item-priority: <xsl:value-of select="//calling-page/system-page/system-data-structure/side/item[type2='Profile']/item-priority"/>
            -->
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Profile']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[featured-bio] and //calling-page/system-page/system-data-structure/side/item[type2='Profile']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/featured-bio]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="component">
                                <xsl:apply-templates select="block/content/system-data-structure/featured-bio"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/featured-bio/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/featured-bio/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2B.1when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/featured-bio/placement/publish_to/path = $thisPage][system-data-structure/featured-bio/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/featured-bio/placement/publish_to/path = $thisPage][system-data-structure/featured-bio/placement/location='Selected Pages Right']">
                                    <div class="component">
                                        <xsl:apply-templates select="system-data-structure/featured-bio"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- 2B.2 hen Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/featured-bio/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/featured-bio/placement/location='Site-wide Right']">
                                    <div class="component">
                                        <xsl:apply-templates select="system-data-structure/featured-bio"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Profile']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="component">
                                <xsl:apply-templates select="block/content/system-data-structure/featured-bio"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2C add local only - no globals exist -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Profile']/item-priority=$placement-add">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Profile']">
                            <div class="component">
                                <xsl:apply-templates select="block/content/system-data-structure/featured-bio"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!--  Related Links -->
        <xsl:if test="descendant::system-data-structure/links">
            <!-- debugging -->
            <!-- ITEM TYPE  <xsl:choose>
            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Related Links']/item-priority=$placement-disable"> is disabled.</xsl:when>
            <xsl:when test="not(//calling-page/system-page/system-data-structure/side/item[type2='Related Links']/item-priority=$placement-disable)"> is enabled.</xsl:when>
            </xsl:choose> Debug value of item-priority: <xsl:value-of select="//calling-page/system-page/system-data-structure/side/item[type2='Related Links']/item-priority"/>
            -->
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Related Links']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[links] and //calling-page/system-page/system-data-structure/side/item[type2='Related Links']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/links]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="component quick-links">
                                <xsl:apply-templates select="block/content/system-data-structure/links"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/links/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/links/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2C.1when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/links/placement/publish_to/path = $thisPage][system-data-structure/links/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/links/placement/publish_to/path = $thisPage][system-data-structure/links/placement/location='Selected Pages Right']">
                                    <div class="component quick-links">
                                        <xsl:apply-templates select="system-data-structure/links"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- w2C.2 hen Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/links/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/links/placement/location='Site-wide Right']">
                                    <div class="component quick-links">
                                        <xsl:apply-templates select="system-data-structure/links"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Related Links']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="component quick-links">
                                <xsl:apply-templates select="block/content/system-data-structure/links"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Related Links']/item-priority=$placement-add">
                        <!-- 2C add local only - no globals exist -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Related Links']">
                            <div class="component quick-links">
                                <xsl:apply-templates select="block/content/system-data-structure/links"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
        <xsl:if test="descendant::system-data-structure/hours-main">
            <!-- debugging -->
            <!-- ITEM TYPE  <xsl:choose>
            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Hours']/item-priority=$placement-disable"> is disabled.</xsl:when>
            <xsl:when test="not(//calling-page/system-page/system-data-structure/side/item[type2='Hours']/item-priority=$placement-disable)"> is enabled.</xsl:when>
            </xsl:choose> Debug value of item-priority: <xsl:value-of select="//calling-page/system-page/system-data-structure/side/item[type2='Hours']/item-priority"/>
            -->
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Hours']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/hours-main] and //calling-page/system-page/system-data-structure/side/item[type2='Hours']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/hours-main]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="component quick-hours">
                                <xsl:apply-templates select="block/content/system-data-structure/hours-main"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/hours-main/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/hours-main/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2C.1when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/hours-main/placement/publish_to/path = $thisPage][system-data-structure/hours-main/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/hours-main/placement/publish_to/path = $thisPage][system-data-structure/hours-main/placement/location='Selected Pages Right']">
                                    <div class="component quick-hours">
                                        <xsl:apply-templates select="system-data-structure/hours-main"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- w2C.2 hen Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/hours-main/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/hours-main/placement/location='Site-wide Right']">
                                    <div class="component">
                                        <xsl:apply-templates select="system-data-structure/hours-main"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Hours']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="component quick-hours">
                                <xsl:apply-templates select="block/content/system-data-structure/hours-main"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Hours']/item-priority=$placement-add">
                        <!-- 2C add local only - no globals exist -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Hours']">
                            <div class="component quick-hours">
                                <xsl:apply-templates select="block/content/system-data-structure/hours-main"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
        <!--  Testimonial -->
        <xsl:if test="descendant::system-data-structure/testimonial">
            <!-- debugging -->
            <!-- ITEM TYPE  <xsl:choose>
            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Testimonial']/item-priority=$placement-disable"> is disabled.</xsl:when>
            <xsl:when test="not(//calling-page/system-page/system-data-structure/side/item[type2='Testimonial']/item-priority=$placement-disable)"> is enabled.</xsl:when>
            </xsl:choose> Debug value of item-priority: <xsl:value-of select="//calling-page/system-page/system-data-structure/side/item[type2='Testimonial']/item-priority"/>
            -->
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Testimonial']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[testimonial] and //calling-page/system-page/system-data-structure/side/item[type2='Testimonial']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/testimonial]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="testimonial component">
                                <xsl:apply-templates select="block/content/system-data-structure/testimonial"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/testimonial/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/testimonial/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2C.1when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/testimonial/placement/publish_to/path = $thisPage][system-data-structure/testimonial/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/testimonial/placement/publish_to/path = $thisPage][system-data-structure/testimonial/placement/location='Selected Pages Right']">
                                    <div class="testimonial component">
                                        <xsl:apply-templates select="system-data-structure/testimonial"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- w2C.2 hen Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/testimonial/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/testimonial/placement/location='Site-wide Right']">
                                    <div class="testimonial component">
                                        <xsl:apply-templates select="system-data-structure/testimonial"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Testimonial']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="testimonial component">
                                <xsl:apply-templates select="block/content/system-data-structure/testimonial"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Testimonial']/item-priority=$placement-add">
                        <!-- 2C add local only - no globals exist -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Testimonial']">
                            <div class="testimonial component">
                                <xsl:apply-templates select="block/content/system-data-structure/testimonial"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!--  Audience Nav -->
        <xsl:if test="descendant::system-data-structure/audience-nav">
            <!-- debugging -->
            <!-- ITEM TYPE  <xsl:choose>
            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Audience Nav']/item-priority=$placement-disable"> is disabled.</xsl:when>
            <xsl:when test="not(//calling-page/system-page/system-data-structure/side/item[type2='Audience Nav']/item-priority=$placement-disable)"> is enabled.</xsl:when>
            </xsl:choose> Debug value of item-priority: <xsl:value-of select="//calling-page/system-page/system-data-structure/side/item[type2='Audience Nav']/item-priority"/>
            -->
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Audience Nav']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[audience-nav] and //calling-page/system-page/system-data-structure/side/item[type2='Audience Nav']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/audience-nav]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="audience-guide component">
                                <xsl:apply-templates select="block/content/system-data-structure/audience-nav"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/audience-nav/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/audience-nav/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2B.1 when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/audience-nav/placement/publish_to/path = $thisPage][system-data-structure/audience-nav/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/audience-nav/placement/publish_to/path = $thisPage][system-data-structure/audience-nav/placement/location='Selected Pages Right']">
                                    <div class="audience-guide component">
                                        <xsl:apply-templates select="system-data-structure/audience-nav"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- 2B.2 hen Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/audience-nav/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/audience-nav/placement/location='Site-wide Right']">
                                    <div class="audience-guide component">
                                        <xsl:apply-templates select="system-data-structure/audience-nav"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Audience Nav']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="audience-guide component">
                                <xsl:apply-templates select="block/content/system-data-structure/audience-nav"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Audience Nav']/item-priority=$placement-add">
                        <!-- 2C add local only - no globals exist -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Audience Nav']">
                            <div class="audience-guide component">
                                <xsl:apply-templates select="block/content/system-data-structure/audience-nav"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!--  News Center Widget -->
        <xsl:if test="descendant::system-data-structure/news-center-widget">
            <!-- debugging -->
            <!-- News Center Widget  <xsl:choose>
            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='News Center Widget']/item-priority=$placement-disable"> is disabled.</xsl:when>
            <xsl:when test="not(//calling-page/system-page/system-data-structure/side/item[type2='News Center Widget']/item-priority=$placement-disable)"> is enabled.</xsl:when>
            </xsl:choose> Debug value of item-priority: <xsl:value-of select="//calling-page/system-page/system-data-structure/side/item[type2='News Center Widget']/item-priority"/>
            -->
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='News Center Widget']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[news-center-widget] and //calling-page/system-page/system-data-structure/side/item[type2='News Center Widget']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/news-center-widget]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="news-feed component">
                                <xsl:apply-templates select="block/content/system-data-structure/news-center-widget"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/news-center-widget/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/news-center-widget/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2B.1 when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/news-center-widget/placement/publish_to/path = $thisPage][system-data-structure/news-center-widget/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/news-center-widget/placement/publish_to/path = $thisPage][system-data-structure/news-center-widget/placement/location='Selected Pages Right']">
                                    <div class="news-feed component">
                                        <xsl:apply-templates select="system-data-structure/news-center-widget"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- 2B.2 when Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/news-center-widget/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/news-center-widget/placement/location='Site-wide Right']">
                                    <div class="news-feed component">
                                        <xsl:apply-templates select="system-data-structure/news-center-widget"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='News Center Widget']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="news-feed component">
                                <xsl:apply-templates select="block/content/system-data-structure/news-center-widget"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='News Center Widget']/item-priority=$placement-add">
                        <!-- 2C add local only - no globals exist -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='News Center Widget']">
                            <div class="news-feed component">
                                <xsl:apply-templates select="block/content/system-data-structure/news-center-widget"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!--  Calendar - Trumba -->
        <xsl:if test="descendant::system-data-structure/calendar-trumba">
            <!-- debugging -->
            <!-- Calendar - Trumba  <xsl:choose>
            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Calendar - Trumba']/item-priority=$placement-disable"> is disabled.</xsl:when>
            <xsl:when test="not(//calling-page/system-page/system-data-structure/side/item[type2='Calendar - Trumba']/item-priority=$placement-disable)"> is enabled.</xsl:when>
            </xsl:choose> Debug value of item-priority: <xsl:value-of select="//calling-page/system-page/system-data-structure/side/item[type2='Calendar - Trumba']/item-priority"/>
            -->
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Calendar - Trumba']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[calendar-trumba] and //calling-page/system-page/system-data-structure/side/item[type2='Calendar - Trumba']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/calendar-trumba]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="calendar component">
                                <xsl:apply-templates select="block/content/system-data-structure/calendar-trumba"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/calendar-trumba/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/calendar-trumba/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2B.1 when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/calendar-trumba/placement/publish_to/path = $thisPage][system-data-structure/calendar-trumba/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/calendar-trumba/placement/publish_to/path = $thisPage][system-data-structure/calendar-trumba/placement/location='Selected Pages Right']">
                                    <div class="calendar component">
                                        <xsl:apply-templates select="system-data-structure/calendar-trumba"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- 2B.2 when Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/calendar-trumba/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/calendar-trumba/placement/location='Site-wide Right']">
                                    <div class="calendar component">
                                        <xsl:apply-templates select="system-data-structure/calendar-trumba"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Calendar - Trumba']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="calendar component">
                                <xsl:apply-templates select="block/content/system-data-structure/calendar-trumba"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Calendar - Trumba']/item-priority=$placement-add">
                        <!-- 2C add local only - no globals exist -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Calendar - Trumba']">
                            <div class="calendar component">
                                <xsl:apply-templates select="block/content/system-data-structure/calendar-trumba"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
        <xsl:if test="descendant::system-data-structure/flex-entry">
            <!-- debugging -->
            <!-- Flexible Entry  <xsl:choose>
            <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Flexible Entry']/item-priority=$placement-disable"> is disabled.</xsl:when>
            <xsl:when test="not(//calling-page/system-page/system-data-structure/side/item[type2='Flexible Entry']/item-priority=$placement-disable)"> is enabled.</xsl:when>
            </xsl:choose> Debug value of item-priority: <xsl:value-of select="//calling-page/system-page/system-data-structure/side/item[type2='Flexible Entry']/item-priority"/>
            -->
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Flexible Entry']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[flex-entry] and //calling-page/system-page/system-data-structure/side/item[type2='Flexible Entry']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/flex-entry]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="component 1">
                                <xsl:copy-of select="block/content/system-data-structure/flex-entry/flex"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/flex-entry/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/flex-entry/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2B.1 when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/flex-entry/placement/publish_to/path = $thisPage][system-data-structure/flex-entry/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/flex-entry/placement/publish_to/path = $thisPage][system-data-structure/flex-entry/placement/location='Selected Pages Right']">
                                    <div class="component 2">
                                        <xsl:copy-of select="system-data-structure/flex-entry/flex"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- 2B.2 when Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/flex-entry/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/flex-entry/placement/location='Site-wide Right']">
                                    <div class="component 3">
                                        <xsl:copy-of select="system-data-structure/flex-entry/flex"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Flexible Entry']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="component 4">
                                <xsl:copy-of select="block/content/system-data-structure/flex-entry/flex"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Flexible Entry']/item-priority=$placement-add">
                        <!-- 2C add local only - no globals exist -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Flexible Entry']">
                            <div class="component 5">
                                <xsl:copy-of select="block/content/system-data-structure/flex-entry/flex"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- stacked element: do not process because it's for the homepage only -->
        <xsl:if test="descendant::system-data-structure/hero or descendant::system-data-structure/stacked-element"/>

        <!-- content box -->
        <xsl:if test="descendant::system-data-structure/content-box">
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Content Box']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[content-box] and //calling-page/system-page/system-data-structure/side/item[type2='Content Box']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/content-box]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="component 6">
                                <!-- <xsl:apply-templates select="section-content-boxes/content-box/component/content/system-data-structure/content-box/entry"/> -->
                                <xsl:apply-templates select="system-data-structure/content-box"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>

                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/content-box/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/content-box/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2B.1when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/content-box/placement/publish_to/path = $thisPage][system-data-structure/content-box/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/content-box/placement/publish_to/path = $thisPage][system-data-structure/content-box/placement/location='Selected Pages Right']">
                                    <div class="component 7">
                                        <xsl:apply-templates select="system-data-structure/content-box"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- 2B.2 hen Site-wide Right is set on a callout -->
                            <!-- TODO fix this!-->
                            <xsl:when test="descendant::system-block[system-data-structure/content-box/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/content-box/placement/location='Site-wide Right']">
                                    <div class="component 8">
                                        <xsl:apply-templates select="system-data-structure/content-box"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Content Box']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="component 9">
                                <xsl:apply-templates select="descendant::system-data-structure/content-box"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2C add local only - no globals exist -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Content Box']/item-priority=$placement-add">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Content Box']">
                            <div class="component 10">
                                <xsl:apply-templates select="descendant::system-data-structure/content-box"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- Ask a Librarian -->
        <xsl:if test="descendant::system-data-structure/ask-a-librarian">
            <!-- 1) if the calling page hasn't disabled this type of content in the sidebar -->
            <xsl:if test="not(//calling-page/system-page/system-data-structure/side/item[type2='Ask a Librarian']/item-priority=$placement-disable)">
                <xsl:choose>
                    <!--  2 replace all callouts with this one. OR process sitewide callouts and add this one. -->
                    <!-- 2 A when local page items are set to replace the global ones -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item/block/content/system-data-structure[ask-a-librarian] and //calling-page/system-page/system-data-structure/side/item[type2='Content Box']/item-priority=$placement-replace">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[block/content/system-data-structure/ask-a-librarian]">
                            <!-- LOCAL - REPLACE GLOBAL SET -->
                            <div class="component 6">
                                <xsl:apply-templates select="block/content/system-data-structure/ask-a-librarian"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>

                    <!-- 2B when local items and global items have placement, and the local items are added to global -->
                    <xsl:when test="descendant::system-block[system-data-structure/ask-a-librarian/placement/publish_to/path = $thisPage] or descendant::system-block[system-data-structure/ask-a-librarian/placement/location='Site-wide Right']">
                        <xsl:choose>
                            <!-- 2B.1when Selected Pages Right is set with this page -->
                            <xsl:when test="descendant::system-block[system-data-structure/ask-a-librarian/placement/publish_to/path = $thisPage][system-data-structure/ask-a-librarian/placement/location='Selected Pages Right']">
                                <!-- SELECTED PAGES  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/ask-a-librarian/placement/publish_to/path = $thisPage][system-data-structure/ask-a-librarian/placement/location='Selected Pages Right']">
                                    <div class="component 7">
                                        <xsl:apply-templates select="block/content/system-data-structure/ask-a-librarian"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- 2B.2 hen Site-wide Right is set on a callout -->
                            <xsl:when test="descendant::system-block[system-data-structure/ask-a-librarian/placement/location='Site-wide Right']">
                                <!--  SITEWIDE  - add priority -->
                                <xsl:for-each select="descendant::system-block[system-data-structure/ask-a-librarian/placement/location='Site-wide Right']">
                                    <div class="component 8">
                                        <xsl:apply-templates select="block/content/system-data-structure/ask-a-librarian"/>
                                    </div>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <!-- if local priority is additive, add them last after any global items -->
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Ask a Librarian']">
                            <!-- LOCAL - ADD TO GLOBAL SET -->
                            <div class="component 9">
                                <xsl:apply-templates select="block/content/system-data-structure/ask-a-librarian"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- 2C add local only - no globals exist -->
                    <xsl:when test="//calling-page/system-page/system-data-structure/side/item[type2='Feature']/item-priority=$placement-add">
                        <xsl:for-each select="//calling-page/system-page/system-data-structure/side/item[type2='Ask a Librarian']">
                            <div class="component 10">
                                <xsl:apply-templates select="block/content/system-data-structure/ask-a-librarian"/>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

    </xsl:template>

    <!-- not yet implemented. this will work for site-wide blocks but not page level? -->
    <xsl:template name="edit-block">
        [system-view:internal]
        <div class="edit-block">
            <a>
                <xsl:attribute name="href">
                    https://cascade.emory.edu/entity/edit.act?id=
                    <xsl:value-of select="id"/>
                    &amp;type=block
                </xsl:attribute>
                Edit Component
            </a>
        </div>[/system-view:internal]
    </xsl:template>

</xsl:stylesheet>
