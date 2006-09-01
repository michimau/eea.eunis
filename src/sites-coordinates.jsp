<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites coordinates" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <script type="text/javascript" language="Javascript" src="script/sites-coordinates.js"></script>
    <script type="text/javascript" language="Javascript" src="script/save-criteria.js"></script>
    <script type="text/javascript" language="Javascript" src="script/sites-coordinates-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
     var countryListString = "<%=Utilities.getCountryListString()%>";
        //-->
    </script>
    <title>
      <%=cm.cms("sites_coordinates_title")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_SERVER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
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
                <br clear="all" />
<!-- MAIN CONTENT -->
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="home#index.jsp,sites#sites.jsp,coordinates"/>
                  <jsp:param name="helpLink" value="sites-help.jsp"/>
                  <jsp:param name="mapLink" value="show"/>
                </jsp:include>
                <form name="eunis" method="get" action="sites-coordinates-result.jsp" onsubmit="return validateForm();">
                  <h1>
                    <%=cm.cmsText("sites_coordinates_01")%>
                  </h1>

                  <%=cm.cmsText("sites_coordinates_18")%>
                  <br />
                  <br />
                  <div class="grey_rectangle">
                    <strong>
                      <%=cm.cmsText("search_will_provide")%>
                    </strong>
                    <br />
                    <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set_1")%>" />
                    <label for="showSourceDB"><%=cm.cmsText("source_data_set_1")%></label>
                    <%=cm.cmsTitle("source_data_set_1")%>

                    <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("country_1")%>" />
                    <label for="showCountry"><%=cm.cmsText("country_1")%></label>
                    <%=cm.cmsTitle("country_1")%>

                    <input id="showName" name="showName" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("site_name_1")%>" />
                    <label for="showName"><%=cm.cmsText("site_name_1")%></label>
                    <%=cm.cmsTitle("site_name_1")%>

                    <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("designation_type_1")%>" />
                    <label for="showDesignationTypes"><%=cm.cmsText("designation_type_1")%></label>
                    <%=cm.cmsTitle("designation_type_1")%>

                    <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("coordinates_1")%>" />
                    <label for="showCoordinates"><%=cm.cmsText("coordinates_1")%></label>
                    <%=cm.cmsTitle("coordinates_1")%>

                    <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("size_1")%>" />
                    <label for="showSize"><%=cm.cmsText("size_1")%></label>
                    <%=cm.cmsTitle("size_1")%>

                    <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("designation_year")%>" />
                    <label for="showDesignationYear"><%=cm.cmsText("designation_year")%></label>
                    <%=cm.cmsTitle("designation_year")%>
                  </div>
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_included")%>
                  <strong>
                    <%=cm.cmsText("longitude")%>
                  </strong>
                  <%=cm.cmsText("between")%>
                  <label for="longMin" class="noshow"><%=cm.cms("sites_coordinates_minlongitude")%></label>
                  <input id="longMin" name="longMin" type="text" title="<%=cm.cms("sites_coordinates_minlongitude")%>" />
                  <%=cm.cmsLabel("sites_coordinates_minlongitude")%>
                  <%=cm.cmsTitle("sites_coordinates_minlongitude")%>

                  <%=cm.cmsText("and")%>
                  <label for="longMax" class="noshow"><%=cm.cms("sites_coordinates_maxlongitude")%></label>
                  <input id="longMax" name="longMax" type="text" title="<%=cm.cms("sites_coordinates_maxlongitude")%>" />&nbsp;
                  <script type="text/javascript" language="Javascript">
                    IE  = (document.all && true);
                    IE5 = (document.getElementById && IE);
                    if (IE5)
                    {
                      document.write('<a href="javascript:chooseCoordinates(\'world\');">');
                      document.write('<img src="images/mini/globe.gif" alt="Open world map in a popup window" title="Open world map" width="16" height="16" border="0" align="middle" />');
                      document.write('</a>');
                    }
                  </script>
                  <!--<a href="javascript:chooseCoordinates('world');"><img src="images/mini/globe.gif" alt="Open world map.<%=Accesibility.getText( "generic.popup" )%>" title="Open world map.<%=Accesibility.getText( "generic.popup" )%>" width="16" height="16" border="0" align="middle" /></a>-->
                  &nbsp;
                  <a href="javascript:openCalculator();"><img src="images/mini/calculator.gif" alt="<%=cm.cms("calculator")%>" title="<%=cm.cms("calculator")%>" width="11" height="15" border="0" align="middle" /></a>
                  <%=cm.cmsTitle("calculator")%>
                  <%=cm.cmsAlt("calculator")%>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
                  <%=cm.cmsTitle("field_included")%>
                  <%=cm.cmsAlt("field_included")%>
                  <strong>
                    <%=cm.cmsText("latitude")%>
                  </strong>
                  <%=cm.cmsText("between")%>
                  <label for="latMin" class="noshow"><%=cm.cms("sites_coordinates_minlatitude")%></label>
                  <input id="latMin" name="latMin" type="text" title="<%=cm.cms("sites_coordinates_minlatitude")%>" />
                  <%=cm.cmsTitle("sites_coordinates_minlatitude")%>
                  <%=cm.cmsLabel("sites_coordinates_minlatitude")%>

                  <%=cm.cmsText("and")%>
                  <label for="latMax" class="noshow"><%=cm.cms("sites_coordinates_maxlatitude")%></label>
                  <input id="latMax" name="latMax" type="text" title="<%=cm.cms("sites_coordinates_maxlatitude")%>" />
                  <%=cm.cmsLabel("sites_coordinates_maxlatitude")%>
                  <%=cm.cmsTitle("sites_coordinates_maxlatitude")%>
                  &nbsp;
                  <script type="text/javascript" language="Javascript">
                    IE  = (document.all && true);
                    IE5 = (document.getElementById && IE);
                    if (IE5)
                    {
                      document.write('<a href="javascript:chooseCoordinates(\'europe\');">');
                      document.write('<img src="images/mini/europe.gif" alt="Open Europe map in a popup window" title="Open Europe map" width="16" height="16" border="0" align="middle" />');
                      document.write('</a>');
                    }
                  </script>
                  <!--<a href="javascript:chooseCoordinates('europe');"><img src="images/mini/europe.gif" alt="Open europe map.<%=Accesibility.getText( "generic.popup" )%>" title="Open europe map.<%=Accesibility.getText( "generic.popup" )%>" width="16" height="16" border="0" align="middle" /></a>-->
                  &nbsp;
                  <a href="javascript:openCalculator();"><img src="images/mini/calculator.gif" alt="<%=cm.cms("calculator")%>" title="<%=cm.cms("calculator")%>" width="11" height="15" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("calculator")%>
                  <%=cm.cmsAlt("calculator")%>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_optional")%>
                  <label for="country">
                    <strong>
                      <%=cm.cmsText("country_name")%>
                    </strong>
                  </label>
                  <input name="country" type="text" id="country" title="<%=cm.cms("country_name")%>" />&nbsp;
                  <%=cm.cmsTitle("country_name")%>
                  <a title="<%=cm.cms("helper")%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  <div class="submit_buttons">
                    <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset")%>" class="standardButton" title="<%=cm.cms("reset_values")%>" />
                    <%=cm.cmsTitle("reset_values")%>
                    <%=cm.cmsInput("reset")%>

                    <input id="submit2" name="submit2" type="submit" class="searchButton" value="<%=cm.cms("search")%>" title="<%=cm.cms("search")%>" />
                    <%=cm.cmsTitle("search")%>
                    <%=cm.cmsInput("search")%>
                  </div>
                  <jsp:include page="sites-search-common.jsp" />
                </form>
          <%
            // Save search criteria
            if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
            {
              // Set Vector for URL string
              Vector show = new Vector();
              show.addElement("showName");
              show.addElement("showSourceDB");
              show.addElement("showDesignationYear");
              show.addElement("showCountry");
              show.addElement("showDesignationTypes");
              show.addElement("showCoordinates");
              show.addElement("showSize");

              String pageName = "sites-coordinates.jsp";
              String pageNameResult = "sites-coordinates-result.jsp?"+Utilities.writeURLCriteriaSave(show);
              // Expand or not save criterias list
              String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
          %>
                <br />
                <%=cm.cmsText("save_your_criteria_1")%>
                <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-coordinates.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                <%=cm.cmsTitle("save")%>
                <%=cm.cmsAlt("save")%>
                <jsp:include page="show-criteria-search.jsp">
                  <jsp:param name="pageName" value="<%=pageName%>" />
                  <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                  <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                </jsp:include>
          <%
            }
          %>

                <%=cm.cmsMsg("sites_coordinates_title")%>
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="sites-coordinates.jsp" />
                </jsp:include>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp" />
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_SERVER" ) )%>
    </div>
  </body>
</html>
