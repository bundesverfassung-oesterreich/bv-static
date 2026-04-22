<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/meta_tags.xsl"/>
    <xsl:variable name="wrong_link_prefix" select="'http://.'"/>
    <xsl:template match="/">
        <xsl:variable name="main_title" select="normalize-space(//tei:fileDesc/tei:titleStmt/tei:title[@type = 'main'][1])"/>
        <xsl:variable name="sub_title" select="normalize-space(//tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub'][1])"/>
        <xsl:variable name="doc_title" select="if ($sub_title != '') then string-join(($main_title, $sub_title), ' – ') else $main_title"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <xsl:call-template name="meta-tags">
                    <xsl:with-param name="title" select="$doc_title"/>
                    <xsl:with-param name="source_authors" select="//tei:msDesc/tei:msContents/tei:msItem/tei:author/text()"/>
                    <xsl:with-param name="description" select="'Die Entstehung der Österreichischen Bundes-Verfassung 1920'"/>
                </xsl:call-template>
                <link rel="stylesheet" href="css/commentary.css" type="text/css"/>
            </head>
            <body class="page" lang="de">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <main id="content" role="main">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-9 col-lg-6 col-sm-12 commentary_container">
                                    <xsl:call-template name="content_overview"/>
                                    <xsl:apply-templates select="//tei:body"/>
                                    <xsl:call-template name="footnotes"/>
                                </div>
                            </div>
                        </div>
                    </main>
                    <xsl:call-template name="html_footer"/>
                </div>
                <script type="text/javascript" src="js/commentary.js"></script>
            </body>
        </html>
    </xsl:template>
    <!-- generic div handling; editorialChapter divs get a specialized template below -->
    <xsl:template match="tei:div">
        <div>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@type">
                <xsl:attribute name="class">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <!-- commentary chapter divs: no id on the wrapper; the id moves to the heading -->
    <xsl:template match="tei:div[@type='editorialChapter']">
        <div>
            <xsl:attribute name="class">
                <xsl:text>editorialChapter</xsl:text>
                <xsl:if test="preceding-sibling::*[1][self::tei:head]">
                    <xsl:text> reduced_top_padding</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <xsl:variable name="level">
            <xsl:value-of select="string(count(ancestor::tei:div[@type='editorialChapter']))"/>
        </xsl:variable>
        <!-- use the xml:id of the nearest editorialChapter ancestor as the heading id -->
        <xsl:variable name="heading_id" select="ancestor::tei:div[@type='editorialChapter'][1]/@xml:id"/>
        <xsl:variable name="heading_name">
            <xsl:choose>
                <xsl:when test="@type=('main', 'sub')">
                    <xsl:value-of select="'h1'"/>
                </xsl:when>
                <xsl:when test="$level='1'">
                    <xsl:value-of select="'h2'"/>
                </xsl:when>
                <xsl:when test="$level='2'">
                    <xsl:value-of select="'h3'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'h4'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$heading_name}">
            <xsl:if test="$heading_id">
                <xsl:attribute name="id">
                    <xsl:value-of select="$heading_id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="@type='main'">
                        <xsl:value-of select="'main_heading'"/>
                    </xsl:when>
                    <xsl:when test="@type='sub'">
                        <xsl:value-of select="'sub_heading'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="' '"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:body/tei:p[1]">
        <h1 id="{generate-id()}">
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    <xsl:template match="tei:p">
        <p id="{generate-id()}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul id="{generate-id()}">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li id="{generate-id()}">
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:table">
        <div>
            <xsl:attribute name="class">
                <xsl:text>commentary_overview</xsl:text>
                <xsl:if test="@type">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="@type"/>
                </xsl:if>
            </xsl:attribute>
            <dl id="{generate-id()}">
                <xsl:apply-templates/>
            </dl>
        </div>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:cell[not(preceding-sibling::tei:cell)]">
        <!-- match first cell, containing the lable -->
        <dt>
            <xsl:apply-templates/>
        </dt>
    </xsl:template>
    <xsl:template match="tei:cell[preceding-sibling::tei:cell]">
        <!-- match second cell containing the data -->
        <dd>
            <xsl:apply-templates/>
        </dd>
    </xsl:template>
    <xsl:template match="tei:hi[contains(@rend, 'bold') or contains(@rendition, 'bold')]">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:note[@type='footnote']">
        <!-- footnote anchor gets builded here, footnotes get generated at end of page-->
        <sup>
            <a class="footnote_anchor">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('#', @xml:id)"/>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="concat('footnote_anchor_', @xml:id)"/>
                </xsl:attribute>
                <xsl:number level="any"/>
            </a>
        </sup>
    </xsl:template>
    <xsl:template name="footnotes">
        <xsl:if test="//tei:note[@type='footnote']">
            <div class="footnote_container">
                <xsl:for-each select="//tei:note[@type='footnote']">
                    <div class="footnote">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                        <div class="footnote_number">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('#footnote_anchor_', @xml:id)"/>
                                </xsl:attribute>
                                <xsl:number level="any"/>
                            </a>
                        </div>
                        <div class="footnote_text">
                            <xsl:apply-templates mode="footnote"/>
                        </div>
                    </div>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template mode="footnote" match="tei:p">
        <p class="footnote_paragraph">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <!-- content overview / heading tree -->
    <xsl:template name="content_overview">
        <input type="checkbox" id="commentary_toc_toggle" class="commentary_toc_toggle"/>
        <label for="commentary_toc_toggle" class="commentary_toc_toggle_button">
            <svg xmlns="http://www.w3.org/2000/svg" class="btn btn-primary" height="2.25em" viewBox="0 0 576 512">
                <path d="M495.9 166.6c3.2 8.7 .5 18.4-6.4 24.6l-43.3 39.4c1.1 8.3 1.7 16.8 1.7 25.4s-.6 17.1-1.7 25.4l43.3 39.4c6.9 6.2 9.6 15.9 6.4 24.6c-4.4 11.9-9.7 23.3-15.8 34.3l-4.7 8.1c-6.6 11-14 21.4-22.1 31.2c-5.9 7.2-15.7 9.6-24.5 6.8l-55.7-17.7c-13.4 10.3-28.2 18.9-44 25.4l-12.5 57.1c-2 9.1-9 16.3-18.2 17.8c-13.8 2.3-28 3.5-42.5 3.5s-28.7-1.2-42.5-3.5c-9.2-1.5-16.2-8.7-18.2-17.8l-12.5-57.1c-15.8-6.5-30.6-15.1-44-25.4L83.1 425.9c-8.8 2.8-18.6 .3-24.5-6.8c-8.1-9.8-15.5-20.2-22.1-31.2l-4.7-8.1c-6.1-11-11.4-22.4-15.8-34.3c-3.2-8.7-.5-18.4 6.4-24.6l43.3-39.4C64.6 273.1 64 264.6 64 256s.6-17.1 1.7-25.4L22.4 191.2c-6.9-6.2-9.6-15.9-6.4-24.6c4.4-11.9 9.7-23.3 15.8-34.3l4.7-8.1c6.6-11 14-21.4 22.1-31.2c5.9-7.2 15.7-9.6 24.5-6.8l55.7 17.7c13.4-10.3 28.2-18.9 44-25.4l12.5-57.1c2-9.1 9-16.3 18.2-17.8C227.3 1.2 241.5 0 256 0s28.7 1.2 42.5 3.5c9.2 1.5 16.2 8.7 18.2 17.8l12.5 57.1c15.8 6.5 30.6 15.1 44 25.4l55.7-17.7c8.8-2.8 18.6-.3 24.5 6.8c8.1 9.8 15.5 20.2 22.1 31.2l4.7 8.1c6.1 11 11.4 22.4 15.8 34.3zM256 336a80 80 0 1 0 0-160 80 80 0 1 0 0 160z"></path>
            </svg>
        </label>
        <nav class="commentary_toc">
            <ul>
                <!-- start from top-level editorial chapters in the body -->
                <xsl:apply-templates select="//tei:body/tei:div[@type='editorialChapter']" mode="toc"/>
            </ul>
        </nav>
    </xsl:template>

    <xsl:template match="tei:div[@type='editorialChapter']" mode="toc">
        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('#', @xml:id)"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(tei:head[1])"/>
            </a>
            <!-- recurse into nested editorial chapters, if any -->
            <xsl:if test="tei:div[@type='editorialChapter']">
                <ul>
                    <xsl:apply-templates select="tei:div[@type='editorialChapter']" mode="toc"/>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    <!-- generic handling of references so that links render correctly -->
    <xsl:template match="tei:ref">
        <xsl:choose>
            <!-- fix malformed http://.example links -->
            <xsl:when test="starts-with(normalize-space(@target), $wrong_link_prefix)">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="substring(normalize-space(@target), string-length($wrong_link_prefix) + 1)"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <!-- absolute http/https links -->
            <xsl:when test="starts-with(normalize-space(@target), 'http')">
                <a href="{normalize-space(@target)}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <!-- internal fragment links -->
            <xsl:when test="starts-with(normalize-space(@target), '#')">
                <a href="{normalize-space(@target)}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <!-- links to other local HTML documents, e.g. bv_doc_id__2 -->
            <xsl:when test="not(contains(normalize-space(@target), '://'))">
                <xsl:variable name="t" select="normalize-space(@target)"/>
                <xsl:variable name="href" select="if (ends-with($t, '.html') or ends-with($t, '.htm')) then $t else concat($t, '.html')"/>
                <a href="{$href}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ensure links also work inside rendered footnotes -->
    <xsl:template mode="footnote" match="tei:ref">
        <!-- delegate to the default-mode tei:ref template so links are rendered -->
        <xsl:apply-templates select="." mode="#default"/>
    </xsl:template>
</xsl:stylesheet>
