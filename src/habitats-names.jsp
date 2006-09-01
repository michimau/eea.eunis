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
  <script language="JavaScript" src="script/habitats-names.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <%
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
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_SERVER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns">
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
                  <jsp:param name="location" value="home#index.jsp,habitat_types#habitats.jsp,names" />
                  <jsp:param name="helpLink" value="habitats-help.jsp" />
                </jsp:include>
                <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="habitats-names-result.jsp">
                <input type="hidden" name="showScientificName" value="true" />
                <input type="hidden" name="deleteIndex" value="-1" />
                <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_EUNIS_CODE%>" />
                <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
                <input type="hidden" name="noSoundex" value="true" />
                <table width="100%" border="0" summary="layout">
                  <tr>
                    <td>
                      <h1>
                        <%=cm.cmsText("names_and_descriptions")%>
                      </h1>
                      <%=cm.cmsText("habitats_names_23")%>
                      <br />
                      <br />
                      <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="layout">
                        <tr>
                          <td bgcolor="#EEEEEE">
                            <strong>
                              <%=cm.cmsText("search_will_provide_2")%>
                            </strong>
                          </td>
                        </tr>
                        <tr>
                          <td bgcolor="#EEEEEE" valign="middle">
                            <input type="checkbox" id="showLevel" name="showLevel" value="true" checked="checked" />
                            <label for="showLevel"><%=cm.cmsText("generic_index_07")%></label>
                            <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
                            <label for="showCode"><%=cm.cmsText("code_column")%></label>
                            <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                            <label for="showScientificName"><%=cm.cmsText("habitat_type_name")%></label>
                            <input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />
                            <label for="showVernacularName"><%=cm.cmsText("habitat_type_english_name")%></label>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="3">
                      <img alt="<%=cm.cms("mandatory_field")%>" src="images/mini/field_mandatory.gif" style="vertical-align:middle" /><%=cm.cmsTitle("mandatory_field")%>&nbsp;
                      <strong>
                        <label for="searchString">
                          <%=cm.cmsText("name_description")%>
                        </label>
                      </strong>
                      <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
                      <select title="<%=cm.cms("operator")%>" name="relationOp" id="relationOp">
                        <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("contains")%></option>
                        <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("is")%></option>
                        <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("starts_with")%></option>
                      </select>
                      <%=cm.cmsLabel("operator")%>
                      <%=cm.cmsInput("contains")%>
                      <%=cm.cmsInput("is")%>
                      <%=cm.cmsInput("starts_with")%>
                      <label for="searchString" class="noshow"><%=cm.cms("filter_value")%></label>
                      <input type="text" size="30" name="searchString" id="searchString" title="<%=cm.cms("filter_value")%>" /><%=cm.cmsTitle("filter_value")%>&nbsp;
                      <a href="javascript:openHelper('habitats-names-choice.jsp')" title="<%=cm.cms("list_of_values")%>"><img alt="<%=cm.cms("list_of_values")%>" title="<%=cm.cms("list_of_values")%>" border="0" src="images/helper/helper.gif" width="11" height="18" style="vertical-align:middle" /></a><%=cm.cmsTitle("list_of_values")%>
                    </td>
                  </tr>
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <%=cm.cmsText("select_database")%>:&nbsp;
                      <input type="radio" id="database1" name="database" value="<%=NamesDomain.SEARCH_EUNIS%>" checked="checked"
                             title="<%=cm.cms("search_eunis")%>" />
                      <%=cm.cmsTitle("search_eunis")%>
                      <label for="database1"><%=cm.cmsText("eunis_habitat_types")%></label>
                      &nbsp;&nbsp;
                      <input type="radio" id="database2" name="database" value="<%=NamesDomain.SEARCH_ANNEX_I%>"
                             title="<%=cm.cms("search_annex1")%>" />
                      <%=cm.cmsTitle("search_annex1")%>
                      <label for="database2"><%=cm.cmsText("habitat_directive_annex")%></label>
                      &nbsp;&nbsp;
                      <input type="radio" id="database3" name="database" value="<%=NamesDomain.SEARCH_BOTH%>"
                             title="<%=cm.cms("search_both")%>" />
                      <%=cm.cmsTitle("search_both")%>
                      <label for="database3"><%=cm.cmsText("both")%></label>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("habitats_names_15")%>:
                      <input type="checkbox" name="useScientific" id="useScientific" value="true" checked="checked" />
                      <label for="useScientific"><%=cm.cmsText("habitats_names_16")%></label>
                      <input type="checkbox" name="useVernacular" id="useVernacular" value="true" checked="checked" />
                      <label for="useVernacular"><%=cm.cmsText("habitats_names_17")%></label>
                      <input type="checkbox" name="useDescription" id="useDescription" value="true" />
                      <label for="useDescription"><%=cm.cmsText("habitats_names_18")%></label>
                      &nbsp;
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      <input title="<%=cm.cms("reset")%>" type="reset" value="<%=cm.cms("reset")%>" name="Reset" id="Reset" class="standardButton" />
                      <%=cm.cmsTitle("reset")%>
                      <%=cm.cmsInput("reset")%>
                      <input title="<%=cm.cms("search")%>" type="submit" value="<%=cm.cms("search")%>" name="action" id="action" class="searchButton" />
                      <%=cm.cmsTitle("search")%>
                      <%=cm.cmsInput("search")%>
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
                    <!--
                    // values of this constants from specific class Domain
                    var source1='';
                    var source2='';
                    var database1='<%=NamesDomain.SEARCH_EUNIS%>';
                    var database2='<%=NamesDomain.SEARCH_ANNEX_I%>';
                    var database3='<%=NamesDomain.SEARCH_BOTH%>';
                    //-->
                    </script>
                    <script language="JavaScript" src="script/habitats-names-save-criteria.js" type="text/javascript"></script>
                    <%=cm.cmsText("save_your_criteria")%>:
                    <a title="<%=cm.cms("save_criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-names.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_criteria")%>" title="Save" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                    <%=cm.cmsTitle("save_criteria")%>
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
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="habitats-names.jsp" />
                </jsp:include>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp" />
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
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_SERVER" ) )%>
    </div>
  </body>
</html>
