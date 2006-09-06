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
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
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
                  <jsp:param name="location" value="home#index.jsp,services"/>
                </jsp:include>
                <h1>
                  <%=cm.cmsText("services_title")%>
                </h1>
                <br />
                <table width="90%" summary="layout" class="listing" id="services">
<%--
                  <tr>
                    <th align="center">
                      &nbsp;
                    </th>
                    <th>
                      <%=cm.cmsText("services")%>
                    </th>
                  </tr>
--%>
<%
  int color = 0;
  String cssClass = "";
  if( SessionManager.isAuthenticated() && ( SessionManager.isUser_management_RIGHT() || SessionManager.isRole_management_RIGHT() ) )
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";

%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="users.jsp" title="<%=cm.cms("user_management")%>"><img alt="<%=cm.cms("user_management")%>" src="images/users.gif" width="81" height="43" border="0" title="<%=cm.cms("user_management")%>" /></a>
                      <%=cm.cmsAlt("user_management")%><%=cm.cmsTitle("user_management")%>
                    </td>
                    <td>
                      <a href="users.jsp" title="<%=cm.cms("user_management")%>"><%=cm.cmsText("services_userslink")%></a>
                      <%=cm.cmsTitle("user_management")%>
                    </td>
                  </tr>
<%
  }
  //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="logos.jsp" title="<%=cm.cms("eunis_database_logos")%>"><img alt="<%=cm.cms("eunis_database_logos")%>" src="images/logos.gif" width="81" height="43" border="0" title="<%=cm.cms("eunis_database_logos")%>" /></a>
                      <%=cm.cmsAlt("eunis_database_logos")%><%=cm.cmsTitle("eunis_database_logos")%>
                    </td>
                    <td>
                      <a href="logos.jsp" title="<%=cm.cms("eunis_database_logos")%>"><%=cm.cmsText("services_logoslink")%></a>
                      <%=cm.cmsTitle("eunis_database_logos")%>
                    </td>
                  </tr>
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
                      <a href="users-bookmarks.jsp" title="<%=cm.cms("user_bookmarks")%>"><%=cm.cmsText("services_bookmarkslink")%></a>
                      <%=cm.cmsTitle("user_bookmarks")%>
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
                      <a href="headline.jsp" title="<%=cm.cms("services_headlinelink_title")%>"><%=cm.cmsText("services_headlinelink")%></a>
                      <%=cm.cmsTitle("services_headlinelink_title")%>
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
                      <a href="glossary-table.jsp" title="<%=cm.cms("edit_glossary_of_terms")%>"><%=cm.cmsText("edit_glossary_of_terms")%></a>
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
                     <a href="feedback-list.jsp" title="<%=cm.cms("feedback_list")%>"><%=cm.cmsText("feedback_list")%></a>
                      <%=cm.cmsTitle("feedback_list")%><%=cm.cmsTitle("feedback_list")%>
                   </td>
                  </tr>
<%
  }
  if( SessionManager.isAuthenticated() )
  {
    //cssClass = color++ % 2 == 0 ? "class=\"zebraeven\"" : "";
%>
                  <tr <%=cssClass%>>
                    <td align="center">
                      <a href="download-database.jsp" title="<%=cm.cms("services_access")%>"><img alt="<%=cm.cms("services_access")%>" src="images/access.gif" width="81" height="43" border="0" title="<%=cm.cms("services_access")%>" /></a>
                      <%=cm.cmsAlt("services_access")%><%=cm.cmsTitle("services_access")%>
                    </td>
                    <td>
                      <a href="download-database.jsp" title="<%=cm.cms("services_access")%>"><%=cm.cmsText("services_access")%></a>
                      <%=cm.cmsTitle("services_access")%>
                    </td>
                  </tr>
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
                      <a href="clear-temporary-data.jsp" title="<%=cm.cms("services_cleartemp")%>"><%=cm.cmsText("services_cleartemp")%></a>
                      <%=cm.cmsTitle("services_cleartemp")%>
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
                      <a href="services.jsp?action=reloadlanguage" title="<%=cm.cms("services_refresh_title")%>"><%=cm.cmsText("refresh_language")%></a>
                      <%=cm.cmsTitle("services_refresh_title")%>
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
                      <a href="services.jsp?editContent=true" title="<%=cm.cms("services_inline_activate_title")%>"><%=cm.cmsText("services_inline_activate")%></a>
                      <%=cm.cmsTitle("services_inline_activate_title")%>
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
                      <a href="services.jsp?editContent=false" title="<%=cm.cms("services_inline_dezactivate_alt")%>"><%=cm.cmsText("services_inline_dezactivate")%></a>
                      <%=cm.cmsTitle("services_inline_dezactivate_alt")%>
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
                      <a href="services.jsp?advancedEditContent=true" title="<%=cm.cms("edit_mode_allwos_editing_html_attributes")%>"><%=cm.cmsText("services_inline_advactivate")%></a>
                      <%=cm.cmsTitle("edit_mode_allwos_editing_html_attributes")%>
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
                      <a href="services.jsp?advancedEditContent=false" title="<%=cm.cms("services_inline_advdezactivate_title")%>"><img alt="<%=cm.cms("services_inline_advdezactivate_alt")%>" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="<%=cm.cms("services_inline_advdezactivate_title")%>" /></a>
                      <%=cm.cmsAlt("services_inline_advdezactivate_title")%>
                    </td>
                    <td>
                      <a href="services.jsp?advancedEditContent=false" title="<%=cm.cms("services_inline_advdezactivate_title")%>"><%=cm.cmsText("services_inline_advdezactivate")%></a>
                      <%=cm.cmsTitle("services_inline_advdezactivate_title")%>
                    </td>
                  </tr>
<%
    }
  }
%>
                </table>

                <%=cm.cmsMsg("refresh_language")%>
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="services.jsp"/>
                </jsp:include>
<%
  String action = Utilities.formatString( request.getParameter("action") );
  if( action.equals("reloadlanguage") )
  {
              SessionManager.getWebContent().reloadLanguageData();
%>
                <script language="JavaScript" type="text/javascript">
                <!--
                  alert('<%=cm.cms("refresh_language")%>');
                //-->
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
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
