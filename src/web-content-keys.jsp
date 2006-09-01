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

  String operation = Utilities.formatString( request.getParameter( "operation" ), "" );
  boolean result = false;
  if ( operation.equalsIgnoreCase( "add" ) )
  {
    String idPage = request.getParameter( "idpage" );
    String contentData = request.getParameter( "contentData" );
    if ( !idPage.equalsIgnoreCase( "" ) && !contentData.equalsIgnoreCase( "" ) )
    {
      String SQL_DRV = application.getInitParameter("JDBC_DRV");
      String SQL_URL = application.getInitParameter("JDBC_URL");
      String SQL_USR = application.getInitParameter("JDBC_USR");
      String SQL_PWD = application.getInitParameter("JDBC_PWD");
      result = cm.insertContentJDBC( idPage, contentData, "", "en", SessionManager.getUsername(), false, SQL_DRV, SQL_URL, SQL_USR, SQL_PWD );
    }
    else
    {
      System.out.println( "web-content-keys: invalid values: idpage=" + idPage );
    }
  }
%>
    <script type="text/javascript" language="javascript">
      <!--
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
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
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
                  <jsp:param name="location" value="home#index.jsp,web_content_management_location"/>
                </jsp:include>
          <%
            if( SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT() )
            {
          %>    <h1>
                  <%=cm.cmsText("web_content_editor")%>
                </h1>
                <br />
                <%=cm.cmsText("web_content_keys_03")%>
                <br />
                <br />
                <form name="contentManage" action="web-content-keys.jsp" method="POST" onsubmit="javascript: return validateForm();">
                  <input type="hidden" name="operation" value="add">
                  <label for="idpage"><%=cm.cmsText("web_content_keys_04")%>:</label>
                  <br />
                  <input title="<%=cm.cms("web_content_keys_04")%>" type="text" size="50" name="idpage" id="idpage" style="font-family:monospace,serif;" />
                  <br />
                  <label for="contentData"><%=cm.cmsText("content")%>:</label>
                  <br />
                  <textarea title="<%=cm.cms("content")%>" rows="5" cols="50" name="contentData" id="contentData" style="font-family:monospace,serif;"></textarea>
                  <br />
                  <br />
                  <input title="<%=cm.cms("insert_new_key")%>" type="submit" name="submit" id="sub1" value="<%=cm.cms("insert_new_key")%>" class="searchButton" />
                  <%=cm.cmsTitle("insert_new_key")%>
                  <%=cm.cmsInput("insert_new_key")%>
                </form>
                <br />
                <br />
          <%
              if( operation.equalsIgnoreCase( "add" ) )
              {
                String message = cm.cms("web_content_keys_08");
                if ( !result )
                {
                  message = cm.cms("web_content_keys_09");
                }
                out.print( message );
              }
            }
            else
            {
          %>
                  <br />
                  <br />
                  <%=cm.cmsText("web_content_keys_10")%>
                  <br />
                  <br />
          <%
            }
          %>

          <%=cm.br()%>
          <%=cm.cmsMsg("web_content_keys_01")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("web_content_keys_08")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("web_content_keys_09")%>
          <%=cm.br()%>
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="template.jsp" />
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
