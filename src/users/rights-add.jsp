<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Part of user management
--%>
<%@ page import="java.util.List,
                 ro.finsiel.eunis.WebContentManagement,
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
 //If user is authentificated and has this right
  if(SessionManager.isAuthenticated() && SessionManager.isRole_management_RIGHT())
{
  // Request parameters
  String users_operation = (request.getParameter("users_operation") == null ? "edit_rights" : request.getParameter("users_operation"));

  String tab1 = (request.getParameter("tab1") == null ? "users" : request.getParameter("tab1"));
  String tab2 = (request.getParameter("tab2")==null ? (request.getParameter("tab1") == null ? "view_users" : (request.getParameter("tab1").equalsIgnoreCase("users") ? "view_users" : "view_roles")) : request.getParameter("tab2"));

  try
  {
   // All rights list
   List ListRights = new RightsDomain().findAll();
   if(ListRights != null && ListRights.size() > 0)
   {
%>
    <script type="text/javascript" language="JavaScript">
       <!--
       var rights_list = new Array(<%=ListRights.size()%>);
      //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
<%
     for (int i=0;i<ListRights.size();i++)
      {
%>
          <script type="text/javascript" language="JavaScript">
             <!--
               rights_list[<%=i%>]='<%=((RightsPersist)ListRights.get(i)).getRightName()%>';
             //-->
         </script>
         <noscript>Your browser does not support JavaScript!</noscript>
<%
      }
  } else
   {
%>
          <script type="text/javascript" language="JavaScript">
             <!--
               var rights_list = new Array(0);
             //-->
          </script>
          <noscript>Your browser does not support JavaScript!</noscript>
<%
    }
  }catch(Exception e){e.printStackTrace();}
%>

<script type="text/javascript" language="JavaScript">
      <!--

      function RightExist(){
      rightName = escape(trim(document.eunis.rightName.value));
      rightName = rightName.replace(' ','_');
      exist=false;
      for(i=0;i<rights_list.length;i++) if (rightName.toLowerCase() == rights_list[i].toLowerCase()) exist = true;
      if(exist) {
                   alert("This right name already exist!");
                   document.eunis.rightName.value = "";
                }
      return exist;
      }

        function validateFormAdd() {
       if (document.eunis.rightName == null || trim(document.eunis.rightName.value)=='')
            {
             alert("You must insert a valid right name value!");
             return false;
            }

        if(RightExist()) return false;

       return true;
        }

           function validateFormEdit() {
            if (document.eunis.rightName == null
            || trim(document.eunis.rightName.value) == ''
            || trim(document.eunis.rightName.value) == 'selectRightName')
            {
             alert("You must select a valid right name value!");
             return false;
            }

           return true;
           }

         function deleteRight(){
         if (document.eunis.rightName != null
         && trim(document.eunis.rightName.value) != ''
         && trim(document.eunis.rightName.value) != 'selectRightName')
         {
         rightName = escape(trim(document.eunis.rightName.value));
         document.location="users.jsp?operation=delete&rightName="+rightName+"&tab1=<%=tab1%>&tab2=<%=tab2%>";
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

// Request parameters
String rightName = (request.getParameter("rightName") == null ? "" : request.getParameter("rightName"));
String message = "";
String operation = request.getParameter("operation");

String onSubmit = "";
// User choose 'add_rights'
if(users_operation.equalsIgnoreCase("add_rights"))
{
  // Set onSubmit string
  onSubmit = "return validateFormAdd();";
  if (operation != null)
  {
      // if user choose to add a new right
      if(operation.equalsIgnoreCase("submit"))
      {
        // if rightName is a valid right name
        if(request.getParameter("rightName") != null && !request.getParameter("rightName").equalsIgnoreCase(""))
        {
          String description = (request.getParameter("description") == null ? "" : request.getParameter("description"));
          // Replace all " " with "_"
          String goodRightName = request.getParameter("rightName").trim().replaceAll(" ","_");
          // add right
           boolean addRightSuccess = UsersUtility.addRights(SessionManager.getUsername(),goodRightName,description);

          if(addRightSuccess) message = "Rights adding operation was made successfully.";
          else message = "<span color=\"red\">Rights adding operation wasn't made successfully.</span>";

        } else message = "<span color=\"red\">Rights adding operation wasn't made successfully.</span>";
      }
  }
}

  // User choose 'edit_rights'
  if(users_operation.equalsIgnoreCase("edit_rights"))
  {
    // Set onSubmit string
    onSubmit = "return validateFormEdit();";
    if (operation!=null)
    {
        // if user choose to update a right
        if(operation.equalsIgnoreCase("submit"))
        {
          // if rightName is a valid right name
          if(request.getParameter("rightName") != null
             && !request.getParameter("rightName").trim().equalsIgnoreCase("")
             && !request.getParameter("rightName").equalsIgnoreCase("selectRightName"))
             {
               String description = (request.getParameter("description") == null ? "" : request.getParameter("description"));
               // Edit right
               boolean editWithSuccess = UsersUtility.editRights(SessionManager.getUsername(),rightName,description,SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
               if(editWithSuccess) message = "Rights updating operation was made successfully.";
               else message = "<span color=\"red\">Rights updating operation wasn't made successfully.</span>";

             } else message = "<span color=\"red\">Rights updating operation wasn't made successfully.</span>";
        }

      // if user choose to delete a right
      if(operation.equalsIgnoreCase("delete"))
       {
       // if rightName is a valid right name
       if(request.getParameter("rightName") != null
          && !request.getParameter("rightName").trim().equalsIgnoreCase("")
          && !request.getParameter("rightName").equalsIgnoreCase("selectRightName")
          && UsersUtility.existRightName(request.getParameter("rightName")) )
       {
           // Delete right
           boolean deleteWithSucces = UsersUtility.deleteRights(rightName,SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
           if(deleteWithSucces) message = "Rights deleting operation was made successfully.";
           else message = "<span color=\"red\">Rights deleting operation wasn't made successfully.</span>";
       }  else message = "<span color=\"red\">Rights deleting operation wasn't made successfully.</span>";
      }
    }
  }


String description = "";
// if user choose 'edit_rights', fill the description field
if(users_operation.equalsIgnoreCase("edit_rights"))
{
  description = (UsersUtility.getRightsObject(rightName) == null ? "" : (UsersUtility.getRightsObject(rightName)).getDescription());
}
%>
     <h5>
       EUNIS Database User Management
     </h5>
     <br />
     <h6>
        <%=(users_operation.equalsIgnoreCase("add_rights")?"Add":"Edit")%> rights
     </h6>
     <br />

<form name="eunis" method="post" action="users.jsp" onsubmit="<%=onSubmit%>">
<input type="hidden" name="tab1" value="<%=tab1%>" />
<input type="hidden" name="tab2" value="<%=tab2%>" />
<input type="hidden" name="operation" value="" />
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse" class="tableBorder">
<tr><td>&nbsp;</td></tr>
<tr>
  <td>
    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
    <%
    if(users_operation.equalsIgnoreCase("edit_rights"))
    {
    %>
    <tr>
      <td>
      &nbsp;&nbsp;<label for="rightName1">Select right name</label>
<%--        &nbsp;&nbsp;Select right name--%>
      </td>
      <td>
       <select id="rightName1" name="rightName" class="inputTextField" style="border-width:1px" onchange="MM_jumpMenuRights('parent',this,0,'<%=tab1%>','<%=tab2%>')"  title="List of right name">
        <option value="selectRightName" selected="selected">Select a right name</option>
        <%
           try
           {
           // Rights list
           List rights = new RightsDomain().findOrderBy("A.RIGHTNAME");
            if(rights != null && rights.size() > 0)
            {
              for(int i=0;i<rights.size();i++)
              {
       %>
       <option value="<%=((RightsPersist)rights.get(i)).getRightName()%>" <%=(rightName.equalsIgnoreCase(((RightsPersist)rights.get(i)).getRightName())?"selected=\"selected\"":"")%>><%=UsersUtility.getNameNice(((RightsPersist)rights.get(i)).getRightName())%></option>
       <%
              }
            }
           } catch(Exception e){e.printStackTrace();}
        %>
       </select>
       &nbsp;&nbsp;&nbsp;
       <a title="Delete this right" href="javascript:deleteRight();">delete this right</a>
      </td>
    </tr>
   <%
    } else
    {
   %>
     <tr>
       <td>
       &nbsp;&nbsp;<label for="rightName2">Right name</label>
<%--         &nbsp;&nbsp;Right name--%>
       </td>
       <td>
         <label for="rightName2" class="noshow">Right name</label>
         <input class="inputTextField" title="Right name" alt="Right name" type="text" id="rightName2" name="rightName" size="50" value="" onchange="RightExist();" />
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
      <tr>
        <td>
        &nbsp;&nbsp;<label for="description">Description</label>
<%--          &nbsp;&nbsp;Description :--%>
        </td>
        <td>
          <textarea title="Description" id="description" name="description" cols="70" rows="5"  class="inputTextField"><%=description%></textarea>
        </td>
      </tr>
    </table>
    <p>&nbsp;</p>
  </td>
</tr>
<tr>
  <td style="text-align:left">
    &nbsp;&nbsp;
    <label for="input1" class="noshow">Submit</label>
    <input id="input1" type="submit" value="<%=(users_operation.equalsIgnoreCase("add_rights")?"Add right":"Update data")%>" name="submit" onclick="document.eunis.operation.value='submit';" class="inputTextField"  title="<%=(users_operation.equalsIgnoreCase("add_rights")?"Add right":"Update data")%>" />&nbsp;&nbsp;
    <label for="input2" class="noshow">Reset</label>
    <input id="input2" type="reset" value="Reset" name="Reset" class="inputTextField"  title="Reset" />
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