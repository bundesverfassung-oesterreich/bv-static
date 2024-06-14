<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/osd-container.xsl"/>
    <xsl:import href="partials/tei-facsimile.xsl"/>
    <xsl:import href="partials/shared.xsl"/>
    <xsl:import href="partials/chapters.xsl"/>
    <xsl:import href="partials/edition_side_nav.xsl"/>
    <xsl:import href="partials/meta_tags.xsl"/>
    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')" />
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')" />
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:title[@type = 'main'][1]/text()"/>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:variable name="revision_state">
            <xsl:value-of select="//tei:revisionDesc/@status"/>
        </xsl:variable>
        <xsl:variable name="revision_label">
            <xsl:choose>
                <xsl:when test="$revision_state='created'">
                    <xsl:value-of select="'maschinell erfasst'"/>
                </xsl:when>
                <xsl:when test="$revision_state='structured'">
                    <xsl:value-of select="'strukturell erschlossen'"/>
                </xsl:when>
                <xsl:when test="$revision_state='text_correct'">
                    <xsl:value-of select="'Dokument vollständig ediert'"/>
                </xsl:when>
                <xsl:when test="$revision_state='done'">
                    <xsl:value-of select="'Dokument vollständig ediert'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <xsl:call-template name="meta-tags">
                    <xsl:with-param name="title" select="$doc_title"/>
                    <xsl:with-param name="source_authors" select="//tei:msDesc/tei:msContents/tei:msItem/tei:author/text()"/>
                    <xsl:with-param name="description" select="'Die Entstehung der Österreichischen Bundes-Verfassung 1920'"/>
                </xsl:call-template>
            </head>
            <body class="page" lang="de">
                <xsl:if test="$revision_state='created' or $revision_state='structured'">
                    <div id="text_quality_disclaimer" class="offcanvas offcanvas-start show" tabindex="-1" aria-labelledby="tqd_label" data-bs-scroll="false" data-bs-backdrop="false">
                        <div class="offcanvas-header">
                            <h5 class="offcanvas-title" id="offcanvasNavigationLabel">Achtung!</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"/>
                        </div>
                        <div class="offcanvas-body">
                            <p>Die vorliegende Transkription wurde maschinell erstellt, um das Dokument
                                grundlegend durchsuchbar zu machen. Sie sollte – ob ihres rein
                                provisorischen Charakters – keinesfalls als Zitationsquelle verwendet
                                werden. Dieses Dokument wird in nächster Zeit kollationiert, annotiert
                                und erschlossen werden.</p>
                        </div>
                    </div>
                </xsl:if>
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar">
                        <xsl:with-param name="edition_buttons" as="xs:boolean" select="true()"/>
                        <xsl:with-param name="doc_title" as="xs:string" select="$doc_title"/>
                    </xsl:call-template>
                    <div class="edition_container ">
                        <div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasNavigation" aria-labelledby="offcanvasNavigationLabel" data-bs-scroll="true" data-bs-backdrop="false">
                            <div class="offcanvas-header">
                                <h5 class="offcanvas-title" id="offcanvasNavigationLabel">Navigation</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"/>
                            </div>
                            <div class="offcanvas-body">
                                <div>
                                    <xsl:call-template name="edition_side_nav">
                                        <xsl:with-param name="doc_title" select="$doc_title"/>
                                    </xsl:call-template>
                                </div>
                            </div>
                        </div>
                        <div class="offcanvas offcanvas-end" tabindex="0" id="offcanvasOptions" aria-labelledby="offcanvasOptionsLabel" data-bs-scroll="true" data-bs-backdrop="false">
                            <div class="offcanvas-header">
                                <h5 class="offcanvas-title" id="offcanvasOptionsLabel">Einstellungen</h5>   
                                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"/>
                            </div>
                            <div class="offcanvas-body">
                                <div>
                                    <ul id="edition_display_options" class="list-unstyled fw-normal pb-1 small">
                                        <li>
                                            <font-size opt="fos"/>
                                        </li>
                                        <li>
                                            <annotation-slider opt="ef"/>
                                        </li>
                                        <li>
                                            <annotation-slider opt="historical_pagecounter"/>
                                        </li>
                                        <li>
                                            <annotation-slider opt="comment_toggler"/>
                                        </li>
                                        <li>
                                            <annotation-slider opt="genetic_toggler"/>
                                        </li>
                                        <li>
                                            <annotation-slider opt="correction_toggler"/>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="wp-transcript">
                            <div class="row" id="edition_metadata">
                                <div class="col-md-8 col-lg-8 col-sm-12 docinfo">
                                    <xsl:variable name="doc_type" select="//tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/@form[1]"/>
                                    <h1>
                                        <xsl:value-of select="$doc_title"/>
                                    </h1>
                                    <p class="document_info">
                                        <xsl:value-of select="string-join((//tei:msDesc/tei:msContents/tei:msItem/tei:author/text()), ' / ')" />
                                    </p>
                                    <p class="document_info archival_small">
                                        <xsl:value-of select="normalize-space(//tei:profileDesc/tei:creation/tei:date[1])" />
                                    </p>
                                    <p class="document_info archival_small">
                                        <xsl:value-of select="//tei:text/@type"/>
                                        <xsl:value-of select="concat(' (', normalize-space($doc_type)), ')'"/>
                                    </p>
                                    <p class="document_info archival_small">
                                        <xsl:value-of select='//tei:msDesc/tei:msIdentifier/tei:idno[@type = "archive"]/text()[1]/normalize-space()'
                                        />
                                    </p>
                            <div>
                            <xsl:attribute name="class">
                                <xsl:value-of select="concat('revision_desc ', $revision_state)"/>
                            </xsl:attribute>
                            <xsl:value-of select="$revision_label"/>
                            </div>
                                </div>
                                <div class="row align-items-start justify-content-start">
                                    <div class="edition_metadata_button" role="button">
                                        <a href="{$target_xml}/{$doc_id}.xml"> XML <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-download" viewBox="0 0 16 16">
                                            <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5"/>
                                            <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708z" />
                                        </svg>
                                    </a>
                                </div>
                                <div class="edition_metadata_button" role="button">
                                    <!--<a href="{$target_xml}/{$doc_title}.pdf">-->
                                    <a href="no_data.html"> PDF <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-download" viewBox="0 0 16 16">
                                        <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5"/>
                                        <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708z" />
                                    </svg>
                                </a>
                            </div>
                            <div class="edition_metadata_button" role="button">
                                <!--<a href="{$target_xml}/comment_{$doc_id}.xml">-->
                                <a href="no_data.html"> Editorischer Bericht <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-earmark-text-fill" viewBox="0 0 16 16">
                                    <path d="M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0M9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1M4.5 9a.5.5 0 0 1 0-1h7a.5.5 0 0 1 0 1zM4 10.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m.5 2.5a.5.5 0 0 1 0-1h4a.5.5 0 0 1 0 1z" />
                                </svg>
                            </a>
                        </div>
                    </div>
                </div>
                <div id="container-resize" class="row transcript active">
                    <div id="img-resize" class="col-md-6 col-lg-6 col-sm-12 facsimiles">
                        <div id="short_title">
                            <h3>
                                <xsl:value-of select="$doc_title"/>
                            </h3>
                        </div>
                        <div id="viewer">
                            <div id="container_facs_1">
                                <!-- container and facs handling in js -->
                            </div>
                            <div class="image_rights">
                                <div class="row">
                                    <button class="osd_nav_element" id="osd_prev_button">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
                                            <!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
                                            <path fill="#f8f9ec" d="M9.4 233.4c-12.5 12.5-12.5 32.8 0 45.3l128 128c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L109.3 288 480 288c17.7 0 32-14.3 32-32s-14.3-32-32-32l-370.7 0 73.4-73.4c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0l-128 128z" />
                                        </svg>
                                    </button>
                                    <button class="osd_nav_element" id="osd_next_button">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
                                            <!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
                                            <path fill="#f8f9ec" d="M502.6 278.6c12.5-12.5 12.5-32.8 0-45.3l-128-128c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L402.7 224 32 224c-17.7 0-32 14.3-32 32s14.3 32 32 32l370.7 0-73.4 73.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0l128-128z" />
                                        </svg>
                                    </button>
                                    <button class="osd_nav_element" id="osd_zoom_out_button">–</button>
                                    <button class="osd_nav_element" id="osd_zoom_reset_button">
                                        <svg xmlns="http://www.w3.org/2000/svg" height="2.5rem" width="auto" viewBox="0 0 384 512">
                                            <!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
                                            <path fill="#f8f9ec" d="M64 464c-8.8 0-16-7.2-16-16V64c0-8.8 7.2-16 16-16H224v80c0 17.7 14.3 32 32 32h80V448c0 8.8-7.2 16-16 16H64zM64 0C28.7 0 0 28.7 0 64V448c0 35.3 28.7 64 64 64H320c35.3 0 64-28.7 64-64V154.5c0-17-6.7-33.3-18.7-45.3L274.7 18.7C262.7 6.7 246.5 0 229.5 0H64zm56 256c-13.3 0-24 10.7-24 24s10.7 24 24 24H264c13.3 0 24-10.7 24-24s-10.7-24-24-24H120zm0 96c-13.3 0-24 10.7-24 24s10.7 24 24 24H264c13.3 0 24-10.7 24-24s-10.7-24-24-24H120z" />
                                        </svg>
                                    </button>
                                    <button class="osd_nav_element" id="osd_zoom_in_button">+</button>
                                </div>
                                <p>Das Original befindet sich im Eigentum des
                                                Österreichischen Staatsarchivs unter der <span style="font-weight: bold;">ÖStA-Signatur „
                                    <xsl:value-of select='//tei:msDesc/tei:msIdentifier/tei:idno[@type = "archive"]/text()[1]/normalize-space()'
                                                  /> “.</span> Die Verwendung des Digitalisats durch
                                                Dritte bedarf einer schriftlichen Bewilligung des
                                                ÖStA entsprechend der geltenden
                                                Benutzungsordnung.</p>
</div>
</div>
</div>
<div id="text-resize" lang="de" class="col-md-6 col-lg-6 col-sm-12 text yes-index">
                                        <div id="section">
                                            <xsl:for-each select="//tei:body/tei:div">
                                                <div class="card-body non_mimetic_lbs">
                                                    <xsl:apply-templates/>
                                                </div>
                                                <xsl:if test="//tei:note[@type = 'footnote']">
                                                    <div class="card-footer">
                                                        <a class="anchor" id="footnotes"/>
                                                        <ul class="footnotes">
                                                            <xsl:for-each select="//tei:note[@place = 'foot']">
                                                                <li>
                                                                    <a class="anchorFoot" id="{@xml:id}"/>
                                                                    <span class="footnote_link">
                                                                        <a href="#{@xml:id}_inline" class="nounderline">
                                                                            <xsl:value-of select="@n"/>
                                                                        </a>
                                                                    </span>
                                                                    <span class="footnote_text">
                                                                        <xsl:apply-templates/>
                                                                    </span>
                                                                </li>
                                                            </xsl:for-each>
                                                        </ul>
                                                    </div>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </div>
                                <!-- create list* elements for entities bs-modal -->
                                <xsl:for-each select="//tei:back">
                                    <div class="tei-back">
                                        <xsl:apply-templates/>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>
                        <xsl:call-template name="html_footer"/>
                    </div>
                    <script src="https://unpkg.com/de-micro-editor@0.4.0/dist/de-editor.min.js"/>
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/openseadragon.min.js"/>
                    <script type="text/javascript" src="js/osd_scroll.js"/>
                    <script type="text/javascript" src="js/run.js"/>
                    <script type="text/javascript" src="js/offcanvastoggler.js"/>
                    <script type="text/javascript" src="js/toggle_shortTitle.js"/>
                </body>
            </html>
        </xsl:template>
        <xsl:template match="tei:div[parent::tei:div]">
            <!-- this is for sections, subsections and articles-->
            <xsl:variable name="type_attrib" select="@type"/>
            <div>
                <xsl:attribute name="class">
                    <xsl:value-of select="$type_attrib"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </div>
        </xsl:template>
        <xsl:template match="tei:pb">
            <!-- needed for scrolling / numbering -->
            <span class="anchor-pb"/>
            <!-- determine img src -->
            <xsl:variable name="pbId">
                <xsl:value-of select="replace(data(@facs), '#', '')"/>
            </xsl:variable>
            <xsl:variable name="surfaceNode" as="node()">
                <xsl:value-of select="//tei:graphic[@xml:id = $pbId]"/>
            </xsl:variable>
            <xsl:variable name="facsUrl">
                <xsl:value-of select="data(//tei:surface[@xml:id = $pbId]/tei:graphic/@url)"/>
            </xsl:variable>
            <xsl:variable name="page_number">
                <xsl:number level="any"/>
            </xsl:variable>
            <span class="pb" source="{$facsUrl}" n="{$page_number}" style="--page_before: '{($page_number - 1)}'; --beginning_page: '{$page_number}';"/>
            <span n="{$page_number}" class="pb_marker"/>
        </xsl:template>
        <xsl:template match="tei:ab">
            <p>
                <xsl:apply-templates/>
            </p>
        </xsl:template>
        <xsl:template match="text()[following-sibling::*[1][local-name() = 'lb' and @break = 'no']]">
            <xsl:value-of select="replace(., '^(.+?)\s*$', '$1')"/>
        </xsl:template>
        <xsl:template match="text()[preceding-sibling::*[1][local-name() = 'lb' and @break = 'no' and not(preceding-sibling::node()[self::text()])]]">
            <xsl:value-of select="replace(., '^\s*(.+?)$', '$1')"/>
        </xsl:template>
        <xsl:template match="tei:lb"/>
        <!-- match paragraphs and listitems with labels; secure whitespaces -->
        <xsl:template match="//tei:body//tei:item[preceding-sibling::*[1][local-name() = 'label']]">
            <xsl:variable name="label_element">
                <xsl:value-of select="./preceding-sibling::tei:label[1]"/>
            </xsl:variable>
            <xsl:variable name="label_text">
                <xsl:choose>
                    <xsl:when test="$label_element/following-sibling::text()[starts-with(., ' ')]">
                        <xsl:value-of select="$label_element/normalize-space()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($label_element/normalize-space(), ' ')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <li>
                <span class="number_label">
                    <xsl:value-of select="$label_text"/>
                </span>
                <xsl:apply-templates/>
            </li>
        </xsl:template>
        <!-- paragraphs -->
        <xsl:template match="tei:p">
            <xsl:choose>
                <xsl:when test="@type = 'legal_section'">
                    <xsl:choose>
                        <xsl:when test="./tei:label">
                            <xsl:variable name="label_element">
                                <xsl:value-of select="./tei:label[1]"/>
                            </xsl:variable>
                            <xsl:variable name="label_text">
                                <xsl:choose>
                                    <xsl:when test="$label_element/following-sibling::text()[starts-with(., ' ')]">
                                        <xsl:value-of select="$label_element/normalize-space()"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($label_element/normalize-space(), ' ')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <p class="legal_section numbered">
                                <span class="number_label">
                                    <xsl:value-of select="$label_text"/>
                                </span>
                                <xsl:apply-templates/>
                            </p>
                        </xsl:when>
                        <xsl:otherwise>
                            <p class="legal_section">
                                <xsl:apply-templates/>
                            </p>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <p>
                        <xsl:apply-templates/>
                    </p>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:template>
        <xsl:template match="tei:lg">
            <p>
                <xsl:apply-templates/>
            </p>
        </xsl:template>
        <xsl:template match="tei:note">
            <xsl:choose>
                <xsl:when test="@place = 'foot'">
                    <a class="anchorFoot" id="{@xml:id}_inline"/>
                    <a href="#{@xml:id}" title="Fußnote {@n}" class="nounderline">
                        <sup>
                            <xsl:value-of select="@n"/>
                        </sup>
                    </a>
                </xsl:when>
                <xsl:when test="@place = 'end'">
                    <a class="anchorFoot" id="{@xml:id}_inline"/>
                    <a href="#{@xml:id}" title="Fußnote {@n}" class="nounderline">
                        <sup>
                            <xsl:value-of select="@n"/>
                        </sup>
                    </a>
                </xsl:when>
            </xsl:choose>
        </xsl:template>
        <!-- delete empty p/hi/div elements -->
        <xsl:template match="
            *[
            (
            local-name() = 'p'
            or local-name() = 'hi'
            or local-name() = 'div'
            )
            and
            not(@* | * | comment() | processing-instruction())
            and normalize-space() = '']"/>
        <xsl:template match="//tei:body//tei:head">
            <!-- find level of head between 1 and 6, the level is not semantical, the hirarchy never interruptet-->
            <xsl:variable name="is_single" select="boolean(count(parent::*/tei:head) = 1)"/>
            <xsl:variable name="is_first" select="boolean(not(preceding-sibling::tei:head))"/>
            <xsl:variable name="head_level_number_raw" select="count(ancestor::tei:div[ancestor::tei:body/tei:div])"/>
            <xsl:variable name="head_level_number">
                <xsl:choose>
                    <xsl:when test="$head_level_number_raw gt 6">6</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$head_level_number_raw"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="heading_element_name" select="concat('h', $head_level_number)"/>
            <xsl:element name="{$heading_element_name}">
                <xsl:attribute name="class">
                    <xsl:value-of select="@class"/>
                    <xsl:choose>
                        <xsl:when test="$is_single">
                            <xsl:value-of select="' single'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="' multiple'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="$is_first">
                            <xsl:value-of select="' first'"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
        <xsl:template match="tei:emph">
            <b>
                <xsl:apply-templates/>
            </b>
        </xsl:template>
        <xsl:template match="tei:fw">
            <span class="historical_pagecounter">
                <xsl:apply-templates/>
            </span>
        </xsl:template>
        <!-- these are already handled above -->
        <xsl:template match="//tei:body//tei:list">
            <ul>
                <xsl:apply-templates/>
            </ul>
        </xsl:template>
        <xsl:template match="//tei:body//tei:label"/>
        <xsl:template match="//tei:note[@type = 'comment']">
            <div class="meta_text">
                <xsl:apply-templates/>
            </div>
        </xsl:template>
        <!-- deal with text features-->
        <xsl:template match="tei:corr"/>
        <xsl:template match="tei:sic"/>
        <xsl:template match="tei:choice[tei:corr]">
            <span class="corr sic">
                <xsl:value-of select="./tei:sic/text()"/>
            </span>
            <span class="corr conjectur">
                <xsl:value-of select="concat('[', ./tei:corr/text(), ']')"/>
            </span>
            <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="//tei:choice[not(tei:corr)]">
            <xsl:variable name="element_name">
                <xsl:value-of select="if (./*[local-name()='p' or local-name()='div' or local-name()='ab']) then 'div' else 'span'"/>
            </xsl:variable>
            <xsl:element name="{$element_name}">
                <xsl:attribute name="class">
                    <xsl:value-of select="'choice text_genetic'" />
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
        <xsl:template match="tei:del">
            <xsl:variable name="element_name">
                <xsl:value-of select="if (./*[local-name()='p' or local-name()='div' or local-name()='ab']) then 'div' else 'span'"/>
            </xsl:variable>
            <xsl:element name="{$element_name}">
                <xsl:attribute name="class">
                    <xsl:value-of select="'del text_genetic'" />
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
        <xsl:template match="tei:add">
            <xsl:variable name="element_name">
                <xsl:value-of select="if (./*[local-name()='p' or local-name()='div' or local-name()='ab']) then 'div' else 'span'"/>
            </xsl:variable>
            <xsl:element name="{$element_name}">
                <xsl:attribute name="class">
                    <xsl:value-of select="'add text_genetic'" />
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
    </xsl:stylesheet>
