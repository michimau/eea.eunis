<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Error page (exception handler page) for the application. Invoked by servlet container (see web.xml).
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html"%>
<%@ page isErrorPage="true"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("generic_404_title", false )%>
    </title>
  </head>
  <body>
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Error page"/>
    </jsp:include>
    <br />
    <br />
    <%=contentManagement.getContent("generic_404_01")%>
    <a title="Send feedback" href="feedback.jsp"><%=contentManagement.getContent("generic_404_05")%></a>.
    <br />
    <br />
    <%=contentManagement.getContent("generic_404_04")%>
    <br />
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="404.jsp" />
    </jsp:include>
    </div>
  </body>
</html>