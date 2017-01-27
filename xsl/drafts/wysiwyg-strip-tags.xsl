<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xd" version="1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        
    <xsl:template name="strip-wysiwyg">
        
        <!-- *************************************************************************** -->            
        <!-- reproduces WYSIWYG text, but strips every tag except:
            <a>, <p>, <b>, <strong>, <i>, <em>, <ol>, <ul>, <li>
        -->
        
        <!-- also adds a paragraph if there are no children -->

        <!-- *************************************************************************** -->
        <!-- usage example:
             1. suppose a WYSIWYG called "flex-box" exists in your data definition
             2. import this file: <xsl:import href="site://WDG Central v2/_cms/xsl/output/wysiwyg-strip-tags.xsl"/>
             3. in the place where flex-box should display, run this code:
                <xsl:if test="flex-box !=''">        
                    <xsl:apply-templates select="flex-box"/>
                </xsl:if>
             4. create a separate template for flex-box, like this:
                <xsl:template match="flex-box">
                    <xsl:call-template name="strip-wysiwyg"/>
                </xsl:template>
        -->
        
        <xsl:choose>

            <!-- *************************************************************************** -->        
            <!-- if there are no child nodes, wrap text in a paragraph and print it -->
            <xsl:when test="(child::node() = '' or node() = '') and node()[not(ancestor::p)]">
                <p>
                    <xsl:value-of select="current()"/>
               </p>
            </xsl:when>
            
            <!-- *************************************************************************** -->            
            <!-- if the current node is text() - i.e., when the name() is blank - then
                print text 
            -->
            <xsl:when test="name()=''"><xsl:value-of select="current()"/></xsl:when>


            
            <!-- *************************************************************************** -->            
            <!-- if the current node is an element, and if we've chosen to keep that element,
                then call the template on the children, wrapped in the appropriate element -->
            
            <xsl:when test="name()='a'">
                <a href="{@href}" target="{@target}">
                    <xsl:for-each select="child::node()">
                        <xsl:call-template name="strip-wysiwyg"/>
                    </xsl:for-each>
                </a>
            </xsl:when>
            
            <xsl:when test="name()='p'">
                <p>
                    <xsl:for-each select="child::node()">
                        <xsl:call-template name="strip-wysiwyg"/>
                    </xsl:for-each>
               </p>
            </xsl:when>
            
            <xsl:when test="name()='b' or name()='strong'">
                <strong>
                    <xsl:for-each select="child::node()">
                        <xsl:call-template name="strip-wysiwyg"/>
                    </xsl:for-each>
                </strong>
            </xsl:when>
            
            <xsl:when test="name()='i' or name()='em'">
                <em>
                    <xsl:for-each select="child::node()">
                        <xsl:call-template name="strip-wysiwyg"/>
                    </xsl:for-each>
                </em>
            </xsl:when>    
            
            <xsl:when test="name()='ul'">
                <ul>
                    <xsl:for-each select="child::node()">
                        <xsl:call-template name="strip-wysiwyg"/>
                    </xsl:for-each>
                </ul>
            </xsl:when>   
            
            <xsl:when test="name()='ol'">
                <ol>
                    <xsl:for-each select="child::node()">
                        <xsl:call-template name="strip-wysiwyg"/>
                    </xsl:for-each>
                </ol>
            </xsl:when>  
            
            <xsl:when test="name()='li'">
                <li>
                    <xsl:for-each select="child::node()">
                        <xsl:call-template name="strip-wysiwyg"/>
                    </xsl:for-each>
                </li>
            </xsl:when>
            
            <xsl:when test="name()='br'">
                <br/>
            </xsl:when>             
            <!-- *************************************************************************** -->                        
            <!-- if the current node is an element, but it's not an element we've chosen
                to reproduce, just call the template again on the children -->
            
            <xsl:otherwise>
                <xsl:for-each select="child::node()">
                    <xsl:call-template name="strip-wysiwyg"/>
                </xsl:for-each>
            </xsl:otherwise>
            
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
