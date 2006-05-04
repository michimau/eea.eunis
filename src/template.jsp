<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Template page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home#index.jsp,category_location#category.jsp"/>
        <jsp:param name="helpLink" value="help.jsp"/>
      </jsp:include>
      <img alt="Loading image" id="loading" src="images/loading.gif" />
<%
          out.flush();
%>
          <%=cm.cmsText("template_01")%>
<%
          out.flush();
%>
      <script language="JavaScript" type="text/javascript">
      <!--
        var load = document.getElementById( "loading" );
        load.style.display="none";
      //-->
      </script>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="template.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
<%
  out.flush();
%>
