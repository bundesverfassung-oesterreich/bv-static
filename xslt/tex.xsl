<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all" version="2.0">
<xsl:output method="text"/>

    <xsl:template match="tei:del | tei:sic | tei:fw | tei:pb | tei:teiHeader | tei:div"/>

    <xsl:template match="/">
            
        \documentclass{article}
        \usepackage[utf8]{inputenc}
        \usepackage[ngerman]{babel}
        \usepackage{microtype}
        \usepackage{enumitem}

        \begin{document}

        \title{<xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/> \\[10pt]
            \large <xsl:value-of select=".//tei:titleStmt/tei:title[2]/text()"/>}
        \author{<xsl:value-of select=".//tei:sourceDesc//tei:author"/>}
        \date{<xsl:value-of select=".//tei:profileDesc//tei:creation/tei:date"/>}

        \maketitle

        <xsl:for-each select=".//tei:div[@type='section']">
            <xsl:for-each select="tei:head">
                \section*{<xsl:value-of select="normalize-space(.)"/>}
            </xsl:for-each>
            <xsl:for-each select="tei:p[not(@type)]">
                <xsl:apply-templates select="./text()"/>
            </xsl:for-each>

            <xsl:for-each select="tei:div[@type='article']">
                <xsl:for-each select="tei:head">
                    \subsection*{<xsl:value-of select="normalize-space(.)"/>}
                </xsl:for-each>
                <xsl:for-each select="tei:p[@type='legal_section']">
                    <xsl:apply-templates select="tei:list | ./text()"/>
                    \\\\
                </xsl:for-each>
                <xsl:apply-templates select="tei:note[@type='comment']"/>
            </xsl:for-each>
        </xsl:for-each>

        <xsl:apply-templates/>

        \end{document}

    </xsl:template>

    <xsl:template match="tei:note[@type='comment']">
        \paragraph*{<xsl:value-of select="."/>}
    </xsl:template>

    <xsl:template match="tei:list">
        <xsl:choose>
            <xsl:when test="matches(tei:label[1], '[A-Za-z]')">
                \begin{enumerate}[label=\alph*)]
            </xsl:when>
            <xsl:otherwise>
                \begin{enumerate}
            </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="tei:item">
            \item <xsl:value-of select="normalize-space(.)"/>
        </xsl:for-each>
        \end{enumerate}
    </xsl:template>

</xsl:stylesheet>