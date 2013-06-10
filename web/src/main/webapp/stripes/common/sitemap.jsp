<%@ page import="ro.finsiel.eunis.WebContentManagement, java.net.URLEncoder, java.util.Enumeration" %>
<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Template page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String pageName = request.getRequestURI();
  String bookmarkURL = pageName + "?a=true";

  Enumeration en = request.getParameterNames();
  while ( en.hasMoreElements() )
  {
    String parameter = ( String )en.nextElement();
    String value = request.getParameter( parameter );
    if ( !parameter.equalsIgnoreCase( "page_name" ) )
    {
      bookmarkURL += "&amp;" + parameter + "=" + value;
    }
  }

%>
<script type="text/javascript">
  function saveBookmark()
  {
    var URL = "users-bookmarks-save.jsp?bookmarkURL=<%=URLEncoder.encode( bookmarkURL, "UTF-8" )%>";
    eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,resizable=yes, location=0,width=420,height=230');");
  }
</script>
<dl class="portlet" id="portlet-navigation-tree">
  <dt class="portletHeader">
    <span class="portletTopLeft"></span>
    <a href="index.jsp" class="tile">EUNIS</a>
    <span class="portletTopRight"></span>
  </dt>
  <dd class="portletItem lastItem">
    <ul class="portletNavigationTree navTreeLevel0">
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/species.jsp" accesskey="s" title="<%=cm.cmsPhrase("Species module")%>"><%=cm.cmsPhrase("Species")%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/habitats.jsp" accesskey="h" title="<%=cm.cmsPhrase("Habitat types module")%>"><%=cm.cmsPhrase("Habitat types")%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/sites.jsp" accesskey="t" title="<%=cm.cmsPhrase("Sites module")%>"><%=cm.cmsPhrase("Sites")%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/combined-search.jsp" accesskey="c" title="<%=cm.cmsPhrase("Combined search tool")%>"><%=cm.cmsPhrase("Combined search")%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/gis-tool.jsp" accesskey="u" title="<%=cm.cmsPhrase("Interactive maps")%>"><%=cm.cmsPhrase("Interactive maps")%></a>
      </li>
<%--
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/glossary.jsp" accesskey="g" title="<%=cm.cmsPhrase("Glossary of terms")%>"><%=cm.cmsPhrase("Glossary")%></a>
      </li>
--%>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/references" accesskey="r" title="<%=cm.cmsPhrase("View references used in EUNIS")%>"><%=cm.cmsPhrase("References")%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/related-reports.jsp" accesskey="p" title="<%=cm.cmsPhrase("Files and links related to biodiversity")%>"><%=cm.cmsPhrase("Downloads and links")%></a>
      </li>
<%--
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/introduction_to_google_earth.jsp" accesskey="l" title="<%=cm.cmsPhrase("Google Earth network link")%>"><%=cm.cmsPhrase("Google Earth network link")%></a>
      </li>
--%>
    </ul>
    <span class="portletBottomLeft"></span>
    <span class="portletBottomRight"></span>
  </dd>
  <dt class="portletHeader">
    <br />
    <%=cm.cmsPhrase( "General information" )%>
  </dt>
  <dd class="portletItem">
    <ul class="portletNavigationTree navTreeLevel0">
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cmsPhrase("About EUNIS Database")%>" href="<%=request.getContextPath()%>/about.jsp" accesskey="b"><%=cm.cmsPhrase( "About EUNIS" )%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cmsPhrase("Help on using EUNIS database")%>" href="<%=request.getContextPath()%>/howto.jsp"><%=cm.cmsPhrase( "How to" )%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cmsPhrase("EUNIS Sitemap")%>" href="<%=request.getContextPath()%>/eunis-map.jsp" accesskey="3"><%=cm.cmsPhrase( "EUNIS Sitemap" )%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cmsPhrase("EUNIS Database animated tutorials")%>" href="<%=request.getContextPath()%>/tutorials.jsp"><%=cm.cmsPhrase( "Tutorials" )%></a>
      </li>
<%--
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cmsPhrase("EUNIS Database latest news")%>" href="<%=request.getContextPath()%>/news.jsp"><%=cm.cmsPhrase( "EUNIS News" )%></a>
      </li>
--%>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="mailto:<%=application.getInitParameter("EMAIL_FEEDBACK")%>" accesskey="9" title="<%=cm.cmsPhrase("Contact EUNIS site administrator")%>"><%=cm.cmsPhrase("Contact EUNIS")%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/feedback.jsp" title="<%=cm.cmsPhrase("Send feedback on EUNIS Database")%>"><%=cm.cmsPhrase("EUNIS Feedback")%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/copyright.jsp" title="<%=cm.cmsPhrase("Copyright and Privacy Policy for EUNIS Database")%>"><%=cm.cmsPhrase("Copyright and Disclaimer")%></a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/accessibility.jsp" title="<%=cm.cmsPhrase("Accessibility statement")%>" accesskey="0"><%=cm.cmsPhrase("Accessibility statement")%></a>
      </li>
    </ul>
    <span class="portletBottomLeft"></span>
    <span class="portletBottomRight"></span>
  </dd>
  <dt class="portletHeader">
    <br />
    <%=cm.cmsPhrase("User operations")%>
  </dt>
  <dd class="portletItem lastItem">
    <ul class="portletNavigationTree navTreeLevel0">
<%
  if ( SessionManager.isAuthenticated() )
  {
%>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" href="<%=request.getContextPath()%>/index.jsp?operation=logout" title="<%=cm.cmsPhrase("Logout")%>"><%=cm.cmsPhrase( "Logout" )%> (<strong><%=SessionManager.getUsername()%></strong>)</a>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" href="javascript:saveBookmark();" title="<%=cm.cmsPhrase("Bookmark this page")%>"><%=cm.cmsPhrase("Bookmark")%></a>
      </li>
<%
  }
  else
  {
%>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" href="<%=request.getContextPath()%>/login.jsp" title="<%=cm.cmsPhrase("Log in to EUNIS")%>"><%=cm.cmsPhrase( "EUNIS Login" )%></a>
      </li>
<%
  }
%>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" title="<%=cm.cmsPhrase("EUNIS database special features")%>" href="<%=request.getContextPath()%>/services.jsp"><%=cm.cmsPhrase( "Services" )%></a>
      </li>
    </ul>
    <span class="portletBottomLeft"></span>
    <span class="portletBottomRight"></span>
  </dd>
</dl>
