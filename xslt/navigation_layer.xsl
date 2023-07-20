<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:head">
        <!-- add anker for navigation if it is head of article or section -->
        <xsl:if test="not(preceding-sibling::tei:head)">
            <!-- determine if article or section -->
            <xsl:variable name="item_class">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:div[1][@ana ='article']">article</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="ancestor::tei:div[1]/@ana"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- create id for ref-->
            <xsl:variable name="anker_id">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:div[1][@ana = 'article']">
                        <xsl:value-of select="'article_'"/>
                        <xsl:number count="tei:div[@ana = 'article']" format="1" level="any"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'section_'"/>
                        <xsl:number count="tei:div[@ana = 'section' or @ana = 'sub_section' or @ana = 'sub_sub_section']" level="any"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <a class="{$item_class}" xml:id="{$anker_id}"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
    