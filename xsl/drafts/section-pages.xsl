<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/patterns.xsl"/>
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <div>
            <xsl:attribute name="class">data-entry <xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'"> wide</xsl:if>
            </xsl:attribute>
            <!-- check for summary. use if present, and use title by itself if not -->
            
            <xsl:apply-templates mode="summary" select="system-index-block/system-page[name='index']">
                <xsl:with-param name="title-alignment" select="system-index-block/system-page[name='index']/system-data-structure/main-content/title-alignment"/>
            </xsl:apply-templates>
               
                
            <!-- check layout? -->
            <xsl:if test="system-index-block/system-page[name='index' and @current='true']/system-data-structure/main-content/layout !='Tiles'">
                <xsl:apply-templates mode="hierarchical" select="system-index-block"/>
            </xsl:if>
            <xsl:if test="system-index-block/system-page[name='index' and @current='true']/system-data-structure/main-content/layout ='Tiles'">
                <xsl:apply-templates mode="tiles" select="system-index-block"/>
            </xsl:if>
        </div>
    </xsl:template>
    <!-- summary div -->
    <xsl:template match="system-index-block/system-page[name='index']" mode="summary">
        <xsl:param name="title-alignment"/>
        <xsl:if test="@current='true'">
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
        </xsl:if>
    </xsl:template>
    <!-- match on system-index-block for Hierarchical -->
    <xsl:template match="system-index-block" mode="hierarchical">
        <div class="hierarchical">
            <xsl:variable name="layout">
                <xsl:value-of select="system-page[@current='true']/system-data-structure/main-content/layout"/>
            </xsl:variable>
            <xsl:if test=" $layout= 'Without Subpages'">
                <xsl:attribute name="class">
                    <xsl:text>hierarchical pages</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$layout='Without Subpages + Featured'">
                    <div class="pages featured">
                        <xsl:for-each select="child::*[not(self::calling-page)]">
                            <xsl:variable name="count">
                                <xsl:value-of select="position()"/>
                            </xsl:variable>
                            <xsl:if test="$layout = 'Without Subpages + Featured'">
                                <xsl:if test="$count = 4">
                                    <xsl:text disable-output-escaping="yes">&lt;/div&gt; &lt;div class="pages"&gt;</xsl:text>
                                </xsl:if>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="self::system-folder | self::system-symlink">
                                    <xsl:apply-templates mode="hierarchical-folders" select="self::node()"/>
                                </xsl:when>
                                <xsl:when test="self::system-page[not(@current='true')]">
                                    <xsl:if test="not(dynamic-metadata[name='subnav-exclude']/value or dynamic-metadata[name='section-listing']/value) or (name != 'index' and @current != 'true') or (name ='index' and @reference!='true')">
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
                                <xsl:if test="not(dynamic-metadata[name='subnav-exclude']/value or dynamic-metadata[name='section-listing']/value) or (name != 'index' and @current != 'true') or (name ='index' and @reference!='true')">
                                    <xsl:apply-templates mode="hierarchical-pages" select="self::node()"/>
                                </xsl:if>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </div>
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
            <xsl:when test="$view-type='Without Subpages' or $view-type='Without Subpages + Featured'">
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
            <xsl:when test="descendant-or-self::system-data-structure/thumbnail/summary!=''">
                <div class="summary">
                    <xsl:copy-of select="descendant-or-self::system-data-structure/thumbnail/summary/node()"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="summary">
                    <p>
                        <xsl:value-of select="descendant-or-self::summary"/>
                    </p>
                </div>
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
                            <xsl:when test="./system-data-structure/thumbnail/image/link!=''">
                        
                                 <img>
                                     <xsl:attribute name="alt">Image for <xsl:value-of select="title"/>
                                     </xsl:attribute>
                                     <xsl:attribute name="src">
                                         <xsl:value-of select="./system-data-structure/thumbnail/image/link"/>
                                     </xsl:attribute>
                                 </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="./system-data-structure/thumbnail/section-icon !='---'">
                                    <i>
                                        <xsl:attribute name="class">
                                            <xsl:text>fa </xsl:text><xsl:call-template name="replace-icon"><xsl:with-param name="icon" select="./system-data-structure/thumbnail/section-icon"/></xsl:call-template>
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
                            <xsl:when test="./system-data-structure/thumbnail/image/path != '/'">
                               <img>
                                   <xsl:attribute name="alt">Image for <xsl:value-of select="title"/>
                                   </xsl:attribute>
                                   <xsl:attribute name="src">
                                       <xsl:value-of select="./system-data-structure/thumbnail/image/path"/>
                                   </xsl:attribute>
                               </img>
                           </xsl:when>
                           <xsl:when test="./system-data-structure/section-inherits/image/path != '/'">
                               <img>
                                   <xsl:attribute name="alt">Image for <xsl:value-of select="title"/>
                                   </xsl:attribute>
                                   <xsl:attribute name="src">
                                       <xsl:value-of select="./system-data-structure/section-inherits/image/path"/>
                                   </xsl:attribute>
                               </img>
                           </xsl:when>
                           <xsl:when test="./system-data-structure/thumbnail/thumb-bio/path != '/'">
                               <img>
                                   <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                   </xsl:attribute>
                                   <xsl:attribute name="src">
                                       <xsl:value-of select="./system-data-structure/thumbnail/thumb-bio/path"/>
                                   </xsl:attribute>
                               </img>
                           </xsl:when>
                           <xsl:when test="./system-data-structure/thumbnail/photo-bio/path != '/'">
                               <img>
                                   <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                   </xsl:attribute>
                                   <xsl:attribute name="src">
                                       <xsl:value-of select="./system-data-structure/thumbnail/photo-bio/path"/>
                                   </xsl:attribute>
                               </img>
                           </xsl:when>
                           <xsl:otherwise>
                               <xsl:if test="./system-data-structure/thumbnail/section-icon !='---'">
                                   <i>
                                       <xsl:attribute name="class">
                                           <xsl:text>fa </xsl:text><xsl:call-template name="replace-icon"><xsl:with-param name="icon" select="./system-data-structure/thumbnail/section-icon"/></xsl:call-template>
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
    <!--Seondary Pages-->
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
        <xsl:apply-templates mode="hierarchical-list-main-pages" select="system-page[name ='index']"/>
    </xsl:template>
    <!-- List main-pages-->
    <xsl:template match="system-page" mode="hierarchical-list-main-pages" name="hierarchical-list-main-pages">
        <xsl:variable name="layout">
            <xsl:value-of select="//system-page[@current='true']/system-data-structure/main-content/layout"/>
        </xsl:variable>
        <article class="page">
            <xsl:if test="$layout = 'Without Subpages' or $layout = 'Tiles' or $layout = 'Without Subpages + Featured'">
                <xsl:call-template name="thumbnail"/>
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
        </article>

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
                    <xsl:value-of select="title"/>
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
            <xsl:when test="$view-type='Without Subpages'">
                <xsl:call-template name="hierarchical-list-main-pages"/>                
            </xsl:when>
            <!--Full Width with Subpages View-->
            <xsl:otherwise>
                <xsl:call-template name="hierarchical-list-main-pages"/>
            </xsl:otherwise>
        </xsl:choose>
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
</xsl:stylesheet>
