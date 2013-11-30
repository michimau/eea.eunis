<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : GIS Tool
--%>
<%@page contentType="text/html;charset=UTF-8"%> <%@ include file="/stripes/common/taglibs.jsp"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
  <%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,gis_tool";
  %>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Interactive map") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" helpLink="gis-tool-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
		<h1><%=cm.cmsPhrase("Interactive map")%></h1>
<!-- MAIN CONTENT -->
<%--todo: text too large --%>
    <div style="width:740px; height:552px">
<div style="margin:auto; font-size: 2.5em;">The EUNIS mapping tool is under re-development. In the meanwhile
we refer to the <a href="http://natura2000.eea.europa.eu/">Natura 2000 map viewer</a>
from where e.g. nationally designated areas are also available.</div>
                    </div>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>