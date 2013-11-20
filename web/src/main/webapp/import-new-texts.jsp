<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Template page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%><%@ page import="ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />

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

<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE")%>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
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
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1>Upload new texts</h1>

<!-- MAIN CONTENT -->
          <%
            if( SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT() )
            {
          %>
                <p>
                	Pressing "Upload" button will upload new keys (as MD5 hash sums) from "new-texts.txt" file to EUNIS database.
                </p>

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
    </stripes:layout-component>
</stripes:layout-render>