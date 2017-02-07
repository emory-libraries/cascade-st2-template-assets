<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- relative to system-data-structure/toprow/search/ -->
    <xsl:output indent="yes"/>

    <xsl:template name="search-form-home">
        <xsl:param name="placement"/>
        <xsl:param name="background"/>
        <xsl:param name="library"/>
        <xsl:param name="span"/>
        <section>
            <xsl:attribute name="class">cta-box library-search <xsl:value-of select="$library"/>-search <xsl:value-of select="$span"/></xsl:attribute>
            <!-- output heading if it exists -->
            <xsl:variable name="search-heading">
                <xsl:choose>
                    <xsl:when test="search/heading = ''">Search this site</xsl:when>
                    <xsl:otherwise><xsl:value-of select="search/heading"/></xsl:otherwise>
                </xsl:choose>    
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$placement = 'toprow' and $background != 'true'">
                    <h1><xsl:value-of select="$search-heading"/></h1>
                </xsl:when>
                <xsl:when test="$placement = 'toprow' and $background = 'true'">
                    <h1 class="alternate"><xsl:value-of select="$search-heading"/></h1>
                </xsl:when>
                <xsl:when test="$placement = 'intro-row'">
                    <h2><xsl:value-of select="$search-heading"/></h2>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="search/datadef-search">
                <xsl:with-param name="placement" select="$placement"/>
                <xsl:with-param name="background" select="$background"/>
                <xsl:with-param name="library" select="$library"/>
            </xsl:apply-templates>
        </section>
    </xsl:template>

    <xsl:template match="search/datadef-search">
        <xsl:param name="placement"/>
        <xsl:param name="background"/>
        <xsl:param name="library"/>
        <form class="primary-form" id="form-library-search" method="get" name="searchForm">
            <xsl:attribute name="action">[system-asset]<xsl:value-of select="content/system-data-structure/search-page/page/path"/>[/system-asset]</xsl:attribute>
            <div class="input-append span12">
                <label>
                    <input autocomplete="off" class="input span10" id="library_q" name="library_q" type="search">
                        <xsl:attribute name="placeholder">
                            <!--<xsl:choose>
                                <xsl:when test="content/system-data-structure/search-page/placeholder != ''">
                                    <xsl:value-of select="content/system-data-structure/search-page/placeholder"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="content/system-data-structure/search-option[default='Yes']/placeholder"/>
                                </xsl:otherwise>
                            </xsl:choose>-->
                            <xsl:value-of select="content/system-data-structure/search-option[default='Yes']/placeholder"/>
                        </xsl:attribute>
                    </input>
                </label>
                <button class="btn span2" type="submit">
                    <strong class="label">Search</strong>
                    <span class="fa fa-search"></span>
                </button>
            </div>
            <fieldset class="search-scope span10">
                <xsl:apply-templates mode="scope" select="content/system-data-structure/search-option"/>
            </fieldset>
            <footer>
                <xsl:choose>
                    <xsl:when test="$background = 'true'">
                        <h4><a class="alternate" href="#">What does <span class="search-indicator">this search?</span></a></h4>
                    </xsl:when>
                    <xsl:otherwise>
                        <h4><a href="#">What does <span class="search-indicator">this search?</span></a></h4>
                    </xsl:otherwise>
                </xsl:choose>
                <ul class="options">
                    <xsl:apply-templates mode="explanation" select="content/system-data-structure/search-option"/>                    
                </ul>
            </footer>
        </form>
    </xsl:template>

    <xsl:template match="content/system-data-structure/search-option" mode="scope">
        <label>
            <xsl:if test="default = 'Yes'">
                <xsl:attribute name="class">checked</xsl:attribute>
            </xsl:if>
            <input name="system" type="radio">
                <xsl:if test="default = 'Yes'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
                <xsl:attribute name="id">hero-search-<xsl:value-of select="name"/></xsl:attribute>
                <xsl:attribute name="value">
                    <xsl:value-of select="name"/>
                </xsl:attribute>
                <xsl:attribute name="data-search-placeholder">
                    <xsl:value-of select="placeholder"/>
                </xsl:attribute>
            </input>
            <xsl:value-of select="dropdown-label"/>
        </label>
    </xsl:template>

    <xsl:template match="content/system-data-structure/search-option" mode="explanation">
        <li>
            <xsl:attribute name="class"><xsl:value-of select="name"/><xsl:if test="default = 'Yes'"> active</xsl:if></xsl:attribute>
            <xsl:copy-of select="what-does-this-search/node()"/>
        </li>
    </xsl:template>

</xsl:stylesheet>
