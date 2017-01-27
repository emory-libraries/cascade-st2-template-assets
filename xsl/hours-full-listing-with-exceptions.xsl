<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="date java" version="1.0" xmlns:date="xalan://java.text.SimpleDateFormat" xmlns:java="http://xml.apache.org/xslt/java">
    <xsl:output indent="yes"/>


    <xsl:template match="system-index-block">
        <!-- Create new Calendar instance -->
        <xsl:variable name="calendar" select="java:java.util.Calendar.getInstance()"/>
        
        <!-- Create new SimpleDateFormat instance -->
        <xsl:variable name="friendlyFormat" select="java:java.text.SimpleDateFormat.getDateTimeInstance()"/>
        <xsl:variable name="cascadeFormat" select="java:java.text.SimpleDateFormat.getDateTimeInstance()"/>

        <!-- Set the SimpleDateFormat pattern -->
        <xsl:variable name="void" select="java:applyPattern($friendlyFormat, 'EEE, MMM d')"/>
        <xsl:variable name="void" select="java:applyPattern($cascadeFormat, 'MM-dd-yyyy')"/>

        <xsl:variable name="today-friendly">
            <xsl:value-of select="java:format($friendlyFormat, java:getTime($calendar))"/>
        </xsl:variable>
        <xsl:variable name="today-cascade">
            <xsl:value-of select="java:format($cascadeFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <!-- Increment day by 1 and record the value of the date -->

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="tomorrow-friendly">
            <xsl:value-of select="java:format($friendlyFormat, java:getTime($calendar))"/>
        </xsl:variable>
        <xsl:variable name="tomorrow-cascade">
            <xsl:value-of select="java:format($cascadeFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <!-- Repeat for the rest of the days... -->
        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day3-friendly">
            <xsl:value-of select="java:format($friendlyFormat, java:getTime($calendar))"/>
        </xsl:variable>
        <xsl:variable name="day3-cascade">
            <xsl:value-of select="java:format($cascadeFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day4-friendly">
            <xsl:value-of select="java:format($friendlyFormat, java:getTime($calendar))"/>
        </xsl:variable>
        <xsl:variable name="day4-cascade">
            <xsl:value-of select="java:format($cascadeFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day5-friendly">
            <xsl:value-of select="java:format($friendlyFormat, java:getTime($calendar))"/>
        </xsl:variable>
        <xsl:variable name="day5-cascade">
            <xsl:value-of select="java:format($cascadeFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day6-friendly">
            <xsl:value-of select="java:format($friendlyFormat, java:getTime($calendar))"/>
        </xsl:variable>
        <xsl:variable name="day6-cascade">
            <xsl:value-of select="java:format($cascadeFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day7-friendly">
            <xsl:value-of select="java:format($friendlyFormat, java:getTime($calendar))"/>
        </xsl:variable>
        <xsl:variable name="day7-cascade">
            <xsl:value-of select="java:format($cascadeFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:copy-of select="calling-page/system-page/system-data-structure/announcement/node()"/>
        <xsl:if test="calling-page/system-page/system-data-structure/range != ''">
            <h2>
                <xsl:value-of select="calling-page/system-page/system-data-structure/range"/>
            </h2>
        </xsl:if>
        <div class="hours table-container">
            <table class="table-striped">
                <thead>
                    <tr>
                        <td/>
                        <th>Today</th>
                        <th><xsl:value-of select="$tomorrow-friendly"/></th>
                        <th><xsl:value-of select="$day3-friendly"/></th>
                        <th><xsl:value-of select="$day4-friendly"/></th>
                        <th><xsl:value-of select="$day5-friendly"/></th>
                        <th><xsl:value-of select="$day6-friendly"/></th>
                        <th><xsl:value-of select="$day7-friendly"/></th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:apply-templates select="calling-page/system-page/system-data-structure/hours-listing/hours-block/content/system-data-structure/hours-main">
                        <xsl:with-param name="today-friendly" select="$today-friendly"/>
                        <xsl:with-param name="today-cascade" select="$today-cascade"/>
                        <xsl:with-param name="tomorrow-friendly" select="$tomorrow-friendly"/>
                        <xsl:with-param name="tomorrow-cascade" select="$tomorrow-cascade"/>
                        <xsl:with-param name="day3-friendly" select="$day3-friendly"/>
                        <xsl:with-param name="day3-cascade" select="$day3-cascade"/>
                        <xsl:with-param name="day4-friendly" select="$day4-friendly"/>
                        <xsl:with-param name="day4-cascade" select="$day4-cascade"/>
                        <xsl:with-param name="day5-friendly" select="$day5-friendly"/>
                        <xsl:with-param name="day5-cascade" select="$day5-cascade"/>
                        <xsl:with-param name="day6-friendly" select="$day6-friendly"/>
                        <xsl:with-param name="day6-cascade" select="$day6-cascade"/>
                        <xsl:with-param name="day7-friendly" select="$day7-friendly"/>
                        <xsl:with-param name="day7-cascade" select="$day7-cascade"/>
                    </xsl:apply-templates>
                </tbody>
            </table>
        </div>
        <xsl:copy-of select="calling-page/system-page/system-data-structure/post/node()"/>
    </xsl:template>

    <xsl:template match="calling-page/system-page/system-data-structure/hours-listing/hours-block/content/system-data-structure/hours-main">

        <xsl:param name="today-friendly"/>
        <xsl:param name="today-cascade"/>
        <xsl:param name="tomorrow-friendly"/>
        <xsl:param name="tomorrow-cascade"/>
        <xsl:param name="day3-friendly"/>
        <xsl:param name="day3-cascade"/>
        <xsl:param name="day4-friendly"/>
        <xsl:param name="day4-cascade"/>
        <xsl:param name="day5-friendly"/>
        <xsl:param name="day5-cascade"/>
        <xsl:param name="day6-friendly"/>
        <xsl:param name="day6-cascade"/>
        <xsl:param name="day7-friendly"/>
        <xsl:param name="day7-cascade"/>
        
        <tr>
            <th>
                <xsl:choose>
                    <xsl:when test="page/path!='/'">
                        <a href="{page/link}"><xsl:call-template name="title-override"/></a>
                    </xsl:when>
                    <xsl:when test="external!=''">
                        <a href="{external}"><xsl:call-template name="title-override"/></a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="title-override"/>
                    </xsl:otherwise>
                </xsl:choose>
            </th>
            
            <!--<xsl:apply-templates select="default-hours/hour-set" />-->
            
            <td>
                <xsl:call-template name="hour-set">
                    <xsl:with-param name="formatted-date" select="$today-friendly"/>
                    <xsl:with-param name="cascade-date" select="$today-cascade"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="hour-set">
                    <xsl:with-param name="formatted-date" select="$tomorrow-friendly"/>
                    <xsl:with-param name="cascade-date" select="$tomorrow-cascade"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="hour-set">
                    <xsl:with-param name="formatted-date" select="$day3-friendly"/>
                    <xsl:with-param name="cascade-date" select="$day3-cascade"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="hour-set">
                    <xsl:with-param name="formatted-date" select="$day4-friendly"/>
                    <xsl:with-param name="cascade-date" select="$day4-cascade"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="hour-set">
                    <xsl:with-param name="formatted-date" select="$day5-friendly"/>
                    <xsl:with-param name="cascade-date" select="$day5-cascade"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="hour-set">
                    <xsl:with-param name="formatted-date" select="$day6-friendly"/>
                    <xsl:with-param name="cascade-date" select="$day6-cascade"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="hour-set">
                    <xsl:with-param name="formatted-date" select="$day7-friendly"/>
                    <xsl:with-param name="cascade-date" select="$day7-cascade"/>
                </xsl:call-template>
            </td>
        </tr>
        
    </xsl:template>
    
    <xsl:template name="hour-set">
        
        <xsl:param name="formatted-date"/>
        <xsl:param name="cascade-date"/>
        <xsl:variable name="input-date-format" select="date:new('MM-dd-yyyy')"/>
        <xsl:variable name="output-date-format" select="date:new('yyyyMMdd')"/>
        <xsl:variable name="cascade-date-input" select="date:parse($input-date-format, $cascade-date)"/>
        <xsl:variable name="cascade-date-output" select="date:format($output-date-format, $cascade-date-input)"/>
        
        <xsl:variable name="exception-date">
            <xsl:for-each select="exception-hours/hour-set">
                <xsl:if test="start-date != ''">
                    <xsl:variable name="start-date-input" select="date:parse($input-date-format, start-date)"/>
                    <xsl:variable name="end-date-input" select="date:parse($input-date-format, end-date)"/>
                    <xsl:variable name="start-date-output" select="date:format($output-date-format, $start-date-input)"/>
                    <xsl:variable name="end-date-output" select="date:format($output-date-format, $end-date-input)"/>
                                    
                    <xsl:if test="$cascade-date-output &gt;= $start-date-output and $cascade-date-output &lt;= $end-date-output">
                        
                        <xsl:choose>
                            <xsl:when test="closed/value = 'Yes'">CLOSED</xsl:when>
                            <xsl:when test="allhours/value = 'Yes'">Open 24 Hours</xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="hours"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:if>
                </xsl:if>
                
            </xsl:for-each>
        </xsl:variable>
        
        
        <xsl:for-each select="default-hours/hour-set">
            <xsl:if test="contains(day,substring($formatted-date,1,3))">
                
                <xsl:choose>
                    <xsl:when test="$exception-date != ''"><xsl:value-of select="$exception-date"/></xsl:when>
                    <xsl:when test="hours[(contains(../closed,'Yes'))]">CLOSED</xsl:when>
                    <xsl:when test="hours[(contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hours"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:if>
        </xsl:for-each>

    </xsl:template>
    
    <xsl:template name="title-override">
        <xsl:choose>
            <xsl:when test="../../../../override-title!=''">
                <xsl:value-of select="../../../../override-title"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="title"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
