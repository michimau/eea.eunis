<%@ page import="ro.finsiel.eunis.WebContentManagement" %>
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
  //String domain = application.getInitParameter( "DOMAIN_NAME" );
%>
<dl class="portlet" id="eea-portlet-navigation-tree">
  <dt class="portletHeader">
	  Main
  </dt>
  <dd class="portletItem">
    <ul class="portletNavigationTree navTreeLevel2">
      <li class="">
        <a class="menuItem" href="index.jsp" accesskey="1" title="<%=cm.cms("home_page")%>">&raquo; <%=cm.cmsText("home")%></a><%=cm.cmsTitle("home_page")%>
      </li>
      <li class="">
        <a class="menuItem" href="species.jsp" accesskey="s" title="<%=cm.cms("generic_header-static_species_title")%>">&raquo; <%=cm.cmsText("species")%></a><%=cm.cmsTitle("generic_header-static_species_title")%>
      </li>
      <li class="">
        <a class="menuItem" href="habitats.jsp" accesskey="h" title="<%=cm.cms("generic_header-static_habitats_title")%>">&raquo; <%=cm.cmsText("habitats")%></a><%=cm.cmsTitle("generic_header-static_habitats_title")%>
      </li>
      <li class="">
        <a class="menuItem" href="sites.jsp" accesskey="t" title="<%=cm.cms("generic_header-static_sites_title")%>">&raquo; <%=cm.cmsText("sites")%></a><%=cm.cmsTitle("generic_header-static_sites_title")%>
      </li>
      <li class="">
        <a class="menuItem" href="combined-search.jsp" accesskey="c" title="<%=cm.cms("generic_header-static_combined_title")%>">&raquo; <%=cm.cmsText("combined_search")%></a><%=cm.cmsTitle("generic_header-static_combined_title")%>
      </li>
      <li class="">
        <a class="menuItem" href="gis-tool.jsp" accesskey="u" title="<%=cm.cms("generic_header-static_gistool_title")%>">&raquo; <%=cm.cmsText("generic_header-static_gistool")%></a><%=cm.cmsTitle("generic_header-static_gistool_title")%>
      </li>
      <li class="">
        <a class="menuItem" href="glossary.jsp" accesskey="g" title="<%=cm.cms("generic_header-static_glossary_title")%>">&raquo; <%=cm.cmsText("glossary")%></a><%=cm.cmsTitle("generic_header-static_glossary_title")%>
      </li>
      <li class="">
        <a class="menuItem" href="references.jsp" accesskey="r" title="<%=cm.cms("generic_header-static_references_title")%>">&raquo; <%=cm.cmsText("references")%></a><%=cm.cmsTitle("generic_header-static_references_title")%>
      </li>
      <li class="">
        <a class="menuItem" id="digir_url_link" href="digir.jsp" title="<%=cm.cms("generic_header-static_digir_title")%>">&raquo; <%=cm.cmsText("generic_header-static_digir")%></a><%=cm.cmsTitle("generic_header-static_digir_title")%>
      </li>
      <li class="">
        <a class="menuItem" href="related-reports.jsp" accesskey="p" title="<%=cm.cms("generic_header-static_reports_title")%>">&raquo; <%=cm.cmsText("related_reports")%></a><%=cm.cmsTitle("generic_header-static_reports_title")%>
      </li>
    </ul>
  </dd>
  <dt class="portletHeader">
    <br />
    <%=cm.cmsText( "general_information" )%>
  </dt>
  <dd class="portletItem">
    <ul class="portletNavigationTree navTreeLevel2">
      <li class="">
        <a class="menuItem" title="<%=cm.cms("introduction_to_eunis")%>" href="introduction.jsp">&raquo; <%=cm.cmsText( "introduction" )%></a><%=cm.cmsTitle("introduction")%>
      </li>
      <li class="">
        <a class="menuItem" title="<%=cm.cms("about_eunis_database")%>" href="about.jsp" accesskey="b">&raquo; <%=cm.cmsText( "generic_about_title" )%></a><%=cm.cmsTitle("about_eunis_database")%>
      </li>
      <li class="">
        <a class="menuItem" title="<%=cm.cms("generic_index_04_title")%>" href="howto.jsp">&raquo; <%=cm.cmsText( "generic_index_04" )%></a><%=cm.cmsTitle("generic_index_04_title")%>
      </li>
      <li class="">
        <a class="menuItem" title="<%=cm.cms("web_site_map")%>" href="eunis-map.jsp" accesskey="3">&raquo; <%=cm.cmsText( "web_site_map" )%></a><%=cm.cmsTitle("web_site_map")%>
      </li>
      <li class="">
        <a class="menuItem" title="<%=cm.cms("generic_index_tutorials_title")%>" href="tutorials.jsp">&raquo; <%=cm.cmsText( "index_tutorials" )%></a><%=cm.cmsTitle("generic_index_tutorials_title")%>
      </li>
      <li class="">
        <a class="menuItem" title="<%=cm.cms("generic_index_news_title")%>" href="news.jsp">&raquo; <%=cm.cmsText( "news" )%></a><%=cm.cmsTitle("generic_index_news_title")%>
      </li>
    </ul>
  </dd>
  <dt class="portletHeader">
    <br />
    <%=cm.cmsText("user_preferences")%>
  </dt>
  <dd class="portletItem">
    <ul class="portletNavigationTree navTreeLevel2">
<%
  if ( SessionManager.isAuthenticated() )
  {
%>
      <li>
        <a class="menuItem" href="index.jsp?operation=logout" title="<%=cm.cms("logout")%>">&raquo; <%=cm.cmsText( "logout" )%></a><%=cm.cmsTitle("logout")%>
        (<strong><%=SessionManager.getUsername()%></strong>)
      </li>
<%
  }
  else
  {
%>
      <li>
        <a class="menuItem" href="login.jsp" title="<%=cm.cms("login")%>">&raquo; <%=cm.cmsText( "login" )%></a><%=cm.cmsTitle("login")%>
      </li>
<%
  }
%>
      <li>
        <a class="menuItem" title="<%=cm.cms("generic_index_09_title")%>" href="services.jsp">&raquo; <%=cm.cmsText( "services" )%></a><%=cm.cmsTitle("generic_index_09_title")%>
        <%=cm.cmsText( "generic_index_07" )%>
      </li>
    </ul>
  </dd>
</dl>