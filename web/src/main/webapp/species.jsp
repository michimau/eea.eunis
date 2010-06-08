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
              <img id="loading" alt="<%=cm.cms("loading_progress")%>" title="<%=cm.cms("loading_progress")%>" src="images/loading.gif" />
                <h1 class="documentFirstHeading">
                  <%=cm.cmsPhrase( "Species search" )%>
                </h1>
              <div class="documentActions">
                <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                <ul>
                  <li>
                    <a href="javascript:this.print();">
                    	<img src="http://webservices.eea.europa.eu/templates/print_icon.gif" alt="<%=cm.cmsPhrase("Print this page")%>" title="<%=cm.cmsPhrase("Print this page")%>" id="icon-print" />
                    </a>
                  </li>
                  <li>
                    <a href="javascript:toggleFullScreenMode();">
                    	<img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif" alt="<%=cm.cmsPhrase("Toggle full screen mode")%>" title="<%=cm.cmsPhrase("Toggle full screen mode")%>" id="icon-full_screen" />
                    </a>
                  </li>
                </ul>
              </div>
<!-- MAIN CONTENT -->

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
                         value="<%=cm.cmsPhrase("Enter species name here...")%>"
                         onfocus="if(this.value=='<%=cm.cmsPhrase("Enter species name here...")%>')this.value='';"
                         onblur="if(this.value=='')this.value='<%=cm.cmsPhrase("Enter species name here...")%>';" />
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
              <table class="datatable fullwidth">
                <caption>
                  <%=cm.cmsPhrase("A set of predefined functions to search the database") %>
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
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-names.jsp" title="<%=cm.cms("search_by_latin_or_vernacular")%>"><strong><%=cm.cmsPhrase("Names")%></strong></a>
                      <%=cm.cmsTitle("search_by_latin_or_vernacular")%>
                    </td>
                    <td width="60%">
                      <%=cm.cmsPhrase("Search species by scientific name (in Latin) or by vernacular name (popular name)")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-groups.jsp" title="<%=cm.cms("species_subspecies_by_group")%>"><strong><%=cm.cmsPhrase("Groups")%></strong></a>
                      <%=cm.cmsTitle("species_subspecies_by_group")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species &amp; subspecies by Group (Invertebrates, Mammals etc.)")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-synonyms.jsp" title="<%=cm.cms("identify_synonym_names_for_species")%>"><strong><%=cm.cmsPhrase("Synonyms")%></strong></a>
                      <%=cm.cmsTitle("identify_synonym_names_for_species")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Identify synonym names for species")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-country.jsp"><strong><%=cm.cmsPhrase("Country/Biogeographic region")%></strong></a>
                      <%=cm.cmsTitle("find_species_located_in_country_region")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find species located within a country and/or a biogeographic region")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-threat-international.jsp"><strong><%=cm.cmsPhrase("International Threat Status")%></strong></a>
                      <%=cm.cmsTitle("species_threatened_at_international_level")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species threatened at international level")%>
                    </td>
                  </tr>
<!--
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-threat-national.jsp"><strong><%=cm.cmsPhrase("National threat status")%></strong></a>
                      <%=cm.cmsTitle("species_threatened_at_country_level")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species threatened at country level")%>
                    </td>
                  </tr>
-->
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-legal.jsp"><strong><%=cm.cmsPhrase("Legal Instruments")%></strong></a>
                      <%=cm.cmsTitle("species_protected_by_legal_texts")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species protected by legal texts at European level")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="habitats-species.jsp?expandare=no&amp;showCode=on&amp;showLevel=on&amp;showVernacularName=on">
                          <strong><%=cm.cmsPhrase("Pick species, show habitat types")%></strong></a>
                      <%=cm.cmsTitle("find_habitat_types_characterized_by_species")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find habitat types characterised by a particular species")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="sites-species.jsp"><strong><%=cm.cmsPhrase("Pick species, show sites")%></strong></a>
                      <%=cm.cmsTitle("find_sites_types_characterized_by_species")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find sites characterized by a particular species")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-books.jsp"><strong><%=cm.cmsPhrase("Pick species, show references")%></strong></a>
                      <%=cm.cmsTitle("find_books_articles")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find books, articles which refers to species")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-references.jsp"><strong><%=cm.cmsPhrase("Pick references, show species")%></strong></a>
                      <%=cm.cmsTitle("fins_species_reffered_by_books")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find species referred by books, articles etc.")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-taxonomic-browser.jsp"><strong><%=cm.cmsPhrase("Taxonomic classification")%></strong></a>
                      <%=cm.cmsTitle("taxonomic_classification_for_species")%>
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
              <table summary="layout" class="datatable fullwidth">
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
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-advanced.jsp?natureobject=Species">
                          <strong><%=cm.cmsPhrase("Advanced Search")%></strong></a>
                    </td>
                    <td>
                        <%=cm.cmsPhrase("Search species information using more complex filtering capabilities")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="advanced-help.jsp"><strong><%=cm.cmsPhrase("How to use Advanced search")%></strong></a>
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
              <table class="datatable fullwidth">
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
                      <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                      <a href="species-statistics-module.jsp">
                        <strong>
                          <%=cm.cmsPhrase("Statistical data")%>
                        </strong>
                      </a>
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
              <table class="datatable fullwidth">
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
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-download.jsp"><strong><%=cm.cmsPhrase("Links and Downloads")%></strong></a>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Links and Downloads")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-indicators.jsp"><strong><%=cm.cmsPhrase("Species indicators")%></strong></a>
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
                <table class="datatable fullwidth">
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
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="easy-help.jsp"><strong><%=cm.cmsPhrase("How to use Easy search")%></strong></a>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Help on species <strong>Easy Searches</strong>")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="glossary.jsp?module=species"><strong><%=cm.cmsPhrase("Glossary")%></strong></a>
                        <%=cm.cmsTitle("species_main_glossary_Title")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Glossary of the terms used in EUNIS Database species module")%>
                      </td>
                    </tr>
                    <tr>
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="http://biodiversity-chm.eea.europa.eu/search_html">
                            <strong><%=cm.cmsPhrase("Browse")%></strong></a>
                        <%=cm.cmsTitle("generic_information_tools_on_species")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Generic information tools on Species diversity")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="species-help.jsp"><strong><%=cm.cmsPhrase("How to use")%></strong></a>
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
