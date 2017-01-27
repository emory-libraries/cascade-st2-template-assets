<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- this XSLT reprocesses the standard footer block to remove span tags -->
    <xsl:template match="/">
        <xsl:apply-templates select="//div[@id='footer']"/>
    </xsl:template>
    
    <xsl:template match="div[@id='footer']">
        <xsl:if test="ul[@class='siteLinks']">
            <section class="siteLinks">
                <xsl:for-each select="ul[@class='siteLinks']">
                    <ul>
                        <xsl:for-each select="li">
                            <li>
                                <xsl:if test="@id">
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="@id"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <a><xsl:copy-of select="a/node() | a/@*"/></a>
                                <!-- remove spans by not declaring them -->
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:for-each>
            </section>
        </xsl:if>
        
        <xsl:if test="ul[@class='footLinks']">
            <section class="footLinks">
                <xsl:for-each select="ul[@class='footLinks']">
                    <ul>
                        <xsl:for-each select="li">
                            <li>                              
                                <a><xsl:copy-of select="a/node() | a/@*"/></a>
                                <!-- remove spans by not declaring them -->
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:for-each>
            </section>
        </xsl:if>
        <p>
            <xsl:copy-of select="p/node()"/>
        </p>
    </xsl:template>
</xsl:stylesheet>
