<?xml version='1.0'?>
<!-- Copyright © 2020 Aleksander Korzynski
   -
   - Permission is granted to copy, distribute and/or modify this document under
   - the terms of the GNU Free Documentation License, Version 1.3 published by
   - the Free Software Foundation; with no Front-Cover Texts, no Back-Cover Texts
   - and an Invariant Section entitled Preface; with Aleksander Korzynski as the
   - proxy for deciding if a later version of the license can be used.
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:template name="user.head.content">
    <script>
      function haveParentOpenFeedbackForm(docTitle, docSubtitle, docAuthors, docVer, docPubDate, locInDoc){
        if (!parent) {
          return false;
        }
        if (typeof parent.openFeedbackForm !== 'function') {
          return false;
        }

        return parent.openFeedbackForm(docTitle, docSubtitle, docAuthors, docVer, docPubDate, locInDoc);
      }

      function enableFeedbackLink() {
        if (!parent) {
          return false;
        }
        if (typeof parent.openFeedbackForm !== 'function') {
          return false;
        }

        var styleElem = document.createElement('style');
        styleElem.innerHTML = `
          .docbook-output .feedback-link-container {
            display: inline;
          }
        `;
        document.head.appendChild(styleElem);

        return true;
      }

      enableFeedbackLink();
    </script>
  </xsl:template>

  <xsl:template name="body.attributes">
    <xsl:attribute name="class">docbook-output</xsl:attribute>
  </xsl:template>

  <xsl:template name="feedback-link">
    <span class="feedback-link-container">
      <xsl:text>&#160;&#160;</xsl:text>
      <sup class="feedback-link-superscript">
        <a>
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="onclick">
            <xsl:text>haveParentOpenFeedbackForm('</xsl:text>
            <xsl:value-of select="/book/bookinfo/title"/>
            <xsl:text>', '</xsl:text>
            <xsl:value-of select="/book/bookinfo/subtitle"/>
            <xsl:text>', '</xsl:text>
            <xsl:for-each select="/book/bookinfo/authorgroup/author|/book/bookinfo/authorgroup/editor">
              <xsl:value-of select="firstname"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="surname"/>
              <xsl:if test="not(position()=last())">
                <xsl:text>, </xsl:text>
              </xsl:if>
            </xsl:for-each>
            <xsl:text>', '</xsl:text>
            <xsl:value-of select="/book/bookinfo/releaseinfo"/>
            <xsl:text>', '</xsl:text>
            <xsl:value-of select="/book/bookinfo/pubdate"/>
            <xsl:text>', '</xsl:text>
            <xsl:for-each select="ancestor-or-self::*">
              <xsl:text>/</xsl:text>
              <xsl:variable name="thisName" select="name(current())"/>
              <xsl:value-of select="$thisName"/>
              <xsl:variable name="precedingSiblingCount" select="count(preceding-sibling::*[name()=$thisName])"/>
              <xsl:variable name="followingSiblingCount" select="count(following-sibling::*[name()=$thisName])"/>
              <xsl:if test="$precedingSiblingCount or $followingSiblingCount">
                <xsl:text>[</xsl:text>
                <xsl:number select="$precedingSiblingCount + 1"/>
                <xsl:text>]</xsl:text>
              </xsl:if>
            </xsl:for-each>
            <xsl:text>'); return false;</xsl:text>
          </xsl:attribute>
          <xsl:text>[feedback]</xsl:text>
        </a>
      </sup>
    </span>
  </xsl:template>

  <xsl:template match="para">
    <xsl:call-template name="paragraph">
      <xsl:with-param name="class">
        <xsl:if test="@role and $para.propagates.style != 0">
          <xsl:value-of select="@role"/>
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:if test="position() = 1 and parent::listitem">
          <xsl:call-template name="anchor">
            <xsl:with-param name="node" select="parent::listitem"/>
          </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="anchor"/>
        <xsl:apply-templates/>
        <xsl:call-template name="feedback-link"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="formalpara/para">
    <xsl:apply-imports/>
  </xsl:template>

  <xsl:template name="user.footer.navigation">
    <script type="text/javascript">
      function haveParentAdjustHeight() {
        var xpath = "//html[1]/body[1]/div";
        var result = document.evaluate(xpath, document, null, XPathResult.ANY_TYPE, null);
        var node = null;
        var totalHeight = 64;
        while(node = result.iterateNext()) {
          totalHeight += node.scrollHeight;
        }
        parent.adjustBookHeight(totalHeight);
      }

      function periodicallyHaveParentAdjustHeight() {
        if (!parent) {
          return false;
        }
        if (typeof parent.adjustBookHeight !== "function") {
          return false;
        }
        setInterval(haveParentAdjustHeight, 500);
      }

      periodicallyHaveParentAdjustHeight();
    </script>
  </xsl:template>

  <xsl:template match="releaseinfo" mode="titlepage.mode">
    <xsl:call-template name="paragraph">
      <xsl:with-param name="class" select="local-name(.)"/>
      <xsl:with-param name="content">
        <xsl:text>Version </xsl:text>
        <xsl:apply-templates mode="titlepage.mode"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="pubdate" mode="titlepage.mode">
    <xsl:call-template name="paragraph">
      <xsl:with-param name="class" select="local-name(.)"/>
      <xsl:with-param name="content">
        <xsl:text>Published on </xsl:text>
        <xsl:apply-templates mode="titlepage.mode"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template> 

</xsl:stylesheet>
