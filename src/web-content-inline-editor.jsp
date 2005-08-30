<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Web content inline editor.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.WebContentPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  //Utilities.dumpRequestParams( request );
  String idPage = Utilities.formatString( request.getParameter( "idPage" ), "" );
  WebContentManagement cm = SessionManager.getWebContent();
  WebContentPersist text = cm.getPageContentEnglish( idPage );
  boolean save = Utilities.checkedStringToBoolean( request.getParameter( "save" ), false );
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <title>Edit text: <%=idPage%></title>
    <jsp:include page="header-page.jsp" />
    <script type="text/javascript" language="JavaScript">
      <!--
        function setPreview()
        {
          try
          {
            var ctrl_content = document.getElementById( "content" );
            var ctrl_editor_preview = document.getElementById( "editor_preview" );
            ctrl_editor_preview.innerHTML = ctrl_content.value;
          }
          catch ( e )
          {
            alert( "Error setting preview.");
          }
        }
      //-->
    </script>
  </head>
  <body>
<%
  boolean result = false;
  if ( save )
  {
%>
    <div id="loading" class="dynamic_content">
      <img alt="Loading image" src="images/loading.gif" />
      <br />
      Updating data, please wait...
      <br />
      The parent page must be refreshed in order to reflect changes.
    </div>
<%
    out.flush();
    String SQL_DRV = application.getInitParameter("JDBC_DRV");
    String SQL_URL = application.getInitParameter("JDBC_URL");
    String SQL_USR = application.getInitParameter("JDBC_USR");
    String SQL_PWD = application.getInitParameter("JDBC_PWD");
    String content = Utilities.formatString( request.getParameter( "content" ), "" );
    String description = text.getDescription();
    result = cm.savePageContentJDBC( idPage, content, description, "en", SessionManager.getUsername(), false, SQL_DRV, SQL_URL, SQL_USR, SQL_PWD );
%>
    <script language="JavaScript" type="text/javascript">
    <!--
      try
      {
        var ctrl_loading = document.getElementById( "loading" );
<%
        if( result )
        {

%>
          ctrl_loading.innerHTML = "Text successfully saved.";
<%
        }
        else
        {
%>
          ctrl_loading.innerHTML = "An error occurred while updating text.";
<%
        }
%>
      }
      catch ( e ) {}
    //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
<%
  }
  String str = text.getContent();
  if ( save && result ) str = Utilities.formatString( request.getParameter( "content" ), "" );
%>
    <form name="editContent" action="web-content-inline-editor.jsp" method="post">
      <input type="hidden" name="save" value="true" />
      <input type="hidden" name="idPage" value="<%=idPage%>" />
      <label for="content" class="noshow">Content</label>
      <textarea title="Content" id="content" name="content" cols="10" rows="15" wrap="off" class="inputTextFieldInlineEditor" style="width : 500px;"><%=str%></textarea>
      <br />
      <label for="input1" class="noshow">Save</label>
      <input title="Save" id="input1" type="submit" name="Save" value="Save" class="inputTextField" />
      <label for="input2" class="noshow">Preview</label>
      <input title="Preview" id="input2" type="button" name="Preview" value="Preview" class="inputTextField" onclick="javascript:setPreview();" />
      <label for="input3" class="noshow">Close</label>
      <input title="Close editor window" id="input3" type="button" name="Close" value="Close" class="inputTextField" onclick="window.close();" />
    </form>
    <br />
    <div id="editor_preview">&nbsp;</div>
  </body>
</html>
<%
  out.flush();
%>