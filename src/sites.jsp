<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Sites module function - display links to all sites searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.sites.names.NameSortCriteria,
                ro.finsiel.eunis.search.AbstractSortCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites";
  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
  String []tabs = { "easy_search", "advanced_search", "statistical_data", "links_and_downloads", "help" };
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>" lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <script language="javascript" type="text/javascript" src="script/sites.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
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
                  <jsp:param name="mapLink" value="show"/>
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <img id="loading" alt="Loading progress" title="Loading progress" src="images/loading.gif" width="250" height="45" />
                <h1 class="documentFirstHeading">
                  <%=cm.cmsText("sites_main_sitesSearch")%>
                </h1>
                <div class="documentDescription">
                  <%=cm.cmsText("sites_main_description")%>
                </div>
                <div style="text-align : center; padding-left : 10px; width : 730px; vertical-align : middle; color : black;">
                  <br />
                  <form name="quick_search" id="quick_search" action="sites-names-result.jsp" method="post" onsubmit="return validateQS();">
                    <input type="hidden" name="showSourceDB" value="true" />
                    <input type="hidden" name="showCountry" value="true" />
                    <input type="hidden" name="showDesignationTypes" value="true" />
                    <input type="hidden" name="showName" value="true" />
                    <input type="hidden" name="showCoordinates" value="true" />
                    <input type="hidden" name="showSize" value="true" />
                    <input type="hidden" name="showDesignationYear" value="true" />
                    <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_NAME%>" />
                    <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
                    <input type="hidden" name="DB_NATURA2000" value="ON" />
                    <input type="hidden" name="DB_CDDA_NATIONAL" value="ON" />
                    <input type="hidden" name="DB_CDDA_NATIONAL" value="ON" />
                    <input type="hidden" name="DB_DIPLOMA" value="ON" />
                    <input type="hidden" name="DB_CDDA_INTERNATIONAL" value="ON" />
                    <input type="hidden" name="DB_CORINE" value="ON" />
                    <input type="hidden" name="DB_BIOGENETIC" value="ON" />
                    <input type="hidden" name="DB_EMERALD" value="ON" />
                    <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_STARTS%>" />
                    <label for="englishName"><%=cm.cms("quick_search_sites_01")%></label>
                    <input type="text"
                           size="32"
                           name="englishName"
                           id="englishName"
                           value="<%=cm.cms("sites_entersitename")%>"
                           title="<%=cm.cms("sites_entersitename")%>"
                           onfocus="this.select();" />
                    <%=cm.cmsLabel("quick_search_sites_01")%>
                    <%=cm.cmsTitle("sites_entersitename")%>
                    <%=cm.cmsInput("sites_entersitename")%>
                    <input type="submit" value="<%=cm.cms( "search")%>" name="Submit" class="searchButton" title="<%=cm.cms( "search")%>" />
                    <%=cm.cmsInput("search")%>
                    <%=cm.cmsTitle("search")%>
                    <a href="fuzzy-search-help.jsp" title="<%=cm.cms("help_fuzzy_search")%>"><img alt="<%=cm.cms("help")%>" src="images/mini/help.jpg" border="0" style="vertical-align:middle" /></a>
                    <%=cm.cmsTitle("help_fuzzy_search")%>
                    <%=cm.cmsAlt("help")%>
                    <br />
                  </form>
                </div>
                <br />
                <div id="tabbedmenu">
                  <ul>
          <%
            String currentTab;
            for ( int i = 0; i < tabs.length; i++ )
            {
              currentTab = "";
              if ( tab == i ) currentTab = " id=\"currenttab\"";
          %>
                <li<%=currentTab%>>
                  <a title="Select <%=cm.cms( tabs[ i ] )%>" href="sites.jsp?tab=<%=i%>"><%=cm.cms( tabs[ i ] )%></a>
                </li>
          <%
              }
          %>
                  </ul>
                </div>
                <br class="brClear" />
                <br />
          <%
            if ( tab == 0 )
            {
          %>
                    <table class="datatable" width="90%" border="0" summary="Easy search">
                      <caption><%=cm.cms( "sites_main_easySearchesDesc" ) %></caption>
                      <thead>
                        <tr>
                          <th>
                           <%=cm.cmsText("links_to_easy_searches")%>
                          </th>
                          <th>
                           <%=cm.cmsText("description")%>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("name")%>" href="sites-names.jsp">
                              <strong>
                                <%=cm.cmsText("name")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("name")%>
                          </td>
                          <td>
                            <%=cm.cmsText("name")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("search_by_size")%>" href="sites-size.jsp">
                              <strong>
                                <%=cm.cmsText("size_area_length")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("search_by_size")%>
                          </td>
                          <td>
                            <%=cm.cmsText("search_by_size")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("search_by_coordinates")%>" href="sites-coordinates.jsp">
                              <strong>
                                <%=cm.cmsText("coordinates")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("search_by_coordinates")%>
                          </td>
                          <td>
                            <%=cm.cmsText("search_by_coordinates")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_countryDesc")%>" href="sites-country.jsp">
                              <strong>
                                <%=cm.cmsText("country")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_countryDesc")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_countryDesc")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_altitudeDesc")%>" href="sites-altitude.jsp">
                              <strong>
                                <%=cm.cmsText("altitude")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_altitudeDesc")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_altitudeDesc")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_designationDesc")%>" href="sites-year.jsp">
                              <strong>
                                <%=cm.cmsText("designation_year")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_designationDesc")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_designationDesc")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_showSpeciesDesc")%>" href="species-sites.jsp">
                              <strong>
                                <%=cm.cmsText("pick_sites_show_species")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_showSpeciesDesc")%>
                          </td>
                          <td>
                            <%=cm.cms("sites_main_showSpeciesDesc")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_showHabitatsDesc")%>" href="habitats-sites.jsp">
                              <strong>
                                <%=cm.cmsText("pick_sites_show_habitat_types")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_showHabitatsDesc")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_showHabitatsDesc")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_showSitesDesc")%>" href="sites-designated-codes.jsp">
                              <strong>
                                <%=cm.cmsText("pick_designation_types_show_sites")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_showSitesDesc")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_showSitesDesc")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_designationTypesDesc")%>" href="sites-designations.jsp">
                              <strong>
                                <%=cm.cmsText("designation_types")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_designationTypesDesc")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_designationTypesDesc")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_neighborhoodDesc")%>" href="sites-neighborhood.jsp">
                              <strong>
                                <%=cm.cmsText("site_neighborhood_1")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_neighborhoodDesc")%>
                          </td>
                          <td abbr="Site neighborhood">
                            <%=cm.cmsText("sites_main_neighborhoodDesc")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                              <%=cm.cmsTitle("bullet_alt")%>
                              <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_tree_browser")%>" href="sites-tree.jsp">
                              <strong>
                                <%=cm.cmsText("sites_tree_browser")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_tree_browser_description")%>
                          </td>
                        </tr>
                      </tbody>
                    </table>
          <%
            }
            if ( tab == 1 )
            {
          %>
                    <table class="datatable" width="90%" border="0" summary="Advanced search">
                      <caption><%=cm.cms( "flexible_search_tool_to_build_your_own_query" ) %></caption>
                      <thead>
                        <tr>
                          <th>
                            <%=cm.cmsText("links_to_advanced_searches")%>
                          </th>
                          <th>
                            <%=cm.cmsText("description")%>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_advSearchSearchDesc")%>" href="sites-advanced.jsp?natureobject=Sites">
                              <strong>
                                <%=cm.cmsText("advanced_search")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_advSearchSearchDesc")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_advSearchSearchDesc")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_advHowToDesc")%>" href="advanced-help.jsp">
                              <strong>
                                <%=cm.cmsText("how_to_use_advanced_search")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_advHowToDesc")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_advHowToDesc")%>
                          </td>
                        </tr>
                      </tbody>
                    </table>
          <%
            }
            if ( tab == 2 )
            {
          %>
                    <table class="datatable" width="90%" summary="Statistical data">
                      <caption><%=cm.cms( "search_tool_to_build_aggregated_data" ) %></caption>
                      <thead>
                        <tr>
                          <th>
                            <%=cm.cmsText("links_to_statistical_data")%>
                          </th>
                          <th>
                            <%=cm.cmsText("description")%>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_numberDesc")%>" href="sites-statistical.jsp">
                              <strong>
                                <%=cm.cmsText("sites_main_number")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_numberDesc")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_numberDesc")%>
                          </td>
                        </tr>
                      </tbody>
                    </table>
          <%
            }
            if ( tab == 3 )
            {
          %>
                    <table class="datatable" width="90%" summary="Links &amp; downloads">
                      <caption><%=cm.cms( "sites_main_linksDesc") %></caption>
                      <thead>
                        <tr>
                          <th>
                            <%=cm.cmsText("links_and_downloads_1")%>
                          </th>
                          <th>
                            <%=cm.cmsText("description")%>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <a title="<%=cm.cms("sites_main_linksDownloadsDesc")%>" href="sites-download.jsp">
                              <strong>
                                <%=cm.cmsText("links_and_downloads_2")%>
                              </strong>
                            </a>
                            <%=cm.cmsTitle("sites_main_linksDownloadsDesc")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_linksDownloadsDesc")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td style="white-space : nowrap">
                            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <%=cm.cmsTitle("bullet_alt")%>
                            <%=cm.cmsAlt("bullet_alt")%>
                            <%=cm.cmsText("sites_main_indicators")%>
                          </td>
                          <td>
                            <%=cm.cmsText("sites_main_indicatorsDesc")%>
                          </td>
                        </tr>
                      </tbody>
                    </table>
          <%
            }
            if ( tab == 4 )
            {
          %>
                <table class="datatable" width="90%" summary="Help">
                  <caption><%=cm.cms( "general_information_on_eunis" ) %></caption>
                  <thead>
                    <tr>
                      <th>
                        <%=cm.cmsText("links_to_online_help")%>
                      </th>
                      <th>
                        <%=cm.cmsText("description")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                        <%=cm.cmsTitle("bullet_alt")%>
                        <%=cm.cmsAlt("bullet_alt")%>
                        <a title="<%=cm.cms("how_to_use_easy_search")%>" href="easy-help.jsp">
                          <strong>
                            <%=cm.cmsText("how_to_use_easy_search")%>
                          </strong>
                        </a>
                        <%=cm.cmsTitle("how_to_use_easy_search")%>
                      </td>
                      <td>
                        <%=cm.cmsText("sites_main_howToDesc")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td>
                        <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                        <%=cm.cmsTitle("bullet_alt")%>
                        <%=cm.cmsAlt("bullet_alt")%>
                        <a title="<%=cm.cms("sites_main_glossaryDesc")%>" href="glossary.jsp?module=sites">
                          <strong>
                            <%=cm.cmsText("glossary")%>
                          </strong>
                        </a>
                        <%=cm.cmsTitle("sites_main_glossaryDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsText("sites_main_glossaryDesc")%>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                        <%=cm.cmsTitle("bullet_alt")%>
                        <%=cm.cmsAlt("bullet_alt")%>
                        <a title="<%=cm.cms("sites_main_sitesHowToDesc")%>" href="sites-help.jsp">
                          <strong>
                            <%=cm.cmsText("how_to_use")%>
                          </strong>
                        </a>
                        <%=cm.cmsTitle("sites_main_sitesHowToDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsText("sites_main_sitesHowToDesc")%>
                      </td>
                    </tr>
                  </tbody>
                </table>
          <%
            }
          %>
          <%
            for ( int i = 0; i < tabs.length; i++ )
            {
          %>
                <%=cm.cmsMsg( tabs[ i ] )%>
                <%=cm.br()%>
          <%
            }
          %>
                <%=cm.cmsMsg("sites")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_main_easySearchesDesc")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("flexible_search_tool_to_build_your_own_query")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("search_tool_to_build_aggregated_data")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_main_linksDesc")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("general_information_on_eunis")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="sites.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
    <script language="javascript" type="text/javascript">
      try
      {
        var ctrl_loading = document.getElementById( "loading" );
        ctrl_loading.style.display = "none";
      }
      catch ( e )
      {
      }
    </script>
  </body>
</html>
