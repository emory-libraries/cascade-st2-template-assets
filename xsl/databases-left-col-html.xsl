<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="/_cms/xsl/databases-left-col.xsl"/>

  <xsl:output indent="yes"/>

    <xsl:template match="/">
        <xsl:call-template name="databases-left-col">
            <xsl:with-param name="is-php" select="'false'"/>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
