<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Site map page
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
    <title><%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("site_map_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home#index.jsp,site_map_location"/>
    </jsp:include>
    <table summary="layout" width="100%" border="0">
      <tr>
        <td>
          <%=cm.cmsText("generic_eunis-map_01")%>
        </td>
      </tr>
    </table>
    <%=cm.cmsMsg("site_map_title")%>
    <%=cm.br()%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="eunis-map.jsp" />
    </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
