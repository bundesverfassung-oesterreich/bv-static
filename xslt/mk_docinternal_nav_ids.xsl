<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xml" version="1.0" indent="no" omit-xml-declaration="yes"/>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//tei:body//tei:head">
        <xsl:variable name="heading_id_prefix">heading_</xsl:variable>
        <!-- find level of head between 1 and 6, the level is not semantical, the hierarchy never interrupted-->
        <xsl:variable name="head_level_number_raw" select="count(ancestor::tei:div[ancestor::tei:body/tei:div])"/>
        <xsl:variable name="head_level_number">
            <xsl:choose>
                <xsl:when test="$head_level_number_raw gt 6">6</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$head_level_number_raw"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- determine if article or section -->
        <xsl:variable name="heading_class">
            <xsl:choose>
                <xsl:when test="ancestor::tei:div[1][@type = 'article']">
                    <xsl:value-of select="'article'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ancestor::tei:div[1]/@type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- calculate id -->
        <xsl:variable name="heading_id">
            <xsl:choose>
                <xsl:when test="$heading_class = 'article'">
                    <xsl:value-of select="concat($heading_id_prefix, 'article_')"/>
                    <xsl:number count="tei:div[@type = 'article']" format="1" level="any"/>
                    <!-- <xsl:number count="tei:head" format="1" level="any"/> -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($heading_id_prefix, 'section_')"/>
                    <xsl:number count="tei:div[@type = 'section']" level="any"/>
                    <!-- <xsl:number count="tei:head" format="1" level="any"/> -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- create hn element -->
        <xsl:element name="head">
            <xsl:attribute name="class">
                <xsl:value-of select="$heading_class"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::tei:head) and not($heading_class = 'main')">
                    <xsl:attribute name="xml:id">
                        <xsl:value-of select="$heading_id"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>