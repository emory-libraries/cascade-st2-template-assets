<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- this XSLT reprocesses the standard footer block to remove span tags -->
   <xsl:import href="/_cms/xsl/components/ask-a-librarian.xsl"/>
    <xsl:template match="/">
        <section class="footer-hat span12">
            <xsl:apply-templates select="//system-index-block/system-page/system-data-structure/footer/component"/>
            <xsl:apply-templates select="//system-index-block/system-page/system-data-structure/social-media"/>
        </section>
    </xsl:template>
    <xsl:template match="social-media">
        
          <xsl:call-template name="component"/>
        
    </xsl:template>
    <xsl:template match="component" name="component">
        <div class="component span3">
            <xsl:if test="position()=1 and not(self::social-media)">
                <xsl:attribute name="class">
                    <xsl:text>component span3 alpha</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <article>
                <xsl:if test="descendant-or-self::title!='' and not(name='ask-a-librarian')">
                    <h2>
                        <xsl:value-of select="descendant-or-self::title"/>
                    </h2>
                </xsl:if>
                <xsl:if test="descendant-or-self::entry/heading!=''">
                    <h2>
                        <xsl:value-of select="descendant-or-self::entry/heading"/>
                    </h2>
                </xsl:if>
                <xsl:if test="descendant-or-self::entry/thumbnail/path !='/'">
                    <xsl:apply-templates select="thumbnail"/>
                </xsl:if>
                <!-- Hours -->
                <xsl:if test="name='hours-component'">
                    <div class="hours-component">
                        <xsl:variable name="path">
                            <xsl:value-of select="./content/system-data-structure/hours-page/path"/>
                        </xsl:variable>
                        <xsl:variable name="page">
                            <xsl:choose>
                                <xsl:when test="./content/system-data-structure/hours-full-listing/path != '/'">
                                    <xsl:value-of select="./content/system-data-structure/hours-full-listing/path"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="./content/system-data-structure/hours-page/path"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="prefix">
                            <xsl:choose>
                                <xsl:when test="./content/system-data-structure/prefix != ''">
                                    <xsl:value-of select="./content/system-data-structure/prefix"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>http://staging.web.emory.edu/librariestemplate</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="url">
                            <xsl:value-of select="$path"/>
                            <xsl:text>.xml</xsl:text>
                        </xsl:variable>
                        [system-view:internal]                                                     
                        <!--<ul class="footer-hours">
                            <li>Today</li>
                            <li>12:30pm - 10:45am</li>
                        </ul>
                        <ul>
                            <li>Tomorrow</li>
                            <li>Open 24 Hours</li>
                        </ul>
                        <ul>
                            <li>Sat, 3 Aug</li>
                            <li>8pm - 2:30am</li>
                        </ul>
                        <p>
                            <small>
                                <xsl:text>(This is a placeholder, the hours on the published site will reflect those found at </xsl:text>
                                <span style="word-break:break-all;">
                                    <xsl:value-of select="$url"/>
                                </span>
                                <xsl:text>)</xsl:text>
                            </small>
                        </p>-->
                        [/system-view:internal]
                                               
                        <section class="footer-hours">
                            <xsl:attribute name="data-url">
                                <xsl:value-of select="$prefix"/>
                                <xsl:value-of select="$url"/>
                            </xsl:attribute>
                            <p>For library hours, view the table below.</p>
                        </section>
                                                
                        <aside class="hours-link">
                            <ul>
                                <li>
                                    <a>
                                        <xsl:attribute name="href">[system-asset]<xsl:value-of select="$page"/>[/system-asset]</xsl:attribute>View Table of All Hours
                                    </a>
                                </li>
                            </ul>
                        </aside>
                    </div>
                </xsl:if>
                <!-- Social Media -->
                <xsl:if test="self::social-media">
                    
                    <xsl:choose>
                        <xsl:when test="//alt-right-col/override-social/value='Yes'">
                            <xsl:apply-templates select="//alt-right-col"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="social-media"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <!-- Directions -->
                <xsl:if test="name='directions-block'">
                    <xsl:call-template name="directions"/>
                </xsl:if>
                <!-- Ask a Librarian -->
                <xsl:if test="descendant::name='ask-a-librarian'">
                    <xsl:apply-templates select="descendant::system-data-structure/ask-a-librarian"/>
                </xsl:if>
                <p>
                    <xsl:copy-of select="descendant-or-self::entry/body-content/text()"/>
                </p>
            </article>
        </div>
    </xsl:template>
    <xsl:template match="thumbnail">
        <img>
            <xsl:attribute name="src">
                <xsl:copy-of select="path/text()"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:value-of select="caption"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="caption"/>
            </xsl:attribute>
        </img>
    </xsl:template>
    <xsl:template name="social-media">
        <h2>Connect with Us</h2>
        <ul class="social-icons">
            <xsl:for-each select="//system-index-block/system-page/system-data-structure/social-media/social-profile">
                <xsl:variable name="social">
                    <xsl:value-of select="translate(type, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                </xsl:variable>
                <xsl:variable name="href">
                    <xsl:value-of select="./external"/>
                </xsl:variable>
                <xsl:variable name="name">
                    <xsl:choose>
                        <xsl:when test="./name !=''">
                            <xsl:value-of select="./name"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./type"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="social-icon">
                    <xsl:choose>
                        <xsl:when test="$social = 'youtube'">
                            <xsl:text>icon-youtube-play</xsl:text>
                        </xsl:when>
                        <xsl:when test="$social = 'itunesu'">
                            <xsl:text>icon-music</xsl:text>
                        </xsl:when>
                        <xsl:when test="$social = 'blog'">
                            <xsl:text>icon-comment</xsl:text>
                        </xsl:when>
                        <xsl:when test="$social = 'other'">
                            <xsl:choose>
                                <xsl:when test="./name = 'Pinterest' or ./name = 'Instagram' or ./name = 'Dropbox' or ./name = 'Skype' or ./name = 'Flickr' or ./name = 'Tumblr' or ./name = 'Foursquare' or ./name = 'Github'">
                                    <xsl:text>icon-</xsl:text>
                                    <xsl:value-of select="translate(./name, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                                </xsl:when>
                                <xsl:when test="./name = 'Google Plus' or ./name = 'Google+' or ./name = 'Google plus' or ./name = 'Google-Plus'">
                                    <xsl:text>icon-google-plus</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>icon-external-link-sign</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>icon-</xsl:text>
                            <xsl:value-of select="$social"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <li>
                    <a href="{$href}" rel="external">
                        <span class="{$social-icon}">
                            <xsl:text/>
                        </span>
                        <xsl:value-of select="$name"/>
                    </a>
                </li>
            </xsl:for-each>
            <xsl:if test="//system-index-block/system-page/system-data-structure/footer/image/path !='/'">
                <div class="footer-accent">
                    <img>
                        <xsl:attribute name="src">
                            <xsl:value-of select="//system-index-block/system-page/system-data-structure/footer/image/link"/>
                        </xsl:attribute>
                    </img>
                </div>
            </xsl:if>
        </ul>
    </xsl:template>
    <xsl:template name="directions">
        <xsl:for-each select="content/system-data-structure/address">
            <div class="address">
                <h4>
                    <xsl:value-of select="name"/>
                </h4>
                <xsl:if test="flex-entry != ''">
                    <xsl:copy-of select="flex-entry/node()"/>
                </xsl:if>
                <p>
                    <xsl:value-of select="street-address"/>
                    <xsl:if test="city!='' and state!=''">
                        <br/>
                    </xsl:if>
                    <xsl:value-of select="city"/>
                    <xsl:if test="city!='' and state!=''">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="state"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="zip-code"/>
                    <xsl:if test="phone!=''">
                        <br/>
                    </xsl:if>
                    <xsl:value-of select="phone"/>
                </p>
            </div>
        </xsl:for-each>
        <xsl:value-of disable-output-escaping="yes" select="//footer/component/content/system-data-structure/map-embed-code"/>
    </xsl:template>
    <xsl:template name="ask-a-librarian">
        <h2>Ask a Librarian</h2>
        <a class="ask-a-librarian">
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="content/system-data-structure/ask-a-librarian/page/path!='/'">
                        <xsl:value-of select="content/system-data-structure/ask-a-librarian/page/path"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>#</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <img>
                <xsl:attribute name="alt">
                    <xsl:text>Ask a Librarian Logo</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="src">
                    <xsl:choose>
                        <xsl:when test="content/system-data-structure/ask-a-librarian/image-override/path != '/'">                            [system-asset]                            
                            <xsl:value-of select="content/system-data-structure/ask-a-librarian/image-override/path"/>
                            [/system-asset]                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="content/system-data-structure/ask-a-librarian/image-url"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </img>
        </a>
    </xsl:template>
    <xsl:template name="string-replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="by"/>
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$by"/>
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="by" select="$by"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="alt-right-col">
        <div>
        <xsl:attribute name="class">
            <xsl:text>right-col-bg</xsl:text>
        </xsl:attribute>
        <xsl:if test="image/path!='/'">
            <xsl:attribute name="style">
                <xsl:text>background-image:url('</xsl:text><xsl:value-of select="image/path"/><xsl:text>');</xsl:text>
            </xsl:attribute>
            
        </xsl:if>
        <h2>
            <xsl:value-of select="heading"/>
        </h2>
        <section>
            <xsl:copy-of select="content/node()"/>
        </section>
        </div>
    </xsl:template>
    
</xsl:stylesheet>
