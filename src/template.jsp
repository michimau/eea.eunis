<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Template page
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
    </title>
  </head>
  <body>
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,category#category.jsp"/>
      <jsp:param name="helpLink" value="help.jsp"/>
    </jsp:include>
    <img alt="Loading image" id="loading" src="images/loading.gif" />
<%
          out.flush();
%>
          dynamic content
<%
          out.flush();
%>
    <script language="JavaScript" type="text/javascript">
    <!--
      var load = document.getElementById( "loading" );
      load.style.display="none";
    //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="template.jsp" />
    </jsp:include>
      </div>
  </body>
</html>
<%
  out.flush();
%>
