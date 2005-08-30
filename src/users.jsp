<%@ page import="ro.finsiel.eunis.search.Utilities"%><%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Main user management page. This page also includes pages from 'users/*' directory
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      User management console
    </title>
    <jsp:include page="header-page.jsp" />
    <style type="text/css">


table.valign {vertical-align: text-top}
.tableBorder
{
border: 1px solid #000000;background-color: #EEEEEE;
}

    /* Tabbed menus  */
#tabbedmenu2 {
  float: left;
  width: 740px;

  font-size: x-small;
  line-height: normal;
}

#tabbedmenu2 ul {
  margin: 0;
  padding: 2px 2px 0;
  list-style: none;
  list-style-image: none;
}

#tabbedmenu2 li {
  float: left;
  background: url( "images/mini/tableft.gif" ) no-repeat left top;
  margin: 0;
  padding: 0 0 0 9px;
  white-space: nowrap;
}

#tabbedmenu2 a {
  display: block;
  text-decoration: none;
  font-weight: normal;
  color: black;
  background: url( "images/mini/tabright.gif" ) no-repeat right top;
  padding: 5px 15px 2px 3px;
}

#tabbedmenu2 #currenttab2 {
  background-image: url( "images/mini/tableft_on.gif" );
}

#tabbedmenu2 #currenttab2 a {
  text-decoration: none;
  font-weight: bold;
  background-image: url( "images/mini/tabright_on.gif" );
  padding-bottom: 2px;
}

#tabbedmenu2 #currenttab2 span {
  display: block;
  text-decoration: none;
  font-weight: normal;
  background: url( "images/mini/tabright_on.gif" ) no-repeat right top;
  padding: 5px 15px 2px 3px;
}
    </style>
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/overlib.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/user-management.js"></script>
  </head>
<%--<body leftmargin="20" bgcolor="#ffffff">--%>
<body>
<div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
<div id="content">
<jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="Home#index.jsp,Services#services.jsp,User Management"/>
</jsp:include>
<%
int tab1 = Utilities.checkedStringToInt( request.getParameter( "tab1" ), 0 );
String []tabs1 = { "User management","Role management"};

int tab2 = Utilities.checkedStringToInt( request.getParameter( "tab2" ), 0 );
String []tabs2 = { "List of users","Edit user","Add user"};
String []tabs3 = { "List of roles","Edit role","Add role","Edit right","Add right"};
%>
<div id="tabbedmenu2">
      <ul>
        <%
          String currentTab = "";

          for(int i = 0; i < tabs1.length; i++) {
            currentTab = "";
            if(tab1 == i) currentTab = " id=\"currenttab2\"";

              %>
              <li<%=currentTab%>>
                <a title="Show <%=tabs1[i]%>" href="users.jsp?tab1=<%=i%>"><%=tabs1[ i ]%></a>
              </li>
              <%
          }
        %>
      </ul>
      </div>
      <br />
<%
String[] tabs = {""};
if(tab1 == 0) tabs = tabs2;
else tabs = tabs3;
%>
        <div id="tabbedmenu">
        <ul>
        <%
            currentTab = "";

            for(int i = 0; i < tabs.length; i++) {
              currentTab = "";
              if(tab2 == i) currentTab = " id=\"currenttab\"";

              %>
                <li<%=currentTab%>>
                  <a title="Show <%=tabs[i]%>" href="users.jsp?tab1=<%=tab1%>&amp;tab2=<%=i%>"><%=tabs[ i ]%></a>
                </li>
              <%
            }
        %>
        </ul>
        </div>
      <br /><br />
         <%
            // if was selected 'edit_users' cell from the seccond line do this
           // if(tab2.equalsIgnoreCase("edit_users"))
            if ( tab1 == 0  && tab2 == 1)
            {
              String userName = (request.getParameter("userName")==null?"":request.getParameter("userName"));
              String operation = (request.getParameter("operation")==null?"":request.getParameter("operation"));
             %>
             <jsp:include page="users/users-edit.jsp">
                 <jsp:param name="users_operation" value="edit_users"/>
                 <jsp:param name="userName" value="<%=userName%>"/>
                 <jsp:param name="operation" value="<%=operation%>"/>
                 <jsp:param name="tab1" value="<%=tab1%>"/>
                 <jsp:param name="tab2" value="<%=tab2%>"/>
             </jsp:include>
            <%
            }

     // if was selected 'add_users' cell from the seccond line do this
     //if(tab2.equalsIgnoreCase("add_users"))
     if ( tab1 == 0  && tab2 == 2)
     {
        String userName = (request.getParameter("userName")==null?"":request.getParameter("userName"));
        String operation = (request.getParameter("operation")==null?"":request.getParameter("operation"));
    %>
     <jsp:include page="users/users-edit.jsp">
         <jsp:param name="users_operation" value="add_users"/>
         <jsp:param name="userName" value="<%=userName%>"/>
         <jsp:param name="operation" value="<%=operation%>"/>
         <jsp:param name="tab1" value="<%=tab1%>"/>
         <jsp:param name="tab2" value="<%=tab2%>"/>
     </jsp:include>
   <%
     }

     // if was selected 'view_users' cell from the seccond line do this
     //if(tab2.equalsIgnoreCase("view_users"))
     if ( tab1 == 0  && tab2 == 0)
     {
   %>
     <jsp:include page="users/users-list.jsp">
         <jsp:param name="tab1" value="<%=tab1%>"/>
         <jsp:param name="tab2" value="<%=tab2%>"/>
     </jsp:include>
   <%
     }

     // if was selected 'add_roles' cell from the seccond line do this
     //if(tab2.equalsIgnoreCase("add_roles"))
     if ( tab1 == 1  && tab2 == 2)
     {
        String roleName = (request.getParameter("roleName")==null?"":request.getParameter("roleName"));
        String operation = (request.getParameter("operation")==null?"":request.getParameter("operation"));
    %>
     <jsp:include page="users/roles-add.jsp">
         <jsp:param name="users_operation" value="add"/>
         <jsp:param name="roleName" value="<%=roleName%>"/>
         <jsp:param name="operation" value="<%=operation%>"/>
         <jsp:param name="tab1" value="<%=tab1%>"/>
         <jsp:param name="tab2" value="<%=tab2%>"/>
     </jsp:include>
     <%
     }

      // if was selected 'edit_roles' cell from the seccond line do this
      //if(tab2.equalsIgnoreCase("edit_roles"))
      if ( tab1 == 1  && tab2 == 1)
      {
        String roleName = (request.getParameter("roleName")==null?"":request.getParameter("roleName"));
        String operation = (request.getParameter("operation")==null?"":request.getParameter("operation"));
      %>
     <jsp:include page="users/roles-add.jsp">
         <jsp:param name="users_operation" value="edit"/>
         <jsp:param name="roleName" value="<%=roleName%>"/>
         <jsp:param name="operation" value="<%=operation%>"/>
         <jsp:param name="tab1" value="<%=tab1%>"/>
         <jsp:param name="tab2" value="<%=tab2%>"/>
     </jsp:include>
     <%
      }

      // if was selected 'view_roles' cell from the seccond line do this
      //if(tab2.equalsIgnoreCase("view_roles"))
       if ( tab1 == 1  && tab2 == 0)
      {
        String userName = (request.getParameter("userName")==null?"":request.getParameter("userName"));
        String operation = (request.getParameter("operation")==null?"":request.getParameter("operation"));
     %>
     <jsp:include page="users/roles-view.jsp">
         <jsp:param name="userName" value="<%=userName%>"/>
         <jsp:param name="operation" value="<%=operation%>"/>
         <jsp:param name="tab1" value="<%=tab1%>"/>
         <jsp:param name="tab2" value="<%=tab2%>"/>
     </jsp:include>
     <%
      }

      // if was selected 'add_rights' cell from the seccond line do this
      //if(tab2.equalsIgnoreCase("add_rights"))
       if ( tab1 == 1  && tab2 == 4)
      {
        String rightName = (request.getParameter("rightName")==null?"":request.getParameter("rightName"));
        String operation = (request.getParameter("operation")==null?"":request.getParameter("operation"));
      %>
     <jsp:include page="users/rights-add.jsp">
         <jsp:param name="users_operation" value="add_rights"/>
         <jsp:param name="rightName" value="<%=rightName%>"/>
         <jsp:param name="operation" value="<%=operation%>"/>
         <jsp:param name="tab1" value="<%=tab1%>"/>
         <jsp:param name="tab2" value="<%=tab2%>"/>
     </jsp:include>
     <%
      }

      // if was selected 'edit_rights' cell from the seccond line do this
      //if(tab2.equalsIgnoreCase("edit_rights"))
       if ( tab1 == 1  && tab2 == 3)
      {
        String rightName = (request.getParameter("rightName")==null?"":request.getParameter("rightName"));
        String operation = (request.getParameter("operation")==null?"":request.getParameter("operation"));
      %>
     <jsp:include page="users/rights-add.jsp">
         <jsp:param name="users_operation" value="edit_rights"/>
         <jsp:param name="rightName" value="<%=rightName%>"/>
         <jsp:param name="operation" value="<%=operation%>"/>
         <jsp:param name="tab1" value="<%=tab1%>"/>
         <jsp:param name="tab2" value="<%=tab2%>"/>
     </jsp:include>
     <%
      }
     %>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="users.jsp" />
    </jsp:include>
</div>
  </body>
</html>