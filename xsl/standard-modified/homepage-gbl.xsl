<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/components/hero-search-box.xsl"/>

    <xsl:template name="goizueta-homepage">
        <xsl:apply-templates select="top-row"/>
    </xsl:template>
    <xsl:template match="top-row">
        
        <div>
            <xsl:attribute name="class">gbl hero span12</xsl:attribute>
            <div class="header span12">
                <h1 class="subtitle">
                    <xsl:value-of select="subtitle"/>
                </h1>
            </div>
            <xsl:if test="background/path != '/'">
                <div class="background">
                    <img>
                        <xsl:attribute name="src"><xsl:value-of select="background/link"/></xsl:attribute>
                        <xsl:attribute name="alt"/>
                    </img>
                </div>
            </xsl:if>
            <div class="section">
                <xsl:apply-templates select="intro-boxes"/>
                <xsl:apply-templates select="power-user-links"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="intro-boxes">
        <div class="intro-boxes span8">
            <ul class="equal-height-row" id="intro-boxes">
                <xsl:apply-templates select="intro-box"/>
            </ul>
        </div>
    </xsl:template>

    <xsl:template match="intro-box">
        <li class="intro-box equal-height span4">
            <h3>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="link/page/path"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:value-of select="heading"/>
                    </xsl:attribute>
                    <xsl:value-of select="heading"/>
                </a>
            </h3>
            <p class="summary">
                <xsl:value-of select="summary"/>
            </p>
        </li>
    </xsl:template>

    <xsl:template match="power-user-links">
        <div class="aside span4" id="power-user-links">
            <xsl:apply-templates select="heading"/>
            <xsl:apply-templates mode="homepage" select="descendant::search-box"/>
            <xsl:apply-templates select="links"/>
        </div>
    </xsl:template>
    <xsl:template match="heading">
        <h2>
            <xsl:value-of select="text()"/>
        </h2>
    </xsl:template>

    <xsl:template match="search-box" mode="homepage">
        <xsl:param name="placement"/>
        <xsl:param name="background"/>
        <xsl:param name="library"/>

        <xsl:param name="type">
            <xsl:if test="content/system-data-structure/search-option[default/value='Yes']/name = 'databases'">database</xsl:if>
        </xsl:param>

        <xsl:param name="num">4</xsl:param>

        <xsl:text disable-output-escaping="yes">
    &lt;!--Search Form --&gt;
        </xsl:text>
        <form class="primary-form" id="form-library-search" method="get" name="searchForm">
            <xsl:attribute name="action">[system-asset]<xsl:value-of select="content/system-data-structure/search-page/page/path"/>[/system-asset]</xsl:attribute>

            <input name="system" type="hidden">
                <xsl:attribute name="id">hero-search-<xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/name"/></xsl:attribute>
                <xsl:attribute name="value"><xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/name"/></xsl:attribute>
                <xsl:if test="content/system-data-structure/search-option[default/value='Yes']/form-action/page/content/system-data-structure/results-options/search-options/use-autosuggest/value = 'Yes'">
                    <xsl:attribute name="data-url">
                        <!--<xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/form-action/page/path"/>.php-->
                        <xsl:text>/_api/v1/gsa/results/?site=</xsl:text>
                        <xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/form-action/page/content/system-data-structure/data/gsa-collection"/>
                        <xsl:text>&amp;num=</xsl:text>
                        <xsl:value-of select="$num"/>
                        <xsl:text>&amp;numgm=0&amp;filter=0&amp;</xsl:text>
                        <xsl:if test="$type = 'database'">
                            <xsl:text>getfields=*&amp;requiredfields=content_type:</xsl:text><xsl:value-of select="$type"/><xsl:text>.</xsl:text>
                        </xsl:if>
                        <xsl:text>-exclude_from:</xsl:text>
                        <xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/form-action/page/content/system-data-structure/data/gsa-collection"/>
                        <xsl:text>&amp;partialfields=include_in:</xsl:text>
                        <xsl:value-of select="substring-after(content/system-data-structure/search-option[default/value='Yes']/form-action/page/content/system-data-structure/data/gsa-collection,'library-databases')"/>
                    </xsl:attribute>
                </xsl:if>
            </input>

            <div class="input-append span12">
                <label>
                    <input autocomplete="off" id="library_q" name="library_q" type="search">
                        <xsl:attribute name="class">input span10<xsl:if test="content/system-data-structure/search-option[default/value='Yes']/form-action/page/content/system-data-structure/results-options/search-options/use-autosuggest/value = 'Yes'"><xsl:text> </xsl:text>ajax_typeahead</xsl:if></xsl:attribute>
                        <xsl:attribute name="placeholder">
                            <xsl:choose>
                                <xsl:when test="content/system-data-structure/search-page/placeholder != ''">
                                    <xsl:value-of select="content/system-data-structure/search-page/placeholder"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/placeholder"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </input>
                </label>
                <button class="btn span2" type="submit">
                    <strong class="label">Search</strong>
                    <span class="icon-search"></span>
                </button>
            </div>
            <!--               <fieldset class="search-scope span10">
                    <xsl:apply-templates mode="scope" select="content/system-data-structure/search-option"/>
                </fieldset>
                <footer>
                    <xsl:choose>
                        <xsl:when test="$background = 'true'">
                            <h4>
                                <a class="alternate" href="#">What does 
                                    <span class="search-indicator">this search?</span>
                                </a>
                            </h4>
                        </xsl:when>
                        <xsl:otherwise>
                            <h4>
                                <a href="#">What does 
                                    <span class="search-indicator">this search?</span>
                                </a>
                            </h4>
                        </xsl:otherwise>
                    </xsl:choose>
                    <ul class="options">
                        <xsl:apply-templates mode="explanation" select="content/system-data-structure/search-option"/>
                    </ul>
                </footer>-->
        </form>

    </xsl:template>
    <xsl:template match="search-box" mode="database-page">
        <xsl:param name="placement"/>
        <xsl:param name="background"/>
        <xsl:param name="library"/>

        <xsl:param name="type">
            <xsl:if test="content/system-data-structure/search-option[default/value='Yes']/name = 'databases'">database</xsl:if>
        </xsl:param>

        <xsl:param name="num">4</xsl:param>

        <xsl:text disable-output-escaping="yes">
    &lt;!--Search Form --&gt;
        </xsl:text>
        <div class="big-search database-search database-page">

            <form class="primary-form clearfix" id="form-library-search" method="get" name="searchForm">
                <xsl:attribute name="action">[system-asset]<xsl:value-of select="content/system-data-structure/search-page/page/path"/>[/system-asset]</xsl:attribute>
                <input name="system" type="hidden">
                    <xsl:attribute name="id">hero-search-<xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/name"/></xsl:attribute>
                    <xsl:attribute name="value"><xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/name"/></xsl:attribute>
                    <xsl:if test="content/system-data-structure/search-option[default/value='Yes']/form-action/page/content/system-data-structure/results-options/search-options/use-autosuggest/value = 'Yes'">
                        <xsl:attribute name="data-url">
                            <!--<xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/form-action/page/path"/>.php-->
                            <xsl:text>/_api/v1/gsa/results/?site=</xsl:text>
                            <xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/form-action/page/content/system-data-structure/data/gsa-collection"/>
                            <xsl:text>&amp;num=</xsl:text>
                            <xsl:value-of select="$num"/>
                            <xsl:text>&amp;numgm=0&amp;filter=0&amp;</xsl:text>
                            <xsl:if test="$type = 'database'">
                                <xsl:text>getfields=*&amp;requiredfields=content_type:</xsl:text><xsl:value-of select="$type"/><xsl:text>.</xsl:text>
                            </xsl:if>
                            <xsl:text>-exclude_from:</xsl:text>
                            <xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/form-action/page/content/system-data-structure/data/gsa-collection"/>
                            <xsl:text>&amp;partialfields=include_in:</xsl:text>
                            <xsl:value-of select="substring-after(content/system-data-structure/search-option[default/value='Yes']/form-action/page/content/system-data-structure/data/gsa-collection,'library-databases')"/>
                        </xsl:attribute>
                    </xsl:if>
                </input>
                <div class="input-append span12">
                    <input autocomplete="off" id="library_q" name="library_q" type="search">
                        <xsl:attribute name="class">input span10<xsl:if test="content/system-data-structure/search-option[default/value='Yes']/form-action/page/content/system-data-structure/results-options/search-options/use-autosuggest/value = 'Yes'"><xsl:text> </xsl:text>ajax_typeahead</xsl:if></xsl:attribute>
                        <xsl:attribute name="placeholder">
                            <xsl:choose>
                                <xsl:when test="content/system-data-structure/search-page/placeholder != ''">
                                    <xsl:value-of select="content/system-data-structure/search-page/placeholder"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="content/system-data-structure/search-option[default/value='Yes']/placeholder"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </input>
                    <button class="btn btn-search" type="submit">
                        <strong class="label">Search</strong>
                        <span class="icon-search"></span>
                    </button>
                </div>
            <!--               <fieldset class="search-scope span10">
                    <xsl:apply-templates mode="scope" select="content/system-data-structure/search-option"/>
                </fieldset>
                <footer>
                    <xsl:choose>
                        <xsl:when test="$background = 'true'">
                            <h4>
                                <a class="alternate" href="#">What does 
                                    <span class="search-indicator">this search?</span>
                                </a>
                            </h4>
                        </xsl:when>
                        <xsl:otherwise>
                            <h4>
                                <a href="#">What does 
                                    <span class="search-indicator">this search?</span>
                                </a>
                            </h4>
                        </xsl:otherwise>
                    </xsl:choose>
                    <ul class="options">
                        <xsl:apply-templates mode="explanation" select="content/system-data-structure/search-option"/>
                    </ul>
                </footer>-->
        </form>
        </div>
    </xsl:template>
    <xsl:template match="links">
        <div class="links" id="quick-access-links">
            <xsl:apply-templates select="link"/>
        </div>
    </xsl:template>

    <xsl:template match="link">
        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="internal-path/path!='/'">
                    <xsl:value-of select="internal-path/path"/>
                </xsl:when>
                <xsl:when test="external-link!=''">
                    <xsl:value-of select="external-link"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>#</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="$href"/>
            </xsl:attribute>
            <span>
                <xsl:attribute name="class">
                    <xsl:text>fa fa-</xsl:text><xsl:value-of select="icon"/>
                </xsl:attribute>
            </span>
            <xsl:value-of select="link-label"/>
        </a>
    </xsl:template>
</xsl:stylesheet>
