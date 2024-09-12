<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                                        version="2.0" exclude-result-prefixes="#all">
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
        
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="meta-tags">
                    <xsl:with-param name="title" select="$doc_title"></xsl:with-param>
                    <xsl:with-param name="source_authors" select="//tei:msDesc/tei:msContents/tei:msItem/tei:author/text()"></xsl:with-param>
                    <xsl:with-param name="description" select="'Die Entstehung der Österreichischen Bundes-Verfassung 1920'"></xsl:with-param>
                </xsl:call-template>
                <link rel="stylesheet" href="css/commentary.css" type="text/css"></link>
            </head>            
            <body class="page" lang="de">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <div class="row">
                            <div class="col-md-9 col-lg-6 col-sm-12 commentary_container">
                                    <xsl:apply-templates select="//tei:body"/>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{generate-id()}"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}"><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="tei:body/tei:p[1]">
        <h1 id="{generate-id()}"><xsl:apply-templates/></h1>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p id="{generate-id()}"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul id="{generate-id()}"><xsl:apply-templates/></ul>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li id="{generate-id()}"><xsl:apply-templates/></li>
    </xsl:template>

    <xsl:template match="tei:table">
        <dl id="{generate-id()}"><xsl:apply-templates/></dl>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:row[not(previous-sibling::tei:row)]">
        <!-- match first row, containing the lable -->
        <dt>
            <xsl:apply-templates/>
        </dt>
    </xsl:template>
    <xsl:template match="tei:row[previous-sibling::tei:row]">
        <!-- match second row containing the data -->
         <dd>
            <xsl:apply-templates/>
         </dd>
    </xsl:template>
    <xsl:template match="tei:hi[contains(@rend, 'bold') or contains(@rendition, 'bold')]">
        <b>
            <xsl:apply-templates></xsl:apply-templates>
        </b>
    </xsl:template>

    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), $wrong_link_prefix)">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="substring(@target, string-length($wrong_link_prefix))"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>