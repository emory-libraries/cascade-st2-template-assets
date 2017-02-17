<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/patterns.xsl"/>
    <xsl:import href="site://Library Template/_cms/xsl/alt-title.xsl"/>
    <xsl:output indent="yes"/>
    
    <xsl:variable name="group-issues" select="4"/>
    
    <xsl:template match="/">
        <xsl:variable name="layout">
            <xsl:choose>
                <xsl:when test="system-index-block/system-page[name='index' and @current='true']/system-data-structure/main-content/layout != ''">
                    <xsl:value-of select="system-index-block/system-page[name='index' and @current='true']/system-data-structure/main-content/layout"/>
                </xsl:when>
                <xsl:when test="system-index-block/calling-page/system-page[name='index' and @current='true']/system-data-structure/main-content/layout != ''">
                    <xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/main-content/layout"/>
                </xsl:when>
                <xsl:otherwise>invalid-layout</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- todo: find out if the current page will just work by itself without the attribute check -->

        <div>
            <xsl:attribute name="class">data-entry<xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'"> wide</xsl:if>
                <xsl:if test="$layout='Tiled Summaries'"> tiled-summaries</xsl:if><xsl:if test="$layout='Magazine Archive'"> magazine-archive</xsl:if>
            </xsl:attribute>
            <!-- check for summary. use if present, and use title by itself if not -->
            <xsl:choose>
                <xsl:when test="not(system-index-block/system-page[name='index'][@current='true'])">
                    <xsl:apply-templates mode="summary" select="//calling-page/system-page[@current='true']">
                        <xsl:with-param name="title-alignment" select="system-index-block/system-page[name='index']/system-data-structure/main-content/title-alignment"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="summary" select="system-index-block/system-page[name='index'][@current='true']">
                        <xsl:with-param name="title-alignment" select="system-index-block/system-page[name='index']/system-data-structure/main-content/title-alignment"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
            <!-- check layout? -->
            <xsl:choose>
                <xsl:when test="contains($layout,'Tile')">
                    <xsl:apply-templates mode="hierarchical" select="system-index-block"/>
                </xsl:when>
                <xsl:when test="contains($layout,'Magazine Archive')">
                    <xsl:apply-templates mode="magazine-archive" select="system-index-block"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="links-layout" select="system-index-block"/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <!-- summary div -->
    <xsl:template match="system-page" mode="summary">
        <xsl:param name="title-alignment"/>
        <header>
            <xsl:choose>
                <xsl:when test="$title-alignment = 'Horizontal Sections'">
                    <xsl:attribute name="class">intro horizontal clearfix</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">intro</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <h1>
                <xsl:value-of select="title"/>
            </h1>
            <xsl:choose>
                <xsl:when test="system-data-structure/thumbnail/summary!=''">
                    <div class="summary">
                        <xsl:copy-of select="system-data-structure/thumbnail/summary/node()"/>
                    </div>
                </xsl:when>
                <xsl:when test="summary != ''">
                    <div class="summary">
                        <p>
                            <xsl:value-of select="summary"/>
                        </p>
                    </div>
                </xsl:when>
            </xsl:choose>
        </header>
    </xsl:template>
    
    <!-- match on system-index-block for Full Width and Tiles -->
    <xsl:template match="system-index-block" mode="hierarchical">
        <div>
            <xsl:variable name="layout">
                <xsl:value-of select="calling-page/system-page/system-data-structure/main-content/layout"/>
            </xsl:variable>
            <xsl:attribute name="class">hierarchical<xsl:if test=" $layout= 'Tiles + No Subpages' or $layout= 'Tiled Summaries'"> pages</xsl:if></xsl:attribute>

            <xsl:choose>
                <xsl:when test="$layout='Featured Tiles + No Subpages'">
                    <div class="pages featured">
                        <xsl:for-each select="child::*[not(self::calling-page)]">
                            <xsl:variable name="count">
                                <xsl:value-of select="position()"/>
                            </xsl:variable>
                            <xsl:if test="$layout = 'Featured Tiles + No Subpages'">
                                <xsl:if test="$count = 4">
                                    <xsl:text disable-output-escaping="yes">&lt;/div&gt; &lt;div class="pages"&gt;</xsl:text>
                                </xsl:if>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="self::system-folder | self::system-symlink">
                                    <xsl:apply-templates mode="hierarchical-folders" select="self::node()"/>
                                </xsl:when>
                                <xsl:when test="self::system-page[not(@current='true')]">
                                    <xsl:if test="not(dynamic-metadata[name='subnav-exclude']/value or dynamic-metadata[name='section-listing']/value='Yes') or (name != 'index' and @current != 'true') or (name ='index' and @reference!='true')">
                                        <xsl:apply-templates mode="hierarchical-pages" select="self::node()"/>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="child::*[not(self::calling-page)]">
                        <xsl:choose>
                            <xsl:when test="self::system-folder | self::system-symlink">
                                <xsl:apply-templates mode="hierarchical-folders" select="self::node()"/>
                            </xsl:when>
                            <xsl:when test="self::system-page[not(@current='true')]">
                                <xsl:if test="not(dynamic-metadata[name='subnav-exclude']/value or dynamic-metadata[name='section-listing']/value='Yes') or (name != 'index' and @current != 'true') or (name ='index' and @reference!='true')">
                                    <xsl:apply-templates mode="hierarchical-pages" select="self::node()"/>
                                </xsl:if>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <!-- layout for magazine archive -->
    <xsl:template match="system-index-block" mode="magazine-archive">
        <xsl:apply-templates mode="issue-group" select="system-page[name!='index'][position() mod $group-issues = 1][position() = 1]">
            <xsl:with-param name="featured">true</xsl:with-param>
        </xsl:apply-templates>
        <xsl:if test="count(system-page[name!='index']) &gt; $group-issues">
            <div class="past">
                <h2>Past Issues</h2>
                <xsl:apply-templates mode="issue-group" select="system-page[name!='index'][position() mod $group-issues = 1][position() != 1]">
                    <xsl:with-param name="featured">false</xsl:with-param>
                </xsl:apply-templates>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="system-page" mode="issue-group">
        <xsl:param name="featured"/>
        <xsl:param name="size" select="12 div $group-issues"/>
        <xsl:choose>
            <xsl:when test="$featured = 'true'">
                <div class="featured">
                    <xsl:apply-templates mode="issue-featured" select=".|following-sibling::system-page[name!='index'][position() &lt; $group-issues]">
                        <xsl:with-param name="size"><xsl:value-of select="$size"/></xsl:with-param>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <xsl:attribute name="class"><xsl:text>issues span</xsl:text><xsl:value-of select="$size"/></xsl:attribute>
                    <ol>
                        <xsl:apply-templates mode="issue" select=".|following-sibling::system-page[name!='index'][position() &lt; $group-issues]"/>
                    </ol>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- match on system-index-block for Tiles (All are equal) -->
    <xsl:template match="system-index-block" mode="tiles">
        <div class="tiles pages">
            <xsl:for-each select="descendant-or-self::system-page[not(@current='true')]">
                <xsl:if test="not(dynamic-metadata[name='subnav-exclude']/value or dynamic-metadata[name='section-listing']/value) or (name != 'index' and @current != 'true') or (name ='index' and @reference!='true')">
                    <xsl:apply-templates mode="hierarchical-pages" select="self::node()"/>
                </xsl:if>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <!-- Folders -->
    <xsl:template match="system-folder" mode="hierarchical-folders">
        <xsl:variable name="view-type">
            <xsl:value-of select="/system-index-block/system-page[name='index']/system-data-structure/main-content/layout"/>
        </xsl:variable>
        <xsl:choose>
            <!--Full Width without Subpages View-->
            <xsl:when test="contains($view-type,'Tile') and $view-type!='Full Width + Tiles'">
                <xsl:call-template name="hierarchical-list-no-subpages"/>
            </xsl:when>
            <!--Full Width with Subpages View-->
            <xsl:otherwise>
                <xsl:call-template name="hierarchical-list"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Main Pages -->
    <xsl:template name="hierarchical-main-pages">
        <h3>
            <a>
                <xsl:attribute name="href">
                    <xsl:call-template name="link"/>
                </xsl:attribute>
                <xsl:value-of select="title"/>
            </a>
        </h3>
        <xsl:call-template name="summary"/>
    </xsl:template>
    
    <!-- Summary Template -->
    <xsl:template name="summary">
        <xsl:choose>
            <xsl:when test="system-data-structure/thumbnail/summary!=''">
                <div class="summary">
                    <xsl:copy-of select="system-data-structure/thumbnail/summary/node()"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="summary!=''">
                    <div class="summary">
                        <p>
                            <xsl:value-of select="summary"/>
                        </p>
                    </div>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--Thumbnail (Figure or Icon) Template -->
    <xsl:template name="thumbnail">
        <figure>
            <a class="thumbnail">
                <xsl:attribute name="href">
                    <xsl:call-template name="link"/>
                </xsl:attribute>
                <xsl:choose>
                    <!--cross references-->
                    <xsl:when test="@reference='true'">
                        <xsl:choose>
                            <xsl:when test="descendant::system-data-structure/thumbnail/image/link!=''">
                                <img>
                                    <xsl:attribute name="alt">Image for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="descendant::system-data-structure/thumbnail/image/link"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="descendant::system-data-structure/thumbnail/section-icon !='---'">
                                    <i>
                                        <xsl:attribute name="class">
                                            <xsl:text>fa </xsl:text><xsl:call-template name="replace-icon"><xsl:with-param name="icon" select="descendant::system-data-structure/thumbnail/section-icon"/></xsl:call-template>
                                        </xsl:attribute>
                                        <xsl:text> </xsl:text>
                                    </i>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!--non cross references-->
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="descendant::system-data-structure/thumbnail/image/link != '/'">
                                <img>
                                    <xsl:attribute name="alt">Image for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="descendant::system-data-structure/thumbnail/image/link"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:when test="descendant::system-data-structure/section-inherits/image/path != '/'">
                                <img>
                                    <xsl:attribute name="alt">Image for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="descendant::system-data-structure/section-inherits/image/path"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:when test="descendant::system-data-structure/thumbnail/thumb-bio/path != '/'">
                                <img>
                                    <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="descendant::system-data-structure/thumbnail/thumb-bio/path"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:when test="descendant::system-data-structure/thumbnail/photo-bio/path != '/'">
                                <img>
                                    <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="descendant::system-data-structure/thumbnail/photo-bio/path"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="descendant::system-data-structure/thumbnail/section-icon !='---'">
                                    <i>
                                        <xsl:attribute name="class">
                                            <xsl:text>fa </xsl:text><xsl:call-template name="replace-icon"><xsl:with-param name="icon" select="descendant::system-data-structure/thumbnail/section-icon"/></xsl:call-template>
                                        </xsl:attribute>
                                        <xsl:text> </xsl:text>
                                    </i>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </figure>
    </xsl:template>
    
    <!--Secondary Pages-->
    <xsl:template name="hierarchical-secondary-pages">
        <section>
            <h3>
                <a>
                    <xsl:attribute name="href">
                        <xsl:call-template name="link"/>
                    </xsl:attribute>
                    <xsl:value-of select="title"/>
                </a>
            </h3>
            <xsl:call-template name="summary"/>
        </section>
    </xsl:template>
    
    <!-- hierarchical list -->
    <xsl:template name="hierarchical-list">
        <xsl:apply-templates mode="hierarchical-list-main-pages" select="system-page[name ='index' and not(@reference='true') ]"/>
        <div class="pages">
            <xsl:apply-templates mode="hierarchical-list-sub-pages" select="system-page[name != 'index'] | system-symlink | system-page[name ='index' and @reference='true'] | system-folder[parent::system-folder]/system-page[name='index']"/>
        </div>
    </xsl:template>
    
    <!-- hierarchical list no subpages -->
    <xsl:template name="hierarchical-list-no-subpages">
        <xsl:apply-templates mode="hierarchical-list-main-pages" select="system-page[name ='index'] "/>
    </xsl:template>
    
    <!-- List main-pages-->
    <xsl:template match="system-page" mode="hierarchical-list-main-pages" name="hierarchical-list-main-pages">
        <xsl:variable name="layout">
            <xsl:value-of select="//system-page[@current='true']/system-data-structure/main-content/layout"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$layout='Tiled Summaries' and (name!='index' or @reference='true')"/>
            <xsl:when test="$layout='Tiled Summaries' and (dynamic-metadata[name='section-listing']/value='Yes')"/>
            <xsl:when test="$layout='Tiled Summaries' and name='index' and not(@reference='true')">
                <article class="page">
                    <xsl:if test="contains($layout,'Tile') and $layout != 'Full Width + Tiles' and not(dynamic-metadata[name='section-listing']='Yes' )">
                        <xsl:call-template name="thumbnail"/>
                    </xsl:if>
                    <xsl:if test="$layout = 'Full Width + Tiles'">
                        <div class="pull-right">
                            <xsl:call-template name="thumbnail"/>
                        </div>
                    </xsl:if>
                    <h2>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:call-template name="link"/>
                            </xsl:attribute>
                            <xsl:value-of select="title"/>
                        </a>                            
                    </h2>
                    <xsl:call-template name="summary"/>
                    <xsl:call-template name="selected-links">
                        <xsl:with-param name="layout">
                            <xsl:value-of select="$layout"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </article>
            </xsl:when>
            <xsl:otherwise>
                <article class="page">
                    <xsl:if test="contains($layout,'Tile') and $layout != 'Full Width + Tiles' ">
                        <xsl:call-template name="thumbnail"/>
                    </xsl:if>
                    <xsl:if test="$layout = 'Full Width + Tiles'">
                        <div class="pull-right">
                            <xsl:call-template name="thumbnail"/>
                        </div>
                    </xsl:if>
                    <h2>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:call-template name="link"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="title"/>
                        </a>
                    </h2>
                    <xsl:call-template name="summary"/>
                    <xsl:call-template name="selected-links"/>
                </article>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--Selected Links Template for Tiled Summaries-->
    <xsl:template name="selected-links">
        <xsl:variable name="href2">
            <xsl:value-of select="ancestor::system-folder/system-page[name='index'][not(@reference='true')]/link"/>
        </xsl:variable>
        <xsl:variable name="layout">
            <xsl:value-of select="//system-page[@current='true']/system-data-structure/main-content/layout"/>
        </xsl:variable>
        <xsl:if test="$layout='Tiled Summaries'">
            <ul class="selected-links">
                <xsl:for-each select="ancestor::system-folder/system-page[not(dynamic-metadata[name='section-listing']='Yes' )][not(name='index')] | ancestor::system-folder/descendant::system-folder/system-page[name='index'][not(dynamic-metadata[name='section-listing']='Yes' )]">
                    <xsl:if test="position()&lt;7">
                        <xsl:variable name="real-href">
                            <xsl:choose>
                                <xsl:when test="system-data-structure[@definition-path='External Link']">
                                    <xsl:value-of select="system-data-structure[@definition-path='External Link']/url"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="link"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <li>
                            <a href="{$real-href}">
                                <xsl:apply-templates select="title"/>
                            </a>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
            <xsl:variable name="count">
                <xsl:for-each select="ancestor::system-folder/system-page[not(dynamic-metadata[name='section-listing']='Yes' )][not(name='index')] | ancestor::system-folder/descendant::system-folder/system-page[name='index'][not(dynamic-metadata[name='section-listing']='Yes' )]">
                    <xsl:if test="position()=last()">
                        <xsl:number/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:if test="$count &gt;6">
                <a class="even-more">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$href2"/>
                    </xsl:attribute>
                    <xsl:text>More...</xsl:text>
                </a>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- List sub-pages-->
    <xsl:template match="system-page[name != 'index'] | system-symlink | system-page[name ='index' and @reference='true'] | system-folder[parent::system-folder]/system-page[name='index']" mode="hierarchical-list-sub-pages">
        <article class="page">
            <xsl:call-template name="thumbnail"/>
            <h3>
                <a>
                    <xsl:attribute name="href">
                        <xsl:call-template name="link"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="title"/>
                </a>
            </h3>
            <xsl:call-template name="summary"/>
        </article>
    </xsl:template>
    
    <!-- hierarchical with no subfolders -->
    <xsl:template match="system-page | system-symlink" mode="hierarchical-pages">
        <xsl:variable name="view-type">
            <xsl:value-of select="/system-index-block/system-page[name='index']/system-data-structure/main-content/layout"/>
        </xsl:variable>
        <xsl:choose>
            <!--Full Width without Subpages View-->
            <xsl:when test="$view-type='Full Width (hide subpages)'">
                <xsl:call-template name="hierarchical-list-main-pages"/>
            </xsl:when>
            <!--Full Width with Subpages View-->
            <xsl:otherwise>
                <xsl:call-template name="hierarchical-list-main-pages"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- featured magazine issue -->
    <xsl:template match="system-page | system-symlink" mode="issue-featured">
        <xsl:param name="size"/>
        <article>
            <xsl:attribute name="class"><xsl:text>issue span</xsl:text><xsl:value-of select="$size"/></xsl:attribute>
            <xsl:call-template name="thumbnail"/>
            <h2>
                <a>
                    <xsl:attribute name="href">
                        <xsl:call-template name="link"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="title"/>
                </a>
            </h2>
        </article>
    </xsl:template>

    <!-- non featured magazine issue -->
    <xsl:template match="system-page | system-symlink" mode="issue">
        <li>
            <a>
                <xsl:attribute name="class">pdf</xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:call-template name="link"/>
                </xsl:attribute>
                <xsl:apply-templates select="title"/>
            </a>
        </li>
    </xsl:template>
    
    <!-- generate the href attribute, depending on whether it is an external link or not -->
    <xsl:template name="link">
        <xsl:choose>
            <xsl:when test="system-data-structure/url != ''">
                <xsl:value-of select="system-data-structure/url"/>
            </xsl:when>
            <xsl:when test="@reference='true'">
                <xsl:value-of select="link"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="path"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- match on system-index-block for Full Width + Links -->
    <xsl:template match="system-index-block" mode="links-layout">
        <div class="links full-width">
            <xsl:for-each select="child::*[not(self::calling-page)][not(@current='true')]">
                <section class="clearfix">
                    <xsl:choose>
                        <xsl:when test="self::system-folder | self::system-symlink">
                            <xsl:apply-templates mode="links-folders" select="self::node()"/>
                        </xsl:when>
                        <xsl:when test="self::system-page">
                            <xsl:if test="not(dynamic-metadata[name='subnav-exclude']/value='Yes' or dynamic-metadata[name='section-listing']/value) or (name != 'index' and @current != 'true') or (name ='index' and @reference!='true')">
                                <xsl:if test="not(name='index' and ancestor-or-self::system-index-block/@name='marbl-magazine-index')">
                                    <xsl:apply-templates mode="links-list-main-pages" select="self::node()"/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </section>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <!-- Folders -->
    <xsl:template match="system-folder" mode="links-folders">
        <xsl:variable name="view-type">
            <xsl:value-of select="/system-index-block/system-page[name='index']/system-data-structure/main-content/layout"/>
        </xsl:variable>
        <xsl:call-template name="links-list"/>
    </xsl:template>
    <!-- Main Pages -->
    <xsl:template match="system-page" mode="links-list-main-pages" name="links-list-main-pages">
        <xsl:if test="descendant::system-data-structure/thumbnail/image/path!='/' or descendant::system-data-structure/thumbnail/section-icon !='---'">
            <div class="pull-right">
                <xsl:call-template name="thumbnail"/>
            </div>
        </xsl:if>
        <h2 class="page-name">
            <xsl:choose>
                <xsl:when test="//system-page[@current='true']/system-data-structure/main-content/layout = 'Full Width + Links' and //system-page[@current='true']/system-data-structure/main-content/unlink-headers/value = 'Yes' and name='index' and (preceding-sibling::*/dynamic-metadata[name = 'section-listing'][not(value = 'Yes')] or following-sibling::*/dynamic-metadata[name = 'section-listing'][not(value = 'Yes')])">
                    <xsl:value-of select="title"/>
                </xsl:when>
                <xsl:otherwise>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="link"/>
                        </xsl:attribute>
                        <xsl:value-of select="title"/>
                    </a>                            
                </xsl:otherwise>
            </xsl:choose>
        </h2>
        <xsl:call-template name="summary"/>
    </xsl:template>
    
    <xsl:template match="system-page" mode="links-list-sub-pages" name="links-list-sub-pages">
        <xsl:choose>
            <xsl:when test="@reference='true'">
                <xsl:if test="(preceding-sibling::system-page[name='index'] or following-sibling::system-page[name='index']) and not(parent::system-folder[parent::system-folder])">
                    <li class="item">
                        <h3>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="link"/>
                                </xsl:attribute>
                                <xsl:apply-templates select="title"/>
                            </a>
                        </h3>
                    </li>
                </xsl:if>
            </xsl:when>
            <xsl:when test="dynamic-metadata[name='section-listing']/value"/>
            <xsl:otherwise>
                <li class="item">
                    <h3>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:call-template name="link"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="title"/>
                        </a>
                    </h3>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- links list -->
    <xsl:template name="links-list">
        <xsl:apply-templates mode="links-list-main-pages" select="system-page[name ='index' and not(@reference='true') ]"/>
        <xsl:variable name="layout">
            <xsl:value-of select="/system-index-block/system-page[name='index' and @current='true']/system-data-structure/main-content/layout"/>
        </xsl:variable>
        <xsl:if test=" $layout != 'Full Width + No Subpages'">
            <xsl:if test="system-page[name != 'index'] | system-symlink | system-page[name ='index' and @reference='true'] | system-folder[parent::system-folder]/system-page[name='index']">
                <ul class="items">
                    <xsl:apply-templates mode="links-list-sub-pages" select="system-page[name != 'index'] | system-symlink | system-page[name ='index' and @reference='true'] | system-folder[parent::system-folder]/system-page[name='index']"/>
                </ul>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
