<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/meta_tags.xsl"/>
    <xsl:variable name="wrong_link_prefix" select="'http://.'"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select='"B-VG 1920"'/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
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
                    <div class="container">
                        <div class="row">
                            <div class="col-md-9 col-lg-6 col-sm-12 commentary_container">
                                <xsl:apply-templates select="//tei:body"/>
                                <xsl:call-template name="footnotes"/>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>
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
    <!-- <xsl:template match="tei:div//tei:head[not(@type) or @type='editorialHead']">
        <h2 id="{generate-id()}">
            <xsl:if test="./following-sibling::*[1][@type='editorialChapter']">
                <xsl:attribute name="class">
                    <xsl:value-of select="'no_padding'"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="level">
                <xsl:value-of select="count(ancestor::tei:div[@type='editorialChapter'])"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="tei:div//tei:head[@type='main']">
        <h1 id="{generate-id()}" class="main_heading">
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    <xsl:template match="tei:div//tei:head[@type='sub']">
        <h1 id="{generate-id()}" class="sub_heading">
            <xsl:apply-templates/>
        </h1>
    </xsl:template> -->
    <xsl:template match="tei:div//tei:head">
        <xsl:variable name="level">
            <xsl:value-of select="string(count(ancestor::tei:div[@type='editorialChapter']))"/>
        </xsl:variable>
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
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="@type='main'">
                        <xsl:value-of select="'main_heading'"/>
                    </xsl:when>
                    <xsl:when test="@type='sub'">
                        <xsl:value-of select="'sub_heading'"/>
                    </xsl:when>
                    <xsl:when test="./following-sibling::*[1][@type='editorialChapter']">
                        <xsl:value-of select="'no_padding'"/>
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
        <dl id="{generate-id()}">
            <xsl:apply-templates/>
        </dl>
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
                <!--            <xsl:value-of select="concat(@n, ' ')"/>-->
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
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), $wrong_link_prefix)">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="substring(@target, string-length($wrong_link_prefix))" />
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
