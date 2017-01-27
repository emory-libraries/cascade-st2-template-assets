<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:variable name="photo-alt">
        <xsl:value-of select="//first_main"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="//last_main"/>
    </xsl:variable>
    <xsl:variable name="photo-align">pull-right</xsl:variable>
    <!-- pull right or left? -->
    <xsl:variable name="contact-heading">Additional Contact Information</xsl:variable>
    <xsl:variable name="websites-heading">Additional Websites</xsl:variable>
    <xsl:variable name="teaching-heading">Teaching</xsl:variable>
    <xsl:variable name="research-heading">Research</xsl:variable>
    <xsl:variable name="publications-heading">Publications</xsl:variable>
    <xsl:variable name="attachments-heading">Attachments Heading TBD</xsl:variable>
    <xsl:template match="system-index-block">
        <xsl:apply-templates select="calling-page/system-page/system-data-structure"/>
    </xsl:template>
    <xsl:template match="system-data-structure">
        <article class="person" itemtype="http://schema.org/Person">
            <xsl:attribute name="itemscope">true</xsl:attribute>
            <h1 id="title-heading" itemprop="name">
                <system-page-title/>
            </h1>
            <div>
                <!-- add class for wide/no rt col -->
                <xsl:attribute name="class">data-entry <xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'">wide</xsl:if>
                </xsl:attribute>
                <!-- optional overview -->
                <xsl:if test="main-content-bio/descendant::*">
                    <xsl:apply-templates select="main-content-bio">
                        <xsl:with-param name="display" select="page-options/layout"/>
                    </xsl:apply-templates>
                </xsl:if>
            </div>
        </article>
    </xsl:template>
    <xsl:template match="main-content-bio">
        <xsl:param name="display"/>
        <div class="intro clearfix">
            <xsl:choose>
                <xsl:when test="$display = 'Accordions'">
                    <xsl:attribute name="class">intro accordions clearfix</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <aside>
            <!-- PHOTO and position -->
                <xsl:if test="../thumbnail/photo-bio/name">
                    <figure>
                        <xsl:attribute name="class">bio-photo <xsl:value-of select="$photo-align"/>
                        </xsl:attribute>
                        <img id="headshot" itemprop="image">
                            <xsl:attribute name="alt">Photo of <xsl:value-of select="$photo-alt"/>
                            </xsl:attribute>
                            <xsl:attribute name="src">
                                <xsl:value-of select="../thumbnail/photo-bio/path"/>
                            </xsl:attribute>
                        </img>
                    </figure>
                </xsl:if>
                <!-- ATTACHMENTS/CV/ETC -->
                <xsl:if test="attachments/cv/name or attachments/online_cv_url!='' or research/research-guide!='' or attachments/misc_attachments/attachment/name">
                    <div id="bio-attachments">
                        <xsl:if test="attachments/cv/name">
                            <p>
                                <a href="{attachments/cv/path}">Download Full CV</a>
                            </p>
                        </xsl:if>
                        <xsl:if test="attachments/online_cv_url!=''">
                            <p>
                                <a href="{attachments/online_cv_url}">View Online CV</a>
                            </p>
                        </xsl:if>
                        <xsl:if test="research/research-guide!=''">
                            <p>
                                <a href="{research/research-guide}">View Research Guide</a>
                            </p>
                        </xsl:if>
                        <!-- misc/other -->
                        <xsl:if test="attachments/misc_attachments/attachment/name">
                            <xsl:for-each select="attachments/misc_attachments">
                                <p>
                                    <a href="{attachment/path}">
                                        <xsl:choose>
                                            <xsl:when test="attachment_label!=''">
                                                <xsl:value-of select="attachment_label"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="attachment/name"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </a>
                                </p>
                            </xsl:for-each>
                        </xsl:if>
                    </div>
                </xsl:if>
                
                <div id="bio-primary-contact">
                    <xsl:if test="contact/phone !=''">
                        <p>
                            <strong>Phone: </strong>
                            <span itemprop="telephone">
                                <xsl:value-of select="contact/phone"/>
                            </span>
                        </p>
                    </xsl:if>
                    <xsl:if test="contact/fax !=''">
                        <p>
                            <strong>Fax: </strong>
                            <xsl:value-of select="contact/fax"/>
                        </p>
                    </xsl:if>
                    <xsl:if test="contact/email != ''">
                        <p>
                            <strong>Email: </strong>
                            <a itemprop="email">
                                <xsl:attribute name="href">mailto: <xsl:value-of select="contact/email"/>
                                </xsl:attribute>
                                <xsl:value-of select="contact/email"/>
                            </a>
                        </p>
                    </xsl:if>
                </div>
            

            </aside>
            <!-- ROLE AND TITLE -->
            <xsl:if test="roletitle/role !=''">
                <section class="standard-group" id="bio-roles">
                    <xsl:apply-templates select="roletitle[role !='']"/>
                </section>
            </xsl:if>
        </div>
        <xsl:choose>
            <xsl:when test="$display = 'Accordions'">
                <xsl:call-template name="accordions"/>
            </xsl:when>
            <xsl:when test="$display = 'Standard'">
                <xsl:call-template name="standard"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="accordions">
        <!-- accordion -->
        <div class="accordion" id="accordion1">
            <xsl:if test="contact/mailing_address/addr_line1 != '' or contact/mailing_address/addr_org!='' or contact/mailing_address/addr_city !='' or contact/mailing_address/addr_state !='' or contact/mailing_address/addr_zip !='' or contact/website !=''">
                <section class="accordion-group" id="bio-contact">
                    <!-- CONTACT INFO -->
                    <h2 class="accordion-heading">
                        <a class="accordion-toggle" data-parent="#accordion1" data-toggle="collapse" href="#collapseOne">
                            <xsl:value-of select="$contact-heading"/>
                        </a>
                    </h2>
                    <div class="accordion-body collapse in" id="collapseOne">
                        <div class="accordion-inner">
                            <!-- contact: mailing addr -->
                            <xsl:if test="contact/mailing_address/addr_line1 !=''">
                                <div class="bio-address" itemprop="address" itemtype="http://schema.org/PostalAddress">
                                    <xsl:attribute name="itemscope">true</xsl:attribute>
                                    <h3>Mailing Address: </h3>
                                    <xsl:if test="contact/mailing_address/addr_org!=''">
                                        <p>
                                            <xsl:value-of select="contact/mailing_address/addr_org"/>
                                        </p>
                                    </xsl:if>
                                    <p itemprop="streetAddress">
                                        <xsl:value-of select="contact/mailing_address/addr_line1"/>
                                        <xsl:if test="contact/mailing_address/addr_line2 !=''">
                                            <br/>
                                            <xsl:value-of select="contact/mailing_address/addr_line2"/>
                                        </xsl:if>
                                    </p>
                                    <xsl:if test="contact/mailing_address/addr_city !=''">
                                        <p>
                                            <span itemprop="addressLocality"><xsl:value-of select="contact/mailing_address/addr_city"/></span>,<xsl:text> </xsl:text><xsl:if test="contact/mailing_address/addr_state !=''"><span itemprop="addressRegion"><xsl:value-of select="contact/mailing_address/addr_state"/></span></xsl:if><xsl:if test="contact/mailing_address/addr_zip !=''"><xsl:text> </xsl:text><span itemprop="postalCode"><xsl:value-of select="contact/mailing_address/addr_zip"/></span></xsl:if>
                                        </p>
                                    </xsl:if>
                                </div>
                            </xsl:if>
                            <!-- contact: websites -->
                            <xsl:if test="contact/website !=''">
                                <h3>
                                    <xsl:value-of select="$websites-heading"/>
                                </h3>
                                <ul id="bio-websites">
                                    <xsl:for-each select="contact/website">
                                        <li>
                                            <a itemprop="url">
                                                <xsl:attribute name="href">
                                                  <xsl:value-of select="."/>
                                                </xsl:attribute>
                                                <xsl:value-of select="."/>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </xsl:if>
                        </div>
                        <!-- collapseinner -->
                    </div>
                    <!-- collapse -->
                </section>
            </xsl:if>
            <!-- end contact info -->
            <!-- end accordion-group1 -->
            <!-- EDUCATION -->
            <xsl:if test="education/degree !=''">
                <section class="accordion-group" id="bio-education">
                    <h2 class="accordion-heading">
                        <a class="accordion-toggle" data-parent="#accordion1" data-toggle="collapse" href="#collapseThree">Education</a>
                    </h2>
                    <div class="accordion-body collapse" id="collapseThree">
                        <div class="accordion-inner">
                            <ul>
                                <xsl:for-each select="education">
                                    <li>
                                        <xsl:value-of select="degree"/>
                                        <xsl:if test="details!=''">, <xsl:value-of select="details"/>
                                        </xsl:if>
                                        <xsl:if test="school!=''">, <xsl:value-of select="school"/>
                                        </xsl:if>
                                        <xsl:if test="location!=''">, <xsl:value-of select="location"/>
                                        </xsl:if>
                                        <xsl:if test="year!=''">, <xsl:value-of select="year"/>
                                        </xsl:if>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </div>
                </section>
            </xsl:if>
            <!-- MAIN BIO TEXT -->
            <xsl:if test="main-bio !=''">
                <section class="accordion-group" id="bio-main">
                    <h2 class="accordion-heading">
                        <a class="accordion-toggle" data-parent="#accordion1" data-toggle="collapse" href="#collapseFour">Professional Profile</a>
                    </h2>
                    <div class="accordion-body collapse" id="collapseFour">
                        <div class="accordion-inner">
                            <xsl:copy-of select="main-bio/node()"/>
                        </div>
                    </div>
                </section>
            </xsl:if>
            <!-- RESEARCH INTERESTS TEXT ???? -->
            <xsl:if test="research/research-interests !=''">
                <section class="accordion-group" id="bio-research">
                    <h2 class="accordion-heading">
                        <a class="accordion-toggle" data-parent="#accordion1" data-toggle="collapse" href="#bio-research-interests">
                            <xsl:value-of select="$research-heading"/>
                        </a>
                    </h2>
                    <div class="accordion-body collapse" id="bio-research-interests">
                        <div class="accordion-inner">
                            <xsl:copy-of select="research/research-interests/node()"/>
                        </div>
                    </div>
                </section>
            </xsl:if>
            <!-- Publications: Collections and Manually Entered Citations populated -->
            <xsl:if test="research/publications/pubs/pubs_label !='' or research/publications/wysiwyg!=''">
                <section class="accordion-group" id="bio-publications">
                    <h2 class="accordion-heading">
                        <a class="accordion-toggle" data-parent="#accordion1" data-toggle="collapse" href="#bio-pubs">
                            <xsl:value-of select="$publications-heading"/>
                        </a>
                    </h2>
                    <div class="accordion-body collapse" id="bio-pubs">
                        <div class="accordion-inner">
                            <xsl:if test="research/publications/pubs/pubs_label!=''">
                                <ul id="bio-publications">
                                    <xsl:if test="research/publications/pubs/pubs_label !=''">
                                        <xsl:apply-templates select="research/publications/pubs"/>
                                    </xsl:if>
                                </ul>
                            </xsl:if>
                            <xsl:if test="research/publications/wysiwyg!=''">
                                <div id="bio-publications-entry">
                                    <xsl:copy-of select="research/publications/wysiwyg/node()"/>
                                </div>
                            </xsl:if>
                        </div>
                    </div>
                </section>
            </xsl:if>
            <!-- teaching -->
            <xsl:if test="teaching/entries/link-text!=''">
                <section class="accordion-group" id="bio-teaching">
                    <!-- unclear on heading specs here -->
                    <h2 class="accordion-heading">
                        <a class="accordion-toggle" data-parent="#accordion1" data-toggle="collapse" href="#bio-teaching-list">
                            <xsl:value-of select="$teaching-heading"/>
                        </a>
                    </h2>
                    <div class="accordion-body collapse" id="bio-teaching-list">
                        <div class="accordion-inner">
                            <ul>
                                <xsl:for-each select="teaching/entries">
                                    <li>
                                        <xsl:choose>
                                            <xsl:when test="page/path != '/' or file/path != '/' or external != ''">
                                                <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:choose>
                                                  <xsl:when test="page/name">
                                                  <xsl:value-of select="page/path"/>
                                                  </xsl:when>
                                                  <xsl:when test="file/name">
                                                  <xsl:value-of select="file/path"/>
                                                  </xsl:when>
                                                  <xsl:when test="external !=''">
                                                  <xsl:value-of select="external"/>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="link-text"/>
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="link-text"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </div>
                </section>
            </xsl:if>
        </div>
        <!-- end #accordion1 -->
    </xsl:template>
    <xsl:template name="standard">
        <!-- standard -->
        <xsl:if test="contact/mailing_address/addr_line1 != '' or contact/mailing_address/addr_org!='' or contact/mailing_address/addr_city !='' or contact/mailing_address/addr_state !='' or contact/mailing_address/addr_zip !='' or contact/website !=''">
            <section class="standard-group" id="bio-contact">
                <!-- CONTACT INFO -->
                <h2>
                    <xsl:value-of select="$contact-heading"/>
                </h2>
                <!-- contact: mailing addr -->
                <xsl:if test="contact/mailing_address/addr_line1 !=''">
                    <div class="bio-address" itemprop="address" itemtype="http://schema.org/PostalAddress">
                        <xsl:attribute name="itemscope">true</xsl:attribute>
                        <h3>Mailing Address: </h3>
                        <xsl:if test="contact/mailing_address/addr_org!=''">
                            <p>
                                <xsl:value-of select="contact/mailing_address/addr_org"/>
                            </p>
                        </xsl:if>
                        <p itemprop="streetAddress">
                            <xsl:value-of select="contact/mailing_address/addr_line1"/>
                            <xsl:if test="contact/mailing_address/addr_line2 !=''">
                                <br/>
                                <xsl:value-of select="contact/mailing_address/addr_line2"/>
                            </xsl:if>
                        </p>
                        <xsl:if test="contact/mailing_address/addr_city !=''">
                            <p>
                                <span itemprop="addressLocality">
                                    <xsl:value-of select="contact/mailing_address/addr_city"/>
                                </span>, <xsl:text> </xsl:text>
                                <xsl:if test="contact/mailing_address/addr_state !=''">
                                    <span itemprop="addressRegion">
                                        <xsl:value-of select="contact/mailing_address/addr_state"/>
                                    </span>
                                </xsl:if>
                                <xsl:if test="contact/mailing_address/addr_zip !=''">
                                    <xsl:text> </xsl:text>
                                    <span itemprop="postalCode">
                                        <xsl:value-of select="contact/mailing_address/addr_zip"/>
                                    </span>
                                </xsl:if>
                            </p>
                        </xsl:if>
                    </div>
                </xsl:if>
                <!-- contact: websites -->
                <xsl:if test="contact/website !=''">
                    <h3>
                        <xsl:value-of select="$websites-heading"/>
                    </h3>
                    <ul id="bio-websites">
                        <xsl:for-each select="contact/website">
                            <li>
                                <a itemprop="url">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    <xsl:value-of select="."/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </section>
        </xsl:if>
        <!-- end contact info -->
        <!-- end accordion-group1 -->
        <!-- EDUCATION -->
        <xsl:if test="education/degree !=''">
            <section class="standard-group" id="bio-education">
                <h2>Education</h2>
                <ul>
                    <xsl:for-each select="education">
                        <li>
                            <xsl:value-of select="degree"/>
                            <xsl:if test="details!=''">, <xsl:value-of select="details"/>
                            </xsl:if>
                            <xsl:if test="school!=''">, <xsl:value-of select="school"/>
                            </xsl:if>
                            <xsl:if test="location!=''">, <xsl:value-of select="location"/>
                            </xsl:if>
                            <xsl:if test="year!=''">, <xsl:value-of select="year"/>
                            </xsl:if>
                        </li>
                    </xsl:for-each>
                </ul>
            </section>
        </xsl:if>
        <!-- MAIN BIO TEXT -->
        <xsl:if test="main-bio !=''">
            <section class="standard-group" id="bio-main">
                <h2>Professional Profile</h2>
                <xsl:copy-of select="main-bio/node()"/>
            </section>
        </xsl:if>
        <!-- RESEARCH INTERESTS TEXT ???? -->
        <xsl:if test="research/research-interests !=''">
            <section class="standard-group" id="bio-research">
                <h2>
                    <xsl:value-of select="$research-heading"/>
                </h2>
                <xsl:copy-of select="research/research-interests/node()"/>
            </section>
        </xsl:if>
        <!-- Publications: Collections and Manually Entered Citations populated -->
        <xsl:if test="research/publications/pubs/pubs_label !='' or research/publications/wysiwyg!=''">
            <section class="standard-group" id="bio-publications">
                <h2>
                    <xsl:value-of select="$publications-heading"/>
                </h2>
                <xsl:if test="research/publications/pubs/pubs_label!=''">
                    <ul id="bio-publications">
                        <xsl:if test="research/publications/pubs/pubs_label !=''">
                            <xsl:apply-templates select="research/publications/pubs"/>
                        </xsl:if>
                    </ul>
                </xsl:if>
                <xsl:if test="research/publications/wysiwyg!=''">
                    <div id="bio-publications-entry">
                        <xsl:copy-of select="research/publications/wysiwyg/node()"/>
                    </div>
                </xsl:if>
            </section>
        </xsl:if>
        <!-- teaching -->
        <xsl:if test="teaching/entries/link-text!=''">
            <section class="standard-group" id="bio-teaching">
                <!-- unclear on heading specs here -->
                <h2>
                    <xsl:value-of select="$teaching-heading"/>
                </h2>
                <ul>
                    <xsl:for-each select="teaching/entries">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:choose>
                                        <xsl:when test="page/name">
                                            <xsl:value-of select="page/path"/>
                                        </xsl:when>
                                        <xsl:when test="file/name">
                                            <xsl:value-of select="file/path"/>
                                        </xsl:when>
                                        <xsl:when test="external !=''">
                                            <xsl:value-of select="external"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:value-of select="link-text"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </section>
        </xsl:if>
    </xsl:template>
    <!-- sub-templates -->
    <xsl:template match="roletitle">
        <h4 class="title" itemprop="jobTitle">
            <xsl:value-of select="role"/>
        </h4>
        <div itemtype="http://schema.org/Organization">
            <xsl:attribute name="itemscope">true</xsl:attribute>
            <h4 class="org" itemprop="name">
                <xsl:value-of select="org"/>
            </h4>
        </div>
    </xsl:template>
    <!-- publications -->
    <xsl:template match="pubs">
        <li>View publications on <a href="{pubs_url}">
                <xsl:attribute name="class">pubs_link</xsl:attribute>
                <xsl:value-of select="pubs_label"/>
            </a>
        </li>
    </xsl:template>
    
</xsl:stylesheet>
