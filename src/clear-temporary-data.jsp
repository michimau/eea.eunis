<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Clear temporary data from MySQL' function
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="java.sql.Connection,
                 java.sql.PreparedStatement,
                 java.sql.DriverManager,
                 java.sql.ResultSet,
                 ro.finsiel.eunis.WebContentManagement" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
    String datacount = "0";
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("generic_clear-temporary-data_title", false)%>
  </title>
</head>

<body>
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Services#services.jsp,Clear temporary data"/>
</jsp:include>
<div id="content">
<%
  // Check if user has Admin right
  if(!SessionManager.isAdmin()) {
%>
<%=contentManagement.getContent("generic_clear-temporary-data_01")%>
<br />
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="clear-temporary-data.jsp"/>
</jsp:include>
</body>
</html>
<%
    return;
  }
%>
<%=contentManagement.getContent("generic_clear-temporary-data_02")%>
<br />
<br />
<form name="clearlog" method="post" action="clear-temporary-data.jsp">
  <label for="submit" class="noshow">Clear</label>
  <input type="submit" value="Clear temporary data" title="Clear temporary data" id="submit" name="submit" class="inputTextField" />
</form>
<%
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");
  // If some of them is null, the wanted database operation isn't made

  if(request.getParameter("submit") != null) {
    if(request.getParameter("submit").equalsIgnoreCase("Clear temporary data")) {
      boolean result = false;
      try {
        // Delete all session data
        result = ro.finsiel.eunis.search.Utilities.ClearAllSessionsData(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
        if(!result) {
          %>
          <%=contentManagement.getContent("generic_clear-temporary-data_03")%>
          <br />
          <%
          } else {
          %>
          <%=contentManagement.getContent("generic_clear-temporary-data_04")%>
          <br />
          <%
        }
      }
      catch(Exception e) {
        e.printStackTrace();
        return;
      }
    }
  }

  Connection con = null;
  PreparedStatement ps = null;
  ResultSet rs = null;

  try {
    Class.forName(SQL_DRV);
    con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

    String SQL = "";
    // Find total number of rows containing temporary data detected in database
    SQL = "SELECT COUNT(*) FROM EUNIS_ADVANCED_SEARCH_RESULTS ";
    SQL += " UNION ";
    SQL += "SELECT COUNT(*) FROM EUNIS_ADVANCED_SEARCH_RESULTS ";
    SQL += " UNION ";
    SQL += "SELECT COUNT(*) FROM EUNIS_ADVANCED_SEARCH_TEMP ";
    SQL += " UNION ";
    SQL += "SELECT COUNT(*) FROM EUNIS_ADVANCED_SEARCH_CRITERIA ";
    SQL += " UNION ";
    SQL += "SELECT COUNT(*) FROM EUNIS_ADVANCED_SEARCH_CRITERIA_TEMP ";
    SQL += " UNION ";
    SQL += "SELECT COUNT(*) FROM EUNIS_COMBINED_SEARCH_RESULTS ";
    SQL += " UNION ";
    SQL += "SELECT COUNT(*) FROM EUNIS_COMBINED_SEARCH_RESULTS ";
    SQL += " UNION ";
    SQL += "SELECT COUNT(*) FROM EUNIS_COMBINED_SEARCH_TEMP ";
    SQL += " UNION ";
    SQL += "SELECT COUNT(*) FROM EUNIS_COMBINED_SEARCH_CRITERIA ";
    SQL += " UNION ";
    SQL += "SELECT COUNT(*) FROM EUNIS_COMBINED_SEARCH_CRITERIA_TEMP ";

    ps = con.prepareStatement(SQL);
    rs = ps.executeQuery();
    if(rs.next()) {
      datacount = rs.getString(1);
    }
    rs.close();
    ps.close();
    con.close();
  }
  catch(Exception e) {
    e.printStackTrace();
    return;
  }
%>
<br />
<%=contentManagement.getContent("generic_clear-temporary-data_05")%>&nbsp;<strong><%=datacount%></strong>
<br />
</div>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="clear-temporary-data.jsp"/>
</jsp:include>
</body>
</html>
