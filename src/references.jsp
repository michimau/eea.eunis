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
  WebContentManagement cm = SessionManager.getWebContent();
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <%-- Note: Include these three files this order. --%>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/references.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("references_page_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,references_location"/>
      </jsp:include>
        <form name="eunis" method="post" action="references-result.jsp" onsubmit="return(checkformForDate());">
          <input type="hidden" name="typeForm" value="<%=ReferencesSearchCriteria.CRITERIA_AUTHOR%>" />
          <h1>
            <%=cm.cmsText("references_references_01")%>
          </h1>
          <%=cm.cmsText("references_references_19")%>
          <br />
          <br />
          <div class="grey_rectangle">
            <strong>
              <%=cm.cmsText("search_will_provide_following_information")%>
            </strong>
            <br />
            <input type="checkbox" id="showAuthor" name="showAuthor" value="true" checked="checked" disabled="disabled" />
            <label for="showAuthor">
              <%=cm.cmsText("references_author")%>
            </label>

            <input type="checkbox" id="showYear" name="showYear" value="true" checked="checked" />
            <label for="showYear">
              <%=cm.cmsText("references_year")%>
            </label>

            <input type="checkbox" id="showTitle" name="showTitle" value="true" checked="checked" />
            <label for="showTitle">
              <%=cm.cmsText("references_title")%>
            </label>

            <input type="checkbox" id="showEditor" name="showEditor" value="true" checked="checked" />
            <label for="showEditor">
              <%=cm.cmsText("references_editor")%>
            </label>

            <input type="checkbox" id="showPublisher" name="showPublisher" value="true" checked="checked" />
            <label for="showPublisher">
              <%=cm.cmsText("references_publisher")%>
            </label>

            <input type="checkbox" id="showURL" name="showURL" value="true" />
            <label for="showURL">
              <%=cm.cmsText("references_url")%>
            </label>
          </div>
          <br />
        <img align="middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_included")%>
          &nbsp;
          <strong>
            <%=cm.cmsText("references_author")%>
          </strong>
          <label for="relationOpAuthor" class="noshow"><%=cm.cms("operator")%></label>
          <select id="relationOpAuthor" name="relationOpAuthor" class="inputTextField">
            <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpAuthor.equalsIgnoreCase(Utilities.OPERATOR_IS.toString())?"selected=\"selected\"":"")%>>
              <%=cm.cms( "references_operator_is")%>
            </option>
            <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpAuthor.equalsIgnoreCase(Utilities.OPERATOR_CONTAINS.toString())?"selected=\"selected\"":"")%>>
              <%=cm.cms("references_operator_contains")%>
            </option>
            <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpAuthor.equalsIgnoreCase(Utilities.OPERATOR_STARTS.toString())?"selected=\"selected\"":"")%>>
              <%=cm.cms("references_operator_starts")%>
            </option>
          </select>
          <%=cm.cmsInput( "references_operator_is")%>
          <%=cm.cmsInput( "references_operator_contains")%>
          <%=cm.cmsInput( "references_operator_starts")%>
          <%=cm.cmsLabel("operator")%>

          <label for="author" class="noshow">Author</label>
          <input size="80" id="author" name="author" value="<%=author%>" class="inputTextField" />
          <a href="javascript:choiceprenref('references-choice.jsp','author',0)"><img height="18" align="middle" alt="List of authors starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>

          <br />
          <img align="middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
          <%=cm.cmsAlt("field_included")%>
          &nbsp;
          <strong>
            <%=cm.cmsText("references_year")%>
          </strong>
          <label for="relOpDate" class="noshow"><%=cm.cms("operator")%></label>
          <select id="relOpDate" name="relOpDate" onchange="MM_jumpMenu('parent',this,0)" class="inputTextField">
            <option value="references.jsp?between=no" <%=(request.getParameter("between")==null?"selected=\"selected\"":(request.getParameter("between").equalsIgnoreCase("yes")?"":"selected=\"selected\""))%>>
              <%=cm.cms("references_operator_is")%>
            </option>
            <option value="references.jsp?between=yes" <%if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes")){%> selected="selected"<%}%>>
              <%=cm.cms("references_operator_between")%>
            </option>
          </select>
          <%=cm.cmsInput( "references_operator_is")%>
          <%=cm.cmsInput( "references_operator_between")%>
          <%=cm.cmsLabel("operator")%>
<%
  if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes"))
  {
%>
          <label for="date" class="noshow">Start year</label>
          <input size="5" id="date" name="date" value="<%=date%>" class="inputTextField" onchange="goodDate1();" />&nbsp;
          <a href="javascript:choiceprenref('references-choice.jsp','date',1)"><img height="18" align="middle" alt="List of years ..." src="images/helper/helper.gif" width="11" border="0" /></a>
          <%=cm.cmsText("and")%>
          <label for="date1" class="noshow">End year</label>
          <input size="5" id="date1" name="date1" value="<%=date1%>" class="inputTextField" onchange="goodDate2();" />&nbsp;
          <a href="javascript:choiceprenref('references-choice.jsp','date',2)"><img height="18" align="middle" alt="List of years ..." src="images/helper/helper.gif" width="11" border="0" /></a>
<%
  }
  else
  {
%>
          <label for="date" class="noshow">
            <%=cm.cms("references_year")%>
          </label>
          <input size="5" id="date" name="date" value="<%=date%>" class="inputTextField" onchange="goodDate1();" />
          <%=cm.cmsLabel("references_year")%>
          <a href="javascript:choiceprenref('references-choice.jsp','date',1)"><img height="18" align="middle" alt="List of years ..." src="images/helper/helper.gif" width="11" border="0" /></a>
<%
  }
  Integer valDate=Utilities.OPERATOR_IS;
  if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes")) valDate=Utilities.OPERATOR_BETWEEN;
%>
        <input type="hidden" name="relationOpDate" value="<%=valDate%>" />
        <br />
        <img align="middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_included")%>
        &nbsp;
        <strong>
          <%=cm.cmsText("references_title")%>
        </strong>
        <label for="relationOpTitle" class="noshow"><%=cm.cms("operator")%></label>
        <select id="relationOpTitle" name="relationOpTitle" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpTitle.equalsIgnoreCase(Utilities.OPERATOR_IS.toString())?"selected=\"selected\"":"")%>>
            <%=cm.cms("references_operator_is")%>
          </option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpTitle.equalsIgnoreCase(Utilities.OPERATOR_CONTAINS.toString())?"selected=\"selected\"":"")%>>
            <%=cm.cms("references_operator_contains")%>
          </option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpTitle.equalsIgnoreCase(Utilities.OPERATOR_STARTS.toString())?"selected=\"selected\"":"")%>>
            <%=cm.cms("references_operator_starts")%>
          </option>
        </select>
        <%=cm.cmsInput( "references_operator_is")%>
        <%=cm.cmsInput( "references_operator_contains")%>
        <%=cm.cmsInput( "references_operator_starts")%>
        <%=cm.cmsLabel("operator")%>

        <label for="title" class="noshow">
          <%=cm.cms("references_title")%>
        </label>
        <input size="80" id="title" name="title" value="<%=title%>" class="inputTextField" />
        <%=cm.cmsLabel("references_title")%>
        <a href="javascript:choiceprenref('references-choice.jsp','title',0)"><img height="18" align="middle" alt="List of titles starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>
        <br />
        <img src="images/mini/field_included.gif" alt="Field is optional" title="Field is optional" />
        &nbsp;
        <strong>
          <%=cm.cmsText("references_editor")%>
        </strong>
        <label for="relationOpEditor" class="noshow"><%=cm.cms("operator")%></label>
        <select id="relationOpEditor" name="relationOpEditor" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpEditor.equalsIgnoreCase(Utilities.OPERATOR_IS.toString())?"selected=\"selected\"":"")%>>
            <%=cm.cms("references_operator_is")%>
          </option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpEditor.equalsIgnoreCase(Utilities.OPERATOR_CONTAINS.toString())?"selected=\"selected\"":"")%>>
            <%=cm.cms("references_operator_contains")%>
          </option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpEditor.equalsIgnoreCase(Utilities.OPERATOR_STARTS.toString())?"selected=\"selected\"":"")%>>
            <%=cm.cms("references_operator_starts")%>
          </option>
        </select>
        <%=cm.cmsInput( "references_operator_is")%>
        <%=cm.cmsInput( "references_operator_contains")%>
        <%=cm.cmsInput( "references_operator_starts")%>
        <%=cm.cmsLabel("operator")%>

        <label for="editor" class="noshow">
          <%=cm.cms("references_editor")%>
        </label>
        <input size="80" id="editor" name="editor" value="<%=editor%>" class="inputTextField" />
        <%=cm.cmsLabel("references_editor")%>
        <a href="javascript:choiceprenref('references-choice.jsp','editor',0)"><img height="18" align="middle" alt="List of editors starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>
        <br />
        <img align="middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_included")%>
        &nbsp;
        <strong>
          <%=cm.cmsText("references_publisher")%>
        </strong>
        <label for="relationOpPublisher" class="noshow"><%=cm.cms("operator")%></label>
        <select id="relationOpPublisher" name="relationOpPublisher" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpPublisher.equalsIgnoreCase(Utilities.OPERATOR_IS.toString())?"selected=\"selected\"":"")%>>
            <%=cm.cms("references_operator_is")%>
          </option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpPublisher.equalsIgnoreCase(Utilities.OPERATOR_CONTAINS.toString())?"selected=\"selected\"":"")%>>
            <%=cm.cms("references_operator_contains")%>
          </option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpPublisher.equalsIgnoreCase(Utilities.OPERATOR_STARTS.toString())?"selected=\"selected\"":"")%>>
            <%=cm.cms("references_operator_starts")%>
          </option>
        </select>
        <%=cm.cmsInput( "references_operator_is")%>
        <%=cm.cmsInput( "references_operator_contains")%>
        <%=cm.cmsInput( "references_operator_starts")%>
        <%=cm.cmsLabel("operator")%>

        <label for="publisher" class="noshow">Publisher</label>
        <input size="80" id="publisher" name="publisher" value="<%=publisher%>" class="inputTextField" />
        <a href="javascript:choiceprenref('references-choice.jsp','publisher',0)"><img height="18" align="middle" alt="List of publishers starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>
        <br />
        <br />
        <div class="submit_buttons">
          <label for="reset" class="noshow"><%=cm.cms("reset_btn_label")%></label>
          <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset_btn_value")%>" class="inputTextField" title="<%=cm.cms("reset_btn_title")%>" />
          <%=cm.cmsLabel("reset_btn_label")%>
          <%=cm.cmsTitle("reset_btn_title")%>
          <%=cm.cmsInput("reset_btn_value")%>

          <label for="submit2" class="noshow"><%=cm.cms("search_btn_label")%></label>
          <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=cm.cms("search_btn_value")%>" title="<%=cm.cms("search_btn_title")%>" />
          <%=cm.cmsLabel("search_btn_label")%>
          <%=cm.cmsTitle("search_btn_title")%>
          <%=cm.cmsInput("search_btn_value")%>
        </div>
      </form>

      <%=cm.cmsMsg("references_page_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="references.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>