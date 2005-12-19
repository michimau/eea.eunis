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
                 java.util.Enumeration,
                 ro.finsiel.eunis.auth.EncryptPassword,
                 ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>

<%
    // Web content manager used in this page.
      WebContentManagement cm = SessionManager.getWebContent();

// If user is authentificated and has this right
if(SessionManager.isAuthenticated() && SessionManager.isUser_management_RIGHT())
{
  // Set what cell from first line was selected
  String tab1 = (request.getParameter("tab1")==null?"users":request.getParameter("tab1"));
  // Set what cell from second line was selected
  String tab2 = (request.getParameter("tab2")==null?(request.getParameter("tab1")==null?"view_users":(request.getParameter("tab1").equalsIgnoreCase("users")?"view_users":"view_roles")):request.getParameter("tab2"));

 try
{
   // All users list
   List ListUsers = new UserDomain().findCustom("SELECT USERNAME,PASSWORD,FIRST_NAME,LAST_NAME,LANG,EMAIL, "  +
              " THEME_INDEX,DATE_FORMAT(login_date,'%d %b %Y %H:%i:%s') "  +
              " FROM EUNIS_USERS ORDER BY USERNAME ");
   if(ListUsers != null && ListUsers.size() > 0)
   {
%>
    <script language="JavaScript" type="text/javascript">
       <!--
       var users_list = new Array(<%=ListUsers.size()%>);
      //-->
    </script>
    <script language="JavaScript" type="text/javascript">
      <!--
      <%
        for (int i=0;i<ListUsers.size();i++)
        {
      %>
           users_list[<%=i%>]='<%=((UserPersist)ListUsers.get(i)).getUsername()%>';
      <%
        }
      %>
       //-->
     </script>
<%
  } else {
     %>
          <script language="JavaScript" type="text/javascript">
             <!--
               var users_list = new Array(0);
             //-->
          </script>
<%
        }
}catch(Exception e){e.printStackTrace();}

%>

<script language="JavaScript" type="text/javascript">
      <!--

      function UserExist(){
      userName = escape(trim(document.eunis.userName.value));
      exist=false;
      for(i=0;i<users_list.length;i++) if (userName.toLowerCase() == users_list[i].toLowerCase()) exist = true;
      if(exist) {
                   alert("<%=cm.cms("users_edit_01")%>");
                   document.eunis.userName.value = "";
                }
      return exist;
      }

      function newUserNameExist(){
      userName = escape(trim(document.eunis.userName.value));
      newUserName = escape(trim(document.eunis.newUserName.value));
      exist=false;
      for(i=0;i<users_list.length;i++)
             if (newUserName.toLowerCase() == users_list[i].toLowerCase()
                 && userName.toLowerCase() != users_list[i].toLowerCase()) exist = true;
      if(exist) {
                   alert("<%=cm.cms("users_edit_02")%>");
                   document.eunis.newUserName.value = "";
                }
      return exist;
      }

        function validateFormEdit() {

       if (document.eunis.userName == null
           || trim(document.eunis.userName.value)==''
           || trim(document.eunis.userName.value)=='selectUserName')
            {
             alert("<%=cm.cms("users_edit_03")%>");
             return false;
            }

       if (document.eunis.newUserName == null || trim(document.eunis.newUserName.value)=='')
            {
             alert("<%=cm.cms("users_edit_04")%>");
             return false;
            }


       if (document.eunis.password1 == null || trim(document.eunis.password1.value)==''
           || document.eunis.password2 == null || trim(document.eunis.password2.value)=='')
            {
             alert("<%=cm.cms("users_edit_05")%>");
             return false;
            }

          if (document.eunis.password1.value != document.eunis.password2.value)
            {
             alert("<%=cm.cms("users_edit_06")%>");
             return false;
            }

          if (newUserNameExist()) return false;

       return true;
        }


   function validateFormAdd() {
        if( document.eunis.userName == null
        || document.eunis.password1 == null
        || document.eunis.password2 == null
        || trim(document.eunis.userName.value)==''
        || trim(document.eunis.password1.value)==''
        || trim(document.eunis.password2.value)=='')
            {
             alert("<%=cm.cms("users_edit_07")%>");
             return false;
            }

        if(UserExist()) return false;

        if (document.eunis.password1.value != document.eunis.password2.value)
            {
             alert("<%=cm.cms("users_edit_08")%>");
             return false;
            }

       return true;
        }




      function deleteUser(manager){
      if (document.eunis.userName==null
          || trim(document.eunis.userName.value)==''
          || trim(document.eunis.userName.value)=='selectUserName')
            {
             alert("<%=cm.cms("users_edit_09")%>");
            }
      else {
             if(trim(manager.toLowerCase()) == trim(document.eunis.userName.value.toLowerCase()))
                 alert("<%=cm.cms("users_edit_10")%>"+manager+"<%=cm.cms("users_edit_11")%>");
             else
               {
                 userName = escape(trim(document.eunis.userName.value));
                 document.location="users.jsp?operation=delete&userName="+userName+"&tab1=<%=tab1%>&tab2=<%=tab2%>";
               }
           }
      }

      function insertPassword1(){

        if (!validPassword(document.eunis.password1.value))
            {
             document.eunis.password1.value='';
             return false;
            }
       return true;
      }

      function insertPassword2(){

        if (!validPassword(document.eunis.password2.value))
            {
             document.eunis.password2.value='';
             return false;
            }

          if (document.eunis.password1.value != document.eunis.password2.value)
            {
             alert("<%=cm.cms("users_edit_12")%>");
             document.eunis.password2.value='';
             return false;
            }

        return true;
      }


    function validPassword(password){
       if(trim(password)=='')
         {
             alert("<%=cm.cms("users_edit_13")%>");
             return false;
         }
       return true;
    }


    function validateChooseRoles(rolename) {

    str = 'rolexxx_'+rolename;

    if(document.eunis.elements[str] !=  null && eval(document.eunis.elements[str]).checked == true)
    {
    if (rolename.toLowerCase() == 'administrator')
     {
       var someIsChecked = false;
       for(i=0;i<document.eunis.elements.length;i++)
             if (document.eunis.elements[i] != null &&
                 document.eunis.elements[i].name.indexOf('rolexxx') != -1 &&
                 eval(document.eunis.elements[i]).checked == true &&
                 document.eunis.elements[i].name.toLowerCase() != 'rolexxx_Administrator'.toLowerCase()) someIsChecked = true;

       if (someIsChecked)
           {
             alert("<%=cm.cms("users_edit_14")%>");
             box = eval(document.eunis.elements[str]);
             box.checked = !box.checked;
             return false;
           }
           else return true;
      } else {
                 if (document.eunis.elements[str] !=  null
                     && eval(document.eunis.elements[str]).checked == true
                     && document.eunis.rolexxx_Administrator != null
                     && eval(document.eunis.rolexxx_Administrator).checked == true)
                     {
                       alert("<%=cm.cms("users_edit_15")%>");
                       box = eval(document.eunis.elements[str]);
                       box.checked = !box.checked;
                       return false;
                     }
                     else return true;
      }
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
    <%=cm.cmsText("users_edit_16")%>
<%
    return;
  }

String message = "";
//Request parameters
String userName = (request.getParameter("userName") == null ? "" : request.getParameter("userName"));
String operation = request.getParameter("operation");
String users_operation = (request.getParameter("users_operation") == null ? "edit_users" : request.getParameter("users_operation"));

String onSubmit = "";
// if user choose 'edit_users'
if(users_operation.equalsIgnoreCase("edit_users"))
  {
    // Set onSubmit string
    onSubmit = "return validateFormEdit();";
    if (operation!=null)
     {
    // if user choose 'update user'
    if(operation.equalsIgnoreCase("submit"))
    {
      // if userName and newUserName are valides names
      if(request.getParameter("userName") != null
              && !request.getParameter("userName").trim().equalsIgnoreCase("")
              && !request.getParameter("userName").equalsIgnoreCase("selectUserName")
              && request.getParameter("newUserName") != null
              && !request.getParameter("newUserName").trim().equalsIgnoreCase(""))
      {
        String firstName = (request.getParameter("firstName")==null?"":request.getParameter("firstName"));
        String lastName = (request.getParameter("lastName")==null?"":request.getParameter("lastName"));
        String mail = (request.getParameter("mail")==null?"":request.getParameter("mail"));
        String password = (request.getParameter("password1")==null?"":request.getParameter("password1"));
        //String loginDate = (request.getParameter("loginDate")==null?"":request.getParameter("loginDate"));
        String loginDate = null;
        //System.out.println("----------loginDate="+loginDate+"+");
        // set newUserName to lower case
        String goodNewUserName = request.getParameter("newUserName").toLowerCase();
        // Update user
        boolean editWithSuccess = UsersUtility.editUser(SessionManager.getUsername(),userName,firstName,lastName,mail,loginDate,password,goodNewUserName,request,SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
        if(editWithSuccess) message = cm.cms("users_edit_17");
        else message = "<span color=\"red\">"+cm.cms("users_edit_18")+"</span>";

      } else message = "<span color=\"red\">"+cm.cms("users_edit_18")+"</span>";
    }
  // if user choose to delete a user
  if(operation.equalsIgnoreCase("delete"))
  {
       // if userName is a valid name
       if(request.getParameter("userName") != null
          && !request.getParameter("userName").equalsIgnoreCase("")
          && !request.getParameter("userName").equalsIgnoreCase("selectUserName")
          && !userName.equalsIgnoreCase(SessionManager.getUsername())
          && UsersUtility.existUserName(request.getParameter("userName")))
       {
           // delete the user
           boolean deleteWithSucces = UsersUtility.deleteUser(userName,SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
           if(deleteWithSucces) message = cm.cms("users_edit_20");
           else message = "<span color=\"red\">"+cm.cms("users_edit_21")+"</span>";
       }  else message = "<span color=\"red\">"+cm.cms("users_edit_21")+"</span>";
   }

}
}

  // if user choose 'add_users'
  if(users_operation.equalsIgnoreCase("add_users"))
  {
  // set onSubmit string
  onSubmit = "return validateFormAdd();";
  if (operation!=null)
    {
      // if user choose to add a new user
      if(operation.equalsIgnoreCase("submit"))
      {
        // if userName is a valid name
        if(request.getParameter("userName") != null
           && !request.getParameter("userName").equalsIgnoreCase("")
           && request.getParameter("password1") != null
           && !request.getParameter("password1").equalsIgnoreCase("")
           && request.getParameter("password2") != null
           && !request.getParameter("password2").equalsIgnoreCase("")
           && request.getParameter("password1").equalsIgnoreCase(request.getParameter("password2")))
        {
          String firstName = (request.getParameter("firstName") == null ? "" : request.getParameter("firstName"));
          String lastName = (request.getParameter("lastName") == null ? "" : request.getParameter("lastName"));
          String mail = (request.getParameter("mail") == null ? "" : request.getParameter("mail"));
          String password = (request.getParameter("password1") == null ? "" : request.getParameter("password1"));
          //String loginDate = (request.getParameter("loginDate") == null ? "" : request.getParameter("loginDate"));
          String loginDate = null;
          // set userName to lower case
          String goodUserName = request.getParameter("userName").toLowerCase();
           // Add user
           boolean addUserSuccess = UsersUtility.addUsers(goodUserName,password,firstName,lastName,mail,loginDate,SessionManager.getUsername(),SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
           boolean addRolesSuccess = false;
           if(addUserSuccess){
             // Add roles for user
             addRolesSuccess = UsersUtility.addRolesForUser(goodUserName,request,SessionManager.getUsername(),SQL_URL,SQL_USR,SQL_PWD);
           }


          if(addUserSuccess && addRolesSuccess) message = cm.cms("users_edit_23");
          else message = "<span color=\"red\">"+cm.cms("users_edit_24")+"</span>";
        } else message = "<span color=\"red\">"+cm.cms("users_edit_24")+"</span>";
      }
    }
  }



String name = "";
String firstName = "";
String lastName = "";
String mail = "";
String password = "";
String loginDate = "";
// Set fields where a userName was selected at 'edit user' operation
UserPersist user = UsersUtility.getUserByUserName(userName);
if(user != null) name = (user.getUsername()==null?"":user.getUsername());
if(user != null) firstName = (user.getFirstName()==null?"":user.getFirstName());
if(user != null) lastName = (user.getLastName()==null?"":user.getLastName());
if(user != null) mail = (user.getEMail()==null?"":user.getEMail());
if(user != null) password = (user.getPassword()==null?"":user.getPassword());
if(user != null) loginDate = (user.getLoginDate()==null?"":user.getLoginDate());
%>

<h1>
   <%=cm.cmsText("users_edit_26")%>
</h1>
<br />
<h2>
   <%=cm.cmsText("users_edit_27")%>
</h2>
<br />

<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse" class="tableBorder">
<tr>
  <td colspan="2">
    &nbsp;
  </td>
</tr>
<tr>
  <td colspan="2">
    &nbsp;
  </td>
</tr>
<tr>
<td>
<form name="eunis" method="post" action="users.jsp" onsubmit="<%=onSubmit%>">
<input type="hidden" name="tab1" value="<%=tab1%>" />
<input type="hidden" name="tab2" value="<%=tab2%>" />
<input type="hidden" name="operation" value="" />
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
  <td>
   <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
    <%
      if(users_operation.equalsIgnoreCase("edit_users"))
      {
    %>
   <tr>
     <td>
     &nbsp;&nbsp;<label for="userName"><%=cm.cmsText("users_edit_28")%></label>
     </td>
     <td>
       <select id="userName" name="userName" class="inputTextField" style="border-width : 1px" onchange="MM_jumpMenu('parent',this,0,'<%=tab1%>','<%=tab2%>')"  title="<%=cm.cms("users_edit_29")%>">
            <option value="selectUserName" selected="selected"><%=cm.cms("users_edit_30")%></option>
            <%
               try
               {
               // Users names list
               List users = new UserDomain().findCustom("SELECT USERNAME,PASSWORD,FIRST_NAME,LAST_NAME,LANG,EMAIL, "  +
              " THEME_INDEX,DATE_FORMAT(login_date,'%d %b %Y %H:%i:%s') "  +
              " FROM EUNIS_USERS ORDER BY USERNAME ");
                if(users != null && users.size() > 0)
                {
                  for(int i=0;i<users.size();i++)
                  {

           %>
           <option value="<%=((UserPersist)users.get(i)).getUsername()%>" <%=(userName.equalsIgnoreCase(((UserPersist)users.get(i)).getUsername())?"selected=\"selected\"":"")%>><%=((UserPersist)users.get(i)).getUsername()%></option>
               <%
                  }
                }
               } catch(Exception e){e.printStackTrace();}
            %>
       </select>
       <%=cm.cmsTitle("users_edit_29")%>
       &nbsp;&nbsp;&nbsp;
      <a title="<%=cm.cms("users_edit_31")%>" href="javascript:deleteUser('<%=SessionManager.getUsername()%>');"><%=cm.cmsText("users_edit_32")%></a>
      <%=cm.cmsTitle("users_edit_31")%>
    </td>
  </tr>
    <%
      } else
      {
    %>
  <tr>
    <td>
       &nbsp;&nbsp;<label for="userName1"><%=cm.cmsText("users_edit_33")%>(*):</label>
    </td>
    <td>
     &nbsp;&nbsp;&nbsp;<input class="inputTextField" title="<%=cm.cms("users_edit_33")%>" alt="<%=cm.cms("users_edit_33")%>" type="text" name="userName" id="userName1" size="50" value="" onchange="UserExist();" />
     <%=cm.cmsTitle("users_edit_33")%>
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
      if(users_operation.equalsIgnoreCase("edit_users"))
      {
    %>
    <tr>
      <td>
        &nbsp;&nbsp;<label for="newUserName"><%=cm.cmsText("users_edit_34")%>:</label>
      </td>
      <td>
       <input class="inputTextField" title="<%=cm.cms("users_edit_34")%>" alt="<%=cm.cms("users_edit_34")%>" type="text" name="newUserName" id="newUserName" size="50" value="<%=name%>" onchange="newUserNameExist();" />
       <%=cm.cmsTitle("users_edit_34")%>
      </td>
    </tr>
    <%
      }
    %>
    <tr>
      <td>
        &nbsp;&nbsp;<label for="firstName"><%=cm.cmsText("users_edit_35")%>:</label>
      </td>
      <td>
        <%=(users_operation.equalsIgnoreCase("add_users")?"&nbsp;&nbsp;&nbsp;":"")%><input class="inputTextField" title="<%=cm.cms("users_edit_35")%>" alt="<%=cm.cms("users_edit_35")%>" type="text" id="firstName" name="firstName" size="50" value="<%=(users_operation.equalsIgnoreCase("edit_users")?firstName:"")%>" />
        <%=cm.cmsTitle("users_edit_35")%>
      </td>
    </tr>
    <tr>
      <td>
       &nbsp;&nbsp;<label for="lastName"><%=cm.cmsText("users_edit_36")%>:</label>
      </td>
      <td>
        <%=(users_operation.equalsIgnoreCase("add_users")?"&nbsp;&nbsp;&nbsp;":"")%><input class="inputTextField" title="<%=cm.cms("users_edit_36")%>" alt="<%=cm.cms("users_edit_36")%>" type="text" id="lastName" name="lastName" size="50" value="<%=(users_operation.equalsIgnoreCase("edit_users")?lastName:"")%>" />
        <%=cm.cmsTitle("users_edit_36")%>
      </td>
    </tr>
    <tr>
      <td>
      &nbsp;&nbsp;<label for="mail"><%=cm.cmsText("users_edit_37")%>:</label>
      </td>
      <td>
        <%=(users_operation.equalsIgnoreCase("add_users")?"&nbsp;&nbsp;&nbsp;":"")%><input class="inputTextField" title="<%=cm.cms("users_edit_37")%>" alt="<%=cm.cms("users_edit_37")%>" type="text" id="mail" name="mail" size="50" value="<%=(users_operation.equalsIgnoreCase("edit_users")?mail:"")%>" />
        <%=cm.cmsTitle("users_edit_37")%>
      </td>
    </tr>
    <tr>
      <td>
        &nbsp;&nbsp;<label for="password1"><%=cm.cmsText("users_edit_38")%><%=(users_operation.equalsIgnoreCase("add_users")?"(*)":"")%>:</label>
      </td>
      <td>
        <%=(users_operation.equalsIgnoreCase("add_users")?"&nbsp;&nbsp;&nbsp;":"")%><input class="inputTextField" title="<%=cm.cms("users_edit_38")%>" alt="<%=cm.cms("users_edit_38")%>" type="text" id="password1" name="password1" size="50" value="<%=(users_operation.equalsIgnoreCase("edit_users")?password:"")%>" />
        <%=cm.cmsTitle("users_edit_38")%>
      </td>
    </tr>
    <tr>
      <td>
        &nbsp;&nbsp;<label for="password2"><%=cm.cmsText("users_edit_39")%><%=(users_operation.equalsIgnoreCase("add_users")?"(*)":"")%>:</label>
      </td>
      <td>
        <%=(users_operation.equalsIgnoreCase("add_users")?"&nbsp;&nbsp;&nbsp;":"")%><input class="inputTextField" title="<%=cm.cms("users_edit_39")%>" alt="<%=cm.cms("users_edit_39")%>" type="text" id="password2" name="password2" size="50" value="<%=(users_operation.equalsIgnoreCase("edit_users")?password:"")%>" />
        <%=cm.cmsTitle("users_edit_39")%>
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
         // Roles names list
         List roles = new RolesDomain().findOrderBy("A.ROLENAME");
         if(roles != null && roles.size() > 0)
         {
        %>
    <table summary="layout" class="valign" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td style="text-align:left">
            <strong><%=cm.cmsText("users_edit_40")%></strong>
          </td>
        </tr>
        <%
         for(int i=0;i<roles.size();i++)
          {
           String roleName = ((RolesPersist)roles.get(i)).getRoleName();
           roleName = (roleName.equalsIgnoreCase("administrator") ? "Administrator" : roleName);
       %>
       <tr>
         <td>
           <input title="<%=cm.cms("users_edit_41")%>" alt="<%=cm.cms("users_edit_41")%>" type="checkbox" id="rolexxx_<%=roleName%>" name="rolexxx_<%=roleName%>" onclick="validateChooseRoles('<%=roleName%>');" value ="<%=roleName%>" <%=(users_operation.equalsIgnoreCase("edit_users")?(UsersUtility.ObjectIsInVector(UsersUtility.getUsersRoles(userName),((RolesPersist)roles.get(i)).getRoleName())?"checked=\"checked\"":""):"")%>  onmouseover="return showtooltip('<%=UsersUtility.getRolesRightsAsString(((RolesPersist)roles.get(i)).getRoleName())%>')" onmouseout="hidetooltip()"  /><label for="rolexxx_<%=roleName%>"><%=((RolesPersist)roles.get(i)).getRoleName()%></label>
           <%=cm.cmsTitle("users_edit_41")%>
         </td>
      </tr>
      <%
           }
      %>
    </table>
      <%
         }
         }catch (Exception e) {e.printStackTrace();}
      %>
  </td>
</tr>
<%
  if(users_operation.equalsIgnoreCase("add_users"))
  {
%>
<tr>
  <td colspan="2">
    <%=cm.cmsText("users_edit_42")%>
  </td>
</tr>
<tr>
  <td colspan="2">
    &nbsp;
  </td>
</tr>
<%
  }
%>
<tr>
  <td style="text-align:left" colspan="2">
   &nbsp;&nbsp;
   <label for="input1" class="noshow"><%=(users_operation.equalsIgnoreCase("edit_users")?cm.cms("users_edit_43"):cm.cms("users_edit_44"))%></label>
   <input id="input1" type="submit" value="<%=(users_operation.equalsIgnoreCase("edit_users")?cm.cms("users_edit_45"):cm.cms("users_edit_46"))%>" name="submit" onclick="document.eunis.operation.value='submit';" class="inputTextField"  title="<%=(users_operation.equalsIgnoreCase("edit_users")?cm.cms("users_edit_43"):cm.cms("users_edit_44"))%>" />
   <%=(users_operation.equalsIgnoreCase("edit_users")?cm.cmsLabel("users_edit_43"):cm.cmsLabel("users_edit_44"))%>
   <%=(users_operation.equalsIgnoreCase("edit_users")?cm.cmsTitle("users_edit_43"):cm.cmsTitle("users_edit_44"))%>
   <%=(users_operation.equalsIgnoreCase("edit_users")?cm.cmsInput("users_edit_45"):cm.cmsInput("users_edit_46"))%>
   &nbsp;&nbsp;
   <%
    if(users_operation.equalsIgnoreCase("add_users"))
    {
   %>
     <label for="input2" class="noshow"><%=cm.cms("reset")%></label>
     <input id="input2" type="reset" value="<%=cm.cms("reset_btn")%>" name="Reset" class="inputTextField"  title="<%=cm.cms("reset")%>" />
     <%=cm.cmsLabel("reset")%>
     <%=cm.cmsTitle("reset")%>
     <%=cm.cmsInput("reset_btn")%>
  <%
    }
  %>
  </td>
</tr>
</table>
</form>
</td>
</tr>
<tr>
  <td colspan="2">
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
  <td colspan="2">
    Message: <%=message%>
  </td>
</tr>
<tr>
  <td colspan="2">
    &nbsp;
  </td>
</tr>
</table>
<br />
<%
  } else {
%>
    <strong><%=cm.cmsText("users_edit_47")%></strong>
<br />
<%
  }
%>

<%=cm.br()%>
<%=cm.cmsMsg("users_edit_01")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_02")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_03")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_04")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_05")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_06")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_07")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_08")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_09")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_10")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_11")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_12")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_13")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_14")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_15")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_17")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_18")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_20")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_21")%>                                                                    
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_23")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_24")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_edit_30")%>
<%=cm.br()%>