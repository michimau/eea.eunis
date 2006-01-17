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
  // Web content manager used in this page.
  WebContentManagement cm = SessionManager.getWebContent();
  String relationOpParam = request.getParameter("relationOp");
  int relationOp = Utilities.checkedStringToInt(relationOpParam, -1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
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
            var errMinDesignationYear = "<%=cm.cms("sites_year_05")%>";
            var errMaxDesignationYear = "<%=cm.cms("sites_year_06")%>";
            var errInvalidYearCombination = "<%=cm.cms("sites_year_07")%>";

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
      <%=cm.cms("sites_year_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,sites_designationyear_location"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" action="sites-year-result.jsp" onsubmit="return validateForm();">
        <input type="hidden" name="showSiteName" value="true" />
        <h1>
          <%=cm.cmsText("sites_year_01")%>
        </h1>
        <br />
        <%=cm.cmsText("sites_year_27")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=cm.cmsText("search_will_provide_following_information")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_year_09")%>" />
          <label for="showSourceDB"><%=cm.cmsText("sites_year_09")%></label>
          <%=cm.cmsTitle("sites_year_09")%>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_year_10")%>" />
          <label for="showCountry"><%=cm.cmsText("sites_year_10")%></label>
          <%=cm.cmsTitle("sites_year_10")%>

          <input id="showName" name="showName" type="checkbox" value="true" disabled="disabled" checked="checked" title="<%=cm.cms("sites_year_12")%>" />
          <label for="showName"><%=cm.cmsText("sites_year_12")%></label>
          <%=cm.cmsTitle("sites_year_12")%>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_year_11")%>" />
          <label for="showDesignationTypes"><%=cm.cmsText("sites_year_11")%></label>
          <%=cm.cmsTitle("sites_year_11")%>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_year_13")%>" />
          <label for="showCoordinates"><%=cm.cmsText("sites_year_13")%></label>
          <%=cm.cmsTitle("sites_year_13")%>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_year_14")%>" />
          <label for="showSize"><%=cm.cmsText("sites_year_14")%></label>
          <%=cm.cmsTitle("sites_year_14")%>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("sites_year_15")%>" />
          <label for="showDesignationYear"><%=cm.cmsText("sites_year_15")%></label>
          <%=cm.cmsTitle("sites_year_15")%>
        </div>
        <br />
        <img align="middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_mandatory")%>

        <strong>
          <%=cm.cmsText("sites_year_17")%>
        </strong>
        <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
        <select id="relationOp" name="relationOp" class="inputTextField" onchange="MM_jumpMenu('parent',this,0)" title="<%=cm.cms("operator")%>">
          <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_IS%>" <%if (relationOp == Utilities.OPERATOR_IS.intValue()) {%>selected="selected"<%}%>>
            <%=cm.cms("sites_year_18")%>
          </option>
          <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_BETWEEN%>" <%if (relationOp == Utilities.OPERATOR_BETWEEN.intValue()) {%>selected="selected"<%}%>>
            <%=cm.cms("sites_year_19")%>
          </option>
          <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_GREATER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
            <%=cm.cms("sites_year_20")%>
          </option>
          <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_SMALLER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
            <%=cm.cms("sites_year_21")%>
          </option>
        </select>
        <%=cm.cmsLabel("operator")%>
        <%=cm.cmsInput("sites_year_18")%>
        <%=cm.cmsInput("sites_year_19")%>
        <%=cm.cmsInput("sites_year_20")%>
        <%=cm.cmsInput("sites_year_21")%>
<%
  if (relationOp == Utilities.OPERATOR_BETWEEN.intValue())
  {
%>
        <label for="searchStringMin" class="noshow"><%=cm.cms("minimum_designation_year")%></label>
        <input id="searchStringMin" name="searchStringMin" title="<%=cm.cms("minimum_designation_year")%>" size="4" maxlength="4" value="" class="inputTextField" />
        <%=cm.cmsTitle("minimum_designation_year")%>
        and
        <label for="searchStringMax" class="noshow"><%=cm.cms("maximum_designation_year")%></label>
        <input id="searchStringMax" name="searchStringMax" title="<%=cm.cms("maximum_designation_year")%>" size="4" maxlength="4" value="" class="inputTextField" />&nbsp;&nbsp;
        <%=cm.cmsTitle("maximum_designation_year")%>
<%
  }
  else
  {
%>
        <label for="searchString" class="noshow"><%=cm.cms("designation_year")%></label>
        <input id="searchString" name="searchString" title="<%=cm.cms("designation_year")%>" value="" size="4" maxlength="4" class="inputTextField" />&nbsp;&nbsp;
        <%=cm.cmsTitle("designation_year")%>
<%
  }
%>
        <br />
        <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <label for="country">
          <strong>
            <%=cm.cmsText("sites_year_23")%>
          </strong>
        </label>
        <input id="country" name="country" type="text" size="30" class="inputTextField" title="<%=cm.cms("sites_year_23")%>" />
        <%=cm.cmsTitle("sites_year_23")%>

        <a title="<%=cm.cms("helper")%>" href="javascript:choiceprec('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
        <br />
        <br />
        <div class="submit_buttons">
          <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset_btn_value")%>" class="inputTextField" title="<%=cm.cms("reset_btn_title")%>" />
          <%=cm.cmsTitle("reset_btn_title")%>
          <%=cm.cmsInput("reset_btn_value")%>

          <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=cm.cms("search_btn_value")%>" title="<%=cm.cms("search_btn_title")%>" />
          <%=cm.cmsTitle("search_btn_title")%>
          <%=cm.cmsInput("search_btn_value")%>
        </div>
        <jsp:include page="sites-search-common.jsp" />
      </form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
  {
%>
      <br />
      <%=cm.cmsText("sites_year_26")%>
      <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-year.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
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

      <%=cm.cmsMsg("sites_year_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_year_02")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_year_03")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_year_04")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_year_05")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_year_06")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_year_07")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-year.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
