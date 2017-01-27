<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="date-converter" version="1.0" xmlns:date-converter="ext1" xmlns:xalan="http://xml.apache.org/xalan"> 
   <xsl:output indent="yes" method="xml"/>
   <xsl:variable name="allowed_characters" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_0123456789%&amp; '"/>
   <xsl:variable name="proxy-fix">http://mail.library.emory.edu:32888/</xsl:variable>
   <xsl:template match="system-index-block">
         <xsl:if test="calling-page/system-page/system-data-structure/link!=''">
          <!-- hotfix for broken proxy links, sept 2015 -->
          <xsl:variable name="db-link">
              <xsl:choose>
                  <xsl:when test="contains(calling-page/system-page/system-data-structure/link,'libcat1')">
                      <xsl:value-of select="concat($proxy-fix,substring-after(calling-page/system-page/system-data-structure/link,'http://libcat1.cc.emory.edu:32888/'))"/>
                  </xsl:when>
                  <xsl:when test="contains(calling-page/system-page/system-data-structure/link,'library.emory.edu:32888')">
                      <xsl:value-of select="concat($proxy-fix,substring-after(calling-page/system-page/system-data-structure/link,'http://library.emory.edu:32888/'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:value-of select="calling-page/system-page/system-data-structure/link"/>
                  </xsl:otherwise>
              </xsl:choose>
          </xsl:variable>
      <p><strong>Link to Database: </strong>  <a href="{$db-link}" rel="nofollow"><xsl:value-of select="$db-link"/></a></p>
</xsl:if>  
     
     <xsl:if test="calling-page/system-page/dynamic-metadata/name='new'">
     <span class="btn btn-success">New <xsl:if test="calling-page/system-page/system-data-structure/new-until!=' '"> until: <xsl:value-of select="calling-page/system-page/system-data-structure/new-until"/>
</xsl:if></span>
</xsl:if>  



     <xsl:if test="calling-page/system-page/dynamic-metadata/name='trial'">
      <span class="btn btn-info"><strong>Trial:</strong>
      <xsl:if test="calling-page/system-page/start-date!=''"><xsl:value-of select="date-converter:convertDate(number(calling-page/system-page/start-date))"/> - </xsl:if>  
           <xsl:if test="calling-page/system-page/end-date!=''"><xsl:value-of select="date-converter:convertDate(number(calling-page/system-page/end-date))"/></xsl:if> </span>
</xsl:if>    


        <ul class="inline well well-small">  
<xsl:choose> 
<xsl:when test="calling-page/system-page/system-data-structure/fulltext/value!='Yes'">
      <li><strong>Full Text:</strong>  Yes</li>
</xsl:when>
<xsl:when test="calling-page/system-page/system-data-structure/fulltext/value!='Varies'">
      <li><strong>Full Text:</strong>  Varies</li>
</xsl:when>
<xsl:otherwise>      <li><strong>Full Text:</strong>  No</li></xsl:otherwise></xsl:choose>

 <xsl:if test="calling-page/system-page/system-data-structure/coverage!=''">
<li><strong>Coverage: </strong>
                  <xsl:value-of select="calling-page/system-page/system-data-structure/coverage"/></li>
              
            </xsl:if>
            
            
 <xsl:if test="calling-page/system-page/system-data-structure/location!=''">
<li><strong>Location (for internal use only): </strong>
                  <xsl:value-of select="calling-page/system-page/system-data-structure/location"/></li>
              
            </xsl:if>
            </ul>

     
       <xsl:if test="calling-page/system-page/system-data-structure/description!=''">
 <h2>Short Description</h2>
                  <xsl:copy-of select="calling-page/system-page/system-data-structure/description/node()"/>
              
            </xsl:if>
     
            <xsl:if test="calling-page/system-page/system-data-structure/alert!=''">
 <h2>Alert or Notes Text</h2>
                  <xsl:copy-of select="calling-page/system-page/system-data-structure/alert/node()"/>
              
            </xsl:if>
           
            <h2>Subjects</h2>
            <xsl:if test="calling-page/system-page/system-data-structure/subjects/subject/name != ''">
              <ul>
                <xsl:for-each select="calling-page/system-page/system-data-structure/subjects/subject">
                    <li>
                      <xsl:value-of select="translate(name,translate(name, $allowed_characters, ''),'')"/>
                      <xsl:if test="featured/value = 'Yes'"> (featured)</xsl:if>
                    </li>
                </xsl:for-each>
              </ul>
            </xsl:if>        
   </xsl:template>

     <xsl:template match="resource-type">
      <li>
         <xsl:value-of select="."/>
      </li>
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
