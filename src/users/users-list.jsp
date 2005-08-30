<%@ page import="java.util.List,
                 ro.finsiel.eunis.jrfTables.users.UserDomain,
                 ro.finsiel.eunis.jrfTables.users.UserPersist,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.search.users.UsersUtility,
                 ro.finsiel.eunis.jrfTables.users.RolesPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>

<%
  // If user is authentificated  and he has this right
  if(SessionManager.isAuthenticated() && SessionManager.isUser_management_RIGHT())
{
%>
    <h5>
      EUNIS Database User Management
    </h5>
    <br />
    <h6>View users</h6>
    <br />
<%
try {
// Users names list
List usersList = new UserDomain().findCustom("SELECT USERNAME,PASSWORD,FIRST_NAME,LAST_NAME,EMAIL," +
              " FONTSIZE,THEME_INDEX,DATE_FORMAT(login_date,'%d %b %Y %H:%i:%s')" +
              " FROM EUNIS_USERS ORDER BY USERNAME");
if(usersList != null && usersList.size() > 0)
  {
%>
<table summary="List of users" width="100%" border="1" cellspacing="0" cellpadding="0">
<tr  class="dusers" style="text-align:left;font-weight :bold;">
  <td>
    User name
  </td>
  <td>
    First name
  </td>
  <td>
    Last name
  </td>
  <td style="text-align:center">
    Last login date
  </td>
  <td>
    Roles
  </td>
</tr>
<%
  //String bgColor = "";
  String classValue = "";
  for(int i=0;i<usersList.size();i++)
  {
    UserPersist objUser = (UserPersist) usersList.get(i);
    //bgColor = (0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF";
    classValue = (0 == (i % 2)) ? "eusers" : "fusers";
    String objUserName = (objUser.getUsername()==null?"":objUser.getUsername());
%>
<tr>
  <td style="text-align:left" class="<%=classValue%>">
  <%
    if (!Utilities.formatString(objUser.getUsername(),"&nbsp;").equalsIgnoreCase("&nbsp;"))
    {
  %>
     <a href="users.jsp?userName=<%=objUser.getUsername()%>&amp;tab1=0&amp;tab2=1" title="Edit user"><%=Utilities.formatString(objUser.getUsername(),"&nbsp;")%></a>
  <%
    } else
    {
      out.print(Utilities.formatString(objUser.getUsername(),"&nbsp;"));
    }
  %>
  </td>
  <td class="<%=classValue%>">
    <%=Utilities.formatString(objUser.getFirstName(),"&nbsp;")%>
  </td>
  <td class="<%=classValue%>">
    <%=Utilities.formatString(objUser.getLastName(),"&nbsp;")%>
  </td>
  <td style="text-align:center" class="<%=classValue%>">
    <%=(objUser.getLoginDate() == null ? "" : (objUser.getLoginDate().trim().equalsIgnoreCase("null") ? "" : objUser.getLoginDate()))%>&nbsp;
  </td>
  <td class="<%=classValue%>" style="vertical-align:top">
  <%
    // Roles names for a user name
    Vector userRoles = UsersUtility.getUsersRoles(objUserName);
    if(userRoles != null && userRoles.size() > 0)
       {
       for(int j=0;j<userRoles.size();j++)
        {
    %>
           <div  onmouseover="return showtooltip('<%=UsersUtility.getRolesRightsAsString((String)userRoles.get(j))%>')" onmouseout="hidetooltip()">
              <%=Utilities.formatString((String)userRoles.get(j),"&nbsp;")%>
           </div>
    <%
       }
    } else
    {
%>&nbsp;
<%
    }
%>
  </td>
</tr>
<%
  }
%>
</table>
<%
  }
}catch(Exception e){e.printStackTrace();}
%>
<%
  } else
  {
%>
<strong>You can't do this because you are not authentificated or you don't haven enough rights!</strong>
<br />
<%
  }
%>