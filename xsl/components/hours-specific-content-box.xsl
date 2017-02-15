<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="date java" version="1.0"
    xmlns:date="xalan://java.text.SimpleDateFormat"
    xmlns:java="http://xml.apache.org/xslt/java">
    <xsl:output indent="yes"/>
    <xsl:template match="hours-main">
        <h3 class="alt-heading"><xsl:value-of select="title"/>Hours</h3>
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
        <table class="hours hours-specific table table-bordered">
            <tbody>
                <tr>
                    <th>Today</th>
                    <td>
                        <xsl:call-template name="hour-set">
                            <xsl:with-param name="formatted-date" select="$today-friendly"/>
                            <xsl:with-param name="cascade-date" select="$today-cascade"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <th>
                        <xsl:value-of select="$tomorrow-friendly"/>
                    </th>
                    <td>
                        <xsl:call-template name="hour-set">
                            <xsl:with-param name="formatted-date" select="$tomorrow-friendly"/>
                            <xsl:with-param name="cascade-date" select="$tomorrow-cascade"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <th>
                        <xsl:value-of select="$day3-friendly"/>
                    </th>
                    <td>
                        <xsl:call-template name="hour-set">
                            <xsl:with-param name="formatted-date" select="$day3-friendly"/>
                            <xsl:with-param name="cascade-date" select="$day3-cascade"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <th>
                        <xsl:value-of select="$day4-friendly"/>
                    </th>
                    <td>
                        <xsl:call-template name="hour-set">
                            <xsl:with-param name="formatted-date" select="$day4-friendly"/>
                            <xsl:with-param name="cascade-date" select="$day4-cascade"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <th>
                        <xsl:value-of select="$day5-friendly"/>
                    </th>
                    <td>
                        <xsl:call-template name="hour-set">
                            <xsl:with-param name="formatted-date" select="$day5-friendly"/>
                            <xsl:with-param name="cascade-date" select="$day5-cascade"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <th>
                        <xsl:value-of select="$day6-friendly"/>
                    </th>
                    <td>
                        <xsl:call-template name="hour-set">
                            <xsl:with-param name="formatted-date" select="$day6-friendly"/>
                            <xsl:with-param name="cascade-date" select="$day6-cascade"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <th>
                        <xsl:value-of select="$day7-friendly"/>
                    </th>
                    <td>
                        <xsl:call-template name="hour-set">
                            <xsl:with-param name="formatted-date" select="$day7-friendly"/>
                            <xsl:with-param name="cascade-date" select="$day7-cascade"/>
                        </xsl:call-template>
                    </td>
                </tr>
            </tbody>
            <xsl:apply-templates select="all-hours"/>
        </table>
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
                    <xsl:variable name="start-date-output" select="date:format($output-date-format, $start-date-input)"/>
                    <xsl:variable name="end-date-value">
                        <xsl:choose>
                            <xsl:when test="end-date != ''">
                                <xsl:value-of select="end-date"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="start-date"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="end-date-input" select="date:parse($input-date-format, $end-date-value)"/>
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
                    <xsl:when test="$exception-date != ''">
                        <xsl:value-of select="$exception-date"/>
                    </xsl:when>
                    <xsl:when test="hours[(contains(../closed,'Yes'))]">CLOSED</xsl:when>
                    <xsl:when test="hours[(contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hours"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="all-hours">
        <xsl:if test="full-listing-page/path != '/' or external != ''">
            <tfoot>
                <tr>
                    <td colspan="2">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="full-listing-page/path != '/'">
                                        <xsl:value-of select="full-listing-page/link"/>
                                    </xsl:when>
                                    <xsl:when test="external != ''">
                                        <xsl:value-of select="external"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:value-of select="link-text"/>
                        </a>
                    </td>
                </tr>
            </tfoot>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
