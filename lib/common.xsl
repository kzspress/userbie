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

</xsl:stylesheet>
