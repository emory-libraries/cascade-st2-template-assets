<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/database-results.xsl"/>
    <xsl:output indent="yes" method="xml"/>

    <xsl:template match="/">
        <xsl:variable name="filename"><xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/data/php-include/path"/></xsl:variable>
        <xsl:variable name="gsa-collection">
            <xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/data/gsa-collection"/>
        </xsl:variable>
        <xsl:variable name="use-database-pages">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/data/use-database-pages/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="get-all-results">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/data/get-all-results/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="use-cache">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/data/use-cache/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="cache-time">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/data/use-cache/value = 'Yes' and system-index-block/calling-page/system-page/system-data-structure/data/cache-time != ''">
                    <xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/data/cache-time"/>
                </xsl:when>
                <xsl:otherwise>''</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="show-selections-body">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/current-selections/display-location/value = 'Main Body'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="num">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/results-options/num != ''">
                    <xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/results-options/num"/>
                </xsl:when>
                <xsl:otherwise>25</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="use-autosuggest">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/results-options/search-options/use-autosuggest/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
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
        <xsl:variable name="use-summary">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/database-options/use-summary/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="show-status">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/database-options/show-status/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="show-fulltext">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/database-options/show-fulltext/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="show-coverage">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/database-options/show-coverage/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="show-subjects">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/database-options/show-subjects/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        [system-view:internal]
            <xsl:call-template name="database-results">
                <xsl:with-param name="show-featured"><xsl:value-of select="$show-featured"/></xsl:with-param>
                <xsl:with-param name="featured-title"><xsl:value-of select="$featured-title"/></xsl:with-param>
                <xsl:with-param name="show-new"><xsl:value-of select="$show-new"/></xsl:with-param>
                <xsl:with-param name="new-title"><xsl:value-of select="$new-title"/></xsl:with-param>
                <xsl:with-param name="use-summary"><xsl:value-of select="$use-summary"/></xsl:with-param>
                <xsl:with-param name="show-status"><xsl:value-of select="$show-status"/></xsl:with-param>
                <xsl:with-param name="show-fulltext"><xsl:value-of select="$show-fulltext"/></xsl:with-param>
                <xsl:with-param name="show-coverage"><xsl:value-of select="$show-coverage"/></xsl:with-param>
                <xsl:with-param name="show-subjects"><xsl:value-of select="$show-subjects"/></xsl:with-param>
                <xsl:with-param name="gsa-collection"><xsl:value-of select="$gsa-collection"/></xsl:with-param>
            </xsl:call-template>
        [/system-view:internal]

        [system-view:external]
            <xsl:processing-instruction name="php">

            // location of includes directory
            $host = $_SERVER['SERVER_NAME'];
            if ($host == 'staging.web.emory.edu')
            {
                $includes_directory = $_SERVER['DOCUMENT_ROOT'] . '/librariestemplate';
                $web_directory = $host . '/librariestemplate';
            }
            else
            {
                $includes_directory = $_SERVER['DOCUMENT_ROOT'];
                $web_directory = $host;
            }

            // location of api root
            $api_root = 'http://' . $web_directory . '/_api/v1/';

            // filename for database results
            $filename = trim('<xsl:value-of select="$filename"/>');

            // full path to include file
            $includePath = $includes_directory . $filename;

            if (file_exists($includePath))
            {
                include($includePath);

                $results = new DatabaseResults('<xsl:value-of select="$gsa-collection"/>', $api_root, <xsl:value-of select="$show-selections-body"/>, <xsl:value-of select="$use-autosuggest"/>, <xsl:value-of select="$show-featured"/>, '<xsl:value-of select="$featured-title"/>', <xsl:value-of select="$show-new"/>, '<xsl:value-of select="$new-title"/>', <xsl:value-of select="$use-summary"/>, <xsl:value-of select="$show-status"/>, <xsl:value-of select="$show-fulltext"/>, <xsl:value-of select="$show-coverage"/>, <xsl:value-of select="$show-subjects"/>, <xsl:value-of select="$use-database-pages"/>, <xsl:value-of select="$get-all-results"/>, <xsl:value-of select="$num"/>, <xsl:value-of select="$use-cache"/>, <xsl:value-of select="$cache-time"/>);
            }

            </xsl:processing-instruction>
        [/system-view:external]

    </xsl:template>
        
</xsl:stylesheet>
