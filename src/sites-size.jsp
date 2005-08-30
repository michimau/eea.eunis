<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites size" function - search page.
--%>
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.search.sites.size.SizeSearchCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
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
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
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
        var errSizeIncorrect = "<%=contentManagement.getContent("sites_size_02", false)%>";
        var errSizeIncorrectBoth = "<%=contentManagement.getContent("sites_size_03", false)%>";
        var errInvalidNr = "<%=contentManagement.getContent("sites_size_04", false)%>";
        var errMinDesignationYear = "<%=contentManagement.getContent("sites_size_05", false)%>";
        var errMaxDesignationYear = "<%=contentManagement.getContent("sites_size_06", false)%>";
        var errInvalidYearCombination = "<%=contentManagement.getContent("sites_size_07", false)%>";

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
      <%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_size_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Size (Area/Length)"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" action="sites-size-result.jsp" onsubmit="return validateForm();">
        <input type="hidden" name="showName" value="true" />
        <input type="hidden" name="showDesignationYear" value="true" />
        <input type="hidden" name="showDesignationYear" value="true" />
        <h5>
          <%=contentManagement.getContent("sites_size_01")%>
        </h5>
        <%=contentManagement.getContent("sites_size_29")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=contentManagement.getContent("sites_size_08")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_size_09", false )%>" />
          <label for="showSourceDB"><%=contentManagement.getContent("sites_size_09")%></label>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_size_10", false)%>" />
          <label for="showCountry"><%=contentManagement.getContent("sites_size_10")%></label>

          <input id="showName" name="showName" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_size_12", false)%>" />
          <label for="showName"><%=contentManagement.getContent("sites_size_12")%></label>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_size_11", false)%>" />
          <label for="showDesignationTypes"><%=contentManagement.getContent("sites_size_11")%></label>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_size_13", false)%>" />
          <label for="showCoordinates"><%=contentManagement.getContent("sites_size_13")%></label>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_size_14", false)%>" />
          <label for="showSize"><%=contentManagement.getContent("sites_size_14")%></label>

          <input id="showLength" name="showLength" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_size_15", false)%>" />
          <label for="showLength"><%=contentManagement.getContent("sites_size_15")%></label>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_size_16", false)%>" />
          <label for="showDesignationYear"><%=contentManagement.getContent("sites_size_16")%></label>
        </div>
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <label for="searchType" class="noshow">Type of search</label>
        <select id="searchType" name="searchType" class="inputTextField" onchange="adjustUnits(this)" title="Type of search">
          <option value="<%=SizeSearchCriteria.SEARCH_AREA%>" <%=(SizeSearchCriteria.SEARCH_AREA.intValue() == criteriaSelected) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("sites_size_14", false)%></option>
          <option value="<%=SizeSearchCriteria.SEARCH_LENGTH%>" <%=(SizeSearchCriteria.SEARCH_LENGTH.intValue() == criteriaSelected) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("sites_size_15", false)%></option>
        </select>
        <label for="relationOp" class="noshow">Operator</label>
        <select id="relationOp" name="relationOp" class="inputTextField" onchange="MM_jumpMenu('parent',this,0)" title="Operator">
          <option value="relationOp=<%=Utilities.OPERATOR_IS%>" <%if (relationOp == Utilities.OPERATOR_IS.intValue()) {%>selected="selected"<%}%>><%=contentManagement.getContent("sites_size_18", false)%></option>
          <option value="relationOp=<%=Utilities.OPERATOR_BETWEEN%>" <%if (relationOp == Utilities.OPERATOR_BETWEEN.intValue()) {%>selected="selected"<%}%>><%=contentManagement.getContent("sites_size_19", false)%></option>
          <option value="relationOp=<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_GREATER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>><%=contentManagement.getContent("sites_size_20", false)%></option>
          <option value="relationOp=<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_SMALLER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>><%=contentManagement.getContent("sites_size_21", false)%></option>
        </select>
<%
  if (relationOp == Utilities.OPERATOR_BETWEEN.intValue())
  {
%>
        <label for="searchStringMin" class="noshow">Minimum value</label>
        <input id="searchStringMin" name="searchStringMin" value="" size="10"  class="inputTextField" title="Minimum value"/>&nbsp;and&nbsp;
        <label for="searchStringMax" class="noshow">Maximum value</label>
        <input id="searchStringMax" name="searchStringMax" value="" size="10" class="inputTextField" title="Maximum value" />&nbsp;
        <label for="units1" class="noshow">Measurement units</label>
        <input id="units1" title="Measurement units" name="units" style="border-style : none; background-color : transparent; color : black;" value="<%=(SizeSearchCriteria.SEARCH_LENGTH.intValue() == criteriaSelected) ? "m" : "ha"%>" onfocus="blur()" />
<%
  }
  else
  {
%>
        <label for="searchString" class="noshow">Value</label>
        <input id="searchString" name="searchString" value="" size="20" class="inputTextField" title="Value" />
        <label for="units2" class="noshow">Measurement units</label>
        <input id="units2" name="units" title="Measurement units" style="border-style : none; background-color : transparent; color : black;" value=" <%=(SizeSearchCriteria.SEARCH_LENGTH.intValue() == criteriaSelected) ? "m" : "ha"%>" onfocus="blur()" />
<%
  }
%>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <label for="country">
          <strong>
            <%=contentManagement.getContent("sites_size_22")%>
          </strong>
        </label>
        <input id="country" name="country" type="text" size="30" class="inputTextField" title="Country" value="<%=country%>" />&nbsp;
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_size_24")%>
        </strong>
        <label for="yearMin" class="noshow">Minimum designation year</label>
        <input id="yearMin" name="yearMin" type="text" maxlength="4" size="4" class="inputTextField" title="Minimum designation year" value="<%=yearMin%>"/>
        <%=contentManagement.getContent("sites_size_25")%>
        <label for="yearMax" class="noshow">Maximum designation year</label>
        <input id="yearMax" name="yearMax" type="text" maxlength="4" size="4" class="inputTextField" title="Maximum designation year" value="<%=yearMax%>" />
        <div class="submit_buttons">
          <input id="reset" name="Reset" type="reset" value="<%=contentManagement.getContent("sites_size_26", false )%>" class="inputTextField" title="Reset values" />
          &nbsp;&nbsp;
          <%=contentManagement.writeEditTag( "sites_size_26")%>
          <input id="search" name="Search" type="submit" class="inputTextField" value="<%=contentManagement.getContent("sites_size_27", false)%>" title="Search" />
          <%=contentManagement.writeEditTag( "sites_size_27")%>
        </div>
        <jsp:include page="sites-search-common.jsp" />
      </form>
      <br />
<%
// Save search criteria
if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
{
%>
      <%=contentManagement.getContent("sites_size_28")%>
      <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-size.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
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
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-size.jsp" />
      </jsp:include>
    </div>
  </body>
</html>