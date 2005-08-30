<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : News page
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%@page contentType="text/html" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title><%=application.getInitParameter("PAGE_TITLE")%>News</title>
  </head>
  <body>
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,EUNIS Database news"/>
    </jsp:include>
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <h5>
      Site News
    </h5>
    Use the following link to get latest news from EUNIS Database in RSS format:
    <a title="RSS News" target="_blank" href="news.xml">RSS News</a>
    <br />
    <br />
    <%=cm.getContent("news_main")%>
    <br />
    <br />
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="news.jsp" />
    </jsp:include>
  </div>
  </body>
</html>