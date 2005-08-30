<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Site map page
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%@page contentType="text/html" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title><%=application.getInitParameter("PAGE_TITLE")%>Site Map</title>
  </head>
  <body>
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,EUNIS Web Site Map"/>
    </jsp:include>
    <table summary="layout" width="100%" border="0">
      <tr>
        <td>
          <%=cm.getContent("generic_eunis-map_01")%>
        </td>
      </tr>
    </table>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="eunis-map.jsp" />
    </jsp:include>
    </div>
  </body>
</html>
