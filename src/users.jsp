<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Main user management page. This page also includes pages from 'users/*' directory
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,services#services.jsp,user_management";
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("users_title")%>
    </title>
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
    <script language="JavaScript" type="text/javascript" src="script/overlib.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/user-management.js"></script>
  </head>
  <body>
    <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                    <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </li>
                  </ul>
                </div>
                <h1>
				   <%=cm.cmsPhrase("EUNIS Database User Management")%>
				</h1>
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
                                  <a title="<%=cm.cms("show")%> <%=tabs[i]%>" href="users.jsp?tab=<%=i%>"><%=tabs[ i ]%></a>
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
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="users.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
