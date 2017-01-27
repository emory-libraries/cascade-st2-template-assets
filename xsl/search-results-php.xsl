<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" method="xml"/>

    <xsl:template match="/">
        <xsl:variable name="filename"><xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/data/php-include/path"/></xsl:variable>
        <xsl:variable name="gsa-collection">
            <xsl:value-of select="system-index-block/system-page/system-data-structure/site-seo/search-collection"/>
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
        <xsl:variable name="numgm">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/results-options/numgm != ''"><xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/results-options/numgm"/></xsl:when>
                <xsl:otherwise>''</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="num">
            <xsl:choose>
                <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/results-options/num != ''"><xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/results-options/num"/></xsl:when>
                <xsl:otherwise>''</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="requiredfields">
            <xsl:if test="system-index-block/calling-page/system-page/system-data-structure/results-options/required-fields/data-pair/key != '' and system-index-block/calling-page/system-page/system-data-structure/results-options/required-fields/data-pair/value != ''">
                <xsl:for-each select="system-index-block/calling-page/system-page/system-data-structure/results-options/required-fields/data-pair">
                    <xsl:value-of select="key"/><xsl:text>:</xsl:text><xsl:value-of select="value"/>
                    <xsl:if test="position() != last()">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:variable>


        [system-view:internal]
            <p>Search options are currently set as:</p>
            <ul>
                <li>Key Matches: <xsl:value-of select="$numgm"/></li>
                <li>Results Per Page: <xsl:value-of select="$num"/></li>
                <xsl:if test="system-index-block/calling-page/system-page/system-data-structure/results-options/required-fields/data-pair/key != '' and system-index-block/calling-page/system-page/system-data-structure/results-options/required-fields/data-pair/value != ''">
                    <li>Required Fields String: <xsl:value-of select="$requiredfields"/></li>
                </xsl:if>
            </ul>
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

                $results = new SearchResults('<xsl:value-of select="$gsa-collection"/>', $api_root, <xsl:value-of select="$numgm"/>, <xsl:value-of select="$num"/>, '<xsl:value-of select="$requiredfields"/>', <xsl:value-of select="$use-cache"/>, <xsl:value-of select="$cache-time"/>);
            }

            </xsl:processing-instruction>
        [/system-view:external]
    </xsl:template>
        
</xsl:stylesheet>
