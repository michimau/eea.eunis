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
  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
  String []tabs = { "sites_tabeasysearch", "sites_tabadvancedsearch", "sites_tabstatisticaldata", "sites_tablinkdownloads", "sites_tabhelp" };
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
      <%=cm.cms("sites_main_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,sites_location"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <img id="loading" alt="Loading progress" title="Loading progress" src="images/loading.gif" width="250" height="45" />
      <h1 align="center">
        <%=cm.cmsText("sites_main_sitesSearch")%>
      </h1>
      <h2 align="center">
        <%=cm.cmsText("sites_main_description")%>
      </h2>
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
                 class="inputTextField"
                 value="<%=cm.cms("sites_entersitename")%>"
                 title="<%=cm.cms("sites_entersitename")%>"
                 onfocus="this.select();" />
          <%=cm.cmsLabel("quick_search_sites_01")%>
          <%=cm.cmsTitle("sites_entersitename")%>
          <%=cm.cmsInput("sites_entersitename")%>
          <input type="submit" value="<%=cm.cms( "sites_main_btnSearch")%>" name="Submit" class="inputTextField" title="<%=cm.cms( "sites_main_btnSearch")%>" />
          <%=cm.cmsInput("sites_main_btnSearch")%>
          <%=cm.cmsTitle("sites_main_btnSearch")%>
          <a href="fuzzy-search-help.jsp" title="<%=cm.cms("help_fuzzy_search")%>"><img alt="<%=cm.cms("help")%>" src="images/mini/help.jpg" border="0" align="middle" /></a>
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
          <table cellspacing="1" cellpadding="3" width="100%" border="0" summary="Easy search">
          <caption><%=cm.cms( "sites_main_easySearchesDesc" ) %></caption>
            <tr>
              <th>
               <%=cm.cmsText("sites_links_easy_searches")%>
              </th>
              <th>
               <%=cm.cmsText("sites_description")%>
              </th>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_name")%>" href="sites-names.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_nameDesc")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_name")%>
              </td>
              <td class="grey_cell">
                <%=cm.cmsText("sites_main_nameDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_sizeDesc")%>" href="sites-size.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_size")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_sizeDesc")%>
              </td>
              <td>
                <%=cm.cmsText("sites_main_sizeDesc")%>
              </td>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_coordinatesDesc")%>" href="sites-coordinates.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_coordinates")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_coordinatesDesc")%>
              </td>
              <td class="grey_cell">
                <%=cm.cmsText("sites_main_coordinatesDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_countryDesc")%>" href="sites-country.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_country")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_countryDesc")%>
              </td>
              <td>
                <%=cm.cmsText("sites_main_countryDesc")%>
              </td>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_altitudeDesc")%>" href="sites-altitude.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_altitude")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_altitudeDesc")%>
              </td>
              <td class="grey_cell">
                <%=cm.cmsText("sites_main_altitudeDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_designationDesc")%>" href="sites-year.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_designation")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_designationDesc")%>
              </td>
              <td>
                <%=cm.cmsText("sites_main_designationDesc")%>
              </td>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_showSpeciesDesc")%>" href="species-sites.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_showSpecies")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_showSpeciesDesc")%>
              </td>
              <td class="grey_cell">
                <%=cm.cms("sites_main_showSpeciesDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_showHabitatsDesc")%>" href="habitats-sites.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_showHabitats")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_showHabitatsDesc")%>
              </td>
              <td>
                <%=cm.cmsText("sites_main_showHabitatsDesc")%>
              </td>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_showSitesDesc")%>" href="sites-designated-codes.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_showSites")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_showSitesDesc")%>
              </td>
              <td class="grey_cell">
                <%=cm.cmsText("sites_main_showSitesDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_designationTypesDesc")%>" href="sites-designations.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_designationTypes")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_designationTypesDesc")%>
              </td>
              <td>
                <%=cm.cmsText("sites_main_designationTypesDesc")%>
              </td>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_neighborhoodDesc")%>" href="sites-neighborhood.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_neighborhood")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_neighborhoodDesc")%>
              </td>
              <td class="grey_cell" abbr="Site neighborhood">
                <%=cm.cmsText("sites_main_neighborhoodDesc")%>
              </td>
            </tr>
          </table>
<%
  }
  if ( tab == 1 )
  {
%>
          <table cellspacing="1" cellpadding="3" width="100%" border="0" summary="Advanced search">
            <caption><%=cm.cms( "sites_main_advSearchDesc" ) %></caption>
            <tr>
              <th>
                <%=cm.cmsText("sites_links_advanced_searches")%>
              </th>
              <th>
                <%=cm.cmsText("sites_description")%>
              </th>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_advSearchSearchDesc")%>" href="sites-advanced.jsp?natureobject=Sites">
                  <strong>
                    <%=cm.cmsText("sites_main_advSearch")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_advSearchSearchDesc")%>
              </td>
              <td class="grey_cell">
                <%=cm.cmsText("sites_main_advSearchSearchDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_advHowToDesc")%>" href="advanced-help.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_advHowTo")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_advHowToDesc")%>
              </td>
              <td>
                <%=cm.cmsText("sites_main_advHowToDesc")%>
              </td>
            </tr>
          </table>
<%
  }
  if ( tab == 2 )
  {
%>
          <table cellspacing="1" cellpadding="3" width="100%" border="0" summary="Statistical data">
            <caption><%=cm.cms( "sites_main_statisticDesc" ) %></caption>
            <tr>
              <th>
                <%=cm.cmsText("sites_links_statisticaldatatable")%>
              </th>
              <th>
                <%=cm.cmsText("sites_description")%>
              </th>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_numberDesc")%>" href="sites-statistical.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_number")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_numberDesc")%>
              </td>
              <td class="grey_cell">
                <%=cm.cmsText("sites_main_numberDesc")%>
              </td>
            </tr>
          </table>
<%
  }
  if ( tab == 3 )
  {
%>
          <table cellspacing="1" cellpadding="3" width="100%" border="0" summary="Links &amp; downloads">
            <caption><%=cm.cms( "sites_main_linksDesc") %></caption>
            <tr>
              <th>
                <%=cm.cmsText("sites_links_linksdownloadstable")%>
              </th>
              <th>
                <%=cm.cmsText("sites_description")%>
              </th>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <a title="<%=cm.cms("sites_main_linksDownloadsDesc")%>" href="sites-download.jsp">
                  <strong>
                    <%=cm.cmsText("sites_main_linksDownloads")%>
                  </strong>
                </a>
                <%=cm.cmsTitle("sites_main_linksDownloadsDesc")%>
              </td>
              <td class="grey_cell">
                <%=cm.cmsText("sites_main_linksDownloadsDesc")%>
              </td>
            </tr>
            <tr>
              <td style="white-space : nowrap">
                <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.cmsTitle("bullet_title")%>
                <%=cm.cmsAlt("bullet_alt")%>
                <%=cm.cmsText("sites_main_indicators")%>
              </td>
              <td>
                <%=cm.cmsText("sites_main_indicatorsDesc")%>
              </td>
            </tr>
          </table>
<%
  }
  if ( tab == 4 )
  {
%>
      <table cellspacing="1" cellpadding="3" width="100%" border="0" summary="Help">
        <caption><%=cm.cms( "sites_main_generalInfo" ) %></caption>
        <tr>
          <th>
            <%=cm.cmsText("sites_links_onlinehelptable")%>
          </th>
          <th>
            <%=cm.cmsText("sites_description")%>
          </th>
        </tr>
        <tr>
          <td class="grey_cell">
            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
            <%=cm.cmsTitle("bullet_title")%>
            <%=cm.cmsAlt("bullet_alt")%>
            <a title="<%=cm.cms("sites_main_howtouseeasysearch")%>" href="easy-help.jsp">
              <strong>
                <%=cm.cmsText("sites_main_howTo")%>
              </strong>
            </a>
            <%=cm.cmsTitle("sites_main_howtouseeasysearch")%>
          </td>
          <td class="grey_cell">
            <%=cm.cmsText("sites_main_howToDesc")%>
          </td>
        </tr>
        <tr>
          <td>
            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
            <%=cm.cmsTitle("bullet_title")%>
            <%=cm.cmsAlt("bullet_alt")%>
            <a title="<%=cm.cms("sites_main_glossaryDesc")%>" href="glossary.jsp?module=sites">
              <strong>
                <%=cm.cmsText("sites_main_glossary")%>
              </strong>
            </a>
            <%=cm.cmsTitle("sites_main_glossaryDesc")%>
          </td>
          <td>
            <%=cm.cmsText("sites_main_glossaryDesc")%>
          </td>
        </tr>
        <tr>
          <td class="grey_cell">
            <img alt="<%=cm.cms("bullet_alt")%>" title="<%=cm.cms("bullet_title")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
            <%=cm.cmsTitle("bullet_title")%>
            <%=cm.cmsAlt("bullet_alt")%>
            <a title="<%=cm.cms("sites_main_sitesHowToDesc")%>" href="sites-help.jsp">
              <strong>
                <%=cm.cmsText("sites_main_sitesHowTo")%>
              </strong>
            </a>
            <%=cm.cmsTitle("sites_main_sitesHowToDesc")%>
          </td>
          <td class="grey_cell">
            <%=cm.cmsText("sites_main_sitesHowToDesc")%>
          </td>
        </tr>
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
      <%=cm.cmsMsg("sites_main_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_main_easySearchesDesc")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_main_advSearchDesc")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_main_statisticDesc")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_main_linksDesc")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_main_generalInfo")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites.jsp" />
      </jsp:include>
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
    </div>
    </div>
    </div>
  </body>
</html>