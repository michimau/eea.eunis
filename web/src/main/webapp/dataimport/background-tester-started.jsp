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
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,data import#dataimport/index.jsp,data tester";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("Background Data Tester Started") %>'></c:set>
<%
    String domainName = application.getInitParameter( "DOMAIN_NAME" );
%>
<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">

                <a name="documentContent"></a>
                <h1>
                  Background Data Tester Started
                </h1>
<!-- MAIN CONTENT -->
                <%
                if( SessionManager.isAuthenticated() && SessionManager.isImportExportData_RIGHT() ){
                %>
	                <div class="system-msg">
	                Background data tester started. Any errors found will be sent to the following e-mail: <%=(String)request.getSession().getAttribute("email")%>
	                <% request.getSession().removeAttribute("email"); %>
	                </div>
	                
		        <%} else {
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