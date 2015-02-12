<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2005 EEA - European Environment Agency.
  - Description : Page to be used from Nagios to check EUNIS web status.
  - Request params : "hide"
    -- if hide parameter is missing or equal to "false", a page containing "TRUE" or "FALSE" is displayed
    -- if hide parameter is equal to "true", a page containing more details on EUNIS web status is displayed
  If the database connection does not work, error 500 is thrown by Tomcat
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.sql.Connection,
                 java.sql.PreparedStatement,
                 java.sql.DriverManager,
                 java.sql.ResultSet"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
<%
    WebContentManagement cm = SessionManager.getWebContent();
%>
<title><%=cm.cmsPhrase("EUNIS Database Status page check")%></title>
</head>
<body>

<%
  String SQL = "SELECT * FROM eunis_web_content LIMIT 0,10";
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  Connection con;
  PreparedStatement ps;

  try
  {
    Class.forName(SQL_DRV);
    con = ro.finsiel.eunis.utilities.TheOneConnectionPool.getConnection(SQL_URL, SQL_USR, SQL_PWD);
    if (SQL.length() > 0)
    {
      ResultSet rs;
      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();
      if (rs.next()) {
      }
      rs.close();
      ps.close();
    }
    con.close();
  }
  catch (Exception e)
  {
    response.sendError( 500 );
  }
  String hide = request.getParameter("hide");
  if (null != hide && hide.equalsIgnoreCase("true"))
  {
  // If full details are show on page
  %>
  <h2><%=cm.cmsPhrase("Eunis status")%></h2>
  <table border="1" style="Font-family:Arial;Font-size:12px" summary="Eunis status">
  <tr>
   <td>
    <%=cm.cmsPhrase("Tomcat status")%>:
   </td>
   <td>
    OK
   </td>
  </tr>
  <tr>
   <td>
    <%=cm.cmsPhrase("MySQL status")%>:
   </td>
   <td>
    OK
   </td>
  </tr>
  </table>
<%
  }
  else
  {
    // If only TRUE/FALSE is shown
%>
    <br /><span style="Font-family:Arial;Font-size:12px">True</span><br />
<%
  }
%>

</body>
</html>
