<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/osd-container.xsl"/>
    <xsl:import href="partials/tei-facsimile.xsl"/>
    <xsl:import href="partials/shared.xsl"/>
    <xsl:import href="partials/aot-options.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:title[@type = 'label'][1]/text()"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:title[@type = 'main'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>

                    <div class="container-fluid">
                        <div class="wp-transcript">
                            <div class="card-header">
                                <div class="row">
                                    <div class="col-md-2 col-lg-2 col-sm-12">
                                        <xsl:if test="ends-with($prev, '.html')">
                                            <h1>
                                                <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="replace($prev, '.html', '_facsimile.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <i class="fas fa-chevron-left" title="prev"/>
                                                </a>
                                            </h1>
                                        </xsl:if>
                                    </div>
                                    <div class="col-md-8 col-lg-8 col-sm-12">
                                        <h1 align="center">
                                            <xsl:value-of select="$doc_title"/>
                                        </h1>
                                        <h3 align="center">
                                            <a href="{$teiSource}">
                                                <i class="fas fa-download" title="show TEI source"/>
                                            </a>
                                        </h3>
                                    </div>
                                    <div class="col-md-2 col-lg-2 col-sm-12"
                                        style="text-align:right">
                                        <xsl:if test="ends-with($next, '.html')">
                                            <h1>
                                                <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="replace($next, '.html', '_facsimile.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <i class="fas fa-chevron-right" title="next"/>
                                                </a>
                                            </h1>
                                        </xsl:if>
                                    </div>
                                </div>
                                <div id="editor-widget">
                                    <p>Text Editor</p>
                                    <xsl:call-template name="annotation-options"/>
                                </div>
                            </div>
                            <div id="container-resize" class="row transcript active">
                                <div id="img-resize" class="col-md-6 col-lg-6 col-sm-12 facsimiles">
                                    <div id="viewer">
                                        <p>Das Original befindet sich im Eigentum des Österreichischen Staatsarchivs unter der ÖStA-Signatur „<xsl:value-of select='//tei:msDesc/tei:msIdentifier/tei:idno[@type="archive"]/text()[1]/normalize-space()'/>)“. Die Verwendung des Digitalisats durch Dritte bedarf einer schriftlichen Bewilligung des ÖStA entsprechend der geltenden Benutzungsordnung.</p>
                                        <div id="container_facs_1">
                                            <!-- container and facs handling in js -->
                                        </div>
                                    </div>
                                </div>
                                <div id="text-resize"
                                    class="col-md-6 col-lg-6 col-sm-12 text yes-index">
                                    <div id="section">
                                        <xsl:for-each select="//tei:body/tei:div">
                                            <div class="card-body">
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
                <script src="https://unpkg.com/de-micro-editor@0.2.6/dist/de-editor.min.js"/>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/openseadragon.min.js"/>
                <script type="text/javascript" src="js/osd_scroll.js"/>
                <script type="text/javascript" src="js/run.js"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div[parent::tei:div]">
        <!-- this is for sections, subsections and articles-->
        <xsl:variable name="ana_attrib" select="@ana"/>
        <div>
            <xsl:attribute name="class">
                <xsl:value-of select="$ana_attrib"/>
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
            <xsl:value-of select="//tei:graphic[@xml:id=$pbId]"/>
        </xsl:variable>
        <xsl:variable name="facsUrl">
            <xsl:value-of select="data(//tei:surface[@xml:id=$pbId]/tei:graphic/@url)"/>
        </xsl:variable>
        <span class="anchor-pb"></span>
        <span class="pb" source="{$facsUrl}">
            <xsl:value-of select="@n"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:p | tei:lg">
        <!-- simply keep paragraphs -->
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
    <xsl:template match="tei:head">
        <!-- find level of head between 1 and 6, the level is not semantical, the hirarchy never interruptet-->
        <xsl:variable name="head_level_number_raw"
            select="count(ancestor::tei:div[ancestor::tei:body/tei:div])"/>
        <xsl:variable name="head_level_number">
            <xsl:choose>
                <xsl:when test="$head_level_number_raw gt 6">6</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$head_level_number_raw"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- determine if article or section -->
        <xsl:variable name="item_class">
            <xsl:choose>
                <xsl:when test="ancestor::tei:div[1][@ana = 'article']"> article </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ancestor::tei:div[1]/@ana"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="head_name" select="concat('h', $head_level_number)"/>
        <xsl:element name="{$head_name}">
            <xsl:attribute name="class">
                <xsl:value-of select="$item_class"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
    