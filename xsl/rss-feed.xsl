<?xml version="1.0" encoding="UTF-8"?>
<!--

MAKE A LOCAL COPY OF THIS XSLT so you can configure it for your site as needed

use with a noroot XML template
change the website_prefix and list_number variables to suit
determine the sort order and date to display: start date? created-on? last-modified
--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="date-converter" version="1.0" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:xalan="http://xml.apache.org/xalan">

    <xsl:output indent="yes" method="xml"/>

    <!-- URL prefix for links - must be absolute URLs -->
    <xsl:variable name="website_prefix">http://staging.web.emory.edu/librariestemplate/</xsl:variable><!-- change me! -->
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
    <xsl:template match="system-index-block">
        <rss version="2.0">
            <channel>
                <!-- write RSS header information -->
                <xsl:apply-templates mode="current" select="//system-page[@current='true' and not(dynamic-metadata[name='Show in archive']/value='Hide')][not(ancestor::calling-page)]"/>
                <!-- avoid index pages and cms base assets for content type index -->
                <xsl:apply-templates select="//system-page[not(contains(name,'index')) and not(dynamic-metadata[name='Show in archive']/value='Hide')][not(ancestor::calling-page)][not(contains(path,'_cms'))] | //system-symlink[not(contains(name,'index')) and not(dynamic-metadata[name='Show in archive']/value='Hide')][not(ancestor::calling-page)][not(contains(path,'_cms'))]">
                    <xsl:sort order="descending" select="start-date"/>
                </xsl:apply-templates>

            </channel>
        </rss>

    </xsl:template>
    <!-- Matches on the current system page, the news type page -->
    <xsl:template match="system-page" mode="current">
        <title><xsl:value-of select="title"/></title>
        <link>
            <xsl:value-of select="$website_prefix"/><xsl:value-of select="substring-after(path,$site_path)"/><xsl:value-of select="$rss_extension"/>
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
            
            <xsl:choose>
                <xsl:when test="../system-folder[1]/system-symlink[1]/start-date &gt; ../system-folder[1]/system-page[1]/start-date">
                    <xsl:value-of select="date-converter:convertDate(number(../system-folder[1]/system-symlink[1]/start-date))"/>
                </xsl:when>
                <!--  <xsl:when test="last-modified">
                <xsl:value-of select="date-converter:convertDate(number(last-modified))"/>
                </xsl:when> -->
                <xsl:when test="../system-folder[1]/system-symlink[1]/start-date &lt; ../system-folder[1]/system-page[1]/start-date">
                    <xsl:value-of select="date-converter:convertDate(number(../system-folder[1]/system-page[1]/start-date))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="date-converter:convertDate(number(last-modified))"/>
                </xsl:otherwise>
            </xsl:choose>
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
                            <xsl:value-of select="$website_prefix"/><xsl:value-of select="substring-after(path,$site_path)"/><xsl:value-of select="$file_extension"/>
                        </xsl:when>
                    </xsl:choose>
                </link>
                <description>
                    <xsl:value-of select="summary"/>
                </description>
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
                            <xsl:value-of select="$website_prefix"/><xsl:value-of select="substring-after(path,$site_path)"/><xsl:value-of select="$file_extension"/>
                        </xsl:when>
                    </xsl:choose>
                </guid>
            </item>
        </xsl:if>
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
