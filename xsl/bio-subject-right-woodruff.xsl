<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" method="xml"/>
    <xsl:template match="system-index-block">
        <xsl:if test="calling-page/system-page/system-data-structure/main-content-bio/subjects/subject-dropdown!=' '">
            <h2 class="boxed-heading">Areas of Expertise</h2>
            <div class="boxed-col-inner">
                <ul class="quick-links">
                    <xsl:apply-templates select="calling-page/system-page/system-data-structure/main-content-bio/subjects/subject-dropdown"/>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="subject-dropdown">
        <li>
            <a>
                <xsl:attribute name="href"><xsl:text>http://web.library.emory.edu/research-learning/subject-librarians/index.html?subject=</xsl:text><xsl:value-of select="translate(.,' ', '-')"/></xsl:attribute>
                <xsl:value-of select="."/>
            </a>
        </li>
    </xsl:template>
</xsl:stylesheet>
