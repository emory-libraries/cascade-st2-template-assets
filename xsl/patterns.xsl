<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <!-- check for ugraded Font Awesome icon names -->
    <xsl:template name="replace-icon">
        <xsl:param name="icon"/>
        <xsl:variable name="icon-name">
            <xsl:choose>
                <xsl:when test="$icon = 'ban-circle'">ban</xsl:when>
                <xsl:when test="$icon = 'bar-chart'">bar-chart-o</xsl:when>
                <xsl:when test="$icon = 'beaker'">flask</xsl:when>
                <xsl:when test="$icon = 'bell'">bell-o</xsl:when>
                <xsl:when test="$icon = 'bell-alt'">bell</xsl:when>
                <xsl:when test="$icon = 'bitbucket-sign'">bitbucket-square</xsl:when>
                <xsl:when test="$icon = 'bookmark-empty'">bookmark-o</xsl:when>
                <xsl:when test="$icon = 'building'">building-o</xsl:when>
                <xsl:when test="$icon = 'calendar-empty'">calendar-o</xsl:when>
                <xsl:when test="$icon = 'check-empty'">square-o</xsl:when>
                <xsl:when test="$icon = 'check-minus'">minus-square-o</xsl:when>
                <xsl:when test="$icon = 'check-sign'">check-square</xsl:when>
                <xsl:when test="$icon = 'check'">check-square-o</xsl:when>
                <xsl:when test="$icon = 'chevron-sign-down'">chevron-down</xsl:when>
                <xsl:when test="$icon = 'chevron-sign-left'">chevron-left</xsl:when>
                <xsl:when test="$icon = 'chevron-sign-right'">chevron-right</xsl:when>
                <xsl:when test="$icon = 'chevron-sign-up'">chevron-up</xsl:when>
                <xsl:when test="$icon = 'circle-arrow-down'">arrow-circle-down</xsl:when>
                <xsl:when test="$icon = 'circle-arrow-left'">arrow-circle-left</xsl:when>
                <xsl:when test="$icon = 'circle-arrow-right'">arrow-circle-right</xsl:when>
                <xsl:when test="$icon = 'circle-arrow-up'">arrow-circle-up</xsl:when>
                <xsl:when test="$icon = 'circle-blank'">circle-o</xsl:when>
                <xsl:when test="$icon = 'cny'">rmb</xsl:when>
                <xsl:when test="$icon = 'collapse-alt'">minus-square-o</xsl:when>
                <xsl:when test="$icon = 'collapse-top'">caret-square-o-up</xsl:when>
                <xsl:when test="$icon = 'collapse'">caret-square-o-down</xsl:when>
                <xsl:when test="$icon = 'comment-alt'">comment-o</xsl:when>
                <xsl:when test="$icon = 'comments-alt'">comments-o</xsl:when>
                <xsl:when test="$icon = 'copy'">files-o</xsl:when>
                <xsl:when test="$icon = 'cut'">scissors</xsl:when>
                <xsl:when test="$icon = 'dashboard'">tachometer</xsl:when>
                <xsl:when test="$icon = 'double-angle-down'">angle-double-down</xsl:when>
                <xsl:when test="$icon = 'double-angle-left'">angle-double-left</xsl:when>
                <xsl:when test="$icon = 'double-angle-right'">angle-double-right</xsl:when>
                <xsl:when test="$icon = 'double-angle-up'">angle-double-up</xsl:when>
                <xsl:when test="$icon = 'download'">arrow-circle-o-down</xsl:when>
                <xsl:when test="$icon = 'download-alt'">download</xsl:when>
                <xsl:when test="$icon = 'edit-sign'">pencil-square</xsl:when>
                <xsl:when test="$icon = 'edit'">pencil-square-o</xsl:when>
                <xsl:when test="$icon = 'ellipsis-horizontal'">ellipsis-h</xsl:when>
                <xsl:when test="$icon = 'ellipsis-vertical'">ellipsis-v</xsl:when>
                <xsl:when test="$icon = 'envelope-alt'">envelope-o</xsl:when>
                <xsl:when test="$icon = 'exclamation-sign'">exclamation-circle</xsl:when>
                <xsl:when test="$icon = 'expand-alt'">plus-square-o</xsl:when>
                <xsl:when test="$icon = 'expand'">caret-square-o-right</xsl:when>
                <xsl:when test="$icon = 'external-link-sign'">external-link-square</xsl:when>
                <xsl:when test="$icon = 'eye-close'">eye-slash</xsl:when>
                <xsl:when test="$icon = 'eye-open'">eye</xsl:when>
                <xsl:when test="$icon = 'facebook-sign'">facebook-square</xsl:when>
                <xsl:when test="$icon = 'facetime-video'">video-camera</xsl:when>
                <xsl:when test="$icon = 'file-alt'">file-o</xsl:when>
                <xsl:when test="$icon = 'file-text-alt'">file-text-o</xsl:when>
                <xsl:when test="$icon = 'flag-alt'">flag-o</xsl:when>
                <xsl:when test="$icon = 'folder-close-alt'">folder-o</xsl:when>
                <xsl:when test="$icon = 'folder-close'">folder</xsl:when>
                <xsl:when test="$icon = 'folder-open-alt'">folder-open-o</xsl:when>
                <xsl:when test="$icon = 'food'">cutlery</xsl:when>
                <xsl:when test="$icon = 'frown'">frown-o</xsl:when>
                <xsl:when test="$icon = 'fullscreen'">arrows-alt</xsl:when>
                <xsl:when test="$icon = 'github-sign'">github-square</xsl:when>
                <xsl:when test="$icon = 'google-plus-sign'">google-plus-square</xsl:when>
                <xsl:when test="$icon = 'group'">users</xsl:when>
                <xsl:when test="$icon = 'h-sign'">h-square</xsl:when>
                <xsl:when test="$icon = 'hand-down'">hand-o-down</xsl:when>
                <xsl:when test="$icon = 'hand-left'">hand-o-left</xsl:when>
                <xsl:when test="$icon = 'hand-right'">hand-o-right</xsl:when>
                <xsl:when test="$icon = 'hand-up'">hand-o-up</xsl:when>
                <xsl:when test="$icon = 'hdd'">hdd-o</xsl:when>
                <xsl:when test="$icon = 'heart-empty'">heart-o</xsl:when>
                <xsl:when test="$icon = 'hospital'">hospital-o</xsl:when>
                <xsl:when test="$icon = 'indent-left'">outdent</xsl:when>
                <xsl:when test="$icon = 'indent-right'">indent</xsl:when>
                <xsl:when test="$icon = 'info-sign'">info-circle</xsl:when>
                <xsl:when test="$icon = 'keyboard'">keyboard-o</xsl:when>
                <xsl:when test="$icon = 'legal'">gavel</xsl:when>
                <xsl:when test="$icon = 'lemon'">lemon-o</xsl:when>
                <xsl:when test="$icon = 'lightbulb'">lightbulb-o</xsl:when>
                <xsl:when test="$icon = 'linkedin-sign'">linkedin-square</xsl:when>
                <xsl:when test="$icon = 'meh'">meh-o</xsl:when>
                <xsl:when test="$icon = 'microphone-off'">microphone-slash</xsl:when>
                <xsl:when test="$icon = 'minus-sign-alt'">minus-square</xsl:when>
                <xsl:when test="$icon = 'minus-sign'">minus-circle</xsl:when>
                <xsl:when test="$icon = 'mobile-phone'">mobile</xsl:when>
                <xsl:when test="$icon = 'moon'">moon-o</xsl:when>
                <xsl:when test="$icon = 'move'">arrows</xsl:when>
                <xsl:when test="$icon = 'off'">power-off</xsl:when>
                <xsl:when test="$icon = 'ok-circle'">check-circle-o</xsl:when>
                <xsl:when test="$icon = 'ok-sign'">check-circle</xsl:when>
                <xsl:when test="$icon = 'ok'">check</xsl:when>
                <xsl:when test="$icon = 'paper-clip'">paperclip</xsl:when>
                <xsl:when test="$icon = 'paste'">clipboard</xsl:when>
                <xsl:when test="$icon = 'phone-sign'">phone-square</xsl:when>
                <xsl:when test="$icon = 'picture'">picture-o</xsl:when>
                <xsl:when test="$icon = 'pinterest-sign'">pinterest-square</xsl:when>
                <xsl:when test="$icon = 'play-circle'">play-circle-o</xsl:when>
                <xsl:when test="$icon = 'play-sign'">play-circle</xsl:when>
                <xsl:when test="$icon = 'plus-sign-alt'">plus-square</xsl:when>
                <xsl:when test="$icon = 'plus-sign'">plus-circle</xsl:when>
                <xsl:when test="$icon = 'pushpin'">thumb-tack</xsl:when>
                <xsl:when test="$icon = 'question-sign'">question-circle</xsl:when>
                <xsl:when test="$icon = 'remove-circle'">times-circle-o</xsl:when>
                <xsl:when test="$icon = 'remove-sign'">times-circle</xsl:when>
                <xsl:when test="$icon = 'remove'">times</xsl:when>
                <xsl:when test="$icon = 'reorder'">bars</xsl:when>
                <xsl:when test="$icon = 'resize-full'">expand</xsl:when>
                <xsl:when test="$icon = 'resize-horizontal'">arrows-h</xsl:when>
                <xsl:when test="$icon = 'resize-small'">compress</xsl:when>
                <xsl:when test="$icon = 'resize-vertical'">arrows-v</xsl:when>
                <xsl:when test="$icon = 'rss-sign'">rss-square</xsl:when>
                <xsl:when test="$icon = 'save'">floppy-o</xsl:when>
                <xsl:when test="$icon = 'screenshot'">crosshairs</xsl:when>
                <xsl:when test="$icon = 'share-alt'">share</xsl:when>
                <xsl:when test="$icon = 'share-sign'">share-square</xsl:when>
                <xsl:when test="$icon = 'share'">share-square-o</xsl:when>
                <xsl:when test="$icon = 'sign-blank'">square</xsl:when>
                <xsl:when test="$icon = 'signin'">sign-in</xsl:when>
                <xsl:when test="$icon = 'signout'">sign-out</xsl:when>
                <xsl:when test="$icon = 'smile'">smile-o</xsl:when>
                <xsl:when test="$icon = 'sort-by-alphabet-alt'">sort-alpha-desc</xsl:when>
                <xsl:when test="$icon = 'sort-by-alphabet'">sort-alpha-asc</xsl:when>
                <xsl:when test="$icon = 'sort-by-attributes-alt'">sort-amount-desc</xsl:when>
                <xsl:when test="$icon = 'sort-by-attributes'">sort-amount-asc</xsl:when>
                <xsl:when test="$icon = 'sort-by-order-alt'">sort-numeric-desc</xsl:when>
                <xsl:when test="$icon = 'sort-by-order'">sort-numeric-asc</xsl:when>
                <xsl:when test="$icon = 'sort-down'">sort-desc</xsl:when>
                <xsl:when test="$icon = 'sort-up'">sort-asc</xsl:when>
                <xsl:when test="$icon = 'stackexchange'">stack-overflow</xsl:when>
                <xsl:when test="$icon = 'star-empty'">star-o</xsl:when>
                <xsl:when test="$icon = 'star-half-empty'">star-half-o</xsl:when>
                <xsl:when test="$icon = 'sun'">sun-o</xsl:when>
                <xsl:when test="$icon = 'thumbs-down-alt'">thumbs-o-down</xsl:when>
                <xsl:when test="$icon = 'thumbs-up-alt'">thumbs-o-up</xsl:when>
                <xsl:when test="$icon = 'time'">clock-o</xsl:when>
                <xsl:when test="$icon = 'trash'">trash-o</xsl:when>
                <xsl:when test="$icon = 'tumblr-sign'">tumblr-square</xsl:when>
                <xsl:when test="$icon = 'twitter-sign'">twitter-square</xsl:when>
                <xsl:when test="$icon = 'unlink'">chain-broken</xsl:when>
                <xsl:when test="$icon = 'upload'">arrow-circle-o-up</xsl:when>
                <xsl:when test="$icon = 'upload-alt'">upload</xsl:when>
                <xsl:when test="$icon = 'warning-sign'">exclamation-triangle</xsl:when>
                <xsl:when test="$icon = 'xing-sign'">xing-square</xsl:when>
                <xsl:when test="$icon = 'youtube-sign'">youtube-square</xsl:when>
                <xsl:when test="$icon = 'zoom-in'">search-plus</xsl:when>
                <xsl:when test="$icon = 'zoom-out'">search-minus</xsl:when>
                <xsl:otherwise><xsl:value-of select="$icon"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="icon-class-name">fa-<xsl:value-of select="$icon-name"/></xsl:variable>
        <xsl:value-of select="$icon-class-name"/>
    </xsl:template>

    <!-- trim whitespace templates -->
    <xsl:variable name="whitespace" select="' '" />

    <!-- Strips trailing whitespace characters from 'string' -->
    <xsl:template name="string-rtrim">
        <xsl:param name="string" />
        <xsl:param name="trim" select="$whitespace" />

        <xsl:variable name="length" select="string-length($string)" />

        <xsl:if test="$length &gt; 0">
            <xsl:choose>
                <xsl:when test="contains($trim, substring($string, $length, 1))">
                    <xsl:call-template name="string-rtrim">
                        <xsl:with-param name="string" select="substring($string, 1, $length - 1)" />
                        <xsl:with-param name="trim"   select="$trim" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$string" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- Strips leading whitespace characters from 'string' -->
    <xsl:template name="string-ltrim">
        <xsl:param name="string" />
        <xsl:param name="trim" select="$whitespace" />

        <xsl:if test="string-length($string) &gt; 0">
            <xsl:choose>
                <xsl:when test="contains($trim, substring($string, 1, 1))">
                    <xsl:call-template name="string-ltrim">
                        <xsl:with-param name="string" select="substring($string, 2)" />
                        <xsl:with-param name="trim"   select="$trim" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$string" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- Strips leading and trailing whitespace characters from 'string' -->
    <xsl:template name="string-trim">
        <xsl:param name="string" />
        <xsl:param name="trim" select="$whitespace" />
        <xsl:call-template name="string-rtrim">
            <xsl:with-param name="string">
                <xsl:call-template name="string-ltrim">
                    <xsl:with-param name="string" select="$string" />
                    <xsl:with-param name="trim"   select="$trim" />
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="trim"   select="$trim" />
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
