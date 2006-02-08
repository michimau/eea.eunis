<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Static part of the header
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement" %>
<%@ page import="java.util.List" %>
<%@ page import="ro.finsiel.eunis.jrfTables.EunisISOLanguagesPersist"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.StringTokenizer"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String domain = application.getInitParameter( "DOMAIN_NAME" );
%>
<a href="#main_content" style="display:none" title="Skip to main content">Skip to main content</a>
<div id="header">
<%
  WebContentManagement cm = SessionManager.getWebContent();
  List translatedLanguages = cm.getTranslatedLanguages();
%>
  <%-- span display the banner --%>
  <span></span>
  <div class="headerlanguageprint">
  <form id="intl_lang" name="intl_lang" action="index.jsp" method="get">
    <input type="hidden" name="operation" value="changeLanguage" />
    <label for="language_international" class="noshow">Language</label>
    <select title="Select site language" id="language_international" name="language_international" onchange="changeLanguage();" class="languageTextField">
<%
  String selected;
  for(int i = 0; i < translatedLanguages.size(); i++)
  {
    EunisISOLanguagesPersist language = ( EunisISOLanguagesPersist ) translatedLanguages.get(i);
    if(language.getCode().equalsIgnoreCase( SessionManager.getCurrentLanguage() ) )
    {
      selected = " selected=\"selected\"";
    }
    else
    {
      selected = "";
    }
%>
      <option value="<%=language.getCode()%>"<%=selected%>>
        <%=language.getName()%>
      </option>
<%
  }
%>
    </select>
  </form>
  </div>
  <div class="headertextprint">
    EUNIS Database 2 - European Nature Information System Database version 2
  </div>
</div>
<div class="headerstaticprint">
  <table summary="layout" border="1" cellpadding="0" cellspacing="0" class="main_menu" width="100%">
    <tr>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/index.jsp" accesskey="1" title="<%=cm.cms("generic_header-static_home_title")%>"><%=cm.cmsText("generic_header-static_home")%></a><%=cm.cmsTitle("generic_header-static_home_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/login.jsp" accesskey="l" title="<%=cm.cms("generic_header-static_login_title")%>"><%=cm.cmsText("generic_header-static_login")%></a><%=cm.cmsTitle("generic_header-static_login_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a id="digir_url_link" href="<%=domain%>/digir.jsp" class="menu_link" title="<%=cm.cms("generic_header-static_digir_title")%>"><%=cm.cmsText("generic_header-static_digir")%></a><%=cm.cmsTitle("generic_header-static_digir_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/references.jsp" class="menu_link" accesskey="r" title="<%=cm.cms("generic_header-static_references_title")%>"><%=cm.cmsText("generic_header-static_references")%></a><%=cm.cmsTitle("generic_header-static_references_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/related-reports.jsp" accesskey="p" title="<%=cm.cms("generic_header-static_reports_title")%>"><%=cm.cmsText("generic_header-static_reports")%></a><%=cm.cmsTitle("generic_header-static_reports_title")%>
      </td>
      <td colspan="3" style="padding-left : 5px; text-align : right;">
        <form action="" name="searchGoogle" id="searchGoogle" method="get" onsubmit="popSearch(); return false;">
        <label class="menu_text" for="qq"><%=cm.cmsText("generic_header-static_google")%></label>
        <input type="text"
               name="q"
               id="qq"
               size="15"
               class="textInputColorMain"
               title="<%=cm.cms("header_google_title")%>"
               value="<%=cm.cms("header_google")%>"
               onfocus="javascript:document.searchGoogle.qq.select();" />
          <%=cm.cmsTitle("header_google_title")%>
          <%=cm.cmsInput("header_google")%>
        </form>
      </td>
    </tr>
    <tr>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/species.jsp" accesskey="s" title="<%=cm.cms("generic_header-static_species_title")%>"><%=cm.cmsText("generic_header-static_species")%></a><%=cm.cmsTitle("generic_header-static_species_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/habitats.jsp" accesskey="h" title="<%=cm.cms("generic_header-static_habitats_title")%>"><%=cm.cmsText("generic_header-static_habitats")%></a><%=cm.cmsTitle("generic_header-static_habitats_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/sites.jsp" accesskey="t" title="<%=cm.cms("generic_header-static_sites_title")%>"><%=cm.cmsText("generic_header-static_sites")%></a><%=cm.cmsTitle("generic_header-static_sites_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/combined-search.jsp" accesskey="c" title="<%=cm.cms("generic_header-static_combined_title")%>"><%=cm.cmsText("generic_header-static_combined")%></a><%=cm.cmsTitle("generic_header-static_combined_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/glossary.jsp" accesskey="g" title="<%=cm.cms("generic_header-static_glossary_title")%>"><%=cm.cmsText("generic_header-static_glossary")%></a><%=cm.cmsTitle("generic_header-static_glossary_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/eunis-map.jsp" accesskey="3" title="<%=cm.cms("generic_header-static_sitemap_title")%>"><%=cm.cmsText("generic_header-static_sitemap")%></a><%=cm.cmsTitle("generic_header-static_sitemap_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/gis-tool.jsp" accesskey="u" title="<%=cm.cms("generic_header-static_gistool_title")%>"><%=cm.cmsText("generic_header-static_gistool")%></a><%=cm.cmsTitle("generic_header-static_gistool_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a class="menu_link" href="<%=domain%>/about.jsp" accesskey="b" title="<%=cm.cms("generic_header-static_about_title")%>"><%=cm.cmsText("generic_header-static_about")%></a><%=cm.cmsTitle("generic_header-static_about_title")%>
      </td>
    </tr>
  </table>
</div>
