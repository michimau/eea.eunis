<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitats, show references' function - Popup for list of values in search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksDomain,
                ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksPersist,
                ro.finsiel.eunis.search.Utilities" %>
<%@ page import="java.util.List" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=contentManagement.getContent("habitats_books-choice_title", false)%>
  </title>
  <script language="JavaScript" type="text/javascript">
  <!--
   function setLine(val) {
     window.opener.document.eunis.scientificName.value=val;
     window.close();
   }
    function editContent( idPage )
   {
     var url = "web-content-inline-editor.jsp?idPage=" + idPage;
     window.open( url ,'', "width=540,height=500,status=0,scrollbars=0,toolbar=0,resizable=1,location=0");
   }
  // -->
  </script>
</head>
<%// Get form parameters here%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.references.ReferencesBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Request parameter
  Integer database = Utilities.checkedStringToInt(request.getParameter("database"), HabitatsBooksDomain.SEARCH_EUNIS);

  HabitatsBooksDomain habitatsBooks = new HabitatsBooksDomain(formBean.toSearchCriteria(), database);
  // Set the result list
  List results = habitatsBooks.getHabitatsWithReferences(true);
%>
<body>
<%
  if(results != null && results.size() > 0) {
    out.print(Utilities.getTextMaxLimitForPopup(contentManagement, results.size()));
  }
%>
<%
  // On can display the title of this popup, if exist results
  if(results != null && results.size() > 0) {
%>
<h6>List of values for:</h6>
<u><%=contentManagement.getContent("habitats_books-choice_03")%></u>
<em><%=Utilities.ReturnStringRelatioOp(Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS))%></em>
<strong><%=formBean.getScientificName()%></strong>
<br />
<br />
<%
  }
  // If exist results, on dispayed it
  if(results != null && results.size() > 0) {
%>
<div id="tab">
  <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
    <tr>
      <th>
        Search results
      </th>
    </tr>
    <%  for(int i = 0; i < results.size(); i++) {
      HabitatsBooksPersist n = (HabitatsBooksPersist) results.get(i);
    %>
    <tr>
      <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
        <a title="Click link to select the value" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(n.getScientificName())%>');"><%=n.getScientificName()%></a>
      </td>
    </tr>
    <%
      }
    %>
  </table>
</div>
<%--    <%=Utilities.getTextMaxLimitForPopup((results == null ? 0 : results.size()))%>--%>
<%
} else {
%>
<strong>
  <%=contentManagement.getContent("habitats_books-choice_01")%>
</strong>
<br />
<br />
<%
  }
%>
<br />
<form action="">
  <label for="button" class="noshow">Close window</label>
  <input title="Close window" type="button" value="<%=contentManagement.getContent("habitats_books-choice_02", false)%>" onclick="javascript:window.close()" name="button" id="button" class="inputTextField" />
</form>
<%=contentManagement.writeEditTag("habitats_books-choice_02")%>
</body>
</html>
