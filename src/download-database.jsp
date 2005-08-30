<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display links to downloadable databases (zipped mdb etc.)
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("generic_download-database_title", false )%>
    </title>
    <jsp:include page="header-page.jsp" />
  </head>
  <body>
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Services#services.jsp,Download database"/>
    </jsp:include>
    <h5>
      <%=contentManagement.getContent("generic_download-database_01")%>
    </h5>
    <br />
    <a title="Download database" href="downloads/eunis.zip"><%=contentManagement.getContent("generic_download-database_02")%></a>
    <br />
    <br />
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="download-database.jsp" />
    </jsp:include>
  </body>
</html>
