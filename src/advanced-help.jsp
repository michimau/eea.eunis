<%--
  - Author(s)   : EUNIS Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Help page for the 'Advanced search' function.
  - Request params : -
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("generic_advanced-help_title", false)%>
  </title>
</head>

<body bgcolor="#ffffff">
<div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Help on advanced search"/>
</jsp:include>
<%=contentManagement.getContent("generic_advanced-help_01")%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="advanced-help.jsp"/>
</jsp:include>
</div>
</body>
</html>