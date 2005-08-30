<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show habitat types' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.species.SpeciesSearchCriteria,
                 java.util.Vector" %>
<%@ page contentType="text/html" %>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.species.SpeciesBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/species-habitats.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
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
//-->
</script>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=contentManagement.getContent("habitats_species_title", false)%>
</title>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Pick species show habitat types" />
  <jsp:param name="helpLink" value="species-help.jsp" />
</jsp:include>
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
            <h5>
              <%=contentManagement.getContent("habitats_species_01")%>
            </h5>
            <%=contentManagement.getContent("habitats_species_25")%>
            <br />
            <br />
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td bgcolor="#EEEEEE">
                  <strong>
                    <%=contentManagement.getContent("habitats_species_02")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td bgcolor="#EEEEEE" valign="middle">&nbsp;
                  <input type="checkbox" name="showLevel" id="showLevel" value="true" checked="checked" />
                  <label for="showLevel"><%=contentManagement.getContent("habitats_species_03")%></label>
                  &nbsp;
                  <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
                  <label for="showCode"><%=contentManagement.getContent("habitats_species_04")%></label>
                  &nbsp;
                  <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                  <label for="showScientificName"><%=contentManagement.getContent("habitats_species_05")%></label>
                  &nbsp;
                  <input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />
                  <label for="showVernacularName"><%=contentManagement.getContent("habitats_species_06")%></label>
                  &nbsp;
                  <input type="checkbox" name="showSpecies" id="showSpecies" value="true" checked="checked" disabled="disabled" />
                  <label for="showSpecies"><%=contentManagement.getContent("habitats_species_07")%></label>
                </td>
              </tr>
            </table>
            <br />
          </td>
        </tr>
        <tr>
          <td colspan="3" align="left">
            <div align="left">
              <img width="11" height="12" align="middle" alt="This field is mandatory" src="images/mini/field_mandatory.gif" />&nbsp;
              <label for="searchAttribute" class="noshow">Criteria</label>
              <select title="Criteria" name="searchAttribute" id="searchAttribute" class="inputTextField">
                <option value="<%=SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME%>" selected="selected"><%=contentManagement.getContent("habitats_species_09", false)%></option>
                <option value="<%=SpeciesSearchCriteria.SEARCH_GROUP%>"><%=contentManagement.getContent("habitats_species_10", false)%></option>
                <option value="<%=SpeciesSearchCriteria.SEARCH_VERNACULAR%>"><%=contentManagement.getContent("habitats_species_11", false)%></option>
                <option value="<%=SpeciesSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>"><%=contentManagement.getContent("habitats_species_12", false)%></option>
                <option value="<%=SpeciesSearchCriteria.SEARCH_COUNTRY%>"><%=contentManagement.getContent("habitats_species_13", false)%></option>
                <option value="<%=SpeciesSearchCriteria.SEARCH_REGION%>"><%=contentManagement.getContent("habitats_species_14", false)%></option>
              </select>&nbsp;
              <label for="relationOp" class="noshow">Operator</label>
              <select title="Operator" name="relationOp" id="relationOp" class="inputTextField">
                <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_species_15", false)%></option>
                <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("habitats_species_16", false)%></option>
                <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("habitats_species_17", false)%></option>
              </select>
              <label for="scientificName" class="noshow">Habitat type name</label>
              <input size="30" alt="Habitat type name" title="Habitat type name" id="scientificName" name="scientificName" class="inputTextField" />
              <a title="List of values" href="javascript:openHelper('habitats-species-choice.jsp')"><img alt="List of values" align="middle" border="0" src="images/helper/helper.gif" width="11" height="18" /></a>
              <br />
            </div>
          </td>
        </tr>
        <tr>
          <td align="left" bgcolor="#EEEEEE" colspan="3">
            <%=contentManagement.getContent("habitats_species_18")%>:&nbsp;
            <input id="database1" alt="Search EUNIS" title="Search EUNIS" type="radio" name="database" value="<%=NamesDomain.SEARCH_EUNIS%>" checked="checked" />
            <label for="database1"><%=contentManagement.getContent("habitats_species_19")%></label>
            &nbsp;&nbsp;
            <input id="database2" alt="Search Annex I" title="Search Annex I" type="radio" name="database" value="<%=NamesDomain.SEARCH_ANNEX_I%>" />
            <label for="database2"><%=contentManagement.getContent("habitats_species_20")%></label>
            &nbsp;&nbsp;
            <input id="database3" alt="Search both" title="Search both" type="radio" name="database" value="<%=NamesDomain.SEARCH_BOTH%>" />
            <label for="database3"><%=contentManagement.getContent("habitats_species_21")%></label>
          </td>
        </tr>
        <tr>
          <td width="40%" align="right">
            <label for="Reset" class="noshow">Reset values</label>
            <input title="Reset values" type="reset" value="<%=contentManagement.getContent("habitats_species_22", false )%>" name="Reset" id="Reset" class="inputTextField" />
            <%=contentManagement.writeEditTag("habitats_species_22")%>
            <label for="submit2" class="noshow">Search</label>
            <input title="Search" type="submit" value="<%=contentManagement.getContent("habitats_species_23", false )%>" name="submit2" id="submit2" class="inputTextField" />
            <%=contentManagement.writeEditTag("habitats_species_23")%>
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
    <!--
    // values of this constants from specific class Domain
    var source1='';
    var source2='';
    var database1='<%=NamesDomain.SEARCH_EUNIS%>';
    var database2='<%=NamesDomain.SEARCH_ANNEX_I%>';
    var database3='<%=NamesDomain.SEARCH_BOTH%>';
    //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
<br />
    <script language="JavaScript" src="script/habitats-species-save-criteria.js" type="text/javascript"></script>
    <%=contentManagement.getContent("habitats_species_24")%>:
    <a title="Save criteria" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-species.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');">
      <img alt="Save criteria" border="0" src="images/save.jpg" width="21" height="19" align="middle" />
    </a>
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

<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-species.jsp" />
</jsp:include>
    </div>
  </body>
</html>