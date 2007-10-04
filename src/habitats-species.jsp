<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show habitat types' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.species.SpeciesSearchCriteria,
                 java.util.Vector" %>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.species.SpeciesBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-habitats.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
  function validateForm()
  {
    document.eunis.scientificName.value = trim(document.eunis.scientificName.value);
    var  scientificName = document.eunis.scientificName.value;
    if (scientificName == "")
    {
     alert('Please enter the search criteria.');
     return false;
    }
    return true;
  }

  function openHelper(URL)
  {
    document.eunis.scientificName.value = trim(document.eunis.scientificName.value);
    scientificName = document.eunis.scientificName.value;
    relationOp = document.eunis.relationOp.value;
    var database = document.eunis.database;
    var dat = 0;
    var searchAttribute = document.eunis.searchAttribute.value;
    // If selects attribute scientific name, validate the form for input.
    if ((searchAttribute == <%=SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME%> ||
        searchAttribute == <%=SpeciesSearchCriteria.SEARCH_VERNACULAR%>) &&
        !validateForm()) {
      // Do nothing and return, form validation failed.
    } else {
      if (database != null) {
        if (database[0].checked == true) dat = 0; // EUNIS
        if (database[1].checked == true) dat = 1; // ANNEX I
        if (database[2].checked == true) dat = 2; // BOTH
      }
      URL2 = URL;
      URL2 += '?searchAttribute=' + searchAttribute;
      URL2 += '&scientificName=' + scientificName;
      URL2 += '&relationOp=' + relationOp;
      URL2 += '&database=' + dat;
      eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,resizable=no,location=0,width=400,height=500,left=500,top=0');");
  }
}
//]]>
</script>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,habitats_species_location";
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=cm.cms("pick_species_show_habitat_types")%>
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
                  <jsp:param name="location" value="<%=btrail%>" />
                  <jsp:param name="helpLink" value="species-help.jsp" />
                </jsp:include>
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
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" onsubmit="javascript:return validateForm();" action="habitats-species-result.jsp">
                <input type="hidden" name="showScientificName" value="true" />
                <input type="hidden" name="sort" value="" />
                <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
                <table summary="layout" width="100%" border="0">
                <tr>
                  <td>
                    <table summary="layout" width="100%" border="0" align="center">
                        <tr>
                          <td colspan="3">
                            <h1>
                              <%=cm.cmsText("pick_species_show_habitat_types")%>
                            </h1>
                            <%=cm.cmsText("habitats_species_25")%>
                            <br />
                            <br />
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td bgcolor="#EEEEEE">
                                  <strong>
                                    <%=cm.cmsText("search_will_provide_2")%>
                                  </strong>
                                </td>
                              </tr>
                              <tr>
                                <td bgcolor="#EEEEEE" valign="middle">&nbsp;
                                  <input type="checkbox" name="showLevel" id="showLevel" value="true" checked="checked" />
                                  <label for="showLevel"><%=cm.cmsText("generic_index_07")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
                                  <label for="showCode"><%=cm.cmsText("code_column")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                                  <label for="showScientificName"><%=cm.cmsText("habitat_type_name")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />
                                  <label for="showVernacularName"><%=cm.cmsText("habitat_type_english_name")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showSpecies" id="showSpecies" value="true" checked="checked" disabled="disabled" />
                                  <label for="showSpecies"><%=cm.cmsText("species_scientific_name")%></label>
                                </td>
                              </tr>
                            </table>
                            <br />
                          </td>
                        </tr>
                        <tr>
                          <td colspan="3">
                            <div>
                              <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("mandatory_field")%>" src="images/mini/field_mandatory.gif" /><%=cm.cmsTitle("mandatory_field")%>&nbsp;
                              <label for="searchAttribute" class="noshow"><%=cm.cms("criteria")%></label>
                              <select title="<%=cm.cms("criteria")%>" name="searchAttribute" id="searchAttribute">
                                <option value="<%=SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME%>" selected="selected"><%=cm.cms("species_scientific_name")%></option>
                                <option value="<%=SpeciesSearchCriteria.SEARCH_GROUP%>"><%=cm.cms("species_group")%></option>
                                <option value="<%=SpeciesSearchCriteria.SEARCH_VERNACULAR%>"><%=cm.cms("species_vernacular_name")%></option>
                                <option value="<%=SpeciesSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>"><%=cm.cms("legal_instrument_name")%></option>
                                <option value="<%=SpeciesSearchCriteria.SEARCH_COUNTRY%>"><%=cm.cms("country_name")%></option>
                                <option value="<%=SpeciesSearchCriteria.SEARCH_REGION%>"><%=cm.cms("biogeographic_region_name")%></option>
                              </select>
                              <%=cm.cmsLabel("criteria")%>
                              <%=cm.cmsInput("species_scientific_name")%>
                              <%=cm.cmsInput("species_group")%>
                              <%=cm.cmsInput("species_vernacular_name")%>
                              <%=cm.cmsInput("legal_instrument_name")%>
                              <%=cm.cmsInput("country_name")%>
                              <%=cm.cmsInput("biogeographic_region_name")%>
                              &nbsp;
                              <select title="<%=cm.cms("operator")%>" name="relationOp" id="relationOp">
                                <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("contains")%></option>
                                <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("is")%></option>
                                <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("starts_with")%></option>
                              </select>
                              <%=cm.cmsLabel("operator")%>
                              <%=cm.cmsInput("contains")%>
                              <%=cm.cmsInput("is")%>
                              <%=cm.cmsInput("starts_with")%>
                              <label for="scientificName" class="noshow"><%=cm.cms("filter_value")%></label>
                              <input size="30" alt="<%=cm.cms("filter_value")%>" title="<%=cm.cms("filter_value")%>" id="scientificName" name="scientificName" />
                              <%=cm.cmsTitle("filter_value")%>
                              <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-species-choice.jsp')"><img alt="<%=cm.cms("list_of_values")%>" style="vertical-align:middle" border="0" src="images/helper/helper.gif" width="11" height="18" /></a><%=cm.cmsTitle("list_of_values")%>
                              <br />
                            </div>
                          </td>
                        </tr>
                        <tr>
                          <td bgcolor="#EEEEEE" colspan="3">
                            <%=cm.cmsText("select_database")%>:&nbsp;
                            <input id="database1" alt="<%=cm.cms("search_eunis")%>" title="<%=cm.cms("search_eunis")%>" type="radio" name="database" value="<%=NamesDomain.SEARCH_EUNIS%>" checked="checked" />
                            <%=cm.cmsTitle("search_eunis")%>
                            <label for="database1"><%=cm.cmsText("eunis_habitat_type")%></label>
                            &nbsp;&nbsp;
                            <input id="database2" alt="<%=cm.cms("search_annex1")%>" title="<%=cm.cms("search_annex1")%>" type="radio" name="database" value="<%=NamesDomain.SEARCH_ANNEX_I%>" />
                            <%=cm.cmsTitle("search_annex1")%>
                            <label for="database2"><%=cm.cmsText("habitats_species_20")%></label>
                            &nbsp;&nbsp;
                            <input id="database3" alt="<%=cm.cms("search_both")%>" title="<%=cm.cms("search_both")%>" type="radio" name="database" value="<%=NamesDomain.SEARCH_BOTH%>" />
                            <%=cm.cmsTitle("search_both")%>
                            <label for="database3"><%=cm.cmsText("both")%></label>
                          </td>
                        </tr>
                        <tr>
                          <td width="40%" align="right">
                            <input title="<%=cm.cms("reset")%>" type="reset" value="<%=cm.cms("reset")%>" name="Reset" id="Reset" class="standardButton" />
                            <%=cm.cmsTitle("reset")%>
                            <%=cm.cmsInput("reset")%>
                            <input title="<%=cm.cms("search")%>" type="submit" value="<%=cm.cms("search")%>" name="submit2" id="submit2" class="searchButton" />
                            <%=cm.cmsTitle("search")%>
                            <%=cm.cmsInput("search")%>
                          </td>
                        </tr>
                    </table>
                  </td>
                </tr>
                </table>
                </form>
                <%
                  // Save search criteria
                  if(SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT()) {
                %>
                    &nbsp;
                    <script type="text/javascript" language="JavaScript">
                    //<![CDATA[
                    // values of this constants from specific class Domain
                    var source1='';
                    var source2='';
                    var database1='<%=NamesDomain.SEARCH_EUNIS%>';
                    var database2='<%=NamesDomain.SEARCH_ANNEX_I%>';
                    var database3='<%=NamesDomain.SEARCH_BOTH%>';
                    //]]>
                    </script>
                <br />
                    <script language="JavaScript" src="script/habitats-species-save-criteria.js" type="text/javascript"></script>
                    <%=cm.cmsText("save_your_criteria")%>:
                    <a title="<%=cm.cms("save_criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-species.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_criteria")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                    <%=cm.cmsTitle("save_criteria")%>
                <%
                  // Set Vector for URL string
                  Vector show = new Vector();
                  show.addElement("showLevel");
                  show.addElement("showCode");
                  show.addElement("showScientificName");
                  show.addElement("showVernacularName");
                  String pageName = "habitats-species.jsp";
                  String pageNameResult = "habitats-species-result.jsp?" + Utilities.writeURLCriteriaSave(show);
                  // Expand or not save criterias list
                  String expandSearchCriteria = (request.getParameter("expandSearchCriteria") == null ? "no" : request.getParameter("expandSearchCriteria"));
                %>
                    <jsp:include page="show-criteria-search.jsp">
                      <jsp:param name="pageName" value="<%=pageName%>" />
                      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                    </jsp:include>
                <%}%>
                <%=cm.br()%>
                <%=cm.cmsMsg("pick_species_show_habitat_types")%>
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
                <jsp:param name="page_name" value="habitats-species.jsp" />
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
