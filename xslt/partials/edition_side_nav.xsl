<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template name="editions_side_nav">
        <div id="edtion-navBarNavDropdown" class="dropstart navBarNavDropdown">
            <ul id="left_edition_content_nav" class="list-unstyled ps-0">
                <li class="mb-1">
                    <button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse" data-bs-target="#docs-collapse" aria-expanded="false">
                        Dokumente
                    </button>
                    <div class="collapse" id="docs-collapse">
                        <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                            <li>
                                <button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse" data-bs-target="#data-set_A" aria-expanded="false">
                                    Verfassungsentwürfe
                                </button>
                                <div class="collapse " id="data-set_A">
                                    <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                                        <li><a href="#" class="link-dark rounded">entwurf 1</a></li>
                                        <li><a href="#" class="link-dark rounded">entwurf 2</a></li>
                                        <li><a href="#" class="link-dark rounded">entwurf 3</a></li>
                                    </ul>
                                </div>
                            </li>
                            <li>
                                <button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse" data-bs-target="#data-set_B" aria-expanded="false">
                                    anderes
                                </button>
                                <div class="collapse" id="data-set_B">
                                    <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                                        <li><a href="#" class="link-dark rounded">anderes 1</a></li>
                                        <li><a href="#" class="link-dark rounded">anderes 2</a></li>
                                        <li><a href="#" class="link-dark rounded">anderes 3</a></li>
                                    </ul>
                                </div>
                            </li>
                        </ul>
                    </div>
                </li>
                <li class="mb-1">
                    <button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse" data-bs-target="#current-doc-collapse" aria-expanded="true">
                        Aktuelles Dokument
                    </button>
                    <div class="collapse" id="current-doc-collapse">
                        <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                            <li>
                                <button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse" data-bs-target="#section_1" aria-expanded="false">
                                    Abschnitt A
                                </button>
                                <div class="collapse " id="section_1">
                                    <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                                        <li><a href="#" class="link-dark rounded">Artikel 1</a></li>
                                        <li><a href="#" class="link-dark rounded">Artikel 2</a></li>
                                        <li><a href="#" class="link-dark rounded">Artikel 3</a></li>
                                    </ul>
                                </div>
                            </li>
                            <li>
                                <button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse" data-bs-target="#section_2" aria-expanded="false">
                                    Abschnitt B
                                </button>
                                <div class="collapse" id="section_2">
                                    <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                                        <li><a href="#" class="link-dark rounded">Artikel 1</a></li>
                                        <li><a href="#" class="link-dark rounded">Artikel 2</a></li>
                                        <li><a href="#" class="link-dark rounded">Artikel 3</a></li>
                                    </ul>
                                </div>
                            </li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>
        <!--<div id="edtion-navBarNavDropdown" class="dropstart navBarNavDropdown">
             <a title="Dokumente" href="#" data-bs-toggle="dropdown" data-bs-auto-close="true" aria-expanded="false" role="button">
             Dokumente
             </a>                    
             <ul class="dropdown-menu">
             <xsl:for-each select="collection('../../data/editions/')//tei:TEI">
             <xsl:sort select="tokenize(document-uri(/), '/')[last()]" />
             <xsl:choose>
             <xsl:when test="position() = 1">
             <li>
             <a class="dropdown-item active" aria-current="page" href="{replace(tokenize(document-uri(/), '/')[last()], '.xml', '.html')}"
             title="">
             <xsl:value-of select="//tei:fileDesc//tei:titleStmt//tei:title[@type='main']/normalize-space()"/>
             </a>
             </li>
             </xsl:when>
             <xsl:otherwise>
             <li>
             <a class="dropdown-item" href="{replace(tokenize(document-uri(/), '/')[last()], '.xml', '.html')}"
             title="">
             <xsl:value-of select="//tei:fileDesc//tei:titleStmt//tei:title[@type='main']/normalize-space()"/>
             </a>
             </li>
             </xsl:otherwise>
             </xsl:choose>
             </xsl:for-each>
             </ul>                                                    
             </div>-->
        <script type="text/javascript">
            $('#edition-navBarNavDropdown .dropdown-menu .nav-item').click(function(e) {
            e.stopPropagation();
            });
        </script>
        
    </xsl:template>
</xsl:stylesheet>