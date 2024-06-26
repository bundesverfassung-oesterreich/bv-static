<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                                        exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="nav_bar">
        <xsl:param name="edition_buttons" as="xs:boolean"><xsl:value-of select="false()"/></xsl:param>
        <xsl:param name="doc_title" as="xs:string"><xsl:value-of select="''"/></xsl:param>
        <div class="wrapper-fluid wrapper-navbar sticky-top hide-reading" id="wrapper-navbar">
            <a class="skip-link screen-reader-text sr-only" href="#content">Skip to content</a>
            <nav class="navbar navbar-expand-lg">
                <xsl:if test="$edition_buttons">
                    <div>
                        <svg class="btn btn-primary sticky" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavigation" aria-controls="offcanvasNavigation" xmlns="http://www.w3.org/2000/svg" height="2.25em" viewBox="0 0 576 512"><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M64 32C64 14.3 49.7 0 32 0S0 14.3 0 32v96V384c0 35.3 28.7 64 64 64H256V384H64V160H256V96H64V32zM288 192c0 17.7 14.3 32 32 32H544c17.7 0 32-14.3 32-32V64c0-17.7-14.3-32-32-32H445.3c-8.5 0-16.6-3.4-22.6-9.4L409.4 9.4c-6-6-14.1-9.4-22.6-9.4H320c-17.7 0-32 14.3-32 32V192zm0 288c0 17.7 14.3 32 32 32H544c17.7 0 32-14.3 32-32V352c0-17.7-14.3-32-32-32H445.3c-8.5 0-16.6-3.4-22.6-9.4l-13.3-13.3c-6-6-14.1-9.4-22.6-9.4H320c-17.7 0-32 14.3-32 32V480z"/></svg>
                    </div>
                </xsl:if>
                <div id="main_navbar_flex_container" class="container-fluid">
                    <a href="index.html" class="navbar-brand custom-logo-link" rel="home" itemprop="url">
                        <img src="{$project_logo}" class="img-fluid" title="{$project_short_title}" alt="{$project_short_title}" itemprop="logo"/>
                    </a>
                    <span class="badge bg-light text-dark">in development</span>
                    <button id="media-menu-toggler" class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <svg class="navbar-toggler-icon" xmlns="http://www.w3.org/2000/svg" height="16" width="14" viewBox="0 0 448 512">
                            <!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2023 Fonticons, Inc.-->
                            <path 
                                fill="#f8f9ec"
                                d="M0 96C0 78.3 14.3 64 32 64H416c17.7 0 32 14.3 32 32s-14.3 32-32 32H32C14.3 128 0 113.7 0 96zM0 256c0-17.7 14.3-32 32-32H416c17.7 0 32 14.3 32 32s-14.3 32-32 32H32c-17.7 0-32-14.3-32-32zM448 416c0 17.7-14.3 32-32 32H32c-17.7 0-32-14.3-32-32s14.3-32 32-32H416c17.7 0 32 14.3 32 32z"/>
                        </svg>
                    </button>
                    <div class="collapse navbar-collapse justify-content-end" id="navbarSupportedContent">
                        <ul class="navbar-nav mb-2 mb-lg-0">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Einführung</a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="about_project.html">Das Projekt</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="about_bvg.html">Das Bundes-Verfassungsgesetz</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="xml_docu.html">XML-Dokumentation</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="toc.html">Quellen</a>
                            </li>
                            <li class="nav-item dropdown disabled">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Register</a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a style="color: grey;" class="dropdown-item" href="./no_data.html" >Personen</a>
                                    </li>
                                    <li>
                                        <a style="color: grey;" class="dropdown-item" href="./no_data.html">Organsisationen</a>
                                    </li>
                                    <li>
                                        <a style="color: grey;" class="dropdown-item" href="./no_data.html">Werke</a>
                                    </li>
                                </ul>
                            </li>
                            
                            <li class="nav-item">
                                <a title="Volltextsuche" class="nav-link" href="search.html">Volltextsuche</a>
                            </li>
                        </ul>
                        <div class="flex" id="navbar_right_spacer"></div>
                    </div>
                </div>
                <xsl:if test="$edition_buttons">
                    <div>
                        <svg class="btn btn-primary" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasOptions" aria-controls="offcanvasOptions" xmlns="http://www.w3.org/2000/svg" height="2.25em" viewBox="0 0 512 512"><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M495.9 166.6c3.2 8.7 .5 18.4-6.4 24.6l-43.3 39.4c1.1 8.3 1.7 16.8 1.7 25.4s-.6 17.1-1.7 25.4l43.3 39.4c6.9 6.2 9.6 15.9 6.4 24.6c-4.4 11.9-9.7 23.3-15.8 34.3l-4.7 8.1c-6.6 11-14 21.4-22.1 31.2c-5.9 7.2-15.7 9.6-24.5 6.8l-55.7-17.7c-13.4 10.3-28.2 18.9-44 25.4l-12.5 57.1c-2 9.1-9 16.3-18.2 17.8c-13.8 2.3-28 3.5-42.5 3.5s-28.7-1.2-42.5-3.5c-9.2-1.5-16.2-8.7-18.2-17.8l-12.5-57.1c-15.8-6.5-30.6-15.1-44-25.4L83.1 425.9c-8.8 2.8-18.6 .3-24.5-6.8c-8.1-9.8-15.5-20.2-22.1-31.2l-4.7-8.1c-6.1-11-11.4-22.4-15.8-34.3c-3.2-8.7-.5-18.4 6.4-24.6l43.3-39.4C64.6 273.1 64 264.6 64 256s.6-17.1 1.7-25.4L22.4 191.2c-6.9-6.2-9.6-15.9-6.4-24.6c4.4-11.9 9.7-23.3 15.8-34.3l4.7-8.1c6.6-11 14-21.4 22.1-31.2c5.9-7.2 15.7-9.6 24.5-6.8l55.7 17.7c13.4-10.3 28.2-18.9 44-25.4l12.5-57.1c2-9.1 9-16.3 18.2-17.8C227.3 1.2 241.5 0 256 0s28.7 1.2 42.5 3.5c9.2 1.5 16.2 8.7 18.2 17.8l12.5 57.1c15.8 6.5 30.6 15.1 44 25.4l55.7-17.7c8.8-2.8 18.6-.3 24.5 6.8c8.1 9.8 15.5 20.2 22.1 31.2l4.7 8.1c6.1 11 11.4 22.4 15.8 34.3zM256 336a80 80 0 1 0 0-160 80 80 0 1 0 0 160z"/></svg>
                    </div>
                </xsl:if>
            </nav>            
            <!-- .site-navigation -->
            <xsl:if test="$doc_title!=''">
                <div id="short_title">
                    <h4>
                        <xsl:value-of select="$doc_title"/>
                    </h4>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
</xsl:stylesheet>