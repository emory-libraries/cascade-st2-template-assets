<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="/">
    <xsl:for-each select="system-index-block/system-page">

      <xsl:if test="system-data-structure/subject/subject-dropdown != '' and system-data-structure/subjects/subject/name = ''">
        <div style="padding-bottom: 1.5em;">
          This database has old subjects but not new ones.

          <ul>
            <xsl:apply-templates select="calling-page/system-page/system-data-structure/subject/subject-dropdown"/>
          </ul>

        </div>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <xsl:template match="subject-dropdown">
    <li>
      <xsl:value-of select="."/>
    </li>
  </xsl:template>

</xsl:stylesheet>
