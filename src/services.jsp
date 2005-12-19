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
  WebContentManagement cm = SessionManager.getWebContent();
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
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("services_page_title")%>
    </title>
    <jsp:include page="header-page.jsp" />
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,services_location"/>
      </jsp:include>
      <h1>
        <%=cm.cmsText("services_title")%>
      </h1>
      <br />
      <table width="100%" border="1" style="border-collapse:collapse" summary="layout">
        <tr>
          <th align="center">
            &nbsp;
          </th>
          <th>
            <%=cm.cmsText("services_servicetitle")%>
          </th>
        </tr>
<%
  if( SessionManager.isAuthenticated() && ( SessionManager.isUser_management_RIGHT() || SessionManager.isRole_management_RIGHT() ) )
  {
%>
        <tr>
          <td align="center">
            <a href="users.jsp" title="<%=cm.cms("services_userslink_title")%>"><img alt="<%=cm.cms("services_userslink_alt")%>" src="images/users.gif" width="81" height="43" border="0" title="<%=cm.cms("services_userslink_title")%>" /></a>
            <%=cm.cmsAlt("services_userslink_alt")%><%=cm.cmsTitle("services_userslink_title")%>
          </td>
          <td>
            <a href="users.jsp" title="<%=cm.cms("services_userslink_title")%>"><%=cm.cmsText("services_userslink")%></a>
            <%=cm.cmsTitle("services_userslink_title")%>
          </td>
        </tr>
<%
  }
%>
        <tr>
          <td align="center">
            <a href="logos.jsp" title="<%=cm.cms("services_logoslink_title")%>"><img alt="<%=cm.cms("services_logoslink_alt")%>" src="images/logos.gif" width="81" height="43" border="0" title="<%=cm.cms("services_logoslink_title")%>" /></a>
            <%=cm.cmsAlt("services_logoslink_alt")%><%=cm.cmsTitle("services_logoslink_title")%>
          </td>
          <td>
            <a href="logos.jsp" title="<%=cm.cms("services_logoslink_title")%>"><%=cm.cmsText("services_logoslink")%></a>
            <%=cm.cmsTitle("services_logoslink_title")%>
          </td>
        </tr>
<%
  if( SessionManager.isAuthenticated() )
  {
%>
        <tr>
          <td align="center">
            <a href="users-bookmarks.jsp" title="<%=cm.cms("services_bookmarkslink_title")%>"><img alt="<%=cm.cms("services_bookmarkslink_alt")%>" src="images/bookmarks.gif" width="81" height="43" border="0" title="<%=cm.cms("services_bookmarkslink_title")%>" /></a>
            <%=cm.cmsAlt("services_bookmarkslink_alt")%><%=cm.cmsTitle("services_bookmarkslink_title")%>
          </td>
          <td>
            <a href="users-bookmarks.jsp" title="<%=cm.cms("services_bookmarkslink_title")%>"><%=cm.cmsText("services_bookmarkslink")%></a>
            <%=cm.cmsTitle("services_bookmarkslink_title")%>
          </td>
        </tr>
<%
  }
  if( SessionManager.isContent_management_RIGHT() )
  {
%>
        <!--<tr>-->
          <!--<td align="center">-->
            <!--<a href="headline.jsp" title="<%=cm.cms("services_headlinelink_title")%>"><img alt="<%=cm.cms("services_headlinelink_alt")%>" src="images/headlines.gif" width="81" height="43" border="0" title="<%=cm.cms("services_headlinelink_title")%>" /></a>-->
            <%--<%=cm.cmsAlt("services_headlinelink_alt")%><%=cm.cmsTitle("services_headlinelink_title")%>--%>
          <!--</td>-->
          <!--<td>-->
            <!--<a href="headline.jsp" title="<%=cm.cms("services_headlinelink_title")%>"><%=cm.cmsText("services_headlinelink")%></a>-->
            <%--<%=cm.cmsTitle("services_headlinelink_title")%>--%>
          <!--</td>-->
        <!--</tr>-->
<%
  }
  if( SessionManager.isEdit_glossary() )
  {
%>
        <tr>
          <td align="center">
            <a href="glossary-table.jsp" title="<%=cm.cms("services_glossarylink_title")%>"><img alt="<%=cm.cms("services_glossarylink_alt")%>" src="images/glossary.gif" width="81" height="43" border="0" title="<%=cm.cms("services_glossarylink_title")%>" /></a>
            <%=cm.cmsAlt("services_glossarylink_alt")%><%=cm.cmsTitle("services_glossarylink_title")%>
          </td>
          <td>
            <a href="glossary-table.jsp" title="<%=cm.cms("services_glossarylink_title")%>"><%=cm.cmsText("services_glossarylink")%></a>
            <%=cm.cmsTitle("services_glossarylink_title")%>
          </td>
        </tr>
<%
  }
  if( SessionManager.isAdmin() )
  {
%>
       <tr>
          <td align="center">
            <a href="feedback-list.jsp" title="<%=cm.cms("services_feedbacklink_title")%>"><img alt="<%=cm.cms("services_feedbacklink_title")%>" src="images/glossary.gif" width="81" height="43" border="0" title="<%=cm.cms("services_feedbacklink_title")%>" /></a>
            <%=cm.cmsAlt("services_feedbacklink_title")%><%=cm.cmsTitle("services_feedbacklink_title")%>
          </td>
          <td>
           <a href="feedback-list.jsp" title="<%=cm.cms("services_feedbacklink_title")%>"><%=cm.cmsText("services_feedbacklink")%></a>
            <%=cm.cmsTitle("services_feedbacklink_title")%><%=cm.cmsTitle("services_feedbacklink_title")%>
         </td>
        </tr>
<%
  }
  if( SessionManager.isAuthenticated() )
  {
%>
        <tr>
          <td align="center">
            <a href="download-database.jsp" title="<%=cm.cms("services_access_title")%>"><img alt="<%=cm.cms("services_access_alt")%>" src="images/access.gif" width="81" height="43" border="0" title="<%=cm.cms("services_access_title")%>" /></a>
            <%=cm.cmsAlt("services_access_alt")%><%=cm.cmsTitle("services_access_title")%>
          </td>
          <td>
            <a href="download-database.jsp" title="<%=cm.cms("services_access_title")%>"><%=cm.cmsText("services_access")%></a>
            <%=cm.cmsTitle("services_access_title")%>
          </td>
        </tr>
<%
  }
  if(SessionManager.isAdmin())
  {
%>
        <tr>
          <td align="center">
            <a href="clear-temporary-data.jsp" title="<%=cm.cms("services_cleartemp_title")%>"><img alt="<%=cm.cms("services_cleartemp_alt")%>" src="images/clean.gif" width="81" height="43" border="0" title="<%=cm.cms("services_cleartemp_title")%>" /></a>
            <%=cm.cmsAlt("services_cleartemp_title")%>
          </td>
          <td>
            <a href="clear-temporary-data.jsp" title="<%=cm.cms("services_cleartemp_title")%>"><%=cm.cmsText("services_cleartemp")%></a>
            <%=cm.cmsTitle("services_cleartemp_title")%>
          </td>
        </tr>
<%
  }
  if ( SessionManager.isContent_management_RIGHT() )
  {
%>
        <tr>
          <td align="center">
            <a href="services.jsp?action=reloadlanguage" title="<%=cm.cms("services_refresh_title")%>"><img alt="<%=cm.cms("services_refresh_alt")%>" src="images/language.gif" width="81" height="43" border="0" title="<%=cm.cms("services_refresh_title")%>" /></a>
            <%=cm.cmsAlt("services_refresh_alt")%>
          </td>
          <td>
            <a href="services.jsp?action=reloadlanguage" title="<%=cm.cms("services_refresh_title")%>"><%=cm.cmsText("services_refresh")%></a>
            <%=cm.cmsTitle("services_refresh_title")%>
          </td>
        </tr>
<%
    if ( !SessionManager.getWebContent().isEditMode() )
    {
%>
        <tr>
          <td align="center">
            <a href="services.jsp?editContent=true" title="<%=cm.cms("services_inline_activate_title")%>"><img alt="<%=cm.cms("services_inline_activate_alt")%>" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="<%=cm.cms("services_inline_activate_title")%>" /></a>
            <%=cm.cmsAlt("services_inline_activate_alt")%>
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
%>
        <tr>
          <td align="center">
            <a href="services.jsp?editContent=false" title="<%=cm.cms("services_inline_dezactivate_title")%>"><img alt="<%=cm.cms("services_inline_dezactivate_alt")%>" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="<%=cm.cms("services_inline_dezactivate_title")%>" /></a>
            <%=cm.cmsAlt("services_inline_dezactivate_title")%>
          </td>
          <td>
            <a href="services.jsp?editContent=false" title="<%=cm.cms("services_inline_dezactivate_title")%>"><%=cm.cmsText("services_inline_dezactivate")%></a>
            <%=cm.cmsTitle("services_inline_dezactivate_title")%>
          </td>
        </tr>
<%
    }
    if ( !SessionManager.getWebContent().isAdvancedEditMode() )
    {
%>
        <tr>
          <td align="center">
            <a href="services.jsp?advancedEditContent=true" title="<%=cm.cms("services_inline_advactivate_title")%>"><img alt="<%=cm.cms("services_inline_activate_alt")%>" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="<%=cm.cms("services_inline_advactivate_title")%>" /></a>
            <%=cm.cmsAlt("services_inline_advactivate_alt")%>
          </td>
          <td>
            <a href="services.jsp?advancedEditContent=true" title="<%=cm.cms("services_inline_advactivate_title")%>"><%=cm.cmsText("services_inline_advactivate")%></a>
            <%=cm.cmsTitle("services_inline_advactivate_title")%>
          </td>
        </tr>
<%
    }
    else
    {
%>
        <tr>
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

      <%=cm.cmsMsg("services_refresh")%>
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
        alert('<%=cm.cms("services_refresh")%>');
      //-->
      </script>
<%
  }
%>
    </div>
    </div>
    </div>
  </body>
</html>
