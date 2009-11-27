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
<a href="#documentContent" style="display:none">Skip to document content</a>
<div id="header">
<%
	WebContentManagement cm = SessionManager.getWebContent();
  List translatedLanguages = cm.getTranslatedLanguages();
%>
  <%-- span display the banner --%>
  <span></span>
  <div class="headerlanguageprint">
  <form id="intl_lang" name="intl_lang" action="index.jsp" method="get" style="padding: 0px; margin: 0px;">
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
  <table summary="layout" border="1" cellpadding="0" cellspacing="0" width="100%">
    <tr>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/index.jsp" accesskey="1" title="<%=cm.cms("home_page")%>"><%=cm.cmsPhrase("EUNIS")%></a><%=cm.cmsTitle("home_page")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/login.jsp" accesskey="l" title="<%=cm.cms("generic_header-static_login_title")%>"><%=cm.cmsPhrase("EUNIS Login")%></a><%=cm.cmsTitle("generic_header-static_login_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a id="digir_url_link" href="<%=domain%>/digir.jsp" title="<%=cm.cms("generic_header-static_digir_title")%>"><%=cm.cmsPhrase("DiGIR Provider")%></a><%=cm.cmsTitle("generic_header-static_digir_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/references.jsp" accesskey="r" title="<%=cm.cms("generic_header-static_references_title")%>"><%=cm.cmsPhrase("References")%></a><%=cm.cmsTitle("generic_header-static_references_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/related-reports.jsp" accesskey="p" title="<%=cm.cms("generic_header-static_reports_title")%>"><%=cm.cmsPhrase("Related reports")%></a><%=cm.cmsTitle("generic_header-static_reports_title")%>
      </td>
      <td colspan="3" style="padding-left : 5px; text-align : right;">
        <form action="" name="searchGoogle" id="searchGoogle" method="get" onsubmit="popSearch(); return false;">
        <label for="qq"><%=cm.cmsPhrase("GOOGLE")%></label>
        <input type="text"
               name="q"
               id="qq"
               size="15"
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
        <a href="<%=domain%>/species.jsp" accesskey="s" title="<%=cm.cms("generic_header-static_species_title")%>"><%=cm.cmsPhrase("species")%></a><%=cm.cmsTitle("generic_header-static_species_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/habitats.jsp" accesskey="h" title="<%=cm.cms("generic_header-static_habitats_title")%>"><%=cm.cmsPhrase("Habitats")%></a><%=cm.cmsTitle("generic_header-static_habitats_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/sites.jsp" accesskey="t" title="<%=cm.cms("generic_header-static_sites_title")%>"><%=cm.cmsPhrase("Sites")%></a><%=cm.cmsTitle("generic_header-static_sites_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/combined-search.jsp" accesskey="c" title="<%=cm.cms("generic_header-static_combined_title")%>"><%=cm.cmsPhrase("Combined search")%></a><%=cm.cmsTitle("generic_header-static_combined_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/glossary.jsp" accesskey="g" title="<%=cm.cms("generic_header-static_glossary_title")%>"><%=cm.cmsPhrase("Glossary")%></a><%=cm.cmsTitle("generic_header-static_glossary_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/eunis-map.jsp" accesskey="3" title="<%=cm.cms("generic_header-static_sitemap_title")%>"><%=cm.cmsPhrase("EUNIS Sitemap")%></a><%=cm.cmsTitle("generic_header-static_sitemap_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/gis-tool.jsp" accesskey="u" title="<%=cm.cms("generic_header-static_gistool_title")%>"><%=cm.cmsPhrase("Interactive Maps")%></a><%=cm.cmsTitle("generic_header-static_gistool_title")%>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/about.jsp" accesskey="b" title="<%=cm.cms("generic_header-static_about_title")%>"><%=cm.cmsPhrase("About EUNIS")%></a><%=cm.cmsTitle("generic_header-static_about_title")%>
      </td>
    </tr>
  </table>
</div>
