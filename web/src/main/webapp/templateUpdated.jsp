<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Copyright page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtReferencesDomain,
                 java.util.Iterator,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtReferencesPersist,
                 ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.search.Utilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,copyright_and_disclaimer_title";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") +  cm.cmsPhrase("Template updated") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">

    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>
                <h1><%=cm.cmsPhrase("Template update")%></h1>

<!-- MAIN CONTENT -->
                <div class="system-msg">
                <%=cm.cmsPhrase("Template header and footer successfully updated!")%>
                </div>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>