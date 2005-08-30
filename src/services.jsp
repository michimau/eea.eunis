<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Services' function - display links to all habitat searches.
--%>
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.search.Utilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Check if we need to enter 'edit web content' mode
  if(request.getParameter("editContent") != null && SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT() )
  {
    boolean editContent = Utilities.checkedStringToBoolean(request.getParameter("editContent"), false);
    //System.out.println( "editContent = " + editContent );
    SessionManager.setEditContentMode( editContent );
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    Services page
  </title>
  <jsp:include page="header-page.jsp" />
</head>
<body>
  <div id="content">
  <jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="Home#index.jsp,Services"/>
  </jsp:include>
  <h5>
    EUNIS Database Services
  </h5>
  <br />
<%
  if(!SessionManager.isAuthenticated())
  {
%>
  Please <a href="login.jsp" title="Login">login</a> to access all features on this page.
  <br />
  <table width="100%" summary="layout" border="1" style="border-collapse:collapse">
    <tr>
      <td>
        <a href="logos.jsp" title="EUNIS Database logos"><img alt="EUNIS Database logos" src="images/logos.gif" width="81" height="43" border="0" title="EUNIS Database logos" /></a>
      </td>
      <td>
        <a href="logos.jsp" title="EUNIS Database logos">Download EUNIS Database logos</a>
      </td>
    </tr>
  </table>
  <jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="services.jsp"/>
  </jsp:include>
    </div>
  </body>
</html>
<%
    return;
  }
%>
  <table width="100%" border="1" style="border-collapse:collapse" summary="layout">
    <tr>
      <th align="center">
        &nbsp;
      </th>
      <th>
        Services
      </th>
    </tr>
<%
  if(SessionManager.isUser_management_RIGHT() || SessionManager.isRole_management_RIGHT())
  {
%>
    <tr>
      <td align="center">
        <a href="users.jsp" title="User management"><img alt="User management" src="images/users.gif" width="81" height="43" border="0" title="Users management" /></a>
      </td>
      <td>
        <a href="users.jsp" title="User management">Add, update and delete users and users roles</a>
      </td>
    </tr>
<%
  }
%>
    <tr>
      <td align="center">
        <a href="users-bookmarks.jsp" title="User bookmarks"><img alt="User bookmarks" src="images/bookmarks.gif" width="81" height="43" border="0" title="Bookmarks management" /></a>
      </td>
      <td>
        <a href="users-bookmarks.jsp" title="User bookmarks">List, update and delete users bookmarks</a>
      </td>
    </tr>
    <tr>
      <td align="center">
        <a href="logos.jsp" title="EUNIS Database logos"><img alt="EUNIS Database logos" src="images/logos.gif" width="81" height="43" border="0" title="EUNIS Database logos" /></a>
      </td>
      <td>
        <a href="logos.jsp" title="EUNIS Database logos">Download EUNIS Database logos</a>
      </td>
    </tr>
<%
  if(SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT())
  {
%>
    <tr>
      <td align="center">
        <a href="headline.jsp" title="Edit EUNIS headline"><img alt="Edit EUNIS Database headline" src="images/headlines.gif" width="81" height="43" border="0" title="Edit headline" /></a>
      </td>
      <td>
        <a href="headline.jsp" title="Edit EUNIS headline">Edit EUNIS Database headlines</a>
      </td>
    </tr>
<%
  }
  if(SessionManager.isAuthenticated() && SessionManager.isEdit_glossary())
  {
%>
    <tr>
      <td align="center">
        <a href="glossary-table.jsp" title="Edit the glossary of terms"><img alt="Edit the glossary of terms" src="images/glossary.gif" width="81" height="43" border="0" title="Edit glossary of terms" /></a>
      </td>
      <td>
        <a href="glossary-table.jsp" title="Edit the glossary of terms">Edit the glossary of terms</a>
      </td>
    </tr>
<%
  }
%>
    <tr>
      <td align="center">
        <a href="download-database.jsp" title="Download database in Microsoft Access format"><img alt="Download database in Microsoft Access format" src="images/access.gif" width="81" height="43" border="0" title="Web content management" /></a>
      </td>
      <td>
        <a href="download-database.jsp" title="Download database in Microsoft Access format">Download database in Microsoft Access format</a>
      </td>
    </tr>
<%
  if(SessionManager.isAdmin())
  {
%>
    <tr>
      <td align="center">
        <a href="clear-temporary-data.jsp" title="Clear temporary data from the database"><img alt="Clear temporary data from the database" src="images/clean.gif" width="81" height="43" border="0" title="Clear temporary data from the database" /></a>
      </td>
      <td>
        <a href="clear-temporary-data.jsp" title="Clear temporary data from the database">Clear temporary data from the database</a>
      </td>
    </tr>
<%
  }
%>
    <tr>
      <td align="center">
        <a href="services.jsp?action=reloadlanguage" title="Refresh language"><img alt="Refresh language" src="images/language.gif" width="81" height="43" border="0" title="Refresh language texts" /></a>
      </td>
      <td>
        <a href="services.jsp?action=reloadlanguage" title="Refresh language">Refresh language</a>
      </td>
    </tr>
<%
  if(SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT())
  {
    if(!SessionManager.getWebContent().isEditMode())
    {
%>
    <tr>
      <td align="center">
        <a href="services.jsp?editContent=true" title="Activate inline content editor"><img alt="Activate inline content editor" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="Inline web content editor" /></a>
      </td>
      <td>
        <a href="services.jsp?editContent=true" title="Activate inline content editor">Activate inline editor for web content</a>
      </td>
    </tr>
<%
  }
  else
  {
%>
    <tr>
      <td align="center">
        <a href="services.jsp?editContent=false" title="Dezactivate inline content editor"><img alt="Dezactivate inline content editor" src="images/webcontent-inline.gif" width="81" height="43" border="0" title="Inline web content editor" /></a>
      </td>
      <td>
        <a href="services.jsp?editContent=false" title="Dezactivate inline content editor">Dezactivate inline editor</a>
      </td>
    </tr>
<%
    }
  }
%>
  </table>
  <jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="services.jsp"/>
  </jsp:include>
<%
  String action = request.getParameter("action");
  if(action != null && action.equals("reloadlanguage"))
  {
    //System.out.println("Rebuilding cache");
    SessionManager.getWebContent().reloadLanguageData();
%>
  <script language="JavaScript" type="text/javascript">
    <!--
    alert('Language data is now refreshed');
    //-->
  </script>
<%
  }
%>
     </div>
  </body>
</html>
