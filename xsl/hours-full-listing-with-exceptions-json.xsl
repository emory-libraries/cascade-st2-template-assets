<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="date java" version="1.0" xmlns:date="xalan://java.text.SimpleDateFormat" xmlns:java="http://xml.apache.org/xslt/java">
    <!--<xsl:import href="site://WDG Central v2/_cms/xsl/output/data-entry.xsl"/>-->
    <xsl:import href="site://Library Template/_cms/xsl/format-date.xsl"/>
    <!--<xsl:import href="site://Library Template/_cms/xsl/dd-date-formatter"/>-->
<xsl:output indent="yes"/>
    <xsl:template match="system-index-block">
        <!-- create a data-entry div that gets removed by body XSLT after we parse it -->
        <!--<xsl:call-template name="data-entry-wide"/>-->
        <!--<xsl:copy-of select="calling-page/system-page/system-data-structure/announcement/node()"/>-->
        <xsl:apply-templates select="calling-page/system-page/system-data-structure/hours-block/content/system-data-structure/hours-main"/>
        <!--<xsl:copy-of select="calling-page/system-page/system-data-structure/post/node()"/>-->
    </xsl:template>
    
<xsl:template match="hours-main">
<!--#cascade-skip-->
<xsl:comment>#protect-top
{<xsl:apply-templates select="default-hours | exception-hours"/>}
#protect-top</xsl:comment>
<!--#cascade-skip-->
</xsl:template>
<xsl:template match="exception-hours | default-hours">
    <xsl:variable name="object-name"><xsl:choose><xsl:when test="name() = 'exception-hours'">exceptions</xsl:when><xsl:otherwise>defaultHours</xsl:otherwise></xsl:choose></xsl:variable>
    "<xsl:value-of select="$object-name"/>":{
        <xsl:for-each select="hour-set[allhours != '' or closed != '' or hours != '']"><xsl:call-template name="properties"><xsl:with-param name="set-type" select="$object-name"/></xsl:call-template></xsl:for-each>
    }<xsl:if test="position() != last()">,</xsl:if>
</xsl:template>
    <xsl:template name="properties">
    <xsl:param name="set-type"/>
    <xsl:variable name="hours"><xsl:call-template name="hours"/></xsl:variable>
    <xsl:choose>
    <xsl:when test="$set-type = 'exceptions'">"<xsl:value-of select="position()-1"/>":{
            "startDate":"<xsl:call-template name="dd-date-picker"><xsl:with-param name="date" select="start-date"/><xsl:with-param name="trimcount">-14</xsl:with-param></xsl:call-template>",
            "endDate":"<xsl:call-template name="dd-date-picker"><xsl:with-param name="date" select="end-date"/><xsl:with-param name="trimcount">-14</xsl:with-param></xsl:call-template>",</xsl:when>
    <xsl:otherwise>"<xsl:value-of select="day"/>":{</xsl:otherwise>
    </xsl:choose>
            "hours":"<xsl:value-of select="$hours"/>"
        }<xsl:if test="position() != last()">,</xsl:if>
    </xsl:template>

    <xsl:template name="hours">
        <xsl:choose>
            <xsl:when test="allhours = 'Yes'">24 hours</xsl:when>
            <xsl:when test="closed = 'Yes'">Closed</xsl:when>
            <xsl:otherwise><xsl:value-of select="hours"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="dd-date-picker">
        <xsl:param name="trimcount"/>
        <!-- from calling xsl: either -8 or -14 if year desired -->
        <xsl:param name="date"/>
        <xsl:variable name="month">
            <xsl:value-of select="substring($date,1,2)"/>
        </xsl:variable>
        <xsl:variable name="after-month">
            <xsl:value-of select="substring-after($date,'-')"/>
        </xsl:variable>
        <xsl:variable name="day">
            <xsl:value-of select="substring-before($after-month,'-')"/>
        </xsl:variable>
        <xsl:variable name="year">
            <xsl:value-of select="substring-after($after-month,'-')"/>
        </xsl:variable>
        <xsl:value-of select="$year"/>/<xsl:value-of select="$month"/>/<xsl:value-of select="$day"/>
    </xsl:template>    
</xsl:stylesheet>
