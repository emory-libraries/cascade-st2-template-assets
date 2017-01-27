<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <div>
            <xsl:attribute name="class">data-entry subject-libs <xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'"> wide</xsl:if>
            </xsl:attribute>
            <!-- check for summary. use if present, and use title by itself if not -->
            <xsl:apply-templates mode="summary" select="system-index-block/calling-page/system-page[name='index']">
                <xsl:with-param name="title-alignment" select="system-index-block/calling-page/system-page[name='index']/system-data-structure/main-content/title-alignment"/>
            </xsl:apply-templates>
            <xsl:choose>
                <!-- create hierarchical layout for bios -->
                <xsl:when test="system-index-block/calling-page/system-page[name='index']/system-data-structure/main-content/layout = 'Hierarchical'">
                    <xsl:apply-templates mode="people-featured" select="system-index-block[descendant::system-page[system-data-structure/main-content-bio/leadership/value='Yes']]"/>
                    <xsl:apply-templates mode="people" select="system-index-block[descendant::system-page[system-data-structure/main-content-bio/leadership = '']]"/>
                </xsl:when>
                <!-- create Full-Width layout for bios -->
                <xsl:when test="system-index-block/calling-page/system-page[name='index']/system-data-structure/main-content/layout = 'Full-Width'">
                    <xsl:apply-templates mode="people-featured" select="system-index-block[descendant::system-folder/system-page] | system-page[@reference='true']/descendant::system-page"/>
                </xsl:when>
                <!-- create Tiles layout for bios -->
                <xsl:when test="system-index-block/calling-page/system-page[name='index']/system-data-structure/main-content/layout = 'Tiles'">
                    <xsl:apply-templates mode="people-tile" select="system-index-block"/>
                </xsl:when>
                <!-- create table layout for bios -->
                <xsl:otherwise>

                    <xsl:apply-templates mode="table-listing" select="system-index-block"/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <!-- summary div -->
    <xsl:template match="system-page[name='index']" mode="summary">
        <xsl:param name="title-alignment"/>
        <header class="intro">
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
            <xsl:if test="summary!=''">
                <div class="summary">
                    <p>
                        <xsl:value-of select="summary"/>
                    </p>
                </div>
            </xsl:if>
        </header>
    </xsl:template>
    <!-- do hierarchical stuff -->
    <xsl:template match="system-index-block" mode="hierarchical">
        <div class="pages hierarchical">
            <xsl:choose>
                <xsl:when test="system-folder">
                    <xsl:apply-templates mode="hierarchical-folders" select="system-folder"/>
                </xsl:when>
                <!--<xsl:otherwise>
                    <xsl:apply-templates mode="hierarchical-pages"
                        select="system-page[name != 'index'][descendant-or-self::subject-dropdown!=' ']"
                    />
                </xsl:otherwise>-->
            </xsl:choose>
        </div>
    </xsl:template>
    <!-- hierarchical with subfolders -->
    <xsl:template match="system-folder" mode="hierarchical-folders">
        <section class="clearfix">
            <xsl:apply-templates mode="hierarchical-main-pages" select="system-page[name ='index']"/>
            <ul class="subpages">
                <xsl:apply-templates mode="hierarchical-sub-pages" select="system-page[name != 'index'][descendant-or-self::subject-dropdown!=' ']"/>
            </ul>
        </section>
    </xsl:template>
    <xsl:template match="system-page[name ='index'][descendant-or-self::subject-dropdown!=' ']" mode="hierarchical-main-pages">
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
    <xsl:template match="system-page[name != 'index'][descendant-or-self::subject-dropdown!=' ']" mode="hierarchical-pages">
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
                        <xsl:text>people featured</xsl:text>
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
                        <xsl:apply-templates mode="person-featured" select="descendant-or-self::system-data-structure/bio/descendant::system-page[system-data-structure/main-content-bio/leadership/value='Yes'][descendant-or-self::subject-dropdown!=' ']"><xsl:sort order="ascending" select="name"/></xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="person-featured" select="descendant-or-self::system-data-structure/bio/descendant::system-page[descendant-or-self::subject-dropdown!=' ']"><xsl:sort order="ascending" select="name"/></xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </ul>
        </section>
    </xsl:template>
    <xsl:template match="system-index-block" mode="table-listing">
        <div class="table-container">
            <table class="table-striped full-width">
                <thead>
                    <tr>
                        <th>
                            <xsl:text> </xsl:text>
                        </th>
                        <th>Full Name</th>
                        <th>Email | Phone</th>
                        <th>Subject Areas</th>
                    </tr>
                </thead>
                <xsl:for-each select="//system-data-structure/bio/descendant::system-page[system-data-structure/main-content-bio/subjects/subject-dropdown!=''][system-data-structure/main-content-bio/subjects/subject-dropdown!=' ']">
                    <xsl:sort order="ascending" select="name"/>
                    <tr>
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
                                                  <xsl:attribute name="src">https://template.emory.edu/assets/wdg/clients/library/images/bio/bio-no-photo.gif</xsl:attribute>
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
                                                  <xsl:attribute name="src">https://template.emory.edu/assets/wdg/clients/library/images/bio/bio-no-photo.gif</xsl:attribute>
                                                  </img>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </a>
                                        </figure>
                                    </a>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            <xsl:call-template name="attachments"/>
                        </td>
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
                        <td class="subjects">
                            <xsl:if test="system-data-structure/main-content-bio/subjects/subject-dropdown!=''">
                                <p>
                                    <xsl:for-each select="system-data-structure/main-content-bio/subjects/subject-dropdown">
                                        <a href="#">
                                            <xsl:value-of select="text()"/>
                                        </a>
                                        <br/>
                                    </xsl:for-each>
                                </p>
                            </xsl:if>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
        </div>
    </xsl:template>
    <xsl:template match="system-page" mode="person-table">
        <tr>
            <td>
                <xsl:value-of select="system-data-structure/main-content-bio/last_main"/>
            </td>
            <td>
                <xsl:value-of select="system-data-structure/main-content-bio/first_main"/>
            </td>
            <td>
                <a itemprop="email">
                    <xsl:attribute name="href">mailto: <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                    </xsl:attribute>
                    <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                </a>
            </td>
            <td>
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
                            <xsl:apply-templates mode="person" select="descendant-or-self::system-data-structure/bio/descendant::system-page[descendant-or-self::subject-dropdown!=' ']"/>
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
                        <xsl:apply-templates mode="person" select="descendant-or-self::system-data-structure/bio/descendant::system-page[descendant-or-self::subject-dropdown!=' ']"/>
                    </ul>
                    <div class="no-results hidden clearfix">
                        <h3>No results</h3>
                        <p>There are no results for your current search.</p>
                    </div>
                </section>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="system-index-block" mode="people-tile">
        
        <xsl:choose>
            <xsl:when test="system-folder != ''">
                
                    <section class="people general">
                        <xsl:choose>
                            <xsl:when test="title and title != ''">
                                <h2>
                                    <xsl:value-of select="title"/>
                                </h2>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="../system-page[name='index']/system-data-structure/main-content/general-heading!=''">
                                    <h2>
                                        <xsl:value-of select="../system-page[name='index']/system-data-structure/main-content/general-heading"/>
                                    </h2>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                        <ul class="equal-height-row clearfix">
                            <xsl:apply-templates mode="person" select="//system-data-structure/bio/descendant::system-page[descendant-or-self::subject-dropdown!=' ']"><xsl:sort order="ascending" select="name"/></xsl:apply-templates>
                        </ul>
                    </section>
                
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
                        
                        <xsl:apply-templates mode="person" select="descendant::system-page[not(name='index') and system-data-structure/main-content-bio != '']"><xsl:sort order="ascending" select="name"/></xsl:apply-templates>
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

                            <xsl:when test="system-data-structure/thumbnail/photo-bio/link != '/'">
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
                                    <xsl:attribute name="src">https://template.emory.edu/assets/wdg/clients/library/images/bio/bio-no-photo.gif</xsl:attribute>
                                </img>
                            </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </figure>
            </div>
            <div class="section span6 bio-info">
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
                
                <xsl:call-template name="attachments"/>
                
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
            <xsl:if test="system-data-structure/main-content-bio/subjects/subject-dropdown">
                <div class="subjects span3">
                    <h2 class="boxed-heading">Subject Areas</h2>
                    <xsl:for-each select="system-data-structure/main-content-bio/subjects/subject-dropdown">
                        <p>
                            <a href="#">
                                <xsl:value-of select="text()"/>
                            </a>
                        </p>
                    </xsl:for-each>
                </div>
            </xsl:if>
        </li>
    </xsl:template>
    <xsl:template match="system-page" mode="person">
        <xsl:variable name="number">
            <xsl:value-of select="position() "/>
        </xsl:variable>
        <xsl:if test="number($number - 1) mod 3 = 0">
            <xsl:text disable-output-escaping="yes">        &lt;/ul&gt;        &lt;ul class="equal-height-row"&gt;                </xsl:text>
        </xsl:if>
        <li itemtype="http://schema.org/Person">
            <xsl:attribute name="class">
                <xsl:text>tile span4</xsl:text>
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
                                    <xsl:attribute name="src">https://template.emory.edu/assets/wdg/clients/library/images/bio/bio-no-photo.gif</xsl:attribute>
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
                <xsl:call-template name="attachments"/>
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
            <xsl:if test="system-data-structure/main-content-bio/subjects/subject-dropdown">
                <div class="subjects span10">
                    <h2 class="boxed-heading">Subject Areas</h2>
                    <xsl:for-each select="system-data-structure/main-content-bio/subjects/subject-dropdown">
                        <p>
                            <a href="#">
                                <xsl:value-of select="text()"/>
                            </a>
                        </p>
                    </xsl:for-each>
                </div>
            </xsl:if>
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
                                    <xsl:attribute name="src">https://template.emory.edu/assets/wdg/clients/library/images/bio/bio-no-photo.gif</xsl:attribute>
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
                
                <xsl:call-template name="attachments"/>
                
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
    <xsl:template name="attachments">
        <!-- ATTACHMENTS/CV/ETC -->
        <xsl:if test="descendant::attachments/cv/name or descendant::attachments/online_cv_url!='' or descendant::research/research-guide!='' or descendant::attachments/misc_attachments/attachment/name">
            <div class="bio-attachments">
                <xsl:if test="descendant::attachments/cv/name">
                    <p>
                        <a href="{descendant::attachments/cv/link}">Download Full CV</a>
                    </p>
                </xsl:if>
                <xsl:if test="descendant::attachments/online_cv_url!=''">
                    <p>
                        <a href="{descendant::attachments/online_cv_url}">View Online CV</a>
                    </p>
                </xsl:if>
                <xsl:if test="descendant::research/research-guide!=''">
                    <p>
                        <a href="{descendant::research/research-guide}">View Research Guides</a>
                    </p>
                </xsl:if>
                <!-- misc/other -->
                <xsl:if test="descendant::attachments/misc_attachments/attachment/name">
                    <xsl:for-each select="descendant::attachments/misc_attachments">
                        <p>
                            <a href="{attachment/path}">
                                <xsl:choose>
                                    <xsl:when test="attachment_label!=''">
                                        <xsl:value-of select="attachment_label"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="attachment/name"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </a>
                        </p>
                    </xsl:for-each>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
