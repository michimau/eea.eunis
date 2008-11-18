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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String datacount = "0";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,services#services.jsp,clear_temporary_data_btn";
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("clear_temporary_data_btn")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
<%
  // Check if user has Admin right
  if(!SessionManager.isAdmin())
  {
%>
                <h1>
                  <%=cm.cmsPhrase( "Clear temporary data" )%>
                </h1>
                <%=cm.cmsPhrase("You do not have Administrator rights, which are required to perform this operation.<br />Please login as Administrator first.")%>
                <br />
                <%=cm.cmsMsg("clear_temporary_data_btn")%>
<%
  }
  else
  {
%>
                <%=cm.cmsText("generic_clear-temporary-data_02")%>
                <br />
                <br />
                <form name="clearlog" method="post" action="clear-temporary-data.jsp">
                  <input type="submit" value="<%=cm.cms("clear_temporary_data_btn")%>" title="<%=cm.cms("clear_temporary_data_btn")%>" id="submit" name="submit" class="submitSearchButton" />
                  <%=cm.cmsInput("clear_temporary_data_btn")%>
                </form>
<%
    String SQL_DRV = application.getInitParameter("JDBC_DRV");
    String SQL_URL = application.getInitParameter("JDBC_URL");
    String SQL_USR = application.getInitParameter("JDBC_USR");
    String SQL_PWD = application.getInitParameter("JDBC_PWD");
    // If some of them is null, the wanted database operation isn't made

    if(request.getParameter("submit") != null)
    {
      if(request.getParameter("submit").equalsIgnoreCase(cm.cms("clear_temporary_data_btn")))
      {
        boolean result;
        try
        {
          // Delete all session data
          result = ro.finsiel.eunis.search.Utilities.ClearAllSessionsData(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
          if(!result)
          {
%>
                <%=cm.cmsPhrase("The temporary data could not be deleted.")%>
                <br />
<%
          }
          else
          {
%>
                <%=cm.cmsPhrase("The temporary data has been deleted.")%>
                <br />
<%
          }
        }
        catch(Exception e)
        {
          e.printStackTrace();
          return;
        }
      }
    }
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    try
    {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      String SQL;
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
      if(rs.next())
      {
        datacount = rs.getString(1);
      }
      rs.close();
      ps.close();
      con.close();
    }
    catch(Exception e)
    {
      e.printStackTrace();
      return;
    }
%>
                <br />
                <%=cm.cmsPhrase("Total number of rows containing temporary data detected in the database:")%>&nbsp;<strong><%=datacount%></strong>
                <br />
                <%=cm.cmsMsg("clear_temporary_data_btn")%>
<%
  }
%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="clear-temporary-data.jsp"/>
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
