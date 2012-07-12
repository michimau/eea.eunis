<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats code' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.jrfTables.Chm62edtClassCodePersist,
                ro.finsiel.eunis.jrfTables.habitats.code.CodeDomain,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                java.util.Iterator,
                java.util.Vector"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" src="<%=request.getContextPath()%>/script/habitats-code.js" type="text/javascript"></script>
    <script language="JavaScript" src="<%=request.getContextPath()%>/script/save-criteria.js" type="text/javascript"></script>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,code_column";
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=cm.cmsPhrase("Habitat type code/classifications")%>
</title>
<script language="JavaScript" type="text/javascript">
//<![CDATA[
// Open popup for first form
function openHelper(URL)
{
  document.eunis.searchString.value = trim(document.eunis.searchString.value);
  classificationCode = document.eunis.classificationCode.value;
  searchString = escape(document.eunis.searchString.value);
  relationOp = document.eunis.relationOp.value;
  database = <%=CodeDomain.SEARCH_EUNIS%>;

    if (document.eunis.database[0].checked)
    {
      database = <%=CodeDomain.SEARCH_EUNIS%>;
    }
    if (document.eunis.database[1].checked)
    {
      database = <%=CodeDomain.SEARCH_ANNEX%>;
    }
    if (document.eunis.database[2].checked)
    {
      database = <%=CodeDomain.SEARCH_BOTH%>;
    }
    if (null == database)
    {
      alert( '<%=cm.cmsPhrase("Please select database")%>' );
    }
    else
    {
      URL2 = URL + '?classificationCode=' + classificationCode;
      URL2 += '&relationOp=' + relationOp;
      URL2 += '&searchString=' + searchString;
      URL2 += '&database=' + database;
      eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=450,height=500,left=490,top=0');");
    }
  }
//]]>
</script>
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
                        <%=cm.cmsPhrase("Code/Classifications")%>
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
                <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="habitats-code-result.jsp">
                <input type="hidden" value="true" name="clearsubs" />
                <input type="hidden" name="sortCriteria" value="code" />
                <input type="hidden" name="sortAscendency" value="descending" />
                <input type="hidden" name="showScientificName" value="true" />
                <input type="hidden" name="showCode" value="true" />
                <table width="100%" border="0" cellspacing="0">
                <tr>
                <td>
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <%=cm.cmsText("habitats_code_20")%>
                      <br />
                      <br />
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr bgcolor="#EEEEEE">
                          <td>
                            <strong>
                              <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%>
                            </strong>
                          </td>
                        </tr>
                        <tr>
                          <td style="white-space:nowrap">
                            <input type="checkbox" id="showLevel" name="showLevel" value="true" checked="checked" />
                            <label for="showLevel"><%=cm.cmsPhrase("Level")%></label>
                            &nbsp;
                            <input type="checkbox" id="showCode" name="showCode" value="true" checked="checked" disabled="disabled" />
                            <label for="showCode"><%=cm.cmsPhrase("Code")%></label>
                            &nbsp;
                            <input type="checkbox" id="showScientificName" name="showScientificName" value="true" checked="checked" disabled="disabled" />
                            <label for="showScientificName"><%=cm.cmsPhrase("Scientific name")%></label>
                            &nbsp;
                            <input type="checkbox" id="showOtherCodes" name="showOtherCodes" value="true" checked="checked" />
                            <label for="showOtherCodes"><%=cm.cmsPhrase("Relationship with other habitat types")%></label>
                            &nbsp;
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <br />
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img alt="<%=cm.cms("mandatory_field")%>" src="images/mini/field_mandatory.gif" /><%=cm.cmsTitle("mandatory_field")%>&nbsp;
                      <label for="classificationCode" class="noshow"><%=cm.cms("habitats_classification_code")%></label>
                      <select title="<%=cm.cms("habitats_classification_code")%>" name="classificationCode" id="classificationCode">
                        <jsp:useBean id="HabitatClassCodeDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtHabitatClassCodeDomain" scope="page" />
                        <%
                          // List of classifications
                          Iterator it = HabitatsSearchUtility.getDatabaseClassifications().iterator();
                          while (it.hasNext()) {
                            Chm62edtClassCodePersist element = (Chm62edtClassCodePersist) it.next();
                        %>
                        <option value="<%=element.getIdClassCode()%>"
                          <%=(element.getCurrentClassification().intValue() == 1 ? "selected=\"selected\"" : "")%>>
                          <%
                            String strCur=cm.cms("current_classification");
                          %>
                          <%=(element.getCurrentClassification().intValue() == 1 ? Utilities.treatURLSpecialCharacters(element.getClassName()) + " " + strCur : Utilities.treatURLSpecialCharacters(element.getClassName()))%>
                          <%
                            if (HabitatsSearchUtility.countHabitatsInClassification(element.getIdClassCode()) <= 0) {
                          %>
                          <%=cm.cms("empty")%>
                          <%
                            }
                          %>
                        </option>
                        <%
                          }
                        %>
                      </select>
                      <%=cm.cmsLabel("habitats_classification_code")%>
                      <%=cm.cmsInput("empty")%>
                      <%=cm.cmsInput("current_classification")%>
                      <label for="searchString">
                      <%=cm.cmsPhrase("Code")%></label>
                      <select title="Operator" name="relationOp" id="relationOp">
                        <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cmsPhrase("is")%></option>
                        <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                        <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cmsPhrase("starts with")%></option>
                      </select>
                      <label for="searchString" class="noshow"><%=cm.cmsPhrase("Filter value")%></label>
                      <input type="text" title="<%=cm.cmsPhrase("Filter value")%>" size="20" name="searchString" id="searchString" value="" />
                      <a title="<%=cm.cmsPhrase("List of values")%>" href="javascript:openHelper('habitats-code-choice.jsp')"><img alt="<%=cm.cmsPhrase("List of values")%>" border="0" src="images/helper/helper.gif" width="11" height="18" style="vertical-align:middle" /></a>
                    </td>
                  </tr>
                  <tr><td><strong><%=cm.cmsPhrase("in relation with habitat types from:")%></strong><br /></td></tr>
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <%=cm.cmsPhrase("in relation with")%>:&nbsp;
                      <label for="database" class="noshow"><%=cm.cms("database")%></label>
                      <select name="database" id="database">
                        <option value="<%=CodeDomain.SEARCH_EUNIS%>"><%=cm.cms("eunis_habitat_types")%></option>
                        <option value="<%=CodeDomain.SEARCH_ANNEX%>"><%=cm.cms("habitat_directive_annex_1")%></option>
                        <option value="<%=CodeDomain.SEARCH_BOTH%>"><%=cm.cms("both")%></option>
                      </select>
                      <%=cm.cmsLabel("database")%>
                      <%=cm.cmsInput("eunis_habitat_types")%>
                      <%=cm.cmsInput("habitat_directive_annex_1")%>
                      <%=cm.cmsInput("both")%>
                    </td>
                  </tr>
                  <tr><td>&nbsp;</td></tr>
                  <tr>
                    <td align="right">
                      <input title="<%=cm.cmsPhrase("Reset")%>" alt="<%=cm.cmsPhrase("Reset")%>" type="reset" value="<%=cm.cmsPhrase("Reset")%>" name="Reset" id="Reset" class="standardButton" />
                      <input title="<%=cm.cmsPhrase("Search")%>" alt="<%=cm.cmsPhrase("Search")%>" type="submit" value="<%=cm.cmsPhrase("Search")%>" name="submit2" id="submit2" class="submitSearchButton" />
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
                    var database1='<%=CodeDomain.SEARCH_EUNIS%>';
                    var database2='<%=CodeDomain.SEARCH_ANNEX%>';
                    var database3='<%=CodeDomain.SEARCH_BOTH%>';
                    //]]>
                    </script>
                    <script language="JavaScript" src="<%=request.getContextPath()%>/script/habitats-code-save-criteria.js" type="text/javascript"></script>
                    <%=cm.cmsPhrase("Save your criteria")%>:
                    <a title="<%=cm.cmsPhrase("Save search criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-code.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cmsPhrase("Save search criteria")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                <%
                  // Set Vector for URL string
                  Vector show = new Vector();
                  show.addElement("showLevel");
                  show.addElement("showCode");
                  show.addElement("showScientificName");
                  show.addElement("showVernacularName");
                  String pageName = "habitats-code.jsp";
                  String pageNameResult = "habitats-code-result.jsp?" + Utilities.writeURLCriteriaSave(show);
                  // Expand or not save criterias list
                  String expandSearchCriteria = (request.getParameter("expandSearchCriteria") == null ? "no" : request.getParameter("expandSearchCriteria"));
                %>
                    <jsp:include page="show-criteria-search.jsp">
                      <jsp:param name="pageName" value="<%=pageName%>" />
                      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                    </jsp:include>
                <%}%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="habitats-code.jsp" />
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
