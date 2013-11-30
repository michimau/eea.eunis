<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Main user management page. This page also includes pages from 'users/*' directory
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,services#services.jsp,user_management";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("users_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    <style type="text/css">
      /* Tabbed menus  */
      #tabbedmenu2
      {
        float: left;
        width: 100%;

        font-size: x-small;
        line-height: normal;
      }

      #tabbedmenu2 ul
      {
        margin: 0;
        padding: 2px 2px 0;
        list-style: none;
        list-style-image: none;
      }

      #tabbedmenu2 li
      {
        float: left;
        background: url( "images/mini/tableft.gif" ) no-repeat left top;
        margin: 0;
        padding: 0 0 0 9px;
        white-space: nowrap;
      }

      #tabbedmenu2 a
      {
        display: block;
        text-decoration: none;
        font-weight: normal;
        color: black;
        background: url( "images/mini/tabright.gif" ) no-repeat right top;
        padding: 5px 15px 2px 3px;
      }

      #tabbedmenu2 #currenttab2
      {
        background-image: url( "images/mini/tableft_on.gif" );
      }

      #tabbedmenu2 #currenttab2 a
      {
        text-decoration: none;
        font-weight: bold;
        background-image: url( "images/mini/tabright_on.gif" );
        padding-bottom: 2px;
      }

      #tabbedmenu2 #currenttab2 span
      {
        display: block;
        text-decoration: none;
        font-weight: normal;
        background: url( "images/mini/tabright_on.gif" ) no-repeat right top;
        padding: 5px 15px 2px 3px;
      }
    </style>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/overlib.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/user-management.js"></script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
        <a name="documentContent"></a>
        <h1><%=cm.cmsPhrase("EUNIS Database User Management")%></h1>

				<br />
<!-- MAIN CONTENT -->
                <%
                int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
                String []tabs = { cm.cms("list_users"),cm.cms("edit_user"),cm.cms("add_user")};
                %>
                        <div id="tabbedmenu">
                        <ul>
                        <%
                            String currentTab = "";

                            for(int i = 0; i < tabs.length; i++) {
                              currentTab = "";
                              if(tab == i) currentTab = " id=\"currenttab\"";

                              %>
                                <li<%=currentTab%>>
                                  <a href="users.jsp?tab=<%=i%>"><%=tabs[ i ]%></a>
                                </li>
                              <%
                            }
                        %>
                        </ul>
                        </div>
                      <br /><br />
                         <%
                            // if was selected 'edit_users' cell from the seccond line do this
                           // if(tab.equalsIgnoreCase("edit_users"))
                            if ( tab == 1)
                            {
                              String userName = (request.getParameter("userName")==null?"":request.getParameter("userName"));
                              String operation = (request.getParameter("operation")==null?"":request.getParameter("operation"));
                             %>
                             <jsp:include page="users/users-edit.jsp">
                                 <jsp:param name="users_operation" value="edit_users"/>
                                 <jsp:param name="userName" value="<%=userName%>"/>
                                 <jsp:param name="operation" value="<%=operation%>"/>
                                 <jsp:param name="tab" value="<%=tab%>"/>
                             </jsp:include>
                            <%
                            }

                     // if was selected 'add_users' cell from the seccond line do this
                     //if(tab.equalsIgnoreCase("add_users"))
                     if ( tab == 2)
                     {
                        String userName = (request.getParameter("userName")==null?"":request.getParameter("userName"));
                        String operation = (request.getParameter("operation")==null?"":request.getParameter("operation"));
                    %>
                     <jsp:include page="users/users-edit.jsp">
                         <jsp:param name="users_operation" value="add_users"/>
                         <jsp:param name="userName" value="<%=userName%>"/>
                         <jsp:param name="operation" value="<%=operation%>"/>
                         <jsp:param name="tab" value="<%=tab%>"/>
                     </jsp:include>
                   <%
                     }

                     // if was selected 'view_users' cell from the seccond line do this
                     //if(tab.equalsIgnoreCase("view_users"))
                     if ( tab == 0)
                     {
                   %>
                     <jsp:include page="users/users-list.jsp">
                         <jsp:param name="tab" value="<%=tab%>"/>
                     </jsp:include>
                   <%
                     }
                   %>

                <%=cm.br()%>
                <%=cm.cmsMsg("users_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("user_management")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("role_management")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("list_users")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("edit_user")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("add_user")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("list_roles")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("edit_role")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("add_role")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("edit_right")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("add_right")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("show")%>
                <%=cm.br()%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>