<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:template name="video-gallery">
        <xsl:apply-templates select="//slideshow-block/content/system-data-structure/video-gallery"/>
    </xsl:template>
    
    <xsl:template match="slideshow-block/content/system-data-structure/video-gallery">
        <xsl:apply-templates mode="first" select="video[open-first/value='Yes']"/>
        <div class="video-playlist-container span4">
        <ul class="video-playlist">
            <xsl:apply-templates select="video"/>
        </ul>
        </div>
    </xsl:template>

    <xsl:template match="video" mode="first">
        <xsl:variable name="youtube-id"><xsl:value-of select="concat(substring-before(substring-after(concat(youtube-url,'&amp;'),'?v='),'&amp;'),substring-before(substring-after(concat(youtube-url,'&amp;'),'&amp;v='),'&amp;'))"/></xsl:variable>
        <article class="main-video video span8">            
            <iframe>
                <xsl:attribute name="id">youtube-player1</xsl:attribute>
                <xsl:attribute name="src">http://www.youtube.com/embed/<xsl:value-of select="$youtube-id"/>?version=3&amp;theme=light&amp;color=white&amp;modestbranding=&amp;rel=0&amp;showinfo=1&amp;enablejsapi=1&amp;wmode=transparent</xsl:attribute>
                <xsl:attribute name="allowfullscreen">true</xsl:attribute>
                <xsl:attribute name="frameborder">0</xsl:attribute>
                <xsl:attribute name="height">250</xsl:attribute>
            </iframe>
        </article>
    </xsl:template>

    <xsl:template match="video">
        <li>
            <a>
                <xsl:attribute name="data-player-id">youtube-player1</xsl:attribute>
                <xsl:attribute name="href"><xsl:value-of select="youtube-url"/></xsl:attribute>
                <h3><xsl:value-of select="title"/></h3>
            </a>
        </li>
    </xsl:template>
</xsl:stylesheet>
