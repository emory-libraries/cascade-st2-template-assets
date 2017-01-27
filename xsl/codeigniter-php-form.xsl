<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:template match="system-index-block">
        <xsl:apply-templates select="calling-page/system-page/system-data-structure"/>
    </xsl:template>
    
    <xsl:template match="system-data-structure">
        <div>
            <xsl:attribute name="class">data-entry <xsl:if test="//calling-page/system-page/dynamic-metadata[name='layout-columns']/value='Disable Right Column'">wide</xsl:if></xsl:attribute>
            
            <xsl:if test="main-content/main!=''">
                <xsl:copy-of select="main-content/main/node()"/>
            </xsl:if>
            
            <xsl:apply-templates select="form"/>
            
            <div class="form">
                <xsl:variable name="msg">
                    <xsl:choose>
                        <xsl:when test="//confirm-message!=''">
                            <xsl:value-of select="//confirm-message"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Your form has been submitted.</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <div class="hidden confirmMsg"><span><p><xsl:value-of select="$msg"/></p><a href="#">Clear</a></span></div>
            </div>

            <xsl:if test="//code/javascript != ''">
                <script>
                    <xsl:value-of select="//code/javascript"/>
                </script>
            </xsl:if>

        </div>
    </xsl:template>
    
    <xsl:template match="form">
        [system-view:internal]
        <p><strong>This message only displays within Cascade.</strong> Please note: PHP cannot be previewed within Cascade. Please publish your page to view the PHP generated output.</p>
        [/system-view:internal]
        
        [system-view:external]
        <xsl:processing-instruction name="php">
                // from data definition

                <xsl:if test="response_subject != ''">$subject = &lt;&lt;&lt;EOD
<xsl:value-of select="response_subject"/>
EOD;
                </xsl:if>

                <xsl:if test="response_message != ''">$response_message = &lt;&lt;&lt;EOD
<xsl:value-of select="response_message"/>
EOD;
                </xsl:if>

                <xsl:if test="response_message = ''">$response_message = '';
                </xsl:if>

                <xsl:if test="confirm-message != ''">$confirm_message = &lt;&lt;&lt;EOD
<xsl:value-of select="confirm-message"/>
EOD;
                </xsl:if>

                <xsl:if test="confirm-message = ''">$confirm_message = '';
                </xsl:if>

                $form = array(
                    'recipient' =&gt; '<xsl:value-of select="translate(recipient, ';', ',')"/>',
                    'recipient_name' =&gt; <xsl:choose><xsl:when test="recipient_name != ''">'<xsl:value-of select="recipient_name"/>'</xsl:when><xsl:otherwise><xsl:value-of select="recipient"/></xsl:otherwise></xsl:choose>,
                    <xsl:if test="response_subject != ''">'subject' =&gt; $subject,</xsl:if>
                    'name' =&gt; '<xsl:value-of select="name"/>',
                    'fields' =&gt; array(
                        // Form:
                        'action'  =&gt; <xsl:choose><xsl:when test="attributes/action != ''">'<xsl:value-of select="attributes/action"/>'</xsl:when><xsl:otherwise>''</xsl:otherwise></xsl:choose>,
                        'prefix'        =&gt; '',
                        'suffix'        =&gt; '',
                        'ci_action'     =&gt; FALSE,

                        'multistep'     =&gt; <xsl:choose><xsl:when test="attributes/multistep/value = 'Yes'">TRUE</xsl:when><xsl:otherwise>FALSE</xsl:otherwise></xsl:choose>,
                        'multistep_nav' =&gt; <xsl:choose><xsl:when test="attributes/multistep_nav/value = 'Yes'">TRUE</xsl:when><xsl:otherwise>FALSE</xsl:otherwise></xsl:choose>,

                        'multipart'     =&gt; <xsl:choose><xsl:when test="attributes/multipart/value = 'Yes'">TRUE</xsl:when><xsl:otherwise>FALSE</xsl:otherwise></xsl:choose>,

                        'debug'     =&gt; <xsl:choose><xsl:when test="attributes/debug/value = 'Yes'">TRUE</xsl:when><xsl:otherwise>FALSE</xsl:otherwise></xsl:choose>,
                        'honeypot' =&gt; <xsl:choose><xsl:when test="attributes/honeypot/value = 'Yes'">TRUE</xsl:when><xsl:otherwise>FALSE</xsl:otherwise></xsl:choose>,
                        'js_submit' =&gt; <xsl:choose><xsl:when test="attributes/js_submit/value = 'Yes'">TRUE</xsl:when><xsl:otherwise>FALSE</xsl:otherwise></xsl:choose>,

                        'attributes'    =&gt; array(
                            'class' =&gt; '<xsl:text>form </xsl:text> <xsl:if test="attributes/class != ''"><xsl:value-of select="attributes/class"/></xsl:if>'<xsl:if test="attributes/id != ''">,</xsl:if>
                            <xsl:if test="attributes/id != ''">'id' =&gt; '<xsl:value-of select="attributes/id"/>'</xsl:if>
                        ),
                        

                        <xsl:apply-templates select="fieldset"/>,

                        <xsl:apply-templates select="submit"/>

                    )
                );

                // hardcoded in xslt

                // location of includes directory
                $host = $_SERVER['SERVER_NAME'];
                if ($host == 'staging.web.emory.edu')
                {
                    $includes_directory = $_SERVER['DOCUMENT_ROOT'] . '/wdg-files-v2';
                    $web_directory = $host . '/wdg-files-v2';
                }
                else
                {
                    $includes_directory = $_SERVER['DOCUMENT_ROOT'];
                    $web_directory = $host;
                }

                // location of api root
                $api_root = 'http://' . $web_directory . '/_api/v1/';

                // full path to api include file
                $api_path = $includes_directory . '/_api/v1/index.php';

                if (file_exists($api_path))
                {
                    define('STDIN', TRUE);
                    $_SERVER['argv'] = array();
                    ob_start();
                    require($api_path);
                    $ci = ob_get_contents();
                    ob_end_clean();
                    $ci = get_instance();

                    $ci-&gt;load-&gt;library('../controllers/forms');
                    $ci-&gt;forms-&gt;create($form);
                }
            </xsl:processing-instruction>
        [/system-view:external]
    </xsl:template>
    
    <xsl:template match="fieldset">
        // fieldset
        
        'step<xsl:value-of select="position()"/>' =&gt; array(
        'type'   =&gt; 'fieldset',
        <xsl:if test="legend != ''">'legend' =&gt; '<xsl:value-of select="legend"/>',</xsl:if>
        'active' =&gt; <xsl:choose><xsl:when test="attributes/active/value = 'Yes'">TRUE</xsl:when><xsl:otherwise>FALSE</xsl:otherwise></xsl:choose>,
        'prefix' =&gt; '',
        'suffix' =&gt; '',
        <xsl:if test="attributes/class != '' or attributes/id != ''">
            'attributes'    =&gt; array(
            'class' =&gt; <xsl:if test="attributes/class != ''">'<xsl:value-of select="attributes/class"/>'</xsl:if><xsl:if test="attributes/id != ''">,</xsl:if>
            'id' =&gt; <xsl:if test="attributes/id != ''">'<xsl:value-of select="attributes/id"/>'</xsl:if>
            ),
        </xsl:if>
        'accordion'  =&gt; array(
        'title'          =&gt; '<xsl:value-of select="attributes/title"/>',
        'target_id'      =&gt; 'step<xsl:value-of select="position()"/>-accordion-body',
        'nav_buttons'    =&gt; <xsl:choose><xsl:when test="../attributes/nav_buttons/value = 'Yes'">TRUE</xsl:when><xsl:otherwise>FALSE</xsl:otherwise></xsl:choose>,
        'nav_next'       =&gt; 'step<xsl:value-of select="position()"/>-accordion-body',
        'nav_next_label' =&gt; 'Next',
        ),
        <xsl:apply-templates select="field"/>
        <xsl:call-template name="message"/>
        )<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
        
    </xsl:template>
    
    <xsl:template match="field">
        <xsl:variable name="label">
            <xsl:value-of select="name"/>
        </xsl:variable>
        // field
        '<xsl:value-of select="name"/>' =&gt; array(
        'type'  =&gt; '<xsl:value-of select="type"/>',
        'label' =&gt; "<xsl:value-of select="label"/>",
        <xsl:if test="icon != ''">'icon' =&gt; '<xsl:value-of select="icon"/>',</xsl:if>
        <xsl:if test="placeholder != ''">'placeholder' =&gt; '<xsl:value-of select="placeholder"/>',</xsl:if>
        <xsl:if test="checked != ''">'checked' =&gt; '<xsl:value-of select="checked"/>',</xsl:if>
        <xsl:if test="multiple != ''">'multiple' =&gt; '<xsl:value-of select="multiple"/>',</xsl:if>
        <xsl:if test="rules/required/value = 'Yes' and (type='checkbox' or type='subject')">'required_check'=&gt;'required="required"',</xsl:if>
        <xsl:if test="error_text != ''">'error_text' =&gt; &lt;&lt;&lt;EOC
<xsl:value-of select="error_text"/>
EOC
,</xsl:if>
        <xsl:if test="select-options/select-item != '' and (type='dropdown' or type='select')">
            'options' =&gt; <xsl:apply-templates select="select-options"><xsl:with-param name="type"><xsl:value-of select="type"/></xsl:with-param><xsl:with-param name="label"><xsl:value-of select="$label"/></xsl:with-param></xsl:apply-templates></xsl:if>
        'rules' =&gt; '<xsl:if test="rules/required/value = 'Yes' and (type!='dropdown' and type!='select' and type!='checkbox' and type!='subject')">required|</xsl:if><xsl:if test="rules/valid_email/value = 'Yes'">valid_email|</xsl:if><xsl:if test="rules/alpha/value = 'Yes'">alpha|</xsl:if><xsl:if test="rules/alphanumeric/value = 'Yes'">alphanumeric|</xsl:if><xsl:if test="rules/numeric/value = 'Yes'">numeric|</xsl:if><xsl:if test="rules/integer/value = 'Yes'">integer|</xsl:if>',
        'attributes' =&gt; array(
            <xsl:if test="attributes/class != ''">'class' =&gt; '<xsl:value-of select="attributes/class"/>',</xsl:if>
            <xsl:if test="attributes/rows != ''">'rows' =&gt; '<xsl:value-of select="attributes/rows"/>'</xsl:if>
        ),
        <xsl:if test="rules/required/value = 'Yes' and (type='dropdown')">'input_append'=&gt;' validate'</xsl:if>
        )<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
        
    </xsl:template>
    <xsl:template match="select-options">
        <xsl:param name="type"/>
        <xsl:param name="label"/>
        <xsl:choose>
            <xsl:when test="select-item!='' and $type='dropdown'">array('None'=&gt;'---',<xsl:for-each select="select-item">"<xsl:value-of select="text()"/>"=&gt;"<xsl:value-of select="text()"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>),
            </xsl:when>
            <xsl:when test="select-item!='' and $type='select'">array(<xsl:for-each select="select-item">"<xsl:value-of select="$label"/>-select<xsl:number/>"=&gt;"<xsl:value-of select="text()"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>),
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="message">
        // field
        ,'email_message' =&gt; array(
        'type'  =&gt; 'hidden',
        'name' =&gt; "email_message",
        'value' =&gt; $response_message
        ), 
    </xsl:template>
    <xsl:template match="submit">
        // Submit:
        'submit' =&gt; array(
        'type'         =&gt; 'submit',
        'value'        =&gt; '<xsl:value-of select="value"/>',
        'class'        =&gt; '<xsl:choose><xsl:when test="type = 'Primary (blue)'">btn btn-primary</xsl:when><xsl:when test="type = 'Info (light blue)'">btn btn-info</xsl:when><xsl:when test="type = 'Success (green)'">btn btn-success</xsl:when><xsl:when test="type = 'Warning (orange)'">btn btn-warning</xsl:when><xsl:when test="type = 'Danger (red)'">btn btn-danger</xsl:when><xsl:when test="type = 'Alternate (dark gray)'">btn btn-inverse</xsl:when><xsl:when test="type = 'Text Link'">btn btn-link</xsl:when><xsl:otherwise>btn</xsl:otherwise></xsl:choose>',
        'form_actions' =&gt; TRUE,
        ),
    </xsl:template>
    
</xsl:stylesheet>
