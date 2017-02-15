<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- relative to system-data-structure/slider/ -->
    <xsl:import href="/_cms/xsl/patterns.xsl"/>
    <xsl:output indent="yes"/>
    <xsl:template name="home-slider">
        <ul class="utilities" id="home-slider-utilities">
            <xsl:apply-templates select="component"/>
        </ul>
    </xsl:template>
    <xsl:template match="component">
        <li>
            <xsl:choose>
                <xsl:when test="name='hours-component'">
                    <xsl:variable name="path">
                        <xsl:value-of select="content/system-data-structure/hours-page/path"/>
                    </xsl:variable>
                    <xsl:variable name="prefix">
                        <xsl:choose>
                            <xsl:when test="content/system-data-structure/prefix != ''">
                                <xsl:value-of select="content/system-data-structure/prefix"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>http://web.library.emory.edu/librariestemplate</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="url">
                        <xsl:value-of select="$path"/>
                        <xsl:text>.xml</xsl:text>
                    </xsl:variable>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="content/system-data-structure/link/page/path != '/'">
                                    <xsl:value-of select="content/system-data-structure/link/page/link"/>
                                </xsl:when>
                                <xsl:when test="content/system-data-structure/link/external != ''">
                                    <xsl:value-of select="content/system-data-structure/link/external"/>
                                </xsl:when>
                                <xsl:when test="content/system-data-structure/hours-page/link != '/'">
                                    <xsl:value-of select="content/system-data-structure/hours-page/link"/>
                                </xsl:when>
                                <xsl:otherwise>#</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <span>
                            <xsl:attribute name="class">
                                <xsl:text>fa fa-clock-o</xsl:text>
                            </xsl:attribute>
                        </span>
                        <xsl:if test="content/system-data-structure/title != ''">
                            <h3>
                                <xsl:value-of select="content/system-data-structure/title"/>
                            </h3>
                        </xsl:if>
                        <p class="today-hours">
                            <xsl:attribute name="data-url">
                                <xsl:value-of select="$prefix"/>
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="substring($url,2,string-length($url))"/>
                            </xsl:attribute>
                            <xsl:text>View Library Hours</xsl:text>
                        </p>
                    </a>
                </xsl:when>
                <xsl:when test="name='ask-a-librarian'">
                    <a>
                        <xsl:attribute name="class">image</xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="content/system-data-structure/ask-a-librarian/page/link!=''">
                                    <xsl:value-of select="content/system-data-structure/ask-a-librarian/page/link"/>
                                </xsl:when>
                                <xsl:when test="content/system-data-structure/ask-a-librarian/external-url!='/'">
                                    <xsl:value-of select="content/system-data-structure/ask-a-librarian/external-url"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>#</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:if test="not(content/system-data-structure/ask-a-librarian/page/link!='') and content/system-data-structure/ask-a-librarian/external-url!='/'">
                            <xsl:attribute name="target">
                                <xsl:text>_blank</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <img>
                            <xsl:attribute name="alt">
                                <xsl:text>Ask a Librarian Logo</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="src">
                                <xsl:choose>
                                    <xsl:when test="content/system-data-structure/ask-a-librarian/image-override/link != ''">
                                        <xsl:value-of select="content/system-data-structure/ask-a-librarian/image-override/link"/>
                                    </xsl:when>
                                    <xsl:otherwise><xsl:text>http://web.library.emory.edu/images/ask-a-librarian-transparent.png</xsl:text></xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </img>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="content/system-data-structure/link/page/path != '/'">
                                    <xsl:value-of select="content/system-data-structure/link/page/link"/>
                                </xsl:when>
                                <xsl:when test="content/system-data-structure/link/external != ''">
                                    <xsl:value-of select="content/system-data-structure/link/external"/>
                                </xsl:when>
                                <xsl:when test="content/system-data-structure/link/file/path != '/'">
                                    <xsl:value-of select="content/system-data-structure/link/file/link"/>
                                </xsl:when>
                                <xsl:otherwise>#</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:if test="content/system-data-structure/link/file/path != '/'">
                            <xsl:attribute name="ga-on">click</xsl:attribute>
                            <xsl:attribute name="ga-event-category">file</xsl:attribute>
                            <xsl:attribute name="ga-event-action">download</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="content/system-data-structure/icon != ''">
                            <span>
                                <xsl:attribute name="class"><xsl:text>fa </xsl:text><xsl:call-template name="replace-icon"><xsl:with-param name="icon" select="content/system-data-structure/icon"/></xsl:call-template></xsl:attribute>
                            </span>
                        </xsl:if>
                        <xsl:if test="content/system-data-structure/title != ''">
                            <h3>
                                <xsl:value-of select="content/system-data-structure/title"/>
                            </h3>
                        </xsl:if>
                        <xsl:if test="content/system-data-structure/description != ''">
                            <p>
                                <xsl:value-of select="content/system-data-structure/description"/>
                            </p>
                        </xsl:if>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
