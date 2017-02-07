<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- relative to system-data-structure/toprow/search/ -->
    <xsl:output indent="yes"/>

    <xsl:template name="featured-links-home">
        <xsl:param name="placement"/>
        <xsl:param name="library"/>
        <xsl:param name="span"/>
        <div>
            <xsl:attribute name="class">featured-links<xsl:text> </xsl:text><xsl:value-of select="$library"/><xsl:text> </xsl:text><xsl:value-of select="$span"/></xsl:attribute>
            <xsl:apply-templates select="link-box">
                <xsl:with-param name="placement" select="$placement"/>
                <xsl:with-param name="library" select="$library"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="link-box">
        <h2><xsl:value-of select="heading"/></h2>
        <ul>
            <xsl:apply-templates select="featured-link"/>
        </ul>
    </xsl:template>
    
    <xsl:template match="featured-link">
        <li>
            <xsl:choose>
                <xsl:when test="page/path != '/' or external != '' or file/path != '/'">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="page/path != '/'">
                                    <xsl:value-of select="page/path"/>
                                </xsl:when>
                                <xsl:when test="external != ''">
                                    <xsl:value-of select="external"/>
                                </xsl:when>
                                <xsl:when test="file/path != '/'">
                                    <xsl:value-of select="file/path"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:if test="icon != '---'">
                            <span>
                                <xsl:attribute name="class">
                                    <xsl:text>fa fa-</xsl:text><xsl:value-of select="icon"/>
                                </xsl:attribute>
                            </span><xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="label"/>
                    </a>
                </xsl:when>
            </xsl:choose>
        </li>
    </xsl:template>

</xsl:stylesheet>
