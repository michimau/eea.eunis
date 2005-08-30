<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species help.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">        
<%@ page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title><%=application.getInitParameter("PAGE_TITLE")%>Species search help</title>
  </head>
  <body style="background-color:#ffffff">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Help on EUNIS Database species" />
    </jsp:include>
    <%
      // Web content manager used in this page.
      WebContentManagement contentManagement = SessionManager.getWebContent();
      String paragraph01 = contentManagement.getContent("species_help_01");
      if (null != paragraph01) out.print(paragraph01);
    %>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-help.jsp" />
    </jsp:include>
  </div>
  </body>
</html>