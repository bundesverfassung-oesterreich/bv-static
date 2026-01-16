<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xpath-default-namespace="http://www.w3.org/2000/svg"
    exclude-result-prefixes="#all">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="@xlink:href[starts-with(., 'https://b-vg.acdh.oeaw.ac.at/') or starts-with(., 'http://b-vg.acdh.oeaw.ac.at/')]">
        <xsl:variable name="href" select="."/>
        <xsl:variable name="base">
            <xsl:choose>
                <xsl:when test="starts-with($href, 'https://b-vg.acdh.oeaw.ac.at/')">
                    <xsl:text>https://b-vg.acdh.oeaw.ac.at/</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>http://b-vg.acdh.oeaw.ac.at/</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="xlink:href">
            <xsl:text>../</xsl:text>
            <xsl:value-of select="substring-after($href, $base)"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="svg:a[@xlink:href[starts-with(., 'https://b-vg.acdh.oeaw.ac.at/') or starts-with(., 'http://b-vg.acdh.oeaw.ac.at/')]]">
        <xsl:variable name="href" select="@xlink:href"/>
        <xsl:variable name="base">
            <xsl:choose>
                <xsl:when test="starts-with($href, 'https://b-vg.acdh.oeaw.ac.at/')">
                    <xsl:text>https://b-vg.acdh.oeaw.ac.at/</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>http://b-vg.acdh.oeaw.ac.at/</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy>
            <!-- copy all attributes except the original xlink:href -->
            <xsl:apply-templates select="@*[not(name() = 'xlink:href')]"/>
            <!-- new relative href -->
            <xsl:attribute name="xlink:href">
                <xsl:text>../</xsl:text>
                <xsl:value-of select="substring-after($href, $base)"/>
            </xsl:attribute>
            <!-- ensure opening in a new tab -->
            <xsl:attribute name="target">_blank</xsl:attribute>
            <!-- children -->
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
