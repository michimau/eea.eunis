<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats country' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.jrfTables.habitats.country.CountryDomain,
                  ro.finsiel.eunis.search.CountryUtil,
                  ro.finsiel.eunis.search.Utilities,
                  ro.finsiel.eunis.search.habitats.country.HabitatCountryUtil,
                  ro.finsiel.eunis.search.species.country.CountryWrapper,
                  ro.finsiel.eunis.search.species.country.RegionWrapper,
                  java.util.Iterator,
                  java.util.Vector" %>
<%
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  int operation = 0;
  if (null != request.getParameter("Add")) {
    operation = 1; // for add operation
  }

  String delete = request.getParameter("deleteField");// We know that if delet >= 0 then operation was to delete
  if (null != request.getParameter("Search")) {
    operation = 2; // for search operation
  }

  // Extract pairs country/region from request
  HabitatCountryUtil requestParser = new HabitatCountryUtil();
  requestParser.set_request(request);
  Vector elements = requestParser.extractCountryParams(request);

  // number of criteria witch must removed
  int delItem = HabitatCountryUtil.checkedStringToInt(delete, -1);
  // remove criteria
  if (delItem >= 0 && delItem < elements.size()) {
    // Remove the specified item
    elements.remove(delItem);
    // Remove always the first element, because on the request, it always comes the first element which is country="", region="".
    elements.remove(0);
  }

  // Get pairs country/region
  requestParser.setCountryRegionPairs(request, elements);
  // Redirect to response page
  if (2 == operation) {
    boolean showLevel = Utilities.checkedStringToBoolean(request.getParameter("showLevel"), false);
    boolean showCode = Utilities.checkedStringToBoolean(request.getParameter("showCode"), false);
    boolean showScientificName = Utilities.checkedStringToBoolean(request.getParameter("showScientificName"), true);
    boolean showVernacularName = Utilities.checkedStringToBoolean(request.getParameter("showVernacularName"), false);
    String url = "habitats-country-result.jsp";
    url += "?database=" + request.getParameter("database");
    url += "&showLevel=" + showLevel;
    url += "&showCode=" + showCode;
    url += "&showScientificName=" + showScientificName;
    url += "&showVernacularName=" + showVernacularName;
    url += requestParser.getCountryRegAsURL();
    response.sendRedirect(url);
    return;
  }

  // habitat database
  int database = Utilities.checkedStringToInt(request.getParameter("database"), CountryDomain.SEARCH_EUNIS.intValue());
%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
<jsp:include page="header-page.jsp" />
<script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=cm.cms("habitats_country_title")%>
</title>
<script language="JavaScript" type="text/javascript">
<!--
  // Error message displayed if not text was entered in text fields.
  var errMessageForm = "<%=cm.cms("habitats_country_02")%>";

  // Array of countries
  var countries = new Array();
  var biogeoregions = new Array();
  <%
  int j = 0;
  CountryUtil countryUtil = new CountryUtil();
  Iterator allCountries = countryUtil.findCountriesForRegion("any");
  while (allCountries.hasNext())
  {
    CountryWrapper country = (CountryWrapper)allCountries.next();
  %>
    countries[<%=j%>] = "<%=country.getName()%>";
  <%
    j++;
  }
  j = 0;
  Iterator allBiogeoregions = CountryUtil.findRegionsFromCountry("any");
  while (allBiogeoregions.hasNext())
  {
    RegionWrapper biogeoregion = (RegionWrapper)allBiogeoregions.next();
  %>
    biogeoregions[<%=j%>] = "<%=biogeoregion.getName()%>";
  <%
    j++;
  }
  %>

  function validateCountryForHabitats(name)
  {
    ret = false;
    for (i = 0; i < countries.length; i++)
    {
      if (countries[i].toLowerCase() == name.toLowerCase())
      {
        return true;
      }
    }
  }
  function validateRegionForHabitats(name)
  {
    ret = false;
    for (i = 0; i < biogeoregions.length; i++)
    {
      if (biogeoregions[i].toLowerCase() == name.toLowerCase())
      {
        return true;
      }
    }
  }

  function openHelper(URL)
  {
    var urlList = '&database=' + document.eunis.database.value;
    for(i=0;i<document.eunis.elements.length;i++) {
       if(document.eunis.elements[i].name.indexOf('region') >= 0)
         urlList += '&' + document.eunis.elements[i].name + "=" + document.eunis.elements[i].value;
       if(document.eunis.elements[i].name.indexOf('country') >= 0)
         urlList += '&' + document.eunis.elements[i].name + "=" + document.eunis.elements[i].value;

    }
    var URL2 = URL + urlList;
    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
  }

  function validateForm()
  {
    document.eunis._0country.value = trim(document.eunis._0country.value);
    document.eunis._0region.value = trim(document.eunis._0region.value);
    var country = document.eunis._0country.value;
    var region = document.eunis._0region.value;
    if (country != "" && !validateCountryForHabitats(country)) // If user entered something in field, validate it
    {
      alert("<%=cm.cms("habitats_country_03")%>");
      return false;
    }
    if (region != "" && !validateRegionForHabitats(region)) // If user entered something in field, validate it
    {
      alert("<%=cm.cms("habitats_country_04")%>");
      return false;
    }
    var operation = document.eunis.operation.value;
    if (country == "" && region == "" && operation != "delete")
    {
      alert(errMessageForm);
      return false;
    }
    return true;
  }
//-->
</script>
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
                  <jsp:param name="location" value="eea#<%=eeaHome%>,home#index.jsp,habitat_types#habitats.jsp,habitats_country_location" />
                  <jsp:param name="helpLink" value="habitats-help.jsp" />
                </jsp:include>
                <table width="100%" border="0" summary="layout">
                <tr>
                <td>
                <h1>
                  <%=cm.cmsText("country_biogeographic_region_location")%>
                </h1>
                <%=cm.cmsText("habitats_country_23")%>
                <br />
                <br />
                <form name="eunis" action="habitats-country.jsp" method="get" onsubmit="javascript: return validateForm();">
                <%-- Used to figure out if used adds or deletes fields --%>
                <input type="hidden" name="operation" value="" />
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <strong>
                        <%=cm.cmsText("search_will_provide")%>
                      </strong>
                    </td>
                  </tr>
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <input type="checkbox" name="showCountry" id="showCountry" value="true" disabled="disabled" checked="checked" />
                      <label for="showCountry"><%=cm.cmsText("country")%></label>
                      &nbsp;
                      <input type="checkbox" name="showRegion" id="showRegion" value="true" disabled="disabled" checked="checked" />
                      <label for="showRegion"><%=cm.cmsText("biogeographic_region")%></label>
                      &nbsp;
                      <input type="checkbox" name="showLevel" id="showLevel" value="true" />
                      <label for="showLevel"><%=cm.cmsText("generic_index_07")%></label>
                      &nbsp;
                      <input type="checkbox" name="showCode" id="showCode" value="true" />
                      <label for="showCode"><%=cm.cmsText("code_column")%></label>
                      &nbsp;
                      <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                      <label for="showScientificName"><%=cm.cmsText("habitat_type_name")%></label>
                      &nbsp;
                      <input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />
                      <label for="showVernacularName"><%=cm.cmsText("english_name")%></label>
                      &nbsp;
                    </td>
                  </tr>
                </table>
                <br />
                <table cellspacing="1" cellpadding="0" border="0" width="100%" align="center">
                <tr>
                  <td valign="bottom" colspan="2" height="27">
                    <input id="deleteField" name="deleteField" type="hidden" value="-1" />
                    <%/// These are the static current inputs%>
                    <%
                      String country0 = "";
                      String region0 = "";
                      if (delItem >= 0) {
                        country0 = request.getParameter("_0country"); // Rember also the primary input fields
                        region0 = request.getParameter("_0region");
                      }
                      if (null == country0) country0 = "";
                      if (null == region0) region0 = "";
                    %>
                    <img title="<%=cm.cms("included_field")%>" alt="<%=cm.cms("included_field")%>" src="images/mini/field_included.gif" style="vertical-align:middle" /><%=cm.cmsTitle("included_field")%>&nbsp;
                    <label for="h_0country"><strong><%=cm.cmsText("country")%></strong></label>
                    <input type="text" name="_0country" id="h_0country" value="<%=country0%>" onblur="return false;" title="<%=cm.cms("country")%>" />&nbsp;
                    <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-country-choice.jsp?field=_0country&amp;whichclicked=0')">
                      <img alt="<%=cm.cms("list_of_values")%>" src="images/helper/helper.gif" width="11" height="18" border="0" style="vertical-align:middle" /></a><%=cm.cmsTitle("list_of_values")%>
                    <label for="h_0region"><strong><%=cm.cmsText("habitats_country_12")%></strong></label>
                    <input type="text" name="_0region" id="h_0region" value="<%=region0%>" onblur="return false;" title="<%=cm.cms("habitats_country_12")%>" />&nbsp;
                    <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-country-choice.jsp?field=_0region&amp;whichclicked=1')">
                      <img src="images/helper/helper.gif" alt="<%=cm.cms("list_of_values")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a><%=cm.cmsTitle("list_of_values")%>
                    <%/// These are the dynamic current inputs
                      if (requestParser.countItems() < 5) {
                    %>
                    <input title="<%=cm.cms("add_criteria")%>" type="submit" name="Add" id="Add" value="<%=cm.cms("add")%>" onclick="document.eunis.operation.value='add'"
                           class="standardButton" />
                    <%=cm.cmsInput("add")%>
                    <%
                      }
                    %>
                    <br />
                    <%
                      // Display existing criteria
                      int maxItems = requestParser.countItems();
                      for (int i = 0; i < maxItems; i++) {
                        String country = requestParser.getCountry(i);
                        String region = requestParser.getRegion(i);
                    %>
                    <img alt="<%=cm.cms("included_field")%>" src="images/mini/field_included.gif" style="vertical-align:middle" /><%=cm.cmsTitle("included_field")%>&nbsp;
                    <label for="h_<%=i + 1%>country"><strong><%=cm.cmsText("country")%></strong></label>
                    <input type="text" name="_<%=i + 1%>country" id="h_<%=i + 1%>country" value="<%=country%>" onfocus="blur()" title="<%=cm.cms("country")%>" />&nbsp;&nbsp;&nbsp;
                    <label for="h_<%=i + 1%>region"><strong><%=cm.cmsText("habitats_country_14")%></strong></label>
                    <input type="text" name="_<%=i + 1%>region" id="h_<%=i + 1%>region" value="<%=region%>" onfocus="blur()" title="<%=cm.cms("habitats_country_14")%>" />&nbsp;&nbsp;&nbsp;
                    <input title="<%=cm.cms("delete_criteria")%>" type="submit" id="h<%=i + 1%>Remove" name="<%=i + 1%>Remove" value="<%=cm.cms("delete_criteria")%>"
                           onclick="document.eunis.deleteField.value='<%=i + 1%>';document.eunis.operation.value='delete'"
                           class="standardButton" />
                    <br />
                    <%
                      }
                    %>
                  </td>
                </tr>
                <tr><td>&nbsp;</td></tr>
                <tr bgcolor="#EEEEEE">
                  <td colspan="2">
                    <%=cm.cmsText("select_database")%>:&nbsp;
                    <input type="radio" name="database" id="database1"
                      <%=(CountryDomain.SEARCH_EUNIS.intValue() == database) ? " checked=\"checked\" " : ""%>
                           value="<%=CountryDomain.SEARCH_EUNIS%>"
                           title="<%=CountryDomain.SEARCH_EUNIS%>" />
                    <label for="database1"><%=cm.cmsText("eunis_habitat_types")%></label>
                    &nbsp;&nbsp;
                    <input type="radio" name="database" id="database2"
                      <%=(CountryDomain.SEARCH_ANNEX_I.intValue() == database) ? " checked=\"checked\" " : ""%>
                           value="<%=CountryDomain.SEARCH_ANNEX_I%>"
                           title="<%=CountryDomain.SEARCH_ANNEX_I%>" />
                    <label for="database2"><%=cm.cmsText("habitat_directive_annex_1")%></label>
                    &nbsp;&nbsp;
                    <input type="radio" name="database" id="database3"
                      <%=(CountryDomain.SEARCH_BOTH.intValue() == database) ? " checked=\"checked\" " : ""%>
                           value="<%=CountryDomain.SEARCH_BOTH%>"
                           title="<%=CountryDomain.SEARCH_BOTH%>" />
                    <label for="database3"><%=cm.cmsText("both")%></label>
                  </td>
                </tr>
                <tr>
                  <td colspan="2">
                    &nbsp;
                  </td>
                </tr>
                <tr>
                  <td width="22%" align="right" colspan="2">
                    <input type="reset" value="<%=cm.cms("reset")%>" name="Reset" id="Reset"
                           onclick="document.eunis.operation.value='search'"
                           onkeypress="document.eunis.operation.value='search'"
                           class="standardButton" title="<%=cm.cms("reset")%>" />
                    <%=cm.cmsTitle("reset")%>
                    <%=cm.cmsInput("reset")%>
                    <input type="submit" name="Search" id="Search" value="<%=cm.cms("search")%>"
                           onclick="document.eunis.operation.value='reset'"
                           onkeypress="document.eunis.operation.value='reset'"
                           class="searchButton" title="<%=cm.cms("search")%>" />
                    <%=cm.cmsTitle("search")%>
                    <%=cm.cmsInput("search")%>
                  </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="2" align="center">
                    <strong>
                      <%=cm.cmsText("habitats_country_21")%>
                    </strong>
                  </td>
                </tr>
                </table>
                </form>
                </td>
                </tr>
                <%
                  // Save search criteria
                  if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT()) {
                %>
                <tr>
                  <td>
                    &nbsp;
                    <script type="text/javascript" language="JavaScript">
                    <!--
                      // values of this constants from specific class Domain
                      var source1='';
                      var source2='';
                      var database1='<%=CountryDomain.SEARCH_EUNIS%>';
                       var database2='<%=CountryDomain.SEARCH_ANNEX_I%>';
                       var database3='<%=CountryDomain.SEARCH_BOTH%>';
                    //-->
                    </script>
                  </td>
                </tr>
                <tr>
                  <td>
                    <script language="JavaScript" src="script/habitats-country-save-criteria.js" type="text/javascript"></script>
                    <%=cm.cmsText("save_your_criteria")%>:
                    <a title="<%=cm.cms("save_criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-country.jsp','7','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_criteria")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                    <%=cm.cmsTitle("save_criteria")%>
                  </td>
                </tr>
                <%
                  // Set Vector for URL string
                  Vector show = new Vector();
                  show.addElement("showLevel");
                  show.addElement("showCode");
                  show.addElement("showScientificName");
                  show.addElement("showVernacularName");
                  show.addElement("showOtherInfo");

                  String pageName = "habitats-country.jsp";
                  String pageNameResult = "habitats-country-result.jsp?" + Utilities.writeURLCriteriaSave(show);
                  // Expand or not save criterias list
                  String expandSearchCriteria = (request.getParameter("expandSearchCriteria") == null ? "no" : request.getParameter("expandSearchCriteria"));
                %>
                <tr>
                  <td>
                    <jsp:include page="show-criteria-search.jsp">
                      <jsp:param name="pageName" value="<%=pageName%>" />
                      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                    </jsp:include>
                  </td>
                </tr>
                <%
                  }
                %>
                <tr>
                  <td>
                    <%=cm.br()%>
                    <%=cm.cmsMsg("habitats_country_title")%>
                    <%=cm.br()%>
                    <%=cm.cmsMsg("habitats_country_02")%>
                    <%=cm.br()%>
                    <%=cm.cmsMsg("habitats_country_03")%>
                    <%=cm.br()%>
                    <%=cm.cmsMsg("habitats_country_04")%>
                    <%=cm.br()%>
                  </td>
                </tr>
                </table>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="habitats-country.jsp" />
              </jsp:include>
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
