<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
<!--    <xsl:template name="lstrip">
        <xsl:variable name="stripped_string">
            <xsl:value-of select="normalize-space()"/>
        </xsl:variable>
        <xsl:value-of select="concat($stripped_string, substring-after(., $stripped_string))"/>
    </xsl:template>
    <xsl:template name="one_withespace_left">
        <xsl:variable name="stripped_string">
            <xsl:value-of select="normalize-space()"/>
        </xsl:variable>
        <xsl:value-of select="concat(' ', $stripped_string, substring-after(., $stripped_string))"/>
    </xsl:template>
    <xsl:template name="rstrip">
        <xsl:variable name="stripped_string">
            <xsl:value-of select="normalize-space()"/>
        </xsl:variable>
        <xsl:value-of select="concat(substring-before(., $stripped_string), $stripped_string)"/>
    </xsl:template>
    <xsl:template name="one_withespace_right">
        <xsl:variable name="stripped_string">
            <xsl:value-of select="normalize-space()"/>
        </xsl:variable>
        <xsl:value-of select="concat(substring-before(., $stripped_string), $stripped_string, ' ')"
        />
    </xsl:template>-->
    <!-- whitespace handling -->
    <!-- delete empty textnodes between pb and fw -->
<!--    <xsl:template name="pb_rstripper">
        <xsl:choose>
            <xsl:when test="./following-sibling::tei:pb[1][@break = 'yes']">
                <xsl:call-template name="one_withespace_right"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="rstrip"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="pb_lstripper">
        <xsl:choose>
            <xsl:when test="./preceding-sibling::tei:pb[1][@break = 'yes']">
                <xsl:call-template name="one_withespace_left"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="lstrip"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="text_between_breaks">
        <xsl:choose>
            <xsl:when test="./preceding-sibling::tei:pb[1][@break = 'yes']">
                <xsl:call-template name="one_withespace_left"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="lstrip"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="text_check_left_break">
        <xsl:choose>
            <xsl:when test="./preceding-sibling::tei:pb[1][@break = 'yes']">
                <xsl:call-template name="one_withespace_left"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="lstrip"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="text_check_right_break">
        <xsl:variable name="following">
            <xsl:value-of select="following-sibling::*[1]"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$following[self::tei:pb[@break='yes']]">
                <xsl:call-template name="one_withespace_right"/>
            </xsl:when>
            <xsl:when test="$following[self::tei:pb[@break='no']]">
                <xsl:call-template name="rstrip"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$following[self::tei:fw and following-sibling::*[1][self::tei:pb[@break='no']] and following-sibling::node()[1][self::text() and normalize-space()='' or self::tei:pb]]">
                        <xsl:call-template name="rstrip"/>
                    </xsl:when>
                    <xsl:when test="$following[self::tei:fw and following-sibling::*[1][self::tei:pb[@break='no']] and following-sibling::node()[1][self::text() and normalize-space()='' or self::tei:pb]]">
                        <xsl:call-template name="one_withespace_right"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    <!-- strip empty textnodes before (fw)pb / (pb)fw -->
<!--    <xsl:template
        match="//text()[normalize-space() = '' and (preceding-sibling::*[1][local-name() = 'pb' or local-name() = 'fw'] or following-sibling::*[1][local-name() = 'pb' or local-name() = 'fw'])]"/>
    <xsl:template
        match="//text()[normalize-space() != '' and preceding-sibling::*[1][local-name() = ('pb', 'fw')] or following-sibling::*[1][local-name() = ('pb', 'fw')]]">
        <xsl:choose>
            <xsl:when
                test="preceding-sibling::*[1][local-name() = ('pb', 'fw')] and following-sibling::*[1][local-name() = ('pb', 'fw')]">
                <xsl:call-template name="text_between_breaks"/>
            </xsl:when>
            <xsl:when test="preceding-sibling::*[1][local-name() = ('pb', 'fw')]">
                <xsl:call-template name="text_check_left_break"/>
            </xsl:when>
            <xsl:when test="following-sibling::*[1][local-name() = ('pb', 'fw')]">
                <xsl:call-template name="text_check_right_break"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->
    <!-- strip nonempty textnodes before (fw)pb -->
    <!--    <xsl:template
        match="//text()[normalize-space() != '' and following-sibling::node()[1][local-name() = 'pb' or (local-name() = 'fw' and following-sibling::node()[1][local-name() = 'pb'])]]">
        <xsl:call-template name="pb_rstripper"/>
    </xsl:template>
    <xsl:template
        match="//text()[normalize-space() != '' and following-sibling::node()[1][local-name() = 'fw' and following-sibling::node()[1][self::text() and normalize-space() = '' and following-sibling::node()[1][local-name() = 'pb']]]]">
        <xsl:call-template name="pb_rstripper"/>
    </xsl:template>
    <xsl:template
        match="//text()[normalize-space() != '' and preceding-sibling::node()[1][local-name() = 'pb' or (local-name() = 'fw' and preceding-sibling::node()[1][local-name() = 'pb'])] and not(following-sibling::node()[1][local-name() = 'pb'])]">
        <xsl:call-template name="pb_lstripper"/>
    </xsl:template>
    <xsl:template
        match="//text()[normalize-space() != '' and preceding-sibling::node()[1][local-name() = 'fw' and preceding-sibling::node()[1][self::text() and normalize-space() = '' and preceding-sibling::node()[1][local-name() = 'pb']]] and not(following-sibling::node()[1][local-name() = 'pb'])]">
        
        <xsl:call-template name="pb_lstripper"/>
    </xsl:template>-->

    <xsl:template match="tei:gap[@reason='illegible']">
        <span class="gap">
        </span>
    </xsl:template>

    <xsl:template match="tei:cit">
        <cite>
            <xsl:apply-templates/>
        </cite>
    </xsl:template>
    <xsl:template match="tei:quote">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:date">
        <span class="date">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:note">
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" format="1" count="tei:note"/>
            </sup>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:list[@type = 'unordered']">
        <xsl:choose>
            <xsl:when test="ancestor::tei:body">
                <ul class="yes-index">
                    <xsl:apply-templates/>
                </ul>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:item">
        <xsl:choose>
            <xsl:when test="parent::tei:list[@type = 'unordered'] | ancestor::tei:body">
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:hi">
        <span>
            <xsl:choose>
                <xsl:when test="@rendition = '#em'">
                    <xsl:attribute name="class">
                        <xsl:text>italic</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#italic'">
                    <xsl:attribute name="class">
                        <xsl:text>italic</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#smallcaps'">
                    <xsl:attribute name="class">
                        <xsl:text>smallcaps</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#bold'">
                    <xsl:attribute name="class">
                        <xsl:text>bold</xsl:text>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:ref">
        <a class="ref {@type}" href="{@target}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="tei:lg">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:l">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">
                <xsl:text>table table-bordered table-striped table-condensed table-hover</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <abbr title="unclear">
            <xsl:apply-templates/>
        </abbr>
    </xsl:template>
    <xsl:template match="tei:del">
        <s>
            <xsl:apply-templates/>
        </s>
    </xsl:template>
    <xsl:template match="tei:rs">
        <xsl:choose>
            <xsl:when test="count(tokenize(@ref, ' ')) > 1">
                <xsl:choose>
                    <xsl:when test="@type = 'person'">
                        <span class="persons {substring-after(@rendition, '#')}" id="{@xml:id}">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-bs-toggle="modal" data-bs-target="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type = 'place'">
                        <span class="places {substring-after(@rendition, '#')}" id="{@xml:id}">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-bs-toggle="modal" data-bs-target="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type = 'bibl'">
                        <span class="works {substring-after(@rendition, '#')}" id="{@xml:id}">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-bs-toggle="modal" data-bs-target="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type = 'org'">
                        <span class="orgs {substring-after(@rendition, '#')}" id="{@xml:id}">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-bs-toggle="modal" data-bs-target="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@type = 'person'">
                        <span class="persons entity {substring-after(@rendition, '#')}"
                            id="{@xml:id}" data-bs-toggle="modal" data-bs-target="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type = 'place'">
                        <span class="places entity {substring-after(@rendition, '#')}"
                            id="{@xml:id}" data-bs-toggle="modal" data-bs-target="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type = 'bibl'">
                        <span class="works entity {substring-after(@rendition, '#')}" id="{@xml:id}"
                            data-bs-toggle="modal" data-bs-target="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type = 'org'">
                        <span class="orgs entity {substring-after(@rendition, '#')}" id="{@xml:id}"
                            data-bs-toggle="modal" data-bs-target="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:listPerson">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:person">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="{concat(./tei:persName/tei:surname, ', ', ./tei:persName/tei:forename)}"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">
                            <xsl:value-of
                                select="concat(./tei:persName/tei:surname, ', ', ./tei:persName/tei:forename)"
                            />
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Close"/>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <tbody>
                                <xsl:if test="./tei:idno[@type = 'GEONAMES']">
                                    <tr>
                                        <th> Geonames ID </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'GEONAMES'], '/')[4]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type = 'WIKIDATA']">
                                    <tr>
                                        <th> Wikidata ID </th>
                                        <td>
                                            <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'WIKIDATA'], '/')[last()]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type = 'GND']">
                                    <tr>
                                        <th> GND ID </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GND']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'GND'], '/')[last()]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                    <tr>
                                        <th> Erwähnungen </th>
                                        <td>
                                            <ul>
                                                <xsl:for-each select=".//tei:event">
                                                  <xsl:variable name="linkToDocument">
                                                  <xsl:value-of
                                                  select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"
                                                  />
                                                  </xsl:variable>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="position() lt $showNumberOfMentions + 1">
                                                  <li>
                                                  <xsl:value-of select=".//tei:title"/>
                                                  <xsl:text/>
                                                  <a href="{$linkToDocument}">
                                                  <i class="fas fa-external-link-alt"/>
                                                  </a>
                                                  </li>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <tr>
                                    <th/>
                                    <td> Anzahl der Erwähnungen limitiert, klicke <a
                                            href="{$selfLink}">hier</a> für eine vollständige
                                        Auflistung </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                            >Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:listPlace">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:place">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="{if(./tei:settlement) then(./tei:settlement/tei:placeName) else (./tei:placeName)}"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">
                            <xsl:value-of select="
                                    if (./tei:settlement) then
                                        (./tei:settlement/tei:placeName)
                                    else
                                        (./tei:placeName)"/>
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Close"/>
                    </div>
                    <div class="modal-body">
                        <table>
                            <tbody>
                                <xsl:if test="./tei:country">
                                    <tr>
                                        <th> Country </th>
                                        <td>
                                            <xsl:value-of select="./tei:country"/>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type = 'GND']/text()">
                                    <tr>
                                        <th> GND </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GND']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'GND'], '/')[last()]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type = 'WIKIDATA']/text()">
                                    <tr>
                                        <th> Wikidata </th>
                                        <td>
                                            <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'WIKIDATA'], '/')[last()]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type = 'GEONAMES']/text()">
                                    <tr>
                                        <th> Geonames </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'GEONAMES'], '/')[4]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                    <tr>
                                        <th> Erwähnungen </th>
                                        <td>
                                            <ul>
                                                <xsl:for-each select=".//tei:event">
                                                  <xsl:variable name="linkToDocument">
                                                  <xsl:value-of
                                                  select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"
                                                  />
                                                  </xsl:variable>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="position() lt $showNumberOfMentions + 1">
                                                  <li>
                                                  <xsl:value-of select=".//tei:title"/>
                                                  <xsl:text/>
                                                  <a href="{$linkToDocument}">
                                                  <i class="fas fa-external-link-alt"/>
                                                  </a>
                                                  </li>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <tr>
                                    <th/>
                                    <td> Anzahl der Erwähnungen limitiert, klicke <a
                                            href="{$selfLink}">hier</a> für eine vollständige
                                        Auflistung </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                            >Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:listOrg">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:org">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="{if(./tei:settlement) then(./tei:settlement/tei:placeName) else (./tei:placeName)}"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">
                            <xsl:value-of select="
                                    if (./tei:settlement) then
                                        (./tei:settlement/tei:placeName)
                                    else
                                        (./tei:placeName)"/>
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Close"/>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <tbody>
                                <xsl:if test="./tei:idno[@type = 'GEONAMES']">
                                    <tr>
                                        <th> Geonames ID </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'GEONAMES'], '/')[4]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type = 'WIKIDATA']">
                                    <tr>
                                        <th> Wikidata ID </th>
                                        <td>
                                            <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'WIKIDATA'], '/')[last()]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type = 'GND']">
                                    <tr>
                                        <th> GND ID </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GND']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'GND'], '/')[last()]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                    <tr>
                                        <th> Erwähnungen </th>
                                        <td>
                                            <ul>
                                                <xsl:for-each select=".//tei:event">
                                                  <xsl:variable name="linkToDocument">
                                                  <xsl:value-of
                                                  select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"
                                                  />
                                                  </xsl:variable>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="position() lt $showNumberOfMentions + 1">
                                                  <li>
                                                  <xsl:value-of select=".//tei:title"/>
                                                  <xsl:text/>
                                                  <a href="{$linkToDocument}">
                                                  <i class="fas fa-external-link-alt"/>
                                                  </a>
                                                  </li>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <tr>
                                    <th/>
                                    <td> Anzahl der Erwähnungen limitiert, klicke <a
                                            href="{$selfLink}">hier</a> für eine vollständige
                                        Auflistung </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                            >Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:listBibl">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:bibl">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="{./tei:title[@type='main']}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">
                            <xsl:value-of select="./tei:title"/>
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Close"/>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <tbody>
                                <tr>
                                    <th> Autor(en) </th>
                                    <td>
                                        <ul>
                                            <xsl:for-each select="./tei:author">
                                                <li>
                                                  <a href="{@xml:id}.html">
                                                  <xsl:value-of select="./tei:persName"/>
                                                  </a>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                                <xsl:if test="./tei:idno[@type = 'GEONAMES']">
                                    <tr>
                                        <th> Geonames ID </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'GEONAMES'], '/')[4]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type = 'WIKIDATA']">
                                    <tr>
                                        <th> Wikidata ID </th>
                                        <td>
                                            <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'WIKIDATA'], '/')[last()]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type = 'GND']">
                                    <tr>
                                        <th> GND ID </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GND']}" target="_blank">
                                                <xsl:value-of
                                                  select="tokenize(./tei:idno[@type = 'GND'], '/')[last()]"
                                                />
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                    <tr>
                                        <th> Erwähnungen </th>
                                        <td>
                                            <ul>
                                                <xsl:for-each select=".//tei:event">
                                                  <xsl:variable name="linkToDocument">
                                                  <xsl:value-of
                                                  select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"
                                                  />
                                                  </xsl:variable>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="position() lt $showNumberOfMentions + 1">
                                                  <li>
                                                  <xsl:value-of select=".//tei:title"/>
                                                  <xsl:text/>
                                                  <a href="{$linkToDocument}">
                                                  <i class="fas fa-external-link-alt"/>
                                                  </a>
                                                  </li>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <tr>
                                    <th/>
                                    <td> Anzahl der Erwähnungen limitiert, klicke <a
                                            href="{$selfLink}">hier</a> für eine vollständige
                                        Auflistung </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                            >Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <!-- <xsl:template match="tei:rs[@ref or @key]">
        <strong>
            <xsl:element name="a">
                <xsl:attribute name="data-toggle">modal</xsl:attribute>
                <xsl:attribute name="data-target">
                    <xsl:value-of select="data(@ref)"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </strong>
    </xsl:template> -->
</xsl:stylesheet>
