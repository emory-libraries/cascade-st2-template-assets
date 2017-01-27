<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xalan="http://xml.apache.org/xalan">
    <!-- written by Emily Porter, Office of Information Technology, Emory University for Emory News Center -->
    <!-- date formatting for page chooser start date as string date-->
    
    <xsl:template name="dd-date">
        <xsl:param name="date"/>
        <xsl:param name="trimcount"/><!-- from calling xsl: either -8 or -14 if year desired -->
        <xsl:variable name="month">
            <xsl:value-of select="substring($date,1,3)"/>
        </xsl:variable>
        <xsl:variable name="rest">
            <xsl:value-of select="substring-after($date,$month)"/>
        </xsl:variable>
        <xsl:variable name="rest_count">
            <xsl:value-of select="string-length($rest)"/>
        </xsl:variable>
        <xsl:variable name="date_trim">
            <xsl:value-of select="number($rest_count - $trimcount)"/>
        </xsl:variable>
        <xsl:variable name="month2">
            <xsl:choose>
                <xsl:when test="$month = 'Apr'">April </xsl:when>
                <xsl:when test="$month = 'May'">May </xsl:when>
                <xsl:when test="$month = 'Jun'">June </xsl:when>
                <xsl:when test="$month = 'Jul'">July </xsl:when>
                <xsl:otherwise><xsl:value-of select="$month"/>. </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$month2"/><xsl:value-of select="substring($rest,1,$date_trim)"/>
    </xsl:template>
    
    <xsl:template name="dd-date-picker">
        <xsl:param name="trimcount"/><!-- from calling xsl: either -8 or -14 if year desired -->
        <xsl:param name="date"/>
        <xsl:variable name="month">
            <xsl:value-of select="substring($date,1,3)"/>
        </xsl:variable>
        <xsl:variable name="rest">
            <xsl:value-of select="substring-after($date,$month)"/>
        </xsl:variable>
        <xsl:variable name="rest_count">
            <xsl:value-of select="string-length($rest)"/>
        </xsl:variable>
        <xsl:variable name="date_trim">
            <xsl:value-of select="number($rest_count - $trimcount)"/>
        </xsl:variable>
        <xsl:variable name="month2">
            <xsl:choose>
                <xsl:when test="$month = 'Apr'">April </xsl:when>
                <xsl:when test="$month = 'May'">May </xsl:when>
                <xsl:when test="$month = 'Jun'">June </xsl:when>
                <xsl:when test="$month = 'Jul'">July </xsl:when>
                <xsl:otherwise><xsl:value-of select="$month"/>. </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$month2"/><xsl:value-of select="substring($rest,1,$date_trim)"/>
    </xsl:template>
    
    <!-- new template for main homepage date formatting: Most Viewed stories -->
    <xsl:template name="dd-date-mostviewed">
        <!-- starting at the first char, pull the first three chars of string -> 3 letter month abbrev. -->
        <xsl:variable name="month">
            <xsl:value-of select="substring(start-date,1,3)"/>
        </xsl:variable>
        <!-- 4 chars after the month - catch the date: can vary quite a bit within start-date string-->
        <xsl:variable name="day">
            <xsl:value-of select="substring(start-date,4,4)"/>
        </xsl:variable>
        <!-- remove leading or trailing whitespace around the date -->
        <xsl:variable name="day2">
            <xsl:value-of select="normalize-space($day)"/> 
        </xsl:variable>
        <!-- remove the comma if that gets pulled in -->
        <xsl:variable name="date_trim">
            <xsl:value-of select="substring-before($day2,',')"/> 
        </xsl:variable>
        <xsl:variable name="month2">
            <xsl:choose>
                <xsl:when test="$month = 'Apr'">April </xsl:when>
                <xsl:when test="$month = 'May'">May </xsl:when>
                <xsl:when test="$month = 'Jun'">June </xsl:when>
                <xsl:when test="$month = 'Jul'">July </xsl:when>
                <xsl:otherwise><xsl:value-of select="$month"/>. </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:value-of select="$month2"/><xsl:text> </xsl:text><xsl:value-of select="$date_trim"/>
        
    </xsl:template>
    
    
    <!-- modified version of data def date picker with flexible date source paramenter; no YYYY used -->
    <xsl:template name="dd-date-noyear">
        <xsl:param name="date_source"/>
        <!-- starting at the first char, pull the first three chars of string -> 3 letter month abbrev. -->
        <xsl:param name="date"/>
        <xsl:variable name="month">
            <xsl:value-of select="substring($date_source,1,3)"/>
        </xsl:variable>
        <!-- 4 chars after the month - catch the date: can vary quite a bit within start-date string-->
        <xsl:variable name="day">
            <xsl:value-of select="substring($date_source,4,4)"/>
        </xsl:variable>
        <!-- remove leading or trailing whitespace around the date -->
        <xsl:variable name="day2">
            <xsl:value-of select="normalize-space($day)"/> 
        </xsl:variable>
        <!-- remove the comma if that gets pulled in -->
        <xsl:variable name="date_trim">
            <xsl:value-of select="substring-before($day2,',')"/> 
        </xsl:variable>
        <xsl:variable name="month2">
            <xsl:choose>
                <xsl:when test="$month = 'Apr'">April </xsl:when>
                <xsl:when test="$month = 'May'">May </xsl:when>
                <xsl:when test="$month = 'Jun'">June </xsl:when>
                <xsl:when test="$month = 'Jul'">July </xsl:when>
                <xsl:otherwise><xsl:value-of select="$month"/>. </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:value-of select="$month2"/><xsl:text> </xsl:text><xsl:value-of select="$date_trim"/>
        
    </xsl:template>
    
</xsl:stylesheet>
