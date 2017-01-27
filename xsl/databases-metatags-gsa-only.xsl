<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="site://WDG Central v2/_cms/xsl/output/html-escape-tags.xsl"/>
    <xsl:import href="site://WDG Central v2/_cms/xsl/output/html-serialize.xsl"/>

    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>
   <xsl:variable name="proxy-fix">http://mail.library.emory.edu:32888/</xsl:variable>

    <xsl:variable name="allowed_characters" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_0123456789%&amp; '"/> <!-- this needs to match the regex in the javascript and php -->
    
    <xsl:variable name="default_site"> <!-- default gsa collection for the site -->
        <xsl:choose>
            <xsl:when test="system-index-block/calling-page/system-page/system-data-structure/default_collection != ''"><xsl:value-of select="system-index-block/calling-page/system-page/system-data-structure/default_collection"/></xsl:when>
            <xsl:otherwise>library-databases-main</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="node() | @*"> <!-- needed for the regex above to work -->
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
    <xsl:apply-templates select="system-index-block/calling-page/system-page"/>
    </xsl:template>
    
    <xsl:template match="system-index-block/calling-page/system-page">

        <!-- php only: content type must be database -->
        [system-view:external]
            <xsl:processing-instruction name="php">
                $user_agent = $_SERVER['HTTP_USER_AGENT'];
                if (strpos($user_agent, 'gsa-emory') !== false) {
                    <!-- content type -->
                    echo '&lt;meta name="content_type" content="database" /&gt;';
                }
            </xsl:processing-instruction>
        [/system-view:external]

        <!-- php only: need to do the featured stuff inside the subjects -->
        [system-view:external]
            <xsl:processing-instruction name="php">
                $user_agent = $_SERVER['HTTP_USER_AGENT'];
                if (strpos($user_agent, 'gsa-emory') !== false) {
                    <!-- featured subjects -->
                    echo '&lt;meta name="featured_subject" content="<xsl:for-each select="system-data-structure/subjects/subject[not(name='--Select a Subject--')]"><xsl:if test="featured/value = 'Yes'"><xsl:value-of select="translate(name,translate(name, $allowed_characters, ''),'')"/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:if></xsl:for-each>" /&gt;';
                }
            </xsl:processing-instruction>
        [/system-view:external]

        <!-- php only: what are the subjects -->
        [system-view:external]
            <xsl:processing-instruction name="php">
                $user_agent = $_SERVER['HTTP_USER_AGENT'];
                if (strpos($user_agent, 'gsa-emory') !== false) {
                    <!-- subject -->
                    echo '&lt;meta name="subject" content="<xsl:for-each select="system-data-structure/subjects/subject[not(name='--Select a Subject--')][not(name='')]"><xsl:value-of select="translate(name,translate(name, $allowed_characters, ''),'')"/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>" /&gt;';
                }
            </xsl:processing-instruction>
        [/system-view:external]

        <!-- php only: what are the resource types? -->
        [system-view:external]
            <xsl:processing-instruction name="php">
                $user_agent = $_SERVER['HTTP_USER_AGENT'];
                if (strpos($user_agent, 'gsa-emory') !== false) {
                    <!-- resource types -->
                    echo '&lt;meta name="resource_type" content="<xsl:for-each select="system-data-structure/resource/resource-type"><xsl:value-of select="."/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>" /&gt;';
                }
            </xsl:processing-instruction>
        [/system-view:external]

        <!-- php only: first character -->
        [system-view:external]
            <xsl:processing-instruction name="php">
                $user_agent = $_SERVER['HTTP_USER_AGENT'];
                if (strpos($user_agent, 'gsa-emory') !== false) {
                    <!-- first character -->
                    echo '&lt;meta name="letter" content="<xsl:value-of select="substring(title,1,1)"/>" /&gt;';
                }
            </xsl:processing-instruction>
        [/system-view:external]

        <!-- php only: is this a new database? -->
        <xsl:if test="system-data-structure/new-until != ''">
            [system-view:external]
                <xsl:processing-instruction name="php">
                    $user_agent = $_SERVER['HTTP_USER_AGENT'];
                    if (strpos($user_agent, 'gsa-emory') !== false) {
                        $now = strtotime('now');
                        $new_until = strtotime(str_replace('-','/', '<xsl:value-of select="system-data-structure/new-until"/>'));
                        if ($new_until <xsl:text disable-output-escaping="yes">&gt;</xsl:text> $now) {
                            echo '&lt;meta name="status" content="new" /&gt;';
                        }
                    }
                </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <!-- php only: is this database featured for a specific library? -->
        [system-view:external]
        <xsl:processing-instruction name="php">
            <xsl:variable name="feature_in">
                <xsl:choose>
                    <xsl:when test="system-data-structure/whsc/include/value = 'Yes' and system-data-structure/whsc/whsc_feature/value='Yes'">library-databases-health</xsl:when>
                    <xsl:when test="system-data-structure/whsc/include/value = 'Yes' and system-data-structure/whsc/whsc_feature/value='Yes' and dynamic-metadata[name='featured']/value='Yes'"><xsl:value-of select="$default_site"/>,library-databases-health</xsl:when>
                    <xsl:when test="dynamic-metadata[name='featured']/value='Yes'"><xsl:value-of select="$default_site"/></xsl:when>
                </xsl:choose>
            </xsl:variable>
            $user_agent = $_SERVER['HTTP_USER_AGENT'];
            if (strpos($user_agent, 'gsa-emory') !== false) {
                <!-- feature in site by collection name -->
                echo '&lt;meta name="feature_in" content="<xsl:value-of select="$feature_in"/>" /&gt;';
            }
        </xsl:processing-instruction>
        [/system-view:external]

        <!-- php only: is this database used for specific library only? -->
        [system-view:external]
        <xsl:processing-instruction name="php">
            $user_agent = $_SERVER['HTTP_USER_AGENT'];
            if (strpos($user_agent, 'gsa-emory') !== false) {
                <!-- include in site by collection name -->
                echo '&lt;meta name="include_in" content="<xsl:choose><xsl:when test="system-data-structure/whsc/exclude/value = 'Yes'"/><xsl:otherwise><xsl:value-of select="$default_site"/></xsl:otherwise></xsl:choose>,<xsl:if test="system-data-structure/whsc/include/value = 'Yes'">library-databases-health</xsl:if>" /&gt;';
            }
        </xsl:processing-instruction>
        [/system-view:external]

        <!-- php only: is this database excluded from a specific library? -->
        <xsl:if test="system-data-structure/whsc/exclude/value = 'Yes'">
            [system-view:external]
            <xsl:processing-instruction name="php">
                $user_agent = $_SERVER['HTTP_USER_AGENT'];
                if (strpos($user_agent, 'gsa-emory') !== false) {
                    <!-- exclude from site by collection name -->
                    echo '&lt;meta name="exclude_from" content="library-databases-main" /&gt;';
                }
            </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <!-- php only: is this database a trial -->
        <xsl:if test="dynamic-metadata[name='trial']/value='Yes'">
            [system-view:external]
            <xsl:processing-instruction name="php">
                $user_agent = $_SERVER['HTTP_USER_AGENT'];
                if (strpos($user_agent, 'gsa-emory') !== false) {
                    <!-- trial -->
                    echo '&lt;meta name="status" content="trial" /&gt;';
                }
            </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <!-- data fields -->

        <!-- php only: title -->
        [system-view:external]
        <xsl:processing-instruction name="php">
            $user_agent = $_SERVER['HTTP_USER_AGENT'];
            if (strpos($user_agent, 'gsa-emory') !== false) {
                <!-- full title -->
                $full_title = &lt;&lt;&lt;EOD
<xsl:value-of select="title"/>
EOD;
                echo '&lt;meta name="full_title" content="'.htmlspecialchars("$full_title").'" /&gt;';
            }
        </xsl:processing-instruction>
        [/system-view:external]

        <!-- php only: external url -->
        <xsl:if test="system-data-structure/link != ''">
        <!-- hotfix for broken proxy links, sept 2015 -->
        <xsl:variable name="db-link">
            <xsl:choose>
                <xsl:when test="contains(system-data-structure/link,'libcat1')">
                    <xsl:value-of select="concat($proxy-fix,substring-after(system-data-structure/link,'http://libcat1.cc.emory.edu:32888/'))"/>
                </xsl:when>
                <xsl:when test="contains(system-data-structure/link,'library.emory.edu:32888')">
                    <xsl:value-of select="concat($proxy-fix,substring-after(system-data-structure/link,'http://library.emory.edu:32888/'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="system-data-structure/link"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
            [system-view:external]
            <xsl:processing-instruction name="php">
                $user_agent = $_SERVER['HTTP_USER_AGENT'];
                if (strpos($user_agent, 'gsa-emory') !== false) {
                    <!-- external url -->
                    echo '&lt;meta name="external_link" content="<xsl:value-of select="$db-link"/>" /&gt;';
                }
            </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <!-- php only: coverage -->
        <xsl:if test="system-data-structure/coverage != ''">
            [system-view:external]
                <xsl:processing-instruction name="php">
                    $user_agent = $_SERVER['HTTP_USER_AGENT'];
                    if (strpos($user_agent, 'gsa-emory') !== false) {
                        <!-- coverage -->
                        $coverage = &lt;&lt;&lt;EOD
<xsl:value-of select="system-data-structure/coverage"/>
EOD;
                        echo '&lt;meta name="coverage" content="'.htmlspecialchars("$coverage").'" /&gt;';
                    }
                </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <!-- php only: location -->
        <xsl:if test="system-data-structure/location != ''">
            [system-view:external]
                <xsl:processing-instruction name="php">
                    $user_agent = $_SERVER['HTTP_USER_AGENT'];
                    if (strpos($user_agent, 'gsa-emory') !== false) {
                        <!-- location -->
                        $location = &lt;&lt;&lt;EOD
<xsl:value-of select="system-data-structure/location"/>
EOD;
                        echo '&lt;meta name="location" content="'.htmlspecialchars("$location").'" /&gt;';
                    }
                </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <!-- php only: full text -->
        <xsl:if test="system-data-structure/fulltext != ''">
            [system-view:external]
                <xsl:processing-instruction name="php">
                    $user_agent = $_SERVER['HTTP_USER_AGENT'];
                    if (strpos($user_agent, 'gsa-emory') !== false) {
                        <!-- full text -->
                        echo '&lt;meta name="fulltext" content="'.htmlspecialchars("<xsl:value-of select="system-data-structure/fulltext/value"/>").'" /&gt;';
                    }
                </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <!-- php only: alert message -->
        <xsl:if test="system-data-structure/alert != ''">
            [system-view:external]
                <xsl:processing-instruction name="php">
                    $user_agent = $_SERVER['HTTP_USER_AGENT'];
                    if (strpos($user_agent, 'gsa-emory') !== false) {
                        <!-- alert message -->
                        $alert = &lt;&lt;&lt;EOD
<xsl:value-of select="system-data-structure/alert"/>
EOD;
                        echo '&lt;meta name="alert" content="'.htmlspecialchars($alert).'" /&gt;';
                    }
                </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <!-- php only: alert type -->
        <xsl:if test="system-data-structure/alert-type != ''">
            [system-view:external]
                <xsl:processing-instruction name="php">
                    $user_agent = $_SERVER['HTTP_USER_AGENT'];
                    if (strpos($user_agent, 'gsa-emory') !== false) {
                        <!-- alert type -->
                        echo '&lt;meta name="alert_type" content="<xsl:value-of select="system-data-structure/alert-type"/>" /&gt;';
                    }
                </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <!-- php only: full description with html - gsa uses this -->
        [system-view:external]
        <xsl:processing-instruction name="php">
            $user_agent = $_SERVER['HTTP_USER_AGENT'];
            if (strpos($user_agent, 'gsa-emory') !== false) {
                <!-- whsc description -->
                $full_description = &lt;&lt;&lt;EOD
<xsl:apply-templates mode="serialize" select="system-data-structure/description/node()"/>
EOD;
                echo '&lt;meta name="full_description" content="'.htmlspecialchars($full_description).'" /&gt;';
            }
        </xsl:processing-instruction>
        [/system-view:external]     

        <!-- php only: is there a description for whsc? -->
        <xsl:if test="system-data-structure/whsc/include = 'Yes'">
            [system-view:external]
            <xsl:processing-instruction name="php">
                $user_agent = $_SERVER['HTTP_USER_AGENT'];
                if (strpos($user_agent, 'gsa-emory') !== false) {
                    <!-- whsc description -->
                    $whsc_full_description = &lt;&lt;&lt;EOD
<xsl:apply-templates mode="serialize" select="system-data-structure/whsc/description/node()"/>
EOD;
                    echo '&lt;meta name="whsc_full_description" content="'.htmlspecialchars($whsc_full_description).'" /&gt;';
                }
            </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <!-- php only: is there a description for goizueta? -->
        <xsl:if test="$default_site = 'library-databases-business'">
            [system-view:external]
            <xsl:processing-instruction name="php">
                $user_agent = $_SERVER['HTTP_USER_AGENT'];
                if (strpos($user_agent, 'gsa-emory') !== false) {
                    <!-- whsc description -->
            </xsl:processing-instruction>
                    <xsl:call-template name="create-metatag">
                        <xsl:with-param name="name">gbl_full_description</xsl:with-param>
                        <xsl:with-param name="content"><xsl:value-of select="system-data-structure/short-description"/></xsl:with-param>
                    </xsl:call-template>
            <xsl:processing-instruction name="php">
                }
            </xsl:processing-instruction>
            [/system-view:external]
        </xsl:if>

        <xsl:call-template name="create-metatag">
            <xsl:with-param name="name">description</xsl:with-param>
            <xsl:with-param name="content">
                <xsl:choose>
                    <xsl:when test="$default_site = 'library-databases-health' and system-data-structure/whsc/description/node() != ''">
                        <xsl:copy-of select="system-data-structure/description/node()"/>
                    </xsl:when>
                    <xsl:when test="$default_site = 'library-databases-business' and system-data-structure/short-description != ''">
                        <xsl:value-of select="system-data-structure/short-description"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:copy-of select="system-data-structure/description/node()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="create-metatag">
        <xsl:param name="name"/>
        <xsl:param name="content"/>

        <meta>
            <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
            <xsl:attribute name="content"><xsl:value-of select="$content"/></xsl:attribute>
        </meta>

    </xsl:template>

</xsl:stylesheet>
