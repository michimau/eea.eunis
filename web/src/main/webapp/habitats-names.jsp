<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats names and descriptions' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.names.NameSortCriteria,
                 java.util.Vector" %>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.names.NameBean" scope="page">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="<%=request.getContextPath()%>/script/habitats-names.js" type="text/javascript"></script>
  <script language="JavaScript" src="<%=request.getContextPath()%>/script/save-criteria.js" type="text/javascript"></script>
  <%
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,names";
    String action = formBean.getAction();
    boolean doAdd = false;
    // Add criteria.
    if (null != action && action.equalsIgnoreCase("search")) {%><jsp:forward page="habitats-names-result.jsp" /><%}
    if (null != action && action.equalsIgnoreCase("add")) {
      // Process the request
      doAdd = true;
    }
    // Delete criteria.
    if (null != action && action.equalsIgnoreCase("delete")) {
      int deleteIndex = Utilities.checkedStringToInt(formBean.getDeleteIndex(), -1);
      formBean.removeCriteriaExtra(deleteIndex);
      doAdd = true;
    }%>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_names_title")%>
  </title>
</head>
  <body>
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
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
                </jsp:include>
                <a name="documentContent"></a>
                      <h1>
                        <%=cm.cmsPhrase("Names and Descriptions")%>
                      </h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cmsPhrase("Print this page")%>"
                            title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cmsPhrase("Toggle full screen mode")%>"
                             title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                    </li>
                    <li>
                      <a href="habitats-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cmsPhrase("Help information")%>"
                             title="<%=cm.cmsPhrase("Help information")%>" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="habitats-names-result.jsp">
                <input type="hidden" name="showScientificName" value="true" />
                <input type="hidden" name="deleteIndex" value="-1" />
                <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_EUNIS_CODE%>" />
                <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
                <input type="hidden" name="noSoundex" value="true" />
                <table width="100%" border="0" summary="layout">
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Search habitat types by name or description<br />(ex.: habitat type name contains <strong>marine</strong>)")%>
                      <br />
                      <br />
                      <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="layout">
                        <tr>
                          <td bgcolor="#EEEEEE">
                            <strong>
                              <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%>
                            </strong>
                          </td>
                        </tr>
                        <tr>
                          <td bgcolor="#EEEEEE" valign="middle">
                            <input type="checkbox" id="showLevel" name="showLevel" value="true" checked="checked" />
                            <label for="showLevel"><%=cm.cmsPhrase("Level")%></label>
                            <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
                            <label for="showCode"><%=cm.cmsPhrase("Code")%></label>
                            <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                            <label for="showScientificName"><%=cm.cmsPhrase("Habitat type name")%></label>
                            <input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />
                            <label for="showVernacularName"><%=cm.cmsPhrase("Habitat type english name")%></label>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="3">
                      <img alt="<%=cm.cms("mandatory_field")%>" src="images/mini/field_mandatory.gif" style="vertical-align:middle" /><%=cm.cmsTitle("mandatory_field")%>&nbsp;
                        <label for="searchString">
                          <%=cm.cmsPhrase("Name(Description)")%>
                        </label>
                      <select title="<%=cm.cmsPhrase("Operator")%>" name="relationOp" id="relationOp">
                        <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                        <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cmsPhrase("is")%></option>
                        <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cmsPhrase("starts with")%></option>
                      </select>
                      <label for="searchString" class="noshow"><%=cm.cmsPhrase("Filter value")%></label>
                      <input type="text" size="30" name="searchString" id="searchString" title="<%=cm.cmsPhrase("Filter value")%>" />&nbsp;
                      <a href="javascript:openHelper('habitats-names-choice.jsp')" title="<%=cm.cmsPhrase("List of values")%>"><img alt="<%=cm.cmsPhrase("List of values")%>" title="<%=cm.cmsPhrase("List of values")%>" border="0" src="images/helper/helper.gif" width="11" height="18" style="vertical-align:middle" /></a>
                    </td>
                  </tr>
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <%=cm.cmsPhrase("Select database")%>:&nbsp;
                      <input type="radio" id="database1" name="database" value="<%=NamesDomain.SEARCH_EUNIS%>" checked="checked"
                             title="<%=cm.cms("search_eunis")%>" />
                      <%=cm.cmsTitle("search_eunis")%>
                      <label for="database1"><%=cm.cmsPhrase("EUNIS Habitat types")%></label>
                      &nbsp;&nbsp;
                      <input type="radio" id="database2" name="database" value="<%=NamesDomain.SEARCH_ANNEX_I%>"
                             title="<%=cm.cms("search_annex1")%>" />
                      <%=cm.cmsTitle("search_annex1")%>
                      <label for="database2"><%=cm.cmsPhrase("Habitats Directive Annex I ")%></label>
                      &nbsp;&nbsp;
                      <input type="radio" id="database3" name="database" value="<%=NamesDomain.SEARCH_BOTH%>"
                             title="<%=cm.cms("search_both")%>" />
                      <%=cm.cmsTitle("search_both")%>
                      <label for="database3"><%=cm.cmsPhrase("Both")%></label>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Search in")%>:
                      <input type="checkbox" name="useScientific" id="useScientific" value="true" checked="checked" />
                      <label for="useScientific"><%=cm.cmsPhrase("Habitat type names")%></label>
                      <input type="checkbox" name="useVernacular" id="useVernacular" value="true" checked="checked" />
                      <label for="useVernacular"><%=cm.cmsPhrase("English names")%></label>
                      <input type="checkbox" name="useDescription" id="useDescription" value="true" />
                      <label for="useDescription"><%=cm.cmsPhrase("Descriptions")%></label>
                      &nbsp;
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      <input title="<%=cm.cmsPhrase("Reset")%>" type="reset" value="<%=cm.cmsPhrase("Reset")%>" name="Reset" id="Reset" class="standardButton" />
                      <input title="<%=cm.cmsPhrase("Search")%>" type="submit" value="<%=cm.cmsPhrase("Search")%>" name="action" id="action" class="submitSearchButton" />
                    </td>
                  </tr>
                </table>
                </form>
                <%
                  // Save search criteria
                  if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT()) {
                %>
                    <br />
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
                    <script language="JavaScript" src="<%=request.getContextPath()%>/script/habitats-names-save-criteria.js" type="text/javascript"></script>
                    <%=cm.cmsPhrase("Save your criteria")%>:
                    <a title="<%=cm.cmsPhrase("Save search criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-names.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cmsPhrase("Save search criteria")%>" title="Save" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                <%
                  // Set Vector for URL string
                  Vector show = new Vector();
                  show.addElement("showLevel");
                  show.addElement("showCode");
                  show.addElement("showScientificName");
                  show.addElement("showVernacularName");
                  String pageName = "habitats-names.jsp";
                  String pageNameResult = "habitats-names-result.jsp?" + Utilities.writeURLCriteriaSave(show);
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
                <%=cm.cmsMsg("habitats_names_title")%>
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
                <jsp:param name="page_name" value="habitats-names.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
