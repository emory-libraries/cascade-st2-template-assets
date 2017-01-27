<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" method="xml"/>
       <xsl:template match="system-data-structure">
        <xsl:apply-templates select="links"/>
    </xsl:template>
    <xsl:template match="links">   
        <xsl:if test="heading!=''">
        <h2>
            <xsl:attribute name="class">boxed-heading</xsl:attribute>
            <xsl:value-of select="heading"/>
        </h2>
        </xsl:if>
        <!-- wrap in inner container -->
        <div class="boxed-col-inner">
        <ul class="quick-links">
            <!-- conditional -->
            <xsl:for-each select="link">
                <li>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="page/name">
                                    <xsl:value-of select="page/link"/>
                                </xsl:when>
                                <xsl:when test="file/name">
                                    <xsl:value-of select="file/link"/>
                                </xsl:when>
                                <xsl:when test="external !=''">
                                    <xsl:value-of select="external"/>
                                </xsl:when>
                                
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="link-text"/>
                    </a>
                </li>
            </xsl:for-each>
        </ul>
         <!-- clear floated lists on mobile -->
            <span class="clearfix visible-phone"></span> 
        </div>
    </xsl:template>
    
</xsl:stylesheet>
