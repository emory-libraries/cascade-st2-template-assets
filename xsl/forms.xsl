<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="java" version="1.0" xmlns:java="http://xml.apache.org/xslt/java">
    
    <xsl:import href="site://WDG Central v2/_cms/xsl/output/data-entry.xsl"/>
    <xsl:output indent="yes"/>
    
    
    
    <xsl:template match="system-index-block">
        <!-- create a data-entry div that gets removed by body XSLT after we parse it -->
        <xsl:call-template name="data-entry-wide"/>
        
        <xsl:copy-of select="calling-page/system-page/system-data-structure/announcement/node()"/>
        
       
        <div class="data-entry">
           
            <xsl:text disable-output-escaping="yes">
                    &lt;form accept-charset="utf-8" action="http://web.library.emory.edu/_api/v1/index.php/form" class="form" method="post"&gt;
                </xsl:text>
                
            <input name="re-name" type="hidden">
                <xsl:attribute name="value">
                    <xsl:value-of select="calling-page/system-page/system-data-structure/form-block/content/system-data-structure/receiver-contact/name"/>
                </xsl:attribute>
                
             </input>
            
           <input name="re-email" type="hidden">
               <xsl:attribute name="value">
                    <xsl:value-of select="calling-page/system-page/system-data-structure/form-block/content/system-data-structure/receiver-contact/email"/>
                </xsl:attribute>
            </input>
            
            <xsl:value-of disable-output-escaping="yes" select="calling-page/system-page/system-data-structure/form-block/content/system-data-structure/form_code"/>
            
            <input id="resetform" type="reset" value="reset"/>
            
            <xsl:text disable-output-escaping="yes">
                    &lt;/form&gt;
                </xsl:text>
        </div>
        <xsl:copy-of select="calling-page/system-page/system-data-structure/post/node()"/>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>
