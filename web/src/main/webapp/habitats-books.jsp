<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitats, show references' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksDomain,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.references.ReferencesSearchCriteria,
                 java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="<%=request.getContextPath()%>/script/habitats-books.js" type="text/javascript"></script>
  <script language="JavaScript" src="<%=request.getContextPath()%>/script/save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" src="<%=request.getContextPath()%>/script/overlib.js" type="text/javascript"></script>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,pick_habitat_type_show_references";
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_books_title")%>
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
                              <%=cm.cmsPhrase("Pick habitat type, show references")%>
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
                <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
                <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="habitats-books-result.jsp">
                <input type="hidden" name="typeForm" value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC%>" />
                <table summary="Main content" width="100%" border="0">
                <tr>
                  <td>
                    <table width="100%" border="0" summary="layout">
                        <tr>
                          <td>
                            <%=cm.cmsPhrase("Find books, articles which refer to a habitat type<br />(ex.: books, articles on <strong>Alpide acidocline [Rhododendron] heaths</strong> habitat type)")%>
                            <br />
                            <br />
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td bgcolor="#EEEEEE">
                                  <strong>
                                    <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed)")%>
                                  </strong>
                                </td>
                              </tr>
                              <tr>
                                <td bgcolor="#EEEEEE">
                                  <input type="checkbox" name="showAuthor" id="showAuthor" value="true" checked="checked" disabled="disabled" />
                                  <label for="showAuthor"><%=cm.cmsPhrase("Author")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showDate" id="showDate" value="true" checked="checked" disabled="disabled" />
                                  <label for="showDate"><%=cm.cmsPhrase("Date")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showTitle" id="showTitle" value="true" checked="checked" disabled="disabled" />
                                  <label for="showTitle"><%=cm.cmsPhrase("Title")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showEditor" id="showEditor" value="true" checked="checked" disabled="disabled" />
                                  <label for="showEditor"><%=cm.cmsPhrase("Editor")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showPublisher" id="showPublisher" value="true" checked="checked" disabled="disabled" />
                                  <label for="showPublisher"><%=cm.cmsPhrase("Publisher")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showSourceType" id="showSourceType" value="true" checked="checked" disabled="disabled" />
                                  <label for="showSourceType"><%=cm.cmsPhrase("Source type")%></label>
                                  &nbsp;
                                  <input type="checkbox" name="showHabitatTypes" id="showHabitatTypes" value="true" checked="checked" disabled="disabled" />
                                  <label for="showHabitatTypes"><%=cm.cmsPhrase("Habitat types")%></label>
                                  &nbsp;
                                </td>
                              </tr>
                            </table>
                            <br />
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <img alt="Mandatory" src="images/mini/field_mandatory.gif" style="vertical-align:middle" />
                            <label for="scientificName"><strong><%=cm.cmsPhrase("Habitat type name")%></strong></label>
                            <select name="relationOp" id="relationOp" title="Operator">
                              <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cmsPhrase("is")%></option>
                              <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cmsPhrase("starts with")%></option>
                            </select>
                            <label for="scientificName" class="noshow"><%=cm.cmsPhrase("List of values")%></label>
                            <input type="text" size="32" name="scientificName" id="scientificName" value="" title="Name" />
                            <a title="<%=cm.cmsPhrase("List of values")%>" href="javascript:openHelper('habitats-books-choice.jsp?')"><img style="vertical-align:middle" height="18" alt="<%=cm.cms("habitats_books_12")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                            <%=cm.cmsTitle("habitats_books_12")%>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                          </td>
                        </tr>
                        <tr><td>&nbsp;</td></tr>
                        <tr>
                          <td bgcolor="#EEEEEE">
                            <%=cm.cmsPhrase("Search database")%>:&nbsp;
                            <input type="radio" name="database" id="database1" value="<%=HabitatsBooksDomain.SEARCH_EUNIS%>" checked="checked" title="<%=cm.cms("search_eunis")%>" />
                            <%=cm.cmsTitle("search_eunis")%>
                            <label for="database1"><%=cm.cmsPhrase("EUNIS Habitat types")%></label>
                            &nbsp;&nbsp;
                            <input type="radio" name="database" id="database2" value="<%=HabitatsBooksDomain.SEARCH_ANNEX_I%>" title="<%=cm.cms("search_annex1")%>" />
                            <%=cm.cmsTitle("search_annex1")%>
                            <label for="database2"><%=cm.cmsPhrase("Habitats Directive Annex I ")%></label>
                            &nbsp;&nbsp;
                            <input type="radio" name="database" id="database3" value="<%=HabitatsBooksDomain.SEARCH_BOTH%>" title="<%=cm.cms("search_both")%>" />
                            <%=cm.cmsTitle("search_both")%>
                            <label for="database3"><%=cm.cmsPhrase("Both")%></label>
                          </td>
                        </tr>
                        <tr>
                          <td align="right">
                            <br />
                            <input type="reset" title="Reset fields" value="<%=cm.cmsPhrase("Reset")%>" name="Reset" id="Reset" class="standardButton" />
                            <%=cm.cmsTitle("reset_values")%>
                            <input type="submit" title="<%=cm.cmsPhrase("Search")%>" value="<%=cm.cmsPhrase("Search")%>" name="submit2" id="submit2" class="submitSearchButton" />
                          </td>
                        </tr>
                    </table>
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
                  var database1='<%=HabitatsBooksDomain.SEARCH_EUNIS%>';
                  var database2='<%=HabitatsBooksDomain.SEARCH_ANNEX_I%>';
                  var database3='<%=HabitatsBooksDomain.SEARCH_BOTH%>';
                  //]]>
                  </script>
                <script language="JavaScript" src="<%=request.getContextPath()%>/script/habitats-books-save-criteria.js" type="text/javascript"></script>
                    <%=cm.cmsPhrase("Save your criteria")%>:
                    <a title="<%=cm.cmsPhrase("Save search criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-books.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cmsPhrase("Save search criteria")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                <%
                  // Set Vector for URL string
                  Vector show = new Vector();
                  String pageName = "habitats-books.jsp";
                  String pageNameResult = "habitats-books-result.jsp?" + Utilities.writeURLCriteriaSave(show);
                  // Expand or not save criterias list
                  String expandSearchCriteria = (request.getParameter("expandSearchCriteria") == null ? "no" : request.getParameter("expandSearchCriteria"));
                %>
                    <jsp:include page="show-criteria-search.jsp">
                      <jsp:param name="pageName" value="<%=pageName%>" />
                      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                    </jsp:include>
                <%
                  }
                %>
                <%=cm.br()%>
                <%=cm.cmsMsg("habitats_books_title")%>
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
                <jsp:param name="page_name" value="habitats-books.jsp" />
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
