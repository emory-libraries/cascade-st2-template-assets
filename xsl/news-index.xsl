<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="java" version="1.0" xmlns:date-converter="http://www.hannonhill.com/dateConverter/1.0/" xmlns:java="http://xml.apache.org/xslt/java" xmlns:xalan="http://xml.apache.org/xalan">
    <xsl:template match="system-index-block">
        <!-- Get the current time from the system index block -->
        <xsl:variable name="currentDateTime" select="@current-time"/>
        <!-- set the number of days in seconds -->
        <xsl:variable name="lastYear" select="$currentDateTime - (31536000*1000)"/>
          <aside class="feed-icon pull-right">
            <p><a href="{/system-index-block/system-page/link}.rss"><span class="fa fa-rss-square"></span></a></p>
        </aside>
        <xsl:choose>
            <xsl:when test="system-page[@current = 'true']/summary">
                <div class="summary">
                    <xsl:value-of select="system-page[@current = 'true']/summary"/>
                </div>
            </xsl:when>
            <xsl:when test="system-page[@current = 'true']/descendant::thumbnail/summary != ''">
                <div class="summary">
                    <xsl:value-of select="system-page[@current = 'true']/descendant::thumbnail/summary"/>
                </div>
            </xsl:when>
        </xsl:choose>
        <dl class="dl-horizontal news-index">
            <!--<xsl:apply-templates select="descendant::system-page[start-date &gt; $lastYear]">
                <xsl:sort order="descending" select="start-date"/>
            </xsl:apply-templates>-->
            <xsl:choose>
                <xsl:when test="descendant::system-page[preceding-sibling::system-page/@current = 'true' or following-sibling::system-page/@current = 'true']">
                    <xsl:apply-templates select="descendant::system-page[preceding-sibling::system-page/@current = 'true' or following-sibling::system-page/@current = 'true']">
                        <xsl:sort order="descending" select="start-date"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="descendant::system-page[start-date &gt; $lastYear]">
                        <xsl:sort order="descending" select="start-date"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </dl>
    </xsl:template>
    <xsl:template match="system-page">
   
        <xsl:variable name="path" select="path"/>
        <xsl:variable name="folder" select="parent::system-folder/name"/>
        <xsl:if test="name != 'index' and contains($path,$folder)">
            <xsl:variable name="url">
                <xsl:value-of select="link"/>
            </xsl:variable>
            <xsl:variable name="publish-date" select="date-converter:convertDate(number(start-date))"/>
            <dt>
                <xsl:value-of select="$publish-date"/>
            </dt>
            <dd>
                <xsl:choose>
                    <xsl:when test="system-data-structure[@definition-path = 'interior-pages/external-news-link']/external-url">
                        <a href="{system-data-structure/external-url}" target="_blank"><xsl:value-of select="title"/></a>
                        <xsl:if test="system-data-structure/source != ''">
                            - <em><xsl:value-of select="system-data-structure/source"/></em>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="{$url}"><xsl:value-of select="title"/></a>
                    </xsl:otherwise>
                </xsl:choose>
            </dd>
        </xsl:if>
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
                <!--var month= String(d.getUTCMonth() + 101);-->            
                var month= String(d.getUTCMonth());
                var monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec" ];
            <!-- jan starts at 0, add one. add 100 for extra digits -->
            <!--var month2 = month.substr(1);-->
                month2 = monthNames[d.getUTCMonth()];
                <!-- converts to 2 digit format -->
                var day= String(d.getUTCDate() + 100);
                var day2 = day.substr(1);            
                <!-- convert year to 2012-06-12 -->
                <!--var showdate = d.getUTCFullYear() + '-' + month2 + '-' + day2;-->
                var year = String(d.getUTCFullYear());
                var showdate = month2 + ' ' + day2 + ' \'' + year.substr(-2);
                var showdate = month2 + ' ' + day2 + ' \'' + year.substr(-2);
                return showdate;
            }
            
        </xalan:script>
    </xalan:component>
</xsl:stylesheet>
