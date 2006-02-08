<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Login page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  boolean success = false;
  String username = request.getParameter( "username" );
  String cmd = Utilities.formatString( request.getParameter( "cmd" ), "" );
  String ref = request.getParameter( "ref" );
  // If cmd is login.
  if ( cmd.equalsIgnoreCase( "login" ) )
  {
    SessionManager.logout();
    try
    {
      String password = request.getParameter( "password" );
      success = ( null != username && null != password ) && SessionManager.login( username, password, request );
      SessionManager.setCurrentLanguage( SessionManager.getUserPrefs().getLang() );
    }
    catch ( Exception e )
    {
      e.printStackTrace();
      success = false;
    }
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>" lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("login_page_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,login_location"/>
      </jsp:include>
      <h1>
        <%=cm.cmsText("login_title")%>
      </h1>
      <br />
      <div style="text-align : center; width : 100%">
<%
  if ( !success )
  {
%>
        <form name="login" method="post" action="login.jsp">
          <input type="hidden" name="cmd" value="login" />
<%
      if( ref != null )
      {
%>
          <input type="hidden" name="ref" value="<%=ref%>" />
<%
      }
%>
          <label for="username"><%=cm.cms("login_username_label")%>:</label>
          <input class="inputTextField" title="<%=cm.cms("login_username_title")%>" type="text" id="username" name="username" value="<%=(null != username) ? username : ""%>" />
          <%=cm.cmsTitle("login_username_title")%>
          <%=cm.cmsLabel("login_username_label")%>
          <br />
          <label for="password"><%=cm.cms("login_password_label")%>:</label>
          <input class="inputTextField" title="<%=cm.cms("login_password_title")%>" type="password" id="password" name="password" />
          <%=cm.cmsTitle("login_password_title")%>
          <%=cm.cmsLabel("login_password_label")%>
          <br />
          <br />
          <input class="inputTextField" title="<%=cm.cms("login_submit_title")%>" type="submit" id="submit" name="Submit" value="<%=cm.cms("login_submit_value")%>" />
          <%=cm.cmsTitle("login_submit_title")%>
          <%=cm.cmsInput("login_submit_value")%>
        </form>

<%
    if ( cmd.equalsIgnoreCase( "login" ) && !success )
    {
%>
    <script type="text/javascript" language="Javascript">
      <!--
        alert( "<%=cm.cms("login_invalid")%>." );
      //-->
    </script>
<%
    }
  }
  else
  {
%>
    <%=cm.cmsText("login_you_successfully_logged")%>
    <strong><%=SessionManager.getUsername()%></strong>.
    <a title="<%=cm.cms("login_home_title")%>" href="index.jsp"><%=cm.cmsText("login_home")%></a>
    <%=cm.cmsTitle("login_home_title")%>
<%
  }
%>
      </div>
    <br />
    <%=cm.cmsText("habitats_login-help_01")%>

    <%=cm.cmsMsg("login_page_title")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("login_invalid")%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="index.jsp" />
    </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>