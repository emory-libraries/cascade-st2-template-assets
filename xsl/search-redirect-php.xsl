<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/"><xsl:comment>#START-ROOT-CODE&lt;?php // call xsl template
<xsl:apply-templates select="system-index-block/calling-page/system-page"/>
         // #END-ROOT-CODE</xsl:comment>
    </xsl:template>
    <xsl:template match="system-index-block/calling-page/system-page">[system-view:external]$system_names = array(<xsl:for-each select="system-data-structure/search-options/block/content/system-data-structure/search-option">"<xsl:value-of select="name"/>" =&gt; array(<xsl:for-each select="./*">"<xsl:value-of select="local-name()"/>" =&gt; <xsl:choose><xsl:when test="local-name() = 'name'">urlencode("<xsl:value-of select="."/>")</xsl:when><xsl:when test="local-name() = 'form-action'"><xsl:choose><xsl:when test="./page/path != '/'">"[system-asset]<xsl:value-of select="./page/link"/>[/system-asset]"</xsl:when><xsl:when test="./external != 'http://'">"<xsl:value-of select="./external"/>"</xsl:when></xsl:choose></xsl:when><xsl:otherwise>"<xsl:value-of select="."/>"</xsl:otherwise></xsl:choose> <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>)<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>);
if (array_key_exists( urlencode($_GET['system']), $system_names)) {
    $key = urlencode($_GET['system']);
    $url = $system_names["$key"]['form-action'];
    $field = $system_names["$key"]['field-id'];
    $params = $system_names["$key"]['params'];
    if ( isset($_GET['q']) || isset($_GET['library_q']) ) {
        if (isset($_GET['q'])) {
            $query = urlencode($_GET['q']);
        } else {
            $query = urlencode($_GET['library_q']);
        }
        if ($params != '') {
            if(strpos($field,'=')){
                $redirect = $url . '?' . $params . '&amp;' . $field . $query;
            } else{
                $redirect = $url . '?' . $params . '&amp;' . $field . '=' . $query;
            }
        } else {
            $redirect = $url . '?' . $field . '=' . $query;
        }
        if ($key == 'discovere' || $key == 'guides' || $key == 'ejournals' || $key == 'findingaids' || $key == 'euclid') {
            $redirect .= '&amp;libsearch=' . strtolower(urlencode('<xsl:value-of select="substring-after(site, 'Library - ')"/>'));
        }
        header('Location: '.$redirect);
    } else {
            if ($params != '') {
            $url = $url . '?' . $params . ' with a field named '.$field;  
        }
        echo 'trying to go to '.$url;
    }
}
    [/system-view:external]</xsl:template>
</xsl:stylesheet>
