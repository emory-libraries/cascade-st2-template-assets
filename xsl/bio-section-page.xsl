<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <div>
            <xsl:attribute name="class">data-entry <xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'"> wide</xsl:if>
            </xsl:attribute>
            <!-- check for summary. use if present, and use title by itself if not -->
            <xsl:choose>
                <xsl:when test="system-index-block/system-page[name='index']/summary != ''">
                    <xsl:apply-templates mode="summary" select="system-index-block/system-page[name='index']">
                        <xsl:with-param name="title-alignment" select="system-index-block/system-page[name='index']/system-data-structure/main-content/title-alignment"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="system-index-block/system-page[name='index']/system-data-structure/flex-group/wysiwyg != ''">
                    <xsl:apply-templates mode="flex-box" select="system-index-block/system-page[name='index']">
                        <xsl:with-param name="title-alignment" select="system-index-block/system-page[name='index']/system-data-structure/main-content/title-alignment"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <h1>
                        <xsl:value-of select="system-index-block/system-page[name='index']/title"/>
                    </h1>
                </xsl:otherwise>
            </xsl:choose>
            <!-- create hierarchical layout for bios -->
            <xsl:if test="system-index-block/system-page[name='index']/system-data-structure/main-content/layout = 'Hierarchical'">
                <xsl:apply-templates mode="people-featured" select="system-index-block[descendant::system-page[system-data-structure/main-content-bio/leadership/value='Yes']]"/>
                <xsl:apply-templates mode="people" select="system-index-block[descendant::system-page[system-data-structure/main-content-bio/leadership = '']]"/>
            </xsl:if>
            <!-- create Full-Width layout for bios -->
            <xsl:if test="system-index-block/system-page[name='index']/system-data-structure/main-content/layout = 'Full-Width'">
                <xsl:apply-templates mode="people-featured" select="system-index-block[descendant::system-page]"/>
            </xsl:if>
            <!-- create Tiles layout for bios -->
            <xsl:if test="system-index-block/system-page[name='index']/system-data-structure/main-content/layout = 'Tiles'">
                <xsl:apply-templates mode="people-tile" select="system-index-block[descendant::system-page]"/>
            </xsl:if>
            <!-- create table layout for bios -->
            <xsl:if test="system-index-block/system-page[name='index']/system-data-structure/main-content/layout = 'Table Listing'">
                <xsl:apply-templates mode="table-listing" select="system-index-block"/>
            </xsl:if>
        </div>
    </xsl:template>
    <!-- summary div -->
    <xsl:template match="system-index-block/system-page[name='index']" mode="summary">
        <xsl:param name="title-alignment"/>
        <div>
            <xsl:choose>
                <xsl:when test="$title-alignment = 'Horizontal Sections'">
                    <xsl:attribute name="class">intro horizontal clearfix</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">intro</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <h1>
                <xsl:value-of select="title"/>
            </h1>
            <h2>
                <xsl:value-of select="summary"/>
            </h2>
        </div>
    </xsl:template>
    <!-- summary with flex box instead -->
    <xsl:template match="system-index-block/system-page[name='index']" mode="flex-box">
        <xsl:param name="title-alignment"/>
        <div>
            <xsl:attribute name="class">intro</xsl:attribute>
            <h1>
                <xsl:value-of select="title"/>
            </h1>
            <div class="wysiwyg">
                <xsl:copy-of select="system-data-structure/flex-group/wysiwyg/node()"/>
            </div>
        </div>
    </xsl:template>
    <!-- do hierarchical stuff -->
    <xsl:template match="system-index-block" mode="hierarchical">
        <div class="pages hierarchical">
            <xsl:choose>
                <xsl:when test="system-folder">
                    <xsl:apply-templates mode="hierarchical-folders" select="system-folder"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="hierarchical-pages" select="system-page[name != 'index']"/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <!-- hierarchical with subfolders -->
    <xsl:template match="system-folder" mode="hierarchical-folders">
        <section class="clearfix">
            <xsl:apply-templates mode="hierarchical-main-pages" select="system-page[name ='index']"/>
            <ul class="subpages">
                <xsl:apply-templates mode="hierarchical-sub-pages" select="system-page[name != 'index']"/>
            </ul>
        </section>
    </xsl:template>
    <xsl:template match="system-page[name ='index']" mode="hierarchical-main-pages">
        <figure class="pull-right span4">
            <a class="thumbnail">
                <xsl:attribute name="href">
                    <xsl:value-of select="link"/>
                </xsl:attribute>
                <img>
                    <xsl:attribute name="alt">Image for <xsl:value-of select="title"/>
                    </xsl:attribute>
                    <xsl:attribute name="src">
                        <xsl:value-of select="system-data-structure/thumbnail/image/link"/>
                    </xsl:attribute>
                </img>
            </a>
        </figure>
        <h3>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="link"/>
                </xsl:attribute>
                <xsl:value-of select="title"/>
            </a>
        </h3>
    </xsl:template>
    <!-- hierarchical with no subfolders -->
    <xsl:template match="system-page[name != 'index']" mode="hierarchical-pages">
        <article class="clearfix">
            <figure class="pull-right span4">
                <a class="thumbnail">
                    <xsl:attribute name="href">
                        <xsl:value-of select="link"/>
                    </xsl:attribute>
                    <img>
                        <xsl:attribute name="alt">Image for <xsl:value-of select="title"/>
                        </xsl:attribute>
                        <xsl:attribute name="src">
                            <xsl:value-of select="system-data-structure/thumbnail/image/link"/>
                        </xsl:attribute>
                    </img>
                </a>
            </figure>
            <h3>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="link"/>
                    </xsl:attribute>
                    <xsl:value-of select="title"/>
                </a>
            </h3>
            <xsl:choose>
                <xsl:when test="summary != ''">
                    <p class="summary">
                        <xsl:value-of select="summary"/>
                    </p>
                </xsl:when>
                <xsl:when test="teaser != ''">
                    <p class="teaser">
                        <xsl:value-of select="teaser"/>
                    </p>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </article>
    </xsl:template>
    <xsl:template match="system-page[name != 'index']" mode="hierarchical-sub-pages">
        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="link"/>
                </xsl:attribute>
                <xsl:value-of select="title"/>
            </a>
        </li>
    </xsl:template>
    <!-- do people stuff -->
    <xsl:template match="system-index-block" mode="people-featured">
        <section>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="//system-index-block/system-page[name='index']/system-data-structure/main-content/layout = 'Full-Width'">
                        <xsl:text>people full-width</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>people featured well well-small</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="system-page[name='index']/system-data-structure/main-content/leadership-heading != ''">
                <h2>
                    <xsl:value-of select="system-page[name='index']/system-data-structure/main-content/leadership-heading"/>
                </h2>
            </xsl:if>
            <ul class="equal-height-row">
                <xsl:choose>
                    <xsl:when test="//layout = 'Hierarchical'">
                        <xsl:apply-templates mode="person-featured" select="descendant::system-page[system-data-structure/main-content-bio/leadership/value='Yes']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="person-featured" select="descendant::system-page[system-data-structure/main-content-bio/leadership]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </ul>
        </section>
    </xsl:template>
    <xsl:template match="system-index-block" mode="table-listing">
        <div class="table-container">
            <table class="table-striped full-width full-bio-listing">
                <thead>
                    <tr>
                        
                        <th>Full Name</th>
                        <th>Email | Phone</th>
                        <th>Position</th>
                    </tr>
                </thead>
                <xsl:for-each select="system-page[not(@current='true')]">
                    <xsl:sort order="ascending" select="name"/>
                    <tr>
                        <xsl:if test="/system-index-block/system-page/system-data-structure/thumbnail/photo-bio/path!='/'">
                        <td>
                            <xsl:choose>
                                <xsl:when test="system-data-structure/url != ' '">
                                    <a href="{system-data-structure/url}">
                                        <figure>
                                            <a class="thumbnail">
                                                <xsl:attribute name="href">
                                                  <xsl:value-of select="link"/>
                                                </xsl:attribute>
                                                <xsl:choose>
                                                  <xsl:when test="system-data-structure/thumbnail/thumb-bio/path != '/'">
                                                  <img>
                                                  <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="src">
                                                  <xsl:value-of select="system-data-structure/thumbnail/thumb-bio/link"/>
                                                  </xsl:attribute>
                                                  </img>
                                                  </xsl:when>
                                                  <xsl:when test="system-data-structure/thumbnail/photo-bio/path != '/'">
                                                  <img>
                                                  <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="src">
                                                  <xsl:value-of select="system-data-structure/thumbnail/photo-bio/link"/>
                                                  </xsl:attribute>
                                                  </img>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <img>
                                                  <xsl:attribute name="alt">Currently no photo for
                                                  <xsl:value-of select="title"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="src">https://template.emory.edu/assets/images/placeholder/bio-no-photo.png</xsl:attribute>
                                                  </img>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </a>
                                        </figure>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <a href="{link}">
                                        <figure>
                                            <a class="thumbnail">
                                                <xsl:attribute name="href">
                                                  <xsl:value-of select="link"/>
                                                </xsl:attribute>
                                                <xsl:choose>
                                                  <xsl:when test="system-data-structure/thumbnail/thumb-bio/path != '/'">
                                                  <img>
                                                  <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="src">
                                                  <xsl:value-of select="system-data-structure/thumbnail/thumb-bio/link"/>
                                                  </xsl:attribute>
                                                  </img>
                                                  </xsl:when>
                                                  <xsl:when test="system-data-structure/thumbnail/photo-bio/path != '/'">
                                                  <img>
                                                  <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="src">
                                                  <xsl:value-of select="system-data-structure/thumbnail/photo-bio/link"/>
                                                  </xsl:attribute>
                                                  </img>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                    <img>
                                                        <xsl:attribute name="alt">Currently no photo for 
                                                        <xsl:value-of select="title"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="src">https://template.emory.edu/assets/images/placeholder/bio-no-photo.png</xsl:attribute>
                                                    </img>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </a>
                                        </figure>
                                    </a>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        </xsl:if>
                        <td>
                            <xsl:choose>
                                <xsl:when test="system-data-structure/url != ' '">
                                    <a class="name" href="{system-data-structure/url}">
                                        <xsl:value-of select="system-data-structure/main-content-bio/first_main"/>
                                        <br/>
                                        <xsl:value-of select="system-data-structure/main-content-bio/last_main"/>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <a class="name" href="{link}">
                                        <xsl:value-of select="system-data-structure/main-content-bio/first_main"/>
                                        <br/>
                                        <xsl:value-of select="system-data-structure/main-content-bio/last_main"/>
                                    </a>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td class="contact-info">
                            <a itemprop="email">
                                <xsl:attribute name="href">mailto: <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                                </xsl:attribute>
                                <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                            </a>
                            <br/>
                            <xsl:if test="system-data-structure/main-content-bio/contact/phone!='' and system-data-structure/main-content-bio/contact/phone!='N/A'">
                                <a itemprop="tel">
                                    <xsl:attribute name="href">tel: <xsl:value-of select="translate(system-data-structure/main-content-bio/contact/phone,'.-() ','')"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="system-data-structure/main-content-bio/contact/phone"/>
                                </a>
                            </xsl:if>
                        </td>
                        <td>
                            <em>
                                <xsl:value-of select="system-data-structure/main-content-bio/roletitle/role[1]"/>
                            </em>
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
    <xsl:template match="system-page" mode="person-table">
        <tr>
            <td colspan="2">
                <xsl:value-of select="system-data-structure/main-content-bio/first_main"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="system-data-structure/main-content-bio/last_main"/>
            </td>
            <td>
                <a itemprop="email">
                    <xsl:attribute name="href">mailto: <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                    </xsl:attribute>
                    <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                </a>
            </td>
            <td class="tel">
                <xsl:value-of select="system-data-structure/main-content-bio/contact/phone"/>
            </td>
            <td>
                <xsl:value-of select="system-data-structure/main-content-bio/roletitle/role[1]"/> ,
                    <xsl:value-of select="system-data-structure/main-content-bio/roletitle/org[1]"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="system-index-block" mode="people">
        <xsl:choose>
            <xsl:when test="system-folder != ''">
                <xsl:for-each select="system-folder">
                    <section class="people general">
                        <xsl:choose>
                            <xsl:when test="title and title != ''">
                                <h2>
                                    <xsl:value-of select="title"/>
                                </h2>
                            </xsl:when>
                            <xsl:otherwise>
                                <h2>
                                    <xsl:value-of select="../system-page[name='index']/system-data-structure/main-content/general-heading"/>
                                </h2>
                            </xsl:otherwise>
                        </xsl:choose>
                        <ul class="equal-height-row clearfix">
                            <xsl:apply-templates mode="person" select="descendant::system-page[not(name='index' or system-data-structure/main-content-bio/leadership/value) and system-data-structure/main-content-bio != '']"/>
                        </ul>
                    </section>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <section class="people general">
                    <xsl:choose>
                        <xsl:when test="system-page[name='index']/system-data-structure/main-content/general-heading != ''">
                            <h2>
                                <xsl:value-of select="system-page[name='index']/system-data-structure/main-content/general-heading"/>
                            </h2>
                        </xsl:when>
                    </xsl:choose>
                    <ul class="equal-height-row clearfix">
                        <xsl:apply-templates mode="person" select="descendant::system-page[not(name='index' or system-data-structure/main-content-bio/leadership/value) and system-data-structure/main-content-bio != '']"/>
                    </ul>
                </section>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="system-index-block" mode="people-tile">
        <xsl:choose>
            <xsl:when test="system-folder != ''">
                <xsl:for-each select="system-folder">
                    <section class="people general">
                        <xsl:choose>
                            <xsl:when test="title and title != ''">
                                <h2>
                                    <xsl:value-of select="title"/>
                                </h2>
                            </xsl:when>
                            <xsl:otherwise>
                                <h2>
                                    <xsl:value-of select="../system-page[name='index']/system-data-structure/main-content/general-heading"/>
                                </h2>
                            </xsl:otherwise>
                        </xsl:choose>
                        <ul class="equal-height-row clearfix">
                            <xsl:apply-templates mode="person" select="descendant::system-page[not(name='index') and system-data-structure/main-content-bio != '']"/>
                        </ul>
                        <div class="no-results hidden clearfix">
                            <h3>No results</h3>
                            <p>There are no results for your current search.</p>
                        </div>
                    </section>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <section class="people general">
                    <xsl:choose>
                        <xsl:when test="system-page[name='index']/system-data-structure/main-content/general-heading != ''">
                            <h2>
                                <xsl:value-of select="system-page[name='index']/system-data-structure/main-content/general-heading"/>
                            </h2>
                        </xsl:when>
                    </xsl:choose>
                    <ul class="equal-height-row clearfix">
                        <xsl:apply-templates mode="person" select="descendant::system-page[not(name='index') and system-data-structure/main-content-bio != '']"/>
                    </ul>
                    <div class="no-results hidden clearfix">
                        <h3>No results</h3>
                        <p>There are no results for your current search.</p>
                    </div>
                </section>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="system-page" mode="person-featured">
        <li class="span12 alpha" itemtype="http://schema.org/Person">
            <xsl:attribute name="itemscope">true</xsl:attribute>
            <div class="section span3">
                <figure>
                    <a class="thumbnail">
                        <xsl:attribute name="href">
                            <xsl:value-of select="link"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="system-data-structure/thumbnail/thumb-bio/path != '/'">
                                <img>
                                    <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="system-data-structure/thumbnail/thumb-bio/link"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:when test="system-data-structure/thumbnail/photo-bio/path != '/'">
                                <img>
                                    <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="system-data-structure/thumbnail/photo-bio/link"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <img>
                                    <xsl:attribute name="alt">Currently no photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">https://template.emory.edu/assets/images/placeholder/bio-no-photo.png</xsl:attribute>
                                </img>
                            </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </figure>
            </div>
            <div class="section span9 bio-info">
                <h3>
                    <a>
                        <xsl:attribute name="itemprop">name</xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="link"/>
                        </xsl:attribute>
                        <xsl:value-of select="title"/>
                    </a>
                </h3>
                <xsl:if test="system-data-structure/main-content-bio/roletitle/role !=''">
                    <xsl:apply-templates select="system-data-structure/main-content-bio/roletitle[role !='']">
                        <xsl:with-param name="number" select="count(system-data-structure/main-content-bio/roletitle/role)"/>
                    </xsl:apply-templates>
                </xsl:if>
                <div class="section phone-email">
                    <xsl:if test="system-data-structure/main-content-bio/contact/phone != ''">
                        <h4 itemprop="telephone">
                            <xsl:value-of select="system-data-structure/main-content-bio/contact/phone"/>
                        </h4>
                    </xsl:if>
                    <xsl:if test="system-data-structure/main-content-bio/contact/email != ''">
                        <h4 class="email">
                            <a itemprop="email">
                                <xsl:attribute name="href">mailto: <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                                </xsl:attribute>
                                <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                            </a>
                        </h4>
                    </xsl:if>
                </div>
            </div>
        </li>
    </xsl:template>
    <xsl:template match="system-page" mode="person">
        <xsl:variable name="number">
            <xsl:value-of select="position() "/>
        </xsl:variable>
        <li itemtype="http://schema.org/Person">
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="number($number - 1) mod 3 = 0">
                        <xsl:text>tile span4 alpha</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>tile span4</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="itemscope">true</xsl:attribute>
            <div class="section span10">
                <figure>
                    <a class="thumbnail">
                        <xsl:attribute name="href">
                            <xsl:value-of select="link"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="system-data-structure/thumbnail/thumb-bio/path != '/'">
                                <img>
                                    <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="system-data-structure/thumbnail/thumb-bio/link"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:when test="system-data-structure/thumbnail/photo-bio/path != '/'">
                                <img>
                                    <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="system-data-structure/thumbnail/photo-bio/link"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <img>
                                    <xsl:attribute name="alt">Currently no photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">https://template.emory.edu/assets/images/placeholder/bio-no-photo.png</xsl:attribute>
                                </img>
                            </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </figure>
            </div>
            <div class="section span10">
                <h3>
                    <a>
                        <xsl:attribute name="itemprop">name</xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="link"/>
                        </xsl:attribute>
                        <xsl:value-of select="title"/>
                    </a>
                </h3>
                <xsl:if test="system-data-structure/main-content-bio/roletitle/role !=''">
                    <xsl:apply-templates select="system-data-structure/main-content-bio/roletitle[role !='']">
                        <xsl:with-param name="number" select="count(system-data-structure/main-content-bio/roletitle/role)"/>
                    </xsl:apply-templates>
                </xsl:if>
                <div class="section phone-email">
                    <xsl:if test="system-data-structure/main-content-bio/contact/phone != ''">
                        <h4 itemprop="telephone">
                            <xsl:value-of select="system-data-structure/main-content-bio/contact/phone"/>
                        </h4>
                    </xsl:if>
                    <xsl:if test="system-data-structure/main-content-bio/contact/email != ''">
                        <h4 class="email">
                            <a itemprop="email">
                                <xsl:attribute name="href">mailto: <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                                </xsl:attribute>
                                <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                            </a>
                        </h4>
                    </xsl:if>
                </div>
            </div>
        </li>
    </xsl:template>
    <xsl:template match="system-page" mode="subject-librarians">
        <li class="span12 alpha" itemtype="http://schema.org/Person">
            <xsl:attribute name="itemscope">true</xsl:attribute>
            <div class="section span3">
                <figure>
                    <a class="thumbnail">
                        <xsl:attribute name="href">
                            <xsl:value-of select="link"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="system-data-structure/thumbnail/thumb-bio/path != '/'">
                                <img>
                                    <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="system-data-structure/thumbnail/thumb-bio/link"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:when test="system-data-structure/thumbnail/photo-bio/path != '/'">
                                <img>
                                    <xsl:attribute name="alt">Photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="system-data-structure/thumbnail/photo-bio/link"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <img>
                                    <xsl:attribute name="alt">Currently no photo for <xsl:value-of select="title"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">https://template.emory.edu/assets/images/placeholder/bio-no-photo.png</xsl:attribute>
                                </img>
                            </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </figure>
            </div>
            <div class="section span6">
                <h3>
                    <a>
                        <xsl:attribute name="itemprop">name</xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="link"/>
                        </xsl:attribute>
                        <xsl:value-of select="title"/>
                    </a>
                </h3>
                <xsl:if test="system-data-structure/main-content-bio/roletitle/role !=''">
                    <xsl:apply-templates select="system-data-structure/main-content-bio/roletitle[role !='']">
                        <xsl:with-param name="number" select="count(system-data-structure/main-content-bio/roletitle/role)"/>
                    </xsl:apply-templates>
                </xsl:if>
                <div class="section phone-email">
                    <xsl:if test="system-data-structure/main-content-bio/contact/phone != ''">
                        <h4 itemprop="telephone">
                            <xsl:value-of select="system-data-structure/main-content-bio/contact/phone"/>
                        </h4>
                    </xsl:if>
                    <xsl:if test="system-data-structure/main-content-bio/contact/email != ''">
                        <h4 class="email">
                            <a itemprop="email">
                                <xsl:attribute name="href">mailto: <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                                </xsl:attribute>
                                <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                            </a>
                        </h4>
                    </xsl:if>
                </div>
            </div>
            <div class="section span3">
                <xsl:if test="system-data-structure/main-content-bio/subjects/subject-dropdown !=''">
                    <section class="subjects">
                        <xsl:choose>
                            <xsl:when test="count(system-data-structure/main-content-bio/subjects/subject-dropdown) = 1">
                                <h4 class="boxed-heading">Subject Area</h4>
                            </xsl:when>
                            <xsl:otherwise>
                                <h4 class="boxed-heading">Subject Areas</h4>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:for-each select="system-data-structure/main-content-bio/subjects/subject-dropdown">
                            <p>
                                <a href="#">
                                    <xsl:value-of select="text()"/>
                                </a>
                            </p>
                        </xsl:for-each>
                    </section>
                </xsl:if>
            </div>
        </li>
    </xsl:template>
    <xsl:template match="roletitle">
        <xsl:param name="number"/>
        <div class="section">
            <h4 class="title" itemprop="jobTitle">
                <xsl:value-of select="role"/>
            </h4>
            <div itemtype="http://schema.org/Organization">
                <xsl:attribute name="itemscope">true</xsl:attribute>
                <h4 class="org" itemprop="name">
                    <xsl:value-of select="org"/>
                </h4>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
