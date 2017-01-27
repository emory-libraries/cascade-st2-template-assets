<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="date-converter" version="1.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:xalan="http://xml.apache.org/xalan">
    <xsl:output indent="yes" method="xml"/>
    <xsl:template match="/">
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
            <xsl:variable name="website_prefix">
        <xsl:value-of select="$domain"/>
        </xsl:variable>
        <!-- change me! -->
        <xsl:variable name="src_website_prefix">
            <xsl:value-of select="$domain"/>
        </xsl:variable>
        <!-- change me! -->
        <xsl:variable name="file_extension">.html</xsl:variable>
        <!-- RSS extension to use -->
        <!-- Path in the CMS -->
        <xsl:variable name="site_path">/</xsl:variable>
        <xsl:variable name="url"><xsl:value-of select="concat($website_prefix,substring-after(descendant::calling-page/system-page/path,$site_path),'.html')"/></xsl:variable>
        <xsl:variable name="title"><xsl:value-of select="descendant::calling-page/system-page/title"/></xsl:variable>
        <xsl:variable name="image"><xsl:value-of select="concat($website_prefix,substring-after(descendant::calling-page/system-page/descendant::image/path,$site_path))"/></xsl:variable>
        <xsl:variable name="description"><xsl:value-of select="descendant::calling-page/system-page/summary"/></xsl:variable>
        <!-- Images social metadata-->
        <xsl:for-each select="descendant::calling-page/system-page/descendant::image[path != '/']">
            <xsl:variable name="image"><xsl:value-of select="concat($website_prefix,substring-after(path,$site_path))"/></xsl:variable>
            <meta content="{$image}" property="og:image"/>
            <meta content="{$image}" name="twitter:image"/>
        </xsl:for-each>

        <!-- Facebook OpenGraph metadata -->
        <meta content="article" property="og:type"/>
        <meta content="{$url}" property="og:url"/>
        <meta content="{$title}" property="og:title"/>
        <meta content="{$description}" property="og:description"/>
        <!-- Twitter card metadata -->
        <meta content="summary" name="twitter:card"/>
        <meta content="{$url}" name="twitter:url"/>
        <meta content="{$title}" name="twitter:title"/>
        <meta content="{$description}" name="twitter:description"/>
    </xsl:template>

</xsl:stylesheet>
