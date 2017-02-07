<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="date-converter" version="1.0" xmlns:date-converter="ext1" xmlns:xalan="http://xml.apache.org/xalan"> 
    <xsl:import href="/_cms/xsl/standard-modified/homepage-gbl.xsl"/>
    <xsl:variable name="proxy-fix">http://mail.library.emory.edu:32888/</xsl:variable>
    
    <xsl:output indent="yes" method="xml"/>
    <xsl:template match="system-index-block">
        <!-- Search -->
        <xsl:if test="descendant::search-box/path !='/'">
            <xsl:apply-templates mode="database-page" select="descendant::search-box"/>
        </xsl:if>
        <!-- End Search -->
        
        <!-- logo -->
        <xsl:if test="//calling-page/system-page/system-data-structure/logo/path!='/'">
            <figure class="pull-right" id="database-logo">
                <img class="img-polaroid" src="{//calling-page/system-page/system-data-structure/logo/link}"/>
            </figure>
        </xsl:if>
        <h1><xsl:value-of select="//calling-page/system-page/title"/></h1>
        <!-- short description -->
        <xsl:if test="//calling-page/system-page/system-data-structure/short-description!=''">
            <section class="clearfix">
                <p><xsl:value-of select="//calling-page/system-page/system-data-structure/short-description"/><xsl:text> </xsl:text></p>
                <p><a href="#description">More details below <span class="fa fa-angle-double-right"></span></a></p>
            </section>
        </xsl:if>       
        
        <!-- notices -->
        <xsl:if test="//calling-page/system-page/system-data-structure/notices/notice/notice-message!=''">
            <xsl:apply-templates select="//calling-page/system-page/system-data-structure/notices/notice"/>
        </xsl:if>
        
        <!-- access info -->
        <xsl:apply-templates select="//calling-page/system-page/system-data-structure/access"/>
        
        <!-- description -->
        <xsl:if test="//calling-page/system-page/system-data-structure/description!=''">
            <a name="description"></a>
            <section class="clearfix">
                <xsl:copy-of select="//calling-page/system-page/system-data-structure/description/node()"/>
            </section>
        </xsl:if>
        
        <!-- help -->
        <xsl:if test="//calling-page/system-page/system-data-structure/help/start-help-content != '' or //calling-page/system-page/system-data-structure/help/end-help-content !='' or //calling-page/system-page/system-data-structure/help/resource-links/resource-link/link-label != ''">        
            <xsl:apply-templates select="//calling-page/system-page/system-data-structure/help"/>
        </xsl:if>
        
        <!-- more databases like this -->
        <xsl:if test="//calling-page/system-page/system-data-structure/databases-like-this/database/title !=''">
            <aside class="related-databases metadata">
                <h2>More Databases Like This</h2>
                <ul class="inline">
                    <xsl:apply-templates select="//calling-page/system-page/system-data-structure/databases-like-this/database"/>
                </ul>
            </aside>
        </xsl:if>
        
        <!-- subjects -->
        <xsl:if test="//calling-page/system-page/system-data-structure/subjects/subject/name != '--Select a Subject--'">
            <div class="subjects metadata">
                <h2>Subjects</h2>
                <ul class="inline">
                    <xsl:apply-templates select="//calling-page/system-page/system-data-structure/subjects/subject/name"/>
                </ul>
            </div>
        </xsl:if>
        <!-- Report a Problem -->
        <h2>Report a Problem</h2>
        <xsl:copy-of select="//system-index-block/system-block[name='report-a-problem']/block-xhtml/node()"/>
        
    </xsl:template>
    
    <!-- notices template-->
    <xsl:template match="notice">
        <section class="clearfix">
            <!-- apply classes based on notice type -->
            <xsl:attribute name="class">alert alert-block <xsl:choose><xsl:when test="notice-type='Note'">alert-info</xsl:when><xsl:when test="notice-type='Alert'">alert-error</xsl:when></xsl:choose></xsl:attribute>
            
            <!-- notice message -->
            <xsl:copy-of select="notice-message/node()"/>
        </section>
    </xsl:template>
    
    <!-- access types template-->
    <xsl:template match="access">
        <section class="database-access clearfix">
            <div class="equal-height-row clearfix">
                <!-- on-campus details -->
                <xsl:apply-templates select="on-campus"/>
                <!-- off-campus details -->
                <xsl:apply-templates select="off-campus"/>
            </div>
            
            <!-- determine if NetID is an access type and display NetID help info -->
            <xsl:if test="(contains(off-campus/access-type,'Emory NetID') and not(off-campus/database-down/value = 'Yes')) or (contains(on-campus/access-type,'Emory NetID') and not(on-campus/database-down/value = 'Yes'))">
                <section class="alert alert-info accordion-group clearfix" id="netid-info">
                    
                    <h4 class="accordion-heading">
                        <a class="accordion-toggle" data-parent="#accordion" data-toggle="collapse">What is an Emory NetID?</a>
                    </h4>
                    <div class="accordion-body collapse" id="netid">
                        <xsl:copy-of select="//system-index-block/system-block[name='emory-netid-info']/block-xhtml/node()"/>
                    </div>
                </section>
            </xsl:if>
        </section>
        
        <!-- disclaimer -->
        <section class="clearfix muted" id="access-disclaimer">
            <xsl:copy-of select="//system-index-block/system-block[name='usage-disclaimer-wysiwyg']/block-xhtml/node()"/>
        </section>
    </xsl:template>
    
    <!-- on-campus access details template-->
    <xsl:template match="on-campus">
        <div class="well well-small span6 equal-height">
            <!-- check if access is available; if not, change heading display; if so, add link and details -->
            <xsl:choose>
                <xsl:when test="access-type = 'Not Available'">
                    <h3>Not Available On-campus</h3>
                </xsl:when>
                <xsl:otherwise>
                    <!-- check if database is down temporarily -->
                    <xsl:choose>
                        <xsl:when test="database-down/value = 'Yes'">
                            <h3 class="text-error">On-campus Access is Temporarily Unavailable</h3>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="access-link = ''">
                                    <h3>On-campus Access</h3>
                                </xsl:when>
                                <xsl:otherwise>
                                    <h3><a><xsl:attribute name="rel"><xsl:if test="new-window='Yes'">external </xsl:if>nofollow</xsl:attribute><xsl:attribute name="href"><!-- hotfix for broken proxy links, sept 2015 --><xsl:choose><xsl:when test="contains(access-link,'libcat1')"><xsl:value-of select="$proxy-fix"/><xsl:value-of select="substring-after(access-link,'http://libcat1.cc.emory.edu:32888/')"/></xsl:when><xsl:otherwise><xsl:value-of select="access-link"/></xsl:otherwise></xsl:choose></xsl:attribute>On-campus Access<xsl:if test="new-window='Yes'"> <span class="fa fa-external-link"></span></xsl:if></a></h3>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:call-template name="access-details"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <!-- off-campus access details template-->
    <xsl:template match="off-campus">
        <div class="well well-small span6 equal-height">
            <!-- check if access is available; if not, change heading display; if so, add link and details -->
            <xsl:choose>
                <xsl:when test="access-type = 'Not Available'">
                    <h3>Not Available Off-campus</h3>
                </xsl:when>
                <xsl:otherwise>
                    <!-- check if database is down temporarily -->
                    <xsl:choose>
                        <xsl:when test="database-down/value = 'Yes'">
                            <h3 class="text-error">Off-campus Access is Temporarily Unavailable</h3>
                        </xsl:when>
                        <xsl:otherwise>
                            <h3><a rel="external nofollow"><xsl:attribute name="rel"><xsl:if test="new-window='Yes'">external </xsl:if>nofollow</xsl:attribute><xsl:attribute name="href"><!-- hotfix for broken proxy links, sept 2015 --><xsl:choose><xsl:when test="contains(access-link,'libcat1')"><xsl:value-of select="$proxy-fix"/><xsl:value-of select="substring-after(access-link,'http://libcat1.cc.emory.edu:32888/')"/></xsl:when><xsl:otherwise><xsl:value-of select="access-link"/></xsl:otherwise></xsl:choose></xsl:attribute>Off-campus Access<xsl:if test="new-window='Yes'"> <span class="fa fa-external-link"></span></xsl:if></a></h3>
                            <xsl:call-template name="access-details"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <!-- access details template-->
    <xsl:template name="access-details">
        <!-- access type -->
        
        <xsl:choose>
            <xsl:when test="access-type = 'Unique Password' or access-type = 'Get Passwords Here' or access-type = 'Library Computer Use with Unique Password'">
                <!-- special messages based on access types -->
                <xsl:variable name="access-type">
                    <xsl:choose>
                        <xsl:when test="access-type = 'Unique Password'">Get Passwords Here</xsl:when>
                        <xsl:otherwise><xsl:value-of select="access-type"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <p><strong>Required:</strong>&#160;<a href="{password-link}"><xsl:value-of select="$access-type"/></a></p>
            </xsl:when>
            <xsl:otherwise>
                <p><strong>Required:</strong>&#160;<xsl:value-of select="access-type"/></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- help details template -->
    <xsl:template match="help">
        <section>
            <h2>Need Help?</h2>
            <xsl:if test="start-help-content != ''">
                <xsl:copy-of select="start-help-content/node()"/>
            </xsl:if>
            <xsl:if test="resource-links/resource-link/link-label !=''">
                <xsl:if test="resource-links/heading!=''">
                    <xsl:choose>
                        <xsl:when test="resource-links/heading-level = 'Heading 2'">
                            <h2>
                                <xsl:value-of select="resource-links/heading"/>
                            </h2>
                        </xsl:when>
                        <xsl:when test="resource-links/heading-level = 'Heading 3'">
                            <h3>
                                <xsl:value-of select="resource-links/heading"/>
                            </h3>
                        </xsl:when>
                        <xsl:when test="resource-links/heading-level = 'Heading 4'">
                            <h4>
                                <xsl:value-of select="resource-links/heading"/>
                            </h4>
                        </xsl:when>
                        <xsl:when test="resource-links/heading-level = 'Heading 5'">
                            <h5>
                                <xsl:value-of select="resource-links/heading"/>
                            </h5>
                        </xsl:when>
                        <xsl:when test="resource-links/heading-level = 'Heading 6'">
                            <h6>
                                <xsl:value-of select="resource-links/heading"/>
                            </h6>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if> 
                <ul>
                    <xsl:for-each select="descendant::resource-link">
                        <xsl:variable name="url">
                            <xsl:choose>
                                <xsl:when test="internal-page/path != '/'"><xsl:value-of select="internal-page/link"/></xsl:when>
                                <xsl:when test="external-link != ''"><xsl:value-of select="external-link"/></xsl:when>
                                <xsl:when test="document/path != '/'"><xsl:value-of select="document/link"/></xsl:when>
                            </xsl:choose>    
                        </xsl:variable>
                        <xsl:variable name="icon">
                            <xsl:choose>
                                <xsl:when test="external-link != ''">fa fa-external-link</xsl:when>
                                <xsl:when test="document/path != '/'">fa fa-file-text-o</xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <li><a href="{$url}"><xsl:value-of select="link-label"/></a><xsl:text> </xsl:text><span class="{$icon}"></span></li>
                    </xsl:for-each>
                </ul>
            </xsl:if>
            <xsl:if test="end-help-content != ''">
                <xsl:copy-of select="end-help-content/node()"/>
            </xsl:if>
        </section>
    </xsl:template>
    
    
    <!-- subjects template -->
    <xsl:template match="name">
        <li><a href="index.php?subject={.}"><xsl:value-of select="."/></a></li>
    </xsl:template>
    
    <!-- more databases like this template -->
    <xsl:template match="database">
        <li><a href="{link}"><xsl:value-of select="title"/></a></li>
    </xsl:template>
    
    <!-- resource-type template -->    
    <xsl:template match="resource-type">
        <li><xsl:value-of select="."/></li>
    </xsl:template>
    
    <xalan:component functions="convertDate" prefix="date-converter">  
        <xalan:script lang="javascript">  
            function convertDate(date)  
            {  
            var d = new Date(date);  
            // Splits date into components  
            var temp = d.toString().split(' ');  
            // timezone difference to GMT  
            var timezone = temp[5].substring(3);  
            // RSS 2.0 valid pubDate format  
            var retString =  temp[1] + ' ' + temp[2];  
            return retString;  
            }  
        </xalan:script>
    </xalan:component>
</xsl:stylesheet>
