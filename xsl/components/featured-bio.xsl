<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:template match="system-data-structure">
        <xsl:apply-templates select="featured-bio"/>
    </xsl:template>
    
    <xsl:template match="featured-bio">
        <xsl:for-each select="entry">
            <div class="profile boxed-col-inner">
                <xsl:choose>
                    <xsl:when test="manual_entry/photo-bio/name">
                        <img>
                            <xsl:attribute name="src">[system-asset]<xsl:value-of select="manual_entry/photo-bio/link"/>[/system-asset]</xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="page-import/title"/>
                            </xsl:attribute>
                        </img>
                    </xsl:when>
                    <xsl:when test="page-import/content/system-data-structure/thumbnail/photo-bio/link">
                        <img>
                            <xsl:attribute name="src">[system-asset]<xsl:value-of select="page-import/content/system-data-structure/thumbnail/photo-bio/link"/>[/system-asset]</xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="page-import/title"/>
                            </xsl:attribute>
                        </img>
                    </xsl:when>
                    <xsl:when test="page-import/content/system-data-structure/thumbnail/profile/name">
                        <img>
                            <xsl:attribute name="src"><xsl:value-of select="page-import/content/system-data-structure/thumbnail/profile/link"/></xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="page-import/title"/>
                            </xsl:attribute>
                        </img>
                    </xsl:when>
                    <xsl:when test="page-import/content/system-data-structure/thumbnail/thumb-bio/name">
                        <img>
                            <xsl:attribute name="src">[system-asset]<xsl:value-of select="page-import/content/system-data-structure/thumbnail/thumb-bio/link"/>[/system-asset]</xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="page-import/title"/>
                            </xsl:attribute>
                        </img>
                    </xsl:when>
                    <xsl:otherwise>
                        <img>
                            <xsl:attribute name="alt">Currently no photo for <xsl:value-of select="page-import/title"/></xsl:attribute>
                            <xsl:attribute name="src">https://template.emory.edu/assets/images/placeholder/bio-no-photo.png</xsl:attribute>
                        </img>
                    </xsl:otherwise>
                </xsl:choose>
                <h2 class="alt-heading">
                    <xsl:value-of select="heading"/>
                </h2>
                
                <xsl:choose>
                    <xsl:when test="manual_entry/title != ''">
                        <h3>
                            <xsl:value-of select="manual_entry/title"/>
                        </h3>
                    </xsl:when>
                    <xsl:otherwise>
                        <h3>
                            <xsl:value-of select="page-import/title"/>
                        </h3>
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:choose>
                    <xsl:when test="manual_entry/blurb != ''">
                        <xsl:if test="blurb_type = 'Summary'">
                            <p class="profile-summary">
                                <xsl:value-of select="manual_entry/blurb"/>
                            </p>
                        </xsl:if>
                        <xsl:if test="blurb_type = 'Quote'">
                            <div class="testimonial">
                                <blockquote>
                                    <p>
                                        <xsl:value-of select="manual_entry/blurb"/>
                                    </p>
                                </blockquote>
                            </div>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="blurb_type = 'Summary'">
                            <p class="profile-summary">
                                <xsl:value-of select="page-import/summary"/>
                            </p>
                        </xsl:if>
                        <xsl:if test="blurb_type = 'Quote'">
                            <div class="testimonial">
                                <blockquote>
                                    <p>
                                        <xsl:value-of select="page-import/summary"/>
                                    </p>
                                </blockquote>
                            </div>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:if test="link/link-text!='' and (link/external!='' or page-import/name or link/page/name)">
                    <xsl:choose>
                        <xsl:when test="link/page/name and page-import/link = ''">
                            <a class="btn">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="link/page/link"/>
                                </xsl:attribute>
                                <xsl:value-of select="link/link-text"/> »
                            </a>
                        </xsl:when>
                        <xsl:when test="link/external != ''">
                            <a class="btn">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="link/external"/>
                                </xsl:attribute>
                                <xsl:value-of select="link/link-text"/> »
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <a class="btn">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="page-import/link"/>
                                </xsl:attribute>
                                <xsl:value-of select="link/link-text"/> » </a>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </div>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
