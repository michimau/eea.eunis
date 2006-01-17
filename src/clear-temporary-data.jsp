<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Clear temporary data from MySQL' function
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.sql.Connection,
                 java.sql.PreparedStatement,
                 java.sql.DriverManager,
                 java.sql.ResultSet,
                 ro.finsiel.eunis.WebContentManagement" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String datacount = "0";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("generic_clear-temporary-data_title")%>
    </title>
  </head>
  <body>
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,services_location#services.jsp,clear_temporary_data_location"/>
    </jsp:include>
    <div id="outline">
    <div id="alignment">
    <div id="content">
<%
    // Check if user has Admin right
    if(!SessionManager.isAdmin())
    {
%>
    <%=cm.cmsText("generic_clear-temporary-data_01")%>
    <br />
    <%=cm.cmsMsg("generic_clear-temporary-data_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="clear-temporary-data.jsp"/>
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
<%
    return;
  }
%>
  <%=cm.cmsText("generic_clear-temporary-data_02")%>
  <br />
  <br />
  <form name="clearlog" method="post" action="clear-temporary-data.jsp">
    <input type="submit" value="<%=cm.cms("clear_temporary_data_btn")%>" title="<%=cm.cms("clear_temporary_data_btn")%>" id="submit" name="submit" class="inputTextField" />
    <%=cm.cmsInput("clear_temporary_data_btn")%>
  </form>
<%
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");
  // If some of them is null, the wanted database operation isn't made

  if(request.getParameter("submit") != null) {
    if(request.getParameter("submit").equalsIgnoreCase(cm.cms("clear_temporary_data_btn"))) {
      boolean result = false;
      try {
        // Delete all session data
        result = ro.finsiel.eunis.search.Utilities.ClearAllSessionsData(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
        if(!result) {
          %>
          <%=cm.cmsText("generic_clear-temporary-data_03")%>
          <br />
          <%
          } else {
          %>
          <%=cm.cmsText("generic_clear-temporary-data_04")%>
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
      <%=cm.cmsText("generic_clear-temporary-data_05")%>&nbsp;<strong><%=datacount%></strong>
      <br />
      <%=cm.cmsMsg("generic_clear-temporary-data_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="clear-temporary-data.jsp"/>
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>