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
<%@ page import="ro.finsiel.eunis.WebContentManagement,ro.finsiel.eunis.utilities.SQLUtilities,java.util.*"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String domainName = application.getInitParameter( "DOMAIN_NAME" );
%>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,data import#dataimport/index.jsp,data exporter";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("Data Export") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">

                <a name="documentContent"></a>
                <h1>
                  Data Export
                </h1>
<!-- MAIN CONTENT -->
                <%
                if( SessionManager.isAuthenticated() && SessionManager.isImportExportData_RIGHT() ){
                %>
	                <p class="documentDescription">
	                The purpose of this page is to export EUNIS database table into XML formatted Oracle dump.
	                </p>
	                <form name="eunis" method="get" action="<%=domainName%>/dataexporter">
	                	<label for="table">Table</label>
		                <select id="table" name="table" title="Table names">
		                	<option value=""></option>
		                <%
		                    SQLUtilities sqlc = new SQLUtilities();

		                	List<String> tableNames = sqlc.getAllChm62edtTableNames();
		                	for(Iterator it = tableNames.iterator(); it.hasNext();){
			                	String tableName = (String) it.next();%>
			                	<option value="<%=tableName%>"><%=tableName%></option>
			                	<%
		                	}
		                %>
		                </select><br/>
		                <input type="checkbox" id="schema" name="schema"/><label for="schema"> - do not add schema identifier</label><br/>
		                <input type="submit" name="btn" value="Export"/>
		                
		            </form>
		            <%
		            List<String> errors = (List<String>)request.getSession().getAttribute("errors");
		            if(errors != null && errors.size() > 0){%>
		            	<h2><%=errors.size()%> errors found:</h2>
		            	<ul>
		            	<%
			         	for(int i = 0 ; i<errors.size() ; i++) {
				         	String error = errors.get(i);
			         		%>
			         		<li><%=error%></li>
			         		<%
				        }
				        %>
				        </ul>
				        <%
				        request.getSession().removeAttribute("errors");
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