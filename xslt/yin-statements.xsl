<?xml version="1.0" encoding="utf-8"?>
<!-- Program name: yin-statements.xsl

Copyright © 2021 by Ladislav Lhotka <ladislav@lhotka.name>

Templates for constructing YANG statements in YIN format [RFC 7950].

yin-statements.xsl is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This stylesheet is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this file.  If not, see
<http://www.gnu.org/licenses/>.
-->

<stylesheet
    xmlns="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:yin="urn:ietf:params:xml:ns:yang:yin:1"
    version="1.0">
  <output method="xml" encoding="utf-8"/>
  <strip-space elements="*"/>

  <!-- General template for statements with yin-element=true. -->

  <template name="yin-element-true">
    <param name="keyword"/>
    <param name="text"/>
    <element name="yin:{$keyword}">
      <element name="yin:text">
	<copy-of select="$text"/>
      </element>
    </element>
  </template>

  <template name="yin-contact">
    <param name="text"/>
    <call-template name="yin-element-true">
      <with-param name="keyword">contact</with-param>
      <with-param name="text" select="$text"/>
    </call-template>
  </template>

  <template name="yin-description">
    <param name="text"/>
    <call-template name="yin-element-true">
      <with-param name="keyword">description</with-param>
      <with-param name="text" select="$text"/>
    </call-template>
  </template>

  <template name="yin-organization">
    <param name="text"/>
    <call-template name="yin-element-true">
      <with-param name="keyword">organization</with-param>
      <with-param name="text" select="$text"/>
    </call-template>
  </template>

  <template name="yin-reference">
    <param name="text"/>
    <call-template name="yin-element-true">
      <with-param name="keyword">reference</with-param>
      <with-param name="text" select="$text"/>
    </call-template>
  </template>

</stylesheet>
