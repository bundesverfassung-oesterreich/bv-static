<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:variable name="target_xml">
        <xsl:value-of select="'./xml-sources'"/>
    </xsl:variable>
    <xsl:variable name="target_pdf">
        <xsl:value-of select="'./pdf-sources'"/>
    </xsl:variable>
    <xsl:variable name="doc_id">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:template name="build_doc_sub_list">
        <!-- This build the list to navigate through documents -->
        <xsl:param name="id_name_for_toggle"></xsl:param>
        <xsl:param name="data_set_id_transkribus"></xsl:param>
        <xsl:param name="heading"></xsl:param>
        <xsl:param name="expanded" as="xs:string" select="'false'"/>
        <li>
            <button class="btn btn-toggle align-items-start justify-content-start rounded collapsed" data-bs-toggle="collapse" data-bs-target="#{$id_name_for_toggle}" aria-expanded="{$expanded}">
                <xsl:value-of select="$heading"/>
            </button>
            <div class="collapse " id="{$id_name_for_toggle}">
                <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                    <xsl:for-each select="collection('../../data/editions/')//tei:TEI[.//tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type='transkribus_collection' and ./text()=$data_set_id_transkribus]]">
                        <xsl:variable as="xs:string" name="text_title" select="//tei:fileDesc//tei:titleStmt//tei:title[@type='main']/normalize-space()"/>
                        <xsl:variable as="xs:string" name="page_uri" select="replace(tokenize(document-uri(/), '/')[last()], '.xml', '.html')"/>
                        <li>
                            <a class="dropdown-item" href="{$page_uri}" title="{$text_title}">
                                <xsl:value-of select="$text_title"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </li>
    </xsl:template>

    <xsl:template name="get_article_nav">
        <xsl:for-each select=".//tei:div[@type='article']">
            <xsl:variable name="article_title" select="./tei:head[not(ancestor::tei:quote)][1]/normalize-space()"/>
            <li>
                <a class="dropdown-item" title="{$article_title}">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('#', (.//tei:head[not(ancestor::tei:quote)][1]/@xml:id)[1])"/>
                    </xsl:attribute>
                    <xsl:value-of select="$article_title"/>
                </a>
            </li>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="get_strict_article_nav">
        <xsl:for-each select="./tei:div[@type='article']">
            <xsl:variable name="article_title" select="./tei:head[not(ancestor::tei:quote)][1]/normalize-space()"/>
            <li>
                <a class="dropdown-item" title="{$article_title}">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('#', (.//tei:head[not(ancestor::tei:quote)][1]/@xml:id)[1])"/>
                    </xsl:attribute>
                    <xsl:value-of select="$article_title"/>
                </a>
            </li>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="get_subsection_and_article_nav">
        <xsl:variable name="subsection_divs" select="./tei:div[contains(@type, 'section')]"/>
        <xsl:variable name="subsection_divs_exist" select="if ($subsection_divs) then 'true' else 'false'"/>
        <xsl:choose>
            <xsl:when test="$subsection_divs_exist = 'true'">
                <xsl:for-each select="$subsection_divs">
                    <li>
                        <xsl:variable name="derived_target_id_for_button" select="concat('target_of_', (.//tei:head[not(ancestor::tei:quote)]/@xml:id)[1])"/>
                        <button class="btn btn-toggle align-items-start collapsed" data-bs-toggle="collapse" data-bs-target="#{$derived_target_id_for_button}" aria-expanded="false">
                            <xsl:value-of select="./tei:head[not(ancestor::tei:quote)][1]/normalize-space()"/>
                        </button>
                        <div class="collapse " id="{$derived_target_id_for_button}">
                            <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                                <xsl:call-template name="get_subsection_and_article_nav"/>
                            </ul>
                        </div>
                    </li>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="get_strict_article_nav"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get_chapter_and_article_nav">
        <xsl:variable name="toplevel_section_divs" select=".//tei:body//tei:div[contains(@type, 'section') and not(ancestor::tei:div[contains(@type, 'section')])]"/>
        <xsl:variable name="toplevel_section_divs_exist" select="if ($toplevel_section_divs) then 'true' else 'false'"/>
        <xsl:choose>
            <xsl:when test="$toplevel_section_divs_exist = 'true'">
                <xsl:for-each select="$toplevel_section_divs">
                    <li>
                        <xsl:variable name="derived_target_id_for_button" select="concat('target_of_', (.//tei:head[not(ancestor::tei:quote)][1]/@xml:id)[1])"/>
                        <button class="btn btn-toggle align-items-start collapsed" data-bs-toggle="collapse" data-bs-target="#{$derived_target_id_for_button}" aria-expanded="false">
                            <xsl:value-of select="./tei:head[not(ancestor::tei:quote)][1]/normalize-space()"/>
                        </button>
                        <div class="collapse " id="{$derived_target_id_for_button}">
                            <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                                <xsl:call-template name="get_subsection_and_article_nav"/>
                            </ul>
                        </div>
                    </li>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="get_article_nav"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get_chapter_and_article_nav_B">
        <xsl:variable name="section_divs" select=".//tei:body//tei:div[contains(@type, 'section')]"/>
        <xsl:for-each select="$section_divs">
            <xsl:variable name="section_title" select="./tei:head[not(ancestor::tei:quote)][1]/normalize-space()"/>
            <li>
                <a class="dropdown-item" title="{$section_title}">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('#', (.//tei:head[not(ancestor::tei:quote)][1]/@xml:id)[1])"/>
                    </xsl:attribute>
                    <xsl:value-of select="$section_title"/>
                </a>
            </li>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="edition_side_nav">
        <xsl:param name="doc_title"/>
        <xsl:variable name="data_set" select="//tei:idno[@type='bv_data_set']/text()"/>
        <div id="edtion-navBarNavDropdown" class="dropstart navBarNavDropdown">
            <xsl:variable name="data_set_A_id" as="xs:string" select="string(195363)"/>
            <xsl:variable name="data_set_B_id" as="xs:string" select="string(196428)"/>
            <xsl:variable name="data_set_C_id" as="xs:string" select="string(196429)"/>
            <ul id="left_edition_content_nav" class="list-unstyled ps-0">
                <li class="mb-1">
                    <button class="btn btn-toggle align-items-start justify-content-start rounded collapsed" data-bs-toggle="collapse" data-bs-target="#docs-collapse" aria-expanded="false">
                        Alle Dokumente
                    </button>
                    <div class="collapse" id="docs-collapse">
                        <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                            <xsl:call-template name="build_doc_sub_list">
                                <xsl:with-param name="id_name_for_toggle" select="'data_set_A_nav_toggle'"/>
                                <xsl:with-param name="data_set_id_transkribus" select="$data_set_A_id"/>
                                <xsl:with-param name="heading" select="'Verfassungesentwürfe'"/>
                                <xsl:with-param name="expanded" select="'true'"/>
                            </xsl:call-template>
                            <xsl:call-template name="build_doc_sub_list">
                                <xsl:with-param name="id_name_for_toggle" select="'data_set_B_nav_toggle'"/>
                                <xsl:with-param name="data_set_id_transkribus" select="$data_set_B_id"/>
                                <xsl:with-param name="heading" select="'Protokolle'"/>
                            </xsl:call-template>
                            <xsl:call-template name="build_doc_sub_list">
                                <xsl:with-param name="id_name_for_toggle" select="'data_set_C_nav_toggle'"/>
                                <xsl:with-param name="data_set_id_transkribus" select="$data_set_C_id"/>
                                <xsl:with-param name="heading" select="'Sonstige'"/>
                            </xsl:call-template>
                        </ul>
                    </div>
                </li>
                <xsl:choose>
                    <xsl:when test="$data_set = 'Datenset A'">
                        <li class="mb-1">
                            <button class="btn btn-toggle align-items-start justify-content-start rounded collapsed" data-bs-toggle="collapse" data-bs-target="#current-doc-collapse" aria-expanded="false">
                                <p>
                                    <xsl:value-of select="$doc_title" />
                                </p>
                            </button>
                            <div class="collapse" id="current-doc-collapse">
                                <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                                    <xsl:call-template name="get_chapter_and_article_nav"/>
                                </ul>
                            </div>
                        </li>
                    </xsl:when>
                    <xsl:when test="$data_set = 'Datenset B'">
                        <li class="mb-1">
                            <button class="btn btn-toggle align-items-start justify-content-start rounded collapsed" data-bs-toggle="collapse" data-bs-target="#current-doc-collapse" aria-expanded="false">
                                <p>
                                    <xsl:value-of select="$doc_title" />
                                </p>
                            </button>
                            <div class="collapse" id="current-doc-collapse">
                                <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                                    <xsl:call-template name="get_chapter_and_article_nav_B"/>
                                </ul>
                            </div>
                        </li>
                    </xsl:when>
                    <xsl:when test="$data_set = 'Datenset C'">
                        <li class="mb-1">
                            <button class="btn btn-toggle align-items-start justify-content-start rounded collapsed" data-bs-toggle="collapse" data-bs-target="#current-doc-collapse" aria-expanded="false">
                                <p>
                                    <xsl:value-of select="$doc_title" />
                                </p>
                            </button>
                            <div class="collapse" id="current-doc-collapse">
                                <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                                    <xsl:call-template name="get_chapter_and_article_nav"/>
                                </ul>
                            </div>
                        </li>
                    </xsl:when>
                </xsl:choose>
            </ul>
        </div>

    </xsl:template>
</xsl:stylesheet>