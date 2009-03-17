<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species module' function - display links to all species searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.species.names.NameSortCriteria,
                ro.finsiel.eunis.search.AbstractSortCriteria" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
  String []tabs = { cm.cms("easy_search"), cm.cms("advanced_search"), cm.cms("statistical_data"), cm.cms("links_and_downloads"), cm.cms("help") };
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species";
%>
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
    function popIndicators(URL)
    {
        //URL = "http://themes.eea.europa.eu/Environmental_issues/biodiversity/indicators/";
        eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=700,height=500,left=200,top=100')");
    }
    function validateQuickSearch()
    {
        if (trim(document.search.scientificName.value) == '' || trim(document.search.scientificName.value) == 'Enter species name here...' )
        {
            alert('<%=cm.cms("species_main_01_Msg")%>');
            return false;
        }
        else return true;
    }
    //]]>
    </script>
    <title>
        <%=application.getInitParameter("PAGE_TITLE")%>
        <%=cm.cms("species_main_title")%>
    </title>
  </head>
  <body>
  <div id="visual-portal-wrapper">
    <jsp:include page="header.jsp" />
    <!-- The wrapper div. It contains the three columns. -->
    <div id="portal-columns" class="visualColumnHideTwo">
      <!-- start of the main and left columns -->
      <div id="visual-column-wrapper">
        <!-- start of main content block -->
        <div id="portal-column-content">
          <div id="content">
            <div class="documentContent" id="region-content">
		<jsp:include page="header-dynamic.jsp">
			<jsp:param name="location" value="<%=btrail%>"/>
		</jsp:include>
              <a name="documentContent"></a>
              <div class="documentActions">
                <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                <ul>
                  <li>
                    <a href="javascript:this.print();">
                    	<img src="http://webservices.eea.europa.eu/templates/print_icon.gif" alt="<%=cm.cms("Print this page")%>" title="<%=cm.cms("Print this page")%>" id="icon-print" /><%=cm.cmsTitle( "Print this page" )%>
                    </a>
                  </li>
                  <li>
                    <a href="javascript:toggleFullScreenMode();">
                    	<img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif" alt="<%=cm.cms("Toggle full screen mode")%>" title="<%=cm.cms("Toggle full screen mode")%>" id="icon-full_screen" /><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </a>
                  </li>
                </ul>
              </div>
<!-- MAIN CONTENT -->
              <img id="loading" alt="<%=cm.cms("loading_progress")%>" title="<%=cm.cms("loading_progress")%>" src="images/loading.gif" />
                <h1 class="documentFirstHeading">
                  <%=cm.cmsPhrase( "SPECIES SEARCH" )%>
                </h1>

              <div class="documentDescription">
                 <!--%=cm.cmsPhrase( "species_main_description" )%-->
                 <%=cm.cmsPhrase( "Access information about species of interest for biodiversity and nature protection" )%>
              </div>

              <div id="qs" style="padding-left : 10px; width : 90%; vertical-align : middle;text-align:center">
                <form name="search" action="species-names-result.jsp" method="get" onsubmit="return validateQuickSearch(); ">
                  <input type="hidden" name="comeFromQuickSearch" value="true" />
                  <input type="hidden" name="showGroup" value="true" />
                  <input type="hidden" name="showOrder" value="true" />
                  <input type="hidden" name="showFamily" value="true" />
                  <input type="hidden" name="showScientificName" value="true" />
                  <input type="hidden" name="showVernacularNames" value="true" />
                  <input type="hidden" name="showValidName" value="true" />
                  <input type="hidden" name="showOtherInfo" value="true" />
                  <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_STARTS%>" />
                  <input type="hidden" name="searchVernacular" value="true" />
                  <input type="hidden" name="searchSynonyms" value="true" />
                  <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>" />
                  <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
                  <label for="scientificName"><%=cm.cmsPhrase("Search species with names starting with:")%></label>
                  <input size="32"
                         id="scientificName"
                         name="scientificName"
                         value="<%=cm.cms("species_main_03_Value")%>"
                         alt="<%=cm.cms("quick_search_species_name")%>"
                         title="<%=cm.cms("quick_search_species_name")%>"
                         onfocus="javascript:document.search.scientificName.select();" />
                  <%=cm.cmsInput("species_main_03_Value")%>
                  <%=cm.cmsAlt("quick_search_species_name")%>
                  <%=cm.cmsTitle("quick_search_species_name")%>
                  <input id="search" type="submit"
                         value="<%=cm.cms("search")%>"
                         name="Submit"
                         class="submitSearchButton"
                         alt="<%=cm.cms("execute_search")%>" title="<%=cm.cms("execute_search")%>"
                         />
                  <%=cm.cmsInput("search")%>
                  <%=cm.cmsAlt("execute_search")%>
                  <%=cm.cmsTitle("execute_search")%>
                  <a href="fuzzy-search-help.jsp" title="<%=cm.cms("help_fuzzy_search")%>"><img src="images/mini/help.jpg" border="0" style="vertical-align:middle;" alt="<%=cm.cms("species_main_04_Alt")%>" /></a>
                  <%=cm.cmsTitle("help_fuzzy_search")%>
                  <%=cm.cmsAlt("species_main_04_Alt")%>
                </form>
                <br />
              </div>
              <div id="tabbedmenu">
                <ul>
          <%
            String currentTab = "";
            for ( int i = 0; i < tabs.length; i++ )
            {
              currentTab = "";
              if ( tab == i ) currentTab = " id=\"currenttab\"";
          %>
                <li<%=currentTab%>><a title="<%=tabs[ i ]%>" href="species.jsp?tab=<%=i%>"><%=tabs[ i ]%></a></li>
          <%
              }
          %>
                </ul>
              </div>
              <br clear="all" />
              <br />
          <%
            if ( tab == 0 )
            {
          %>
              <table summary="<%=cm.cms("easy_searches")%>" class="datatable" width="90%">
                <caption>
                  <%=cm.cmsPhrase("A set of predefined &nbsp;functions to search the database") %>
                </caption>
                <thead>
                  <tr>
                    <th width="40%" style="white-space: nowrap">
                      <%=cm.cmsPhrase("Links to easy searches")%>
                    </th>
                    <th width="60%">
                      <%=cm.cmsPhrase("Description")%>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("names")%>" />
                      <a href="species-names.jsp" title="<%=cm.cms("search_by_latin_or_vernacular")%>"><strong><%=cm.cmsPhrase("Names")%></strong></a>
                      <%=cm.cmsTitle("search_by_latin_or_vernacular")%>
                      <%=cm.cmsAlt("names")%>
                    </td>
                    <td width="60%">
                      <%=cm.cmsPhrase("Search species by scientific name (in Latin) or by vernacular name (popular name)")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("groups")%>" />
                      <a href="species-groups.jsp" title="<%=cm.cms("species_subspecies_by_group")%>"><strong><%=cm.cmsPhrase("Groups")%></strong></a>
                      <%=cm.cmsTitle("species_subspecies_by_group")%>
                      <%=cm.cmsAlt("groups")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species &amp; subspecies by Group (Invertebrates, Mammals etc.)")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("synonyms")%>" />
                      <a href="species-synonyms.jsp" title="<%=cm.cms("identify_synonym_names_for_species")%>"><strong><%=cm.cmsPhrase("Synonyms")%></strong></a>
                      <%=cm.cmsTitle("identify_synonym_names_for_species")%>
                      <%=cm.cmsAlt("synonyms")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Identify synonym names for species")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("country_biogeographic_region_location")%>" />
                      <a href="species-country.jsp" title="<%=cm.cms("find_species_located_in_country_region")%>"><strong><%=cm.cmsPhrase("Country/Biogeographic region")%></strong></a>
                      <%=cm.cmsTitle("find_species_located_in_country_region")%>
                      <%=cm.cmsAlt("country_biogeographic_region_location")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find species located within a country and/or a biogeographic region")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("international_threat_status")%>" />
                      <a href="species-threat-international.jsp" title="<%=cm.cms("species_threatened_at_international_level")%>"><strong><%=cm.cmsPhrase("International Threat Status")%></strong></a>
                      <%=cm.cmsTitle("species_threatened_at_international_level")%>
                      <%=cm.cmsAlt("international_threat_status")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species threatened at international level")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("national_threat_status")%>" />
                      <a href="species-threat-national.jsp" title="<%=cm.cms("species_threatened_at_country_level")%>"><strong><%=cm.cmsPhrase("National threat status")%></strong></a>
                      <%=cm.cmsTitle("species_threatened_at_country_level")%>
                      <%=cm.cmsAlt("national_threat_status")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species threatened at country level")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("legal_instruments")%>" />
                      <a href="species-legal.jsp" title="<%=cm.cms("species_protected_by_legal_texts")%>"><strong><%=cm.cmsPhrase("Legal Instruments")%></strong></a>
                      <%=cm.cmsTitle("species_protected_by_legal_texts")%>
                      <%=cm.cmsAlt("legal_instruments")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species protected by legal texts at European level")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("pick_species_show_habitat_types")%>" />
                      <a href="habitats-species.jsp?expandare=no&amp;showCode=on&amp;showLevel=on&amp;showVernacularName=on" title="<%=cm.cms("find_habitat_types_characterized_by_species")%>">
                          <strong><%=cm.cmsPhrase("Pick species, show habitat types")%></strong></a>
                      <%=cm.cmsTitle("find_habitat_types_characterized_by_species")%>
                      <%=cm.cmsAlt("pick_species_show_habitat_types")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find habitat types characterised by a particular species")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("pick_species_show_sites")%>" />
                      <a href="sites-species.jsp" title="<%=cm.cms("find_sites_types_characterized_by_species")%>"><strong><%=cm.cmsPhrase("Pick species, show sites")%></strong></a>
                      <%=cm.cmsTitle("find_sites_types_characterized_by_species")%>
                      <%=cm.cmsAlt("pick_species_show_sites")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find sites characterized by a particular species")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("pick_species_show_references")%>" />
                      <a href="species-books.jsp" title="<%=cm.cms("find_books_articles")%>"><strong><%=cm.cmsPhrase("Pick species, show references")%></strong></a>
                      <%=cm.cmsTitle("find_books_articles")%>
                      <%=cm.cmsAlt("pick_species_show_references")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find books, articles which refers to species")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("pick_references_show_species")%>" />
                      <a href="species-references.jsp" title="<%=cm.cms("fins_species_reffered_by_books")%>"><strong><%=cm.cmsPhrase("Pick references, show species")%></strong></a>
                      <%=cm.cmsTitle("fins_species_reffered_by_books")%>
                      <%=cm.cmsAlt("pick_references_show_species")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find species referred by books, articles etc.")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("taxonomic_classification")%>" />
                      <a href="species-taxonomic-browser.jsp" title="<%=cm.cms("taxonomic_classification_for_species")%>"><strong><%=cm.cmsPhrase("Taxonomic classification")%></strong></a>
                      <%=cm.cmsTitle("taxonomic_classification_for_species")%>
                      <%=cm.cmsAlt("taxonomic_classification")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Taxonomic classification for species")%>
                    </td>
                  </tr>
                </tbody>
              </table>
          <%
            }
            if ( tab == 1 )
            {
          %>
              <table summary="<%=cm.cms("advanced_searches")%>" class="datatable" width="90%">
                <caption>
                  <%=cm.cmsPhrase("A flexible search tool to build your own query") %>
                </caption>
                <thead>
                  <tr>
                    <th width="40%" style="white-space: nowrap">
                      <%=cm.cmsPhrase("Description")%>
                    </th>
                    <th width="60%">
                      <%=cm.cmsPhrase("Description")%>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("advanced_search")%>" />
                      <a href="species-advanced.jsp?natureobject=Species" title="<%=cm.cms("search_using_complex_filtering")%>">
                          <strong><%=cm.cmsPhrase("Advanced Search")%></strong></a>
                      <%=cm.cmsTitle("search_using_complex_filtering")%>
                      <%=cm.cmsAlt("advanced_search")%>
                    </td>
                    <td>
                        <%=cm.cmsPhrase("Search species information using more complex filtering capabilities")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("how_to_use_advanced_search")%>" />
                      <a href="advanced-help.jsp" title="<%=cm.cms("species_main_advSearchHelp_Title")%>"><strong><%=cm.cmsPhrase("How to use Advanced search")%></strong></a>
                      <%=cm.cmsTitle("species_main_advSearchHelp_Title")%>
                      <%=cm.cmsAlt("how_to_use_advanced_search")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Help on species <strong>Advanced Search</strong>")%>
                    </td>
                  </tr>
                </tbody>
              </table>
          <%
            }

            if ( tab == 2 )
            {
          %>
              <table summary="<%=cm.cms("statistical_data")%>" class="datatable" width="90%">
                <caption>
                  <%=cm.cmsPhrase( "A search tool to build aggregated data" ) %>
                </caption>
                <thead>
                  <tr>
                    <th>
                      <%=cm.cmsPhrase("Links to statistical data")%>
                    </th>
                    <th>
                      <%=cm.cmsPhrase("Description")%>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <img alt="<%=cm.cms("statistical_data")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                      <a title="<%=cm.cms("fins_statistical_data_about_species")%>" href="species-statistics-module.jsp">
                        <strong>
                          <%=cm.cmsPhrase("Statistical data")%>
                        </strong>
                      </a>
                      <%=cm.cmsTitle("fins_statistical_data_about_species")%>
                      <%=cm.cmsAlt("statistical_data")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find statistical data about species")%>
                    </td>
                  </tr>
                </tbody>
              </table>
          <%
            }

            if ( tab == 3 )
            {
          %>
              <table summary="<%=cm.cms("links_and_downloads")%>" class="datatable" width="90%">
                <caption>
                  <%=cm.cmsPhrase("Species links and downloads")%>
                </caption>
                <thead>
                  <tr>
                    <th width="40%">
                      <%=cm.cmsPhrase("Links to data downloads")%>
                    </th>
                    <th width="60%">
                      <%=cm.cmsPhrase("Description")%>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("links_and_downloads_2")%>" />
                      <a href="species-download.jsp" title="<%=cm.cms("links_and_downloads_2")%>"><strong><%=cm.cmsPhrase("Links and Downloads")%></strong></a>
                      <%=cm.cmsTitle("links_and_downloads_2")%>
                      <%=cm.cmsAlt("links_and_downloads_2")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Links and Downloads")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("links_and_downloads_2")%>" />
                      <%=cm.cmsText("species_main_indicators")%>
                      <%=cm.cmsAlt("links_and_downloads_2")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find species used in indicators")%>
                    </td>
                  </tr>
                </tbody>
              </table>
          <%
            }
            if ( tab == 4 )
            {
          %>
                <table summary="<%=cm.cms("help")%>" class="datatable" width="90%">
                  <caption>
                    <%=cm.cmsPhrase("General information on EUNIS application") %>
                  </caption>
                  <thead>
                    <tr>
                      <th width="40%" style="white-space: nowrap">
                        <%=cm.cmsPhrase("Links to online help")%>
                      </th>
                      <th width="60%">
                        <%=cm.cmsPhrase("Description")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("how_to_use_easy_search")%>" />
                        <a href="easy-help.jsp" title="<%=cm.cms("species_main_easyHelp_Title")%>"><strong><%=cm.cmsPhrase("How to use Easy search")%></strong></a>
                        <%=cm.cmsTitle("species_main_easyHelp_Title")%>
                        <%=cm.cmsAlt("how_to_use_easy_search")%>
                      </td>
                      <td width="60%">
                        <%=cm.cmsPhrase("Help on species <strong>Easy Searches</strong>")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("glossary")%>" />
                        <a href="glossary.jsp?module=species" title="<%=cm.cms("species_main_glossary_Title")%>"><strong><%=cm.cmsPhrase("Glossary")%></strong></a>
                        <%=cm.cmsTitle("species_main_glossary_Title")%>
                        <%=cm.cmsAlt("glossary")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Glossary of the terms used in EUNIS Database species module")%>
                      </td>
                    </tr>
                    <tr>
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("browse")%>" />
                        <a href="http://biodiversity-chm.eea.europa.eu/search_html" title="<%=cm.cms("generic_information_tools_on_species")%>">
                            <strong><%=cm.cmsPhrase("Browse")%></strong></a>
                        <%=cm.cmsTitle("generic_information_tools_on_species")%>
                        <%=cm.cmsAlt("browse")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Generic information tools on Species diversity")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="<%=cm.cms("how_to_use")%>" />
                        <a href="species-help.jsp" title="<%=cm.cms("species_main_howTo_Title")%>"><strong><%=cm.cmsPhrase("How to use")%></strong></a>
                        <%=cm.cmsTitle("species_main_howTo_Title")%>
                        <%=cm.cmsAlt("how_to_use")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Help on EUNIS Database species module search tools")%>
                      </td>
                    </tr>
                  </tbody>
                </table>
          <%
            }
          %>

          <%=cm.br()%>
          <%=cm.cmsMsg("easy_search")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("advanced_search")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("statistical_data")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("links_and_downloads")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("help")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("species_main_01_Msg")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("species_main_title")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("easy_searches")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("advanced_searches")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("statistical_data")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("links_and_downloads")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("help")%>
          <%=cm.br()%>
                <script language="javascript" type="text/javascript">
                //<![CDATA[
                try
                {
                    var ctrl_loading = document.getElementById("loading");
                    ctrl_loading.style.display = "none";
                }
                catch (e)
                {
                }
                //]]>
                </script>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="species.jsp"/>
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
