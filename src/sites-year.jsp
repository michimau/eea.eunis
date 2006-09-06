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
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
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
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-year-save-criteria.js"></script>
    <script language="JavaScript" type="text/JavaScript">
    <!--
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
    //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("site_designation_year")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
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
                  <jsp:param name="location" value="home#index.jsp,sites#sites.jsp,designation_year"/>
                  <jsp:param name="helpLink" value="sites-help.jsp"/>
                  <jsp:param name="mapLink" value="show"/>
                </jsp:include>
                <form name="eunis" method="get" action="sites-year-result.jsp" onsubmit="return validateForm();">
                  <input type="hidden" name="showSiteName" value="true" />
                  <h1>
                    <%=cm.cmsText("site_designation_year")%>
                  </h1>
                  <br />
                  <%=cm.cmsText("sites_year_27")%>
                  <br />
                  <br />
                  <div class="grey_rectangle">
                    <strong>
                      <%=cm.cmsText("search_will_provide")%>
                    </strong>
                    <br />
                    <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set")%>" />
                    <label for="showSourceDB"><%=cm.cmsText("source_data_set")%></label>
                    <%=cm.cmsTitle("source_data_set")%>

                    <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("country")%>" />
                    <label for="showCountry"><%=cm.cmsText("country")%></label>
                    <%=cm.cmsTitle("country")%>

                    <input id="showName" name="showName" type="checkbox" value="true" disabled="disabled" checked="checked" title="<%=cm.cms("site_name")%>" />
                    <label for="showName"><%=cm.cmsText("site_name")%></label>
                    <%=cm.cmsTitle("site_name")%>

                    <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("designation_type")%>" />
                    <label for="showDesignationTypes"><%=cm.cmsText("designation_type")%></label>
                    <%=cm.cmsTitle("designation_type")%>

                    <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("coordinates")%>" />
                    <label for="showCoordinates"><%=cm.cmsText("coordinates")%></label>
                    <%=cm.cmsTitle("coordinates")%>

                    <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("size")%>" />
                    <label for="showSize"><%=cm.cmsText("size")%></label>
                    <%=cm.cmsTitle("size")%>

                    <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("designation_year")%>" />
                    <label for="showDesignationYear"><%=cm.cmsText("designation_year")%></label>
                    <%=cm.cmsTitle("designation_year")%>
                  </div>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_mandatory")%>

                  <strong>
                    <%=cm.cmsText("year")%>
                  </strong>
                  <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
                  <select id="relationOp" name="relationOp" onchange="MM_jumpMenu('parent',this,0)" title="<%=cm.cms("operator")%>">
                    <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_IS%>" <%if (relationOp == Utilities.OPERATOR_IS.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cms("is")%>
                    </option>
                    <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_BETWEEN%>" <%if (relationOp == Utilities.OPERATOR_BETWEEN.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cms("between")%>
                    </option>
                    <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_GREATER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cms("sites_year_20")%>
                    </option>
                    <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_SMALLER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cms("sites_year_21")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("operator")%>
                  <%=cm.cmsInput("is")%>
                  <%=cm.cmsInput("between")%>
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
                    <strong>
                      <%=cm.cmsText("country_is")%>
                    </strong>
                  </label>
                  <input id="country" name="country" type="text" size="30" title="<%=cm.cms("country_is")%>" />
                  <%=cm.cmsTitle("country_is")%>

                  <a title="<%=cm.cms("helper")%>" href="javascript:choiceprec('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  <br />
                  <br />
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
          %>
                <br />
                <%=cm.cmsText("save_your_criteria_1")%>
                <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-year.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                <%=cm.cmsTitle("save")%>
                <%=cm.cmsAlt("save")%>
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
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="sites-year.jsp" />
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
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
