<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:import href="./editions.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:variable name="is_image_only" as="xs:boolean" select="exists(//tei:body//tei:pb) and not(exists(//tei:body//text()[normalize-space()])) and not(exists(//tei:body//tei:*[not(self::tei:body or self::tei:div or self::tei:pb)]))"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$is_image_only">
                <xsl:call-template name="render-image-only-edition"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="render-standard-edition"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="render-image-only-edition">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
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
            <body class="page image-only-page" lang="de">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar">
                        <xsl:with-param name="edition_buttons" as="xs:boolean" select="true()"/>
                        <xsl:with-param name="doc_title" as="xs:string" select="$doc_title"/>
                    </xsl:call-template>
                    <div class="edition_container image-only-edition-container">
                        <div class="wp-transcript image-only-transcript">
                            <xsl:call-template name="render-edition-metadata">
                                <xsl:with-param name="revision-state" select="$revision_state"/>
                                <xsl:with-param name="revision-label" select="'Text nicht erfasst.'"/>
                                <xsl:with-param name="revision-extra-class" select="'image_only'"/>
                            </xsl:call-template>
                            <div id="container-resize" class="row transcript active image-only-layout justify-content-center">
                                <div id="img-resize" class="col-12 col-lg-10 col-xl-8 facsimiles image-only-column">
                                    <div id="short_title">
                                        <h3>
                                            <xsl:value-of select="$doc_title"/>
                                        </h3>
                                    </div>
                                    <div id="viewer" class="image-only-viewer">
                                        <div id="container_facs_1">
                                            <!-- container and facs handling in js -->
                                        </div>
                                        <div id="image-source-list" class="image-source-list visually-hidden" aria-hidden="true">
                                            <xsl:for-each select="//tei:body//tei:pb">
                                                <xsl:variable name="pbId" select="replace(data(@facs), '#', '')"/>
                                                <span class="image-source">
                                                    <xsl:attribute name="data-image-url">
                                                        <xsl:value-of select="data(//tei:surface[@xml:id = $pbId]/tei:graphic/@url)"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="data-page-number">
                                                        <xsl:value-of select="position()"/>
                                                    </xsl:attribute>
                                                </span>
                                            </xsl:for-each>
                                        </div>
                                        <xsl:call-template name="render-image-viewer-controls"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
                <script src="js/openseadragon.min.js"/>
                <script type="text/javascript" src="js/osd_scroll_image_only.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>