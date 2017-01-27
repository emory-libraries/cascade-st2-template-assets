<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" method="xml"/>
    
    <xsl:template match="/">

        <xsl:call-template name="output-php-content">
            <xsl:with-param name="filepath"><xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/dataset/database-include/path"/></xsl:with-param>
            <xsl:with-param name="content">
                <!-- need to figure out how to parse this instead -->
                <xsl:copy-of select="system-index-block/node()"/>
                <!--<xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/dataset/database-include/path"/>-->
            </xsl:with-param>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="output-php-content">
        <xsl:param name="filepath"/>
        <xsl:param name="content"/>

        [system-view:internal]
            <xsl:copy-of select="$content"/>
        [/system-view:internal]

        [system-view:external]
            <xsl:processing-instruction name="php">
            # Where to find the included path

            if ($_SERVER['HTTP_HOST'] == 'staging.web.emory.edu') {
                $serverPath = $_SERVER["DOCUMENT_ROOT"] . '/librariestemplate';
            } else ($_SERVER['HTTP_HOST'] == 'www.staging.com') {
                $serverPath = $_SERVER["DOCUMENT_ROOT"];
            }

            # filepath parameter from XSL template
            $filePath = trim('<xsl:value-of select="$filepath"/>');

            # Full path of the include file
            $includePath = $serverPath . $filePath . '.php';

            # Just output the content if
            #   1. The file that's executing this code *is* the include file
            #   2. or the $isInclude flag has been set to true (see the else block)
            if (($_SERVER["SCRIPT_FILENAME"] == $includePath) or ((isset($isInclude)) and ($isInclude === true)))
            {
                </xsl:processing-instruction>
                <xsl:copy-of select="$content"/>
                <xsl:processing-instruction name="php">
            }

            # Otherwise, bring in the contents of the include file
            else
            {
                if (file_exists($includePath))
                {
                    # Setting $isInclude to true forces the include file to output its content when it's brought in
                    $isInclude = true;

                    # Capture the content of the include
                    ob_start();
                    include $includePath;
                    $content = ob_get_contents();
                    ob_end_clean();

                    # Strip the "data" root tag and print the XML contents
                    preg_match_all('/&lt;data&gt;(.*)&lt;\/data&gt;/s', $content, $matches);
                    print_r($matches[1][0]);

                    # Reset the $isInclude flag
                    $isInclude = false;
                }
            }
            </xsl:processing-instruction>
        [/system-view:external]
    </xsl:template>
</xsl:stylesheet>
