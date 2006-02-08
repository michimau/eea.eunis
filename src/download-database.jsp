<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display links to downloadable databases (zipped mdb etc.)
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("generic_download-database_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,services_location#services.jsp,download_database_location"/>
    </jsp:include>
    <h1>
      <%=cm.cmsText("generic_download-database_01")%>
    </h1>
    <br />
    <a title="<%=cm.cms("generic_download-database_02")%>" href="downloads/eunis.zip"><%=cm.cmsText("generic_download-database_02")%></a>
    <br />
    <br />
    <%=cm.cmsMsg("generic_download-database_title")%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="download-database.jsp" />
    </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
