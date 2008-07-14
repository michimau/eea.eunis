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
<%@ page import="ro.finsiel.eunis.WebContentManagement"%><%@ page import="ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,web_content_management_location";
  String operation = Utilities.formatString( request.getParameter( "operation" ), "" );
  boolean result = false;
  if ( operation.equalsIgnoreCase( "upload" ) )
  {
      String SQL_DRV = application.getInitParameter("JDBC_DRV");
      String SQL_URL = application.getInitParameter("JDBC_URL");
      String SQL_USR = application.getInitParameter("JDBC_USR");
      String SQL_PWD = application.getInitParameter("JDBC_PWD");
      result = cm.importNewTexts( "","en",SessionManager.getUsername(),SQL_DRV,SQL_URL,SQL_USR,SQL_PWD );
  }
%>
    <script type="text/javascript" language="javascript">
      //<![CDATA[
      function validateForm()
      {
        var idpage = document.getElementById( "idpage" );
        var contentData = document.getElementById( "contentData" );
        if ( idpage.value == "" || contentData.value == "" )
        {
          alert( "<%=cm.cms("web_content_keys_01")%>");
          return false;
        }
        return true;
      }
      //]]>
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
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
            if( SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT() )
            {
          %>    <h1>
                  	Upload new texts
                </h1>
                <br />
                	Pressing "Upload" button will upload new keys (as MD5 hash sums) from "new-texts.txt" file to EUNIS database.
                <br />
                <br />
                <form name="contentManage" action="import-new-texts.jsp" method="POST" onsubmit="javascript: return validateForm();">
                  <input type="hidden" name="operation" value="upload">
                  <input title="Upload" type="submit" name="submit" id="sub1" value="Upload" class="submitSearchButton" />
                </form>
                <br />
                <br />
          <%
              if( operation.equalsIgnoreCase( "upload" ) )
              {
                String message = "Upload sucessful!";
                if ( !result )
                {
                  message = "Upload failed!";
                }
                out.print( message );
              }
            }
            else
            {
          %>
                  <br />
                  <br />
                  <%=cm.cmsPhrase("You do not have the proper privileges to access the functionality of this page.")%>
                  <br />
                  <br />
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
                <jsp:param name="page_name" value="web-content-keys.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
