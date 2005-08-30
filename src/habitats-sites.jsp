<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show habitats' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesDomain,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.sites.SitesSearchCriteria,
                 ro.finsiel.eunis.search.habitats.sites.SitesSortCriteria,
                 java.util.Vector" %>
<%@page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
var errInvalidRegion = 'Biogeographic regions is not valid, please use helper to find biogeographic regions';

function validateForm()
{
  var errMessageForm = "Please type a few letters from site name.";
  var errMessageSize = "Please enter size as a numerical value.";
  var  scientificName;
  var  database;

  document.criteria.scientificName.value = trim(document.criteria.scientificName.value);
  scientificName = document.criteria.scientificName.value;
  var criteriaType = document.getElementById("searchAttribute").options[document.getElementById("searchAttribute").selectedIndex].value;
  var fscientificName = parseFloat(scientificName);

  if (scientificName == "")
  {
    alert(errMessageForm);
    return false;
  }

  if ((criteriaType == <%=SitesSearchCriteria.SEARCH_SIZE%>) && isNaN(fscientificName))
  {
      alert(errMessageSize);
      return false;
  }

  if(criteriaType == <%=SitesSearchCriteria.SEARCH_COUNTRY%>)
  {
    // Check if country is a valid country
   if (!validateCountry('<%=Utilities.getCountryListString()%>',scientificName))
   {
     alert(errInvalidCountry);
     return false;
   }
  }

  if(criteriaType == <%=SitesSearchCriteria.SEARCH_REGION%>)
  {
  // Check if region is a valid region
   if (!validateRegion('<%=Utilities.getRegionListString()%>',scientificName))
   {
     alert(errInvalidRegion);
     return false;
   }
  }

  return checkValidSelection();// From sites-databases.jsp
}

  function openHelper(URL)
  {
    document.criteria.scientificName.value = trim(document.criteria.scientificName.value);
    var scientificName = document.criteria.scientificName.value;
    var relationOp = document.criteria.relationOp.value;
    var searchAttribute = document.criteria.searchAttribute.value;
    var database = document.criteria.database;
    // If selects attribute scientific name, validate the form for input.
    if (searchAttribute == <%=SitesSearchCriteria.SEARCH_NAME%> && !validateForm())
    {
      // Do nothing and return, form validation failed.
    } else {
      if (searchAttribute == <%=SitesSearchCriteria.SEARCH_SIZE%> ||
           searchAttribute == <%=SitesSearchCriteria.SEARCH_LENGTH%>) {
           // Do nothing, no popup for size or length
           alert("Helper not applicable for this criteria.");
      } else {
        var habitatDB=<%=HabitatsSitesDomain.SEARCH_EUNIS%>;
        if (database != null) {
              if (database[0].checked == true) habitatDB=<%=HabitatsSitesDomain.SEARCH_EUNIS%>
              if (database[1].checked == true) habitatDB=<%=HabitatsSitesDomain.SEARCH_ANNEX_I%>
              if (database[2].checked == true) habitatDB=<%=HabitatsSitesDomain.SEARCH_BOTH%>
        }
        URL2 = URL;
        URL2 += '?searchAttribute=' + searchAttribute;
        URL2 += '&scientificName=' + scientificName;
        URL2 += '&relationOp=' + relationOp;
        URL2 += '&database=' + habitatDB;
        eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,resizable=no,location=0,width=400,height=500,left=500,top=0');");
      }
    }
  }

//-->
</script>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=contentManagement.getContent("habitats_sites_title", false)%>
</title>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Pick sites show habitat types"/>
  <jsp:param name="helpLink" value="sites-help.jsp"/>
</jsp:include>
<form name="criteria" method="get" onsubmit="return validateForm();" action="habitats-sites-result.jsp">
<input type="hidden" name="showScientificName" value="true" />
<input type="hidden" name="sort" value="<%=SitesSortCriteria.SORT_EUNIS_CODE%>" />
<input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
<table width="100%" border="0">
<tr>
  <td>
    <table width="100%" border="0" align="center">
        <tr>
          <td>
            <h5>
              <%=contentManagement.getContent("habitats_sites_01")%>
            </h5>
            <%=contentManagement.getContent("habitats_sites_17")%>
            <br />
            <br />
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td bgcolor="#EEEEEE">
                  <strong>
                    <%=contentManagement.getContent("habitats_sites_02")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td bgcolor="#EEEEEE" valign="middle">
                  <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
                  <label for="showCode"><%=contentManagement.getContent("habitats_sites_03")%></label>
                  &nbsp;
                  <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                  <label for="showScientificName"><%=contentManagement.getContent("habitats_sites_04")%></label>
                  &nbsp;
                  <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                  <label for="showScientificName">Sites</label>
                  &nbsp;
                  <%--<input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />--%>
                  <%--<label for="showVernacularName"><%=contentManagement.getContent("habitats_sites_05")%></label>--%>
                  <!--&nbsp;-->
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td align="right">
            <div align="left">
              <img width="11" height="12" align="middle" alt="This field is mandatory" src="images/mini/field_mandatory.gif" />&nbsp;
              <label for="searchAttribute" class="noshow">Criteria</label>
              <select title="Criteria" name="searchAttribute" id="searchAttribute" class="inputTextField">
                <option value="<%=SitesSearchCriteria.SEARCH_NAME%>" selected="selected"><%=contentManagement.getContent("habitats_sites_07", false)%></option>
                <option value="<%=SitesSearchCriteria.SEARCH_SIZE%>"><%=contentManagement.getContent("habitats_sites_08", false)%></option>
                <option value="<%=SitesSearchCriteria.SEARCH_COUNTRY%>"><%=contentManagement.getContent("habitats_sites_09", false)%></option>
                <option value="<%=SitesSearchCriteria.SEARCH_REGION%>"><%=contentManagement.getContent("habitats_sites_10", false)%></option>
              </select>&nbsp;
              <label for="relationOp" class="noshow">Operator</label>
              <select title="Operator" name="relationOp" id="relationOp" class="inputTextField">
                <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_sites_11", false)%></option>
                <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("habitats_sites_12", false)%></option>
                <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("habitats_sites_13", false)%></option>
              </select>
              <label for="scientificName" class="noshow">Search value</label>
              <input title="Search value" alt="Search value" size="30" name="scientificName" id="scientificName" class="inputTextField" />
              <a title="List of values" href="javascript:openHelper('habitats-sites-choice.jsp')"><img title="List of values" border="0" alt="List of values" src="images/helper/helper.gif" width="11" height="18" /></a>
              <br />
            </div>
          </td>
        </tr>
        <tr>
          <td width="40%" align="right">
            <label for="Reset" class="noshow">Reset values</label>
            <input title="Reset values" alt="Reset values" type="reset" value="<%=contentManagement.getContent("habitats_sites_14", false )%>" name="Reset" id="Reset" class="inputTextField" />
            <%=contentManagement.writeEditTag("habitats_sites_14")%>
            <label for="submit2" class="noshow">Search</label>
            <input title="Search" alt="Search" type="submit" value="<%=contentManagement.getContent("habitats_sites_15", false )%>" name="submit2" id="submit2" class="inputTextField" />
            <%=contentManagement.writeEditTag("habitats_sites_15")%>
          </td>
        </tr>
        <tr>
          <td align="left">
            <jsp:include page="sites-databases.jsp"/>
            <%--              Select habitat type classification: &nbsp;--%>
            <%--              <input type="radio" name="database" value="<%=HabitatsSitesDomain.SEARCH_EUNIS%>' checked>EUNIS habitat type&nbsp;&nbsp;--%>
            <%--              <input type="radio" name="database" value="<%=HabitatsSitesDomain.SEARCH_ANNEX_I%>' disabled>Habitat ANNEX I directive&nbsp;--%>
            <%--              <input type="radio" name="database" value="<%=HabitatsSitesDomain.SEARCH_BOTH%>' disabled>Both--%>
          </td>
        </tr>
    </table>
  </td>
</tr>
<%
  // Save search criteria
  if(SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT()) {
%>
<tr>
  <td>
    &nbsp;
    <script type="text/javascript" language="JavaScript">
    <!--
     // values of source and database constants from specific class Domain(here are all '')
     var source1='';
     var source2='';
     var database1='';
     var database2='';
     var database3='';
    //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
  </td>
</tr>
<tr>
  <td>
    <script language="JavaScript" src="script/habitats-sites-save-criteria.js" type="text/javascript"></script>
    <%=contentManagement.getContent("habitats_sites_16")%>:
    <a title="Save criteria" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-sites.jsp','2','criteria',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');">
      <img alt="Save criteria" border="0" src="images/save.jpg" width="21" height="19" align="middle" />
    </a>
  </td>
</tr>
<tr>
  <td>
<%
    // Set Vector for URL string
    Vector show = new Vector();
    show.addElement("showLevel");
    show.addElement("showCode");
    show.addElement("showScientificName");
    show.addElement("showVernacularName");
    show.addElement("showOtherInfo");

    String pageName = "habitats-sites.jsp";
    String pageNameResult = "habitats-sites-result.jsp?" + Utilities.writeURLCriteriaSave(show);
    // Expand or not save criterias list
    String expandSearchCriteria = (request.getParameter("expandSearchCriteria") == null ? "no" : request.getParameter("expandSearchCriteria"));
%>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
  </td>
</tr>
<%}%>
</table>
</form>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-sites.jsp"/>
</jsp:include>
    </div>
  </body>
</html>