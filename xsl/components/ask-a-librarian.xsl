<?xml version="1.0" encoding="UTF-8"?>
<!-- import this into interior-right-col-index.xsl --><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="system-data-structure/ask-a-librarian">
        <div id="ask-a-librarian">
        <xsl:variable name="url">
            <xsl:choose>
                <xsl:when test="page/link != ''">
                    <xsl:value-of select="page/link"/>
                </xsl:when>
                <xsl:when test="external-url != ''">
                    <xsl:value-of select="external-url"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
            <a href="{$url}">
                <img alt="Need Help? Ask a Librarian.">
                    <xsl:attribute name="src">
                        <xsl:choose>
                            <xsl:when test="image-override/path != '/'"><xsl:value-of select="image-override/link"/></xsl:when>
                            <xsl:otherwise>http://web.library.emory.edu/images/ask-a-librarian-transparent.png</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </img>
            </a>
        </div>
        <xsl:if test="phone-details/number != ''">
            <xsl:apply-templates select="phone-details"/>
        </xsl:if>
        <xsl:if test="email-details/address != ''">
            <xsl:apply-templates select="email-details"/>
        </xsl:if>
        <xsl:if test="code-insert != ''">
            <div class="code">
                <xsl:copy-of select="code-insert/node()"/>
            </div>
        </xsl:if>
                
    </xsl:template>
    
    <xsl:template match="phone-details">
        <dl class="dl-horizontal phone">
            <dt><xsl:value-of select="phone-details/label"/>:</dt>
            <dd><xsl:value-of select="phone-details/number"/></dd>
        </dl>
    </xsl:template>

    <xsl:template match="email-details">
        <dl class="dl-horizontal email">
            <dt><xsl:value-of select="email-details/label"/>:</dt>
            <dd><xsl:value-of select="email-details/address"/></dd>
        </dl>
    </xsl:template>

</xsl:stylesheet>
