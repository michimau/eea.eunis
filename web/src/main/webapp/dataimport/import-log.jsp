<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : News page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,ro.finsiel.eunis.utilities.SQLUtilities,java.util.*,ro.finsiel.eunis.dataimport.ImportLogDTO"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String domainName = application.getInitParameter( "DOMAIN_NAME" );
%>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,data import#dataimport/index.jsp,background importer log";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("Background Importer Log") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>
                <h1>
                  Background Importer Log
                </h1>
<!-- MAIN CONTENT -->
                <%
                if( SessionManager.isAuthenticated() && SessionManager.isImportExportData_RIGHT() ){
                	String SQL_DRV = application.getInitParameter("JDBC_DRV");
                    String SQL_URL = application.getInitParameter("JDBC_URL");
                    String SQL_USR = application.getInitParameter("JDBC_USR");
                    String SQL_PWD = application.getInitParameter("JDBC_PWD");

                    SQLUtilities sqlc = new SQLUtilities();
                    sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
	                    
                	List<ImportLogDTO> messages = sqlc.getImportLogMessages();
                	if(messages != null && messages.size() > 0){%>
	                	<table class="datatable" width="90%">
	                		<%
	                		for(Iterator<ImportLogDTO> it = messages.iterator(); it.hasNext();){
		                		ImportLogDTO message = it.next();%>
		                		<tr>
		                			<td nowrap="nowrap"><%=message.getTimestamp()%></td>
		                			<td><%=message.getMessage()%></td>
		                		</tr>
		                		<%
			               	}
			            	%>
			            </table> 
		            <%
	                }
		        } else {
	            	%>
	            		<div class="error-msg">
		                <%=cm.cmsPhrase("You must be authenticated and have the proper right to access this page.")%>
		              </div>
	            	<%	
            	}
                %>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>