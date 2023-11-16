<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template name="build_sub_list">
        <xsl:param name="id_name_for_toggle"></xsl:param>
        <xsl:param name="data_set_id_transkribus"></xsl:param>
        <xsl:param name="heading"></xsl:param>
        <xsl:param name="expanded" as="xs:string" select="'false'"/>
        <li>
            <button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse" data-bs-target="#{$id_name_for_toggle}" aria-expanded="{$expanded}">
                <xsl:value-of select="$heading"/>
            </button>
            <div class="collapse " id="{$id_name_for_toggle}">
                <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                    <xsl:for-each select="collection('../../data/editions/')//tei:TEI[.//tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type='transkribus_collection' and ./text()=$data_set_id_transkribus]]" >
                        <xsl:variable as="xs:string" name="text_title" select="//tei:fileDesc//tei:titleStmt//tei:title[@type='main']/normalize-space()"/>
                        <xsl:variable as="xs:string" name="page_uri" select="replace(tokenize(document-uri(/), '/')[last()], '.xml', '.html')"/>
                        <!--<xsl:sort select="tokenize(document-uri(/), '/')[last()]" />
                             <xsl:choose>
                             <xsl:when test="position() = 1">
                             then active etc …
                        -->  
                        <li>
                            <a class="dropdown-item" href="{$page_uri}"
                               title="{$text_title}">
                                <xsl:value-of select="$text_title"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </li>
    </xsl:template>
    
    <xsl:template name="editions_side_nav">
        <div id="edtion-navBarNavDropdown" class="dropstart navBarNavDropdown">
            <xsl:variable name="data_set_A_id" as="xs:string" select="string(195363)"/>
            <xsl:variable name="data_set_B_id" as="xs:string" select="string(196428)"/>
            <xsl:variable name="data_set_C_id" as="xs:string" select="string(196429)"/>
            <ul id="left_edition_content_nav" class="list-unstyled ps-0">
                <li class="mb-1">
                    <button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse" data-bs-target="#docs-collapse" aria-expanded="false">
                        Dokumente
                    </button>
                    <div class="collapse" id="docs-collapse">
                        <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                            <xsl:call-template name="build_sub_list">
                                <xsl:with-param name="id_name_for_toggle" select="'data_set_A_nav_toggle'"/>
                                <xsl:with-param name="data_set_id_transkribus" select="$data_set_A_id"/>
                                <xsl:with-param name="heading" select="'Verfassungesentwürfe'"/>
                                <xsl:with-param name="expanded" select="'true'"/>
                            </xsl:call-template>
                            <xsl:call-template name="build_sub_list">
                                <xsl:with-param name="id_name_for_toggle" select="'data_set_B_nav_toggle'"/>
                                <xsl:with-param name="data_set_id_transkribus" select="$data_set_B_id"/>
                                <xsl:with-param name="heading" select="'Protokolle'"/>
                            </xsl:call-template>
                            <xsl:call-template name="build_sub_list">
                                <xsl:with-param name="id_name_for_toggle" select="'data_set_C_nav_toggle'"/>
                                <xsl:with-param name="data_set_id_transkribus" select="$data_set_C_id"/>
                                <xsl:with-param name="heading" select="'Sonstige'"/>
                            </xsl:call-template>
                         </ul>
                    </div>
                </li>
            </ul>
        </div>
        <script type="text/javascript">
            $('#edition-navBarNavDropdown .dropdown-menu .nav-item').click(function(e) {
            e.stopPropagation();
            });
        </script>
        
    </xsl:template>
</xsl:stylesheet>