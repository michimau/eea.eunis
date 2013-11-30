<%--
  - Author(s)   : EUNIS Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Help page for the 'Advanced search' function.
  - Request params : -
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />

<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,help_on_advanced_search_link";
%>

<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Advanced search help") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>
		<h1><%=cm.cmsPhrase("How to use the EUNIS Advanced Search facility")%></h1>

<!-- MAIN CONTENT -->
                <%=cm.cmsText("generic_advanced-help_01")%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
