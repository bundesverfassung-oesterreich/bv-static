<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <!--<xsl:template match="tei:head[not(preceding-sibling::tei:head)]">-->
    <!-- I dont see any reason to not do it less strict, every heading could be for navigation I guess-->
    <xsl:template match="//tei:body//tei:head">
        <xsl:variable name="anchor_prefix">navigation_</xsl:variable>
        <!-- add anchor for navigation if it is head of article or section -->
        <!-- determine if article or section -->
        <xsl:variable name="item_class">
            <xsl:choose>
                <xsl:when test="ancestor::tei:div[1][@ana ='article']">
                    <xsl:value-of select="concat($anchor_prefix, 'article')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($anchor_prefix, ancestor::tei:div[1]/@ana)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- create id for ref-->
        <xsl:variable name="anchor_id">
            <xsl:choose>
                <xsl:when test="ancestor::tei:div[1][@ana = 'article']">
                    <xsl:value-of select="concat($anchor_prefix, 'article_')"/>
                    <xsl:number count="tei:div[@ana = 'article']" format="1" level="any"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($anchor_prefix, 'section_')"/>
                    <xsl:number count="tei:div[@ana = 'section' or @ana = 'sub_section' or @ana = 'sub_sub_section']" level="any"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- write anchor element -->
        <a class="{$item_class}" xml:id="{$anchor_id}"/>
        <!-- copy head element -->
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
    