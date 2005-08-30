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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.sql.Connection,
                 java.sql.PreparedStatement,
                 java.sql.DriverManager,
                 java.sql.ResultSet"%>
<%@page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
<title>EUNIS Database Status page check</title>
</head>
<body>

<%
  String SQL = "SELECT * FROM EUNIS_WEB_CONTENT LIMIT 0,10";
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  Connection con;
  PreparedStatement ps;

  try
  {
    Class.forName(SQL_DRV);
    con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
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
  <h6>Eunis status</h6>
  <table border="1" style="Font-family:Arial;Font-size:12px" summary="Eunis status">
  <tr>
   <td>
    Tomcat status:
   </td>
   <td>
    OK
   </td>
  </tr>
  <tr>
   <td>
    MySQL status:
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