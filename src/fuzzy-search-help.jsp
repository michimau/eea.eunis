<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Fuzzy search help
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("sites_help_title")%>
  </title>
</head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp, help_on_fuzzy_search_location"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <h1><%=cm.cmsText("help_on_fuzzy_search")%></h1>
      <br />
      <a href="javascript:history.go(-1);" title="<%=cm.cms("return_to_previous_page")%>"><%=cm.cmsText("back")%></a><%=cm.cmsTitle("return_to_previous_page")%>
      <br />
      <br />
      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <%=cm.cmsText("help_on_fuzzy_search_01")%>
          </td>
        </tr>
      </table>
      <br />
      <a href="javascript:history.go(-1);" title="<%=cm.cms("return_to_previous_page")%>"><%=cm.cms("back")%></a>
      <br />
      <%=cm.cmsMsg("sites_help_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-help.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
