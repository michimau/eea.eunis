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
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String title = Utilities.formatString( request.getParameter( "title" ), "" );
  String swf = Utilities.formatString( request.getParameter( "tutorial" ), "" );
  String swf_file = "tutorials/EUNIS_Tutorial_-_" + swf + ".swf";
%>
<c:set var="title" value='<%= title %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" pageTitle="${title}" >
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>

<!-- MAIN CONTENT -->
                <div style="text-align:center;width:100%;height:100%">
                <div style="width:800px; height:600px">
                  <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"
                  width="100%" height="100%" id="EUNIS_Database_Tutorial">
                  <param name="movie" value="<%=swf_file%>" />
                  <param name="quality" value="high" />
                  <param name="bgcolor" value="#FFFFFF" />
                  <embed src="<%=swf_file%>" quality="high" bgcolor="#FFFFFF" width="100%" height="100%" name="<%=title%>" align="" type="application/x-shockwave-flash"	pluginspace="http://www.macromedia.com/go/getflashplayer">
                  </embed>
                  </object>
                </div>
                </div>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>