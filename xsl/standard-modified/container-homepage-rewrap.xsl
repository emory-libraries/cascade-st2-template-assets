<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"> 
    <!-- 
       this XSLT is applied at the Configuration Set level, also interacts with the Template level XSLT to add the body class
       removes right and left "columns" divs from the template markup since they are not used by the homepage
    -->
    
    <xsl:include href="site://WDG Central v2/_cms/xsl/output/html5-boilerplate.xsl"/>

    <!-- node here comes from homepage.xsl -->
    <xsl:variable name="remove-gutters">
        <xsl:value-of select="//remove-gutters/node()"/>
    </xsl:variable>
    
    <!-- The identity transform -->
    
    <xsl:template match="@*|node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- <xsl:template match="//div[@id='left']"/>
        <xsl:template match="//div[@id='content']"/>
        <xsl:template match="//div[@id='related']"/>
    -->
    <xsl:template match="//div[@class='container']">
        <!-- select the container row -->
        <xsl:copy>
            <!-- add a class for bootstrap -->
            <xsl:attribute name="class">container</xsl:attribute>
            <!-- copy the current node contents -->
            <xsl:apply-templates select="//div[@id='emergency-alert']"/>
               <!-- <xsl:apply-templates select="//div[@id='context']"/> -->
               <div>
                <xsl:attribute name="class">row col2<xsl:if test="$remove-gutters = 'true'"> full-page</xsl:if></xsl:attribute>
                <xsl:apply-templates select="//div[@id='main-content']"/>                
            </div>
               <!-- <xsl:apply-templates select="//div[@id='related']"/> -->
        </xsl:copy>
        
    </xsl:template>
    
    
    <xsl:template match="div[@id='context']"/>

    
    <xsl:template match="div[@id='main-content']">
        <xsl:copy>
            <!-- copy the current body node contents -->
            <xsl:apply-templates select="@*|node()"/>
            <!-- output the rest -->
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="div[@id='related']"/>
        
     <!-- remove height and width attributes from all elements -->
    
    <xsl:template match="//@width[not(parent::iframe)]"/>
     <xsl:template match="//@height[not(parent::iframe)]"/>
    
    <!--  <xsl:template match="//footer">
        <xsl:copy-of select="."/>
        </xsl:template> -->
    
    <xsl:template match="remove-gutters"/> <!-- get rid of the false element created by homepages -->
    
</xsl:stylesheet>
