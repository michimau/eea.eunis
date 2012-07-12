<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Designation types" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,designation_types";
%>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-designated-codes.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-designations-save-criteria.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cmsPhrase("Site designation types")%>
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
                  <h1>
                    <%=cm.cmsPhrase("Designation types")%>
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
                    <li>
                      <a href="sites-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cmsPhrase("Help information")%>"
                             title="<%=cm.cmsPhrase("Help information")%>" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="sites-designations-result.jsp">
                  <input type="hidden" name="source" value="sitedesignatedname" />
                  <p>
                  <%=cm.cmsText("sites_designations_19")%>
                  </p>
                  <fieldset class="large">
                  <legend>Search in</legend>
                  <jsp:include page="sites-search-common.jsp" />
                  </fieldset>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search what")%></legend>
                  <img style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                  <label for="relationOp"><%=cm.cmsPhrase("Original/English/French Designation name")%></label>
                  <select id="relationOp" name="relationOp" title="<%=cm.cmsPhrase("Operator")%>">
                    <option value="<%=Utilities.OPERATOR_IS%>">
                      <%=cm.cmsPhrase("is")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                      <%=cm.cmsPhrase("contains")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
                      <%=cm.cmsPhrase("starts with")%>
                    </option>
                  </select>
                  <label for="searchString" class="noshow"><%=cm.cms("designation_name")%></label>
                  <input id="searchString" name="searchString" value="" size="32" title="<%=cm.cms("designation_name")%>" />
                  <%=cm.cmsLabel("designation_name")%>
                  <%=cm.cmsTitle("designation_name")%>

                  <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-designations-choice.jsp','no')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_optional")%>
                  <label for="category">
                      <%=cm.cmsPhrase("Designation category")%>
                  </label>
                  <select id="category" name="category" title="<%=cm.cms("designation_category")%>">
                    <option value="A"><%=cm.cms("sites_designations_cata")%></option>
                    <option value="B"><%=cm.cms("sites_designations_catb")%></option>
                    <option value="C"><%=cm.cms("sites_designations_catc")%></option>
                    <option value="any" selected="selected">
                      <%=cm.cms("any")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("designation_category")%>
                  <%=cm.cmsTitle("designation_category")%>
                  <%=cm.cmsInput("any")%>
                  <%=cm.cmsInput("sites_designations_cata")%>
                  <%=cm.cmsInput("sites_designations_catb")%>
                  <%=cm.cmsInput("sites_designations_catc")%>
                  </fieldset>

                  <fieldset class="large">
                    <legend><%=cm.cmsPhrase("Output fields")%></legend>
                    <strong>
                      <%=cm.cmsPhrase("Search shall provide the following information (checked fields will be displayed)")%>
                    </strong>
                    <br />
                    <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set_2")%>" />
                    <label for="showSourceDB"><%=cm.cmsPhrase("Source data set")%></label>
                    <%=cm.cmsTitle("source_data_set_2")%>

                    <input id="showIso" name="showIso" type="checkbox" value="true" checked="checked" title="<%=cm.cms("country_1")%>" />
                    <label for="showIso"><%=cm.cmsPhrase("Country")%></label>
                    <%=cm.cmsTitle("country_1")%>

                    <input id="showDesignation" name="showDesignation" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_designations_04")%>" />
                    <label for="showDesignation"><%=cm.cmsPhrase("Designation name")%></label>
                    <%=cm.cmsTitle("sites_designations_04")%>

                    <input id="showDesignationEn" name="showDesignationEn" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_designations_05")%>" />
                    <label for="showDesignationEn"><%=cm.cmsPhrase("English designation name")%></label>
                    <%=cm.cmsTitle("sites_designations_05")%>

                    <input id="showDesignationFr" name="showDesignationFr" type="checkbox" value="true" title="<%=cm.cms("sites_designations_06")%>" />
                    <label for="showDesignationFr"><%=cm.cmsPhrase("French designation name")%></label>
                    <%=cm.cmsTitle("sites_designations_06")%>

                    <input id="showAbreviation" name="showAbreviation" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_designations_08")%>" />
                    <label for="showAbreviation"><%=cm.cmsPhrase("Designation abbreviation ")%></label>
                    <%=cm.cmsTitle("sites_designations_08")%>
                  </fieldset>

                  <div class="submit_buttons">
                    <input id="reset" name="Reset" type="reset" value="<%=cm.cmsPhrase("Reset")%>" class="standardButton" title="<%=cm.cmsPhrase("Reset values")%>" />

                    <input id="submit2" name="submit2" type="submit" class="submitSearchButton" value="<%=cm.cmsPhrase("Search")%>" title="<%=cm.cmsPhrase("Search")%>" />
                  </div>
                </form>
          <%
            // Save search criteria
            if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
            {
              // Set Vector for URL string
              Vector show = new Vector();
              show.addElement("showSource");
              show.addElement("showDesignation");
              show.addElement("showDesignationEn");
              show.addElement("showDesignationFr");
              show.addElement("showSourceDB");
              show.addElement("showIso");
              show.addElement("showAbreviation");
              String pageName = "sites-designations.jsp";
              String pageNameResult = "sites-designations-result.jsp?"+Utilities.writeURLCriteriaSave(show);
              // Expand or not save criterias list
              String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
          %>
                <br />
              <%=cm.cmsPhrase("Save your criteria:")%>
              <a title="<%=cm.cmsPhrase("Save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-designations.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cmsPhrase("Save")%>" title="<%=cm.cmsPhrase("Save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
              <jsp:include page="show-criteria-search.jsp">
                <jsp:param name="pageName" value="<%=pageName%>" />
                <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
              </jsp:include>
          <%
            }
          %>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="sites-designations.jsp" />
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
