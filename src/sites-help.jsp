<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Help page for sites module
--%>
<%@ page contentType="text/html"%>
<%@page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_help_title", false )%></title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp, Sites#sites.jsp,Help on EUNIS Database sites"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <%=contentManagement.getContent("sites_help_01")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-help.jsp" />
      </jsp:include>
    </div>
  </body>
</html>