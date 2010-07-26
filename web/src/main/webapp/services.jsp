<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Services' function - display links to all habitat searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.search.Utilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,services";
  // Check if we need to enter 'edit web content' mode
  if(SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT() )
  {
    if ( request.getParameter("editContent") != null )
    {
      boolean editContent = Utilities.checkedStringToBoolean(request.getParameter("editContent"), false);
      SessionManager.setEditContentMode( editContent );
    }
    if ( request.getParameter("advancedEditContent") != null )
    {
      boolean advancedEditContent = Utilities.checkedStringToBoolean(request.getParameter("advancedEditContent"), false);
      SessionManager.setAdvancedEditContentMode( advancedEditContent );
    }
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("services_page_title")%>
    </title>
    <style type="text/css">
      #services td
      {
        vertical-align: middle;
      }
    </style>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
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
<!-- MAIN CONTENT -->
                <h1>
                  <%=cm.cmsPhrase("EUNIS Database Services")%>
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
                <br />
                <table class="listing fullwidth" id="services">
<%--
                  <tr>
                    <th align="center">
                      &nbsp;
                    </th>
                    <th>
                      <%=cm.cmsPhrase("Services")%>
                    </th>
                  </tr>
--%>
<%
  int color = 0;
  String cssClass = "";
  if( SessionManager.isAuthenticated() && SessionManager.isUser_management_RIGHT() )
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";

%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="users.jsp" title="<%=cm.cms("user_management")%>"><img alt="<%=cm.cms("user_management")%>" src="images/users.gif" width="81" height="43" border="0" title="<%=cm.cms("user_management")%>" /></a>
                      <%=cm.cmsAlt("user_management")%><%=cm.cmsTitle("user_management")%>
                    </td>
                    <td>
                      <a href="users.jsp"><%=cm.cmsPhrase("Add, update and delete users")%></a>
                    </td>
                  </tr>
<%
  }
  if( SessionManager.isAuthenticated() && SessionManager.isRole_management_RIGHT() )
  {
%>
				  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="roles.jsp" title="<%=cm.cms("role_management")%>"><img alt="<%=cm.cms("role_management")%>" src="images/roles.gif" width="81" height="43" border="0" title="<%=cm.cms("role_management")%>" /></a>
                      <%=cm.cmsAlt("role_management")%><%=cm.cmsTitle("role_management")%>
                    </td>
                    <td>
                      <a href="roles.jsp"><%=cm.cmsPhrase("Add, update and delete users roles")%></a>
                      <%=cm.cmsTitle("role_management")%>
                    </td>
                  </tr>
<%
  }
  //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
<%--
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="logos.jsp" title="<%=cm.cms("eunis_database_logos")%>"><img alt="<%=cm.cms("eunis_database_logos")%>" src="images/logos.gif" width="81" height="43" border="0" title="<%=cm.cms("eunis_database_logos")%>" /></a>
                      <%=cm.cmsAlt("eunis_database_logos")%><%=cm.cmsTitle("eunis_database_logos")%>
                    </td>
                    <td>
                      <a href="logos.jsp"><%=cm.cmsPhrase("Download EUNIS Database logos")%></a>
                    </td>
                  </tr>
--%>
<%
  if( SessionManager.isAuthenticated() )
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="users-bookmarks.jsp" title="<%=cm.cms("user_bookmarks")%>"><img alt="<%=cm.cms("services_bookmarkslink_alt")%>" src="images/bookmarks.gif" width="81" height="43" border="0" title="<%=cm.cms("user_bookmarks")%>" /></a>
                      <%=cm.cmsAlt("services_bookmarkslink_alt")%><%=cm.cmsTitle("user_bookmarks")%>
                    </td>
                    <td>
                      <a href="users-bookmarks.jsp"><%=cm.cmsPhrase("List, update and delete your bookmarks")%></a>
                    </td>
                  </tr>
<%
  }
  if( SessionManager.isContent_management_RIGHT() )
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
<%--
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="headline.jsp" title="<%=cm.cms("services_headlinelink_title")%>"><img alt="<%=cm.cms("services_headlinelink")%>" src="images/headlines.gif" width="81" height="43" border="0" title="<%=cm.cms("services_headlinelink_title")%>" /></a>
                      <%=cm.cmsAlt("services_headlinelink")%><%=cm.cmsTitle("services_headlinelink_title")%>
                    </td>
                    <td>
                      <a href="headline.jsp"><%=cm.cmsPhrase("Edit EUNIS Database headline")%></a>
                    </td>
                  </tr>
--%>
<%
  }
  if( SessionManager.isEdit_glossary() )
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="glossary-table.jsp" title="<%=cm.cms("edit_glossary_of_terms")%>"><img alt="<%=cm.cms("edit_glossary_of_terms")%>" src="images/glossary.gif" width="81" height="43" border="0" title="<%=cm.cms("edit_glossary_of_terms")%>" /></a>
                      <%=cm.cmsAlt("edit_glossary_of_terms")%><%=cm.cmsTitle("edit_glossary_of_terms")%>
                    </td>
                    <td>
                      <a href="glossary-table.jsp"><%=cm.cmsPhrase("Edit the glossary of terms")%></a>
                      <%=cm.cmsTitle("edit_glossary_of_terms")%>
                    </td>
                  </tr>
<%
  }
  if( SessionManager.isAdmin() )
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="feedback-list.jsp" title="<%=cm.cms("feedback_list")%>"><img alt="<%=cm.cms("feedback_list")%>" src="images/glossary.gif" width="81" height="43" border="0" title="<%=cm.cms("feedback_list")%>" /></a>
                      <%=cm.cmsAlt("feedback_list")%><%=cm.cmsTitle("feedback_list")%>
                    </td>
                    <td>
                     <a href="feedback-list.jsp"><%=cm.cmsPhrase("Feedback list")%></a>
                   </td>
                  </tr>
<%
  }
  if( SessionManager.isAuthenticated() )
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
<%--
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="download-database.jsp" title="<%=cm.cms("services_access")%>"><img alt="<%=cm.cms("services_access")%>" src="images/access.gif" width="81" height="43" border="0" title="<%=cm.cms("services_access")%>" /></a>
                      <%=cm.cmsAlt("services_access")%><%=cm.cmsTitle("services_access")%>
                    </td>
                    <td>
                      <a href="download-database.jsp"><%=cm.cmsPhrase("Download database in Microsoft Access format")%></a>
                    </td>
                  </tr>
--%>
<%
  }
  if(SessionManager.isAdmin())
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="clear-temporary-data.jsp" title="<%=cm.cms("services_cleartemp")%>"><img alt="<%=cm.cms("services_cleartemp")%>" src="images/clean.gif" width="81" height="43" border="0" title="<%=cm.cms("services_cleartemp")%>" /></a>
                      <%=cm.cmsAlt("services_cleartemp")%>
                    </td>
                    <td>
                      <a href="clear-temporary-data.jsp"><%=cm.cmsPhrase("Clear temporary data from the database")%></a>
                    </td>
                  </tr>
<%
  }
  if ( SessionManager.isContent_management_RIGHT() )
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="services.jsp?action=reloadlanguage" title="<%=cm.cms("services_refresh_title")%>"><img alt="<%=cm.cms("refresh_language")%>" src="images/language.gif" width="81" height="43" border="0" title="<%=cm.cms("services_refresh_title")%>" /></a>
                      <%=cm.cmsAlt("refresh_language")%>
                    </td>
                    <td>
                      <a href="services.jsp?action=reloadlanguage"><%=cm.cmsPhrase("Refresh language")%></a>
                    </td>
                  </tr>
<%
  }
  if ( SessionManager.isAdmin() )
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="refreshtemplate" title="<%=cm.cms("services_refresh_template")%>"><img alt="<%=cm.cms("refresh_template")%>" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="<%=cm.cms("services_refresh_template")%>" /></a>
                      <%=cm.cmsAlt("refresh_template")%>
                    </td>
                    <td>
                      <a href="refreshtemplate"><%=cm.cmsPhrase("Refresh template")%></a>
                    </td>
                  </tr>
<%
    if ( !SessionManager.getWebContent().isEditMode() )
    {
      //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="services.jsp?editContent=true" title="<%=cm.cms("services_inline_activate_title")%>"><img alt="<%=cm.cms("edit_mode_allwos_editing_html_attributes")%>" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="<%=cm.cms("services_inline_activate_title")%>" /></a>
                      <%=cm.cmsAlt("edit_mode_allwos_editing_html_attributes")%>
                    </td>
                    <td>
                      <a href="services.jsp?editContent=true"><%=cm.cmsPhrase("Activate inline editor for web content")%></a>
                    </td>
                  </tr>
<%
    }
    else
    {
      //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="services.jsp?editContent=false" title="<%=cm.cms("services_inline_dezactivate_alt")%>"><img alt="<%=cm.cms("services_inline_dezactivate_alt")%>" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="<%=cm.cms("services_inline_dezactivate_alt")%>" /></a>
                      <%=cm.cmsAlt("services_inline_dezactivate_alt")%>
                    </td>
                    <td>
                      <a href="services.jsp?editContent=false"><%=cm.cmsPhrase("Deactivate inline editor")%></a>
                    </td>
                  </tr>
<%
    }
    if ( !SessionManager.getWebContent().isAdvancedEditMode() )
    {
      //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="services.jsp?advancedEditContent=true" title="<%=cm.cms("edit_mode_allwos_editing_html_attributes")%>"><img alt="<%=cm.cms("edit_mode_allwos_editing_html_attributes")%>" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="<%=cm.cms("edit_mode_allwos_editing_html_attributes")%>" /></a>
                      <%=cm.cmsAlt("services_inline_advactivate_alt")%>
                    </td>
                    <td>
                      <a href="services.jsp?advancedEditContent=true"><%=cm.cmsPhrase("Activate advanced inline editor")%></a>
                      <%=cm.cms("edit_mode_allwos_editing_html_attributes")%>
                    </td>
                  </tr>
<%
    }
    else
    {
      //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="services.jsp?advancedEditContent=false"><img alt="<%=cm.cms("services_inline_advdezactivate_alt")%>" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="<%=cm.cms("services_inline_advdezactivate_title")%>" /></a>
                      <%=cm.cmsTitle("services_inline_advdezactivate_title")%>
                    </td>
                    <td>
                      <a href="services.jsp?advancedEditContent=false"><%=cm.cmsPhrase("Deactivate advanced inline editor")%></a>
                    </td>
                  </tr>
<%
    }
    if( SessionManager.isImportExportData_RIGHT() )
  	{
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="dataimport" title="<%=cm.cmsPhrase("Data import")%>"><img alt="<%=cm.cmsPhrase("Data import")%>" src="images/clean.gif" width="81" height="43" border="0" title="<%=cm.cmsPhrase("Data import")%>" /></a>
                    </td>
                    <td>
                      <a href="dataimport"><%=cm.cmsPhrase("Import data into EUNIS database")%></a>
                    </td>
                  </tr>
<%
  	}
    
  }
%>
                </table>

                <%=cm.cmsMsg("refresh_language")%>
<%
  String action = Utilities.formatString( request.getParameter("action") );
  if( action.equals("reloadlanguage") )
  {
              SessionManager.getWebContent().reloadLanguageData();
%>
                <script language="JavaScript" type="text/javascript">
                //<![CDATA[
                  alert('<%=cm.cms("refresh_language")%>');
                //]]>
                </script>
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
                <jsp:param name="page_name" value="services.jsp"/>
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
