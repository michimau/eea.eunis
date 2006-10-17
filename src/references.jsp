<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : References search page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.formBeans.ReferencesSearchCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String author = (request.getParameter("author")==null?"":request.getParameter("author"));
  String relationOpAuthor = (request.getParameter("relationOpAuthor")==null?Utilities.OPERATOR_CONTAINS.toString():request.getParameter("relationOpAuthor"));
  String date = (request.getParameter("date")==null?"":request.getParameter("date"));
  String date1 = (request.getParameter("date1")==null?"":request.getParameter("date1"));
  //String relationOpDate = (request.getParameter("relationOpDate")==null?Utilities.OPERATOR_CONTAINS.toString():request.getParameter("relationOpDate"));
  String title = (request.getParameter("title")==null?"":request.getParameter("title"));
  String relationOpTitle = (request.getParameter("relationOpTitle")==null?Utilities.OPERATOR_CONTAINS.toString():request.getParameter("relationOpTitle"));
  String editor = (request.getParameter("editor")==null?"":request.getParameter("editor"));
  String relationOpEditor = (request.getParameter("relationOpEditor")==null?Utilities.OPERATOR_CONTAINS.toString():request.getParameter("relationOpEditor"));
  String publisher = (request.getParameter("publisher")==null?"":request.getParameter("publisher"));
  String relationOpPublisher = (request.getParameter("relationOpPublisher")==null?Utilities.OPERATOR_CONTAINS.toString():request.getParameter("relationOpPublisher"));
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,references";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <%-- Note: Include these three files this order. --%>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
      <script language="JavaScript" type="text/javascript" src="script/references.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("references")%>
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
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                  <form name="eunis" method="post" action="references-result.jsp" onsubmit="return(checkformForDate());">
                    <input type="hidden" name="typeForm" value="<%=ReferencesSearchCriteria.CRITERIA_AUTHOR%>" />
                    <h1>
                      <%=cm.cmsText("references")%>
                    </h1>
                    <%=cm.cmsText("references_references_19")%>
                    <br />
                    <br />
                    <div class="grey_rectangle">
                      <strong>
                        <%=cm.cmsText("search_will_provide")%>
                      </strong>
                      <br />
                      <input type="checkbox" id="showAuthor" name="showAuthor" value="true" checked="checked" disabled="disabled" />
                      <label for="showAuthor">
                        <%=cm.cmsText("author")%>
                      </label>

                      <input type="checkbox" id="showYear" name="showYear" value="true" checked="checked" />
                      <label for="showYear">
                        <%=cm.cmsText("year")%>
                      </label>

                      <input type="checkbox" id="showTitle" name="showTitle" value="true" checked="checked" />
                      <label for="showTitle">
                        <%=cm.cmsText("title")%>
                      </label>

                      <input type="checkbox" id="showEditor" name="showEditor" value="true" checked="checked" />
                      <label for="showEditor">
                        <%=cm.cmsText("editor")%>
                      </label>

                      <input type="checkbox" id="showPublisher" name="showPublisher" value="true" checked="checked" />
                      <label for="showPublisher">
                        <%=cm.cmsText("publisher")%>
                      </label>

                      <input type="checkbox" id="showURL" name="showURL" value="true" />
                      <label for="showURL">
                        <%=cm.cmsText("url")%>
                      </label>
                    </div>
                    <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_included")%>
                    &nbsp;
                    <strong>
                      <%=cm.cmsText("author")%>
                    </strong>
                    <label for="relationOpAuthor" class="noshow"><%=cm.cms("operator")%></label>
                    <select id="relationOpAuthor" name="relationOpAuthor">
                      <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpAuthor.equalsIgnoreCase(Utilities.OPERATOR_IS.toString())?"selected=\"selected\"":"")%>>
                        <%=cm.cms( "is")%>
                      </option>
                      <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpAuthor.equalsIgnoreCase(Utilities.OPERATOR_CONTAINS.toString())?"selected=\"selected\"":"")%>>
                        <%=cm.cms("contains")%>
                      </option>
                      <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpAuthor.equalsIgnoreCase(Utilities.OPERATOR_STARTS.toString())?"selected=\"selected\"":"")%>>
                        <%=cm.cms("starts")%>
                      </option>
                    </select>
                    <%=cm.cmsInput( "is")%>
                    <%=cm.cmsInput( "contains")%>
                    <%=cm.cmsInput( "starts")%>
                    <%=cm.cmsLabel("operator")%>

                    <label for="author" class="noshow">Author</label>
                    <input size="80" id="author" name="author" value="<%=author%>" />
                    <a href="javascript:choiceprenref('references-choice.jsp','author',0)"><img height="18" style="vertical-align:middle" alt="List of authors starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>

                    <br />
                    <img style="vertical-align:middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
                    <%=cm.cmsAlt("field_included")%>
                    &nbsp;
                    <strong>
                      <%=cm.cmsText("year")%>
                    </strong>
                    <label for="relOpDate" class="noshow"><%=cm.cms("operator")%></label>
                    <select id="relOpDate" name="relOpDate" onchange="MM_jumpMenu('parent',this,0)">
                      <option value="references.jsp?between=no" <%=(request.getParameter("between")==null?"selected=\"selected\"":(request.getParameter("between").equalsIgnoreCase("yes")?"":"selected=\"selected\""))%>>
                        <%=cm.cms("is")%>
                      </option>
                      <option value="references.jsp?between=yes" <%if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes")){%> selected="selected"<%}%>>
                        <%=cm.cms("between")%>
                      </option>
                    </select>
                    <%=cm.cmsInput( "is")%>
                    <%=cm.cmsInput( "between")%>
                    <%=cm.cmsLabel("operator")%>
          <%
            if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes"))
            {
          %>
                    <label for="date" class="noshow">Start year</label>
                    <input size="5" id="date" name="date" value="<%=date%>" onchange="goodDate1();" />&nbsp;
                    <a href="javascript:choiceprenref('references-choice.jsp','date',1)"><img height="18" style="vertical-align:middle" alt="List of years ..." src="images/helper/helper.gif" width="11" border="0" /></a>
                    <%=cm.cmsText("and")%>
                    <label for="date1" class="noshow">End year</label>
                    <input size="5" id="date1" name="date1" value="<%=date1%>" onchange="goodDate2();" />&nbsp;
                    <a href="javascript:choiceprenref('references-choice.jsp','date',2)"><img height="18" style="vertical-align:middle" alt="List of years ..." src="images/helper/helper.gif" width="11" border="0" /></a>
          <%
            }
            else
            {
          %>
                    <label for="date" class="noshow">
                      <%=cm.cms("year")%>
                    </label>
                    <input size="5" id="date" name="date" value="<%=date%>" onchange="goodDate1();" />
                    <%=cm.cmsLabel("year")%>
                    <a href="javascript:choiceprenref('references-choice.jsp','date',1)"><img height="18" style="vertical-align:middle" alt="List of years ..." src="images/helper/helper.gif" width="11" border="0" /></a>
          <%
            }
            Integer valDate=Utilities.OPERATOR_IS;
            if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes")) valDate=Utilities.OPERATOR_BETWEEN;
          %>
                  <input type="hidden" name="relationOpDate" value="<%=valDate%>" />
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_included")%>
                  &nbsp;
                  <strong>
                    <%=cm.cmsText("title")%>
                  </strong>
                  <label for="relationOpTitle" class="noshow"><%=cm.cms("operator")%></label>
                  <select id="relationOpTitle" name="relationOpTitle">
                    <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpTitle.equalsIgnoreCase(Utilities.OPERATOR_IS.toString())?"selected=\"selected\"":"")%>>
                      <%=cm.cms("is")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpTitle.equalsIgnoreCase(Utilities.OPERATOR_CONTAINS.toString())?"selected=\"selected\"":"")%>>
                      <%=cm.cms("contains")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpTitle.equalsIgnoreCase(Utilities.OPERATOR_STARTS.toString())?"selected=\"selected\"":"")%>>
                      <%=cm.cms("starts")%>
                    </option>
                  </select>
                  <%=cm.cmsInput( "is")%>
                  <%=cm.cmsInput( "contains")%>
                  <%=cm.cmsInput( "starts")%>
                  <%=cm.cmsLabel("operator")%>

                  <label for="title" class="noshow">
                    <%=cm.cms("title")%>
                  </label>
                  <input size="80" id="title" name="title" value="<%=title%>" />
                  <%=cm.cmsLabel("title")%>
                  <a href="javascript:choiceprenref('references-choice.jsp','title',0)"><img height="18" style="vertical-align:middle" alt="List of titles starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>
                  <br />
                  <img src="images/mini/field_included.gif" alt="Field is optional" title="Field is optional" />
                  &nbsp;
                  <strong>
                    <%=cm.cmsText("editor")%>
                  </strong>
                  <label for="relationOpEditor" class="noshow"><%=cm.cms("operator")%></label>
                  <select id="relationOpEditor" name="relationOpEditor">
                    <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpEditor.equalsIgnoreCase(Utilities.OPERATOR_IS.toString())?"selected=\"selected\"":"")%>>
                      <%=cm.cms("is")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpEditor.equalsIgnoreCase(Utilities.OPERATOR_CONTAINS.toString())?"selected=\"selected\"":"")%>>
                      <%=cm.cms("contains")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpEditor.equalsIgnoreCase(Utilities.OPERATOR_STARTS.toString())?"selected=\"selected\"":"")%>>
                      <%=cm.cms("starts")%>
                    </option>
                  </select>
                  <%=cm.cmsInput( "is")%>
                  <%=cm.cmsInput( "contains")%>
                  <%=cm.cmsInput( "starts")%>
                  <%=cm.cmsLabel("operator")%>

                  <label for="editor" class="noshow">
                    <%=cm.cms("editor")%>
                  </label>
                  <input size="80" id="editor" name="editor" value="<%=editor%>" />
                  <%=cm.cmsLabel("editor")%>
                  <a href="javascript:choiceprenref('references-choice.jsp','editor',0)"><img height="18" style="vertical-align:middle" alt="List of editors starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_included")%>
                  &nbsp;
                  <strong>
                    <%=cm.cmsText("publisher")%>
                  </strong>
                  <label for="relationOpPublisher" class="noshow"><%=cm.cms("operator")%></label>
                  <select id="relationOpPublisher" name="relationOpPublisher">
                    <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpPublisher.equalsIgnoreCase(Utilities.OPERATOR_IS.toString())?"selected=\"selected\"":"")%>>
                      <%=cm.cms("is")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpPublisher.equalsIgnoreCase(Utilities.OPERATOR_CONTAINS.toString())?"selected=\"selected\"":"")%>>
                      <%=cm.cms("contains")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpPublisher.equalsIgnoreCase(Utilities.OPERATOR_STARTS.toString())?"selected=\"selected\"":"")%>>
                      <%=cm.cms("starts")%>
                    </option>
                  </select>
                  <%=cm.cmsInput( "is")%>
                  <%=cm.cmsInput( "contains")%>
                  <%=cm.cmsInput( "starts")%>
                  <%=cm.cmsLabel("operator")%>

                  <label for="publisher" class="noshow">Publisher</label>
                  <input size="80" id="publisher" name="publisher" value="<%=publisher%>" />
                  <a href="javascript:choiceprenref('references-choice.jsp','publisher',0)"><img height="18" style="vertical-align:middle" alt="List of publishers starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>
                  <br />
                  <br />
                  <div class="submit_buttons">
                    <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset")%>" class="standardButton" title="<%=cm.cms("reset_values")%>" />
                    <%=cm.cmsTitle("reset_values")%>
                    <%=cm.cmsInput("reset")%>

                    <input id="submit2" name="submit2" type="submit" class="searchButton" value="<%=cm.cms("search")%>" title="<%=cm.cms("search")%>" />
                    <%=cm.cmsTitle("search")%>
                    <%=cm.cmsInput("search")%>
                  </div>
                </form>

                <%=cm.cmsMsg("references")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="references.jsp" />
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
