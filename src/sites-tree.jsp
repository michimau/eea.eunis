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
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_SERVER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
                <br clear="all" />
<!-- MAIN CONTENT -->
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="home#index.jsp,sites#sites.jsp,sites_tree_browser"/>
                  <jsp:param name="helpLink" value="help.jsp"/>
                </jsp:include>
                <h1>
                  <%=cm.cmsText("sites_tree_browser")%>
                </h1>
                <br/>
                <%=cm.cmsText("sites_tree_browser_explanation")%>
                <br/>
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
            strSQL = strSQL + " ORDER BY DESCRIPTION ASC";

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
          <%      if(sqlc.DesignationHasSites(rs.getString("ID_DESIGNATION"),rs.getString("ID_GEOSCOPE"))) {
          %>
                  <a title="<%=rs.getString("DESCRIPTION")%>" href="sites-tree.jsp?idDesignation=<%=rs.getString("ID_DESIGNATION")%>&amp;idGeoscope=<%=rs.getString("ID_GEOSCOPE")%>#position"><%=rs.getString("DESCRIPTION")%> (<%=rs.getString("AREA_NAME_EN")%>)</a>
                  &nbsp;
                  [<a title="<%=rs.getString("DESCRIPTION")%>" href="designations-factsheet.jsp?idDesign=<%=rs.getString("ID_DESIGNATION")%>&amp;geoscope=<%=rs.getString("ID_GEOSCOPE")%>#position"><%=cm.cmsText("open_designation_factsheet")%></a>]
          <%
                  //now check if we expand source databases

                  if(idDesignation.length()>0 && idGeoscope.length()>0) {
                    if(rs.getString("ID_DESIGNATION").equalsIgnoreCase(idDesignation) && rs.getString("ID_GEOSCOPE").equalsIgnoreCase(idGeoscope))  {
                      // we calculate and display count of sites group by source database

                      strSQL = "SELECT SOURCE_DB, COUNT(*) AS RECORD_COUNT";
                      strSQL = strSQL + " FROM `chm62edt_sites`";
                      strSQL = strSQL + " INNER JOIN `chm62edt_designations` ON (`chm62edt_sites`.ID_DESIGNATION = `chm62edt_designations`.ID_DESIGNATION AND `chm62edt_sites`.ID_GEOSCOPE = `chm62edt_designations`.ID_GEOSCOPE)";
                      strSQL = strSQL + " WHERE `chm62edt_sites`.ID_DESIGNATION = '" + idDesignation + "'";
                      strSQL = strSQL + " AND `chm62edt_sites`.ID_GEOSCOPE = " + idGeoscope;
                      strSQL = strSQL + " GROUP BY `chm62edt_sites`.ID_DESIGNATION, `chm62edt_sites`.ID_GEOSCOPE";
                      strSQL = strSQL + " ORDER BY SOURCE_DB ASC";

                      ps2 = con.prepareStatement( strSQL );
                      rs2 = ps2.executeQuery();
          %>
                      <ul>
          <%
                      while ( rs2.next() )
                      {
          %>
                      <li>
                        <a name="position"></a><a title="<%=SitesSearchUtility.translateSourceDB(rs2.getString("SOURCE_DB"))%>" href="sites-tree.jsp?idDesignation=<%=rs.getString("ID_DESIGNATION")%>&amp;idGeoscope=<%=rs.getString("ID_GEOSCOPE")%>&amp;idSource=<%=rs2.getString("SOURCE_DB")%>#position"><%=SitesSearchUtility.translateSourceDB(rs2.getString("SOURCE_DB"))%> (<%=rs2.getString("RECORD_COUNT")%> records.)</a>
          <%
                        //we check to see if we need to display sites
                        if(idSource.length()>0) {
                          strSQL = "SELECT ID_SITE, NAME";
                          strSQL = strSQL + " FROM `chm62edt_sites`";
                          strSQL = strSQL + " WHERE `chm62edt_sites`.ID_DESIGNATION = '" + idDesignation + "'";
                          strSQL = strSQL + " AND `chm62edt_sites`.ID_GEOSCOPE = " + idGeoscope;
                          strSQL = strSQL + " AND `chm62edt_sites`.SOURCE_DB = '" + idSource + "'";
                          strSQL = strSQL + " ORDER BY NAME ASC";

                          ps3 = con.prepareStatement( strSQL );
                          rs3 = ps3.executeQuery();
          %>
                          <ul>
          <%
                          while ( rs3.next() )
                          {
          %>
                            <li>
                              <a title="<%=rs3.getString("NAME")%>" href="sites-factsheet.jsp?idsite=<%=rs3.getString("ID_SITE")%>"><%=rs3.getString("NAME")%></a>
                            </li>
          <%              }

          %>
                          </ul>
          <%
                          rs3.close();
                          ps3.close();
                        }
          %>
                      </li>
          <%
                      }
          %>
                      </ul>
          <%
                      rs2.close();
                      ps2.close();
                    }
                  }
                } else {
          %>
                <%=rs.getString("DESCRIPTION")%>
                &nbsp;
                [<a title="<%=rs.getString("DESCRIPTION")%>" href="designations-factsheet.jsp?idDesign=<%=rs.getString("ID_DESIGNATION")%>&amp;geoscope=<%=rs.getString("ID_GEOSCOPE")%>#position"><%=cm.cmsText("open_designation_factsheet")%></a>]
<%
                }
%>
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
                <br/>
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="sites-tree.jsp" />
                </jsp:include>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp" />
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_SERVER" ) )%>
    </div>
  </body>
</html>