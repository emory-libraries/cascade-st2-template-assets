<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="site://Library Template/_cms/xsl/alt-title.xsl"/>
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
        <div>
            <xsl:attribute name="class">data-entry<xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'"> wide</xsl:if></xsl:attribute>
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
    

    
</xsl:stylesheet>
