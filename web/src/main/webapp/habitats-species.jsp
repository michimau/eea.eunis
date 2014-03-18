<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show habitat types' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
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
<%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,habitats_species_location";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("pick_species_show_habitat_types") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" helpLink="species-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
      <link rel="stylesheet" type="text/css" href="/css/eea_search.css">
      <script language="JavaScript" src="<%=request.getContextPath()%>/script/species-habitats.js" type="text/javascript"></script>
      <script language="JavaScript" src="<%=request.getContextPath()%>/script/save-criteria.js" type="text/javascript"></script>
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
      eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,resizable=no,location=0,width=450,height=500,left=500,top=0');");
  }
}
//]]>
</script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
		    <h1>
		      <%=cm.cmsPhrase("Pick species, show habitat types")%>
		    </h1>
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
                            <%=cm.cmsPhrase("Search for habitat types for which the selected species are found in the database<br />(ex.: scientific name is <strong>Acer pseudoplatanus</strong>)")%>
                            <br />
                            <br />
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td bgcolor="#EEEEEE">
                                  <strong>
                                    <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%>
                                  </strong>
                                </td>
                              </tr>
                              <tr>
                                <td bgcolor="#EEEEEE" valign="middle">&nbsp;
                                  <input type="checkbox" name="showLevel" id="showLevel" value="true" checked="checked" />
                                  <label for="showLevel"><%=cm.cmsPhrase("Level")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
                                  <label for="showCode"><%=cm.cmsPhrase("Code")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                                  <label for="showScientificName"><%=cm.cmsPhrase("Habitat type name")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />
                                  <label for="showVernacularName"><%=cm.cmsPhrase("Habitat type english name")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showSpecies" id="showSpecies" value="true" checked="checked" disabled="disabled" />
                                  <label for="showSpecies"><%=cm.cmsPhrase("Species scientific name")%></label>
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
                              <label for="searchAttribute" class="noshow"><%=cm.cmsPhrase("Criteria")%></label>
                              <select title="<%=cm.cmsPhrase("Criteria")%>" name="searchAttribute" id="searchAttribute">
                                <option value="<%=SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME%>" selected="selected"><%=cm.cms("species_scientific_name")%></option>
                                <option value="<%=SpeciesSearchCriteria.SEARCH_GROUP%>"><%=cm.cms("species_group")%></option>
                                <option value="<%=SpeciesSearchCriteria.SEARCH_VERNACULAR%>"><%=cm.cms("species_vernacular_name")%></option>
                                <option value="<%=SpeciesSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>"><%=cm.cms("legal_instrument_name")%></option>
                                <option value="<%=SpeciesSearchCriteria.SEARCH_COUNTRY%>"><%=cm.cms("country_name")%></option>
                                <option value="<%=SpeciesSearchCriteria.SEARCH_REGION%>"><%=cm.cms("biogeographic_region_name")%></option>
                              </select>
                              <%=cm.cmsInput("species_scientific_name")%>
                              <%=cm.cmsInput("species_group")%>
                              <%=cm.cmsInput("species_vernacular_name")%>
                              <%=cm.cmsInput("legal_instrument_name")%>
                              <%=cm.cmsInput("country_name")%>
                              <%=cm.cmsInput("biogeographic_region_name")%>
                              &nbsp;
                              <select title="<%=cm.cmsPhrase("Operator")%>" name="relationOp" id="relationOp">
                                <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                                <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cmsPhrase("is")%></option>
                                <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cmsPhrase("starts with")%></option>
                              </select>
                              <label for="scientificName" class="noshow"><%=cm.cmsPhrase("Filter value")%></label>
                              <input size="30" alt="<%=cm.cmsPhrase("Filter value")%>" title="<%=cm.cmsPhrase("Filter value")%>" id="scientificName" name="scientificName" />
                              <a title="<%=cm.cmsPhrase("List of values")%>" href="javascript:openHelper('habitats-species-choice.jsp')"><img alt="<%=cm.cmsPhrase("List of values")%>" style="vertical-align:middle" border="0" src="images/helper/helper.gif" width="11" height="18" /></a>
                              <br />
                            </div>
                          </td>
                        </tr>
                        <tr>
                          <td bgcolor="#EEEEEE" colspan="3">
                            <%=cm.cmsPhrase("Select database")%>:&nbsp;
                            <input id="database1" alt="<%=cm.cms("search_eunis")%>" title="<%=cm.cms("search_eunis")%>" type="radio" name="database" value="<%=NamesDomain.SEARCH_EUNIS%>" checked="checked" />
                            <%=cm.cmsTitle("search_eunis")%>
                            <label for="database1"><%=cm.cmsPhrase("EUNIS Habitat type")%></label>
                            &nbsp;&nbsp;
                            <input id="database2" alt="<%=cm.cms("search_annex1")%>" title="<%=cm.cms("search_annex1")%>" type="radio" name="database" value="<%=NamesDomain.SEARCH_ANNEX_I%>" />
                            <%=cm.cmsTitle("search_annex1")%>
                            <label for="database2"><%=cm.cmsPhrase("Habitat ANNEX I directive")%></label>
                            &nbsp;&nbsp;
                            <input id="database3" alt="<%=cm.cms("search_both")%>" title="<%=cm.cms("search_both")%>" type="radio" name="database" value="<%=NamesDomain.SEARCH_BOTH%>" />
                            <%=cm.cmsTitle("search_both")%>
                            <label for="database3"><%=cm.cmsPhrase("Both")%></label>
                          </td>
                        </tr>
                        <tr>
                          <td width="40%" align="right">
                            <input title="<%=cm.cmsPhrase("Reset")%>" type="reset" value="<%=cm.cmsPhrase("Reset")%>" name="Reset" id="Reset" class="standardButton" />
                            <input title="<%=cm.cmsPhrase("Search")%>" type="submit" value="<%=cm.cmsPhrase("Search")%>" name="submit2" id="submit2" class="submitSearchButton" />
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
                    <script language="JavaScript" src="<%=request.getContextPath()%>/script/habitats-species-save-criteria.js" type="text/javascript"></script>
                    <%=cm.cmsPhrase("Save your criteria")%>:
                    <a title="<%=cm.cmsPhrase("Save search criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-species.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cmsPhrase("Save search criteria")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
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
    </stripes:layout-component>
</stripes:layout-render>