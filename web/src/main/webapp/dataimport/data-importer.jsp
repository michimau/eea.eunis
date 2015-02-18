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
  String btrail = "eea#" + eeaHome + ",home#index.jsp,data import#dataimport/index.jsp,data importer";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("Data Import") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">

                <a name="documentContent"></a>
                <h1>
                  Data Import
                </h1>
<!-- MAIN CONTENT -->
                <%
                if( SessionManager.isAuthenticated() && SessionManager.isImportExportData_RIGHT() ){
                %>
	                <p class="documentDescription">
	                The purpose of this page is to import the XML formatted Oracle dumps into the EUNIS database.
	                </p>
	                <form name="eunis" method="post" action="<%=domainName%>/dataimporter" enctype="multipart/form-data">
	                	<table border="0">
		                	<tr>
		                		<td><label for="table">Table</label></td>
		                		<td>
					                <select id="table" name="table" title="Table names">
					                	<option value=""></option>
					                	<option value="natura2000">== Natura 2000 sites ==</option>
					                <%
					                    SQLUtilities sqlc = new SQLUtilities();
					                    
					                	List<String> tableNames = sqlc.getAllChm62edtTableNames();
					                	for(Iterator it = tableNames.iterator(); it.hasNext();){
						                	String tableName = (String) it.next();%>
						                	<option value="<%=tableName%>"><%=tableName%></option>
						                	<%
					                	}
					                %>
					                </select>
								</td>
							</tr>
							<tr>
			                	<td><label for="file">File</label></td>
			                	<td><input type="file" id="file" name="file"/></td>
			                </tr>
			                <tr>
			                	<td><label for="empty">Empty the table first</label></td>
			                	<td><input type="checkbox" id="empty" name="empty" checked="checked"/></td>
			                </tr>
			                <tr>
			                	<td><label for="back">Run in background</label></td>
			                	<td><input type="checkbox" id="back" name="back"/></td>
			                </tr>
			                <tr>
			                	<td align="right" colspan="2"><input type="submit" name="btn" value="Import"/></td>
			                </tr>
		                </table>
		            </form>
		            <%
		            List<String> errors = (List<String>)request.getSession().getAttribute("errors");
		            if(errors != null && errors.size() > 0){
			            if(errors.size() > 1){%>		            
		            		<h2><%=(errors.size() - 1)%> errors found:</h2>
		            	<%} else { %>
			            	<h2><%=errors.size()%> errors found:</h2>
			            <% } %>
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
		            } else {
			         	String success = (String)request.getSession().getAttribute("success");
			         	if(success != null){
			         		%>
			         			<b><%=success%></b>
			         		<%
				        	request.getSession().removeAttribute("success");
		         		}
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