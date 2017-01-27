<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="site://Standard Template v2/_cms/xsl/analytics-head"/>
    <xsl:template match="system-index-block">
        <xsl:apply-templates mode="library" select="//analytics"/>
    </xsl:template>
    <xsl:template match="//analytics" mode="library">
        [system-view:external]
        <!-- InstersectionObserver polyfill for impression tracker -->
        <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=IntersectionObserver"></script>

        <!-- Google Analytics autotrack.js snippet -->
        <script>
        window.ga=window.ga||function(){(ga.q=ga.q||[]).push(arguments)};ga.l=+new Date;
        
        <!-- Build array of IDs we want to track outside of .data-entry containers (e.g. - home page)-->
        var elementIds = [{id: 'home-slider-utilities'},{id: 'footer'},{id: 'row1'}];
        
        $(document).ready(function(){

        <!-- For other pages, get all IDs within the page; useful for interior pages with IDs on headings -->
        $('.data-entry').find('[id]').not('#expandAll, #hideAll, #accordion, #toggle-all, [id^=collapse]').each(function(){
            elementIds.push({id:this.id});
            //console.log(this.id);
        });
        
        <!-- Emory's tracking ID -->
        <xsl:variable name="emory_id">UA-43397511-1</xsl:variable>
        
        <xsl:choose>
            <xsl:when test="code-snippet != ''">
                <xsl:for-each select="code-snippet">
                    <xsl:variable name="namespace">prop_<xsl:value-of select="position()"/></xsl:variable>
                    <xsl:variable name="domain">'auto'</xsl:variable>

                    ga('create', '<xsl:value-of select="."/>', <xsl:value-of select="$domain"/>,{'name':'<xsl:value-of select="$namespace"/>'});

                    <!-- check for enhanced link attribution -->
                    <xsl:if test="../enhanced-link-attribution = 'Yes'">
                        ga('<xsl:value-of select="$namespace"/>.require', 'linkid',{'levels': 5});
                    </xsl:if>
                    
                    <!-- autotrack.js plugins -->
                    ga('<xsl:value-of select="$namespace"/>.require', 'eventTracker');
                    ga('<xsl:value-of select="$namespace"/>.require', 'outboundLinkTracker');
                    ga('<xsl:value-of select="$namespace"/>.require', 'impressionTracker', {elements: elementIds});

                    <!-- send data -->
                    ga('<xsl:value-of select="$namespace"/>.send', 'pageview');
                </xsl:for-each>
    
                <!-- Begin Emory University Universal Analytics Tracking -->
                ga('create', '<xsl:value-of select="$emory_id"/>', {'name':'emory'});
                ga('emory.send', 'pageview');
                <!-- End Emory University Universal Analytics Tracking -->

            </xsl:when>
            <xsl:otherwise>
                ga('create', '<xsl:value-of select="$emory_id"/>', 'emory.edu');
                ga('send', 'pageview'); 
            </xsl:otherwise>
        </xsl:choose>
        });
        </script>
        <!-- Load analytics.js -->
        <script async="async" src="https://www.google-analytics.com/analytics.js"></script>
        <!-- Load autotrack.js -->
        <script async="async" src="https://template.library.emory.edu/js/plugins/analytics/autotrack/autotrack.js"></script>
        [/system-view:external]
    </xsl:template>
</xsl:stylesheet>
