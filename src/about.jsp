<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : About page for the application.
  - Request params : -
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%@page contentType="text/html" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("generic_about_title", false )%>
    </title>
  </head>
  <body bgcolor="#ffffff">
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,About EUNIS Database"/>
    </jsp:include>
    <%=contentManagement.getContent("generic_about_01")%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="about.jsp" />
    </jsp:include>
    </div>
  </body>
</html>