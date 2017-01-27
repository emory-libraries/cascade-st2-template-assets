<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
  <xsl:output indent="yes"/>

  <xsl:template name="database-results">
    <xsl:param name="show-featured"/>
    <xsl:param name="featured-title"/>
    <xsl:param name="show-new"/>
    <xsl:param name="new-title"/>
    <xsl:param name="show-status"/>
    <xsl:param name="show-fulltext"/>
    <xsl:param name="show-coverage"/>
    <xsl:param name="show-subjects"/>
    <xsl:param name="gsa-collection"/>

        <div>
            <xsl:attribute name="class">data-entry<xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'"> wide</xsl:if>
            </xsl:attribute>

            <!-- check for summary. use if present, and use title by itself if not -->
            <xsl:choose>
                <xsl:when test="system-index-block/system-page[name='index']/summary != ''">
                    <xsl:apply-templates mode="summary" select="system-index-block/system-page[name='index']">
                        <xsl:with-param name="title-alignment" select="system-index-block/system-page[name='index']/system-data-structure/main-content/title-alignment"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="system-index-block/system-page[name='index']/system-data-structure/flex-group/wysiwyg != ''">
                    <xsl:apply-templates mode="flex-box" select="system-index-block/system-page[name='index']">
                        <xsl:with-param name="title-alignment" select="system-index-block/system-page[name='index']/system-data-structure/main-content/title-alignment"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <h1>
                        <xsl:value-of select="//calling-page/system-page/title"/>
                    </h1>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- create layout without individual database pages -->
            <xsl:apply-templates mode="results-only" select="system-index-block">
                <xsl:with-param name="gsa-collection"><xsl:value-of select="$gsa-collection"/></xsl:with-param>
            </xsl:apply-templates>            
        </div>
    </xsl:template>

    <!-- setup the list -->
    <xsl:template match="system-index-block" mode="results-only">
        <xsl:param name="gsa-collection"/>
        <section class="all-databases database-results clearfix">
            <h2>All Databases</h2>
            <ol class="listings results-only">
                <xsl:choose>
                    <xsl:when test="$gsa-collection = 'library-databases-health'">
                       <xsl:apply-templates mode="database-entry" select="system-page[not(contains(path,'_cms'))][system-data-structure/whsc/include/value = 'Yes']">
                            <xsl:with-param name="gsa-collection"><xsl:value-of select="$gsa-collection"/></xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="database-entry" select="system-page[not(contains(path,'_cms'))][not(system-data-structure/whsc/exclude/value = 'Yes')]">
                            <xsl:with-param name="gsa-collection"><xsl:value-of select="$gsa-collection"/></xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </ol>
       </section>
    </xsl:template>

    <xsl:template match="system-page" mode="database-entry">
        <xsl:param name="gsa-collection"/>
        <li class="span12">
            <h3>
                <a>
                    <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
                    <xsl:value-of select="title"/>
                </a>
            </h3>

            <xsl:choose>
                <xsl:when test="$gsa-collection = 'library-databases-health' and system-data-structure/whsc/description/node() != ''">
                    <xsl:copy-of select="system-data-structure/whsc/description/node()"/>
                </xsl:when>
                <xsl:when test="$gsa-collection = 'library-databases-business' and system-data-structure/short-description != ''">
                    <xsl:copy-of select="system-data-structure/short-description"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="system-data-structure/description/node()"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="dynamic-metadata[name='new']/value='Yes' or dynamic-metadata[name='trial']/value='Yes'">
                <p class="muted">
                    <xsl:if test="dynamic-metadata[name='new']/value='Yes'">
                        <span class="">New</span>
                    </xsl:if>
                    <xsl:if test="dynamic-metadata[name='trial']/value='Yes'">
                        <span class="">Trial</span>
                    </xsl:if>
                </p>
            </xsl:if>
        </li>

    </xsl:template>

</xsl:stylesheet>
