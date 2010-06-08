<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2006 EEA - European Environment Agency.
  - Description : Annex I habitat types tree
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,habitats_annex1_tree_location";
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <link rel="StyleSheet" href="css/tree.css" type="text/css" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("habitats_annex1-browser_title")%>
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
                  <jsp:param name="location" value="<%=btrail%>" />
                </jsp:include>
                <a name="documentContent"></a>
<!-- MAIN CONTENT -->
                <h1>
                  <%=cm.cmsPhrase("Habitat Annex I Directive hierarchical view: (higher levels are for grouping only)")%>
                </h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cmsPhrase("Print this page")%>"
                            title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cmsPhrase("Toggle full screen mode")%>"
                             title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                    </li>
                  </ul>
                </div>
                <br/>
          <%
            String expand = Utilities.formatString( request.getParameter( "expand" ), "" );

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
            PreparedStatement ps4 = null;
            ResultSet rs4 = null;
            PreparedStatement ps5 = null;
            ResultSet rs5 = null;

            try
            {
              Class.forName( SQL_DRV );
              con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

              //we display root nodes
              strSQL = "SELECT ID_HABITAT, SCIENTIFIC_NAME, CODE_2000";
              strSQL = strSQL + " FROM CHM62EDT_HABITAT";
              strSQL = strSQL + " WHERE LENGTH(CODE_2000)=1";
              strSQL = strSQL + " AND CODE_2000<>'-'";
              strSQL = strSQL + " ORDER BY CODE_2000 ASC";

              ps = con.prepareStatement( strSQL );
              rs = ps.executeQuery();
              
              String hide = cm.cmsPhrase("Hide sublevel habitat types");
              String show = cm.cmsPhrase("Show sublevel habitat types");

          %>
              <ul class="tree">
          <%
              while(rs.next())
              {
          %>
                <li>
                  <% if(Utilities.expandContains(expand,rs.getString("CODE_2000").substring(0,1))){ %>
	                <a title="<%=hide%>" id="level_<%=rs.getString("CODE_2000")%>" href="habitats-annex1-browser.jsp?expand=<%=Utilities.removeFromExpanded(expand,rs.getString("CODE_2000").substring(0,1))%>#level_<%=rs.getString("CODE_2000")%>"><img src="images/img_minus.gif" alt="<%=hide%>"/></a>
                  <% } else { %>
                    <a title="<%=show%>" id="level_<%=rs.getString("CODE_2000")%>" href="habitats-annex1-browser.jsp?expand=<%=Utilities.addToExpanded(expand,rs.getString("CODE_2000").substring(0,1))%>#level_<%=rs.getString("CODE_2000")%>"><img src="images/img_plus.gif" alt="<%=show%>"/></a>
                  <% } %>
                  <a title="<%=rs.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs.getString("ID_HABITAT")%>"><%=rs.getString("CODE_2000")%> : <%=rs.getString("SCIENTIFIC_NAME")%></a><br/>
                  <%
                  //we begin to display the tree
	              if(expand.length()>0 && Utilities.expandContains(expand,rs.getString("CODE_2000").substring(0,1))) {
	                strSQL = "SELECT ID_HABITAT, SCIENTIFIC_NAME, CODE_2000";
	                strSQL = strSQL + " FROM CHM62EDT_HABITAT";
	                strSQL = strSQL + " WHERE CODE_2000 LIKE '"+rs.getString("CODE_2000").substring(0,1)+"%00'";
	                strSQL = strSQL + " ORDER BY CODE_2000 ASC";
	
	                ps2 = con.prepareStatement( strSQL );
	                rs2 = ps2.executeQuery();
	
	%>
	                <ul class="tree">
	<%
	                while(rs2.next())
	                {
	%>
	                  <li>
	<%
	                  if(sqlc.Annex1HabitatHasChilds(rs2.getString("CODE_2000").substring(0,rs2.getString("CODE_2000").length()-2),rs2.getString("CODE_2000"))) {
	%>					<% if(Utilities.expandContains(expand,rs2.getString("CODE_2000").substring(0,2))){ %>
		                  <a title="<%=hide%>" id="level_<%=rs2.getString("CODE_2000")%>" href="habitats-annex1-browser.jsp?expand=<%=Utilities.removeFromExpanded(expand,rs2.getString("CODE_2000").substring(0,2))%>#level_<%=rs2.getString("CODE_2000")%>"><img src="images/img_minus.gif" alt="<%=hide%>"/></a>
	                    <% } else { %>
	                      <a title="<%=show%>" id="level_<%=rs2.getString("CODE_2000")%>" href="habitats-annex1-browser.jsp?expand=<%=Utilities.addToExpanded(expand,rs2.getString("CODE_2000").substring(0,2))%>#level_<%=rs2.getString("CODE_2000")%>"><img src="images/img_plus.gif" alt="<%=show%>"/></a>
	                    <% } %>
	                    <a title="<%=rs2.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs2.getString("ID_HABITAT")%>"><%=rs2.getString("CODE_2000")%> : <%=rs2.getString("SCIENTIFIC_NAME")%></a><br/>
	<%
	                  } else {
	%>
	                    <img src="images/img_bullet.gif" alt="<%=rs2.getString("SCIENTIFIC_NAME")%>"/>&nbsp;<a title="<%=rs2.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs2.getString("ID_HABITAT")%>"><%=rs2.getString("CODE_2000")%> : <%=rs2.getString("SCIENTIFIC_NAME")%></a><br/>
	<%
	                  }
	
	                   if(expand.length()>0 && Utilities.expandContains(expand,rs2.getString("CODE_2000").substring(0,2))) {
	                     strSQL = "SELECT ID_HABITAT, SCIENTIFIC_NAME, CODE_2000";
	                     strSQL = strSQL + " FROM CHM62EDT_HABITAT";
	                     strSQL = strSQL + " WHERE CODE_2000 LIKE '"+rs2.getString("CODE_2000").substring(0,2)+"%0'";
	                     strSQL = strSQL + " AND CODE_2000 NOT LIKE '"+rs2.getString("CODE_2000").substring(0,2)+"%00'";
	                     strSQL = strSQL + " ORDER BY CODE_2000 ASC";
	
	                     ps4 = con.prepareStatement( strSQL );
	                     rs4 = ps4.executeQuery();
	
	%>
	                     <ul class="tree">
	<%
	                     while(rs4.next())
	                     {
	%>
	                       <li>
	<%
	                       if(sqlc.Annex1HabitatHasChilds(rs4.getString("CODE_2000").substring(0,rs4.getString("CODE_2000").length()-1),rs4.getString("CODE_2000"))) {
	%>						  <% if(Utilities.expandContains(expand,rs4.getString("CODE_2000").substring(0,4))){ %>
			                    <a title="<%=hide%>" id="level_<%=rs4.getString("CODE_2000")%>" href="habitats-annex1-browser.jsp?expand=<%=Utilities.removeFromExpanded(expand,rs4.getString("CODE_2000").substring(0,4))%>#level_<%=rs4.getString("CODE_2000")%>"><img src="images/img_minus.gif" alt="<%=hide%>"/></a>
		                      <% } else { %>
		                        <a title="<%=show%>" id="level_<%=rs4.getString("CODE_2000")%>" href="habitats-annex1-browser.jsp?expand=<%=Utilities.addToExpanded(expand,rs4.getString("CODE_2000").substring(0,4))%>#level_<%=rs4.getString("CODE_2000")%>"><img src="images/img_plus.gif" alt="<%=show%>"/></a>
		                      <% } %>
	                          <a title="<%=rs4.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs4.getString("ID_HABITAT")%>"><%=rs4.getString("CODE_2000")%> : <%=rs4.getString("SCIENTIFIC_NAME")%></a><br/>
	<%
	                       } else {
	%>
	                         <img src="images/img_bullet.gif" alt="<%=rs4.getString("SCIENTIFIC_NAME")%>"/>&nbsp;<a title="<%=rs4.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs4.getString("ID_HABITAT")%>"><%=rs4.getString("CODE_2000")%> : <%=rs4.getString("SCIENTIFIC_NAME")%></a><br/>
	<%
	                       }
	                       if(expand.length()>0 && Utilities.expandContains(expand,rs4.getString("CODE_2000").substring(0,4))) {
	                         strSQL = "SELECT ID_HABITAT, SCIENTIFIC_NAME, CODE_2000";
	                         strSQL = strSQL + " FROM CHM62EDT_HABITAT";
	                         strSQL = strSQL + " WHERE CODE_2000 LIKE '"+rs4.getString("CODE_2000").substring(0,4)+"%'";
	                         strSQL = strSQL + " AND CODE_2000 NOT LIKE '"+rs4.getString("CODE_2000").substring(0,4)+"%0'";
	                         strSQL = strSQL + " ORDER BY CODE_2000 ASC";
	
	                         ps5 = con.prepareStatement( strSQL );
	                         rs5 = ps5.executeQuery();
	
	%>
	                         <ul class="tree">
	<%
	                         while(rs5.next())
	                         {
	%>
	                           <li>
	                             <img src="images/img_bullet.gif" alt="<%=rs4.getString("SCIENTIFIC_NAME")%>"/>&nbsp;<a title="<%=rs5.getString("SCIENTIFIC_NAME")%>" href="habitats/<%=rs5.getString("ID_HABITAT")%>"><%=rs5.getString("CODE_2000")%> : <%=rs5.getString("SCIENTIFIC_NAME")%></a><br/>
	                           </li>
	<%
	                         }
	%>
	                         </ul>
	<%
	
	                         rs5.close();
	                         ps5.close();
	                       }
	%>
	                       </li>
	<%
	                     }
	%>
	                     </ul>
	<%
	
	                     rs4.close();
	                     ps4.close();
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
                  %>
                </li>
          <%
              }
          %>
              </ul>
              <%=cm.cmsTitle("Show sublevel habitat types")%>
              <%=cm.br()%>
              <%=cm.cmsTitle("Hide sublevel habitat types")%>
          <%

              rs.close();
              ps.close();

              out.println("<br/><br/>");

              

              con.close();
            }
            catch ( Exception e )
            {
              e.printStackTrace();
              return;
            }

%>
                <br/>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="habitats-annex1-browser.jsp" />
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
