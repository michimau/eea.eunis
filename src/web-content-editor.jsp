<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Web content editor.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="java.util.List"%>
<%@ page import="ro.finsiel.eunis.jrfTables.WebContentPersist"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtLanguagePersist"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="ro.finsiel.eunis.jrfTables.EunisISOLanguagesPersist"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  //Utilities.dumpRequestParams( request );
  String language = Utilities.formatString( request.getParameter( "language"), SessionManager.getCurrentLanguage() );
  String idPage = Utilities.formatString( request.getParameter( "idPage" ) );
  String type = Utilities.formatString( request.getParameter( "type" ), "msg" );

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent( language );
%>
    <title>
      <%=cm.cms("web_content_editor")%>
    </title>
    <script language="javascript" type="text/javascript">
      //<![CDATA[
      function versionOnChange()
      {
        var frm = document.createElement("form");
        frm.action = "web-content-editor.jsp";
        document.appendChild( frm );

        // version
        var version = document.contentManagement.version;
        var ctrl_version = document.createElement("input");
        ctrl_version.type= "hidden";
        ctrl_version.name = "version";
        ctrl_version.value = version.options[ version.selectedIndex ].value;
        frm.appendChild( ctrl_version );

        // Language
        var language = document.contentManagement.language;
        var ctrl_language = document.createElement("input");
        ctrl_language.type= "hidden";
        ctrl_language.name = "language";
        ctrl_language.value = language.options[ language.selectedIndex ].value;
        frm.appendChild( ctrl_language );

        // idPage
        var ctrl_idPage = document.createElement("input");
        ctrl_idPage.type= "hidden";
        ctrl_idPage.name = "idPage";
        ctrl_idPage.value = '<%=idPage%>';
        frm.appendChild( ctrl_idPage );

        // type
        var ctrl_idPage = document.createElement("input");
        ctrl_idPage.type= "hidden";
        ctrl_idPage.name = "type";
        ctrl_idPage.value = '<%=type%>';
        frm.appendChild( ctrl_idPage );

        frm.submit();
      }

      function languageOnChange()
      {
        var frm = document.createElement("form");
        frm.action = "web-content-editor.jsp";
        document.appendChild( frm );

        // Language
        var language = document.contentManagement.language;
        var ctrl_language = document.createElement("input");
        ctrl_language.type= "hidden";
        ctrl_language.name = "language";
        ctrl_language.value = language.options[ language.selectedIndex ].value;
        frm.appendChild( ctrl_language );

        // idPage
        var ctrl_idPage = document.createElement("input");
        ctrl_idPage.type= "hidden";
        ctrl_idPage.name = "idPage";
        ctrl_idPage.value = '<%=idPage%>';
        frm.appendChild( ctrl_idPage );

        // type
        var ctrl_idPage = document.createElement("input");
        ctrl_idPage.type= "hidden";
        ctrl_idPage.name = "type";
        ctrl_idPage.value = '<%=type%>';
        frm.appendChild( ctrl_idPage );

        frm.submit();
      }

      function resetOnChange()
      {
        var frm = document.createElement("form");
        frm.action = "web-content-editor.jsp";
        document.appendChild( frm );

        // idPage
        var ctrl_idPage = document.createElement("input");
        ctrl_idPage.type= "hidden";
        ctrl_idPage.name = "idPage";
        ctrl_idPage.value = '<%=idPage%>';
        frm.appendChild( ctrl_idPage );

        // type
        var ctrl_idPage = document.createElement("input");
        ctrl_idPage.type= "hidden";
        ctrl_idPage.name = "type";
        ctrl_idPage.value = '<%=type%>';
        frm.appendChild( ctrl_idPage );

        frm.submit();
      }
      //]]>
    </script>
  </head>
  <body>
    <div id="content">
<%
  if( SessionManager.isContent_management_RIGHT() || idPage.equalsIgnoreCase( "" ) )
  {
    boolean save = Utilities.checkedStringToBoolean( request.getParameter( "save" ), false );
    long version = Utilities.checkedStringToLong( request.getParameter( "version" ), -1 );
    boolean saveResult = false;
    String errorHint = "";
    short maxLength = 0;
    List languages = new ArrayList();
    List versions = new ArrayList();
    String contentText = "";
    String descriptionText = "";
    String msg = "";

    String typeStr = cm.cms("text");
    if ( type.equalsIgnoreCase( "text" ) ) typeStr = cm.cms("text");
    if ( type.equalsIgnoreCase( "alt" ) ) typeStr = cm.cms("web_content_editor_04");
    if ( type.equalsIgnoreCase( "title" ) ) typeStr = cm.cms("web_content_editor_05");
    if ( type.equalsIgnoreCase( "label" ) ) typeStr = cm.cms("web_content_editor_06");
    if ( type.equalsIgnoreCase( "msg" ) ) typeStr = cm.cms("web_content_editor_07");

    if( save )
    {
      String text = Utilities.formatString( request.getParameter( "text" ) ).trim();
      String description = Utilities.formatString( request.getParameter( "description" ) ).trim();
      short maxLengthSave = ( short )Utilities.checkedStringToInt( request.getParameter( "maxLength" ), 0 );
      boolean validContent = true;
      // Validate content
      if ( maxLengthSave > 0 )
      {
        validContent = text.length() < maxLengthSave;
      }
      if( validContent)
      {
        saveResult = cm.savePageContentJDBC( idPage,
                text,
                description,
                language,
                maxLengthSave,
                SessionManager.getUsername(),
                false, SQL_DRV, SQL_URL, SQL_USR, SQL_PWD  );
        version = -1;
      }
      else
      {
        errorHint = cm.cms("web_content_editor_08") + maxLengthSave + cm.cms("web_content_editor_09");
      }
    }

    WebContentPersist cmPersist = cm.getPersistentObject( idPage );
    if ( cmPersist == null )
    {
      // This is a new Key and must be inserted not updated etc...
      msg = cm.cms("web_content_editor_10");
    }
    else
    {
      // Maximum length
      Short maxLengthShort = cmPersist.getContentLength();
      if ( maxLengthShort != null && maxLengthShort.shortValue() > 0 ) maxLength = maxLengthShort.shortValue();
      languages = cm.getTranslatedLanguages();
      versions = cm.getIDPageVersions( idPage, language );
      descriptionText = Utilities.formatString( cmPersist.getDescription() );
      contentText = Utilities.formatString( cm.getText( idPage ) );

      if ( version != -1 )
      {
        for ( int i = 0; i < versions.size(); i++ )
        {
          WebContentPersist wCP = ( WebContentPersist ) versions.get( i );
          if( version == wCP.getRecordDate().getTime() )
          {
            contentText = wCP.getContent();
            descriptionText = Utilities.formatString( wCP.getDescription() );
            if( descriptionText.equalsIgnoreCase( "null" ) ) descriptionText = "";
          }
        }
      }
    }

%>
      <form id="contentManagement" name="contentManagement" action="web-content-editor.jsp" method="post">
        <input type="hidden" name="save" value="true" />
        <input type="hidden" name="type" value="<%=type%>" />
        <%=cm.cms("web_content_editor_11")%>:
        <strong>
          <%=typeStr%>
        </strong>
        <br />
        <br />
        <label for="idPage"><%=cm.cms("web_content_editor_12")%> : </label>
        <input id="idPage" name="idPage" type="text" value="<%=idPage%>" size="50" title="<%=cm.cms("web_content_editor_12")%>" />
        <br />
        <br />
        <label for="language"><%=cm.cms("language")%> : </label>
        <select title="<%=cm.cms("web_content_editor_14")%>" id="language" name="language" onchange="javascript:languageOnChange();">
<%
    for ( int i = 0; i < languages.size(); i++ )
    {
      EunisISOLanguagesPersist languagePersist = ( EunisISOLanguagesPersist ) languages.get( i );
      String selected = "";
      if ( languagePersist.getCode().equalsIgnoreCase( language ) )
      {
        selected = " selected=\"selected\"";
      }
%>
          <option value="<%=languagePersist.getCode()%>"<%=selected%>><%=languagePersist.getName()%></option>
<%
  }
%>
          <%-- Available languages here --%>
        </select>
        &nbsp;&nbsp;&nbsp;
        <%=cm.cms("web_content_editor_15")%>:
<%
  if ( versions.size() == 0 )
  {
%>
        <label for="version1" class="noshow"><%=cm.cms("no_version_available")%></label>
        <select title="<%=cm.cms("no_version_available")%>" id="version1" name="version" onchange="javascript:versionOnChange();" disabled="disabled">
          <option value=""><%=cm.cms("no_version_available")%></option>
        </select>
<%
  }
  else
  {
%>
        <label for="version" class="noshow"><%=cm.cms("web_content_editor_18")%></label>
        <select title="<%=cm.cms("web_content_editor_18")%>" id="version" name="version" onchange="javascript:versionOnChange();">
<%
    for( int i = 0; i < versions.size(); i++ )
    {
      WebContentPersist wCP = ( WebContentPersist ) versions.get( i );
      String dateStr = new SimpleDateFormat( "yyyy/MM/dd - kk:mm:ss" ).format( wCP.getRecordDate() );
      if( i == 0 ) dateStr += " - Current";
      String selected = "";
      if( version == wCP.getRecordDate().getTime() )
      {
        selected = " selected=\"selected\"";
      }
%>
          <option value="<%=wCP.getRecordDate().getTime()%>"<%=selected%>><%=dateStr%></option>
<%
    }
%>
        </select>
<%
  }
%>
        <br />
        <br />
        <%=cm.cms("web_content_editor_19")%>:
        <br />
        <label for="text" class="noshow"><%=cm.cms("web_content_editor_21")%></label>
        <textarea id="text" name="text" rows="10" cols="80" title="<%=cm.cms("web_content_editor_21")%>" ><%=contentText%></textarea>
        <br />
        <%=cm.cms("web_content_editor_20")%>:
        <br />
        <label for="description" class="noshow"><%=cm.cms("description_of_the_text")%></label>
        <textarea rows="3" id="description" name="description" cols="80" title="<%=cm.cms("description_of_the_text")%>"><%=descriptionText%></textarea>
        <%--<%=cm.cmsTitle("description_of_the_text")%>--%>
        <br />
        <br />
        <label for="maxLength"><%=cm.cms("web_content_editor_23")%>:</label> <input type="text" id="maxLength" name="maxLength" value="<%=maxLength%>" size="4" style="text-align : right;" title="<%=cm.cms("web_content_editor_24")%>" />
        <br />
        <br />
        <input type="submit" id="save" name="Save" value="<%=cm.cms("save")%>" title="<%=cm.cms("web_content_editor_25")%>" class="searchButton" />
        <input type="button" id="delete" name="Delete" value="<%=cm.cms("delete")%>" title="<%=cm.cms("web_content_editor_26")%>" class="standardButton" onclick="javascript:alert( 'TODO' );" />
        <input type="reset" id="reset" name="Reset" value="<%=cm.cms("reset")%>" title="<%=cm.cms("web_content_editor_27")%>" class="standardButton" onclick="javascript:resetOnChange();" />
        <input type="button" id="close_window" name="Close" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close();" title="<%=cm.cms("web_content_editor_28")%>" class="standardButton" />
      </form>
<%
  if( save )
  {
    if ( saveResult )
    {
      msg = cm.cms("web_content_editor_29");
      if ( !type.equalsIgnoreCase( "msg" ) && !type.equalsIgnoreCase( "label" ) )
      {
        msg += cm.cms("web_content_editor_30");
      }
    }
    else
    {
      msg = cm.cms("web_content_editor_31");
    }
    msg += "<br />";
    msg += errorHint;
  }
%>
      <div id="msg" style="color : red"><%=msg%></div>
<%
  }
  else
  {
%>
    <%=cm.cms("web_content_editor_32")%>
<%
  }
%>
    </div>
  </body>
</html>
