<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Gis Tool Help page
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
      GIS Tool Help
    </title>
  </head>
  <body>
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,GIS Tool help"/>
    </jsp:include>
    <%=contentManagement.getContent("gis_tool_help_01")%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="about.jsp" />
    </jsp:include>
   </div>
  </body>
</html>
