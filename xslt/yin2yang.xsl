<?xml version="1.0"?>

<!-- Program name: yin2yang.xsl

Copyright © 2020 by Ladislav Lhotka <ladislav@lhotka.name>

Translates YIN to YANG (see RFC 7950).

NOTES:

1. XML comments outside arguments are translated to YANG comments. 

2. This stylesheet supports the following non-standard YIN extension:

   Arguments of 'contact', 'description', 'organization' and
   'reference' (wrapped in <text>) may contain the following HTML
   elements in the "http://www.w3.org/1999/xhtml" namespace:

   <html:p> - a paragraph of text
   <html:ul> - unordered list
   <html:ol> - ordered list

   List elements <html:ul> a <html:ol> may appear at the paragraph
   level or inside a paragraph. In the latter case, there are no empty
   lines separating the list from the surrounding contents.

   <html:p> elements may, apart from text and lists, also contain empty
   <html:br/> elements that cause an unconditional line break.

   List elements must contain one or more <html:li> elements
   representing list items with text and <html:br/> elements.

   A <text> element may also have the xml:id attribute and contain the
   XInclude element <xi:include>.

3. The stylesheet tries to break long arguments into multiple
   lines. If the result isn't satisfactory, it is possible to provide
   a hint by adding processing instruction <?delim x> as the content
   of the corresponding statement element, where x is is the delimiter
   character after which the argument may be split.

   For example, The following pattern can be split on every right
   parenthesis:

   <pattern value="..."><?delim )?></pattern>

4. If the "date" parameter is set, this value will overwrite the data
   of the first (most recent) revision in the YANG module.

==

yin2yang.xsl is free software: you can redistribute it and/or modify
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
    xmlns:yin="urn:ietf:params:xml:ns:yang:yin:1"
    xmlns:md="urn:ietf:params:xml:ns:yang:ietf-yang-metadata"
    xmlns:html="http://www.w3.org/1999/xhtml"
    version="1.0">
  <output method="text"/>
  <strip-space elements="*"/>

  <!-- The 'date' parameter, if set, overrides the value of the first
       (most recent) 'revision' statement. -->
  <param name="date"/>
  <!-- Amount of indentation added for each YANG hierarchy level. -->
  <param name="indent-step" select="2"/>
  <!-- Maximum line length -->
  <param name="line-length" select="70"/>
  <!-- Marks for unordered list items at different levels of
       embedding -->
  <param name="list-bullets" select="'-*o+'"/>

  <variable name="unit-indent">
    <call-template name="repeat-string">
      <with-param name="count" select="$indent-step"/>
      <with-param name="string" select="' '"/>
    </call-template>
  </variable>

  <template name="repeat-string">
    <param name="count"/>
    <param name="string"/>
    <choose>
      <when test="not($count) or not($string)"/>
      <when test="$count = 1">
	<value-of select="$string"/>
      </when>
      <otherwise>
	<if test="$count mod 2">
	  <value-of select="$string"/>
	</if>
	<call-template name="repeat-string">
	  <with-param name="count" select="floor($count div 2)"/>
	  <with-param name="string" select="concat($string,$string)"/>
	</call-template> 
      </otherwise>
    </choose>
  </template>

  <template name="indent">
    <param name="level" select="count(ancestor::*)"/>
    <call-template name="repeat-string">
      <with-param name="count" select="$level"/>
      <with-param name="string" select="$unit-indent"/>
    </call-template>
  </template>

  <template name="fill-text">
    <param name="text"/>
    <param name="length"/>
    <param name="remains" select="$length"/>
    <param name="prefix"/>
    <param name="wdelim" select="' '"/>
    <param name="break" select="'&#xA;'"/>
    <param name="at-start" select="false()"/>
    <if test="string-length($text) &gt; 0">
      <variable name="next-word">
	<choose>
	  <when test="contains($text, $wdelim)">
	    <value-of select="substring-before($text, $wdelim)"/>
	  </when>
	  <otherwise>
	    <value-of select="$text"/>
	  </otherwise>
	</choose>
      </variable>
      <variable name="rest">
	<choose>
	  <when test="contains($text, $wdelim)">
	    <value-of select="substring-after($text, $wdelim)"/>
	  </when>
	  <otherwise>
	    <text></text>
	  </otherwise>
	</choose>
      </variable>
      <variable
	  name="left"
	  select="$remains - string-length(concat($wdelim,$next-word))"/>
      <choose>
	<when test="$at-start">
	  <value-of select="$next-word"/>
	  <call-template name="fill-text">
	    <with-param name="text" select="$rest"/>
	    <with-param name="length" select="$length"/>
	    <with-param name="remains" select="$left + 1"/>
	    <with-param name="prefix" select="$prefix"/>
	    <with-param name="wdelim" select="$wdelim"/>
	    <with-param name="break" select="$break"/>
	  </call-template>
	</when>
	<when test="$left &lt; string-length($break)">
	  <value-of select="concat($break,$prefix)"/>
	  <call-template name="fill-text">
	    <with-param name="text" select="$text"/>
	    <with-param name="length" select="$length"/>
	    <with-param name="remains" select="$length"/>
	    <with-param name="prefix" select="$prefix"/>
	    <with-param name="wdelim" select="$wdelim"/>
	    <with-param name="break" select="$break"/>
	    <with-param name="at-start" select="true()"/>
	  </call-template>
	</when>
	<otherwise>
	  <value-of select="concat($wdelim,$next-word)"/>
	  <call-template name="fill-text">
	    <with-param name="text" select="$rest"/>
	    <with-param name="length" select="$length"/>
	    <with-param name="remains" select="$left"/>
	    <with-param name="prefix" select="$prefix"/>
	    <with-param name="wdelim" select="$wdelim"/>
	    <with-param name="break" select="$break"/>
	  </call-template>
	</otherwise>
      </choose>
    </if>
  </template>

  <template name="semi-or-sub">
    <choose>
      <when test="*">
	<text> {&#xA;</text>
	<apply-templates select="*|comment()"/>
	<call-template name="indent"/>
	<text>}&#xA;</text>
      </when>
      <otherwise>
	<text>;&#xA;</text>
      </otherwise>
    </choose>
  </template>

  <template name="keyword">
    <param name="kw" select="local-name()"/>
    <if test="count(ancestor::*)=1 and not($kw = 'yang-version' or
	      $kw = 'namespace' or $kw = 'prefix')">
      <text>&#xA;</text>
    </if>
    <call-template name="indent"/>
    <value-of select="$kw"/>
  </template>

  <template name="statement">
    <param name="arg"/>
    <call-template name="keyword"/>
    <value-of select="concat(' ', $arg)"/>
    <call-template name="semi-or-sub"/>
  </template>

  <template name="extension-statement">
    <param name="arg"/>
    <call-template name="keyword">
      <with-param name="kw" select="name()"/>
    </call-template>
    <value-of select="concat(' ', $arg)"/>
    <call-template name="semi-or-sub"/>
  </template>

  <template name="statement-dq">    <!-- double-quoted arg -->
    <param name="arg"/>
    <call-template name="statement">
      <with-param name="arg">
	<text>"</text>
	<call-template name="escape-text">
	  <with-param name="text" select="$arg"/>
	</call-template>
	<text>"</text>
      </with-param>
    </call-template>
  </template>

  <template name="escape-text">
    <param name="text"/>
    <call-template name="escape-char">
      <with-param name="text">
	<call-template name="escape-char">
	  <with-param name="text" select="$text"/>
	  <with-param name="char">\</with-param>
	</call-template>
      </with-param>
      <with-param name="char">"</with-param>
    </call-template>
  </template>

  <template name="escape-char">
    <param name="text"/>
    <param name="char"/>
    <choose>
      <when test="contains($text, $char)">
	<value-of
	    select="concat(substring-before($text, $char), '\', $char)"/>
	<call-template name="escape-char">
	  <with-param name="text"
		      select="substring-after($text, $char)"/>
	  <with-param name="char" select="$char"/>
	</call-template>
      </when>
      <otherwise>
	<value-of select="$text"/>
      </otherwise>
    </choose>
  </template>

  <template name="chop-arg">
    <param name="token-delim" select="' '"/>
    <param name="after" select="2"/>
    <variable name="qchar">"</variable>
    <variable name="cind">
      <call-template name="indent">
	<with-param name="level" select="count(ancestor::*)-1"/>
      </call-template>
    </variable>
    <variable name="tdel">
      <choose>
	<when test="../processing-instruction('delim')">
	  <value-of select="../processing-instruction('delim')"/>
	</when>
	<otherwise>
	  <value-of select="$token-delim"/>
	</otherwise>
      </choose>
    </variable>
    <variable name="txt">
      <call-template name="escape-text">
	<with-param name="text" select="normalize-space(.)"/>
      </call-template>
    </variable>
    <choose>
      <when
	  test="string-length(concat($cind,local-name(..),$txt))
		&lt; $line-length - 5">
	<value-of select="concat(' ',$qchar,$txt)"/>
      </when>
      <when test="string-length(concat($cind,$unit-indent,$txt))
		      &lt; $line-length - 4">
	<text>&#xA;</text>
	<call-template name="indent"/>
	<value-of select="concat($qchar,$txt)"/>
      </when>
      <otherwise>
	<value-of select="concat(' ',$qchar)"/>
	<call-template name="fill-text">
	  <with-param name="text" select="$txt"/>
	  <with-param
	      name="length"
	      select="$line-length - $after -
		      string-length(concat($cind, local-name(..)))"/>
	  <with-param name="prefix">
	    <value-of select="$cind"/>
	    <call-template name="repeat-string">
	      <with-param
		  name="count"
		  select="string-length(local-name(..)) - 1"/>
	      <with-param name="string" select="' '"/>
	    </call-template>
	    <value-of select="concat('+ ',$qchar)"/>
	  </with-param>
	  <with-param name="wdelim" select="$tdel"/>
	  <with-param name="break"
			  select="concat($tdel,$qchar,'&#xA;')"/>
	  <with-param name="at-start" select="true()"/>
	</call-template>
      </otherwise>
    </choose>
    <value-of select="$qchar"/>
  </template>

  <!-- Root element -->

  <template match="/">
    <apply-templates select="yin:module|yin:submodule|comment()"/>
  </template>

  <template
      match="yin:action|yin:anydata|yin:anyxml|yin:argument|yin:base
	     |yin:bit|yin:case|yin:choice|yin:container|yin:enum
	     |yin:extension|yin:feature|yin:grouping|yin:identity
	     |yin:leaf|yin:leaf-list|yin:list|yin:module
	     |yin:notification|yin:rpc|yin:submodule
	     |yin:type|yin:typedef|yin:uses">
    <call-template name="statement">
      <with-param name="arg" select="@name"/>
    </call-template>
  </template>

  <template match="md:annotation">
    <call-template name="extension-statement">
      <with-param name="arg" select="@name"/>
    </call-template>
  </template>

  <template match="yin:namespace">
    <call-template name="keyword"/>
    <apply-templates select="@uri"/>
    <call-template name="semi-or-sub"/>
  </template>

  <template match="@uri">
    <call-template name="chop-arg">
      <with-param name="token-delim">:</with-param>
    </call-template>
  </template>

  <template match="yin:units|yin:if-feature">
    <call-template name="statement-dq">
      <with-param name="arg" select="@name"/>
    </call-template>
  </template>

  <template match="yin:augment|yin:deviation|yin:refine">
    <call-template name="keyword"/>
    <apply-templates select="@target-node"/>
    <call-template name="semi-or-sub"/>
  </template>

  <template match="yin:belongs-to|yin:import|yin:include">
    <call-template name="statement">
      <with-param name="arg" select="@module"/>
    </call-template>
  </template>

  <template
      match="yin:key|yin:length|yin:pattern|yin:presence|yin:range">
    <call-template name="statement-dq">
      <with-param name="arg" select="@value"/>
    </call-template>
  </template>

  <template match="yin:default">
    <call-template name="keyword"/>
    <apply-templates select="@value" mode="chop"/>
    <call-template name="semi-or-sub"/>
  </template>

  <template match="@value" mode="chop">
    <call-template name="chop-arg"/>
  </template>

  <template match="yin:modifier|yin:prefix|yin:yang-version
		   |yin:config|yin:deviate|yin:error-app-tag
		   |yin:fraction-digits|yin:mandatory
		   |yin:max-elements|yin:min-elements|yin:ordered-by
		   |yin:position|yin:require-instance|yin:status
		   |yin:value|yin:yin-element">
    <call-template name="statement">
      <with-param name="arg" select="@value"/>
    </call-template>
  </template>

  <template match="yin:path|yin:pattern">
    <call-template name="keyword"/>
    <apply-templates select="@value"/>
    <call-template name="semi-or-sub"/>
  </template>

  <template match="@target-node|yin:path/@value">
    <call-template name="chop-arg">
      <with-param name="token-delim" select="'/'"/>
    </call-template>
  </template>

  <template match="yin:pattern/@value">
    <call-template name="chop-arg">
      <with-param name="token-delim">|</with-param>
    </call-template>
  </template>

  <template match="yin:error-message">
    <call-template name="keyword"/>
    <apply-templates select="yin:value" mode="chop"/>
  </template>

  <template match="yin:contact|yin:description
		       |yin:organization|yin:reference">
    <call-template name="keyword"/>
    <apply-templates select="yin:text"/>
  </template>

  <template match="yin:input|yin:output">
    <call-template name="keyword"/>
    <call-template name="semi-or-sub"/>
  </template>

  <template match="yin:must|yin:when">
    <call-template name="keyword"/>
    <apply-templates select="@condition"/>
    <call-template name="semi-or-sub"/>
  </template>

  <template match="@condition">
    <call-template name="chop-arg">
      <with-param name="token-delim">
	<choose>
	  <when test="contains(substring(.,0,$line-length),' ')">
	    <text> </text>
	  </when>
	  <otherwise>/</otherwise>
	</choose>
      </with-param>
      <with-param name="after" select="3"/>
    </call-template>
  </template>

  <template match="yin:revision">
    <call-template name="statement">
      <with-param name="arg">
	<choose>
	  <when test="not($date) or preceding-sibling::yin:revision">
	    <value-of select="@date"/>
	  </when>
	  <otherwise>
	    <value-of select="$date"/>
	  </otherwise>
	</choose>
      </with-param>
    </call-template>
  </template>

  <template match="yin:revision-date">
    <call-template name="statement">
      <with-param name="arg" select="@date"/>
    </call-template>
  </template>

  <template match="yin:unique">
    <call-template name="statement-dq">
      <with-param name="arg" select="@tag"/>
    </call-template>
  </template>

  <template match="yin:text">
    <variable name="qchar">"</variable>
    <text>&#xA;</text>
    <variable name="prf">
      <call-template name="indent"/>
    </variable>
    <value-of select="concat($prf,$qchar)"/>
    <choose>
      <when test="html:*">
	<apply-templates select="html:p|html:ul|html:ol">
	  <with-param name="prefix" select="concat($prf,' ')"/>
	</apply-templates>
      </when>
      <otherwise>
	<call-template name="fill-text">
	  <with-param name="text">
	    <call-template name="escape-text">
	      <with-param
		  name="text"
		  select="normalize-space(.)"/>
	    </call-template>
	    <value-of select="concat($qchar,';&#xA;')"/>
	  </with-param>
	  <with-param
	      name="length"
	      select="$line-length - string-length($prf) - 1"/>
	  <with-param name="prefix" select="concat($prf,' ')"/>
	  <with-param name="at-start" select="true()"/>
	</call-template>
      </otherwise>
    </choose>
  </template>

  <template match="html:ul">
    <param name="prefix"/>
    <choose>
      <when test="html:li">
	<if test="position()>1">
	  <if test="not(parent::html:p)">
	    <text>&#xA;</text>
	  </if>
	  <value-of select="concat('&#xA;',$prefix)"/>
	</if>
	<apply-templates select="html:li">
	  <with-param name="prefix" select="$prefix"/>
	  <with-param name="last" select="position()=last()"/>
	</apply-templates>
      </when>
      <otherwise>
	<if test="position()=last()">";&#xA;</if>
      </otherwise>
    </choose>
  </template>

  <template match="html:ol">
    <param name="prefix"/>
    <choose>
      <when test="html:li">
	<if test="position()>1">
	  <if test="not(parent::html:p)">
	    <text>&#xA;</text>
	  </if>
	  <value-of select="concat('&#xA;',$prefix)"/>
	</if>
	<apply-templates select="html:li" mode="numbered">
	  <with-param name="prefix" select="$prefix"/>
	  <with-param name="last" select="position()=last()"/>
	</apply-templates>
      </when>
      <otherwise>
	<if test="position()=last()">";&#xA;</if>
      </otherwise>
    </choose>
  </template>

  <template match="html:p">
    <param name="prefix"/>
    <choose>
      <when test="html:*|text()">
	<if test="position()>1">
	  <value-of select="concat('&#xA;&#xA;',$prefix)"/>
	</if>
	<apply-templates
	    select="text()|html:br|html:ul|html:ol">
	  <with-param name="prefix" select="$prefix"/>
	  <with-param name="last" select="position()=last()"/>
	</apply-templates>
      </when>
      <otherwise>
	<if test="position()=last()">";&#xA;</if>
      </otherwise>
    </choose>
  </template>

  <template match="text()">
    <param name="prefix"/>
    <param name="last"/>
    <call-template name="fill-text">
      <with-param name="text">
	<call-template name="escape-text">
	  <with-param name="text" select="normalize-space(.)"/>
	</call-template>
	<if test="$last and position()=last()">";&#xA;</if>
      </with-param>
      <with-param
	  name="length"
	  select="$line-length - string-length($prefix)"/>
      <with-param name="prefix" select="$prefix"/>
      <with-param name="at-start" select="true()"/>
    </call-template>
  </template>

  <template match="html:br">
    <param name="prefix"/>
    <param name="last"/>
    <value-of select="concat('&#xA;',$prefix)"/>
    <if test="$last and position()=last()">";&#xA;</if>
  </template>

  <template match="html:li">
    <param name="prefix"/>
    <param name="last"/>
    <call-template name="list-item">
      <with-param
	  name="label"
	  select="substring($list-bullets,
		  count(ancestor::html:ul),1)"/>
      <with-param name="prefix" select="$prefix"/>
      <with-param name="last" select="$last"/>
    </call-template>
  </template>

  <template match="html:li" mode="numbered">
    <param name="prefix"/>
    <param name="last"/>
    <call-template name="list-item">
      <with-param
	  name="label"
	  select="concat(count(preceding-sibling::html:li) + 1,'.')"/>
      <with-param name="prefix" select="$prefix"/>
      <with-param name="last" select="$last"/>
    </call-template>
  </template>

  <template name="list-item">
    <param name="label"/>
    <param name="prefix"/>
    <param name="last"/>
    <if test="position()>1">
      <value-of select="concat('&#xA;',$prefix)"/>
    </if>
    <value-of select="concat($label,' ')"/>
    <call-template name="fill-text">
      <with-param name="text">
	<call-template name="escape-text">
	  <with-param name="text" select="normalize-space(.)"/>
	</call-template>
	<if test="position()=last()">
	  <choose>
	    <when test="$last">";&#xA;</when>
	    <otherwise>
	      <if test="ancestor::html:p">
		<value-of select="concat('&#xA; ', $prefix)"/>
	      </if>
	    </otherwise>
	  </choose>
	</if>
      </with-param>
      <with-param
	  name="length"
	  select="$line-length - string-length($prefix) -
		  string-length($label) - 1"/>
      <with-param name="prefix" select="concat($prefix,'  ')"/>
      <with-param name="at-start" select="true()"/>
    </call-template>
  </template>

  <template match="comment()">
    <if test="count(ancestor::yin:*)=1">
      <text>&#xA;</text>
    </if>
    <call-template name="indent"/>
    <text>/* </text>
    <value-of select="."/>
    <text> */&#xA;</text>
  </template>

  <!-- Extension -->
  <template match="*">
    <if test="count(ancestor::*)=1">
      <text>&#xA;</text>
    </if>
    <call-template name="indent"/>
    <value-of select="name(.)"/>
    <text> "</text>
    <call-template name="escape-text">
      <with-param name="text" select="@*"/>
    </call-template>
    <text>"</text>
    <call-template name="semi-or-sub"/>
  </template>

</stylesheet>
