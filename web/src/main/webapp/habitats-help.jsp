<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display information about how to use Habitat searches.
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
    String btrail = "eea#" + eeaHome + ",home#index.jsp,how_to_use_eunis_habitats_location";
  %>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Habitat type search help") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1><%=cm.cmsPhrase("EUNIS Habitat types search tools")%></h1>
<!-- MAIN CONTENT -->
                <%=cm.cmsText("habitats_help_01")%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>