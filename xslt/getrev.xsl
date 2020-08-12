<?xml version="1.0" encoding="utf-8"?>

<!-- Get current revision date -->

<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
		xmlns:yin="urn:ietf:params:xml:ns:yang:yin:1"
		version="1.0">
  <output method="text" encoding="utf-8"/>
  <strip-space elements="*"/>
  <template match="yin:module|yin:submodule">
    <value-of select="yin:revision[1]/@date"/>
  </template>
</stylesheet>
