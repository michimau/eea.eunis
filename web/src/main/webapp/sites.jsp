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
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites";
  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
  String []tabs = { cm.cmsPhrase("Easy search"), cm.cmsPhrase("Advanced search"), cm.cmsPhrase("Statistical data"), cm.cmsPhrase("Help") };
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>" lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cmsPhrase("Sites")%>
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
                  <jsp:param name="mapLink" value="show"/>
                </jsp:include>
                <a name="documentContent"></a>
                <img id="loading" alt="Loading progress" title="Loading progress" src="images/loading.gif" width="250" height="45" />
                <h1 class="documentFirstHeading">
                  <%=cm.cmsPhrase("Sites search")%>
                </h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cmsPhrase("Print this page")%>"
                            title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cmsPhrase("Toggle full screen mode")%>"
                             title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <div class="documentDescription">
                  <%=cm.cmsPhrase("Access information about sites of interest for biodiversity and nature protection")%>
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
                    <label for="englishName"><%=cm.cmsPhrase("Search sites by code or by name starting with:")%></label>
                    <input type="text"
                           size="32"
                           name="englishName"
                           id="englishName"
                           value="<%=cm.cmsPhrase("Enter code or site name here...")%>"
                           onfocus="if(this.value=='<%=cm.cmsPhrase("Enter code or site name here...")%>')this.value='';"
                           onblur="if(this.value=='')this.value='<%=cm.cmsPhrase("Enter code or site name here...")%>';" />
                    <input type="submit" value="<%=cm.cmsPhrase("Search")%>" name="Submit" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" />
                    <a href="fuzzy-search-help.jsp" title="<%=cm.cmsPhrase("Help on fuzzy search")%>"><img alt="" src="images/mini/help.jpg" border="0" style="vertical-align:middle" /></a>
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
                  <a href="sites.jsp?tab=<%=i%>"><%=tabs[ i ]%></a>
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
                    <table class="datatable fullwidth" summary="Easy search">
                      <caption><%=cm.cmsPhrase( "A set of predefined functions to search the database" ) %></caption>
                      <thead>
                        <tr>
                          <th>
                           <%=cm.cmsPhrase("Links to easy searches")%>
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
                            <a title="<%=cm.cmsPhrase("Search sites by name")%>" href="sites-names.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Name")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Search sites by name")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Search sites by size")%>" href="sites-size.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Size (Area/Length)")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Search sites by size")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Search sites by geographical coordinates")%>" href="sites-coordinates.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Coordinates")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Search sites by geographical coordinates")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Search sites by country location")%>" href="sites-country.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Country")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Search sites by country location")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Search sites by characterizing altitude")%>" href="sites-altitude.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Altitude")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Search sites by characterizing altitude")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Search sites by the year of designation")%>" href="sites-year.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Designation year")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Search sites by the year of designation")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Identify species located within sites")%>" href="species-sites.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Pick sites, show species")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Identify species located within sites")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Identify habitat types located within sites ")%>" href="habitats-sites.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Pick sites, show habitat types")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Identify habitat types located within sites")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Search sites by legal instruments")%>" href="sites-designated-codes.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Pick designation types, show sites")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Search sites by legal instruments ")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Search designation types")%>" href="sites-designations.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Designation types")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Search designation types")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Search neighboring sites within a range of a specified site")%>" href="sites-neighborhood.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Site neighborhood")%>
                              </strong>
                            </a>
                          </td>
                          <td abbr="Site neighborhood">
                            <%=cm.cmsPhrase("Search neighboring sites within a range of a specified site")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Sites tree browser")%>" href="sites-tree.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Sites tree browser")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Sites tree browser")%>
                          </td>
                        </tr>
                      </tbody>
                    </table>
          <%
            }
            if ( tab == 1 )
            {
          %>
                    <table class="datatable fullwidth" summary="Advanced search">
                      <caption><%=cm.cmsPhrase( "A flexible search tool to build your own query" ) %></caption>
                      <thead>
                        <tr>
                          <th>
                            <%=cm.cmsPhrase("Links to advanced searches")%>
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
                            <a title="<%=cm.cmsPhrase("Search sites information using more complex filtering capabilities")%>" href="sites-advanced.jsp?natureobject=Sites">
                              <strong>
                                <%=cm.cmsPhrase("Advanced Search")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Search sites information using more complex filtering capabilities")%>
                          </td>
                        </tr>
                        <tr class="zebraeven">
                          <td>
                            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                            <a title="<%=cm.cmsPhrase("Help on sites Advanced Search")%>" href="advanced-help.jsp">
                              <strong>
                                <%=cm.cmsPhrase("How to use Advanced search")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Help on sites Advanced Search")%>
                          </td>
                        </tr>
                      </tbody>
                    </table>
          <%
            }
            if ( tab == 2 )
            {
          %>
                    <table class="datatable fullwidth" summary="Statistical data">
                      <caption><%=cm.cmsPhrase( "A search tool to build aggregated data" ) %></caption>
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
                            <a title="<%=cm.cmsPhrase("Find statistical data about sites")%>" href="sites-statistical.jsp">
                              <strong>
                                <%=cm.cmsPhrase("Number/Total area")%>
                              </strong>
                            </a>
                          </td>
                          <td>
                            <%=cm.cmsPhrase("Find statistical data about sites")%>
                          </td>
                        </tr>
                      </tbody>
                    </table>
          <%
            }
            if ( tab == 3 )
            {
          %>
                <table class="datatable fullwidth" summary="Help">
                  <caption><%=cm.cmsPhrase( "General information on EUNIS application" ) %></caption>
                  <thead>
                    <tr>
                      <th>
                        <%=cm.cmsPhrase("Links to online help")%>
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
                        <a title="<%=cm.cmsPhrase("How to use Easy search")%>" href="easy-help.jsp">
                          <strong>
                            <%=cm.cmsPhrase("How to use Easy search")%>
                          </strong>
                        </a>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Help on sites <strong>Easy Searches</strong>")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td>
                        <img alt=""src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                        <a title="<%=cm.cmsPhrase("Glossary of the terms used in EUNIS Database sites module")%>" href="glossary.jsp?module=sites">
                          <strong>
                            <%=cm.cmsPhrase("Glossary")%>
                          </strong>
                        </a>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Glossary of the terms used in EUNIS Database sites module")%>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <img alt=""src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                        <a title="<%=cm.cmsPhrase("Sites online help")%>" href="sites-help.jsp">
                          <strong>
                            <%=cm.cmsPhrase("How to use")%>
                          </strong>
                        </a>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Sites online help")%>
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
      <jsp:include page="footer-static.jsp" />
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
