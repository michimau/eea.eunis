<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites year" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,designation_year";
  String relationOpParam = request.getParameter("relationOp");
  int relationOp = Utilities.checkedStringToInt(relationOpParam, -1);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-year-save-criteria.js"></script>
    <script language="JavaScript" type="text/JavaScript">
    //<![CDATA[
     var countryListString = "<%=Utilities.getCountryListString()%>";

      function MM_jumpMenu(targ,selObj,restore){ //v3.0
        eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
        if (restore) selObj.selectedIndex=0;
      }
      function validateForm()
      {
<%
  if (relationOp != Utilities.OPERATOR_BETWEEN.intValue())
  {
%>
            var errInvalidYear = "<%=cm.cms("sites_year_02")%>";
            var errDesignationYear = "<%=cm.cms("sites_year_03")%>";

            document.eunis.searchString.value = trim(document.eunis.searchString.value);
            if (document.eunis.searchString.value == "")
            {
              alert(errDesignationYear);
              return false;
            } else {
              if (!isYear(document.eunis.searchString.value))
              {
                alert(errDesignationYear);
                return false;
              }
            }
             // Check if country is a valid country
             if (!validateCountry(countryListString,document.eunis.country.value))
             {
               alert(errInvalidCountry);
               return false;
             }
            return checkValidSelection();
<%
  }
  else
  {
%>
            var errInvalidYear = "<%=cm.cms("sites_year_04")%>";
            var errMinDesignationYear = "<%=cm.cms("enter_min_year_in_yyyy")%>";
            var errMaxDesignationYear = "<%=cm.cms("enter_max_year_in_yyyy")%>";
            var errInvalidYearCombination = "<%=cm.cms("minimum_designation_year_invalid")%>";

            document.eunis.searchStringMin.value = trim(document.eunis.searchStringMin.value);
            document.eunis.searchStringMax.value = trim(document.eunis.searchStringMax.value);
            if (document.eunis.searchStringMin.value == "" || document.eunis.searchStringMax.value == "")
            {
              alert(errInvalidYear);
              return false;
            } else {
              // Check years
              if (!isYear(document.eunis.searchStringMin.value))
              {
                alert(errMinDesignationYear);
                return false;
              }
              if (!isYear(document.eunis.searchStringMax.value))
              {
                alert(errMaxDesignationYear);
                return false;
              }
              if (str2Number(document.eunis.searchStringMin.value) > str2Number(document.eunis.searchStringMax.value))
              {
                alert(errInvalidYearCombination);
                return false;
              }
            }
             // Check if country is a valid country
             if (!validateCountry(countryListString,document.eunis.country.value))
             {
               alert(errInvalidCountry);
               return false;
             }
            return checkValidSelection();
<%
  }
%>
      }
    //]]>
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("site_designation_year")%>
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
                    <%=cm.cmsPhrase("Site designation year")%>
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
                <form name="eunis" method="get" action="sites-year-result.jsp" onsubmit="return validateForm();">
                  <input type="hidden" name="showSiteName" value="true" />
                  <p>
                  <%=cm.cmsPhrase("Search sites by the year of designation<br />(ex. sites with designation year between 1990 and 1995)")%>
                  </p>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search in")%></legend>
                  <jsp:include page="sites-search-common.jsp" />
                  </fieldset>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search what")%></legend>
                  <img style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />

                  <label for="relationOp"><%=cm.cmsPhrase("Year")%></label>
                  <select id="relationOp" name="relationOp" onchange="MM_jumpMenu('parent',this,0)" title="<%=cm.cmsPhrase("Operator")%>">
                    <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_IS%>" <%if (relationOp == Utilities.OPERATOR_IS.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cmsPhrase("is")%>
                    </option>
                    <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_BETWEEN%>" <%if (relationOp == Utilities.OPERATOR_BETWEEN.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cmsPhrase("Between")%>
                    </option>
                    <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_GREATER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cms("sites_year_20")%>
                    </option>
                    <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_SMALLER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cms("sites_year_21")%>
                    </option>
                  </select>
                  <%=cm.cmsInput("sites_year_20")%>
                  <%=cm.cmsInput("sites_year_21")%>
          <%
            if (relationOp == Utilities.OPERATOR_BETWEEN.intValue())
            {
          %>
                  <label for="searchStringMin" class="noshow"><%=cm.cms("minimum_designation_year")%></label>
                  <input id="searchStringMin" name="searchStringMin" title="<%=cm.cms("minimum_designation_year")%>" size="4" maxlength="4" value="" />
                  <%=cm.cmsTitle("minimum_designation_year")%>
                  and
                  <label for="searchStringMax" class="noshow"><%=cm.cms("maximum_designation_year")%></label>
                  <input id="searchStringMax" name="searchStringMax" title="<%=cm.cms("maximum_designation_year")%>" size="4" maxlength="4" value="" />&nbsp;&nbsp;
                  <%=cm.cmsTitle("maximum_designation_year")%>
          <%
            }
            else
            {
          %>
                  <label for="searchString" class="noshow"><%=cm.cms("designation_year")%></label>
                  <input id="searchString" name="searchString" title="<%=cm.cms("designation_year")%>" value="" size="4" maxlength="4" />&nbsp;&nbsp;
                  <%=cm.cmsTitle("designation_year")%>
          <%
            }
          %>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_optional")%>
                  <label for="country">
                      <%=cm.cmsPhrase("Country is")%>
                  </label>
                  <input id="country" name="country" type="text" size="30" title="<%=cm.cms("country_is")%>" />
                  <%=cm.cmsTitle("country_is")%>

                  <a title="<%=cm.cms("helper")%>" href="javascript:choiceprec('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  </fieldset>

                  <fieldset class="large">
                    <legend><%=cm.cmsPhrase("Output fields")%></legend>
                    <strong>
                      <%=cm.cmsPhrase("Search shall provide the following information (checked fields will be displayed)")%>
                    </strong>
                    <br />
                    <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set")%>" />
                    <label for="showSourceDB"><%=cm.cmsPhrase("Source data set")%></label>
                    <%=cm.cmsTitle("source_data_set")%>

                    <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cmsPhrase("Country")%>" />
                    <label for="showCountry"><%=cm.cmsPhrase("Country")%></label>

                    <input id="showName" name="showName" type="checkbox" value="true" disabled="disabled" checked="checked" title="<%=cm.cms("site_name")%>" />
                    <label for="showName"><%=cm.cmsPhrase("Site name")%></label>
                    <%=cm.cmsTitle("site_name")%>

                    <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("designation_type")%>" />
                    <label for="showDesignationTypes"><%=cm.cmsPhrase("Designation type")%></label>
                    <%=cm.cmsTitle("designation_type")%>

                    <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("coordinates")%>" />
                    <label for="showCoordinates"><%=cm.cmsPhrase("Coordinates")%></label>
                    <%=cm.cmsTitle("coordinates")%>

                    <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("size")%>" />
                    <label for="showSize"><%=cm.cmsPhrase("Size")%></label>
                    <%=cm.cmsTitle("size")%>

                    <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("designation_year")%>" />
                    <label for="showDesignationYear"><%=cm.cmsPhrase("Designation year")%></label>
                    <%=cm.cmsTitle("designation_year")%>
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
          %>
                <br />
                <%=cm.cmsPhrase("Save your criteria:")%>
                <a title="<%=cm.cmsPhrase("Save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-year.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cmsPhrase("Save")%>" title="<%=cm.cmsPhrase("Save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
          <%
            // Set Vector for URL string
            Vector show = new Vector();
            show.addElement("showName");
            show.addElement("showSourceDB");
            show.addElement("showDesignationYear");
            show.addElement("showCountry");
            show.addElement("showDesignationTypes");
            show.addElement("showCoordinates");
            show.addElement("showSize");
            String pageName = "sites-year.jsp";
            String pageNameResult = "sites-year-result.jsp?"+Utilities.writeURLCriteriaSave(show);
            // Expand or not save criterias list
            String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
          %>
                <jsp:include page="show-criteria-search.jsp">
                  <jsp:param name="pageName" value="<%=pageName%>" />
                  <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                  <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                </jsp:include>
          <%
            }
          %>

                <%=cm.cmsMsg("site_designation_year")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_year_02")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_year_03")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_year_04")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("enter_min_year_in_yyyy")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("enter_max_year_in_yyyy")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("minimum_designation_year_invalid")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="sites-year.jsp" />
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
