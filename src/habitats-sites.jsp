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
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,habitats_sites_location";
%>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
var errInvalidRegion = '<%=cm.cms("biogeographic_region_is_not_valid")%>';

function validateForm()
{
  var errMessageForm = '<%=cm.cms("please_type_letters_from_site_name")%>';
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
  <%=cm.cms("pick_sites_show_habitat_types")%>
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
                  <jsp:param name="helpLink" value="sites-help.jsp"/>
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
                              <%=cm.cmsText("pick_sites_show_habitat_types")%>
                            </h1>
                            <%=cm.cmsText("habitats_sites_17")%>
                            <br />
                            <br />
                            <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td bgcolor="#EEEEEE">
                                  <strong>
                                    <%=cm.cmsText("search_will_provide_1")%>
                                  </strong>
                                </td>
                              </tr>
                              <tr>
                                <td bgcolor="#EEEEEE" valign="middle">
                                  <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
                                  <label for="showCode"><%=cm.cmsText("habitat_type_code")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                                  <label for="showScientificName"><%=cm.cmsText("habitat_type_name")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showScientificName" id="showScientificNameSites" value="true" checked="checked" disabled="disabled" />
                                  <label for="showScientificName"><%=cm.cmsText("sites")%></label>
                                  &nbsp;
                                  <%--<input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />--%>
                                  <%--<label for="showVernacularName"><%=contentManagement.cms("english_name")%></label>--%>
                                  <!--&nbsp;-->
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <div>
                              <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("mandatory_field")%>" src="images/mini/field_mandatory.gif" /><%=cm.cmsTitle("mandatory_field")%>&nbsp;
                              <label for="searchAttribute" class="noshow"><%=cm.cms("criteria")%></label>
                              <select title="<%=cm.cms("criteria")%>" name="searchAttribute" id="searchAttribute">
                                <option value="<%=SitesSearchCriteria.SEARCH_NAME%>" selected="selected"><%=cm.cms("site_name")%></option>
                                <option value="<%=SitesSearchCriteria.SEARCH_SIZE%>"><%=cm.cms("site_size")%></option>
                                <option value="<%=SitesSearchCriteria.SEARCH_COUNTRY%>"><%=cm.cms("country_name")%></option>
                                <option value="<%=SitesSearchCriteria.SEARCH_REGION%>"><%=cm.cms("biogeographic_region_name")%></option>
                              </select>
                              <%=cm.cmsLabel("criteria")%>
                              <%=cm.cmsInput("site_name")%>
                              <%=cm.cmsInput("site_size")%>
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
                              <input title="<%=cm.cms("filter_value")%>" alt="<%=cm.cms("filter_value")%>" size="30" name="scientificName" id="scientificName" />
                              <%=cm.cmsTitle("filter_value")%>
                              <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-sites-choice.jsp')"><img title="<%=cm.cms("list_of_values")%>" border="0" alt="List of values" src="images/helper/helper.gif" width="11" height="18" /></a><%=cm.cmsTitle("list_of_values")%>
                              <br />
                            </div>
                          </td>
                        </tr>
                        <tr>
                          <td width="40%" align="right">
                            <input title="<%=cm.cms("reset")%>" alt="<%=cm.cms("reset")%>" type="reset" value="<%=cm.cms("reset")%>" name="Reset" id="Reset" class="standardButton" />
                            <%=cm.cmsTitle("reset")%>
                            <%=cm.cmsInput("reset")%>
                            <input title="<%=cm.cms("search")%>" alt="<%=cm.cms("search")%>" type="submit" value="<%=cm.cms("search")%>" name="submit2" id="submit2" class="searchButton" />
                            <%=cm.cmsTitle("search")%>
                            <%=cm.cmsInput("search")%>
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
                    <%=cm.cmsText("save_your_criteria")%>:
                    <a title="<%=cm.cms("save_criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-sites.jsp','2','criteria',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_criteria")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
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
                      <%=cm.cmsMsg("pick_sites_show_habitat_types")%>
                      <%=cm.br()%>
                      <%=cm.cmsMsg("biogeographic_region_is_not_valid")%>
                      <%=cm.br()%>
                      <%=cm.cmsMsg("please_type_letters_from_site_name")%>
                      <%=cm.br()%>
                      <%=cm.cmsMsg("enter_size_as_number")%>
                      <%=cm.br()%>
                      <%=cm.cmsMsg("helper_not_applicable")%>
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
                <jsp:param name="page_name" value="habitats-sites.jsp"/>
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
