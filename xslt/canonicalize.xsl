<?xml version="1.0" encoding="utf-8"?>
<!-- Program name: canonicalize.xsl

Copyright © 2020 by Ladislav Lhotka <ladislav@lhotka.name>

This stylesheet rearranges a YIN module into canonical order [RFC 7950].

canonicalize.xsl is free software: you can redistribute it and/or modify
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
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:md="urn:ietf:params:xml:ns:yang:ietf-yang-metadata"
    xmlns:yin="urn:ietf:params:xml:ns:yang:yin:1"
    xmlns:ymt="urn:ietf:params:xml:ns:yang:ietf-yang-text-media-type"
    version="1.0">
  <output method="xml" encoding="utf-8"/>
  <strip-space elements="*"/>
  <template name="preceding-comment">
    <if
	test="count((preceding-sibling::*|preceding-sibling::comment())
	      [last()]|preceding-sibling::comment()[1]) = 1">
      <apply-templates select="preceding-sibling::comment()[1]"/>
    </if>
  </template>
  <template
      match="html:*|ymt:*|xi:*|@*|comment()|text()|processing-instruction()">
    <copy-of select="."/>
  </template>
  <template name="data-def-stmt">
    <apply-templates
	select="yin:container|yin:leaf|yin:leaf-list|yin:list|
		yin:choice|yin:anydata|yin:anyxml|yin:uses"/>
  </template>

  <template match="yin:module">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:yang-version"/>
      <apply-templates select="yin:namespace"/>
      <apply-templates select="yin:prefix"/>
      <apply-templates select="yin:import"/>
      <apply-templates select="yin:include"/>
      <apply-templates select="ymt:text-media-type"/>
      <apply-templates select="yin:organization"/>
      <apply-templates select="yin:contact"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <apply-templates select="yin:revision"/>
      <apply-templates
	  select="md:annotation|yin:extension|yin:feature|yin:identity
		  |yin:typedef|yin:grouping|yin:container|yin:leaf
		  |yin:leaf-list|yin:list|yin:choice|yin:anyxml|yin:uses
		  |yin:augment|yin:rpc|yin:notification|yin:deviation"/>
    </copy>
  </template>
  <template match="yin:submodule">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:yang-version"/>
      <apply-templates select="yin:belongs-to"/>
      <apply-templates select="yin:import"/>
      <apply-templates select="yin:include"/>
      <apply-templates select="ymt:text-media-type"/>
      <apply-templates select="yin:organization"/>
      <apply-templates select="yin:contact"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <apply-templates select="yin:revision"/>
      <apply-templates
	  select="md:annotation|yin:extension|yin:feature|yin:identity
		  |yin:typedef|yin:grouping|yin:container|yin:leaf
		  |yin:leaf-list|yin:list|yin:choice|yin:anyxml|yin:uses
		  |yin:augment|yin:rpc|yin:notification|yin:deviation"/>
    </copy>
  </template>
  <template match="md:annotation">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates select="html:*|xi:*|@*|text()"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:type"/>
      <apply-templates select="yin:units"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:feature">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates select="html:*|xi:*|@*|text()"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:identity">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:base"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:import">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:prefix"/>
      <apply-templates select="yin:revision-date"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:include">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:revision-date"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:belongs-to">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:prefix"/>
    </copy>
  </template>
  <template match="yin:organization|yin:contact|
		       yin:description|yin:reference">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:text"/>
    </copy>
  </template>
  <template match="yin:revision">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:extension">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:argument"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:argument">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:yin-element"/>
    </copy>
  </template>
  <template match="yin:typedef">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:type"/>
      <apply-templates select="yin:units"/>
      <apply-templates select="yin:default"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:type">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:fraction-digits"/>
      <apply-templates select="yin:range"/>
      <apply-templates select="yin:length"/>
      <apply-templates select="yin:pattern"/>
      <apply-templates select="yin:enum"/>
      <apply-templates select="yin:bit"/>
      <apply-templates select="yin:path"/>
      <apply-templates select="yin:base"/>
      <apply-templates select="yin:type"/>
      <apply-templates select="yin:require-instance"/>
    </copy>
  </template>
  <template match="yin:range">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:error-message"/>
      <apply-templates select="yin:error-app-tag"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:length">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:error-message"/>
      <apply-templates select="yin:error-app-tag"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:pattern">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:modifier"/>
      <apply-templates select="yin:error-message"/>
      <apply-templates select="yin:error-app-tag"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:enum">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:value"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:bit">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:position"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:must">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:error-message"/>
      <apply-templates select="yin:error-app-tag"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:error-message">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:value"/>
    </copy>
  </template>
  <template match="yin:grouping">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <apply-templates select="yin:typedef"/>
      <apply-templates select="yin:grouping"/>
      <call-template name="data-def-stmt"/>
      <apply-templates select="yin:action"/>
      <apply-templates select="yin:notification"/>
    </copy>
  </template>
  <template match="yin:container">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:when"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:must"/>
      <apply-templates select="yin:presence"/>
      <apply-templates select="yin:config"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <apply-templates select="yin:typedef"/>
      <apply-templates select="yin:grouping"/>
      <call-template name="data-def-stmt"/>
      <apply-templates select="yin:action"/>
      <apply-templates select="yin:notification"/>
    </copy>
  </template>
  <template match="yin:leaf">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:when"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:type"/>
      <apply-templates select="yin:units"/>
      <apply-templates select="yin:must"/>
      <apply-templates select="yin:default"/>
      <apply-templates select="yin:config"/>
      <apply-templates select="yin:mandatory"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:leaf-list">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:when"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:type"/>
      <apply-templates select="yin:units"/>
      <apply-templates select="yin:must"/>
      <apply-templates select="yin:default"/>
      <apply-templates select="yin:config"/>
      <apply-templates select="yin:min-elements"/>
      <apply-templates select="yin:max-elements"/>
      <apply-templates select="yin:ordered-by"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:list">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:when"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:must"/>
      <apply-templates select="yin:key"/>
      <apply-templates select="yin:unique"/>
      <apply-templates select="yin:config"/>
      <apply-templates select="yin:min-elements"/>
      <apply-templates select="yin:max-elements"/>
      <apply-templates select="yin:ordered-by"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <apply-templates select="yin:typedef"/>
      <apply-templates select="yin:grouping"/>
      <call-template name="data-def-stmt"/>
      <apply-templates select="yin:action"/>
      <apply-templates select="yin:notification"/>
    </copy>
  </template>
  <template match="yin:if-feature|yin:base|yin:yang-version|
		       yin:namespace|yin:prefix|yin:text|yin:units|
		       yin:yin-element|yin:fraction-digits|yin:default|
		       yin:position|yin:path|yin:require-instance|
		       yin:status|yin:config|yin:mandatory|yin:presence|
		       yin:ordered-by|yin:value|yin:error-app-tag|
		       yin:min-elements|yin:max-elements|yin:key|
		       yin:revision-date|yin:unique|yin:modifier">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
    </copy>
  </template>
  <template match="yin:choice">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:when"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:default"/>
      <apply-templates select="yin:config"/>
      <apply-templates select="yin:mandatory"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <apply-templates select="yin:container"/>
      <apply-templates select="yin:leaf"/>
      <apply-templates select="yin:leaf-list"/>
      <apply-templates select="yin:list"/>
      <apply-templates select="yin:anyxml"/>
      <apply-templates select="yin:case"/>
    </copy>
  </template>
  <template match="yin:case">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:when"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <call-template name="data-def-stmt"/>
    </copy>
  </template>
  <template match="yin:anydata|yin:anyxml">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:when"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:must"/>
      <apply-templates select="yin:config"/>
      <apply-templates select="yin:mandatory"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:uses">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:when"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <apply-templates select="yin:refine"/>
      <apply-templates select="yin:augment"/>
    </copy>
  </template>
  <template match="yin:refine">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:must"/>
      <apply-templates select="yin:presence"/>
      <apply-templates select="yin:default"/>
      <apply-templates select="yin:config"/>
      <apply-templates select="yin:mandatory"/>
      <apply-templates select="yin:min-elements"/>
      <apply-templates select="yin:max-elements"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:augment">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:when"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <call-template name="data-def-stmt"/>
      <apply-templates select="yin:case"/>
      <apply-templates select="yin:action"/>
      <apply-templates select="yin:notification"/>
    </copy>
  </template>
  <template match="yin:when">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
    </copy>
  </template>
  <template match="yin:action|yin:rpc">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <apply-templates select="yin:typedef"/>
      <apply-templates select="yin:grouping"/>
      <apply-templates select="yin:input"/>
      <apply-templates select="yin:output"/>
    </copy>
  </template>
  <template match="yin:input">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:typedef"/>
      <apply-templates select="yin:grouping"/>
      <call-template name="data-def-stmt"/>
    </copy>
  </template>
  <template match="yin:output">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:typedef"/>
      <apply-templates select="yin:grouping"/>
      <call-template name="data-def-stmt"/>
    </copy>
  </template>
  <template match="yin:notification">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:if-feature"/>
      <apply-templates select="yin:status"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <apply-templates select="yin:typedef"/>
      <apply-templates select="yin:grouping"/>
      <call-template name="data-def-stmt"/>
    </copy>
  </template>
  <template match="yin:deviation">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:description"/>
      <apply-templates select="yin:reference"/>
      <apply-templates select="yin:deviate"/>
    </copy>
  </template>
  <template match="yin:deviate">
    <call-template name="preceding-comment"/>
    <copy>
      <apply-templates
	  select="html:*|xi:*|@*|text()|processing-instruction()"/>
      <apply-templates select="yin:type"/>
      <apply-templates select="yin:units"/>
      <apply-templates select="yin:must"/>
      <apply-templates select="yin:unique"/>
      <apply-templates select="yin:default"/>
      <apply-templates select="yin:config"/>
      <apply-templates select="yin:mandatory"/>
      <apply-templates select="yin:min-elements"/>
      <apply-templates select="yin:max-elements"/>
    </copy>
  </template>
  <template match="/">
    <apply-templates select="yin:module"/>
    <apply-templates select="yin:submodule"/>
  </template>
</stylesheet>
