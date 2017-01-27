<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- 
        
        written by Emily Porter, OIT Web Design Group, Emory University 2009 - 2012
        
        you are here indicators work to the depth that your folder index is set to. typically 3 - 4.
        
        top level section index can be excluded.
        
        adding alt-subnav-title variant (recommend using that for references)
        
        exclusion of entire folders based on unique metadata
        
        external links open in new window
        
        dynamic metadata may not get created unless populated, so need to use not() based filter method:
        not(dynamic-metadata[name='subnav-exclude']/value='Yes')
        not(dynamic-metadata[name='exclude_folder']/value='Yes')

    -->
    
    <xsl:output indent="yes"/>
    <xsl:param name="subnav-theme"/><!-- if we are importing, we need to send a subnav theme -->    
    
    <xsl:template match="system-index-block">

        <xsl:variable name="is-section"> <!-- we need all the section page types here -->
            <xsl:if test="//system-page[@current='true']/system-data-structure/@definition-path = 'section-pages/section-page' or //system-page[@current='true']/system-data-structure/@definition-path = 'interior-pages/library-full-contact-listing'">true</xsl:if>
        </xsl:variable>

        <xsl:if test="system-folder[not(dynamic-metadata[name='exclude_folder']/value='Yes')][descendant-or-self::*[@current='true' and not(@reference)]][system-page[name='index']]">
            <!-- !!! this script requires default page name of index !!! -->
            <nav id="sub-nav" role="navigation">
                <xsl:if test="$subnav-theme != ''">
                    <xsl:attribute name="class"><xsl:value-of select="$subnav-theme"/></xsl:attribute>
                </xsl:if>
                <ul id="section-nav">
                    <xsl:apply-templates mode="level1" select="system-folder[not(dynamic-metadata[name='exclude_folder']/value='Yes')][descendant-or-self::*[@current='true' and not(@reference)]][system-page[name='index']]">
                        <xsl:with-param name="is-section" select="$is-section"/>
                    </xsl:apply-templates>
                    <!-- level one folder with a descendant @ current -->
                </ul>
            </nav>
        </xsl:if>        
    </xsl:template>   

    <xsl:template match="system-folder" mode="level1">
        <xsl:param name="is-section"/>
        <xsl:variable name="selected">
            <xsl:choose>
                <xsl:when test="system-page[@current='true'][name='index']">selected-section selected-page</xsl:when>
                <xsl:when test="system-page[name='index']">selected-section</xsl:when>
            </xsl:choose>

        </xsl:variable>

        <!-- main index can be disabled from listing -->
        <xsl:if test="system-page[name='index' and not(dynamic-metadata[name='subnav-exclude']/value='Yes')]">
            <li>
                    <xsl:attribute name="class"><xsl:value-of select="$selected"/></xsl:attribute>
                
                <xsl:call-template name="nav-link-index">
                    <xsl:with-param name="selected" select="$selected"/>
                    <xsl:with-param name="is-section" select="$is-section"/>
                </xsl:call-template>
            </li>
        </xsl:if>
        <xsl:apply-templates mode="sub" select="system-page[name !='index'][not(dynamic-metadata[name='subnav-exclude']/value='Yes')] | system-page[name ='index' and @reference='true'][not(dynamic-metadata[name='subnav-exclude']/value='Yes')] | system-symlink[not(dynamic-metadata[name='subnav-exclude']/value='Yes')] | system-folder[not(dynamic-metadata[name='exclude_folder']/value='Yes')][system-page[name='index' and not(dynamic-metadata[name='subnav-exclude']/value='Yes')]]">
            <xsl:with-param name="is-section" select="$is-section"/>
        </xsl:apply-templates>
        <!-- sibling pages at level 1 (called as sub mode) and level 2 folders -->
    </xsl:template>
    
    <xsl:template match="system-page | system-symlink" mode="level1">
        <li>
            <!-- allow level one pages not named index to show as active -->
            <xsl:if test="@current='true' and name!='index'">
                <xsl:attribute name="class">selected-page</xsl:attribute>
            </xsl:if>
            <xsl:call-template name="nav-link"/>
        </li>
    </xsl:template>
    
    <xsl:template match="system-folder" mode="sub">
        <xsl:param name="is-section"/>
        <xsl:variable name="selected">
            <xsl:choose>
                <xsl:when test="system-page[name='index'][not(@reference)][@current='true']">selected-folder selected-page</xsl:when>
                <xsl:when test="(@current='true' and not(@reference)) or (descendant::*[@current='true' and not(@reference)])">selected-folder</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <li>
            <xsl:if test="$selected != ''">
                <xsl:attribute name="class"><xsl:value-of select="$selected"/></xsl:attribute>
            </xsl:if>
            
            <xsl:call-template name="nav-link-index">
                <xsl:with-param name="selected" select="$selected"/>
                <xsl:with-param name="is-section" select="$is-section"/>
            </xsl:call-template>
            <!-- avoid empty subfolder expanding  -->
            <xsl:variable name="countCurrent">
                <xsl:value-of select="count(system-page[not(dynamic-metadata[name='subnav-exclude']/value='Yes')] | system-symlink[not(dynamic-metadata[name='subnav-exclude']/value='Yes')] | system-page[name ='index' and @reference='true'][not(dynamic-metadata[name='subnav-exclude']/value='Yes')] | system-folder[system-page[name='index'][not(@reference)][not(dynamic-metadata[name='subnav-exclude']/value='Yes')]])"/>
            </xsl:variable>
            
            <!-- DEBUG: <xsl:value-of select="$countCurrent"/> -->
            <xsl:if test="$countCurrent &gt; 1">
            <!-- if at current, and children (folders or pages) @current - nested "selected" on state -->
            <xsl:if test="(descendant::system-page[@current='true' and not(@reference)]) or (descendant::system-folder[@current='true'])">    
                    <ul>
                        <xsl:apply-templates mode="sub2" select="system-folder[system-page[name='index'][not(@reference)][not(dynamic-metadata[name='subnav-exclude']/value='Yes')]] | system-page[name != 'index'][not(dynamic-metadata[name='subnav-exclude']/value='Yes')] | system-page[@reference][not(dynamic-metadata[name='subnav-exclude']/value='Yes')] | system-symlink[not(dynamic-metadata[name='subnav-exclude']/value='Yes')]">
                            <xsl:with-param name="is-section" select="$is-section"/>
                        </xsl:apply-templates>
                        <!-- this displays in the subfolders/pages: max depth = specified in index block -->
                    </ul>                
            </xsl:if>
            </xsl:if>
        </li>
    </xsl:template>
    
    <xsl:template match="system-folder" mode="sub2">
        <xsl:param name="is-section"/>
        <li>
            <xsl:if test="(@current='true' and not(@reference)) or descendant::*[@current='true'][not(@reference)]">
                <xsl:attribute name="class">selected-page</xsl:attribute>
            </xsl:if>
            <xsl:call-template name="nav-link-index">
                <xsl:with-param name="is-section" select="$is-section"/>
            </xsl:call-template>
        </li>
    </xsl:template>      
    
    <xsl:template match="system-page | system-symlink" mode="sub">
        <li>
            <!-- index page will never be processed here. use this rule to avoid false sibling selected -->
            <xsl:if test="@current='true' and name!='index'">
                <xsl:attribute name="class">selected-page</xsl:attribute>
            </xsl:if>
            <xsl:call-template name="nav-link"/>
        </li>
    </xsl:template>
    
    <!-- level 3.5 -->
    
    <xsl:template match="system-page | system-symlink" mode="sub2">
        <li>
            <!-- index page will never be processed here. use this rule to avoid false sibling selected -->
            <xsl:if test="@current='true' and name!='index'">
                <xsl:attribute name="class">selected-page</xsl:attribute>
            </xsl:if>
            <xsl:call-template name="nav-link"/>
        </li>
    </xsl:template>
    
    <!-- named templates for processing links -->
    
    <xsl:template name="nav-link">
        <a>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="system-data-structure/url != ''">
                        <xsl:value-of select="system-data-structure/url"/>
                    </xsl:when>
                    <xsl:when test="@reference='true'">
                        <xsl:value-of select="link"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="path"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="dynamic-metadata/value='Open in New Window'">
                <xsl:attribute name="target">
                    <xsl:text>_blank</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="dynamic-metadata[name='alt-subnav-title']/value!=''">                       
                    <xsl:value-of select="dynamic-metadata[name='alt-subnav-title']/value"/>                  
                </xsl:when>
                <xsl:when test="display-name!=''">                       
                    <xsl:value-of select="display-name"/>                  
                </xsl:when>
                <xsl:when test="title!=''"><!-- title is required for most pages -->                       
                    <xsl:value-of select="title"/>                  
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name"/>
                </xsl:otherwise>
            </xsl:choose>
        </a> 
    </xsl:template>
    
    <xsl:template name="nav-link-index">
        <xsl:param name="selected"/>
        <xsl:param name="is-section"/>
        <a href="{path}/index">
            <xsl:choose>
            <!-- additional override scenario for referenced assets that use the alt title -->
                <xsl:when test="dynamic-metadata[name='alt-subnav-title']/value!='' and @reference and display-name!=''">                       
                    <xsl:value-of select="display-name"/>                  
                </xsl:when>
                <xsl:when test="system-page[name='index'][not(@reference)]/dynamic-metadata[name='alt-subnav-title']/value!=''">
                    <xsl:value-of select="system-page[name='index'][not(@reference)]/dynamic-metadata[name='alt-subnav-title']/value"/>
                </xsl:when>
                <xsl:when test="system-page[name='index'][not(@reference)]/display-name!=''">
                    <xsl:value-of select="system-page[name='index'][not(@reference)]/display-name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="system-page[name='index'][not(@reference)]/title"/> 
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:choose>
                <xsl:when test="contains(concat(' ', normalize-space($selected), ' '), ' selected-section ')"/>
                <xsl:when test="contains(concat(' ', normalize-space($selected), ' '), ' selected-folder ')">
                    <xsl:if test="$is-section != 'true'">
                        <span class="icon-angle-down"></span>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <span class="icon-angle-right"></span>
                </xsl:otherwise>
            </xsl:choose>

        </a>
    </xsl:template>

    
</xsl:stylesheet>
