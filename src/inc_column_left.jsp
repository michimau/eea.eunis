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
        <a class="navItemLevel1" href="species.jsp" accesskey="s" title="<%=cm.cms("generic_header-static_species_title")%>"><%=cm.cmsText("species")%></a><%=cm.cmsTitle("generic_header-static_species_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="habitats.jsp" accesskey="h" title="<%=cm.cms("generic_header-static_habitats_title")%>"><%=cm.cmsText("habitats")%></a><%=cm.cmsTitle("generic_header-static_habitats_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="sites.jsp" accesskey="t" title="<%=cm.cms("generic_header-static_sites_title")%>"><%=cm.cmsText("sites")%></a><%=cm.cmsTitle("generic_header-static_sites_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="combined-search.jsp" accesskey="c" title="<%=cm.cms("generic_header-static_combined_title")%>"><%=cm.cmsText("combined_search")%></a><%=cm.cmsTitle("generic_header-static_combined_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="gis-tool.jsp" accesskey="u" title="<%=cm.cms("generic_header-static_gistool_title")%>"><%=cm.cmsText("generic_header-static_gistool")%></a><%=cm.cmsTitle("generic_header-static_gistool_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="glossary.jsp" accesskey="g" title="<%=cm.cms("generic_header-static_glossary_title")%>"><%=cm.cmsText("glossary")%></a><%=cm.cmsTitle("generic_header-static_glossary_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="references.jsp" accesskey="r" title="<%=cm.cms("generic_header-static_references_title")%>"><%=cm.cmsText("references")%></a><%=cm.cmsTitle("generic_header-static_references_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" id="digir_url_link" href="digir.jsp" title="<%=cm.cms("generic_header-static_digir_title")%>"><%=cm.cmsText("generic_header-static_digir")%></a><%=cm.cmsTitle("generic_header-static_digir_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="related-reports.jsp" accesskey="p" title="<%=cm.cms("generic_header-static_reports_title")%>"><%=cm.cmsText("related_reports")%></a><%=cm.cmsTitle("generic_header-static_reports_title")%>
      </li>
    </ul>
    <span class="portletBottomLeft"></span>
    <span class="portletBottomRight"></span>
  </dd>
  <dt class="portletHeader">
    <br />
    <%=cm.cmsText( "general_information" )%>
  </dt>
  <dd class="portletItem">
    <ul class="portletNavigationTree navTreeLevel0">
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("introduction_to_eunis")%>" href="introduction.jsp"><%=cm.cmsText( "introduction" )%></a><%=cm.cmsTitle("introduction")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("about_eunis_database")%>" href="about.jsp" accesskey="b"><%=cm.cmsText( "generic_about_title" )%></a><%=cm.cmsTitle("about_eunis_database")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("generic_index_04_title")%>" href="howto.jsp"><%=cm.cmsText( "generic_index_04" )%></a><%=cm.cmsTitle("generic_index_04_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("web_site_map")%>" href="eunis-map.jsp" accesskey="3"><%=cm.cmsText( "web_site_map" )%></a><%=cm.cmsTitle("web_site_map")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("generic_index_tutorials_title")%>" href="tutorials.jsp"><%=cm.cmsText( "index_tutorials" )%></a><%=cm.cmsTitle("generic_index_tutorials_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" title="<%=cm.cms("generic_index_news_title")%>" href="news.jsp"><%=cm.cmsText( "news" )%></a><%=cm.cmsTitle("generic_index_news_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="http://biodiversity-chm.eea.europa.eu/information/database/" title="<%=cm.cms("footer_related_databases_title")%>"><%=cm.cmsText("footer_related_databases")%></a><%=cm.cmsTitle("footer_related_databases_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="mailto:<%=application.getInitParameter("EMAIL_FEEDBACK")%>" accesskey="9" title="<%=cm.cms("footer_contact_title")%>"><%=cm.cmsText("footer_contact")%></a><%=cm.cmsTitle("footer_contact_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="feedback.jsp" title="<%=cm.cms("footer_feedback_title")%>"><%=cm.cmsText("feedback")%></a><%=cm.cmsTitle("footer_feedback_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="copyright.jsp" title="<%=cm.cms("footer_copyright_title")%>"><%=cm.cmsText("copyright_and_disclaimer_title")%></a><%=cm.cmsTitle("footer_copyright_title")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="navItemLevel1" href="accessibility.jsp" title="<%=cm.cms("accessibility_statement")%>" accesskey="0"><%=cm.cmsText("footer_accessibility")%></a><%=cm.cmsTitle("accessibility_statement")%>
      </li>
    </ul>
    <span class="portletBottomLeft"></span>
    <span class="portletBottomRight"></span>
  </dd>
  <dt class="portletHeader">
    <br />
    <%=cm.cmsText("user_preferences")%>
  </dt>
  <dd class="portletItem lastItem">
    <ul class="portletNavigationTree navTreeLevel0">
<%
  if ( SessionManager.isAuthenticated() )
  {
%>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" href="index.jsp?operation=logout" title="<%=cm.cms("logout")%>"><%=cm.cmsText( "logout" )%></a>(<strong><%=SessionManager.getUsername()%></strong>)<%=cm.cmsTitle("logout")%>
      </li>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" href="javascript:saveBookmark();" title="<%=cm.cms("footer_bookmark_title")%>"><%=cm.cmsText("bookmark")%></a><%=cm.cmsTitle("footer_bookmark_title")%>
      </li>
<%
  }
  else
  {
%>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" href="login.jsp" title="<%=cm.cms("login")%>"><%=cm.cmsText( "login" )%></a><%=cm.cmsTitle("login")%>
      </li>
<%
  }
%>
      <li class="navTreeItem visualNoMarker">
        <a class="menuItem" title="<%=cm.cms("generic_index_09_title")%>" href="services.jsp"><%=cm.cmsText( "services" )%></a><%=cm.cmsTitle("generic_index_09_title")%>
      </li>
    </ul>
    <span class="portletBottomLeft"></span>
    <span class="portletBottomRight"></span>
  </dd>
</dl>
