<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xsl:template match="/">

    <ul>
    <xsl:for-each select="system-index-block/system-page[not(contains(path,'_cms'))]">
    <xsl:sort order="ascending" select="name"/>
        <li>
            <a href="{path}">
                <xsl:value-of select="title"/>
            </a>
        </li>
        </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>
