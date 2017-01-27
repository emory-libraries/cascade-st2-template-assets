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
       have to fix main nav classes too 
    -->
        <xsl:import href="/_cms/xsl/standard-modified/sub-nav"/>
        <xsl:variable name="theme">
            <xsl:choose>
                <xsl:when test="/system-data-structure/sources/block/content/system-index-block/calling-page/system-page/dynamic-metadata[name='theme']/value != '' and /system-data-structure/sources/block/content/system-index-block/calling-page/system-page/dynamic-metadata[name='theme']/value != 'Site default'">
                    <xsl:value-of select="/system-data-structure/sources/block/content/system-index-block/calling-page/system-page/dynamic-metadata[name='theme']/value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="/system-data-structure/sources/page/content/system-data-structure/theme[1]/topnav[1]"/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
      <xsl:param name="subnav-theme">
            <xsl:choose>
                <!-- example of switching -->
                <xsl:when test="$theme = 'goizueta'">goizueta</xsl:when>
                <xsl:otherwise>library</xsl:otherwise>
            </xsl:choose>
        </xsl:param>
    
    <xsl:output indent="yes"/>

        <xsl:template match="/">
            <xsl:apply-templates select="system-data-structure/sources/block/content"/>
        </xsl:template>

        <xsl:template match="system-data-structure/sources/block/content">
            <xsl:apply-templates select="system-index-block[@name='navigation-index']"/>
        </xsl:template>

</xsl:stylesheet>
