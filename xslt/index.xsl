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
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$html_title"></xsl:with-param>
                </xsl:call-template>
            </head>            
            <body class="page" style="background-color:#f1f1f1;">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>

                    <div class="container">
                        <div class="row intro">
                            <div class="col-md-6 wp-intro_left">
                                <div class="intro_left">
                                    <h1><xsl:value-of select="$project_short_title"/></h1>
                                    <h3><xsl:value-of select="$project_title"/></h3>
                                    <a href="bv_doc_id__1.html" title="Kelsen, Entwurf I">
                                        <button class="btn btn-secondary" role="button" style="width: 250px;">
                                            Kelsen, Entwurf I
                                        </button>
                                    </a>
                                    <a href="toc.html" title="Übersicht Entwurfsgruppe I">
                                        <button class="btn btn-secondary" role="button" style="width: 250px;">
                                            Übersicht Entwurfsgruppe I
                                        </button>
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="intro_right wrapper">
                                    <img src="https://www.geschichtewiki.wien.gv.at/images/7/78/Hans_Kelsen.jpg" title="Hans Kelsen, Verfasser der Bundesverfassung" alt="Hans Kelsen, Verfasser der Bundesverfassung"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--<div class="container-fluid" style="margin:2em auto;">
                        <div class="row wrapper img_bottom">
                            <div class="col-md-6">
                                <a href="toc.html" class="index-link">                                   
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img src="images/example-img-1.jpg" class="d-block w-100" alt="..."/>
                                        </div>
                                        <div class="card-header">                                            
                                            <p>
                                                Vorlage für eine Edition ohne Faksimiles
                                            </p>                                            
                                        </div>
                                    </div>                                     
                                </a>                                    
                            </div>
                            <div class="col-md-6">
                                <a href="toc_facs.html" class="index-link">                                                     
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img src="images/example-img-1.jpg" class="d-block w-100" alt="..."/>
                                        </div>
                                        <div class="card-header">                                            
                                            <p>
                                                Vorlage für eine Edition mit Faksimiles
                                            </p>                                            
                                        </div>
                                    </div>                                 
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="about.html" class="index-link">  
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img src="images/example-img-1.jpg" class="d-block w-100" alt="..."/>
                                        </div>
                                        <div class="card-header">                                            
                                            <p>
                                                Über das Projekt
                                            </p>                                            
                                        </div>
                                    </div>                                    
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="search.html" class="index-link">  
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img src="images/example-img-1.jpg" class="d-block w-100" alt="..."/>
                                        </div>
                                        <div class="card-header">                                            
                                            <p>
                                                Datenbanksuche
                                            </p>                                            
                                        </div>
                                    </div>                                    
                                </a>
                            </div>
                        </div>
                    </div>-->
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}"><xsl:apply-templates/></h2>
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
    <xsl:template match="tei:ref">
        <xsl:choose>
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