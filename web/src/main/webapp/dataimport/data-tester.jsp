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
<%@ page import="ro.finsiel.eunis.jrfTables.users.UserPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String domainName = application.getInitParameter( "DOMAIN_NAME" );
%>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,data import#dataimport/index.jsp,data tester";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("Data Import Tester") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    <script type="text/javascript">
    	function displayEmail(){	
	    	var back = document.getElementById("back");	 
	    	var emailRow = document.getElementById("emailRow");	
	    	var emailDescRow = document.getElementById("emailDescRow");	
	    	
	    	if (back.checked){
	    		emailRow.style.display = '';	
	    		emailDescRow.style.display = '';
    		} else {
	    		emailRow.style.display = 'none';	
	    		emailDescRow.style.display = 'none';
	    	}
		}
		
		function hideEmail(){	
	    	document.getElementById("emailRow").style.display = 'none';	
	    	document.getElementById("emailDescRow").style.display = 'none';	
		}

		window.onload = function(){
		    hideEmail();
		}
	</script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>
                <h1>
                  Data Import Tester
                </h1>
<!-- MAIN CONTENT -->
                <%
                if( SessionManager.isAuthenticated() && SessionManager.isImportExportData_RIGHT() ){
	                UserPersist usr = SessionManager.getUserPrefs();
	                String eMail = usr.getEMail();
	                if(eMail == null){
	                	eMail = "";
                	}
                %>
	                <p class="documentDescription">
	                The purpose of this page is to test the XML formatted Oracle dumps from the EUNIS maintainer.
	                It will not overwrite data.
	                </p>
	                <form name="eunis" method="post" action="<%=domainName%>/datatester" enctype="multipart/form-data">
	                	<table border="0">
		                	<tr>
		                		<td><label for="table">Table</label></td>
		                		<td>
					                <select id="table" name="table" title="Table names">
					                	<option value=""></option>
					                <%
					                	String SQL_DRV = application.getInitParameter("JDBC_DRV");
					                    String SQL_URL = application.getInitParameter("JDBC_URL");
					                    String SQL_USR = application.getInitParameter("JDBC_USR");
					                    String SQL_PWD = application.getInitParameter("JDBC_PWD");
					
					                    SQLUtilities sqlc = new SQLUtilities();
					                    sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
					                    
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
			                	<td><label for="back">Run in background</label></td>
			                	<td><input type="checkbox" id="back" name="back" onClick="displayEmail()"/></td>
			                </tr>
			                <tr id="emailRow">
			                	<td><label for="mail">E-mail</label></td>
			                	<td><input type="text" id="mail" name="mail" value="<%=eMail%>"/></td>
			                </tr>
			                <tr id="emailDescRow">
			                	<td></td>
			                	<td>Specifies the e-mail where any occuring errors will be sent.</td>
			                </tr>
			                <tr>
			                	<td align="right" colspan="2"><input type="submit" name="btn" value="Test"/></td>
			                </tr>
		                </table>
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