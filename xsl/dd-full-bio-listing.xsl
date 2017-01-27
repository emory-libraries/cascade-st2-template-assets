<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/dd-interior-main-content"/>
    <xsl:output indent="yes"/>
    <xsl:template match="system-index-block">
        <div class="overview clearfix">
            <xsl:apply-templates select="//main-content"/>
        </div>
        <div class="table-container">
            <table class="table-striped full-width full-bio-listing">
                <thead>
                    <tr>
                        <th class="name">Full Name</th>
                        <th class="contact-info">Email | Phone</th>
                        <th class="title">Position</th>
                    </tr>
                </thead>
                <xsl:for-each select="calling-page/system-page/system-data-structure/bio/content/system-index-block/system-page[not(name='index') and not(contains(path,'_cms'))]">
                    <xsl:sort order="ascending" select="name"/>
                    <tr itemtype="http://schema.org/Person">
                        <xsl:attribute name="itemscope">true</xsl:attribute>
                        <td class="name">
                            <xsl:attribute name="itemprop">name</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="system-data-structure/url != ' '">
                                    <a href="{system-data-structure/url}" itemprop="url">
                                        <xsl:value-of select="system-data-structure/main-content-bio/first_main"/><xsl:text> </xsl:text><xsl:value-of select="system-data-structure/main-content-bio/last_main"/>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <a href="{link}" itemprop="url">
                                        <xsl:value-of select="system-data-structure/main-content-bio/first_main"/><xsl:text> </xsl:text><xsl:value-of select="system-data-structure/main-content-bio/last_main"/>
                                    </a>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td class="contact-info">
                            <a class="email" itemprop="email">
                                <xsl:attribute name="href">mailto:<xsl:value-of select="system-data-structure/main-content-bio/contact/email"/></xsl:attribute>
                                <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                            </a>
                            <xsl:if test="system-data-structure/main-content-bio/contact/phone!='' and system-data-structure/main-content-bio/contact/phone!='N/A'">
                                <a class="tel" itemprop="telephone">
                                    <xsl:attribute name="href">tel:<xsl:value-of select="translate(system-data-structure/main-content-bio/contact/phone,'.-() ','')"/></xsl:attribute>
                                    <xsl:value-of select="system-data-structure/main-content-bio/contact/phone"/>
                                </a>
                            </xsl:if>
                        </td>
                        <td class="title">
                            <xsl:attribute name="itemprop">jobTitle</xsl:attribute>
                             <em><xsl:value-of select="system-data-structure/main-content-bio/roletitle/role[1]"/></em>
                            <xsl:if test="system-data-structure/main-content-bio/roletitle/org[1]!=''">
                                <xsl:text>, </xsl:text> 
                               <xsl:value-of select="system-data-structure/main-content-bio/roletitle/org[1]"/>
                            </xsl:if>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
        </div>
    </xsl:template>
</xsl:stylesheet>
