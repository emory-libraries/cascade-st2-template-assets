<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output indent="yes"/>

    <xsl:template name="search-form-header">
        <xsl:apply-templates select="/system-index-block/system-page/system-data-structure/site-seo/datadef-search/content/system-data-structure"/>
    </xsl:template>

    <xsl:template match="/system-index-block/system-page/system-data-structure/site-seo/datadef-search/content/system-data-structure">
        <div class="nav-box search">
            <form id="form-search" method="get" name="searchForm">
                <xsl:attribute name="action">[system-asset]<xsl:value-of select="search-page/page/path"/>[/system-asset]</xsl:attribute>
                <div class="input-append">
                    <label>
                        <input autocomplete="off" class="input-medium" id="q" name="q" placeholder="Search" type="search"/>
                    </label>
                    <button class="btn" type="submit">
                        <strong class="label">Search</strong>
                        <span class="icon-search"></span>
                    </button>
                </div>
                <fieldset class="search-scope">
                    <xsl:apply-templates select="search-option"/>                  
                </fieldset>
            </form>
        </div>
    </xsl:template>

    <xsl:template match="search-option">
        <label>
            <xsl:if test="default = 'Yes'"><xsl:attribute name="class">checked</xsl:attribute></xsl:if>
            <input name="system" type="radio">
                <xsl:if test="default = 'Yes'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                <xsl:attribute name="id">search-<xsl:value-of select="name"/></xsl:attribute>
                <xsl:attribute name="value"><xsl:value-of select="name"/></xsl:attribute>
                <xsl:attribute name="data-search-placeholder"><xsl:choose><xsl:when test="short-placeholder != ''"><xsl:value-of select="short-placeholder"/></xsl:when><xsl:otherwise><xsl:value-of select="placeholder"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </input>
            <xsl:value-of select="dropdown-label"/>
        </label>
    </xsl:template>

</xsl:stylesheet>
