<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites year" function - search page.
--%>
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
  String relationOpParam = request.getParameter("relationOp");
  int relationOp = Utilities.checkedStringToInt(relationOpParam, -1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
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
            var errInvalidYear = "<%=contentManagement.getContent("sites_year_02", false )%>";
            var errDesignationYear = "<%=contentManagement.getContent("sites_year_03", false )%>";

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
            var errInvalidYear = "<%=contentManagement.getContent("sites_year_04", false )%>";
            var errMinDesignationYear = "<%=contentManagement.getContent("sites_year_05", false )%>";
            var errMaxDesignationYear = "<%=contentManagement.getContent("sites_year_06", false )%>";
            var errInvalidYearCombination = "<%=contentManagement.getContent("sites_year_07", false )%>";

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
      <%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_year_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Designation year"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" action="sites-year-result.jsp" onsubmit="return validateForm();">
        <input type="hidden" name="showSiteName" value="true" />
        <strong>
          <%=contentManagement.getContent("sites_year_01")%>
        </strong>
        <br />
        <%=contentManagement.getContent("sites_year_27")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=contentManagement.getContent("sites_year_08")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_year_09", false )%>" />
          <label for="showSourceDB"><%=contentManagement.getContent("sites_year_09")%></label>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_year_10", false )%>" />
          <label for="showCountry"><%=contentManagement.getContent("sites_year_10")%></label>

          <input id="showName" name="showName" type="checkbox" value="true" disabled="disabled" checked="checked" title="<%=contentManagement.getContent("sites_year_12", false )%>" />
          <label for="showName"><%=contentManagement.getContent("sites_year_12")%></label>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_year_11", false )%>" />
          <label for="showDesignationTypes"><%=contentManagement.getContent("sites_year_11")%></label>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_year_13", false )%>" />
          <label for="showCoordinates"><%=contentManagement.getContent("sites_year_13")%></label>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_year_14", false )%>" />
          <label for="showSize"><%=contentManagement.getContent("sites_year_14")%></label>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_year_15", false )%>" />
          <label for="showDesignationYear"><%=contentManagement.getContent("sites_year_15")%></label>
        </div>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_year_17")%>
        </strong>
        <label for="relationOp" class="noshow">Operator</label>
        <select id="relationOp" name="relationOp" class="inputTextField" onchange="MM_jumpMenu('parent',this,0)" title="Operator">
          <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_IS%>" <%if (relationOp == Utilities.OPERATOR_IS.intValue()) {%>selected="selected"<%}%>><%=contentManagement.getContent("sites_year_18", false )%></option>
          <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_BETWEEN%>" <%if (relationOp == Utilities.OPERATOR_BETWEEN.intValue()) {%>selected="selected"<%}%>><%=contentManagement.getContent("sites_year_19", false )%></option>
          <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_GREATER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>><%=contentManagement.getContent("sites_year_20", false )%></option>
          <option value="sites-year.jsp?relationOp=<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_SMALLER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>><%=contentManagement.getContent("sites_year_21", false )%></option>
        </select>
<%
  if (relationOp == Utilities.OPERATOR_BETWEEN.intValue())
  {
%>
        <label for="searchStringMin" class="noshow">Minimum designation year</label>
        <input id="searchStringMin" name="searchStringMin" title="Minimum designation year" size="4" maxlength="4" value="" class="inputTextField" />
        and
        <label for="searchStringMax" class="noshow">Maximum designation year</label>
        <input id="searchStringMax" name="searchStringMax" title="Maximum designation year" size="4" maxlength="4" value="" class="inputTextField" />&nbsp;&nbsp;
<%
  }
  else
  {
%>
        <label for="searchString" class="noshow">Designation year</label>
        <input id="searchString" name="searchString" title="Designation year" value="" size="4" maxlength="4" class="inputTextField" />&nbsp;&nbsp;
<%
  }
%>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <label for="country">
          <strong>
            <%=contentManagement.getContent("sites_year_23")%>
          </strong>
        </label>
        <input id="country" name="country" type="text" size="30" class="inputTextField" title="Country" />
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:choiceprec('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <br />
        <br />
        <div class="submit_buttons">
          <label for="reset" class="noshow">Reset values</label>
          <input id="reset" name="Reset" type="reset" value="<%=contentManagement.getContent("sites_year_24", false )%>" class="inputTextField"  title="Reset values" />
          <%=contentManagement.writeEditTag( "sites_year_24" )%>
          <label for="submit2" class="noshow">Search</label>
          <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=contentManagement.getContent("sites_year_25", false)%>" title="Search" />
          <%=contentManagement.writeEditTag( "sites_year_25" )%>
        </div>
        <jsp:include page="sites-search-common.jsp" />
      </form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
  {
%>
      <br />
      <%=contentManagement.getContent("sites_year_26")%>
      <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-year.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
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
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-year.jsp" />
      </jsp:include>
    </div>
  </body>
</html>
