<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="java" version="1.0" xmlns:java="http://xml.apache.org/xslt/java">

    <xsl:output indent="yes"/>

    <xsl:template match="system-index-block">
        <!-- Create new Calendar instance -->
        <xsl:variable name="calendar" select="java:java.util.Calendar.getInstance()"/>
        <!-- Create new SimpleDateFormat instance -->
        <xsl:variable name="dateFormat" select="java:java.text.SimpleDateFormat.getDateTimeInstance()"/>

        <!-- Set the SimpleDateFormat pattern -->
        <xsl:variable name="void" select="java:applyPattern($dateFormat, 'EEE, MMM d')"/>

        <xsl:variable name="day1">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <!-- Increment DAY_OF_YEAR by 1 and record the formatted value of the date -->

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="tomorrow">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <!-- Repeat for the rest of the days... -->
        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day3">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day4">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day5">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day6">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day7">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
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
                    <th>
                        <xsl:value-of select="$tomorrow"/>
                    </th>
                    <th>
                        <xsl:value-of select="$day3"/>
                    </th>
                    <th>
                        <xsl:value-of select="$day4"/>
                    </th>
                    <th>
                        <xsl:value-of select="$day5"/>
                    </th>
                    <th>
                        <xsl:value-of select="$day6"/>
                    </th>
                    <th>
                        <xsl:value-of select="$day7"/>
                    </th>
                </tr>
            </thead>
            <xsl:apply-templates select="calling-page/system-page/system-data-structure/hours-listing/hours-block/content/system-data-structure/hours-main"/>
        </table>
        </div>
        <xsl:copy-of select="calling-page/system-page/system-data-structure/post/node()"/>
    </xsl:template>

    <xsl:template match="calling-page/system-page/system-data-structure/hours-listing/hours-block/content/system-data-structure/hours-main">

        <!-- Create new Calendar instance -->
        <xsl:variable name="calendar" select="java:java.util.Calendar.getInstance()"/>
        <!-- Create new SimpleDateFormat instance -->
        <xsl:variable name="dateFormat" select="java:java.text.SimpleDateFormat.getDateTimeInstance()"/>

        <!-- Set the SimpleDateFormat pattern -->
        <xsl:variable name="void" select="java:applyPattern($dateFormat, 'EEE, MMM d')"/>

        <xsl:variable name="day1">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <!-- Increment DAY_OF_YEAR by 1 and record the formatted value of the date -->

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="tomorrow">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <!-- Repeat for the rest of the days... -->
        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day3">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day4">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day5">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day6">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>

        <xsl:variable name="void" select="java:add($calendar, 6, 1)"/>
        <xsl:variable name="day7">
            <xsl:value-of select="java:format($dateFormat, java:getTime($calendar))"/>
        </xsl:variable>



        <tr>
            <xsl:call-template name="hour-set">
                <xsl:with-param name="day1" select="$day1"/>
                <xsl:with-param name="tomorrow" select="$tomorrow"/>
                <xsl:with-param name="day3" select="$day3"/>
                <xsl:with-param name="day4" select="$day4"/>
                <xsl:with-param name="day5" select="$day5"/>
                <xsl:with-param name="day6" select="$day6"/>
                <xsl:with-param name="day7" select="$day7"/>
            </xsl:call-template>
        </tr>


    </xsl:template>



    <xsl:template name="hour-set">
        
        <xsl:param name="day1"/>
        <xsl:param name="tomorrow"/>
        <xsl:param name="day3"/>
        <xsl:param name="day4"/>
        <xsl:param name="day5"/>
        <xsl:param name="day6"/>
        <xsl:param name="day7"/>
      
        <th>
            <xsl:choose>
                <xsl:when test="page/path!='/'">
                    <a href="{page/link}">
                        <xsl:call-template name="title-override"/>
                    </a>
                </xsl:when>
                <xsl:when test="external!=''">
                    <a href="{external}">
                        <xsl:call-template name="title-override"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="title-override"/>
                </xsl:otherwise>
            </xsl:choose>
        </th>

        <td>
            <xsl:choose>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day1,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day1,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="hour-set/hours[contains(../day,substring($day1,1,3))]"/>
                </xsl:otherwise>
            </xsl:choose>
        </td>

        <td>
            <xsl:choose>
                <xsl:when test="hour-set/hours[(contains(../day,substring($tomorrow,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                <xsl:when test="hour-set/hours[(contains(../day,substring($tomorrow,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="hour-set/hours[contains(../day,substring($tomorrow,1,3))]"/>
                </xsl:otherwise>
            </xsl:choose>
        </td>
        <td>
            <xsl:choose>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day3,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day3,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="hour-set/hours[contains(../day,substring($day3,1,3))]"/>
                </xsl:otherwise>
            </xsl:choose>
        </td>
        <td>
            <xsl:choose>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day4,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day4,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="hour-set/hours[contains(../day,substring($day4,1,3))]"/>
                </xsl:otherwise>
            </xsl:choose>
        </td>
        <td>
            <xsl:choose>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day5,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day5,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="hour-set/hours[contains(../day,substring($day5,1,3))]"/>
                </xsl:otherwise>
            </xsl:choose>
        </td>
        <td>
            <xsl:choose>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day6,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day6,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="hour-set/hours[contains(../day,substring($day6,1,3))]"/>
                </xsl:otherwise>
            </xsl:choose>
        </td>
        <td>
            <xsl:choose>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day7,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day7,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="hour-set/hours[contains(../day,substring($day7,1,3))]"/>
                </xsl:otherwise>
            </xsl:choose>
        </td>
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
