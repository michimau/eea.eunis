<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitats, show references' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksDomain,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.references.ReferencesSearchCriteria,
                 java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-books.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/overlib.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_books_title", false)%>
  </title>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Pick habitat type show references" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
</jsp:include>
<div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
<form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="habitats-books-result.jsp">
<input type="hidden" name="typeForm" value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC%>" />
<table summary="Main content" width="100%" border="0">
<tr>
  <td>
    <table width="100%" border="0" align="center" summary="layout">
        <tr>
          <td>
            <h5>
              <%=contentManagement.getContent("habitats_books_01")%>
            </h5>
            <%=contentManagement.getContent("habitats_books_20")%>
            <br />
            <br />
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td bgcolor="#EEEEEE">
                  <strong>
                    <%=contentManagement.getContent("habitats_books_02")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td bgcolor="#EEEEEE">
                  <input type="checkbox" name="showAuthor" id="showAuthor" value="true" checked="checked" disabled="disabled" />
                  <label for="showAuthor"><%=contentManagement.getContent("habitats_books_03")%></label>
                  &nbsp;
                  <input type="checkbox" name="showDate" id="showDate" value="true" checked="checked" disabled="disabled" />
                  <label for="showDate"><%=contentManagement.getContent("habitats_books_04")%></label>
                  &nbsp;
                  <input type="checkbox" name="showTitle" id="showTitle" value="true" checked="checked" disabled="disabled" />
                  <label for="showTitle"><%=contentManagement.getContent("habitats_books_05")%></label>
                  &nbsp;
                  <input type="checkbox" name="showEditor" id="showEditor" value="true" checked="checked" disabled="disabled" />
                  <label for="showEditor"><%=contentManagement.getContent("habitats_books_06")%></label>
                  &nbsp;
                  <input type="checkbox" name="showPublisher" id="showPublisher" value="true" checked="checked" disabled="disabled" />
                  <label for="showPublisher"><%=contentManagement.getContent("habitats_books_07")%></label>
                  &nbsp;
                  <input type="checkbox" name="showSourceType" id="showSourceType" value="true" checked="checked" disabled="disabled" />
                  <label for="showSourceType">Source type</label>
                  &nbsp;
                  <input type="checkbox" name="showHabitatTypes" id="showHabitatTypes" value="true" checked="checked" disabled="disabled" />
                  <label for="showHabitatTypes">Habitat types</label>
                  &nbsp;
                </td>
              </tr>
            </table>
            <br />
          </td>
        </tr>
        <tr>
          <td align="left">
            <img alt="Mandatory" src="images/mini/field_mandatory.gif" align="middle" />
            &nbsp;
            <label for="scientificName"><strong><%=contentManagement.getContent("habitats_books_08")%></strong></label>
            &nbsp;
            <label for="relationOp" class="noshow">Operator</label>
            <select name="relationOp" id="relationOp" class="inputTextField" title="Operator">
              <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("habitats_books_09", false)%></option>
              <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_books_10", false)%></option>
              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("habitats_books_11", false)%></option>
            </select>
            <label for="scientificName" class="noshow">List of values</label>
            <input  align="middle" size="32" name="scientificName" id="scientificName" value="" class="inputTextField" title="Name" />
            <a title="List of values" href="javascript:openHelper('habitats-books-choice.jsp?')"><img align="middle" height="18" alt="<%=contentManagement.getContent("habitats_books_12", false )%>" src="images/helper/helper.gif" width="11" border="0" /></a>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <%=contentManagement.writeEditTag("habitats_books_12")%>
          </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr>
          <td align="left" bgcolor="#EEEEEE">
            <%=contentManagement.getContent("habitats_books_13")%>:&nbsp;
            <input type="radio" name="database" id="database1" value="<%=HabitatsBooksDomain.SEARCH_EUNIS%>" checked="checked" onmouseover="showtooltip('Habitats_Eunis')" onmouseout="hidetooltip()" />
            <label for="database1"><%=contentManagement.getContent("habitats_books_14")%></label>
            &nbsp;&nbsp;
            <input type="radio" name="database" id="database2" value="<%=HabitatsBooksDomain.SEARCH_ANNEX_I%>" onmouseover="showtooltip('Habitats_AnnexI')" onmouseout="hidetooltip()" />
            <label for="database2"><%=contentManagement.getContent("habitats_books_15")%></label>
            &nbsp;&nbsp;
            <input type="radio" name="database" id="database3" value="<%=HabitatsBooksDomain.SEARCH_BOTH%>" onmouseover="showtooltip('Habitats_Both')" onmouseout="hidetooltip()" />
            <label for="database3"><%=contentManagement.getContent("habitats_books_16")%></label>
          </td>
        </tr>
        <tr>
          <td align="right">
            <br />
            <label for="Reset" class="noshow">Reset values</label>
            <input type="reset" title="Reset fields" value="<%=contentManagement.getContent("habitats_books_17", false)%>" name="Reset" id="Reset" class="inputTextField" />
            <%=contentManagement.writeEditTag("habitats_books_17")%>
            <label for="submit2" class="noshow">Search</label>
            <input type="submit" title="Search" value="<%=contentManagement.getContent("habitats_books_18", false)%>" name="submit2" id="submit2" class="inputTextField" />
            <%=contentManagement.writeEditTag("habitats_books_18")%>
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
  <!--
  // values of this constants from specific class Domain
  var source1='';
  var source2='';
  var database1='<%=HabitatsBooksDomain.SEARCH_EUNIS%>';
  var database2='<%=HabitatsBooksDomain.SEARCH_ANNEX_I%>';
  var database3='<%=HabitatsBooksDomain.SEARCH_BOTH%>';
  //-->
  </script>
<script language="JavaScript" src="script/habitats-books-save-criteria.js" type="text/javascript"></script>
    <%=contentManagement.getContent("habitats_books_19")%>:
    <a href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-books.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');">
      <img alt="Save" border="0" src="images/save.jpg" width="21" height="19" align="middle" />
    </a>
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
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-books.jsp" />
</jsp:include>
  </div>
</body>
</html>