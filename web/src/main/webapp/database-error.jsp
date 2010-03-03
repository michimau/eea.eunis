<%@ page import="ro.finsiel.eunis.search.Utilities, ro.finsiel.eunis.WebContentManagement" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Template page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
  		WebContentManagement cm = SessionManager.getWebContent();
	%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=Utilities.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <a name="documentContent"></a>
                <h1>
                  Database connection error
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
<!-- MAIN CONTENT -->
                <p>
                The EUNIS MySQL Database could not be opened.
                </p>
                <p>
                This can be a result of a:
		</p>
                <ul>
                <li>Server maintenance operation in progress</li>
                <li>Database maintenance operation in progress</li>
                <li>A communication error with the server</li>
                </ul>
                <p>
                We apologize for any inconvenience and thank you for your understanding!
                </p>
                <p>
                Please come back later.
                </p>
                <p>
                You can always contact us at: <a title="Send email to EUNIS team" href="mailto:eunis@eea.europa.eu">
                eunis@eea.europa.eu</a>
                </p>
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
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=Utilities.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
