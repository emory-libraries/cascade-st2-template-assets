<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="date-converter" version="1.0" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:xalan="http://xml.apache.org/xalan">
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:variable name="from-rss">
        <xsl:text>No</xsl:text>
    </xsl:variable>
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
    <!-- Path in the CMS -->
    <xsl:variable name="site_path">/</xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates mode="old" select="/system-index-block/calling-page/system-page"/>
    </xsl:template>
    <xsl:template match="system-page" mode="old">
        <article class="data-entry">
            <xsl:if test="$from-rss = 'No'">
                <xsl:if test="descendant::subheadline != ''">
                    <h2><xsl:value-of select="descendant::subheadline"/></h2>
                </xsl:if>
                <p class="publication-date">Published <xsl:value-of select="date-converter:convertDate(number(start-date))"/></p>
            </xsl:if>
            <xsl:if test="summary !=''">
                <p class="summary">
                    <xsl:value-of select="summary"/>
                </p>
            </xsl:if>
            <xsl:apply-templates mode="old" select="descendant::article-details"/>
        </article>
    </xsl:template>
    
    <!-- Transform article details -->
    <xsl:template match="article-details" mode="old">
        <xsl:if test="author !=''">
            <p class="author"> by 
                <xsl:apply-templates select="author"/>
            </p>
        </xsl:if>
        <xsl:variable name="img-src">
            <xsl:choose>
                <xsl:when test="$from-rss = 'Yes'">
                    <xsl:value-of select="concat($src_website_prefix,substring-after(descendant::path,$site_path))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="content/feature-photo/photo/link"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:if test="$img-src != ''">
            <figure class="structured-inset pull-right">
                <img src="{$img-src}"/>
                <xsl:if test="content/feature-photo/credit != '' ">
                    <p class="photo-credit muted">Photo credit: <xsl:value-of select="content/feature-photo/credit"/></p>
                </xsl:if>
                <xsl:if test="content/feature-photo/caption != '' ">
                    <figcaption class="muted">
                        <xsl:value-of select="content/feature-photo/caption"/>
                    </figcaption>
                </xsl:if>
            </figure>
        </xsl:if>
        <section class="article-copy">
            <xsl:copy-of select="content/article-copy/node()"/>
        </section>
        <xsl:if test="related-links/link/page/link or related-links/link/external != '' or related-links/link/file/link">
            <section class="related-links">
                <h3>Related Links:</h3>
                <ul class="links">
                    <xsl:apply-templates mode="old" select="related-links/link"/>
                </ul>
            </section>
        </xsl:if>
        <xsl:if test="contact-info/name != ''">
            <section class="contact-info">
                <h3>For media inquiries, contact:</h3>
                <xsl:apply-templates mode="old" select="contact-info"/>
            </section>
        </xsl:if>
    </xsl:template>
    
    <!-- Parse through authors and format based on number of authors accordingly -->
    <xsl:template match="author">
        <!-- If there is more than one author... -->
        <xsl:if test="count(../author) &gt; 1">
            <!-- If there are exactly two authors, and this is the last one, prefix with " and "... -->
            <xsl:if test="count(../author) = 2 and current() = //author[last()]">
                &#32;and&#32; </xsl:if>
            <!-- If there are more than two authors... -->
            <xsl:if test="count(../author) &gt; 2">
                <!-- If this is not the first or last, prefix with ", " -->
                <xsl:if test="current() != //author[position() = 1] and current() != //author[last()]">,&#32;</xsl:if>
                <!-- If this is the last of 3 or more, prefix with ", and " -->
                <xsl:if test="current() = //author[last()]">,&#32;and&#32;</xsl:if>
            </xsl:if>
        </xsl:if>
        <!-- Output the current author -->
        <xsl:value-of select="current()"/>
    </xsl:template>
    
    <!-- Parse through related links and build list items -->
    <xsl:template match="link" mode="old">
        <xsl:variable name="url">
            <xsl:choose>
                <xsl:when test="page/link">
                    <xsl:value-of select="page/link"/>
                </xsl:when>
                <xsl:when test="external != ''">
                    <xsl:value-of select="external"/>
                </xsl:when>
                <xsl:when test="file/link">
                    <xsl:value-of select="file/link"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <li><a href="{$url}"><xsl:value-of select="label"/></a></li>
    </xsl:template>
 
    <!-- Parse through contacts and output info if available -->
    <xsl:template match="contact-info" mode="old">
        <ul class="contact">
            <xsl:if test="name !=''">
                <li class="contact-name">
                    <strong><xsl:value-of select="name"/></strong>
                </li>
            </xsl:if>
            <xsl:if test="title !=''">
                <li class="contact-title">
                    <xsl:value-of select="title"/>
                </li>
            </xsl:if>
            <xsl:if test="phone !=''">
                <li class="contact-phone">
                    Phone: 
                    <xsl:value-of select="phone"/>
                </li>
            </xsl:if>
            <xsl:if test="e-mail !=''">
                <li class="contact-email">
                    Email: 
                    <a href="mailto:{e-mail}"><xsl:value-of select="e-mail"/></a>
                </li>
            </xsl:if>
        </ul>
    </xsl:template>
    
    <!-- xalan date converter required -->
    <xalan:component functions="convertDate,getYear" prefix="date-converter">
        <xalan:script lang="javascript">
            function getYear(date) {
            var d = new Date(date);
            var showyear = d.getUTCFullYear();
            return showyear;
            }
            
            function convertDate(date) {
            var d = new Date(date);
            var month= String(d.getUTCMonth() + 101);
            <!-- jan starts at 0, add one. add 100 for extra digits -->
            var month2 = month.substr(1);
            <!-- converts to 2 digit format -->
            var day= String(d.getUTCDate() + 100);
            var day2 = day.substr(1);
            <!-- convert year to 2012-06-12 -->
            var showdate = d.getUTCFullYear() + '-' + month2 + '-' + day2; 
            var showdate = month2 + '-' + day2 + '-' +  d.getUTCFullYear() ; 
            return showdate;
            }
        </xalan:script>
    </xalan:component>
</xsl:stylesheet>
