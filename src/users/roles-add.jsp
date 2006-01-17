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
                 ro.finsiel.eunis.jrfTables.users.RolesPersist,
                 ro.finsiel.eunis.jrfTables.users.UserDomain,
                 ro.finsiel.eunis.search.users.UsersUtility,
                 java.util.Vector,
                 ro.finsiel.eunis.jrfTables.users.UserPersist,
                 ro.finsiel.eunis.jrfTables.users.RightsDomain,
                 ro.finsiel.eunis.jrfTables.users.RightsPersist"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
    // Web content manager used in this page.
      WebContentManagement cm = SessionManager.getWebContent();

  // If user is authentificated and has this right
  if(SessionManager.isAuthenticated() && SessionManager.isRole_management_RIGHT())
{
  // Request parameters
  String tab1 = (request.getParameter("tab1")==null?"users":request.getParameter("tab1"));
  String tab2 = (request.getParameter("tab2")==null?(request.getParameter("tab1")==null?"view_users":(request.getParameter("tab1").equalsIgnoreCase("users")?"view_users":"view_roles")):request.getParameter("tab2"));

  try
  {
   // List of all roles
   List ListRoles = new RolesDomain().findAll();
   if(ListRoles != null && ListRoles.size() > 0)
   {
%>
    <script type="text/javascript" language="JavaScript">
       <!--
       var roles_list = new Array(<%=ListRoles.size()%>);
      //-->
    </script>
<%
     for (int i=0;i<ListRoles.size();i++)
     {
%>
          <script type="text/javascript" language="JavaScript">
             <!--
               roles_list[<%=i%>]='<%=((RolesPersist)ListRoles.get(i)).getRoleName()%>';
             //-->
         </script>
<%
     }
  } else {
     %>
          <script type="text/javascript" language="JavaScript">
             <!--
               var roles_list = new Array(0);
             //-->
          </script>
<%
         }
  }catch(Exception e){e.printStackTrace();}
%>

<script type="text/javascript" language="JavaScript">
      <!--

      function RoleExist(){
      roleName = escape(trim(document.eunis.roleName.value));
      roleName = roleName.replace(' ','_');
      exist=false;
      for(i=0;i<roles_list.length;i++)  if (roleName.toLowerCase() == roles_list[i].toLowerCase()) exist = true;
      if(exist) {
                   alert("<%=cm.cms("roles_add_01")%>");
                   document.eunis.roleName.value = "";
                }
      return exist;
      }

      function NewRoleExist(){
      newRoleName = escape(trim(document.eunis.newRoleName.value));
      roleName = escape(trim(document.eunis.roleName.value));
      newRoleName = newRoleName.replace(' ','_');
      exist=false;
      for(i=0;i<roles_list.length;i++)
          if (newRoleName.toLowerCase() == roles_list[i].toLowerCase()
              && roleName.toLowerCase() != roles_list[i].toLowerCase()) exist = true;
      if(exist) {
                   alert("<%=cm.cms("roles_add_01")%>");
                   document.eunis.newRoleName.value = "";
                }
      return exist;
      }

        function validateAddForm() {

         if (document.eunis.roleName == null || trim(document.eunis.roleName.value)=='')
            {
             alert("<%=cm.cms("roles_add_02")%>");
             return false;
            }

        if(RoleExist()) return false;

       return true;
        }

        function validateEditForm() {

       if (document.eunis.roleName == null
           || trim(document.eunis.roleName.value)==''
           || trim(document.eunis.roleName.value)=='selectRoleName')
            {
             alert("<%=cm.cms("roles_add_03")%>");
             return false;
            }

       if (document.eunis.newRoleName == null || trim(document.eunis.newRoleName.value)=='')
            {
             alert("<%=cm.cms("roles_add_04")%>");
             return false;
            }

        if(NewRoleExist()) return false;

       return true;
        }

      function deleteRole(){
      if (document.eunis.roleName == null
          || trim(document.eunis.roleName.value) == ''
          || trim(document.eunis.roleName.value) == 'selectRoleName')
            {
             alert("<%=cm.cms("roles_add_05")%>");
            }
      else {
                 roleName = escape(trim(document.eunis.roleName.value));
                 document.location="users.jsp?operation=delete&roleName="+roleName+"&tab1=<%=tab1%>&tab2=<%=tab2%>";
           }
      }
      //-->
</script>
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
    <%=cm.cmsText("roles_add_06")%>
<%
    return;
  }

String message = "";
// Request parameters
String operation = request.getParameter("operation");
String users_operation = (request.getParameter("users_operation") == null ? "edit" : request.getParameter("users_operation"));

//Set onSubmit string
String onSubmit="";
if (users_operation != null && users_operation.equalsIgnoreCase("edit"))
{
 onSubmit="onsubmit=\"return validateEditForm();\"";
}
else
{
 onSubmit="onsubmit=\"return validateAddForm();\"";
}

  if (operation!=null)
  {
      // if user choose to add a role
      if(operation.equalsIgnoreCase("submit"))
      {
        // if roleName is a valid role name
        if(request.getParameter("roleName") != null && !request.getParameter("roleName").trim().equalsIgnoreCase(""))
        {
          String description = (request.getParameter("description") == null ? "" : request.getParameter("description"));
          // Replace all " " with "_"
          String goodNameRole = request.getParameter("roleName").trim().replaceAll(" ","_");
           // add the role
           boolean addRoleSuccess = UsersUtility.addRoles(SessionManager.getUsername(),goodNameRole,description);
           boolean addRightsSuccess = false;
           if(addRoleSuccess) {
             // add rights for this role
             addRightsSuccess = UsersUtility.addRightsForRole(SessionManager.getUsername(),request,goodNameRole,SQL_URL,SQL_USR,SQL_PWD);
           }


          if(addRoleSuccess && addRightsSuccess) message = cm.cms("roles_add_07");
          else message = "<span color=\"red\">" + cm.cms("roles_add_08") + "</span>";

        } else message = "<span color=\"red\">"+cm.cms("roles_add_08")+"</span>";
      }

    // if user choose to update a role
    if(operation.equalsIgnoreCase("updateRole"))
    {
      // id roleName is a valid role name
      if(request.getParameter("roleName") != null
         && !request.getParameter("roleName").trim().equalsIgnoreCase("")
         && !request.getParameter("roleName").equalsIgnoreCase("selectRoleName")
         && request.getParameter("newRoleName") != null
         && !request.getParameter("newRoleName").trim().equalsIgnoreCase(""))
      {
        String description = (request.getParameter("description") == null ? "" : request.getParameter("description"));
        // replace all " " with "_"
        String goodNameRole = request.getParameter("newRoleName").trim().replaceAll(" ","_");
         // update the role
         boolean updateRoleSuccess = UsersUtility.editRoleName(SessionManager.getUsername(),
                                     goodNameRole,
                                     request.getParameter("roleName"),
                                     description,
                                     request,
                                     SQL_DRV,
                                     SQL_URL,
                                     SQL_USR,
                                     SQL_PWD);


        if(updateRoleSuccess) message = cm.cms("roles_add_10");
        else message = "<span color=\"red\">"+cm.cms("roles_add_11")+"</span>";

      } else message = "<span color=\"red\">"+cm.cms("roles_add_11")+"</span>";
    }
    // if user choose to delete a role
    if(operation.equalsIgnoreCase("delete"))
      {
        // if roleName is a valid role name
        if(request.getParameter("roleName") != null
           && !request.getParameter("roleName").equalsIgnoreCase("")
           && !request.getParameter("roleName").equalsIgnoreCase("selectRoleName")
           && UsersUtility.existRoleName(request.getParameter("roleName")))
        {
            // delete the role
            boolean deleteWithSuccess = UsersUtility.deleteRole(request.getParameter("roleName"),SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
            if(deleteWithSuccess) message = cm.cms("roles_add_13");
            else message = "<span color=\"red\">"+cm.cms("roles_add_14")+"</span>";
        } else message = "<span color=\"red\">"+cm.cms("roles_add_14")+"</span>";
      }
  }

String roleName = (request.getParameter("roleName") == null ? "" : request.getParameter("roleName"));
String name = "";
String description = "";
// if user choose 'edit' role, fill newRoleName and description field
if (users_operation != null && users_operation.equalsIgnoreCase("edit"))
 {
   RolesPersist role = UsersUtility.getRoleObject(roleName);
   if (role != null)
     {
      name = (role.getRoleName() == null ? "" : role.getRoleName());
      description = (role.getDescription() == null ? "" : role.getDescription());
     }
 }
%>

   <h1>
     <%=cm.cmsText("roles_add_16")%>
   </h1>
   <br />
   <h2>
       <%=(users_operation != null && users_operation.equalsIgnoreCase("edit")?cm.cmsText("edit"):cm.cmsText("add"))%> <%=cm.cmsText("roles")%>
   </h2>
   <br />

<form name="eunis" method="post" action="users.jsp" <%=onSubmit%>>
<input type="hidden" name="tab1" value="<%=tab1%>" />
<input type="hidden" name="tab2" value="<%=tab2%>" />
<input type="hidden" name="operation" value="" />

<table  summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse" class="tableBorder">
<tr>
   <td style="vertical-align:top">
     <br /><br /><br />
     <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
      <%
      if(users_operation.equalsIgnoreCase("edit"))
      {
      %>
        <tr>
          <td>
          &nbsp;&nbsp;<label for="roleName"><%=cm.cmsText("roles_add_17")%></label>
          </td>
          <td>
           <select id="roleName" name="roleName" class="inputTextField" style="border-width:1px" onchange="MM_jumpMenuRoles('parent',this,0,'<%=tab1%>','<%=tab2%>')"  title="<%=cm.cms("roles_add_18")%>">
           <option value="selectRoleName" selected="selected"><%=cm.cms("roles_add_19")%></option>
            <%
            try
            {
            // Roles list
            List roles = new RolesDomain().findOrderBy("A.ROLENAME");
             if(roles != null && roles.size() > 0)
             {
               for(int i=0;i<roles.size();i++)
               {

            %>
            <option value="<%=((RolesPersist)roles.get(i)).getRoleName()%>" <%=(name.equalsIgnoreCase(((RolesPersist)roles.get(i)).getRoleName())?"selected":"")%>><%=UsersUtility.getNameNice(((RolesPersist)roles.get(i)).getRoleName())%></option>
            <%
                }
              }
            }catch(Exception e){e.printStackTrace();}
            %>
           </select>
           <%=cm.cmsTitle("roles_add_18")%>
           &nbsp;&nbsp;&nbsp;
           <a title="<%=cm.cms("roles_add_20")%>" href="javascript:deleteRole();"><%=cm.cmsText("roles_add_20")%></a>
           <%=cm.cmsTitle("roles_add_20")%>
          </td>
        </tr>
        <%
        } else
         {
        %>
        <tr>
          <td>
          &nbsp;&nbsp;<label for="roleName1"><%=cm.cmsText("roles_add_21")%>(*):</label>
          </td>
          <td>
           &nbsp;<input class="inputTextField" title="<%=cm.cms("roles_add_22")%>" alt="<%=cm.cms("roles_add_22")%>" type="text" id="roleName1" name="roleName" size="50" value="" onchange="RoleExist();" />
           <%=cm.cmsTitle("roles_add_22")%>
          </td>
        </tr>
        <%
          }
        %>
        <tr>
          <td colspan="2">
             &nbsp;
          </td>
        </tr>
        <%
         if(users_operation.equalsIgnoreCase("edit"))
         {
        %>
        <tr>
          <td>
          &nbsp;&nbsp;<label for="newRoleName"><%=cm.cmsText("roles_add_21")%>:</label>&nbsp;
          </td>
          <td>
           <input class="inputTextField" title="<%=cm.cms("roles_add_22")%>" alt="<%=cm.cms("roles_add_22")%>" type="text" id="newRoleName" name="newRoleName" size ="50" value="<%=name%>" onchange="NewRoleExist();" />
           <%=cm.cmsTitle("roles_add_22")%>
          </td>
        </tr>
        <%
         }
        %>
        <tr>
          <td>
          &nbsp;&nbsp;<label for="description"><%=cm.cmsText("roles_add_23")%>:</label>
          </td>
          <td>
          <textarea title="<%=cm.cms("roles_add_23")%>" id="description" name="description" cols="50" rows="5" class="inputTextField"><%=description%></textarea>
          <%=cm.cmsTitle("roles_add_23")%>
          </td>
        </tr>
    </table>
      <p>&nbsp;</p>
  </td>
  <td style="vertical-align:top">
  &nbsp;
     <%
       try
       {
       // Rights list
       List rights = new RightsDomain().findOrderBy("A.RIGHTNAME");
       if(rights != null && rights.size() > 0)
       {
      %>
     <table summary="layout" class="valign" width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
       <td style="text-align:left">
          <strong><%=cm.cmsText("roles_add_24")%></strong>
       </td>
      </tr>
     <%
         for(int i=0;i<rights.size();i++)
            {
     %>
      <tr>
      <%
          if(users_operation != null && users_operation.equalsIgnoreCase("edit"))
          {
      %>
      <td>
        <label for="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" class="noshow">Right</label>
        <input title="<%=cm.cms("roles_add_25")%>" alt="<%=cm.cms("roles_add_25")%>" type="checkbox" id="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" name="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" value ="<%=((RightsPersist)rights.get(i)).getRightName()%>" <%=(UsersUtility.ifRoleRightObjectExist(request.getParameter("roleName"),((RightsPersist)rights.get(i)).getRightName())?"checked=\"checked\"":"")%> /><label for="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>"><%=UsersUtility.getNameNice(((RightsPersist)rights.get(i)).getRightName())%></label>
        <%=cm.cmsTitle("roles_add_25")%>
      </td>
      <%
          } else
          {
      %>
      <td>
        <label for="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" class="noshow">Right</label>
        <input title="<%=cm.cms("roles_add_25")%>" alt="<%=cm.cms("roles_add_25")%>" type="checkbox" id="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" name="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" value ="<%=((RightsPersist)rights.get(i)).getRightName()%>" /><label for="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>"><%=UsersUtility.getNameNice(((RightsPersist)rights.get(i)).getRightName())%></label>
        <%=cm.cmsTitle("roles_add_25")%>
      </td>
      <%
          }
      %>
    </tr> <tr><td>&nbsp;</td></tr>
    <%
            }
    %>
     </table>
    <%
       }
       } catch(Exception e){e.printStackTrace();}
    %>
  </td>
</tr>
  <tr>
   <td style="text-align:left">
   &nbsp;&nbsp;
    <%
      if(users_operation != null && users_operation.equalsIgnoreCase("edit"))
      {
    %>
    <input id="input1" type="submit" value="<%=cm.cms("roles_add_27")%>" name="submit" onclick="document.eunis.operation.value='updateRole';" class="inputTextField"  title="<%=cm.cms("roles_add_26")%>" />
    <%=cm.cmsTitle("roles_add_26")%>
    <%=cm.cmsInput("roles_add_27")%> &nbsp;&nbsp;
    <%
      } else
      {
    %>
    <input id="input2" type="submit" value="<%=cm.cms("roles_add_29")%>" name="submit" onclick="document.eunis.operation.value='submit';" class="inputTextField"   title="<%=cm.cms("roles_add_28")%>" />
    <%=cm.cmsTitle("roles_add_28")%>
    <%=cm.cmsInput("roles_add_29")%>&nbsp;&nbsp;
    <%
      }
    %>
    <input id="input3" type="reset" value="<%=cm.cms("reset_btn")%>" name="Reset" class="inputTextField"  title="<%=cm.cms("reset")%>" />
    <%=cm.cmsTitle("reset")%>
    <%=cm.cmsInput("reset_btn")%>
  </td>
 </tr>
 <tr>
  <td>
    &nbsp;
   </td>
 </tr>
 <tr>
  <td>
    <hr noshade="noshade" size="1" />
  </td>
  <td>
    <hr noshade="noshade" size="1" />
  </td>
 </tr>
 <tr>
  <td>
    Message: <%=message%>
   </td>
 </tr>
<tr>
  <td>
    &nbsp;
   </td>
 </tr>
</table>
</form>
<br />


<%
  } else
  {
%>
<strong><%=cm.cmsText("roles_add_30")%></strong>
<br />
<%
  }
%>

<%=cm.br()%>
<%=cm.cmsMsg("roles_add_01")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_02")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_03")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_04")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_05")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_07")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_08")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_10")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_11")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_13")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_14")%>
<%=cm.br()%>
<%=cm.cmsMsg("roles_add_19")%>
<%=cm.br()%>