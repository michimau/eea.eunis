<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats legal instruments' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.Chm62edtClassCodePersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtHabitatPersist,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                 ro.finsiel.eunis.search.habitats.legal.LegalSortCriteria,
                 java.util.Iterator,
                 java.util.Vector" %>

<jsp:useBean id="HabitatDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtHabitatDomain" scope="page" />
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-legal.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,legal_instruments";
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitat_type_legal_instruments")%>
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
                  <jsp:param name="location" value="<%=btrail%>" />
                  <jsp:param name="helpLink" value="habitats-help.jsp" />
                </jsp:include>
                <table summary="layout" width="100%" border="0">
                <tr>
                <td>
                <h1>
                  <%=cm.cmsText("legal_instruments")%>
                </h1>
                <%=cm.cmsText("habitats_legal_17")%>
                <br />
                <br />
                <form name="eunis" action="habitats-legal-result.jsp" method="get" onsubmit="javascript: return validateForm();">
                <input type="hidden" name="sort" value="<%=LegalSortCriteria.SORT_EUNIS_CODE%>" />
                <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
                <input type="hidden" name="showScientificName" value="true" />
                <table width="100%" summary="layout" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <strong>
                        <%=cm.cmsText("search_will_provide_2")%>
                      </strong>
                    </td>
                  </tr>
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <input title="Show level" type="checkbox" id="showLevel" name="showLevel" value="true" checked="checked" />
                      <label for="showLevel"><%=cm.cmsText("generic_index_07")%></label>
                      &nbsp;
                      <input title="Show code" type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
                      <label for="showCode"><%=cm.cmsText("code_column")%></label>
                      &nbsp;
                      <input title="Show name" type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
                      <label for="showScientificName"><%=cm.cmsText("habitat_type_name")%></label>
                      &nbsp;
                      <input title="Show legal text" type="checkbox" name="showLegalText" id="showLegalText" value="true" checked="checked" />
                      <label for="showLegalText"><%=cm.cmsText("legal_text")%></label>
                      &nbsp;
                    </td>
                  </tr>
                </table>
                <table summary="layout" cellspacing="2" cellpadding="0" border="0" width="100%">
                  <tr>
                    <td valign="bottom" colspan="2">
                      <p>
                        <img alt="<%=cm.cms("included_field")%>" src="images/mini/field_included.gif" style="vertical-align:middle" /><%=cm.cmsTitle("included_field")%>
                        &nbsp;
                        <label for="habitatType">
                        <strong>
                          <%=cm.cmsText("habitat_type")%>
                        </strong>
                        </label>
                      </p>
                    </td>
                    <td valign="bottom" colspan="2">
                      <label for="habitatType" class="noshow"><%=cm.cms("habitat_type")%></label>
                      <select title="<%=cm.cms("habitat_type")%>" name="habitatType" id="habitatType">
                        <option value="any" selected="selected"><%=cm.cms("habitats_legal_09")%></option>
                        <%
                          // List of EUNIS habitats from first level.
                          Iterator it = HabitatsSearchUtility.findEUNISHabitatTypes().iterator();
                          while (it.hasNext()) {
                            Chm62edtHabitatPersist habitat = (Chm62edtHabitatPersist) it.next();%>
                        <option value="<%=habitat.getEunisHabitatCode()%>"><%=habitat.getEunisHabitatCode()%>
                          - <%=habitat.getScientificName()%></option>
                        <%}%>
                      </select>
                      <%=cm.cmsLabel("habitat_type")%>
                      <%=cm.cmsInput("habitats_legal_09")%>
                    </td>
                    <td width="6%" align="right">
                      <strong>
                        <%=cm.cmsText("and")%>
                      </strong>
                    </td>
                  </tr>
                  <tr valign="middle">
                    <td colspan="2">
                      <br />
                      <img alt="<%=cm.cms("included_field")%>" src="images/mini/field_included.gif" style="vertical-align:middle" /><%=cm.cmsTitle("included_field")%>
                      &nbsp;
                      <label for="searchString"><strong><%=cm.cmsText("habitats_legal_11")%></strong></label>
                    </td>
                    <td colspan="2">
                      <br />
                      <input title="<%=cm.cms("habitats_legal_11")%>" size="30" name="searchString" id="searchString" /><%=cm.cmsTitle("habitats_legal_11")%>
                      &nbsp;
                      <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-legal-choice.jsp');">
                        <img alt="<%=cm.cms("list_of_values")%>" height="18" src="images/helper/helper.gif" style="vertical-align:middle" width="11" border="0" /></a><%=cm.cmsTitle("list_of_values")%>
                    </td>
                    <td width="6%" align="right">
                      <br />
                      <strong>
                        <%=cm.cmsText("and")%>
                      </strong>
                    </td>
                  </tr>
                  <tr valign="middle">
                    <td valign="middle" colspan="2">
                      <br />
                      <img alt="<%=cm.cms("included_field")%>" src="images/mini/field_included.gif" style="vertical-align:middle" /><%=cm.cmsTitle("included_field")%>
                      &nbsp;
                      <label for="legalText"><strong><%=cm.cmsText("legal_text")%></strong></label>
                    </td>
                    <td colspan="2">
                      <br />
                      <label for="legalText" class="noshow"><%=cm.cms("legal_text")%></label>
                      <select title="<%=cm.cms("legal_text")%>" name="legalText" id="legalText">
                        <option value="any" selected="selected"><%=cm.cms("any_legal_text")%></option>
                        <%
                          // List of habitats legal instruments.
                          it = HabitatsSearchUtility.findLegalTexts().iterator();
                          while (it.hasNext()) {
                            Chm62edtClassCodePersist element = (Chm62edtClassCodePersist) it.next();%>
                        <option value="<%=element.getClassName()%>"><%=element.getClassName()%></option>
                        <%}%>
                      </select>
                      <%=cm.cmsLabel("legal_text")%>
                      <%=cm.cmsInput("any_legal_text")%>
                    </td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td align="right" colspan="5">
                      <input title="<%=cm.cms("reset")%>" type="reset" value="<%=cm.cms("reset")%>" name="Reset" id="Reset" class="standardButton" />
                      <%=cm.cmsTitle("reset")%>
                      <%=cm.cmsInput("reset")%>
                      <input title="<%=cm.cms("search")%>" type="submit" value="<%=cm.cms("search")%>" id="submit" name="submit" class="searchButton" />
                      <%=cm.cmsTitle("search")%>
                      <%=cm.cmsInput("search")%>
                    </td>
                  </tr>
                </table>
                </form>
                </td>
                </tr>
                <%
                  // Expand saved searches list for this jsp page
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
                     var database1='';
                     var database2='';
                     var database3='';
                    //-->
                    </script>
                  </td>
                </tr>
                <tr>
                  <td>
                    <script language="JavaScript" src="script/habitats-legal-save-criteria.js" type="text/javascript"></script>
                    <%=cm.cmsText("save_your_criteria")%>:
                    <a title="<%=cm.cms("save_criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',true,'habitats-legal.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_criteria")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                    <%=cm.cmsTitle("save_criteria")%>
                  </td>
                </tr>
                <%
                  // Set Vector for URL string
                  Vector show = new Vector();
                  show.addElement("showLegalText");
                  show.addElement("showCode");
                  show.addElement("showScientificName");
                  String pageName = "habitats-legal.jsp";
                  String pageNameResult = "habitats-legal-result.jsp?" + Utilities.writeURLCriteriaSave(show);
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
                <%}%>
                </table>
                <%=cm.br()%>
                <%=cm.cmsMsg("habitat_type_legal_instruments")%>
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
                <jsp:param name="page_name" value="habitats-legal.jsp" />
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
