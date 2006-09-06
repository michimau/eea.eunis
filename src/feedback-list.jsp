<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.session.SessionManager"%>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="java.util.List"%>
<%@ page import="ro.finsiel.eunis.utilities.TableColumns"%>
<%@ page import="java.util.Vector"%><%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Feedback list
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
    WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("feedback_list")%>
    </title>

  </head>
<body>
<div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
                <br clear="all" />
<!-- MAIN CONTENT -->
                <jsp:include page="header-dynamic.jsp">
                    <jsp:param name="location" value="home#index.jsp,services#services.jsp,feedback_list"/>
                </jsp:include>

                   <h1><%=cm.cmsText("feedback_list")%></h1>
                   <br />
                <%
                  String SQL_DRV = application.getInitParameter("JDBC_DRV");
                  String SQL_URL = application.getInitParameter("JDBC_URL");
                  String SQL_USR = application.getInitParameter("JDBC_USR");
                  String SQL_PWD = application.getInitParameter("JDBC_PWD");

                  SQLUtilities sqlUtil = new SQLUtilities();
                  sqlUtil.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

                  String sql = "select FEEDBACK_TYPE, MODULE, COMMENT, NAME, EMAIL, COMPANY, ADDRESS, PHONE, FAX, URL " +
                          " from EUNIS_FEEDBACK " +
                          " order by FEEDBACK_TYPE, MODULE limit 0,10 ";
                  List feedbacks = sqlUtil.ExecuteSQLReturnList(sql, 10);

                  if (feedbacks != null && feedbacks.size() > 0)
                  {
                %>
                    <table summary="layout" width="100%" cellspacing="1" cellpadding="1" border="1" style="border-collapse:collapse">
                     <tr>
                       <th>
                         <%=cm.cmsText("feedback_type")%>
                       </th>
                         <th>
                           <%=cm.cmsText("feedback_list_03")%>
                         </th>
                         <th>
                           <%=cm.cmsText("comment")%>
                         </th>
                         <th>
                           <%=cm.cmsText("description")%>
                         </th>
                     </tr>

                <%
                   int j = 0;
                   for (int i=0;i<feedbacks.size();i++)
                   {
                      TableColumns columns = (TableColumns) feedbacks.get(i);
                      List feedback = columns.getColumnsValues();
                      String bgColor = (j++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF");
                %>
                     <tr style="background-color:<%=bgColor%>">
                      <td>
                         <%=Utilities.formatString(feedback.get(0),"&nbsp;")%>
                       </td>
                         <td>
                           <%=Utilities.formatString(feedback.get(1),"&nbsp;")%>
                         </td>
                         <td>
                           <%=Utilities.formatString(feedback.get(2),"&nbsp;")%>
                         </td>
                         <td>
                          <strong><%=cm.cmsText("name")%> : </strong> <%=Utilities.formatString(feedback.get(3)," - ")%> <br />
                          <strong><%=cm.cmsText("feedback_list_07")%> : </strong> <%=Utilities.formatString(feedback.get(4)," - ")%> <br />
                          <strong><%=cm.cmsText("feedback_list_08")%> : </strong> <%=Utilities.formatString(feedback.get(5)," - ")%> <br />
                          <strong><%=cm.cmsText("feedback_list_09")%> : </strong> <%=Utilities.formatString(feedback.get(6)," - ")%> <br />
                          <strong><%=cm.cmsText("feedback_list_10")%> : </strong> <%=Utilities.formatString(feedback.get(7)," - ")%> <br />
                          <strong><%=cm.cmsText("feedback_list_11")%> : </strong> <%=Utilities.formatString(feedback.get(8)," - ")%> <br />
                          <strong><%=cm.cmsText("url")%> :  </strong> <%=Utilities.formatString(feedback.get(9)," - ")%>
                         </td>
                     </tr>
                <%
                   }
                %>
                    </table>
                <%
                    } else
                    {
                %>
                   <br />
                   <strong> <%=cm.cmsText("feedback_list_13")%> </strong>
                   <br />
                <%
                    }
                %>
                    <%=cm.br()%>
                    <%=cm.cmsMsg("feedback_list")%>
                    <%=cm.br()%>

                    <jsp:include page="footer.jsp">
                      <jsp:param name="page_name" value="feedback-list.jsp" />
                    </jsp:include>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp" />
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
