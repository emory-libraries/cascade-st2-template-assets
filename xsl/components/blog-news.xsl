<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="rss">
        <!--<xsl:call-template name="page-title"/>-->
        <xsl:attribute name="class">
            <xsl:text>news</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="descendant::item"/>
    </xsl:template>
    <xsl:template name="page-title">
        <xsl:variable name="link">
            <xsl:value-of select="descendant::link"/>
        </xsl:variable>
        <h1>
            <a href="{$link}">
                <xsl:value-of select="descendant::title"/>
            </a>
        </h1>
    </xsl:template>
    <xsl:template name="title">
        <xsl:variable name="link">
            <xsl:value-of select="descendant::link"/>
        </xsl:variable>
        <xsl:variable name="pubDate">
            <xsl:value-of select="substring(substring(pubDate,1,16),6)"/>
        </xsl:variable>
        <h2>
            <small class="text-muted">
                <xsl:value-of select="$pubDate"/>
            </small>
            <br/>
            <a href="{$link}">
                <xsl:value-of select="descendant::title"/>
            </a>
        </h2>
    </xsl:template>
    <xsl:template match="item">
        <div class="article">
            <xsl:call-template name="title"/>
            <xsl:variable name="content">
                <xsl:choose>
                    <xsl:when test="substring-before(description,'...')!=''">
                        <xsl:value-of select="substring-before(description,'...')"/>
                        <xsl:text>...</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="description"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="encoded">
                <xsl:copy-of select="node()[name(.)='content:encoded']"/>
            </xsl:variable>
            
            <p>
            <xsl:if test="contains($encoded,'img')">
                <xsl:variable name="img-src">
                    <xsl:value-of select="substring-before(substring-after(substring-after($encoded,'&lt;img'),'src='),' ')"/>
                </xsl:variable>
                
                <xsl:if test="$img-src!=''">
                    <xsl:text disable-output-escaping="yes">&lt;img src=</xsl:text><xsl:value-of select="$img-src"/> <xsl:text disable-output-escaping="yes"> class="pull-left"/&gt;</xsl:text>

                </xsl:if>
            </xsl:if>
            
            
                <xsl:value-of disable-output-escaping="yes" select="$content"/>
            </p>
        </div>
    </xsl:template>
</xsl:stylesheet>
