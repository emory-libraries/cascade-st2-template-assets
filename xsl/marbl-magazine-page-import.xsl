<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="java" version="1.0" xmlns:java="http://xml.apache.org/xslt/java">
    
    <xsl:import href="site://Standard Template v2/_cms/xsl/components/link-set.xsl"/>


     <xsl:template match="system-index-block">
        <!-- create a data-entry div that gets removed by body XSLT after we parse it -->
        

        
        <h3>
            <xsl:value-of select="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/date-range"/>
        </h3>
        <img>
            <xsl:attribute name="src">
                <xsl:value-of select="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/photo-bio/link"/>
            </xsl:attribute>
        </img>
        
        
        
        <xsl:copy-of select="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/main-bio/node()"/>
        <xsl:if test="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/website!=''">
            <h4>View Exhibition at <a href="{calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/website}">
                <xsl:value-of select="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/website"/>
            </a></h4>
        </xsl:if>
        <p>For more information, contact <xsl:value-of select="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/contact/name"/> at <a>
                <xsl:attribute name="href">mailto: <xsl:value-of select="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/contact/email"/></xsl:attribute><xsl:value-of select="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/contact/email"/></a>
            <xsl:if test="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/contact/phone!=''"> or
                <xsl:value-of select="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/contact/phone"/>
            </xsl:if>
        </p>
        <h2>Related Links</h2>
        <div class="component quick-links">
            <xsl:apply-templates select="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/links"/>
        </div>
  
        <xsl:apply-templates select="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/hours-block/content/system-data-structure/hours-main"/>
           
              
    </xsl:template>
    
    <xsl:template match="calling-page/system-page/system-data-structure/exhibition/content/system-data-structure/hours-block/content/system-data-structure/hours-main">
        
        <!-- Create new Calendar instance -->
        <xsl:variable name="calendar" select="java:java.util.Calendar.getInstance()"/>
        <!-- Create new SimpleDateFormat instance -->
        <xsl:variable name="dateFormat" select="java:java.text.SimpleDateFormat.getDateTimeInstance()"/>
        
        <!-- Set the SimpleDateFormat pattern -->
        <xsl:variable name="void" select="java:applyPattern($dateFormat, 'EEE, d MMM')"/>
        
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
<tr><th colspan="2">Hours This Week</th></tr>
                <tr>
                    <xsl:call-template name="this-week">
                        <xsl:with-param name="day1" select="$day1"/>
                        <xsl:with-param name="tomorrow" select="$tomorrow"/>
                        <xsl:with-param name="day3" select="$day3"/>
                        <xsl:with-param name="day4" select="$day4"/>
                        <xsl:with-param name="day5" select="$day5"/>
                        <xsl:with-param name="day6" select="$day6"/>
                        <xsl:with-param name="day7" select="$day7"/>
                    </xsl:call-template>
                </tr>
      
        
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
        
        <tr><td>Today</td> <td>
            <xsl:choose>
                <xsl:when test="hour-set/hours[(contains(../day,substring($day1,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                
                <xsl:when test="hour-set/hours[(contains(../day,substring($day1,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="hour-set/hours[contains(../day,substring($day1,1,3))]"/>
                </xsl:otherwise>
            </xsl:choose></td>
        </tr>
        <tr><td>
            <xsl:value-of select="$tomorrow"/>
        </td>
        <td>
            <xsl:choose>
                <xsl:when test="hour-set/hours[(contains(../day,substring($tomorrow,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                
                <xsl:when test="hour-set/hours[(contains(../day,substring($tomorrow,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="hour-set/hours[contains(../day,substring($tomorrow,1,3))]"/>
                </xsl:otherwise>
            </xsl:choose></td>
        </tr>
        <tr><td>
            <xsl:value-of select="$day3"/></td>
            <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day3,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                    
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day3,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day3,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose></td>
            
        </tr>
        <tr><td>
            <xsl:value-of select="$day4"/></td>
            
            <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day4,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                    
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day4,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day4,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose></td>
            
        </tr>
        <tr><td>
            <xsl:value-of select="$day5"/></td>
            <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day5,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                    
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day5,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day5,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose></td>
            
        </tr>
        <tr><td>
            <xsl:value-of select="$day6"/></td> <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day6,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                    
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day6,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day6,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose></td>
            
        </tr>
        <tr><td>
            <xsl:value-of select="$day7"/></td>
            
            <td>
                <xsl:choose>
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day7,1,3))) and (contains(../closed,'Yes'))]">CLOSED</xsl:when>
                    
                    <xsl:when test="hour-set/hours[(contains(../day,substring($day7,1,3))) and (contains(../allhours,'Yes'))]">Open 24 Hours</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="hour-set/hours[contains(../day,substring($day7,1,3))]"/>
                    </xsl:otherwise>
                </xsl:choose></td>
            
        </tr>
        
 
    </xsl:template>
    
    
</xsl:stylesheet>
