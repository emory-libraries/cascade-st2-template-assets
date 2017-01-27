<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="java" version="1.0" xmlns:java="http://xml.apache.org/xslt/java">
    
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/link-set.xsl"/>

    <xsl:output indent="yes"/>
    
    <xsl:template match="system-index-block">
        <xsl:apply-templates select="descendant::exhibition-details"/>
    </xsl:template>
    <xsl:template match="exhibition-details">
    <div class="data-entry">
        <xsl:if test="teaser != ''">
            <p class="lead lead-exhibition"><xsl:copy-of select="teaser/node()"/></p>
        </xsl:if>
        <section class="exhibition-details">
            <xsl:attribute name="class">
                exhibition-details
                <xsl:choose>
                    <xsl:when test="hours-block/path != '/' or links/link/page/link or links/link/external !='' or links/link/file/link"> span7 pull-left</xsl:when>
                    <xsl:otherwise> span12 </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="photo-details/photo/link">
                <figure class="structured-inset pull-right">
                    <img>
                        <xsl:attribute name="src">
                            <xsl:value-of select="photo-details/photo/link"/>
                        </xsl:attribute>
                    </img>
                    <figcaption class="muted"><xsl:value-of select="photo-details/caption"/></figcaption>
                </figure>
            </xsl:if>
            <xsl:if test="main != ''">
                <xsl:copy-of select="main/node()"/>
            </xsl:if>
            <xsl:if test="contact/name != ''">
                <p>For more information, contact <xsl:value-of select="contact/name"/> at <a>
                    <xsl:attribute name="href">mailto: <xsl:value-of select="contact/email"/></xsl:attribute><xsl:value-of select="contact/email"/></a>
                    <xsl:if test="contact/phone!=''"> or <xsl:value-of select="contact/phone"/>
                    </xsl:if>
                </p>
            </xsl:if>
            <xsl:if test="website != 'http://' and website != '' ">
                <p>Exhibition Web Site: <a href="{website}"><xsl:value-of select="website"/></a></p>
            </xsl:if>
        </section>
        <xsl:if test="hours-block/path != '/' or links/link/page/link or links/link/external !='' or links/link/file/link">
            <aside class="exhibition-aside span4">
                <xsl:if test="links/link/page/link or links/link/external !='' or links/link/file/link">
                    <section class="exhibition-related-links">
                        <div class="component quick-links">
                            <h2>Related Links</h2>
                            <xsl:apply-templates select="links"/>
                        </div>
                    </section>     
                </xsl:if>
                <xsl:if test="hours-block/path != '/'">
                    <section class="exhibition-hours">
                        <div class="component">
                            <h2><xsl:value-of select="hours-block/content/system-data-structure/hours-main/title"/></h2>
                            <xsl:apply-templates select="hours-block/content/system-data-structure/hours-main"/>
                        </div>
                    </section>          
                </xsl:if>
            </aside>
        </xsl:if>
        </div>
 </xsl:template>
    
    <xsl:template match="hours-block/content/system-data-structure/hours-main">
        
        <!-- Create new Calendar instance -->
        <xsl:variable name="calendar" select="java:java.util.Calendar.getInstance()"/>
        <!-- Create new SimpleDateFormat instance -->
        <xsl:variable name="dateFormat" select="java:java.text.SimpleDateFormat.getDateTimeInstance()"/>
        
        <!-- Set the SimpleDateFormat pattern -->
        <xsl:variable name="void" select="java:applyPattern($dateFormat, 'EEE, MM/d')"/>
        
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

        <table>
                    <xsl:call-template name="this-week">
                        <xsl:with-param name="day1" select="$day1"/>
                        <xsl:with-param name="tomorrow" select="$tomorrow"/>
                        <xsl:with-param name="day3" select="$day3"/>
                        <xsl:with-param name="day4" select="$day4"/>
                        <xsl:with-param name="day5" select="$day5"/>
                        <xsl:with-param name="day6" select="$day6"/>
                        <xsl:with-param name="day7" select="$day7"/>
                    </xsl:call-template>
      
        
        </table>
    </xsl:template>
    
    <xsl:template name="this-week">
        <xsl:param name="day1"/>
        <xsl:param name="tomorrow"/>
        <xsl:param name="day3"/>
        <xsl:param name="day4"/>
        <xsl:param name="day5"/>
        <xsl:param name="day6"/>
        <xsl:param name="day7"/>
        <tr>
            <td>Today</td>
            <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day1,1,3))) and (contains(../closed,'Yes'))]">
                        CLOSED
                    </xsl:when>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day1,1,3))) and (contains(../allhours,'Yes'))]">
                        Open 24 Hours
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day1,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>
                <xsl:value-of select="$tomorrow"/>
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
        </tr>
        <tr>
            <td>
                <xsl:value-of select="$day3"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day3,1,3))) and (contains(../closed,'Yes'))]">
                        CLOSED
                    </xsl:when>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day3,1,3))) and (contains(../allhours,'Yes'))]">
                        Open 24 Hours
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day3,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>
                <xsl:value-of select="$day4"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day4,1,3))) and (contains(../closed,'Yes'))]">
                        CLOSED
                    </xsl:when>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day4,1,3))) and (contains(../allhours,'Yes'))]">
                        Open 24 Hours
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day4,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>
                <xsl:value-of select="$day5"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day5,1,3))) and (contains(../closed,'Yes'))]">
                        CLOSED
                    </xsl:when>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day5,1,3))) and (contains(../allhours,'Yes'))]">
                        Open 24 Hours
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day5,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>
                <xsl:value-of select="$day6"/>
            </td>
             <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day6,1,3))) and (contains(../closed,'Yes'))]">
                        CLOSED
                    </xsl:when>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day6,1,3))) and (contains(../allhours,'Yes'))]">
                        Open 24 Hours
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day6,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>
                <xsl:value-of select="$day7"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day7,1,3))) and (contains(../closed,'Yes'))]">
                        CLOSED
                    </xsl:when>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day7,1,3))) and (contains(../allhours,'Yes'))]">
                        Open 24 Hours
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day7,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
     </xsl:template>
</xsl:stylesheet>
