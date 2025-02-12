<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all" version="2.0">
<xsl:output method="text"/>

    <xsl:template match="tei:teiHeader | tei:div" />

    <xsl:template match="tei:del | tei:sic | tei:fw" mode="ve sp"/>

    <xsl:template match="/">
            
        \documentclass{article}
        \usepackage[utf8]{inputenc}
        \usepackage[ngerman]{babel}
        \usepackage{microtype}
        \usepackage{enumitem}
        \usepackage{tcolorbox}
        \usepackage{changepage}

        \setlength\parindent{0pt}

        \newtcolorbox{mynote}[1][]{
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

        <xsl:apply-templates/>

        \end{document}

    </xsl:template>

<!-- Verfassungsentwurf oder Verfassungstext (Kürzel: ve)-->

    <xsl:template match="tei:text[@type = 'Verfassungsentwurf' or @type = 'Verfassungstext']">
        <xsl:apply-templates select="descendant::tei:div[@type = 'main']" mode="ve"/>
    </xsl:template>

    <xsl:template match="tei:body" mode="ve">
        <xsl:apply-templates mode="ve"/>
    </xsl:template>

    <xsl:template match="tei:div[@type = 'main']" mode="ve">
        <xsl:apply-templates select="child::tei:head[@class = 'main'] | child::tei:p | child::tei:div[@type = 'section'] | child::tei:div[@type = 'preamble']" mode="ve"/>
    </xsl:template>

    <xsl:template match="tei:div[@type = 'preamble']" mode="ve">
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>\par\vspace{3mm}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:p" mode="ve">
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>\par</xsl:text>
    </xsl:template>

    <xsl:template match="tei:head[@class = 'main']" mode="ve">
        <xsl:text>\vspace{5mm}\textbf{\LARGE </xsl:text>
            <xsl:value-of select="."/>
        <xsl:text>}\par\vspace{5mm}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:div[@type = 'section']" mode="ve">
        <xsl:apply-templates mode="ve"/>
        <xsl:text>\vspace{5mm}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:head[@class = 'section']" mode="ve">
        <xsl:text>\vspace{3mm}\hspace*{3mm}\textbf{\Large </xsl:text>
            <xsl:value-of select="text()"/>
        <xsl:text>}\par\vspace{3mm}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:div[@type = 'article']" mode="ve">
        <xsl:text>\begin{adjustwidth}{6mm}{0mm}\subsection*{</xsl:text>
            <xsl:apply-templates select="child::tei:head[@class='article']" mode="ve"/>
        <xsl:text>}\end{adjustwidth}</xsl:text>
        <xsl:apply-templates select="child::tei:p[@type = 'legal_section'] | child::tei:note[@type='comment']" mode="ve"/>
    </xsl:template>

    <xsl:template match="tei:head[@class='article']" mode="ve">
        <xsl:for-each select="text() | child::tei:choice/tei:add">
                    <xsl:value-of select="normalize-space(.)"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="tei:p[@type = 'legal_section']" mode="ve">
        <xsl:choose>
            <xsl:when test="(following-sibling::*[1][self::tei:fw] or (following-sibling::*[1][self::tei:pb] and following-sibling::*[2][self::tei:fw])) and following-sibling::*[2]">
                <xsl:text>\begin{adjustwidth}{6mm}{0mm}</xsl:text>
                <xsl:call-template name="process-p-content"/>
                <xsl:text>&#10;</xsl:text>
            </xsl:when>
            <xsl:when test="(preceding-sibling::*[1][self::tei:fw] or (preceding-sibling::*[1][self::tei:pb] and preceding-sibling::*[2][self::tei:fw])) and preceding-sibling::*[2]">
                <xsl:call-template name="process-p-content"/>
                <xsl:text>\end{adjustwidth}\par </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\begin{adjustwidth}{6mm}{0mm}</xsl:text>
                <xsl:call-template name="process-p-content"/>
                <xsl:text>\end{adjustwidth}\par </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="process-p-content">
        <xsl:if test="child::tei:label and not(following-sibling::tei:item)">
            <xsl:text>\begin{quote}\hbox{}\hspace{-6mm}</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="child::node()" mode="ve"/>
        <xsl:if test="child::tei:label and not(following-sibling::tei:item)">
            <xsl:text>\end{quote}</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:corr" mode="ve">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="text()"/>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template match="tei:choice" mode="ve">
        <xsl:value-of select="child::tei:add/text()"/>
    </xsl:template>

    <xsl:template match="tei:emph" mode="ve">
        <xsl:text>\textit{</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:note[@type='comment']" mode="ve">
        <xsl:text>\begin{mynote}</xsl:text>
            <xsl:value-of select="text()"/>
        <xsl:text>\end{mynote}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:list" mode="ve">
        <xsl:text>\begin{itemize}</xsl:text>
            <xsl:apply-templates select="tei:item" mode="ve"/>
        <xsl:text>\end{itemize}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:item" mode="ve">
        <xsl:text>\item [</xsl:text>
            <xsl:value-of select="normalize-space(preceding-sibling::tei:label[1])"/>
        <xsl:text>]</xsl:text>
        <xsl:apply-templates select="child::node()" mode="ve"/>
    </xsl:template>

<!-- Sitzungsprotokoll oder Stellungnahme zum Verfassungsentwurf (Kürzel: sp) -->

    <xsl:template match="tei:text[@type = 'Sitzungsprotokoll' or @type = 'Stellungnahme zum Verfassungsentwurf']">
        <xsl:apply-templates select="descendant::tei:div[@type = 'main']" mode="sp"/>
    </xsl:template>

   <xsl:template match="tei:div[@type = 'main']" mode="sp">
        <xsl:apply-templates select="child::tei:p" mode="sp"/>
    </xsl:template>

    <xsl:template match="tei:p" mode="sp">
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>

</xsl:stylesheet>