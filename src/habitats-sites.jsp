<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show habitats' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesDomain,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.sites.SitesSearchCriteria,
                 ro.finsiel.eunis.search.habitats.sites.SitesSortCriteria,
                 java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
var errInvalidRegion = '<%=cm.cms("biogeographic_region_is_not_valid")%>';

function validateForm()
{
  var errMessageForm = '<%=cm.cms("type_few_letters_from_site")%>';
  var errMessageSize = '<%=cm.cms("enter_size_as_number")%>';
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
           alert('<%=cm.cms("helper_not_applicable")%>');
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
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=cm.cms("habitats_sites_title")%>
</title>
</head>

<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,habitats_sites_location"/>
  <jsp:param name="helpLink" value="sites-help.jsp"/>
</jsp:include>
<form name="criteria" method="get" onsubmit="return validateForm();" action="habitats-sites-result.jsp">
<input type="hidden" name="showScientificName" value="true" />
<input type="hidden" name="sort" value="<%=SitesSortCriteria.SORT_EUNIS_CODE%>" />
<input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
<table width="100%" border="0">
<tr>
  <td>
    <table summary="layout" width="100%" border="0">
        <tr>
          <td>
            <h1>
              <%=cm.cmsText("habitats_sites_01")%>
            </h1>
            <%=cm.cmsText("habitats_sites_17")%>
            <br />
            <br />
            <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td bgcolor="#EEEEEE">
                  <strong>
                    <%=cm.cmsText("habitats_sites_02")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td bgcolor="#EEEEEE" valign="middle">
                  <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
                  <label for="showCode"><%=cm.cmsText("habitats_sites_03")%></label>
                  &nbsp;
                  <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                  <label for="showScientificName"><%=cm.cmsText("habitats_sites_04")%></label>
                  &nbsp;
                  <input type="checkbox" name="showScientificName" id="showScientificNameSites" value="true" checked="checked" disabled="disabled" />
                  <label for="showScientificName"><%=cm.cmsText("habitats_sites_sites")%></label>
                  &nbsp;
                  <%--<input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />--%>
                  <%--<label for="showVernacularName"><%=contentManagement.cms("habitats_sites_05")%></label>--%>
                  <!--&nbsp;-->
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <div>
              <img width="11" height="12" align="middle" alt="<%=cm.cms("mandatory_field")%>" src="images/mini/field_mandatory.gif" /><%=cm.cmsTitle("mandatory_field")%>&nbsp;
              <label for="searchAttribute" class="noshow"><%=cm.cms("criteria")%></label>
              <select title="<%=cm.cms("criteria")%>" name="searchAttribute" id="searchAttribute" class="inputTextField">
                <option value="<%=SitesSearchCriteria.SEARCH_NAME%>" selected="selected"><%=cm.cms("habitats_sites_07")%></option>
                <option value="<%=SitesSearchCriteria.SEARCH_SIZE%>"><%=cm.cms("habitats_sites_08")%></option>
                <option value="<%=SitesSearchCriteria.SEARCH_COUNTRY%>"><%=cm.cms("habitats_sites_09")%></option>
                <option value="<%=SitesSearchCriteria.SEARCH_REGION%>"><%=cm.cms("habitats_sites_10")%></option>
              </select>
              <%=cm.cmsLabel("criteria")%>
              <%=cm.cmsInput("habitats_sites_07")%>
              <%=cm.cmsInput("habitats_sites_08")%>
              <%=cm.cmsInput("habitats_sites_09")%>
              <%=cm.cmsInput("habitats_sites_10")%>
              &nbsp;
              <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
              <select title="<%=cm.cms("operator")%>" name="relationOp" id="relationOp" class="inputTextField">
                <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("habitats_sites_11")%></option>
                <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("habitats_sites_12")%></option>
                <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("habitats_sites_13")%></option>
              </select>
              <%=cm.cmsLabel("operator")%>
              <%=cm.cmsInput("habitats_sites_11")%>
              <%=cm.cmsInput("habitats_sites_12")%>
              <%=cm.cmsInput("habitats_sites_13")%>
              <label for="scientificName" class="noshow"><%=cm.cms("search_value")%></label>
              <input title="<%=cm.cms("search_value")%>" alt="<%=cm.cms("search_value")%>" size="30" name="scientificName" id="scientificName" class="inputTextField" />
              <%=cm.cmsTitle("search_value")%>
              <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-sites-choice.jsp')"><img title="<%=cm.cms("list_of_values")%>" border="0" alt="List of values" src="images/helper/helper.gif" width="11" height="18" /></a><%=cm.cmsTitle("list_of_values")%>
              <br />
            </div>
          </td>
        </tr>
        <tr>
          <td width="40%" align="right">
            <input title="<%=cm.cms("reset_btn")%>" alt="<%=cm.cms("reset_btn")%>" type="reset" value="<%=cm.cms("habitats_sites_14")%>" name="Reset" id="Reset" class="inputTextField" />
            <%=cm.cmsTitle("reset_btn")%>
            <%=cm.cmsInput("habitats_sites_14")%>
            <input title="<%=cm.cms("search_btn")%>" alt="<%=cm.cms("search_btn")%>" type="submit" value="<%=cm.cms("habitats_sites_15")%>" name="submit2" id="submit2" class="inputTextField" />
            <%=cm.cmsTitle("search_btn")%>
            <%=cm.cmsInput("habitats_sites_15")%>
          </td>
        </tr>
        <tr>
          <td>
            <jsp:include page="sites-databases.jsp"/>
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
  </td>
</tr>
<tr>
  <td>
    <script language="JavaScript" src="script/habitats-sites-save-criteria.js" type="text/javascript"></script>
    <%=cm.cmsText("habitats_sites_16")%>:
    <a title="<%=cm.cms("save_criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-sites.jsp','2','criteria',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_criteria")%>" border="0" src="images/save.jpg" width="21" height="19" align="middle" /></a>
    <%=cm.cmsTitle("save_criteria")%>
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
      <%=cm.br()%>
      <%=cm.cmsMsg("habitats_sites_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("biogeographic_region_is_not_valid")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("type_few_letters_from_site")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("enter_size_as_number")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("helper_not_applicable")%>
      <%=cm.br()%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="habitats-sites.jsp"/>
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>