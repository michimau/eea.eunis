<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : No results found during search
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + "," + Utilities.formatString( request.getParameter( "location" ) );
  boolean fromRefine = Utilities.checkedStringToBoolean( request.getParameter("fromRefine"), false );
  String titlePage = cm.cmsPhrase("No results found for this search");
  if( fromRefine )
  {
    titlePage = cm.cmsPhrase("No results found for refine search");
  }
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= location%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>
<!-- MAIN CONTENT -->
                <h1>
                  <%=titlePage%>
                </h1>
                <%=cm.cmsPhrase("<br /><br />The input rules were probably too restrictive, please try a more generic approach.<br /><br />Please go")%>
                <strong>
                  <a href="javascript:history.go(-1)" title="Go to previous page"><%=cm.cmsPhrase("Back")%></a>
                </strong>
                <%=cm.cmsPhrase("and review the search criteria")%>.
                <br />
                <br />
                <br />
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>