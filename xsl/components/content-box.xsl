<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="system-data-structure">
        <xsl:apply-templates select="content-box"/>
    </xsl:template>
    <xsl:template match="content-box">
        <xsl:param name="page-type"/>
        <xsl:for-each select="entry">
            <xsl:variable name="url">
                <xsl:choose>
                    <xsl:when test="primary-link/page/path != '/'">
                        <xsl:value-of select="primary-link/page/link"/>
                    </xsl:when>
                    <xsl:when test="primary-link/external != ''">
                        <xsl:value-of select="primary-link/external"/>
                    </xsl:when>
                    <xsl:when test="primary-link/file/path != '/'">
                        <xsl:value-of select="primary-link/file/link"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <div class="content-box">
                <xsl:attribute name="class">content-box<xsl:choose><xsl:when test="$page-type = 'homepage'"/><xsl:when test="count(ancestor::component/preceding-sibling::component[path != '/']) + count(ancestor::component/following-sibling::component[path != '/']) = 0"> span12</xsl:when><xsl:otherwise> span6 equal-height</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:choose>
                    <xsl:when test="primary-link/link-application = 'Button' or (primary-link/page/path='/' and primary-link/file/path='/' and primary-link/external='')">
                        <xsl:if test="heading != ''">
                                <h3>
                                    <xsl:value-of select="heading"/>
                                </h3>
                            </xsl:if>
                        <xsl:if test="photo/path != '/'">
                            <p class="feature-img">
                                <img alt="" src="{photo/link}"/>
                            </p>
                            <xsl:if test="caption !=''">
                                <p class="feature-caption">
                                    <xsl:value-of select="caption"/>
                                </p>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="thumbnail/path != '' or body-content != ''">
                                <xsl:if test="thumbnail/path != '/'">
                                    <img alt="" class="pull-left" src="{thumbnail/link}"/>
                                </xsl:if>
                                <xsl:if test="body-content != ''">
                                    <xsl:copy-of select="body-content/node()"/>
                                </xsl:if>
                        </xsl:if>
                        <xsl:if test="primary-link/page/path != '/' or primary-link/file/path != '/' or primary-link/external != ''">
                            <p class="feature-btn">
                                <a href="{$url}">
                                    <xsl:attribute name="class"> btn <xsl:choose>
                                            <xsl:when test="primary-link/button-details/button-style = 'Primary (Blue)'">btn-primary</xsl:when>
                                            <xsl:when test="primary-link/button-details/button-style = 'Info (Aqua)'">btn-info</xsl:when>
                                            <xsl:when test="primary-link/button-details/button-style = 'Success (Green)'">btn-success</xsl:when>
                                            <xsl:when test="primary-link/button-details/button-style = 'Warning (Yellow)'">btn-warning</xsl:when>
                                            <xsl:when test="primary-link/button-details/button-style = 'Danger (Red)'">btn-danger</xsl:when>
                                            <xsl:when test="primary-link/button-details/button-style = 'Inverse (Black)'">btn-inverse</xsl:when>
                                            <xsl:when test="primary-link/button-details/button-style = 'Link (None)'">btn-link</xsl:when>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="primary-link/button-details/button-label"/> » </a>
                            </p>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="primary-link/link-application = 'Heading and Photo'">

                        <xsl:if test="heading != ''">
                            <div class="content-padding">
                                <h3>
                                    <a href="{$url}">
                                        <xsl:value-of select="heading"/>
                                    </a>
                                </h3>
                            </div>
                        </xsl:if>
                        <xsl:if test="photo/path != '/'">
                            <p class="feature-img">
                                <a href="{$url}">
                                    <img alt="" src="{photo/link}"/>
                                </a>
                            </p>
                            <xsl:if test="caption !=''">
                                <p class="feature-caption">
                                    <xsl:value-of select="caption"/>
                                </p>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="thumbnail/path !='/' or body-content != ''">
                            <div class="content-padding">
                                <xsl:if test="thumbnail/path != '/'">
                                    <a href="{$url}">
                                        <img alt="" class="pull-left" src="{thumbnail/link}"/>
                                    </a>
                                </xsl:if>
                                <xsl:if test="body-content !=''">
                                    <xsl:copy-of select="body-content/node()"/>
                                </xsl:if>
                            </div>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </div>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
