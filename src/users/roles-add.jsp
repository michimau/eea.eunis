<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Part of user management
--%>
<%@ page import="java.util.List,
                 ro.finsiel.eunis.jrfTables.users.RolesDomain,
                 ro.finsiel.eunis.jrfTables.users.RolesPersist,
                 ro.finsiel.eunis.jrfTables.users.UserDomain,
                 ro.finsiel.eunis.search.users.UsersUtility,
                 java.util.Vector,
                 ro.finsiel.eunis.jrfTables.users.UserPersist,
                 ro.finsiel.eunis.jrfTables.users.RightsDomain,
                 ro.finsiel.eunis.jrfTables.users.RightsPersist"%>
<%@ page contentType="text/html"%>

<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>


<%
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
    <noscript>Your browser does not support JavaScript!</noscript>
<%
     for (int i=0;i<ListRoles.size();i++)
     {
%>
          <script type="text/javascript" language="JavaScript">
             <!--
               roles_list[<%=i%>]='<%=((RolesPersist)ListRoles.get(i)).getRoleName()%>';
             //-->
         </script>
         <noscript>Your browser does not support JavaScript!</noscript>
<%
     }
  } else {
     %>
          <script type="text/javascript" language="JavaScript">
             <!--
               var roles_list = new Array(0);
             //-->
          </script>
          <noscript>Your browser does not support JavaScript!</noscript>
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
                   alert("This role name already exist!");
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
                   alert("This role name already exist!");
                   document.eunis.newRoleName.value = "";
                }
      return exist;
      }

        function validateAddForm() {

         if (document.eunis.roleName == null || trim(document.eunis.roleName.value)=='')
            {
             alert("You must insert a valid role name value!");
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
             alert("You must select a valid role name value!");
             return false;
            }

       if (document.eunis.newRoleName == null || trim(document.eunis.newRoleName.value)=='')
            {
             alert("You must insert a valid new role name value!");
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
             alert("You must select a valid role name value!");
            }
      else {
                 roleName = escape(trim(document.eunis.roleName.value));
                 document.location="users.jsp?operation=delete&roleName="+roleName+"&tab1=<%=tab1%>&tab2=<%=tab2%>";
           }
      }
      //-->
</script>
<noscript>Your browser does not support JavaScript!</noscript>

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
    Error: The web.xml file does not contain one/all of these required values: JDBC_DRV,JDBC_URL,JDBC_USR,JDBC_PWD.
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


          if(addRoleSuccess && addRightsSuccess) message = "Roles adding operation was made successfully.";
          else message = "<span color=\"red\">Roles adding operation wasn't made successfully.</span>";

        } else message = "<span color=\"red\">Roles adding operation wasn't made successfully.</span>";
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


        if(updateRoleSuccess) message = "Roles edit operation was made successfully.";
        else message = "<span color=\"red\">Roles edit operation wasn't made successfully.</span>";

      } else message = "<span color=\"red\">Roles edit operation wasn't made successfully.</span>";
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
            if(deleteWithSuccess) message = "Roles deleting operation was made successfully.";
            else message = "<span color=\"red\">Roles deleting operation wasn't made successfully.</span>";
        } else message = "<span color=\"red\">Roles deleting operation wasn't made successfully.</span>";
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

   <h5>
     EUNIS Database User Management
   </h5>
   <br />
   <h6>
       <%=(users_operation != null && users_operation.equalsIgnoreCase("edit")?"Edit":"Add")%> roles
   </h6>
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
          &nbsp;&nbsp;<label for="roleName">Select role name</label>
<%--            &nbsp;&nbsp;Select role name--%>
          </td>
          <td>
           <select id="roleName" name="roleName" class="inputTextField" style="border-width:1px" onchange="MM_jumpMenuRoles('parent',this,0,'<%=tab1%>','<%=tab2%>')"  title="List of role name">
           <option value="selectRoleName" selected="selected">Select a role name</option>
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
           &nbsp;&nbsp;&nbsp;
           <a title="Delete this role" href="javascript:deleteRole();">delete this role</a>
          </td>
        </tr>
        <%
        } else
         {
        %>
        <tr>
          <td>
          &nbsp;&nbsp;<label for="roleName1">Role name(*):</label>
<%--            &nbsp;&nbsp;Role name :--%>
          </td>
          <td>
           &nbsp;<input class="inputTextField" title="Role name" alt="Role name" type="text" id="roleName1" name="roleName" size="50" value="" onchange="RoleExist();" />
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
          &nbsp;&nbsp;<label for="newRoleName">Role name:</label>&nbsp;
<%--            &nbsp;&nbsp;Role name :&nbsp;--%>
          </td>
          <td>
           <input class="inputTextField" title="Role name" alt="Role name" type="text" id="newRoleName" name="newRoleName" size ="50" value="<%=name%>" onchange="NewRoleExist();" />
          </td>
        </tr>
        <%
         }
        %>
        <tr>
          <td>
          &nbsp;&nbsp;<label for="description">Description:</label>
<%--            &nbsp;&nbsp;Description :--%>
          </td>
          <td>
          <textarea title="Description" id="description" name="description" cols="50" rows="5" class="inputTextField"><%=description%></textarea>
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
          <strong>Rights</strong>
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
        <input title="Choose a right" alt="Choose a right" type="checkbox" id="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" name="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" value ="<%=((RightsPersist)rights.get(i)).getRightName()%>" <%=(UsersUtility.ifRoleRightObjectExist(request.getParameter("roleName"),((RightsPersist)rights.get(i)).getRightName())?"checked=\"checked\"":"")%> /><label for="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>"><%=UsersUtility.getNameNice(((RightsPersist)rights.get(i)).getRightName())%></label>
      </td>
      <%
          } else
          {
      %>
      <td>
        <label for="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" class="noshow">Right</label>
        <input title="Choose a right" alt="Choose a right" type="checkbox" id="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" name="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>" value ="<%=((RightsPersist)rights.get(i)).getRightName()%>" /><label for="rightxxx_<%=((RightsPersist)rights.get(i)).getRightName()%>"><%=UsersUtility.getNameNice(((RightsPersist)rights.get(i)).getRightName())%></label>
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
    <label for="input1" class="noshow">Edit role</label>
    <input id="input1" type="submit" value="Edit role" name="submit" onclick="document.eunis.operation.value='updateRole';" class="inputTextField"  title="Edit role" />&nbsp;&nbsp;
    <%
      } else
      {
    %>
    <label for="input2" class="noshow">Add role</label>
    <input id="input2" type="submit" value="Add role" name="submit" onclick="document.eunis.operation.value='submit';" class="inputTextField"   title="Add role" />&nbsp;&nbsp;
    <%
      }
    %>
    <label for="input3" class="noshow">Reset</label>
    <input id="input3" type="reset" value="Reset" name="Reset" class="inputTextField"  title="Reset" />
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
<strong>You cann't do this because you are not authentificated or you haven't this right!</strong>
<br />
<%
  }
%>