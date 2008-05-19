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
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,size_area_length";
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
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <script language="JavaScript" type="text/javascript" src="script/sites-size.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-size-save-criteria.js"></script>
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
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("site_size")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
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
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </li>
                    <li>
                      <a href="sites-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" action="sites-size-result.jsp" onsubmit="return validateForm();">
                  <input type="hidden" name="showName" value="true" />
                  <input type="hidden" name="showDesignationYear" value="true" />
                  <input type="hidden" name="showDesignationYear" value="true" />
                  <h1>
                    <%=cm.cmsPhrase("Site size (Area/Length)")%>
                  </h1>
                  <p>
                  <%=cm.cmsPhrase("Search sites by size<br />(ex.: size between <strong>23</strong> and <strong>34</strong> ha)")%>
                  </p>
                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search in")%></legend>
                  <jsp:include page="sites-search-common.jsp" />
                  </fieldset>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search what")%></legend>
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_mandatory")%>
                  <label for="searchType" class="noshow"><%=cm.cms("type_of_search")%></label>
                  <select id="searchType" name="searchType" onchange="adjustUnits(this)" title="<%=cm.cms("type_of_search")%>">
                    <option value="<%=SizeSearchCriteria.SEARCH_AREA%>" <%=(SizeSearchCriteria.SEARCH_AREA.intValue() == criteriaSelected) ? "selected=\"selected\"" : ""%>>
                      <%=cm.cms("size")%>
                    </option>
                    <option value="<%=SizeSearchCriteria.SEARCH_LENGTH%>" <%=(SizeSearchCriteria.SEARCH_LENGTH.intValue() == criteriaSelected) ? "selected=\"selected\"" : ""%>>
                      <%=cm.cms("length")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("type_of_search")%>
                  <%=cm.cmsTitle("type_of_search")%>
                  <%=cm.cmsInput("size")%>
                  <%=cm.cmsInput("length")%>
                  <select id="relationOp" name="relationOp" onchange="MM_jumpMenu('parent',this,0)" title="<%=cm.cms("operator")%>">
                    <option value="relationOp=<%=Utilities.OPERATOR_IS%>" <%if (relationOp == Utilities.OPERATOR_IS.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cms("is")%>
                    </option>
                    <option value="relationOp=<%=Utilities.OPERATOR_BETWEEN%>" <%if (relationOp == Utilities.OPERATOR_BETWEEN.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cms("between")%>
                    </option>
                    <option value="relationOp=<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_GREATER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cms("greater_than")%>
                    </option>
                    <option value="relationOp=<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>" <%if (relationOp == Utilities.OPERATOR_SMALLER_OR_EQUAL.intValue()) {%>selected="selected"<%}%>>
                      <%=cm.cms("smaller_than")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("operator")%>
                  <%=cm.cmsTitle("operator")%>
                  <%=cm.cmsInput("is")%>
                  <%=cm.cmsInput("between")%>
                  <%=cm.cmsInput("greater_than")%>
                  <%=cm.cmsInput("smaller_than")%>
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
                  <input id="searchString" name="searchString" value="" size="20" title="<%=cm.cms("search_string")%>" />
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
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_optional")%>
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
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_optional")%>
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
                    <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set")%>" />
                    <label for="showSourceDB"><%=cm.cmsPhrase("Source data set")%></label>
                    <%=cm.cmsTitle("source_data_set")%>

                    <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("country")%>" />
                    <label for="showCountry"><%=cm.cmsPhrase("Country")%></label>
                    <%=cm.cmsTitle("country")%>

                    <input id="showName" name="showName" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("site_name")%>" />
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

                    <input id="showLength" name="showLength" type="checkbox" value="true" checked="checked" title="<%=cm.cms("length")%>" />
                    <label for="showLength"><%=cm.cmsPhrase("Length")%></label>
                    <%=cm.cmsTitle("length")%>

                    <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("designation_year")%>" />
                    <label for="showDesignationYear"><%=cm.cmsPhrase("Designation year")%></label>
                    <%=cm.cmsTitle("designation_year")%>
                  </fieldset>
                  <div class="submit_buttons">
                    <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset")%>" class="standardButton" title="<%=cm.cms("reset_values")%>" />
                    <%=cm.cmsTitle("reset_values")%>
                    <%=cm.cmsInput("reset")%>

                    <input id="submit2" name="submit2" type="submit" class="searchButton" value="<%=cm.cms("search")%>" title="<%=cm.cms("search")%>" />
                    <%=cm.cmsTitle("search")%>
                    <%=cm.cmsInput("search")%>
                  </div>
                </form>
                <br />
          <%
// Save search criteria
          if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
          {
          %>
                <%=cm.cmsPhrase("Save your criteria:")%>
                <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-size.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
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
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="sites-size.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
