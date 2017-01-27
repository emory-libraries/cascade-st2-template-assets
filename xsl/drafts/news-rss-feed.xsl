<?xml version="1.0" encoding="UTF-8"?>
<!--

MAKE A LOCAL COPY OF THIS XSLT so you can configure it for your site as needed

use with a noroot XML template
change the website_prefix and list_number variables to suit
determine the sort order and date to display: start date? created-on? last-modified
--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="date-converter" version="1.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:xalan="http://xml.apache.org/xalan">
    <xsl:import href="/_cms/xsl/drafts/news-article"/>
    <xsl:import href="/_cms/xsl/drafts/structured-news-article"/>
    <xsl:output indent="yes" method="xml"/>

    <xsl:variable name="from-rss"><xsl:text>Yes</xsl:text></xsl:variable>
    <!-- URL prefix for links - must be absolute URLs -->
    <xsl:variable name="domain">
        <!--set variable for replacement domain; might need to include GBL and WHSC later-->
        <xsl:choose>
            <xsl:when test="descendant::calling-page/system-page/site = 'Library - MARBL'">
                <xsl:text>http://marbl.library.emory.edu/</xsl:text>
            </xsl:when>
            <xsl:when test="descendant::calling-page/system-page/site = 'Library - Woodruff'">
                <xsl:text>http://web.library.emory.edu/</xsl:text>
            </xsl:when>
            <xsl:when test="descendant::calling-page/system-page/site = 'Library - Oxford'">
                <xsl:text>http://oxford.library.emory.edu/</xsl:text>
            </xsl:when>
            <xsl:when test="descendant::calling-page/system-page/site = 'Library Template'">
                <xsl:text>http://staging.web.emory.edu/librariestemplate/</xsl:text>
            </xsl:when>
        </xsl:choose>           
    </xsl:variable>
    <xsl:variable name="website_prefix"><xsl:value-of select="$domain"/></xsl:variable><!-- change me! -->
    <xsl:variable name="src_website_prefix"><xsl:value-of select="$domain"/></xsl:variable><!-- change me! -->
    <xsl:variable name="list_number">7</xsl:variable><!-- number of stories to list -->
    <!-- File extension used -->
    <xsl:variable name="file_extension">.html</xsl:variable>
    <!-- RSS extension to use -->
    <xsl:variable name="rss_extension">.rss</xsl:variable><!-- config set matched publish as .xml -->
    <!-- Name of RSS generator -->
    <xsl:variable name="rss_generator">Cascade Server</xsl:variable>
    <!-- Web master's email address -->
    <xsl:variable name="web_master">webmaster@site.com</xsl:variable>
    <!-- Path in the CMS -->
    <xsl:variable name="site_path">/</xsl:variable>
    <!-- Match on the root index block -->
    <xsl:template match="/">
        <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/">
            <channel>
                <atom:link href="https://pubsubhubbub.appspot.com/" rel="hub"/>
                <xsl:variable name="self" select="concat($website_prefix,substring-after(descendant::calling-page/system-page/path,$site_path),$rss_extension)"/>
                <atom:link href="{$self}" rel="self"/>
                <!-- write RSS header information -->
                <xsl:apply-templates mode="current" select="/system-index-block/calling-page/system-page[not(dynamic-metadata[name='Show in archive']/value='Hide')]"/>
                <!-- avoid index pages and cms base assets for content type index -->
                <!--<xsl:apply-templates select="//system-page[not(contains(name,'index')) and not(dynamic-metadata[name='Show in archive']/value='Hide')][not(ancestor::calling-page)][not(contains(path,'_cms'))] | //system-symlink[not(contains(name,'index')) and not(dynamic-metadata[name='Show in archive']/value='Hide')][not(ancestor::calling-page)][not(contains(path,'_cms'))]">-->
                <xsl:variable name="current-path"><xsl:value-of select="/system-index-block/calling-page/system-page/path"/></xsl:variable>
                <xsl:apply-templates select="descendant::system-page[not(contains(name,'index')) and not(dynamic-metadata[name='Show in archive']/value='Hide')][not(ancestor::calling-page)][not(contains(path,'_cms'))] | //system-symlink[not(contains(name,'index')) and not(dynamic-metadata[name='Show in archive']/value='Hide')][not(ancestor::calling-page)][not(contains(path,'_cms'))]">
                    <xsl:sort order="descending" select="start-date"/>
                </xsl:apply-templates>
            </channel>
        </rss>

    </xsl:template>
    <!-- Matches on the current system page, the news type page -->
    <xsl:template match="system-page" mode="current">
        <title><xsl:value-of select="title"/></title>
        <link>
            <xsl:value-of select="$website_prefix"/><xsl:value-of select="substring-after(path,$site_path)"/><xsl:value-of select="$file_extension"/>
        </link>
        <description>
            <xsl:value-of select="summary"/>
        </description>
        <pubDate>
            <!-- Get the start-date of the most recent item, whether it's a symlink or a page -->
            
            <!-- <xsl:for-each select="/system-folder[1]/*/start-date">
                <xsl:if test="position() = 1">
                    <xsl:value-of select="current()"/>
                </xsl:if>
        </xsl:for-each> -->
            
            <!--<xsl:choose>
                <xsl:when test="../system-folder[1]/system-symlink[1]/start-date &gt; ../system-folder[1]/system-page[1]/start-date">
                    <xsl:value-of select="date-converter:convertDate(number(../system-folder[1]/system-symlink[1]/start-date))"/>
                </xsl:when>
                <xsl:when test="../system-folder[1]/system-symlink[1]/start-date &lt; ../system-folder[1]/system-page[1]/start-date">
                    <xsl:value-of select="date-converter:convertDate(number(../system-folder[1]/system-page[1]/start-date))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="date-converter:convertDate(number(last-modified))"/>
                </xsl:otherwise>
            </xsl:choose>-->
            <xsl:value-of select="date-converter:convertDate(number(/system-index-block/@current-time))"/>
        </pubDate>
        <generator>
            <xsl:value-of select="$rss_generator"/>
        </generator>
        <!-- <webMaster><xsl:value-of select="$web_master"/></webMaster> -->
    </xsl:template>

    <!-- Match # of $list_number invidiual news item pages -->
    <xsl:template match="system-page | system-symlink">
        <xsl:if test="position() &lt; $list_number+1">
            <item>
                <title><xsl:value-of select="title"/></title>
                <link>
                    <xsl:choose>
                        <xsl:when test="name() = 'system-symlink'">
                            <xsl:value-of select="link"/>
                        </xsl:when>
                        <xsl:when test="name() = 'system-page'">
                            <xsl:choose>
                            <!-- If it's a media coverage index, use the external url -->
                                <xsl:when test="/system-index-block[@name = 'media-coverage-index']">
                                    <xsl:value-of select="system-data-structure/external-url"/>
                                </xsl:when>
                            <!-- If it's a news index, use the page/symlink path -->
                                <xsl:when test="/system-index-block[@name = 'news-index']">
                                    <xsl:value-of select="$website_prefix"/><xsl:value-of select="substring-after(path,$site_path)"/><xsl:value-of select="$file_extension"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </link>
                <description><xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text><xsl:value-of select="descendant::summary"/><xsl:text disable-output-escaping="yes">]]&gt;</xsl:text></description>
                <content:encoded>
                    <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                        <xsl:choose>
                            <xsl:when test="descendant::main-content">
                                <xsl:apply-templates mode="structured" select="."/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates mode="old" select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- insert section and section headings here -->
                        <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
                </content:encoded>
                <pubDate>
                    <xsl:choose>
                        <xsl:when test="start-date">
                            <xsl:value-of select="date-converter:convertDate(number(start-date))"/>
                        </xsl:when>
                        <!--  <xsl:when test="last-modified">
                        <xsl:value-of select="date-converter:convertDate(number(last-modified))"/>
                        </xsl:when> -->
                        <xsl:otherwise>
                            <xsl:value-of select="date-converter:convertDate(number(created-on))"/>
                        </xsl:otherwise>
                    </xsl:choose>

                </pubDate>
                <guid>
                    <!--<xsl:value-of select="$website_prefix"/>/<xsl:value-of select="@id"/>-->
                    <!-- safari uses id to create link = broken  link -->
                    <xsl:choose>
                        <xsl:when test="name() = 'system-symlink'">
                            <xsl:value-of select="link"/>
                        </xsl:when>
                        <xsl:when test="name() = 'system-page'">
                            <xsl:choose>
                            <!-- If it's a media coverage index, use the external url -->
                                <xsl:when test="/system-index-block[@name = 'media-coverage-index']">
                                    <xsl:value-of select="system-data-structure/external-url"/>
                                </xsl:when>
                            <!-- If it's a news index, use the page/symlink path -->
                                <xsl:when test="/system-index-block[@name = 'news-index']">
                                    <xsl:value-of select="$website_prefix"/><xsl:value-of select="substring-after(path,$site_path)"/><xsl:value-of select="$file_extension"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </guid>
            </item>
        </xsl:if>
    </xsl:template>

    <!-- template for grabbing a feature image -->
    <xsl:template match="image">
        <figure>
            <xsl:variable name="src" select="concat($src_website_prefix,substring-after(descendant::path,$site_path))"/>
            <img src="{$src}"/>
            <xsl:if test="credit != ''">
                <p>Photo Credit: <xsl:value-of select="credit"/></p>
            </xsl:if>
            <xsl:if test="caption != ''">
                <figcaption>
                    <xsl:value-of select="caption"/>                    
                </figcaption> 
            </xsl:if>
        </figure>
    </xsl:template>

    <xsl:template match="main/node()" mode="rss">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>
    
    <!-- recursive template for article copy -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- template to find all a tags with either href or src to change site links to absolute urls -->
    <xsl:template match="@href[parent::a] | @src[parent::img]">
        <xsl:variable name="replace_site_name">
            <!--set variable to look for specific site paths-->
            <xsl:choose>
                <xsl:when test="contains(.,'site://Library - MARBL')">
                    <xsl:text>site://Library - MARBL/</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'site://Library - Woodruff')">
                    <xsl:text>site://Library - Woodruff/</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'site://Library - Oxford')">
                    <xsl:text>site://Library - Oxford/</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="domain">
            <!--set variable for replacement domain; might need to include GBL and WHSC later-->
            <xsl:choose>
                <xsl:when test="contains(.,'site://Library - MARBL')">
                    <xsl:text>http://marbl.library.emory.edu/</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'site://Library - Woodruff')">
                    <xsl:text>http://web.library.emory.edu/</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'site://Library - Oxford')">
                    <xsl:text>http://oxford.library.emory.edu/</xsl:text>
                </xsl:when>
            </xsl:choose>           
        </xsl:variable>
            <!--set variable list for potential file extensions for documents and images with site links-->
        <xsl:variable name="potential_extensions" select="'pdf doc gif jpg png'"/>
        <xsl:variable name="path_extension">
            <!--If the site link includes a potential extension, assign the appropriate extension; if no extension, then presume it's an html page-->
            <xsl:choose>
                <xsl:when test="contains($potential_extensions,substring(.,string-length(.)-2,3))">
                    <xsl:value-of select="substring(.,string-length(.)-2,3)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'.html'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
            <!--Concatenate the new url based on domain, remainder of link after the original site name, and the file extension-->
        <xsl:variable name="href_src_concat" select="concat($domain,substring-after(.,$replace_site_name),$path_extension)"/>
        <!--If the given a tag contains 'site://', replace the href or src attribute with the new url; otherwise use the existing url-->
        <xsl:choose>
            <xsl:when test="contains(.,'site://')">
                <xsl:choose>
                    <xsl:when test="name() = 'href'">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$href_src_concat"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name() = 'src'">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$href_src_concat"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>

    <!-- Xalan component for date conversion from CMS date format to RSS 2.0 pubDate format -->
    <xalan:component functions="convertDate" prefix="date-converter">
        <xalan:script lang="javascript">function convertDate(date)
            {
            var d = new Date(date);
            // Splits date into components
            var temp = d.toString().split(' ');
            // timezone difference to GMT
            var timezone = temp[5].substring(3);
            // RSS 2.0 valid pubDate format
            var retString = temp[0] + ', ' + temp[2] + ' ' + temp[1] + ' ' + temp[3] + ' ' + temp[4] + ' ' + timezone;
            return retString;
            }</xalan:script>
    </xalan:component>
</xsl:stylesheet>
