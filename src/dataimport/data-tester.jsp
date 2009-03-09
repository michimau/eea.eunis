<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : News page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,ro.finsiel.eunis.utilities.SQLUtilities,java.util.*"%>
<%@ page import="ro.finsiel.eunis.jrfTables.users.UserPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
<%
  String domainName = application.getInitParameter( "DOMAIN_NAME" );
%>
  <base href="<%=domainName%>/"/>
    <jsp:include page="../header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,data import#dataimport/index.jsp,data tester";
%>
    <title>
      Data Import Tester
    </title>
    
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
	</script>
  </head>
  <body onLoad="hideEmail()">
    <div id="visual-portal-wrapper">
      <jsp:include page="../header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="../header-dynamic.jsp">
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
<!-- MAIN CONTENT -->
                <h1>
                  Data Import Tester
                </h1>
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
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="../inc_column_left.jsp">
                <jsp:param name="page_name" value="news.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="../footer-static.jsp" />
    </div>
  </body>
</html>
