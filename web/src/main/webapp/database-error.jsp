<%@ page import="ro.finsiel.eunis.search.Utilities, ro.finsiel.eunis.WebContentManagement" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Template page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
  WebContentManagement cm = SessionManager.getWebContent();
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" pageTitle="${title}" >
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1>
          Database connection error
        </h1>
<!-- MAIN CONTENT -->
        <p>
        The EUNIS MySQL Database could not be opened.
        </p>
        <p>
        This can be a result of a:
		</p>
        <ul>
            <li>Server maintenance operation in progress</li>
            <li>Database maintenance operation in progress</li>
            <li>A communication error with the server</li>
        </ul>
        <p>
        We apologize for any inconvenience and thank you for your understanding!
        </p>
        <p>
        Please come back later.
        </p>
        <p>
        You can always contact us at: <a title="Send email to EUNIS team" href="mailto:eunis@eea.europa.eu">
        eunis@eea.europa.eu</a>
        </p>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
