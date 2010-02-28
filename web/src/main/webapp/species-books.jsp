<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show references' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.references.ReferencesSearchCriteria,
                 java.util.Vector" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,pick_species_show_references_location";
  %>
  <script language="JavaScript" src="script/species-books-save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
      var errMessageForm = "<%=cm.cms("species_books_02")%>.";
      function openHelper(URL)
      {
        document.eunis.scientificName.value = trim(document.eunis.scientificName.value);
        scientificName = document.eunis.scientificName.value;
        if(scientificName=="") {
          alert(errMessageForm);
        } else {
            relationOp=escape(document.eunis.relationOp.value);
            URL2= URL + '&scientificName=' + scientificName+'&relationOp='+relationOp;
            eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=450,height=500,left=490,top=0');");
        }
      }

      function validateForm()
      {
        document.eunis.scientificName.value = trim(document.eunis.scientificName.value);
        scientificName = document.eunis.scientificName.value;
        if (scientificName == "")
        {
          alert(errMessageForm);
          return false;
        }
        return true;
      }
    //]]>
  </script>
<%
  // Save search criteria
  if(SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
  {
%>
<script type="text/javascript" language="JavaScript">
//<![CDATA[
 // values of source and database constants from specific class Domain(only in habitat searches, so here are all '')
 var source1='';
 var source2='';
 var database1='';
 var database2='';
 var database3='';
//]]>
</script>
<%
  }
%>

  <title><%=application.getInitParameter("PAGE_TITLE")%><%=cm.cms("species_books_title")%></title>
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
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
		    <h1>
		      <%=cm.cmsPhrase("Pick species, show references")%>
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
                      <a href="species-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <table width="100%" border="0" summary="layout">
                <tr>
                  <td>
                    <form name="eunis" method="get" onsubmit="return(validateForm());" action="species-books-result.jsp">
                      <input type="hidden" name="typeForm" value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC%>" />
                      <table width="100%" border="0" style="text-align : left" summary="layout">
                        <tr>
                          <td colspan="2">
                            <%=cm.cmsPhrase("Find books, articles which refers to species<br />(ex.: documents which refers the <strong>salmo trutta</strong> fish)")%>
                            <br />
                            <br />
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="layout">
                              <tr>
                                <td style="background-color:#EEEEEE">
                                  <strong>
                                    <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%>
                                  </strong>
                                </td>
                              </tr>
                              <tr>
                                <td style="background-color:#EEEEEE">
                                  <input title="<%=cm.cms("species_books_04_Title")%>" alt="<%=cm.cms("species_books_04_Title")%>" id="checkbox1" name="checkbox1" type="checkbox" value="show" checked="checked" disabled="disabled" />
                                  <label for="checkbox1"><%=cm.cmsPhrase("Author")%></label>
                                  <%=cm.cmsTitle("species_books_04_Title")%>
                                  <input title="<%=cm.cms("species_books_05_Title")%>" alt="<%=cm.cms("species_books_04_Title")%>" id="checkbox2" name="checkbox2" type="checkbox" value="show" checked="checked" disabled="disabled" />
                                  <label for="checkbox2"><%=cm.cmsPhrase("Date")%></label>
                                   <%=cm.cmsTitle("species_books_05_Title")%>
                                  <input title="<%=cm.cms("species_books_06_Title")%>" alt="<%=cm.cms("species_books_04_Title")%>" id="checkbox3" name="checkbox3" type="checkbox" value="show" checked="checked" disabled="disabled" />
                                  <label for="checkbox3"><%=cm.cmsPhrase("Title")%></label>
                                  <%=cm.cmsTitle("species_books_06_Title")%>
                                  <input title="<%=cm.cms("species_books_07_Title")%>" alt="<%=cm.cms("species_books_04_Title")%>" id="checkbox4" name="checkbox4" type="checkbox" value="show" checked="checked" disabled="disabled" />
                                  <label for="checkbox4"><%=cm.cmsPhrase("Editor")%></label>
                                  <%=cm.cmsTitle("species_books_07_Title")%>
                                  <input title="<%=cm.cms("species_books_08_Title")%>" alt="<%=cm.cms("species_books_04_Title")%>" id="checkbox5" name="checkbox5" type="checkbox" value="show" checked="checked" disabled="disabled" />
                                  <label for="checkbox5"><%=cm.cmsPhrase("Publisher")%></label>
                                  <%=cm.cmsTitle("species_books_08_Title")%>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <br />
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="2">
                            <img width="11" height="12" style="vertical-align : middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" />
                            <%=cm.cmsAlt("field_mandatory")%>
                            &nbsp;
                            <label for="scientificName"><%=cm.cmsPhrase("Species scientific name")%></label>
                            <label for="select1" class="noshow"><%=cm.cms("relation_type")%></label>
                            <select id="select1" title="<%=cm.cms("relation_type")%>" name="relationOp">
                              <option value="<%=Utilities.OPERATOR_IS%>">
                                  <%=cm.cms("is")%>
                              </option>
                              <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                                  <%=cm.cms("contains")%>
                              </option>
                              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
                                  <%=cm.cms("starts_with")%>
                              </option>
                            </select>
                            <%=cm.cmsLabel("relation_type")%>
                            <%=cm.cmsTitle("relation_type")%>
                            <input id="scientificName" alt="<%=cm.cms("species_books_09_Alt")%>" title="<%=cm.cms("species_books_09_Alt")%>" size="32" name="scientificName" value="" />
                            <%=cm.cmsAlt("species_books_09_Alt")%>
                            <a title="<%=cm.cms("species_books_13_Title")%>" href="javascript:openHelper('species-books-choice.jsp?')"><img alt="<%=cm.cms("species_books_13")%>" style="vertical-align : middle" title="<%=cm.cms("species_books_13")%>" src="images/helper/helper.gif" border="0" /></a>
                            <%=cm.cmsTitle("species_books_13_Title")%>
                            <%=cm.cmsAlt("species_books_13")%>
                          </td>
                        </tr>
                        <tr>
                          <td style="text-align:right" colspan="2">
                            <input id="Reset" type="reset" value="<%=cm.cms("reset")%>" name="Reset" class="standardButton" alt="Reset" title="<%=cm.cms("reset")%>" />
                            <%=cm.cmsTitle("reset")%>
                            <%=cm.cmsInput("reset")%>
                            <input id="submit" type="submit" value="<%=cm.cms("search")%>" name="submit2" class="submitSearchButton" alt="Search" title="<%=cm.cms("search")%>" />
                            <%=cm.cmsTitle("search")%>
                            <%=cm.cmsInput("search")%>
                          </td>
                        </tr>
                      </table>
                    </form>
                  </td>
                </tr>
                <%
                  // Save search criteria
                  if(SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT()) {
                %>
                <tr><td>&nbsp;</td></tr>
                <tr style="background-color:#EEEEEE">
                  <td>
                    <%=cm.cmsPhrase("Save your criteria")%>:
                    <a title="<%=cm.cms("species_books_20_Title")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-books.jsp','1','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');">
                      <img border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" alt="<%=cm.cms("species_books_20_Alt")%>" />
                    </a>
                    <%=cm.cmsTitle("species_books_20_Title")%>
                    <%=cm.cmsAlt("species_books_20_Alt")%>
                  </td>
                </tr>
                <%
                  // Set Vector for URL string
                  Vector show = new Vector();
                  String pageName = "species-books.jsp";
                  String pageNameResult = "species-books-result.jsp?" + Utilities.writeURLCriteriaSave(show);
                  // Expand or not save criterias list
                  String expandSearchCriteria = (request.getParameter("expandSearchCriteria") == null ? "no" : request.getParameter("expandSearchCriteria"));
                %>
                <tr><td>
                    <jsp:include page="show-criteria-search.jsp">
                      <jsp:param name="pageName" value="<%=pageName%>" />
                      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                    </jsp:include>
                </td></tr>
                <%
                  }
                %>
                </table>

                <%=cm.br()%>
                <%=cm.cmsMsg("species_books_02")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_books_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("is")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("contains")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("starts_with")%>
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
                <jsp:param name="page_name" value="species-books.jsp" />
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
