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
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,services#services.jsp,feedback_list";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Feedback list") %>'></c:set>

<%--todo: the table needs more horizontal space --%>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
           <h1><%=cm.cmsPhrase("Feedback list")%></h1>
<!-- MAIN CONTENT -->

                   <br />
                <%
				String p = request.getParameter("page");
                int limit = 10;
                if(p == null) p = "1";
      			int mypage=Integer.parseInt(p);
      			int myEnd = (limit * mypage);
        		int myBase = (myEnd - limit);
                
                String SQL_DRV = application.getInitParameter("JDBC_DRV");
                String SQL_URL = application.getInitParameter("JDBC_URL");
                String SQL_USR = application.getInitParameter("JDBC_USR");
                String SQL_PWD = application.getInitParameter("JDBC_PWD");

                SQLUtilities sqlUtil = new SQLUtilities();
                sqlUtil.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
                
                String countStr = sqlUtil.ExecuteSQL("SELECT COUNT(FEEDBACK_TYPE) FROM EUNIS_FEEDBACK");
                int count = Integer.parseInt(countStr);
                
                int last = myEnd;
    			if(count <= myEnd)
    				last = count;

                String sql = "select FEEDBACK_TYPE, MODULE, COMMENT, NAME, EMAIL, COMPANY, ADDRESS, PHONE, FAX, URL " +
                        " from EUNIS_FEEDBACK " +
                        " order by FEEDBACK_TYPE, MODULE limit "+myBase+","+limit;
                        
                List feedbacks = sqlUtil.ExecuteSQLReturnList(sql, 10);

                if (feedbacks != null && feedbacks.size() > 0)
                {
                %>
                    <table summary="layout" width="100%" cellspacing="1" cellpadding="1" border="1" style="border-collapse:collapse">
                     <tr>
                     	<td colspan="4" align="center" height="25">
                     		<b>Found <%=count%> records. Showing records <%=myBase%> - <%=last%></b>
                     	</td>
                     </tr>
                     <tr>
                       <th>
                         <%=cm.cmsPhrase("Feedback type")%>
                       </th>
                         <th>
                           <%=cm.cmsPhrase("Module")%>
                         </th>
                         <th>
                           <%=cm.cmsPhrase("Comment")%>
                         </th>
                         <th>
                           <%=cm.cmsPhrase("Description")%>
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
                          <strong><%=cm.cmsPhrase("Name")%> : </strong> <%=Utilities.formatString(feedback.get(3)," - ")%> <br />
                          <strong><%=cm.cmsPhrase("Email")%> : </strong> <%=Utilities.formatString(feedback.get(4)," - ")%> <br />
                          <strong><%=cm.cmsPhrase("Company")%> : </strong> <%=Utilities.formatString(feedback.get(5)," - ")%> <br />
                          <strong><%=cm.cmsPhrase("Address")%> : </strong> <%=Utilities.formatString(feedback.get(6)," - ")%> <br />
                          <strong><%=cm.cmsPhrase("Phone")%> : </strong> <%=Utilities.formatString(feedback.get(7)," - ")%> <br />
                          <strong><%=cm.cmsPhrase("Fax")%> : </strong> <%=Utilities.formatString(feedback.get(8)," - ")%> <br />
                          <strong><%=cm.cmsPhrase("Url")%> :  </strong> <%=Utilities.formatString(feedback.get(9)," - ")%>
                         </td>
                     </tr>
                <%
                   }
                %>
                    </table>
                <%
                		if(count > limit){
	                		%>
	                			<table summary="layout" width="100%" cellspacing="1" cellpadding="1" style="border-collapse:collapse">
	                				<tr>
	                					<%
	                					if(mypage > 1){
		                					%>
		                					<td align="left"><a href="feedback-list.jsp?page=<%=(mypage - 1)%>">previous page</a></td>
		                					<%	
	                					}
	                					%>
	                					<td align="center" height="25">
	                					<%
	                						int i=0;
	                						int cnt = count;
					                        while(cnt>0) {
					                            i++;
					                            if(i != mypage){ %>
					                            	<a href="feedback-list.jsp?page=<%=i%>"><%=i%></a>&nbsp;&nbsp;
					                            <% } else { %>
					                            	<%=i%>&nbsp;&nbsp;
					                            <% }
					                            cnt-=limit;
					                        }
	                					%>
	                					</td>
	                					<%
	                					if(count > myEnd){
		                					%>
		                					<td align="right"><a href="feedback-list.jsp?page=<%=(mypage + 1)%>">next page</a></td>
		                					<%	
	                					}
	                					%>
	                				</tr>
	                			</table>
	                		<%
                		}
                    } else
                    {
                %>
                   <br />
                   <strong> <%=cm.cmsPhrase("No feedbacks yet.")%> </strong>
                   <br />
                <%
                    }
                %>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>