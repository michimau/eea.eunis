<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites by designation types" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,Sites#sites.jsp,sites_designated_codes_location";
%>
    <script language="JavaScript" type="text/javascript" src="script/sites-designated-codes.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-designated-codes-save-criteria.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("site_by_designation_codes")%>
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
                <h1>
                  <%=cm.cmsPhrase("Pick designation types, show sites")%>
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
                      <a href="species-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="sites-designated-codes-result.jsp">
                <input type="hidden" name="source" value="sitedesignatedname" />
                <p>
                <%=cm.cmsPhrase("Search sites by legal instruments<br />(ex.: designations with <strong>forest</strong> in their name, <strong>A</strong> as category, from all source data sets)")%>
                </p>
                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search in")%></legend>
                  <jsp:include page="sites-search-common.jsp" />
                  </fieldset>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search what")%></legend>

                <img style="vertical-align:middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                <label for="relationOp"><%=cm.cmsPhrase("Original/English/French Designation name")%></label>
                <select id="relationOp" name="relationOp" title="<%=cm.cms("operator")%>">
                  <option value="<%=Utilities.OPERATOR_IS%>">
                    <%=cm.cms("is")%>
                  </option>
                  <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                    <%=cm.cms("contains")%>
                  </option>
                  <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
                    <%=cm.cms("starts_with")%>
                  </option>
                </select>
                <%=cm.cmsLabel("operator")%>
                <%=cm.cmsTitle("operator")%>
                <%=cm.cmsInput("is")%>
                <%=cm.cmsInput("contains")%>
                <%=cm.cmsInput("starts_with")%>

                <label for="searchString" class="noshow"><%=cm.cms("designation_name")%></label>
                <input id="searchString" name="searchString" value="" size="32" title="<%=cm.cms("designation_name")%>" />
                <%=cm.cmsLabel("designation_name")%>
                <%=cm.cmsTitle("designation_name")%>
                <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-designations-choice.jsp','yes')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>&nbsp;
                <%=cm.cmsTitle("helper")%>
                <%=cm.cmsAlt("helper")%>
                <br />
                <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                <%=cm.cmsAlt("field_optional")%>
                <label for="category">
                    <%=cm.cmsPhrase("Designation category")%>
                </label>
                <select id="category" name="category" title="Designation category">
                    <option value="A"><%=cm.cms("sites_designations_cata")%></option>
                    <option value="B"><%=cm.cms("sites_designations_catb")%></option>
                    <option value="C"><%=cm.cms("sites_designations_catc")%></option>
                    <option value="any" selected="selected">
                      <%=cm.cms("any")%>
                    </option>
                </select>
                <%=cm.cmsInput("sites_designations_cata")%>
                <%=cm.cmsInput("sites_designations_catb")%>
                <%=cm.cmsInput("sites_designations_catc")%>
                  </fieldset>

                  <fieldset class="large">
                    <legend><%=cm.cmsPhrase("Output fields")%></legend>
                  <strong>
                    <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed), as provided in the original database:")%>
                  </strong>
                  <br />
                  <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set_2")%>" />
                  <label for="showSourceDB"><%=cm.cmsPhrase("Source data set&nbsp;")%></label>
                  <%=cm.cmsTitle("source_data_set_2")%>

                  <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("country_1")%>" />
                  <label for="showCountry"><%=cm.cmsPhrase("Country &nbsp;")%></label>
                  <%=cm.cmsTitle("country_1")%>

                  <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("site_name_1")%>" />
                  <label for="showName"><%=cm.cmsPhrase("Site name &nbsp;")%></label>
                  <%=cm.cmsTitle("site_name_1")%>

                  <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_designated-codes_05")%>" />
                  <label for="showDesignationTypes"><%=cm.cmsPhrase("Designation type category&nbsp;")%></label>
                  <%=cm.cmsTitle("sites_designated-codes_05")%>

                  <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("coordinates_1")%>" />
                  <label for="showCoordinates"><%=cm.cmsPhrase("Coordinates &nbsp;")%></label>
                  <%=cm.cmsTitle("coordinates_1")%>

                  <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("size_1")%>" />
                  <label for="showSize"><%=cm.cmsPhrase("Size &nbsp;")%></label>
                  <%=cm.cmsTitle("size_1")%>

                  <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("designation_year")%>" />
                  <label for="showDesignationYear"><%=cm.cmsPhrase("Designation year")%></label>
                  <%=cm.cmsTitle("designation_year")%>
                </fieldset>

                <div class="submit_buttons">
                  <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset")%>" class="standardButton" title="<%=cm.cms("reset_values")%>" />
                  <%=cm.cmsTitle("reset_values")%>
                  <%=cm.cmsInput("reset")%>

                  <input id="submit2" name="submit2" type="submit" class="submitSearchButton" value="<%=cm.cms("search")%>" title="<%=cm.cms("search")%>" />
                  <%=cm.cmsTitle("search")%>
                  <%=cm.cmsInput("search")%>
                </div>
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
              String pageName = "sites-designated-codes.jsp";
              String pageNameResult = "sites-designated-codes-result.jsp?"+Utilities.writeURLCriteriaSave(show);
              // Expand or not save criterias list
              String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
          %>
              <%=cm.cmsPhrase("Save your criteria:")%>
              <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-designated-codes.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
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

                <%=cm.cmsMsg("site_by_designation_codes")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="sites-designated-codes.jsp" />
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
