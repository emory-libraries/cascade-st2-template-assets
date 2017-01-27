<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
        <xsl:apply-templates mode="root" select="//calling-page/system-page"/>
    </xsl:template>
    
    <!-- calling-page system-page template-->
    <xsl:template match="system-page" mode="root">
        <!-- Determine layout -->
        <xsl:variable name="layout">
            <xsl:choose>
                <xsl:when test="system-data-structure/main-content/layout != ''">
                    <xsl:value-of select="system-data-structure/main-content/layout"/>
                </xsl:when>
                <xsl:otherwise>invalid-layout</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- output content div; consider main element -->
        <main><xsl:attribute name="class">data-entry section-page<xsl:if test="dynamic-metadata[name='layout-columns']/value='Disable Right Column'"> wide</xsl:if> <xsl:if test="contains($layout,'Tiles')">  section-page--tiles</xsl:if></xsl:attribute>
            <!-- insert the summary of the current page -->
            <xsl:apply-templates mode="summary" select="."/>
            <!-- output subsections -->
            <xsl:apply-templates mode="rows" select="system-data-structure/section-page/group"/>
            <xsl:choose>
                <xsl:when test="contains($layout,'Tiles')">
                    <xsl:apply-templates mode="tiles" select="system-data-structure/section-page/group/group-link"/>
                </xsl:when>
                <xsl:when test="contains($layout,'Tiles')">
                    <xsl:apply-templates mode="links-layout" select="system-index-block"/>
                </xsl:when>
            </xsl:choose>
        </main>
    </xsl:template>
    
    <!-- current page summary -->
    <xsl:template match="system-page" mode="summary">
        <header><xsl:attribute name="class">intro</xsl:attribute>
            <xsl:if test="system-data-structure/thumbnail/summary!='' or summary != '' or system-data-structure/section-page/page-summary!=''">
                <div class="summary">
                    <xsl:choose>
                        <xsl:when test="system-data-structure/section-page/page-summary!=''">
                            <xsl:copy-of select="system-data-structure/section-page/page-summary/node()"/>
                        </xsl:when>
                        <xsl:when test="system-data-structure/thumbnail/summary!=''">
                            <xsl:copy-of select="system-data-structure/thumbnail/summary/node()"/>
                        </xsl:when>
                        <xsl:when test="summary != ''">
                            <p><xsl:value-of select="summary"/></p>
                        </xsl:when>
                    </xsl:choose>
                </div>
            </xsl:if>
        </header>
    </xsl:template>

    <!-- Subsection template -->
    <xsl:template match="group" mode="rows">
        <section>
            <xsl:variable name="subsection-heading">
                <xsl:choose>
                    <!-- Is the heading an override? if so, use that value -->
                    <xsl:when test="detail-overrides/value = 'Title'">
                        <xsl:value-of select="heading-label"/>
                    </xsl:when>
                    <!-- or just use the page's title -->
                    <xsl:otherwise>
                        <xsl:value-of select="group-link/title"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- drop in the selected heading label -->
            <a href="{group-link/link}"><h2><xsl:value-of select="$subsection-heading"/></h2></a>
            <xsl:if test="link">
                <ul>
                    <xsl:apply-templates mode="rows" select="link"/>
                </ul>
            </xsl:if>
        </section>
    </xsl:template>

    <!-- Links for rows template -->
    <xsl:template match="link" mode="rows">
        <!-- resolve labels -->
        <xsl:variable name="link-label">
            <xsl:choose>
                <xsl:when test="detail-overrides/value='Title'">
                    <xsl:value-of select="title"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="page/title"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <li>
            <a href="{page/link}"><xsl:value-of select="$link-label"/></a>
        </li>
    </xsl:template>

    <!-- Tiles layout -->
    <xsl:template match="group/group-link" mode="tiles">
        
    </xsl:template>
    
</xsl:stylesheet>
