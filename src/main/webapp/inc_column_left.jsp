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
  String page_name = request.getParameter( "page_name" );
  String bookmarkURL = page_name + "?a=true";

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
<script language="javascript" type="text/javascript">
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
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/species.jsp" accesskey="s" title="<%=cm.cms("generic_header-static_species_title")%>"><%=cm.cmsPhrase("Species")%></a><%=cm.cmsTitle("generic_header-static_species_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/habitats.jsp" accesskey="h" title="<%=cm.cms("generic_header-static_habitats_title")%>"><%=cm.cmsPhrase("Habitats")%></a><%=cm.cmsTitle("generic_header-static_habitats_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/sites.jsp" accesskey="t" title="<%=cm.cms("generic_header-static_sites_title")%>"><%=cm.cmsPhrase("Sites")%></a><%=cm.cmsTitle("generic_header-static_sites_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/combined-search.jsp" accesskey="c" title="<%=cm.cms("generic_header-static_combined_title")%>"><%=cm.cmsPhrase("Combined search")%></a><%=cm.cmsTitle("generic_header-static_combined_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/gis-tool.jsp" accesskey="u" title="<%=cm.cms("generic_header-static_gistool_title")%>"><%=cm.cmsPhrase("Interactive Maps")%></a><%=cm.cmsTitle("generic_header-static_gistool_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/glossary.jsp" accesskey="g" title="<%=cm.cms("generic_header-static_glossary_title")%>"><%=cm.cmsPhrase("Glossary")%></a><%=cm.cmsTitle("generic_header-static_glossary_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/references.jsp" accesskey="r" title="<%=cm.cms("generic_header-static_references_title")%>"><%=cm.cmsPhrase("References")%></a><%=cm.cmsTitle("generic_header-static_references_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" id="digir_url_link" href="<%=request.getContextPath()%>/digir.jsp" title="<%=cm.cms("generic_header-static_digir_title")%>"><%=cm.cmsPhrase("DiGIR Provider")%></a><%=cm.cmsTitle("generic_header-static_digir_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/related-reports.jsp" accesskey="p" title="<%=cm.cms("generic_header-static_reports_title")%>"><%=cm.cmsPhrase("Related reports")%></a><%=cm.cmsTitle("generic_header-static_reports_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/introduction_to_google_earth.jsp" accesskey="l" title="<%=cm.cms("google_earth_network_link_title")%>"><%=cm.cmsPhrase("Google Earth network link")%></a><%=cm.cmsTitle("google_earth_network_link_title")%>
      </li>
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
        <a class="navItemLevel1" title="<%=cm.cms("introduction_to_eunis")%>" href="<%=request.getContextPath()%>/introduction.jsp"><%=cm.cmsPhrase( "Introduction" )%></a><%=cm.cmsTitle("introduction")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("about_eunis_database")%>" href="<%=request.getContextPath()%>/about.jsp" accesskey="b"><%=cm.cmsPhrase( "About EUNIS" )%></a><%=cm.cmsTitle("about_eunis_database")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("generic_index_04_title")%>" href="<%=request.getContextPath()%>/howto.jsp"><%=cm.cmsPhrase( "How to" )%></a><%=cm.cmsTitle("generic_index_04_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("web_site_map")%>" href="<%=request.getContextPath()%>/eunis-map.jsp" accesskey="3"><%=cm.cmsPhrase( "EUNIS Sitemap" )%></a><%=cm.cmsTitle("web_site_map")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("generic_index_tutorials_title")%>" href="<%=request.getContextPath()%>/tutorials.jsp"><%=cm.cmsPhrase( "Tutorials" )%></a><%=cm.cmsTitle("generic_index_tutorials_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("generic_index_news_title")%>" href="<%=request.getContextPath()%>/news.jsp"><%=cm.cmsPhrase( "EUNIS News" )%></a><%=cm.cmsTitle("generic_index_news_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="http://biodiversity-chm.eea.europa.eu/information/database/" title="<%=cm.cms("footer_related_databases_title")%>"><%=cm.cmsPhrase("Related databases")%></a><%=cm.cmsTitle("footer_related_databases_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="mailto:<%=application.getInitParameter("EMAIL_FEEDBACK")%>" accesskey="9" title="<%=cm.cms("footer_contact_title")%>"><%=cm.cmsPhrase("Contact EUNIS")%></a><%=cm.cmsTitle("footer_contact_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/feedback.jsp" title="<%=cm.cms("footer_feedback_title")%>"><%=cm.cmsPhrase("EUNIS Feedback")%></a><%=cm.cmsTitle("footer_feedback_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/copyright.jsp" title="<%=cm.cms("footer_copyright_title")%>"><%=cm.cmsPhrase("EUNIS Copyright and Disclaimer")%></a><%=cm.cmsTitle("footer_copyright_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="<%=request.getContextPath()%>/accessibility.jsp" title="<%=cm.cms("accessibility_statement")%>" accesskey="0"><%=cm.cmsPhrase("Eunis Accessibility statement")%></a><%=cm.cmsTitle("accessibility_statement")%>
      </li>
    </ul>
    <span class="portletBottomLeft"></span>
    <span class="portletBottomRight"></span>
  </dd>
  <dt class="portletHeader">
    <br />
    <%=cm.cmsPhrase("User preferences")%>
  </dt>
  <dd class="portletItem lastItem">
    <ul class="portletNavigationTree navTreeLevel0">
<%
  if ( SessionManager.isAuthenticated() )
  {
%>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" href="<%=request.getContextPath()%>/index.jsp?operation=logout" title="<%=cm.cms("logout")%>"><%=cm.cmsPhrase( "Logout" )%></a>(<strong><%=SessionManager.getUsername()%></strong>)<%=cm.cmsTitle("logout")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" href="javascript:saveBookmark();" title="<%=cm.cms("footer_bookmark_title")%>"><%=cm.cmsPhrase("Bookmark")%></a><%=cm.cmsTitle("footer_bookmark_title")%>
      </li>
<%
  }
  else
  {
%>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" href="<%=request.getContextPath()%>/login.jsp" title="<%=cm.cms("login")%>"><%=cm.cmsPhrase( "EUNIS Login" )%></a><%=cm.cmsTitle("login")%>
      </li>
<%
  }
%>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" title="<%=cm.cms("generic_index_09_title")%>" href="<%=request.getContextPath()%>/services.jsp"><%=cm.cmsPhrase( "Services" )%></a><%=cm.cmsTitle("generic_index_09_title")%>
      </li>
    </ul>
    <span class="portletBottomLeft"></span>
    <span class="portletBottomRight"></span>
  </dd>
</dl>
