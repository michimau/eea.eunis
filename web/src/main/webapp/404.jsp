<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Error page (exception handler page) for the application. Invoked by servlet container (see web.xml).
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
    request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,error_page_01";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Page not found") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">

        <%@ page isErrorPage="true"%>

    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>

                <br clear="all" />
<!-- MAIN CONTENT -->

                <br />
                <br />
                <%=cm.cmsText("generic_404_01")%>
                <br />
                <br />
                <strong>
                  Resource not found.
                </strong>
                <br />
<!-- END MAIN CONTENT -->

    </stripes:layout-component>
</stripes:layout-render>
