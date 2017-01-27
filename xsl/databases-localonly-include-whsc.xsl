<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:variable name="allowed_characters" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_0123456789%&amp; '"/>
 
    <xsl:template match="/">
        <xsl:value-of select="count(system-index-block/system-page[system-data-structure/whsc/include/value = 'Yes'])"/>
        <ul>
        <xsl:for-each select="system-index-block/system-page">
     
            <xsl:if test="system-data-structure/whsc/include/value = 'Yes'">
    
                <li>
                <p><a href="{path}"><xsl:value-of select="name"/></a></p>
                
               <div class="subjects_new"><xsl:for-each select="system-data-structure/subjects/subject">
                    <xsl:value-of select="translate(name,translate(name, $allowed_characters, ''),'')"/>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each></div>
                
                <div class="subjects_old muted">
                    <xsl:if test="system-data-structure/subject/subject-dropdown != ''">
                    <small>
                        <xsl:for-each select="system-data-structure/subject/subject-dropdown">
                            <xsl:value-of select="translate(.,translate(., $allowed_characters, ''),'')"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </small>
                    </xsl:if>
                </div>
                </li>
</xsl:if>
        </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>
