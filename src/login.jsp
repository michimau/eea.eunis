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
                  <jsp:param name="location" value="home#index.jsp,login"/>
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
                    <input title="<%=cm.cms("login_username_title")%>" type="text" id="username" name="username" value="<%=(null != username) ? username : ""%>" />
                    <%=cm.cmsTitle("login_username_title")%>
                    <%=cm.cmsLabel("login_username_label")%>
                    <br />
                    <label for="password"><%=cm.cms("password")%>:</label>
                    <input title="<%=cm.cms("login_password_title")%>" type="password" id="password" name="password" />
                    <%=cm.cmsTitle("login_password_title")%>
                    <%=cm.cmsLabel("password")%>
                    <br />
                    <br />
                    <input class="searchButton" title="<%=cm.cms("login_submit_title")%>" type="submit" id="submit" name="Submit" value="<%=cm.cms("login")%>" />
                    <%=cm.cmsTitle("login_submit_title")%>
                    <%=cm.cmsInput("login")%>
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
              <a title="<%=cm.cms("home_page")%>" href="index.jsp"><%=cm.cmsText("home")%></a>
              <%=cm.cmsTitle("home_page")%>
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
