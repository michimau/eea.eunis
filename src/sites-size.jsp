<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites size" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.sites.size.SizeSearchCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement cm = SessionManager.getWebContent();
  String relationOpParam = request.getParameter("relationOp");
  int relationOp = Utilities.checkedStringToInt(relationOpParam, -1);
  int criteriaSelected = Utilities.checkedStringToInt(request.getParameter("criteria"), SizeSearchCriteria.CRITERIA_AREA.intValue());
  String country = Utilities.formatString( request.getParameter( "country" ) );
  String yearMin = Utilities.formatString( request.getParameter( "yearMin" ) );
  String yearMax = Utilities.formatString( request.getParameter( "yearMax" ) );
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-size.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-size-save-criteria.js"></script>
    <script language="JavaScript" type="text/JavaScript">
    <!--
        function MM_jumpMenu(targ, selObj, restore){
          var searchType = document.eunis.searchType.options[document.eunis.searchType.selectedIndex].value;
          var country = document.eunis.country.value;
          var yearMin = document.eunis.yearMin.value;
          var yearMax = document.eunis.yearMax.value;
          var url = targ+".location='sites-size.jsp?criteria=" + searchType;
          if ( country != "" )
          {
            url += "&country=" + country;
          }
          if ( yearMin != "" )
          {
            url += "&yearMin=" + yearMin;
          }
          if ( yearMax != "" )
          {
            url += "&yearMax=" + yearMax;
          }
          url += "&" + selObj.options[selObj.selectedIndex].value + "'";
          eval( url );
        }

        function adjustUnits()
        {
          if (document.eunis.searchType.selectedIndex == 0) {
            document.eunis.units.value=" ha";
          }
          if (document.eunis.searchType.selectedIndex == 1) {
            document.eunis.units.value=" m";
          }
        }

      function validateForm()
      {
        // Error messages displayed by alert.
        var errSizeIncorrect = "<%=cm.cms("sites_size_02")%>";
        var errSizeIncorrectBoth = "<%=cm.cms("sites_size_03")%>";
        var errInvalidNr = "<%=cm.cms("sites_size_04")%>";
        var errMinDesignationYear = "<%=cm.cms("sites_size_05")%>";
        var errMaxDesignationYear = "<%=cm.cms("sites_size_06")%>";
        var errInvalidYearCombination = "<%=cm.cms("sites_size_07")%>";

        if (eval(document.eunis.relationOp[document.eunis.relationOp.selectedIndex].value) == <%=Utilities.OPERATOR_BETWEEN%>)
        {
          if (document.eunis.searchStringMin.value == "" || document.eunis.searchStringMax.value == "")
          {
            alert(errSizeIncorrectBoth);
            return false;
          } else {
            if (!isNumber(document.eunis.searchStringMin.value) || !isNumber(document.eunis.searchStringMax.value))
            {
              alert(errInvalidNr);
              return false;
            }
          }
        } else {
          if (document.eunis.searchString.value == "")
          {
            alert(errSizeIncorrect);
            return false;
          } else {
            if (!isNumber(document.eunis.searchString.value))
            {
              alert(errInvalidNr);
              return false;
            }
          }
        }
        // Validate designation years
        if (document.eunis.yearMin.value != "" && !isYear(document.eunis.yearMin.value))
        {
          alert(errMinDesignationYear);
          return false;
        }
        if (document.eunis.yearMax.value != "" && !isYear(document.eunis.yearMax.value))
        {
          alert(errMaxDesignationYear);
          return false;
        }
        // Check if yearMin is smaller than yearMax
        if ((str2Number(document.eunis.yearMin.value)) > (str2Number(document.eunis.yearMax.value)))
        {
          alert(errInvalidYearCombination);
          return false;
        }
         // Check if country is a valid country
       if (!validateCountry("<%=Utilities.getCountryListString()%>",document.eunis.country.value))
       {
         alert(errInvalidCountry);
         return false;
       }
        return checkValidSelection(); // from sites-search-common.jsp
      }
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_size_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,sites_size_location"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" action="sites-size-result.jsp" onsubmit="return validateForm();">
        <input type="hidden" name="showName" value="true" />
        <input type="hidden" name="showDesignationYear" value="true" />
        <input type="hidden" name="showDesignationYear" value="true" />
        <h1>
          <%=cm.cmsText("sites_size_01")%>
        </h1>
        <%=cm.cmsText("sites_size_29")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=cm.cmsText("search_will_provide_following_information")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_size_09")%>" />
          <label for="showSourceDB"><%=cm.cmsText("sites_size_09")%></label>
          <%=cm.cmsTitle("sites_size_09")%>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_size_10")%>" />
          <label for="showCountry"><%=cm.cmsText("sites_size_10")%></label>
          <%=cm.cmsTitle("sites_size_10")%>

          <input id="showName" name="showName" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("sites_size_12")%>" />
          <label for="showName"><%=cm.cmsText("sites_size_12")%></label>
          <%=cm.cmsTitle("sites_size_12")%>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_size_11")%>" />
          <label for="showDesignationTypes"><%=cm.cmsText("sites_size_11")%></label>
          <%=cm.cmsTitle("sites_size_11")%>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_size_13")%>" />
          <label for="showCoordinates"><%=cm.cmsText("sites_size_13")%></label>
          <%=cm.cmsTitle("sites_size_13")%>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_size_14")%>" />
          <label for="showSize"><%=cm.cmsText("sites_size_14")%></label>
          <%=cm.cmsTitle("sites_size_14")%>

          <input id="showLength" name="showLength" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_size_15")%>" />
          <label for="showLength"><%=cm.cmsText("sites_size_15")%></label>
          <%=cm.cmsTitle("sites_size_15")%>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("sites_size_16")%>" />
          <label for="showDesignationYear"><%=cm.cmsText("sites_size_16")%></label>
          <%=cm.cmsTitle("sites_size_16")%>
        </div>
        <img align="middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_mandatory")%>
        <label for="searchType" class="noshow"><%=cm.cms("type_of_search")%></label>
        <select id="searchType" name="searchType" class="inputTextField" onchange="adjustUnits(this)" title="<%=cm.cms("type_of_search")%>">
          <option value="<%=SizeSearchCriteria.SEARCH_AREA%>" <%=(SizeSearchCriteria.SEARCH_AREA.intValue() == criteriaSelected) ? "selected=\"selected\"" : ""%>>
            <%=cm.cms("sites_size_14")%>
          </option>
          <option value="<%=SizeSearchCriteria.SEARCH_LENGTH%>" <%=(SizeSearchCriteria.SEARCH_LENGTH.intValue() == criteriaSelected) ? "selected=\"selected\"" : ""%>>
            <%=cm.cms("sites_size_15")%>
          </option>
        </select>
        <%=cm.cmsLabel("type_of_search")%>
        <%=cm.cmsTitle("type_of_search")%>
        <%=cm.cmsInput("sites_size_14")%>
        <%=cm.cmsInput("sites_size_15")%>
        <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
        <select id="relationOp" name="relationOp" class="inputTextField" onchange="MM_jumpMenu('parent',this,0)" title="<%=cm.cms("operator")%>">
          <option value="relationOp=<%=Utilities.OPERATOR_IS%>" <%if (relationOp == Utilities.OPERATOR_IS.intValue()) {%>selected="selected"<%}%>>
            <%=cm.cms("sites_size_18")%>
          </option>
          <option value="relationOp=<%=Utilities.OPERATOR_BETWEEN%>" <%if (relationOp == Utilities.OPERATOR_BETWEEN.intValue()) {%>selected="selected"<%}%>>
            <%=cm.cms("sites_size_19")%>
          </option>
          <option value="relationOp=<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_GREATER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
            <%=cm.cms("sites_size_20")%>
          </option>
          <option value="relationOp=<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_SMALLER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
            <%=cm.cms("sites_size_21")%>
          </option>
        </select>
        <%=cm.cmsLabel("operator")%>
        <%=cm.cmsTitle("operator")%>
        <%=cm.cmsInput("sites_size_18")%>
        <%=cm.cmsInput("sites_size_19")%>
        <%=cm.cmsInput("sites_size_20")%>
        <%=cm.cmsInput("sites_size_21")%>
<%
  if (relationOp == Utilities.OPERATOR_BETWEEN.intValue())
  {
%>
        <label for="searchStringMin" class="noshow"><%=cm.cms("min_value")%></label>
        <input id="searchStringMin" name="searchStringMin" value="" size="10"  class="inputTextField" title="<%=cm.cms("min_value")%>"/>&nbsp;and&nbsp;
        <%=cm.cmsLabel("min_value")%>
        <%=cm.cmsTitle("min_value")%>
        <label for="searchStringMax" class="noshow"><%=cm.cms("max_value")%></label>
        <input id="searchStringMax" name="searchStringMax" value="" size="10" class="inputTextField" title="<%=cm.cms("max_value")%>" />&nbsp;
        <%=cm.cmsLabel("max_value")%>
        <%=cm.cmsTitle("max_value")%>
        <label for="units1" class="noshow"><%=cm.cms("units")%></label>
        <input id="units1" title="<%=cm.cms("units")%>" name="units" style="border-style : none; background-color : transparent; color : black;" value="<%=(SizeSearchCriteria.SEARCH_LENGTH.intValue() == criteriaSelected) ? "m" : "ha"%>" onfocus="blur()" />
        <%=cm.cmsLabel("units")%>
        <%=cm.cmsTitle("units")%>
<%
  }
  else
  {
%>
        <label for="searchString" class="noshow"><%=cm.cms("search_string")%></label>
        <input id="searchString" name="searchString" value="" size="20" class="inputTextField" title="<%=cm.cms("search_string")%>" />
        <%=cm.cmsLabel("search_string")%>
        <%=cm.cmsTitle("search_string")%>
        <label for="units2" class="noshow"><%=cm.cms("units")%></label>
        <input id="units2" name="units" title="<%=cm.cms("units")%>" style="border-style : none; background-color : transparent; color : black;" value=" <%=(SizeSearchCriteria.SEARCH_LENGTH.intValue() == criteriaSelected) ? "m" : "ha"%>" onfocus="blur()" />
        <%=cm.cmsLabel("units")%>
        <%=cm.cmsTitle("units")%>
<%
  }
%>
        <br />
        <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <label for="country">
          <strong>
            <%=cm.cmsText("sites_size_22")%>
          </strong>
        </label>
        <input id="country" name="country" type="text" size="30" class="inputTextField" title="<%=cm.cms("sites_size_22")%>" value="<%=country%>" />&nbsp;
        <%=cm.cmsLabel("sites_size_22")%>
        <%=cm.cmsTitle("sites_size_22")%>
        <a title="<%=cm.cms("helper")%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
        <br />
        <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <strong>
          <%=cm.cmsText("sites_size_24")%>
        </strong>
        <label for="yearMin" class="noshow"><%=cm.cms("minimum_designation_year")%></label>
        <input id="yearMin" name="yearMin" type="text" maxlength="4" size="4" class="inputTextField" title="<%=cm.cms("minimum_designation_year")%>" value="<%=yearMin%>"/>
        <%=cm.cmsLabel("minimum_designation_year")%>
        <%=cm.cmsTitle("minimum_designation_year")%>

        <%=cm.cmsText("sites_size_25")%>
        <label for="yearMax" class="noshow"><%=cm.cms("maximum_designation_year")%></label>
        <input id="yearMax" name="yearMax" type="text" maxlength="4" size="4" class="inputTextField" title="<%=cm.cms("maximum_designation_year")%>" value="<%=yearMax%>" />
        <div class="submit_buttons">
          <label for="reset" class="noshow"><%=cm.cms("reset_btn_label")%></label>
          <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset_btn_value")%>" class="inputTextField" title="<%=cm.cms("reset_btn_title")%>" />
          <%=cm.cmsLabel("reset_btn_label")%>
          <%=cm.cmsTitle("reset_btn_title")%>
          <%=cm.cmsInput("reset_btn_value")%>

          <label for="submit2" class="noshow"><%=cm.cms("search_btn_label")%></label>
          <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=cm.cms("search_btn_value")%>" title="<%=cm.cms("search_btn_title")%>" />
          <%=cm.cmsLabel("search_btn_label")%>
          <%=cm.cmsTitle("search_btn_title")%>
          <%=cm.cmsInput("search_btn_value")%>
        </div>
        <jsp:include page="sites-search-common.jsp" />
      </form>
      <br />
<%
// Save search criteria
if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
{
%>
      <%=cm.cmsText("sites_size_28")%>
      <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-size.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
      <%=cm.cmsTitle("save")%>
      <%=cm.cmsAlt("save")%>
<%
  // Set Vector for URL string
  Vector show = new Vector();
  show.addElement("showLength");
  show.addElement("showSize");
  show.addElement("showName");
  show.addElement("showSourceDB");
  show.addElement("showDesignationYear");
  show.addElement("showCountry");
  show.addElement("showDesignationTypes");
  show.addElement("showCoordinates");

  String pageName = "sites-size.jsp";
  String pageNameResult = "sites-size-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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

      <%=cm.cmsMsg("sites_size_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_size_02")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_size_03")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_size_04")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_size_05")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_size_06")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_size_07")%>
      <%=cm.br()%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-size.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>