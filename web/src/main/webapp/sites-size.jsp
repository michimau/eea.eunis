<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites size" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
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
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,size_area_length";
  String relationOpParam = request.getParameter("relationOp");
  int relationOp = Utilities.checkedStringToInt(relationOpParam, -1);
  int criteriaSelected = Utilities.checkedStringToInt(request.getParameter("criteria"), SizeSearchCriteria.CRITERIA_AREA.intValue());
  String country = Utilities.formatString( request.getParameter( "country" ) );
  String yearMin = Utilities.formatString( request.getParameter( "yearMin" ) );
  String yearMax = Utilities.formatString( request.getParameter( "yearMax" ) );
  WebContentManagement cm = SessionManager.getWebContent();
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Site size") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" helpLink="sites-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-size.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-size-save-criteria.js"></script>
    <script language="JavaScript" type="text/JavaScript">
    //<![CDATA[
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
        var errMinDesignationYear = "<%=cm.cms("enter_min_year_in_yyyy")%>";
        var errMaxDesignationYear = "<%=cm.cms("enter_max_year_in_yyyy")%>";
        var errInvalidYearCombination = "<%=cm.cms("minimum_designation_year_invalid")%>";

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
      //]]>
    </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
          <h1>
            <%=cm.cmsPhrase("Site size (Area/Length)")%>
          </h1>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" action="sites-size-result.jsp" onsubmit="return validateForm();">
                  <input type="hidden" name="showName" value="true" />
                  <input type="hidden" name="showDesignationYear" value="true" />
                  <input type="hidden" name="showDesignationYear" value="true" />
                  <p>
                  <%=cm.cmsPhrase("Search sites by size<br />(ex.: size between <strong>23</strong> and <strong>34</strong> ha)")%>
                  </p>
                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search in")%></legend>
                  <jsp:include page="sites-search-common.jsp" />
                  </fieldset>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search what")%></legend>
                  <img style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                  <label for="searchType" class="noshow"><%=cm.cmsPhrase("Type of search")%></label>
                  <select id="searchType" name="searchType" onchange="adjustUnits(this)" title="<%=cm.cmsPhrase("Type of search")%>">
                    <option value="<%=SizeSearchCriteria.SEARCH_AREA%>" <%=(SizeSearchCriteria.SEARCH_AREA.intValue() == criteriaSelected) ? "selected=\"selected\"" : ""%>>
                      <%=cm.cmsPhrase("Size")%>
                    </option>
                    <option value="<%=SizeSearchCriteria.SEARCH_LENGTH%>" <%=(SizeSearchCriteria.SEARCH_LENGTH.intValue() == criteriaSelected) ? "selected=\"selected\"" : ""%>>
                      <%=cm.cmsPhrase("Length")%>
                    </option>
                  </select>
                  <select id="relationOp" name="relationOp" onchange="MM_jumpMenu('parent',this,0)" title="<%=cm.cmsPhrase("Operator")%>">
                    <option value="relationOp=<%=Utilities.OPERATOR_IS%>" <%if (relationOp == Utilities.OPERATOR_IS.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cmsPhrase("is")%>
                    </option>
                    <option value="relationOp=<%=Utilities.OPERATOR_BETWEEN%>" <%if (relationOp == Utilities.OPERATOR_BETWEEN.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cmsPhrase("between")%>
                    </option>
                    <option value="relationOp=<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_GREATER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cmsPhrase("greater than")%>
                    </option>
                    <option value="relationOp=<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_SMALLER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cmsPhrase("smaller than")%>
                    </option>
                  </select>
          <%
            if (relationOp == Utilities.OPERATOR_BETWEEN.intValue())
            {
          %>
                  <label for="searchStringMin" class="noshow"><%=cm.cms("min_value")%></label>
                  <input id="searchStringMin" name="searchStringMin" value="" size="10"  title="<%=cm.cms("min_value")%>"/>&nbsp;and&nbsp;
                  <%=cm.cmsLabel("min_value")%>
                  <%=cm.cmsTitle("min_value")%>
                  <label for="searchStringMax" class="noshow"><%=cm.cms("max_value")%></label>
                  <input id="searchStringMax" name="searchStringMax" value="" size="10" title="<%=cm.cms("max_value")%>" />&nbsp;
                  <%=cm.cmsLabel("max_value")%>
                  <%=cm.cmsTitle("max_value")%>
                  <label for="units1" class="noshow"><%=cm.cmsPhrase("Measurement units")%></label>
                  <input id="units1" title="<%=cm.cmsPhrase("Measurement units")%>" name="units" style="border-style : none; background-color : transparent; color : black;" value="<%=(SizeSearchCriteria.SEARCH_LENGTH.intValue() == criteriaSelected) ? "m" : "ha"%>" onfocus="blur()" />
          <%
            }
            else
            {
          %>
                  <label for="searchString" class="noshow"><%=cm.cmsPhrase("Search string")%></label>
                  <input id="searchString" name="searchString" value="" size="20" title="<%=cm.cmsPhrase("Search string")%>" />
                  <label for="units2" class="noshow"><%=cm.cmsPhrase("Measurement units")%></label>
                  <input id="units2" name="units" title="<%=cm.cmsPhrase("Measurement units")%>" style="border-style : none; background-color : transparent; color : black;" value=" <%=(SizeSearchCriteria.SEARCH_LENGTH.intValue() == criteriaSelected) ? "m" : "ha"%>" onfocus="blur()" />
          <%
            }
          %>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is optional")%>" title="<%=cm.cmsPhrase("This field is optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <label for="country">
                      <%=cm.cmsPhrase("Country is")%>
                  </label>
                  <input id="country" name="country" type="text" size="30" title="<%=cm.cms("country_is")%>" value="<%=country%>" />&nbsp;
                  <%=cm.cmsLabel("country_is")%>
                  <%=cm.cmsTitle("country_is")%>
                  <a title="<%=cm.cms("helper")%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is optional")%>" title="<%=cm.cmsPhrase("This field is optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <label for="yearMin"><%=cm.cmsPhrase("Designation year between")%></label>
                  <input id="yearMin" name="yearMin" type="text" maxlength="4" size="4" title="<%=cm.cms("minimum_designation_year")%>" value="<%=yearMin%>"/>
                  <%=cm.cmsLabel("minimum_designation_year")%>
                  <%=cm.cmsTitle("minimum_designation_year")%>

                  <%=cm.cmsPhrase("and")%>
                  <label for="yearMax" class="noshow"><%=cm.cms("maximum_designation_year")%></label>
                  <input id="yearMax" name="yearMax" type="text" maxlength="4" size="4" title="<%=cm.cms("maximum_designation_year")%>" value="<%=yearMax%>" />
                  </fieldset>

                  <fieldset class="large">
                    <legend><%=cm.cmsPhrase("Output fields")%></legend>
                    <strong>
                      <%=cm.cmsPhrase("Search shall provide the following information (checked fields will be displayed)")%>
                    </strong>
                    <br />
                    <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cmsPhrase("Source data set")%>" />
                    <label for="showSourceDB"><%=cm.cmsPhrase("Source data set")%></label>

                    <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cmsPhrase("Country")%>" />
                    <label for="showCountry"><%=cm.cmsPhrase("Country")%></label>

                    <input id="showName" name="showName" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cmsPhrase("Site name")%>" />
                    <label for="showName"><%=cm.cmsPhrase("Site name")%></label>

                    <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cmsPhrase("Designation type")%>" />
                    <label for="showDesignationTypes"><%=cm.cmsPhrase("Designation type")%></label>

                    <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cmsPhrase("Coordinates")%>" />
                    <label for="showCoordinates"><%=cm.cmsPhrase("Coordinates")%></label>

                    <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cmsPhrase("Size")%>" />
                    <label for="showSize"><%=cm.cmsPhrase("Size")%></label>

                    <input id="showLength" name="showLength" type="checkbox" value="true" checked="checked" title="<%=cm.cmsPhrase("Length")%>" />
                    <label for="showLength"><%=cm.cmsPhrase("Length")%></label>

                    <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cmsPhrase("Designation year")%>" />
                    <label for="showDesignationYear"><%=cm.cmsPhrase("Designation year")%></label>
                  </fieldset>
                  <div class="submit_buttons">
                    <input id="reset" name="Reset" type="reset" value="<%=cm.cmsPhrase("Reset")%>" class="standardButton" title="<%=cm.cmsPhrase("Reset values")%>" />

                    <input id="submit2" name="submit2" type="submit" class="submitSearchButton" value="<%=cm.cmsPhrase("Search")%>" title="<%=cm.cmsPhrase("Search")%>" />
                  </div>
                </form>
                <br />
          <%
// Save search criteria
          if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
          {
          %>
                <%=cm.cmsPhrase("Save your criteria:")%>
                <a title="<%=cm.cmsPhrase("Save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-size.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cmsPhrase("Save")%>" title="<%=cm.cmsPhrase("Save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
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

                <%=cm.cmsMsg("site_size")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_size_02")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_size_03")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_size_04")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("enter_min_year_in_yyyy")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("enter_max_year_in_yyyy")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("minimum_designation_year_invalid")%>
                <%=cm.br()%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
