<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
  <xsl:output indent="yes"/>
   <xsl:strip-space elements="li"/> 

    <xsl:template name="databases-left-col">
        <xsl:param name="is-php"/>
        
        <xsl:variable name="this-url">
            <xsl:value-of select="/system-data-structure/sources/block/content/system-index-block/system-page/path"/><xsl:text>.php</xsl:text>
        </xsl:variable>
        <xsl:variable name="gsa-collection">
            <xsl:value-of select="/system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/data/gsa-collection"/>
        </xsl:variable>
        <xsl:variable name="use-cache">
            <xsl:choose>
                <xsl:when test="/system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/data/use-cache/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="cache-time">
            <xsl:choose>
                <xsl:when test="/system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/data/use-cache/value = 'Yes' and /system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/data/cache-time != ''">
                    <xsl:value-of select="/system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/data/cache-time"/>
                </xsl:when>
                <xsl:otherwise>''</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="show-selections-sidebar">
            <xsl:choose>
                <xsl:when test="/system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/current-selections/display-location/value = 'Sidebar'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="show-featured">
            <xsl:if test="/system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/results-options/featured-options/show/value = 'Yes'">true</xsl:if>
        </xsl:variable>
        <xsl:variable name="featured-title">
            <xsl:value-of select="/system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/results-options/featured-options/title"/>
        </xsl:variable>
        <xsl:variable name="show-new">
            <xsl:choose>
                <xsl:when test="/system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/results-options/new-options/show/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="new-title">
            <xsl:value-of select="/system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/results-options/new-options/title"/>
        </xsl:variable>
        <xsl:variable name="show-status">
            <xsl:choose>
                <xsl:when test="/system-data-structure/sources/block/content/system-index-block/system-page/system-data-structure/database-options/show-status/value = 'Yes'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="$is-php = 'true'">
            [system-view:external]<xsl:processing-instruction name="php">
                function checkUrl() {
                    // store the host, and switch the path if we are on staging
                    $host = $_SERVER['SERVER_NAME'];
                    if ($host == 'staging.web.emory.edu') {
                        $prefix = '/librariestemplate';
                    } else {
                        $prefix = '';
                    }    

                    $selectors = array(<xsl:for-each select="system-data-structure/sources/block/content/system-data-structure/filter-list/list/content/ul">trim('<xsl:value-of select="@id"/>')<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>);
                    parse_str($_SERVER['QUERY_STRING'], $urlarray);
                    foreach ($urlarray as $key) {
                        if (!in_array($key, $selectors)) {
                            unset($urlarray["$key"]);
                        }
                    }
                    if (!empty($urlarray)) {
                        $controlurl = $prefix.'<xsl:value-of select="system-data-structure/sources/block/content/system-index-block/system-page/path"/>.php?'.rtrim(http_build_query($urlarray), '=');
                    } else {
                        $controlurl = $prefix.'<xsl:value-of select="system-data-structure/sources/block/content/system-index-block/system-page/path"/>.php';
                    }
                    return $controlurl;
                }

                function checkFormat() {
                    // use json for results if server supports it
                    if (!isset($_GET['format']) &amp;&amp; doesSupport('json') || isset($_GET['format']) &amp;&amp; $_GET['format'] == 'json') {
                        $format = 'json';
                    } else {
                        $format= 'xml';
                    }
                    return $format;
                }

                function doesSupport($function) {
                    return phpversion($function);
                }

                // this removes a querystring value from the url based on the key we want to remove
                function parseQueryString($url, $key, $values = '') {
                    // store the host, and switch the path if we are on staging
                        $host = $_SERVER['SERVER_NAME'];
                        if ($host == 'staging.web.emory.edu') {
                            $prefix = '/librariestemplate';
                        } else {
                            $prefix = '';
                        }
                        $parts = parse_url($url);
                        $qs = isset($parts['query']) ? $parts['query'] : '';
                        //$base = $qs ? substr($url, 0, strpos($url, '?')) : $url; // all of URL except QS
                        $base = $prefix.'<xsl:value-of select="system-data-structure/sources/block/content/system-index-block/system-page/path"/>.php';
                        parse_str($qs, $qsParts);
                        unset($qsParts[$key]);
                        $newQs = rtrim(http_build_query($qsParts), '=');
                        if ($newQs)
                        return $base.'?'.$newQs;
                        else
                        return $base;
                }

                function titleCase($string)  {
                    $len=strlen($string); 
                    $i=0; 
                    $last= ""; 
                    $new= ""; 
                    $string=strtoupper($string); 
                    while  ($i &lt; $len): 
                            $char=substr($string,$i,1); 
                            if  (ereg( "[A-Z]",$last)): 
                                    $new.=strtolower($char); 
                            else: 
                                    $new.=strtoupper($char); 
                            endif; 
                            $last=$char; 
                            $i++; 
                    endwhile; 
                    return($new); 
                }
            </xsl:processing-instruction>[/system-view:external]

        </xsl:if>

        <xsl:apply-templates select="system-data-structure/sources/block/content/system-data-structure">
            <xsl:with-param name="is-php"><xsl:value-of select="$is-php"/></xsl:with-param>

            <xsl:with-param name="this-url"><xsl:value-of select="$this-url"/></xsl:with-param>
            <xsl:with-param name="gsa-collection"><xsl:value-of select="$gsa-collection"/></xsl:with-param>
            <xsl:with-param name="show-selections-sidebar"><xsl:value-of select="$show-selections-sidebar"/></xsl:with-param>
            <xsl:with-param name="show-featured"><xsl:value-of select="$show-featured"/></xsl:with-param>
            <xsl:with-param name="featured-title"><xsl:value-of select="$featured-title"/></xsl:with-param>
            <xsl:with-param name="show-new"><xsl:value-of select="$show-new"/></xsl:with-param>
            <xsl:with-param name="new-title"><xsl:value-of select="$new-title"/></xsl:with-param>
            <xsl:with-param name="show-status"><xsl:value-of select="$show-status"/></xsl:with-param>
            <xsl:with-param name="use-cache"><xsl:value-of select="$use-cache"/></xsl:with-param>
            <xsl:with-param name="cache-time"><xsl:value-of select="$cache-time"/></xsl:with-param>

        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="system-data-structure/sources/block/content/system-data-structure">
        <xsl:param name="is-php"/>

        <xsl:param name="this-url"/>
        <xsl:param name="gsa-collection"/>
        <xsl:param name="show-selections-sidebar"/>
        <xsl:param name="show-featured"/>
        <xsl:param name="featured-title"/>
        <xsl:param name="show-new"/>
        <xsl:param name="new-title"/>
        <xsl:param name="show-status"/>
        <xsl:param name="use-cache"/>
        <xsl:param name="cache-time"/>

        <xsl:text disable-output-escaping="yes">&lt;!--googleoff: all --&gt;</xsl:text>
        <xsl:choose>
            <xsl:when test="$is-php = 'true'">
                [system-view:external]<xsl:processing-instruction name="php">

                    $format = checkFormat();

                    echo '&lt;form class="browse-databases accordion primary-form" name="database-filter" id="database-filter" action="#" method="get" data-url="<xsl:value-of select="$this-url"/>"&gt;';
                </xsl:processing-instruction>[/system-view:external]
                    
                    <h2><xsl:choose><xsl:when test="heading != ''"><xsl:value-of select="heading"/></xsl:when><xsl:otherwise>Browse Databases</xsl:otherwise></xsl:choose></h2>
            
                    <!-- create filter lists -->
                    <xsl:apply-templates select="filter-list">
                        <xsl:with-param name="is-php"><xsl:value-of select="$is-php"/></xsl:with-param>
                        <xsl:with-param name="show-selections-sidebar"><xsl:value-of select="$show-selections-sidebar"/></xsl:with-param>
                    </xsl:apply-templates>

                    <!-- post filter -->
                    <xsl:apply-templates select="aside"/>

                [system-view:external]<xsl:processing-instruction name="php">
                    echo '&lt;/form&gt;';
                </xsl:processing-instruction>[/system-view:external]
            </xsl:when>
        <xsl:otherwise>
        <form>
            
            <xsl:attribute name="class">browse-databases accordion primary-form</xsl:attribute>
            <xsl:attribute name="name">database-filter</xsl:attribute>
            <xsl:attribute name="id">database-filter</xsl:attribute>
            <xsl:attribute name="action">#</xsl:attribute>
            <xsl:attribute name="method">get</xsl:attribute>

            <xsl:attribute name="data-url">/_api/v1/gsa/results/?site=<xsl:value-of select="$gsa-collection"/>&amp;num=25&amp;numgm=0&amp;filter=0&amp;getfields=*&amp;requiredfields=content_type:database&amp;use_cache=<xsl:choose><xsl:when test="$use-cache = 'true'">1&amp;cache_time=<xsl:value-of select="$cache-time"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:attribute>

            <h2><xsl:choose><xsl:when test="heading != ''"><xsl:value-of select="heading"/></xsl:when><xsl:otherwise>Browse Databases</xsl:otherwise></xsl:choose></h2>
            
            <!-- create filter lists -->
            <xsl:apply-templates select="filter-list">
                <xsl:with-param name="is-php"><xsl:value-of select="$is-php"/></xsl:with-param>
                <xsl:with-param name="show-selections-sidebar"><xsl:value-of select="$show-selections-sidebar"/></xsl:with-param>
            </xsl:apply-templates>

            <!-- post filter -->
            <xsl:apply-templates select="aside"/>

        </form>
        </xsl:otherwise>
        </xsl:choose>
        <xsl:text disable-output-escaping="yes">&lt;!--googleon: all --&gt;</xsl:text>
    </xsl:template>

    <!-- setup the list -->
    <xsl:template match="filter-list">
        <xsl:param name="is-php"/>
        <xsl:param name="show-selections-sidebar"/>
        <xsl:variable name="this-filter"><xsl:value-of select="list/content/ul/@id"/></xsl:variable>
        <xsl:if test="hide = ''">
            <xsl:choose>
                <xsl:when test="expanded = ''">
                    <fieldset class="browse-group accordion-group">
                        <h3 class="accordion-heading">
                            <a class="accordion-toggle" data-parent="#database-filter" data-toggle="collapse">
                                <xsl:attribute name="href">#<xsl:value-of select="$this-filter"/></xsl:attribute>
                                <xsl:value-of select="heading"/>
                            </a>
                        </h3>
                        <xsl:apply-templates select="list/content/ul">
                            <xsl:with-param name="this-filter" select="$this-filter"/>
                            <xsl:with-param name="is-php"><xsl:value-of select="$is-php"/></xsl:with-param>
                            <xsl:with-param name="accordion">true</xsl:with-param>
                            <xsl:with-param name="collapse">true</xsl:with-param>
                        </xsl:apply-templates>
                    </fieldset>
                </xsl:when>
                <xsl:otherwise>
                    <fieldset class="browse-group accordion-group">
                        <h3 class="accordion-heading">
                            <a class="accordion-toggle" data-parent="#database-filter" data-toggle="collapse">
                                <xsl:attribute name="href">#<xsl:value-of select="$this-filter"/></xsl:attribute>
                                <xsl:value-of select="heading"/>
                            </a>
                        </h3>
                        <xsl:apply-templates select="list/content/ul">
                            <xsl:with-param name="this-filter" select="$this-filter"/>
                            <xsl:with-param name="is-php"><xsl:value-of select="$is-php"/></xsl:with-param>
                            <xsl:with-param name="accordion">true</xsl:with-param>
                            <xsl:with-param name="collapse">false</xsl:with-param>
                        </xsl:apply-templates>
                    </fieldset>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$is-php = 'true'">

                [system-view:external]
                <xsl:if test="$is-php = 'true' and $show-selections-sidebar = 'true'">
                    <xsl:processing-instruction name="php"> 

                        $url = $_SERVER["REQUEST_URI"];
                        $controlurl = checkUrl();

                        $group = '<xsl:value-of select="list/content/ul/@id"/>';
                        $key = trim("$group");
                        if (isset($_GET["$key"]) &amp;&amp; $_GET["$key"] !== '') {
                            $value = $_GET["$key"];

                            if ( strpos ( urldecode($value), '.') !== false) {
                                $value = explode('.', $value);
                            } else {
                                $value = $_GET["$key"];
                            }

                        } else {
                            $key = '';
                            $value = '';
                        }

                        $url = parseQueryString($url,$key,$value);

                        // compare the urls. if they do not match, there is a current selection.
                        if ($url !== $controlurl) {
                            // show the current selection with a link to remove it.
                            echo '&lt;ul class="'.$key.' filter-list unstyled well well-small clearfix"&gt;';
                                    echo '&lt;li&gt;&lt;strong&gt;Your Selections:&lt;/strong&gt;&lt;/li&gt;';
                                    if (!is_array($value)) {
                                        echo '&lt;li&gt;&lt;span&gt;'.titleCase(urldecode(urldecode($value))).'&lt;a href="'.htmlspecialchars($url).'" title="Remove this filter" class="remove"&gt;x&lt;/a&gt;&lt;/span&gt;&lt;/li&gt;';
                                    } else {
                                        foreach ($value as $item) {
                                            $replace = array('.'.urlencode($item), urlencode($item).'.', urlencode($item));
                                            $url = str_replace($replace, '', $controlurl);
                                            echo '&lt;li&gt;&lt;span&gt;'.titleCase(urldecode(urldecode($item))).'&lt;a href="'.htmlspecialchars($url).'" title="Remove this filter" class="remove"&gt;x&lt;/a&gt;&lt;/span&gt;&lt;/li&gt;';
                                        }
                                    }
                            echo '&lt;/ul&gt;';
                        }

                    </xsl:processing-instruction>
                </xsl:if>
                [/system-view:external]

            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- make the list work with the accordion -->
    <xsl:template match="list/content/ul">
        <xsl:param name="this-filter"/>
        <xsl:param name="is-php"/>
        <xsl:param name="accordion"/>
        <xsl:param name="collapse"/>
        <ul>
            <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
            <xsl:attribute name="id"><xsl:value-of select="$this-filter"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="$accordion = 'true'">
                    <xsl:attribute name="class">accordion-body<xsl:if test="$collapse = 'true'"><xsl:text> </xsl:text>collapse</xsl:if><xsl:if test="$collapse = 'false'"><xsl:text> </xsl:text>in</xsl:if><xsl:if test="@class"><xsl:text> </xsl:text><xsl:value-of select="@class"/></xsl:if></xsl:attribute>
                </xsl:when>
                <xsl:otherwise><xsl:attribute name="class">standard<xsl:if test="@class"><xsl:text> </xsl:text><xsl:value-of select="@class"/></xsl:if></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="$is-php = 'true'">
                    [system-view:external]<xsl:processing-instruction name="php">
                        $key = trim("<xsl:value-of select="$id"/>");
                        $url = $_SERVER["REQUEST_URI"];
                        $items = array(<xsl:for-each select="li">"<xsl:value-of select="."/>"<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>);
                        foreach ($items as $item) {
                            $urlvalue = strtolower(urlencode($item));
                            $this_url = parseQueryString( $url,$key);
                            // add the new string to the url
                            if(strpos($this_url,'?') !== false) {
                               $this_url .= "&amp;$key=$urlvalue";
                            } else {
                               $this_url .= "?$key=$urlvalue";
                            }
                            echo '&lt;li&gt;&lt;a href="'.htmlspecialchars($this_url).'"&gt;'.$item.'&lt;/a&gt;&lt;/li&gt;';
                        }
                    </xsl:processing-instruction>[/system-view:external]
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="li">
                        <xsl:with-param name="id"><xsl:value-of select="$id"/></xsl:with-param>
                        <xsl:with-param name="is-php"><xsl:value-of select="$is-php"/></xsl:with-param>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>

        </ul>
    </xsl:template>

    <!-- each list item -->
    <xsl:template match="li">
        <xsl:param name="id"/>
        <xsl:param name="is-php"/>
        <li>
            <a>
                <xsl:attribute name="href">#</xsl:attribute>
                <xsl:value-of select="."/>
            </a>
        </li>
    </xsl:template>

    <!-- aside below filter list -->
    <xsl:template match="aside">
        <xsl:if test="page/path != '/' or external != '' or file/path != '/' or wysiwyg != ''">
            <aside class="alert alert-info">
                <xsl:if test="page/path != '/' or external != '' or file/path != '/'">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="page/path != '/'">
                                    <xsl:value-of select="page/link"/>
                                </xsl:when>
                                <xsl:when test="external != ''">
                                    <xsl:value-of select="external"/>
                                </xsl:when>
                                <xsl:when test="file/path != '/'">
                                    <xsl:value-of select="file/link"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                    </a>
                </xsl:if>
                <xsl:if test="wysiwyg != ''">
                    <xsl:copy-of select="wysiwyg/node()"/>
                </xsl:if>
            </aside>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
