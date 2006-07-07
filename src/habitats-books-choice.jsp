<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitats, show references' function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksDomain,
                ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksPersist,
                ro.finsiel.eunis.search.Utilities" %>
<%@ page import="java.util.List" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=cm.cms("list_of_values")%>
  </title>
  <script language="JavaScript" type="text/javascript">
  <!--
   function setLine(val) {
     window.opener.document.eunis.scientificName.value=val;
     window.close();
   }
  // -->
  </script>
</head>
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
    out.print(Utilities.getTextMaxLimitForPopup(cm, results.size()));
  }
%>
<%
  // On can display the title of this popup, if exist results
  if(results != null && results.size() > 0) {
%>
<h2><%=cm.cmsText("list_of_values_for")%></h2>
<u><%=cm.cmsText("habitat_type_name")%></u>
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
  <table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
    <tr>
      <th>
        <%=cm.cmsText("search_results")%>
      </th>
    </tr>
    <%  for(int i = 0; i < results.size(); i++) {
      HabitatsBooksPersist n = (HabitatsBooksPersist) results.get(i);
    %>
    <tr>
      <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
        <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(n.getScientificName())%>');"><%=n.getScientificName()%></a>
        <%=cm.cmsTitle("click_link_to_select_value")%>
      </td>
    </tr>
    <%
      }
    %>
  </table>
</div>
<%
} else {
%>
<strong>
  <%=cm.cmsText("no_results_found_1")%>
</strong>
<br />
<br />
<%
  }
%>
<br />
<form action="">
  <input title="<%=cm.cms("close_window")%>" type="button" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" name="button" id="button" class="standardButton" />
  <%=cm.cmsInput("close_btn")%>
</form>
<%=cm.cmsMsg("list_of_values")%>
<%=cm.br()%>
<%=cm.cmsMsg("list_of_values")%>
<%=cm.br()%>
</body>
</html>
