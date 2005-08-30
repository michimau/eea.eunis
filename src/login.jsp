<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Login page
--%>
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
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
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>Login into EUNIS Database
    </title>
  </head>
  <body>
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Login"/>
    </jsp:include>
    <div id="content">
      <h5>
        EUNIS Database Login
      </h5>
      <br />
    <div style="text-align : center; width : 740px;">
      <div style="width : 740px; text-align : center; padding : 15px;">
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
          <label for="username">Username:</label>
          <input class="inputTextField" title="Enter your username here" type="text" id="username" name="username" value="<%=(null != username) ? username : ""%>" />
          <br />
          <label for="password">Password:</label>
          <input class="inputTextField" title="Enter your password here" type="password" id="password" name="password" />
          <br />
          <br />
          <label for="submit" class="noshow">Login</label>
          <input class="inputTextField" title="Login to EUNIS Database" type="submit" id="submit" name="Submit" value="Login" />
        </form>

<%
    if ( cmd.equalsIgnoreCase( "login" ) && !success )
    {
%>
    <script type="text/javascript" language="Javascript">
      <!--
        alert( "Invalid username or password." );
      //-->
    </script>
<%
    }
  }
  else
  {
%>
    You successfully logged as
    <strong><%=SessionManager.getUsername()%></strong>.
    <a title="Home page" href="index.jsp">Home</a>
<%
  }
%>
      </div>
    </div>
    <br />
    <%=contentManagement.getContent("habitats_login-help_01")%>
    </div>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="index.jsp" />
    </jsp:include>
  </body>
</html>