<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Users bookmarks save.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities,
                 ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  String username = SessionManager.getUsername();
  String action = Utilities.formatString( request.getParameter( "action" ), "" );
  String bookmarkURL = request.getParameter( "bookmarkURL" );
  String description = request.getParameter( "description" );

  SQLUtilities sql = new SQLUtilities();
  sql.Init( SQL_DRV, SQL_URL, SQL_USR, SQL_PWD );

  boolean result = false;
  if ( action.equalsIgnoreCase( "saveBookmark" ) )
  {
    //System.out.println( "description = " + description );
    result = sql.insertBookmark( username, bookmarkURL, description );
  }
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
        WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title><%=cm.cms("users_bookmarks_save_title")%></title>
    <script type="text/javascript" language="javascript">
      //<![CDATA[
        function validateForm()
        {
          var desc = document.saveBookmark.description.value;
          if ( desc == "" )
          {
            alert( "<%=cm.cms("users_bookmarks_save_01")%>");
            return false;
          }
          return true;
        }
      //]]>
    </script>
  </head>
  <body>
    <form name="saveBookmark" method="post" action="users-bookmarks-save.jsp" onsubmit="javascript: return validateForm();">
      <input type="hidden" name="action" value="saveBookmark" />
      <input type="hidden" name="bookmarkURL" value="<%=bookmarkURL%>" />
      <%=cm.cmsPhrase("Bookmark URL")%>:
      <span class="zebraeven">
        <%=bookmarkURL%>
      </span>
      <br />
      <br />
      <label for="description">
      <%=cm.cmsPhrase("Enter description for bookmark")%>:
      </label>
      <br />
      <textarea title="<%=cm.cms("description")%>" name="description" id="description" rows="6" cols="60"></textarea>
      <%=cm.cmsTitle("description")%>
      <br />      
      <input title="<%=cm.cmsPhrase("Save")%>" id="input1" type="submit" name="Save" value="<%=cm.cmsPhrase("Save")%>" class="saveButton" />
      <input title="<%=cm.cmsPhrase("Reset")%>" id="input2" type="reset" name="Reset" value="<%=cm.cmsPhrase("Reset")%>" class="standardButton" />
      <input title="<%=cm.cmsPhrase("Close window")%>" id="input3" type="button" name="Close" value="<%=cm.cmsPhrase("Close")%>" class="standardButton" onClick="window.close();" />
    </form>
<%
  if ( action.equalsIgnoreCase( "saveBookmark" ) )
  {
%>
      <script language="JavaScript" type="text/javascript">
        //<![CDATA[
<%
          if ( result )
          {
%>
            alert( "<%=cm.cms("users_bookmarks_save_04")%>");
<%
          }
          else
          {
%>
            alert( "<%=cm.cms("users_bookmarks_save_05")%>" );
<%
          }
%>
          this.close();
        //]]>
      </script>
<%
  }
%>

<%=cm.br()%>
<%=cm.cmsMsg("users_bookmarks_save_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_bookmarks_save_01")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_bookmarks_save_04")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_bookmarks_save_05")%>
<%=cm.br()%>

  </body>
</html>
