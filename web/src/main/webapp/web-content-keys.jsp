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
  if ( operation.equalsIgnoreCase( "add" ) )
  {
    String idPage = request.getParameter( "idpage" );
    String contentData = request.getParameter( "contentData" );
    if ( !idPage.equalsIgnoreCase( "" ) && !contentData.equalsIgnoreCase( "" ) )
    {
      result = cm.insertContentJDBC( idPage, contentData, "", "en", SessionManager.getUsername(), false);
    }
    else
    {
      System.out.println( "web-content-keys: invalid values: idpage=" + idPage );
    }
  }
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
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
        <h1><%=cm.cmsPhrase("Web content editor")%></h1>

<!-- MAIN CONTENT -->
          <%
            if( SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT() )
            {
          %>
                <br />
                <%=cm.cmsPhrase("Use this page to add new content to the database.")%>
                <br />
                <br />
                <form name="contentManage" action="web-content-keys.jsp" method="POST" onsubmit="javascript: return validateForm();">
                  <input type="hidden" name="operation" value="add">
                  <label for="idpage"><%=cm.cmsPhrase("Id page")%>:</label>
                  <br />
                  <input title="<%=cm.cms("web_content_keys_04")%>" type="text" size="50" name="idpage" id="idpage" style="font-family:monospace,serif;" />
                  <br />
                  <label for="contentData"><%=cm.cmsPhrase("Content")%>:</label>
                  <br />
                  <textarea title="<%=cm.cms("content")%>" rows="5" cols="50" name="contentData" id="contentData" style="font-family:monospace,serif;"></textarea>
                  <br />
                  <br />
                  <input title="<%=cm.cms("insert_new_key")%>" type="submit" name="submit" id="sub1" value="<%=cm.cms("insert_new_key")%>" class="submitSearchButton" />
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
                  <%=cm.cmsPhrase("You do not have the proper privileges to access the functionality of this page.")%>
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
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
