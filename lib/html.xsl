<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="./xsl/html/chunk.xsl"/>
  <xsl:include href="./common.xsl"/>
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>
  <xsl:param name="chunk.section.depth" select="0"/>
  <xsl:param name="html.stylesheet">html.css site.css</xsl:param>
  <xsl:param name="ulink.target">_PARENT</xsl:param>

</xsl:stylesheet>
