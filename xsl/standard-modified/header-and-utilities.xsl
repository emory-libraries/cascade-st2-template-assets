<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/standard-modified/utility-nav-rewrap.xsl"/>
    <xsl:variable name="sitetheme"><xsl:value-of select="//theme[1]/site[1]"/></xsl:variable>
    <xsl:variable name="topnavtheme"><xsl:value-of select="//theme[1]/topnav[1]"/></xsl:variable>
    <xsl:variable name="bootstrap">
        <xsl:choose>
            <xsl:when test="//theme[1]/bootstrap-config[1] != ''"><xsl:value-of select="//theme[1]/bootstrap-config[1]"/></xsl:when>
        </xsl:choose>
    </xsl:variable>
        <xsl:variable name="theme"><xsl:value-of select="//theme[1]/topnav[1]"/></xsl:variable>
        <xsl:param name="topnavtheme">
            <xsl:choose>
                <xsl:when test="$theme = 'taupe / dark gray / dark tan'">tp-dkgr-dktn</xsl:when>
                <xsl:when test="$theme = 'light gray / dark gray / dark beige'">ltgr-dkgr-dkbg</xsl:when>
                <xsl:when test="$theme = 'black / light gray / dark taupe'">bk-ltgr-dktp</xsl:when>
                <xsl:when test="$theme = 'dark gray / white / light blue'">dkgr-white-ltbl</xsl:when>
                <xsl:when test="$theme = 'yellow-gold / white / light taupe'">gld-white-lttp</xsl:when>
                <xsl:when test="$theme = 'taupe / tan / beige'">tp-tn-bg</xsl:when>
                <xsl:when test="$theme = 'light gray / light olive / light olive'">ltgr-lto-lto</xsl:when>
                <xsl:when test="$theme = 'raw sienna / burnt sienna / beige'">rs-bts-bg</xsl:when>
                <xsl:when test="$theme = 'gray / light olive / dark tan'">gr-lto-dktn</xsl:when>
                <xsl:when test="$theme = 'turquoise / light olive / light blue'">tuq-lto-ltbl</xsl:when>
                <xsl:otherwise><xsl:value-of select="$theme"/></xsl:otherwise>
            </xsl:choose>
        </xsl:param>
    <xsl:template match="system-index-block">
        <xsl:if test="$bootstrap">
            <bootstrap class="bootstrap"><xsl:value-of select="$bootstrap"/></bootstrap>
        </xsl:if>
        <header id="header" role="banner">
            <xsl:attribute name="class">container <xsl:value-of select="$topnavtheme"/></xsl:attribute>   
            <!-- image map equiv -->
            <h1><xsl:attribute name="class">container<xsl:choose><xsl:when test="system-page/system-data-structure/logo/type = 'Tall - School of Medicine'"> logo-tall-som</xsl:when><xsl:when test="system-page/system-data-structure/logo/type = 'Tall - School of Public Health'"> logo-tall-sph</xsl:when><xsl:when test="system-page/system-data-structure/logo/type = 'Misc Tall Logo'"> logo-tall</xsl:when></xsl:choose><xsl:if test="system-page/system-data-structure/logo/additional-org-title!=''"> additional-org</xsl:if></xsl:attribute>
                <img class="{$sitetheme}" id="logo">
                    <xsl:attribute name="src">
                        <xsl:choose>
                            <xsl:when test="system-page/system-data-structure/logo/image-url!=''">
                                <xsl:value-of select="system-page/system-data-structure/logo/image-url"/>
                            </xsl:when>
                             <xsl:when test="system-page/system-data-structure/logo/image/path!='/'">
                                <xsl:value-of select="system-page/system-data-structure/logo/image/path"/>
                            </xsl:when>
                            <xsl:otherwise>http://template.web.emory.edu/cascade/images/sig_placeholder.png</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <!-- note protocol relative if external -->
                    <xsl:attribute name="alt">
                        <xsl:value-of select="system-page/system-data-structure/site-seo/site-title"/>
                    </xsl:attribute>
                </img>
                <!-- parent logo alt text -->
                <!-- link 1 -->
                <a href="{system-page/system-data-structure/logo/parent-org-link}" id="emory-logo">
                    <xsl:value-of select="system-page/system-data-structure/logo/parent-org-title"/>
                </a>
                <!-- link 2: typically the local homepage but may be an additional org in a 3 part logo -->
                <a id="unit-logo">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="system-page/system-data-structure/logo/additional-org-link!=''">
                                <xsl:value-of select="system-page/system-data-structure/logo/additional-org-link"/>
                            </xsl:when>
                            <xsl:when test="system-page/system-data-structure/logo/homepage/name">
                                <xsl:value-of select="system-page/system-data-structure/logo/homepage/path"/>
                            </xsl:when>
                            <!-- default homepage -->
                            <xsl:otherwise>/index</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="system-page/system-data-structure/logo/additional-org-title!=''">
                            <xsl:value-of select="system-page/system-data-structure/logo/additional-org-title"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="system-page/system-data-structure/logo/site-title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
                <!-- optional link 3: if 3 links, the local site link will be last -->
                <xsl:if test="system-page/system-data-structure/logo/additional-org-title!=''">
                <a id="third-logo">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="system-page/system-data-structure/logo/homepage/name">
                                <xsl:value-of select="system-page/system-data-structure/logo/homepage/path"/>
                            </xsl:when>
                            <!-- default homepage -->
                            <xsl:otherwise>/index</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="system-page/system-data-structure/logo/site-title"/>
                </a>
                </xsl:if>
            </h1>
            
            <!-- responsive view for nav and search -->
            <div>
                <xsl:attribute name="class">toggles container</xsl:attribute>   
                <a class="toggle-nav" href="#"><span aria-hidden="true" class="fa fa-bars"></span> Navigation</a>
                <a class="toggle-search" href="#" title="Search"><span aria-hidden="true" class="fa fa-search"></span> Search</a>
            </div>
            
            <!-- utility nav: imported -->
            <xsl:apply-templates select="system-page/system-data-structure/navigation/utility-nav/global"/>
            
        </header>
    </xsl:template>
</xsl:stylesheet>
