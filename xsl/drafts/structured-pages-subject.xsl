<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <div>
            <xsl:attribute name="class">data-entry
                <xsl:if test="//dynamic-metadata[name='layout-columns']/value='Disable Right Column'">
                    wide</xsl:if>
            </xsl:attribute>
            <!-- check for summary. use if present, and use title by itself if not -->
            <xsl:choose>
                <xsl:when test="system-index-block/system-page[name='index']/summary != ''">
                    <xsl:apply-templates mode="summary" select="system-index-block/system-page[name='index']">
                        <xsl:with-param name="title-alignment" select="system-index-block/system-page[name='index']/system-data-structure/main-content/title-alignment"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <h1>
                        <xsl:value-of select="system-index-block/system-page[name='index']/title"/>
                    </h1>
                </xsl:otherwise>
            </xsl:choose>
            <!-- create hierarchical layout for pages only -->
            <xsl:if test="system-index-block/system-page[name='index']/system-data-structure/main-content/layout = 'Default (Hierarchical)'">
                <xsl:apply-templates mode="hierarchical" select="system-index-block"/>
            </xsl:if>
            <!-- create hierarchical layout for bios only -->
            <xsl:if test="system-index-block/system-page[name='index']/system-data-structure/main-content/layout = 'Hierarchical Bio Listing'">
                <xsl:apply-templates mode="people-featured" select="system-index-block[descendant::system-page[system-data-structure/main-content-bio/leadership/value='Yes']]"/>
                <xsl:apply-templates mode="people" select="system-index-block[descendant::system-page[system-data-structure/main-content-bio/leadership = '']]"/>
            </xsl:if>
            <!-- create thumbnail list layout - for pages and bios -->
            <xsl:if test="system-index-block/system-page[name='index']/system-data-structure/main-content/layout = 'Thumbnail with Summary' or system-index-block/system-page[name='index']/system-data-structure/main-content/layout = 'Thumbnail Bio Listing'">
                <xsl:variable name="button-text">
                    <xsl:choose>
                        <xsl:when test="system-index-block/system-page[name='index']/system-data-structure/main-content/button-text != ''">
                            <xsl:value-of select="system-index-block/system-page[name='index']/system-data-structure/main-content/button-text"/>
                        </xsl:when>
                        <xsl:otherwise>View more</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="thumbnail-type" select="system-index-block/system-page[name='index']/system-data-structure/main-content/layout"/>
                <xsl:choose>
                    <xsl:when test="$thumbnail-type='Thumbnail Bio Listing'">
                        <xsl:apply-templates mode="thumbnails-people" select="system-index-block">
                            <xsl:with-param name="button-text" select="$button-text"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="thumbnails" select="system-index-block">
                            <xsl:with-param name="button-text" select="$button-text"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
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
    <!-- do hierarchical stuff -->
    <xsl:template match="system-index-block" mode="hierarchical">
        <div class="pages hierarchical">
            <xsl:apply-templates mode="hierarchical-folders" select="system-folder"/>
        </div>
    </xsl:template>
    <xsl:template match="system-folder" mode="hierarchical-folders">
        <section class="clearfix">
            <xsl:apply-templates mode="hierarchical-main-pages" select="system-page[name ='index'][not(dynamic-metadata[name='section-listing']/value='Yes')]"/>
            <ul class="subpages">
                <xsl:apply-templates mode="hierarchical-sub-pages" select="system-page[name != 'index'][not(dynamic-metadata[name='section-listing']/value='Yes')]"/>
            </ul>
        </section>
    </xsl:template>
    <xsl:template match="system-page[name ='index']" mode="hierarchical-main-pages">
        <figure class="pull-right span4">
            <a class="thumbnail">
                <xsl:attribute name="href">
                    <xsl:value-of select="path"/>
                </xsl:attribute>
                <img>
                    <xsl:attribute name="alt">Image for 
                        <xsl:value-of select="title"/></xsl:attribute>
                    <xsl:attribute name="src">
                        <xsl:value-of select="system-data-structure/thumbnail/image/path"/>
                    </xsl:attribute>
                </img>
            </a>
        </figure>
        <h3>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="path"/>
                </xsl:attribute>
                <xsl:value-of select="title"/>
            </a>
        </h3>
    </xsl:template>
    <xsl:template match="system-page[name != 'index']" mode="hierarchical-sub-pages">
        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="path"/>
                </xsl:attribute>
                <xsl:value-of select="title"/>
            </a>
        </li>
    </xsl:template>
    <!-- do thumbnail stuff -->
    <xsl:template match="system-index-block" mode="thumbnails">
        <xsl:param name="button-text"/>
        <div>
            <xsl:attribute name="class">equal-height-row pages thumbnail-pages clearfix</xsl:attribute>
            <xsl:for-each select="descendant::system-page[system-data-structure/thumbnail][not(dynamic-metadata[name='section-listing']/value='Yes')] | system-symlink">
                <section class="page equal-height span3">
                    <figure>
                        <a class="thumbnail">
                            <xsl:attribute name="href">
                                <xsl:value-of select="path"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="system-data-structure/thumbnail/image/path != '/'">
                                    <img>
                                        <xsl:attribute name="alt">Image for 
                                            <xsl:value-of select="title"/></xsl:attribute>
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="system-data-structure/thumbnail/image/path"/>
                                        </xsl:attribute>
                                    </img>
                                </xsl:when>
                                <xsl:when test="system-data-structure/thumbnail/thumb-bio/path != '/'">
                                    <img>
                                        <xsl:attribute name="alt">Photo for 
                                            <xsl:value-of select="title"/></xsl:attribute>
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="system-data-structure/thumbnail/thumb-bio/path"/>
                                        </xsl:attribute>
                                    </img>
                                </xsl:when>
                                <xsl:when test="system-data-structure/thumbnail/photo-bio/path != '/'">
                                    <img>
                                        <xsl:attribute name="alt">Photo for 
                                            <xsl:value-of select="title"/></xsl:attribute>
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="system-data-structure/thumbnail/photo-bio/path"/>
                                        </xsl:attribute>
                                    </img>
                                </xsl:when>
                            </xsl:choose>
                        </a>
                    </figure>
                    <h3>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="path"/>
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
                    <p>
                        <a>
                            <xsl:attribute name="class">btn</xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of select="path"/>
                            </xsl:attribute>
                            <xsl:if test="dynamic-metadata/value='Open in New Window'">
                                <xsl:attribute name="rel">
                                    <xsl:text>external</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="$button-text != ''">
                                    <xsl:value-of select="$button-text"/>
                                </xsl:when>
                                <xsl:otherwise>View More</xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </p>
                </section>
            </xsl:for-each>
        </div>
    </xsl:template>
    <!-- do thumbnail bio stuff -->
    <xsl:template match="system-index-block" mode="thumbnails-people">
        <xsl:param name="button-text"/>
        <div>
            <xsl:attribute name="class">equal-height-row pages thumbnail-pages thumbnail-people clearfix</xsl:attribute>
            <!--<xsl:for-each select="descendant::system-page[not(name='index' or system-data-structure/main-content-bio/leadership/value) and system-data-structure/main-content-bio != '']">* this was hiding leadership. no idea why. -->
            <xsl:for-each select="descendant::system-page[not(name='index') and system-data-structure/main-content-bio != ''][not(dynamic-metadata[name='section-listing']/value='Yes')]">
                <section class="page equal-height span3">
                    <figure>
                        <a class="thumbnail">
                            <xsl:attribute name="href">
                                <xsl:value-of select="path"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="system-data-structure/thumbnail/image/path != '/'">
                                    <img>
                                        <xsl:attribute name="alt">Image for 
                                            <xsl:value-of select="title"/></xsl:attribute>
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="system-data-structure/thumbnail/image/path"/>
                                        </xsl:attribute>
                                    </img>
                                </xsl:when>
                                <xsl:when test="system-data-structure/thumbnail/thumb-bio/path != '/'">
                                    <img>
                                        <xsl:attribute name="alt">Photo for 
                                            <xsl:value-of select="title"/></xsl:attribute>
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="system-data-structure/thumbnail/thumb-bio/path"/>
                                        </xsl:attribute>
                                    </img>
                                </xsl:when>
                                <xsl:when test="system-data-structure/thumbnail/photo-bio/path != '/'">
                                    <img>
                                        <xsl:attribute name="alt">Photo for 
                                            <xsl:value-of select="title"/></xsl:attribute>
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="system-data-structure/thumbnail/photo-bio/path"/>
                                        </xsl:attribute>
                                    </img>
                                </xsl:when>
                                <xsl:otherwise>
                                    <img>
                                        <xsl:attribute name="alt">Currently no photo for 
                                            <xsl:value-of select="title"/></xsl:attribute>
                                        <xsl:attribute name="src">https://template.emory.edu/assets/images/placeholder/bio-no-photo.png</xsl:attribute>
                                    </img>
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </figure>
                    <h3>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="path"/>
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
                    <p>
                        <a>
                            <xsl:attribute name="class">btn</xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of select="path"/>
                            </xsl:attribute>
                            <xsl:if test="dynamic-metadata/value='Open in New Window'">
                                <xsl:attribute name="rel">
                                    <xsl:text>external</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="$button-text != ''">
                                    <xsl:value-of select="$button-text"/>
                                </xsl:when>
                                <xsl:otherwise>View More</xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </p>
                </section>
            </xsl:for-each>
        </div>
    </xsl:template>
    <!-- do people stuff -->
    <xsl:template match="system-index-block" mode="people-featured">
        <select class="input-xxlarge" id="edit-tid" name="tid">
            <option selected="selected" value="All">Choose a Subject</option>
            <option value="269">African American Studies</option>
            <option value="333">African History</option>
            <option value="270">African Studies</option>
            <option value="335">American Literature</option>
            <option value="327">Ancient and Medieval History</option>
            <option value="271">Anthropology</option>
            <option value="272">Art History</option>
            <option value="273">Biological and Biomedical Sciences</option>
            <option value="336">British Literature</option>
            <option value="344">Buddhism</option>
            <option value="275">Career Resources</option>
            <option value="276">Chemistry</option>
            <option value="345">Christianity</option>
            <option value="277">Classical Studies</option>
            <option value="278">Collection Management </option>
            <option value="346">Comparative and Other Religions</option>
            <option value="279">Comparative Literature</option>
            <option value="280">Computer Science</option>
            <option value="281">Copyright and Publishing</option>
            <option value="282">Dance</option>
            <option value="283">Data Sets</option>
            <option value="572">Data Management </option>
            <option value="284">Development Studies (Masters in Development Practice)</option>
            <option value="326">East Asian History </option>
            <option value="337">East Asian Literature</option>
            <option value="285">East Asian Studies</option>
            <option value="286">Economics</option>
            <option value="287">Education</option>
            <option value="363">EndNote</option>
            <option value="288">Environmental Studies</option>
            <option value="328">European History</option>
            <option value="289">Film Studies</option>
            <option value="338">French Literature</option>
            <option value="290">French Studies</option>
            <option value="291">Geospatial Data Librarian (GIS)</option>
            <option value="292">German Studies</option>
            <option value="293">Government Documents</option>
            <option value="294">Health, Physical Education and Sports</option>
            <option value="347">Hinduism</option>
            <option value="349">Instruction </option>
            <option value="296">Interdisciplinary Studies/ILA</option>
            <option value="297">International Documentation</option>
            <option value="332">Islam</option>
            <option value="298">Italian Studies</option>
            <option value="299">Jewish Studies</option>
            <option value="300">Journalism</option>
            <option value="348">Judaism</option>
            <option value="329">Latin American History</option>
            <option value="339">Latin American Literature</option>
            <option value="301">Latin American Studies</option>
            <option value="302">LGBT Studies</option>
            <option value="303">Library Science</option>
            <option value="304">Linguistics</option>
            <option value="306">Math</option>
            <option value="307">Medicine</option>
            <option value="308">Middle Eastern Studies</option>
            <option value="309">Music</option>
            <option value="310">Neuroscience and Behavioral Biology</option>
            <option value="355">Open Access</option>
            <option value="311">Philosophy</option>
            <option value="312">Physics</option>
            <option value="313">Political Science</option>
            <option value="340">Popular Literature</option>
            <option value="314">Portuguese</option>
            <option value="341">Portuguese Literature</option>
            <option value="315">Psychology</option>
            <option value="316">Public Health</option>
            <option value="317">Reference Books</option>
            <option value="319">Russian and East European Studies</option>
            <option value="320">Science (General)</option>
            <option value="321">Sociology</option>
            <option value="330">South Asian History</option>
            <option value="342">South Asian Literature</option>
            <option value="322">South Asian Studies</option>
            <option value="323">Spanish</option>
            <option value="343">Spanish Literature</option>
            <option value="324">Theater Studies</option>
            <option value="331">United States History</option>
            <option value="325">Womens Studies</option>
            <option value="364">Zotero</option>
        </select>
        <section class="people featured well well-small">
            <xsl:if test="system-page[name='index']/system-data-structure/main-content/leadership-heading != ''">
                <h2>
                    <xsl:value-of select="system-page[name='index']/system-data-structure/main-content/leadership-heading"/>
                </h2>
            </xsl:if>
            <ul class="equal-height-row">
                <xsl:apply-templates mode="person-featured" select="descendant::system-page[system-data-structure/main-content-bio/leadership/value='Yes']"/>
            </ul>
        </section>
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
                            <xsl:apply-templates mode="person" select="descendant::system-page[not(name='index' or system-data-structure/main-content-bio/leadership/value) and system-data-structure/main-content-bio != ''][not(dynamic-metadata[name='section-listing']/value='Yes')]"/>
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
                        <xsl:apply-templates mode="person" select="descendant::system-page[not(name='index' or system-data-structure/main-content-bio/leadership/value) and system-data-structure/main-content-bio != ''][not(dynamic-metadata[name='section-listing']/value='Yes')]"/>
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
        <li class="equal-height clearfix" itemtype="http://schema.org/Person">
            <xsl:attribute name="itemscope">true</xsl:attribute>
            <figure>
                <a class="thumbnail">
                    <xsl:attribute name="href">
                        <xsl:value-of select="path"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="system-data-structure/thumbnail/thumb-bio/path != '/'">
                            <img itemprop="image">
                                <xsl:attribute name="alt">Photo for 
                                    <xsl:value-of select="title"/></xsl:attribute>
                                <xsl:attribute name="src">
                                    <xsl:value-of select="system-data-structure/thumbnail/thumb-bio/path"/>
                                </xsl:attribute>
                            </img>
                        </xsl:when>
                        <xsl:when test="system-data-structure/thumbnail/photo-bio/path != '/'">
                            <img itemprop="image">
                                <xsl:attribute name="alt">Photo for 
                                    <xsl:value-of select="title"/></xsl:attribute>
                                <xsl:attribute name="src">
                                    <xsl:value-of select="system-data-structure/thumbnail/photo-bio/path"/>
                                </xsl:attribute>
                            </img>
                        </xsl:when>
                        <xsl:otherwise>
                            <img>
                                <xsl:attribute name="alt">Currently no photo for 
                                    <xsl:value-of select="title"/></xsl:attribute>
                                <xsl:attribute name="src">https://template.emory.edu/assets/images/placeholder/bio-no-photo.png</xsl:attribute>
                            </img>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </figure>
            <h3>
                <a>
                    <xsl:attribute name="itemprop">name</xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="path"/>
                    </xsl:attribute>
                    <xsl:value-of select="title"/>
                </a>
            </h3>
            <xsl:if test="system-data-structure/main-content-bio/contact/email != ''">
                <h4>
                    <a itemprop="email">
                        <xsl:attribute name="href">mailto:
                            <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/></xsl:attribute>
                        <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                    </a>
                </h4>
            </xsl:if>
            <xsl:if test="system-data-structure/main-content-bio/contact/phone != ''">
                <h4 itemprop="telephone">
                    <xsl:value-of select="system-data-structure/main-content-bio/contact/phone"/>
                </h4>
            </xsl:if>
            <h4>Subject 1, Subject 2</h4>
        </li>
    </xsl:template>
    <xsl:template match="system-page" mode="person">
        <li class="span6 equal-height" itemtype="http://schema.org/Person">
            <xsl:attribute name="itemscope">true</xsl:attribute>
            <figure>
                <a class="thumbnail">
                    <xsl:attribute name="href">
                        <xsl:value-of select="path"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="system-data-structure/thumbnail/thumb-bio/path != '/'">
                            <img>
                                <xsl:attribute name="alt">Photo for 
                                    <xsl:value-of select="title"/></xsl:attribute>
                                <xsl:attribute name="src">
                                    <xsl:value-of select="system-data-structure/thumbnail/thumb-bio/path"/>
                                </xsl:attribute>
                            </img>
                        </xsl:when>
                        <xsl:when test="system-data-structure/thumbnail/photo-bio/path != '/'">
                            <img>
                                <xsl:attribute name="alt">Photo for 
                                    <xsl:value-of select="title"/></xsl:attribute>
                                <xsl:attribute name="src">
                                    <xsl:value-of select="system-data-structure/thumbnail/photo-bio/path"/>
                                </xsl:attribute>
                            </img>
                        </xsl:when>
                        <xsl:otherwise>
                            <img>
                                <xsl:attribute name="alt">Currently no photo for 
                                    <xsl:value-of select="title"/></xsl:attribute>
                                <xsl:attribute name="src">https://template.emory.edu/assets/images/placeholder/bio-no-photo.png</xsl:attribute>
                            </img>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </figure>
            <h3>
                <a>
                    <xsl:attribute name="itemprop">name</xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="path"/>
                    </xsl:attribute>
                    <xsl:value-of select="title"/>
                </a>
            </h3>
            <xsl:if test="system-data-structure/main-content-bio/contact/email != ''">
                <h4 class="email">
                    <a itemprop="email">
                        <xsl:attribute name="href">mailto:
                            <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/></xsl:attribute>
                        <xsl:value-of select="system-data-structure/main-content-bio/contact/email"/>
                    </a>
                </h4>
            </xsl:if>
            <xsl:if test="system-data-structure/main-content-bio/contact/phone != ''">
                <h4 itemprop="telephone">
                    <xsl:value-of select="system-data-structure/main-content-bio/contact/phone"/>
                </h4>
            </xsl:if>
            <h4 class="title">Subject 1, Subject 2</h4>
        </li>
    </xsl:template>
    <xsl:template match="roletitle">
        <xsl:param name="number"/>
        <h4 class="title" itemprop="jobTitle">
            <xsl:value-of select="role"/>
        </h4>
        <div itemtype="http://schema.org/Organization">
            <xsl:attribute name="itemscope">true</xsl:attribute>
            <h4 class="org" itemprop="name">
                <xsl:value-of select="org"/>
            </h4>
        </div>
    </xsl:template>
</xsl:stylesheet>
