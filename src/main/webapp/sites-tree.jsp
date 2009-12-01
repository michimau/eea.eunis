<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2006 EEA - European Environment Agency.
  - Description : Sites tree
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");  
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="ro.finsiel.eunis.search.sites.SitesSearchUtility"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,sites_tree_browser";
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_tree_browser")%>
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
                    <li>
                      <a href="help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <h1>
                  <%=cm.cmsPhrase("Sites browser")%>
                </h1>
                <p class="documentDescription">
                <%=cm.cmsPhrase("Sites grouped by description")%>
                </p>
          <%
            String idSource = Utilities.formatString( request.getParameter( "idSource" ), "" );
            String idDesignation = Utilities.formatString( request.getParameter( "idDesignation" ), "" );
            String idGeoscope = Utilities.formatString( request.getParameter( "idGeoscope" ), "" );

            String SQL_DRV = application.getInitParameter("JDBC_DRV");
            String SQL_URL = application.getInitParameter("JDBC_URL");
            String SQL_USR = application.getInitParameter("JDBC_USR");
            String SQL_PWD = application.getInitParameter("JDBC_PWD");

            SQLUtilities sqlc = new SQLUtilities();
            sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

            String strSQL = "";

            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            PreparedStatement ps2 = null;
            ResultSet rs2 = null;
            PreparedStatement ps3 = null;
            ResultSet rs3 = null;

            strSQL = "SELECT ID_DESIGNATION, CHM62EDT_DESIGNATIONS.ID_GEOSCOPE, DESCRIPTION, AREA_NAME_EN";
            strSQL = strSQL + " FROM CHM62EDT_DESIGNATIONS, CHM62EDT_COUNTRY";
            strSQL = strSQL + " WHERE CHM62EDT_DESIGNATIONS.ID_GEOSCOPE = CHM62EDT_COUNTRY.ID_GEOSCOPE";
            strSQL = strSQL + " AND LENGTH(DESCRIPTION)>0";
            strSQL = strSQL + " ORDER BY DESCRIPTION ASC, AREA_NAME_EN ASC";

            try
            {
              Class.forName( SQL_DRV );
              con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

              ps = con.prepareStatement( strSQL );
              rs = ps.executeQuery();
          %>
              <ul>
          <%
                while ( rs.next() )
                {
          %>
                <li>
                <a href="designations-factsheet.jsp?idDesign=<%=rs.getString("ID_DESIGNATION")%>&amp;geoscope=<%=rs.getString("ID_GEOSCOPE")%>#position"><%=rs.getString("DESCRIPTION")%></a> <%=rs.getString("AREA_NAME_EN")%> (<%=rs.getString("ID_DESIGNATION")%>)
                </li>
<%
                }
%>
              </ul>
          <%
              rs.close();
              ps.close();
              con.close();
            }
            catch ( Exception e )
            {
              e.printStackTrace();
              return;
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
                <jsp:param name="page_name" value="sites-tree.jsp" />
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
