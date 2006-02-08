<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Error page (exception handler page) for the application. Invoked by servlet container (see web.xml).
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page isErrorPage="true"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
      WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("generic_404_title")%>
    </title>
  </head>
  <body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,error_page_01"/>
    </jsp:include>
    <br />
    <br />
    <%=cm.cmsText("generic_404_01")%>
    <a title="<%=cm.cms("error_send_feedback")%>" href="feedback.jsp"><%=cm.cmsText("generic_404_05")%></a>.
    <%=cm.cmsTitle("error_send_feedback")%>
    <br />
    <br />
    <strong>
      Resource not found.
    </strong>
    <br />
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="404.jsp" />
    </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>