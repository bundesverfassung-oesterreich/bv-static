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
        \usepackage{tcolorbox}

        \setlength\parindent{0pt}

        \newtcolorbox{mynote}[1][]{%
            sharp corners,
            colback=grey,
            boxrule=0pt,
            grow to left by=-1cm,
            grow to right by=-1cm,
            #1
        }

        \begin{document}

        \title{<xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/> \\[10pt]
            \large <xsl:value-of select=".//tei:titleStmt/tei:title[2]/text()"/>}
        \author{<xsl:value-of select=".//tei:sourceDesc//tei:author"/>}
        \date{<xsl:value-of select=".//tei:profileDesc//tei:creation/tei:date"/>}

        \maketitle

        <xsl:choose>
            <xsl:when test="exists(.//tei:text[@type='Verfassungsentwurf' or @type='Verfassungstext'])">
                <xsl:for-each select=".//tei:div[@type='main']/tei:head[@class='main']">
                    \section*{<xsl:value-of select="normalize-space(.)"/>}
                </xsl:for-each>

                <xsl:for-each select=".//tei:div[@type='main']/tei:p | .//tei:div[@type='main']/tei:div[@type='preamble']/tei:p">
                    <xsl:apply-templates/>\\\\
                </xsl:for-each>

                <xsl:for-each select=".//tei:div[@type='section']">
                    <xsl:for-each select="tei:head[@class='section']">
                        \subsection*{<xsl:value-of select="normalize-space(.)"/>}
                    </xsl:for-each>
                    <xsl:for-each select="tei:p[not(@type)]">
                        <xsl:apply-templates select="./text()"/>
                    </xsl:for-each>
                    <xsl:for-each select="tei:note[@type='comment']">
                        <xsl:apply-templates select="tei:note[@type='comment']"/>
                    </xsl:for-each>

                    <xsl:for-each select="tei:div[@type='article']">
                        <xsl:for-each select="tei:head[@class='article']">
                            \subsubsection*{<xsl:apply-templates/>}
                        </xsl:for-each>
                        <xsl:for-each select="tei:p[@type='legal_section']">
                            <xsl:apply-templates select="tei:list | ./text() | tei:note[@type='comment'] | tei:emph"/>
                            \\\\
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="exists(.//tei:text[@type='Sitzungsprotokoll' or @type='Stellungnahme zum Verfassungsentwurf'])">
                <xsl:for-each select=".//tei:div[@type='main']/tei:p">
                    <xsl:apply-templates select="tei:list | ./text() | tei:note[@type='comment'] | tei:emph"/>\\\\
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                \section(Überprüfe den Texttyp: Verfassungsentwurf, Verfassungstext, Sitzungsprotokoll, Stellungnahme zum Verfassungsentwurf
            </xsl:otherwise>
        </xsl:choose>

        <xsl:apply-templates/>

        \end{document}

    </xsl:template>

    <xsl:template match="tei:corr">[<xsl:value-of select="."/>]</xsl:template>

    <xsl:template match="tei:emph">\textit{<xsl:value-of select="."/>}</xsl:template>

    <xsl:template match="tei:p"><xsl:value-of select="."/><xsl:apply-templates/>\\\\</xsl:template>

    <xsl:template match="text()">
        <xsl:choose>
            <xsl:when test="exists(parent::*/tei:choice|parent::*/tei:fw)">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:note[@type='comment']">
        \begin{mynote}
            <xsl:apply-templates/>
        \end{mynote}
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