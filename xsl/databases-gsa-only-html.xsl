<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="/_cms/xsl/database-results.xsl"/>
  <xsl:output indent="yes"/>

  <xsl:template match="/">
        <xsl:variable name="filename"><xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/data/php-include/path"/></xsl:variable>
        <xsl:variable name="gsa-collection">
            <xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/data/gsa-collection"/>
        </xsl:variable>
        <xsl:variable name="show-featured">
            <xsl:if test="system-index-block/calling-page/system-page/system-data-structure/results-options/featured-options/show/value = 'Yes'">true</xsl:if>
        </xsl:variable>
        <xsl:variable name="featured-title">
            <xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/results-options/featured-options/title"/>
        </xsl:variable>
        <xsl:variable name="show-new">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/results-options/new-options/show/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="new-title">
            <xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/results-options/new-options/title"/>
        </xsl:variable>
        <xsl:variable name="show-status">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/database-options/show-status/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="show-subjects">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/database-options/show-subjects/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:call-template name="database-results">
            <xsl:with-param name="show-featured"><xsl:value-of select="$show-featured"/></xsl:with-param>
            <xsl:with-param name="featured-title"><xsl:value-of select="$featured-title"/></xsl:with-param>
            <xsl:with-param name="show-new"><xsl:value-of select="$show-new"/></xsl:with-param>
            <xsl:with-param name="new-title"><xsl:value-of select="$new-title"/></xsl:with-param>
            <xsl:with-param name="show-status"><xsl:value-of select="$show-status"/></xsl:with-param>
            <xsl:with-param name="show-subjects"><xsl:value-of select="$show-subjects"/></xsl:with-param>
            <xsl:with-param name="gsa-collection"><xsl:value-of select="$gsa-collection"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
