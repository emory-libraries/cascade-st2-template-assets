<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    STATUS 
    - finish alternate searchbox code
    - additional util nav bucket
    --><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/_cms/xsl/search-form-header.xsl"/>
    <xsl:variable name="search-type">
        <xsl:value-of select="/system-index-block/system-page/system-data-structure/site-seo/search-type"/>
    </xsl:variable>
    <xsl:variable name="gsa-collection">
        <xsl:value-of select="/system-index-block/system-page/system-data-structure/site-seo/search-collection"/>
    </xsl:variable>
    <xsl:variable name="gsa-frontend">
        <!-- option for results landing page template -->
        <xsl:choose>
            <xsl:when test="/system-index-block/system-page/system-data-structure/site-seo/gsa-frontend!=''">
                <xsl:value-of select="/system-index-block/system-page/system-data-structure/site-seo/gsa-frontend"/>
            </xsl:when>
            <xsl:otherwise>default_frontend</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="gsa-proxystylesheet">
        <!-- option for results landing page template -->
        <xsl:choose>
            <xsl:when test="/system-index-block/system-page/system-data-structure/site-seo/gsa-proxystylesheet!=''">
                <xsl:value-of select="/system-index-block/system-page/system-data-structure/site-seo/gsa-proxystylesheet"/>
            </xsl:when>
            <xsl:otherwise>homepage</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- utility nav -->
    <xsl:template match="global">
        <nav id="emory-wide">
            <a class="skip" href="#main-content">Skip to Content</a>
            <ul>
                <!-- central block content first -->
                <xsl:apply-templates select="content/div[@id='utilityContent']/ul"/>
                <!-- optional local tab -->
                
            </ul>
        </nav>
    </xsl:template>

    <xsl:template match="ul">
        <!-- filter out the last li with #search div -->
        <xsl:apply-templates select="li[not(descendant::div[@id='search'])]"/>
        <xsl:if test="/system-index-block/system-page/system-data-structure/navigation/utility-nav/additional='Yes'">
            <xsl:call-template name="additional"/>
        </xsl:if>
        <!-- searchbox -->
        <xsl:choose>
            <xsl:when test="$search-type='Standard'">
                <xsl:call-template name="searchbox"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- alternate code block -->
                <li class="top search">
                    <xsl:choose>
                        <xsl:when test="/system-index-block/system-page/system-data-structure/site-seo/searchbox-alt/content != ''">
                            <xsl:copy-of select="/system-index-block/system-page/system-data-structure/site-seo/searchbox-alt/content/node()"/>
                        </xsl:when>
                        <xsl:when test="/system-index-block/system-page/system-data-structure/site-seo/datadef-search != ''">
                            <xsl:call-template name="search-form-header"/>
                        </xsl:when>
                    </xsl:choose>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="li">
        <li>
            <xsl:attribute name="class">top</xsl:attribute>
            <a>
                <xsl:value-of select="a[@class='utilLink']"/>
            </a>
            <div class="nav-box">
                <xsl:copy-of select="div/node()[not(descendant::div[@id='search'])]"/>
            </div>
        </li>
    </xsl:template>

    <xsl:template name="additional">
        <li>
            <xsl:attribute name="class">top</xsl:attribute>
            <a>
                <xsl:value-of select="/system-index-block/system-page/system-data-structure/navigation/utility-nav/heading"/>
            </a>
            <div class="nav-box">
                <!-- multiples -->
                <xsl:for-each select="/system-index-block/system-page/system-data-structure/navigation/utility-nav/list">
                    <div>
                        <xsl:attribute name="class">col col<xsl:value-of select="position()"/></xsl:attribute>
                        <h4>
                            <xsl:value-of select="heading-inner"/>
                        </h4>
                        <ul>
                                                    <xsl:apply-templates mode="additional" select="entry"/>
                        </ul>
                    </div>
                </xsl:for-each>
            </div>

        </li>

    </xsl:template>


        <xsl:template match="entry" mode="additional">
            <li>
          <a>
              <xsl:attribute name="href">
                  <xsl:choose>
                      <xsl:when test="page/name">
                          <xsl:value-of select="page/path"/>
                      </xsl:when>
                      <xsl:otherwise>
                          <xsl:value-of select="external"/>
                      </xsl:otherwise>
                  </xsl:choose>
              </xsl:attribute>
              <xsl:choose>
                  <xsl:when test="text!=''">
                      <xsl:value-of select="text"/>
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:value-of select="page/title"/>
                  </xsl:otherwise>
              </xsl:choose>
          </a>
      </li>
        </xsl:template>

    <xsl:template name="searchbox">
        <li class="top search">
            <div class="nav-box search">
                <form action="http://search.emory.edu/search" id="form-search" method="get" name="searchForm">
                    <input name="searchString" type="hidden"/>
                    <input name="numgm" type="hidden" value="5"/>
                    <input name="client" type="hidden" value="{$gsa-frontend}"/>
                    <!-- frontend in query -->
                    <!-- variable - same -->
                    <input name="output" type="hidden" value="xml_no_dtd"/>
                    <input name="proxystylesheet" type="hidden" value="{$gsa-proxystylesheet}"/>
                    <!-- proxystylesheet in query -->
                    <!-- variable - same -->
                    <div class="input-append">
                        <label><input autocomplete="off" class="input-medium" id="q" maxlength="2048" name="q" placeholder="Search" type="search"/></label>
                        <button class="btn" type="submit">
                            <strong class="label">Search</strong>
                            <span aria-hidden="true" class="fa fa-search"></span>
                        </button>
                    </div>
                    <fieldset class="search-scope" style="display: none;">
                        <label class="checked">
                            <input checked="checked" id="search-site" name="site" type="radio" value="{$gsa-collection}"/> This Site</label>
                        <!-- adjust for GSA -->
                        <label>
                            <input id="search-emory" name="site" type="radio" value="default_collection"/> All Emory Sites</label>
                        <label>
                            <input id="search-directory" name="site" type="radio" value="directory"/> People</label>
                    </fieldset>
                </form>
            </div>
        </li>

    </xsl:template>

</xsl:stylesheet>
