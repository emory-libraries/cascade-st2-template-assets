<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="system-index-block">
        <xsl:apply-templates select="calling-page/system-page/system-data-structure"/>
    </xsl:template>

    <xsl:template match="system-data-structure">
        <div>
            <!-- add class for wide/no rt col -->
            <xsl:attribute name="class">data-entry <xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'">wide</xsl:if></xsl:attribute>
            <!-- optional overview -->
            <xsl:if test="main-content/descendant::*">
                <xsl:apply-templates select="main-content"/>
            </xsl:if>
                    <div class="clearfix" id="section-faq">
                            <ul>
                                <xsl:for-each select="section-content">
                                    <li>
                                        <a>
                                            <xsl:attribute name="href">#faq<xsl:value-of select="position()"/></xsl:attribute>
                                            <xsl:value-of select="heading"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        <!--    <p id="faq-controls"><a class="btn" id="expandAll">Show All Answers</a>  <a class="btn" id="hideAll">Hide All Answers</a></p> -->
                        <!-- anchors first, then answers -->
                        <xsl:apply-templates mode="faq" select="section-content"/>
                      <!--  <script src="/js/faq-toggle.js"></script> -->
                    </div>
        </div>
        <!-- end outer data-entry div -->
    </xsl:template>

    <xsl:template match="main-content">
         <xsl:copy-of select="main/node()"/>
    </xsl:template>

     <xsl:template match="section-content" mode="faq">
            <!-- process each section-content: note classnames are used by JS for expand/collapse -->
            <section class="faq clearfix" id="faq{position()}">
                <xsl:choose>
                    <xsl:when test="heading=''">
                        <h2><a>
                            <xsl:attribute name="id">faq-question<xsl:value-of select="position()"/></xsl:attribute>[system-view:internal]Please enter a
                            Heading/Question [/system-view:internal]</a></h2>
                   </xsl:when>
                    <xsl:otherwise>
                        <h2 class="faq-question">
                        <a>
                            <xsl:attribute name="id">faq-question<xsl:value-of select="position()"/></xsl:attribute>
                                <xsl:value-of select="heading"/>
                        </a>
                            </h2>
                    </xsl:otherwise>
                </xsl:choose>
                <div class="wysiwyg faq-answer">
                    <xsl:copy-of select="main/node()"/>
                </div>
                <p class="back-to-top"><a href="#">Back to top</a></p>
            </section>
    </xsl:template>

</xsl:stylesheet>
