<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Part of user management
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.List,
                 ro.finsiel.eunis.jrfTables.users.RolesDomain,
                 ro.finsiel.eunis.jrfTables.users.RightsDomain,
                 ro.finsiel.eunis.jrfTables.users.RightsPersist,
                 ro.finsiel.eunis.jrfTables.users.RolesPersist,
                 ro.finsiel.eunis.search.users.UsersUtility,
                 java.util.Enumeration"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
    // Web content manager used in this page.
      WebContentManagement cm = SessionManager.getWebContent();

  // If user is authentificated and has this right
  if(SessionManager.isAuthenticated() && SessionManager.isRole_management_RIGHT())
{
%>
<h1>
  <%=cm.cmsText("roles_view_01")%>
</h1>
<br />
<h2>
   <%=cm.cmsText("roles_view_02")%>
</h2>
<br />
<%
  // Set database parameters
  String SQL_DRV="";
  String SQL_URL="";
  String SQL_USR="";
  String SQL_PWD="";

  SQL_DRV = application.getInitParameter("JDBC_DRV");
  SQL_URL = application.getInitParameter("JDBC_URL");
  SQL_USR = application.getInitParameter("JDBC_USR");
  SQL_PWD = application.getInitParameter("JDBC_PWD");
  // If some of them is null, the wanted database operation isn't made
  if(SQL_DRV == null || SQL_URL==null || SQL_USR == null || SQL_PWD==null )
  {
%>
    <%=cm.cmsText("roles_view_03")%>
<%
    return;
  }
// Request parameters
String tab1 = (request.getParameter("tab1")==null?"users":request.getParameter("tab1"));
String tab2 = (request.getParameter("tab2")==null?(request.getParameter("tab1")==null?"view_users":(request.getParameter("tab1").equalsIgnoreCase("users")?"view_users":"view_roles")):request.getParameter("tab2"));

%>
<form name="eunis" method="post" action="users.jsp">
 <input type="hidden" name="tab1" value="<%=tab1%>" />
 <input type="hidden" name="tab2" value="<%=tab2%>" />
 <input type="hidden" name="operation" value="" />
 <input type="hidden" name="deleteWho" value="" />
<%
try {
// Roles list
List roles = new RolesDomain().findOrderBy("A.ROLENAME");
// Rights list
List rights = new RightsDomain().findOrderBy("A.RIGHTNAME");
if(roles != null && roles.size() > 0)
{
%>
  <table summary="layout" width="100%" border="1" style="border-collapse: collapse">
  <tr>
    <td style="text-align:left">
     <strong>
      <%=cm.cmsText("roles_view_04")%>
     </strong>
    </td>
  <%
     for(int i=0;i<roles.size();i++)
     {
      RolesPersist role = (RolesPersist)roles.get(i);
      String tooltip = (role.getDescription() != null && !role.getDescription().trim().equalsIgnoreCase("")  ? "  title=\""+(role.getDescription())+"\" ":"");
  %>
    <td style="text-align:center" <%=tooltip%>>
      <strong>
      <a href="users.jsp?tab1=1&amp;tab2=1&amp;roleName=<%=role.getRoleName()%>" title="<%=cm.cms("roles_view_05")%>">
        <%=UsersUtility.getNameNice(role.getRoleName())%>
      </a>
      <%=cm.cmsTitle("roles_view_05")%>
      </strong>    
    </td>
  <%
     }
  %>
  </tr>
  <%
     if(rights != null && rights.size() > 0)
     {
       for(int j=0;j<rights.size();j++)
       {
         RightsPersist right = (RightsPersist)rights.get(j);
         String tooltip = (right.getDescription() != null && !right.getDescription().trim().equalsIgnoreCase("")  ? " title=\""+(right.getDescription())+"\" " : "");
  %>
  <tr>
    <td style="text-align:left" <%=tooltip%>>
      <a href="users.jsp?tab1=1&amp;tab2=3&amp;rightName=<%=right.getRightName()%>" title="<%=cm.cms("roles_view_06")%>">
       <%=UsersUtility.getNameNice(right.getRightName())%>
      </a>
      <%=cm.cmsTitle("roles_view_06")%>
    </td>
  <%
     for(int i=0;i<roles.size();i++)
     {
        RolesPersist role = (RolesPersist)roles.get(i);
    %>
    <td style="text-align:center">
       <label for="<%=role.getRoleName()%>_rightxxx_<%=right.getRightName()%>" class="noshow"><%=cm.cms("roles_view_07")%></label>
       <input id="<%=role.getRoleName()%>_rightxxx_<%=right.getRightName()%>" title="<%=cm.cms("roles_view_07")%>" alt="<%=cm.cms("roles_view_07")%>" name="<%=role.getRoleName()%>_rightxxx_<%=right.getRightName()%>" type="checkbox" value="checkbox" <%=(UsersUtility.ObjectIsInVector(UsersUtility.getRolesRightsName(role.getRoleName()),right.getRightName())?"checked=\"checked\"":"")%> disabled="disabled" />
       <%=cm.cmsLabel("roles_view_07")%>
       <%=cm.cmsTitle("roles_view_07")%>
    </td>
  <%
    }
  %>
  </tr>
  <%
    }
     }
  %>
  </table>
<%
}
} catch(Exception e){e.printStackTrace();}
%>
</form>
<%
} else
  {
%>
  <strong><%=cm.cmsText("roles_view_08")%></strong>
<br />
<%
  }
%>