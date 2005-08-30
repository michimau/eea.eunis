<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Sites module function - display links to all sites searches.
--%>
<%@page contentType="text/html"%>
<%@page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.sites.names.NameSortCriteria,
                ro.finsiel.eunis.search.AbstractSortCriteria,
                ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
  String []tabs = { "Easy search", "Advanced search", "Statistical data", "Links &amp; Downloads", "Help" };
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>" lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
    <script language="javascript" type="text/javascript" src="script/sites.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.getContent("sites_main_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <img id="loading" alt="Loading progress" title="Loading progress" src="images/loading.gif" width="250" height="45" />
      <h5 align="center">
        <%=cm.getContent("sites_main_sitesSearch")%>
      </h5>
      <h6 align="center">
        <%=cm.getContent("sites_main_description")%>
      </h6>
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
          <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_STARTS%>" />
          <label for="englishName"><%=cm.getContent("quick_search_sites_01")%></label>
          <input type="text"
                 size="32"
                 name="englishName"
                 id="englishName"
                 class="inputTextField"
                 value="Enter site name here..."
                 title="Enter site name here..."
                 onfocus="this.select();" />
          <input type="submit" value="<%=cm.getContent( "sites_main_btnSearch", false )%>" name="Submit" class="inputTextField" title="<%=cm.getContent( "sites_main_btnSearch", false )%>" />
          <%=cm.writeEditTag( "sites_main_btnSearch" )%>
          <a href="fuzzy-search-help.jsp" title="Help on fuzzy search"><img alt="Help" title="Help" src="images/mini/help.jpg" border="0" align="middle" /></a>
          <br />
        </form>
      </div>
      <br />
      <div id="tabbedmenu">
        <ul>
<%
  String currentTab = "";
  for ( int i = 0; i < tabs.length; i++ )
  {
    currentTab = "";
    if ( tab == i ) currentTab = " id=\"currenttab\"";
%>
      <li<%=currentTab%>>
        <a title="Select <%=tabs[ i ]%>" href="sites.jsp?tab=<%=i%>"><%=tabs[ i ]%></a>
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
          <caption><%=cm.getContent( "sites_main_easySearchesDesc" ) %></caption>
            <tr>
              <th>
                Links to easy searches
              </th>
              <th>
                Description
              </th>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_name", false )%>" href="sites-names.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_nameDesc")%>
                  </strong>
                </a>
              </td>
              <td class="grey_cell">
                <%=cm.getContent("sites_main_nameDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_sizeDesc", false )%>" href="sites-size.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_size")%>
                  </strong>
                </a>
              </td>
              <td>
                <%=cm.getContent("sites_main_sizeDesc")%>
              </td>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_coordinatesDesc", false )%>" href="sites-coordinates.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_coordinates")%>
                  </strong>
                </a>
              </td>
              <td class="grey_cell">
                <%=cm.getContent("sites_main_coordinatesDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_countryDesc", false )%>" href="sites-country.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_country")%>
                  </strong>
                </a>
              </td>
              <td>
                <%=cm.getContent("sites_main_countryDesc")%>
              </td>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_altitudeDesc", false )%>" href="sites-altitude.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_altitude")%>
                  </strong>
                </a>
              </td>
              <td class="grey_cell">
                <%=cm.getContent("sites_main_altitudeDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_designationDesc", false )%>" href="sites-year.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_designation")%>
                  </strong>
                </a>
              </td>
              <td>
                <%=cm.getContent("sites_main_designationDesc")%>
              </td>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_showSpeciesDesc", false )%>" href="species-sites.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_showSpecies")%>
                  </strong>
                </a>
              </td>
              <td class="grey_cell">
                <%=cm.getContent("sites_main_showSpeciesDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_showHabitatsDesc", false )%>" href="habitats-sites.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_showHabitats")%>
                  </strong>
                </a>
              </td>
              <td>
                <%=cm.getContent("sites_main_showHabitatsDesc")%>
              </td>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_showSitesDesc", false )%>" href="sites-designated-codes.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_showSites")%>
                  </strong>
                </a>
              </td>
              <td class="grey_cell">
                <%=cm.getContent("sites_main_showSitesDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_designationTypesDesc", false )%>" href="sites-designations.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_designationTypes")%>
                  </strong>
                </a>
              </td>
              <td>
                <%=cm.getContent("sites_main_designationTypesDesc")%>
              </td>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_neighborhoodDesc", false )%>" href="sites-neighborhood.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_neighborhood")%>
                  </strong>
                </a>
              </td>
              <td class="grey_cell" abbr="Site neighborhood">
                <%=cm.getContent("sites_main_neighborhoodDesc")%>
              </td>
            </tr>
            <tr>
              <td style="white-space : nowrap">
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <%=cm.getContent("sites_main_indicators")%>
              </td>
              <td>
                <%=cm.getContent("sites_main_indicatorsDesc")%>
              </td>
            </tr>
          </table>
<%
  }
  if ( tab == 1 )
  {
%>
          <table cellspacing="1" cellpadding="3" width="100%" border="0" summary="Advanced search">
            <caption><%=cm.getContent( "sites_main_advSearchDesc" ) %></caption>
            <tr>
              <th>
                Links to advanced searches
              </th>
              <th>
                Description
              </th>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_advSearchSearchDesc", false )%>" href="sites-advanced.jsp?natureobject=Sites">
                  <strong>
                    <%=cm.getContent("sites_main_advSearch")%>
                  </strong>
                </a>
              </td>
              <td class="grey_cell">
                <%=cm.getContent("sites_main_advSearchSearchDesc")%>
              </td>
            </tr>
            <tr>
              <td>
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_advHowToDesc", false )%>" href="advanced-help.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_advHowTo")%>
                  </strong>
                </a>
              </td>
              <td>
                <%=cm.getContent("sites_main_advHowToDesc")%>
              </td>
            </tr>
          </table>
<%
  }
  if ( tab == 2 )
  {
%>
          <table cellspacing="1" cellpadding="3" width="100%" border="0" summary="Statistical data">
            <caption><%=cm.getContent( "sites_main_statisticDesc" ) %></caption>
            <tr>
              <th>
                Links to statistical data
              </th>
              <th>
                Description
              </th>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_numberDesc", false )%>" href="sites-statistical.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_number")%>
                  </strong>
                </a>
              </td>
              <td class="grey_cell">
                <%=cm.getContent("sites_main_numberDesc")%>
              </td>
            </tr>
          </table>
<%
  }
  if ( tab == 3 )
  {
%>
          <table cellspacing="1" cellpadding="3" width="100%" border="0" summary="Links &amp; downloads">
            <caption><%=cm.getContent( "sites_main_linksDesc" , false ) %></caption>
            <tr>
              <th>
                Links &amp; downloads
              </th>
              <th>
                Description
              </th>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("sites_main_linksDownloadsDesc", false )%>" href="sites-download.jsp">
                  <strong>
                    <%=cm.getContent("sites_main_linksDownloads")%>
                  </strong>
                </a>
              </td>
              <td class="grey_cell">
                <%=cm.getContent("sites_main_linksDownloadsDesc")%>
              </td>
            </tr>
          </table>
<%
  }
  if ( tab == 4 )
  {
%>
      <table cellspacing="1" cellpadding="3" width="100%" border="0" summary="Help">
        <caption><%=cm.getContent( "sites_main_generalInfo" ) %></caption>
        <tr>
          <th>
            Links to online help
          </th>
          <th>
            Description
          </th>
        </tr>
        <tr>
          <td class="grey_cell">
            <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
            <a title="How to use Easy search" href="easy-help.jsp">
              <strong>
                <%=cm.getContent("sites_main_howTo")%>
              </strong>
            </a>
          </td>
          <td class="grey_cell">
            <%=cm.getContent("sites_main_howToDesc")%>
          </td>
        </tr>
        <tr>
          <td>
            <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
            <a title="<%=cm.getContent("sites_main_glossaryDesc", false )%>" href="glossary.jsp?module=sites">
              <strong>
                <%=cm.getContent("sites_main_glossary")%>
              </strong>
            </a>
          </td>
          <td>
            <%=cm.getContent("sites_main_glossaryDesc")%>
          </td>
        </tr>
        <tr>
          <td class="grey_cell">
            <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
            <a title="<%=cm.getContent("sites_main_sitesHowToDesc", false )%>" href="sites-help.jsp">
              <strong>
                <%=cm.getContent("sites_main_sitesHowTo")%>
              </strong>
            </a>
          </td>
          <td class="grey_cell">
            <%=cm.getContent("sites_main_sitesHowToDesc")%>
          </td>
        </tr>
      </table>
<%
  }
%>
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
      <noscript><%=Accesibility.getText( "generic.noscript" )%></noscript>
    </div>
  </body>
</html>