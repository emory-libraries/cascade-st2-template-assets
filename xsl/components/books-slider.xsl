<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes"/>
    <xsl:template match="system-data-structure">
        <xsl:apply-templates select="books-slider"/>
    </xsl:template>
    <xsl:template match="books-slider">
        <xsl:param name="page-type"/>
        <xsl:variable name="url">
            <xsl:value-of select="link/page/link"/>
        </xsl:variable>
        <div>
            <xsl:attribute name="class">books-slider-box
                <xsl:choose>
                    <xsl:when test="$page-type = 'homepage'"/>
                    <xsl:when test="count(ancestor::component/preceding-sibling::component[path != '/']) + count(ancestor::component/following-sibling::component[path != '/']) = 0"> span12</xsl:when>
                    <xsl:otherwise> span6 equal-height</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="heading != ''">
                <h3>
                    <a href="{$url}">
                        <xsl:value-of select="heading"/>
                    </a>
                </h3>
            </xsl:if>
            <ul class="books-slider">
                <xsl:apply-templates select="slider/book/descendant::book"/>
            </ul>
            <xsl:if test="body-content != ''">
                <xsl:if test="body-content != ''">
                    <xsl:copy-of select="body-content/node()"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="link/page/path != '/'">
                <p class="feature-btn">
                    <a href="{$url}">
                        <xsl:attribute name="class"> btn 
                            <xsl:choose>
                                <xsl:when test="link/button-style = 'Primary (Blue)'">btn-primary</xsl:when>
                                <xsl:when test="link/button-style = 'Info (Aqua)'">btn-info</xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="link/button-label"/> » 
                    </a>
                </p>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="book">
        <li>
            <a href="{category/link}#{isbn}">
                <img alt="Book cover of {title}" src="{cover/path}" title="{title}"/>
            </a>
        </li>
    </xsl:template>
</xsl:stylesheet>
