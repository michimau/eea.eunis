<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Users bookmarks save.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities,
                 ro.finsiel.eunis.search.Utilities"%>
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
    <title>Save bookmark</title>
    <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
      <!--
        function validateForm()
        {
          var desc = document.saveBookmark.description.value;
          if ( desc == "" )
          {
            alert( "Please enter description for bookmark");
            return false;
          }
          return true;
        }
      //-->
    </script>
  </head>
  <body>
    <form name="saveBookmark" method="post" action="users-bookmarks-save.jsp" onsubmit="javascript: return validateForm();">
      <input type="hidden" name="action" value="saveBookmark" />
      <input type="hidden" name="bookmarkURL" value="<%=bookmarkURL%>" />
      Bookmark URL:
      <span style="background-color : #EEEEEE">
        <%=bookmarkURL%>
      </span>
      <br />
      <br />
      <label for="description">
      Enter description for bookmark:
      </label>
      <br />
      <textarea title="Description" name="description" id="description" rows="6" cols="60"  class="inputTextField"></textarea>
      <br />
      <label for="input1" class="noshow">Save</label>
      <input title="Save" id="input1" type="submit" name="Save" value="Save" class="inputTextField" />
      <label for="input2" class="noshow">Reset</label>
      <input title="Reset" id="input2" type="reset" name="Reset" value="Reset" class="inputTextField" />
      <label for="input3" class="noshow">Close</label>
      <input title="Close" id="input3" type="button" name="Close" value="Close" class="inputTextField" onClick="window.close();" />
    </form>
<%
  if ( action.equalsIgnoreCase( "saveBookmark" ) )
  {
%>
      <script language="JavaScript" type="text/javascript">
        <!--
<%
          if ( result )
          {
%>
            alert( "Bookmark successfully saved.");
<%
          }
          else
          {
%>
            alert( "An error occurred, possibly because bookmark already exits." );
<%
          }
%>
          this.close();
        //-->
      </script>
      <noscript>Your browser does not support JavaScript!</noscript>
<%
  }

%>
  </body>
</html>