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
  for (int i = 0; i < translatedLanguages.size(); i++) {
    EunisISOLanguagesPersist language = ( EunisISOLanguagesPersist ) translatedLanguages.get(i);
    if (language.getCode().equalsIgnoreCase( SessionManager.getCurrentLanguage() ) ) {
      selected = " selected=\"selected\"";
    } else {
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
        <a href="<%=domain%>/index.jsp" accesskey="1" title="<%=cm.cmsPhrase("Home page")%>"><%=cm.cmsPhrase("EUNIS")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/login.jsp" accesskey="l" title="<%=cm.cmsPhrase("User login")%>"><%=cm.cmsPhrase("EUNIS Login")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a id="digir_url_link" href="<%=domain%>/digir.jsp" title="<%=cm.cmsPhrase("View DiGIR application provider information")%>"><%=cm.cmsPhrase("DiGIR Provider")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/references" accesskey="r" title="<%=cm.cmsPhrase("View references used in EUNIS")%>"><%=cm.cmsPhrase("References")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/related-reports.jsp" accesskey="p" title="<%=cm.cmsPhrase("View and download reports on biodiversity")%>"><%=cm.cmsPhrase("Related reports")%></a>
      </td>
      <td colspan="3" style="padding-left : 5px; text-align : right;">
        <form action="" name="searchGoogle" id="searchGoogle" method="get" onsubmit="popSearch(); return false;">
        <label for="qq"><%=cm.cmsPhrase("GOOGLE")%></label>
        <input type="text"
               name="q"
               id="qq"
               size="15"
               title="<%=cm.cmsPhrase("Type the string you are searching for and press 'Enter'")%>"
               value="<%=cm.cmsPhrase("Search on Google")%>"
               onfocus="javascript:document.searchGoogle.qq.select();" />
        </form>
      </td>
    </tr>
    <tr>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/species.jsp" accesskey="s" title="<%=cm.cmsPhrase("Species module")%>"><%=cm.cmsPhrase("Species")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/habitats.jsp" accesskey="h" title="<%=cm.cmsPhrase("Habitat types module")%>"><%=cm.cmsPhrase("Habitats")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/sites.jsp" accesskey="t" title="<%=cm.cmsPhrase("Sites module")%>"><%=cm.cmsPhrase("Sites")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/combined-search.jsp" accesskey="c" title="<%=cm.cmsPhrase("Combined search tool")%>"><%=cm.cmsPhrase("Combined search")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/glossary.jsp" accesskey="g" title="<%=cm.cmsPhrase("Glossary of terms")%>"><%=cm.cmsPhrase("Glossary")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/eunis-map.jsp" accesskey="3" title="<%=cm.cmsPhrase("EUNIS navigation map")%>"><%=cm.cmsPhrase("EUNIS Sitemap")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/gis-tool.jsp" accesskey="u" title="<%=cm.cmsPhrase("Interactive maps")%>"><%=cm.cmsPhrase("Interactive Maps")%></a>
      </td>
      <td style="padding-left : 5px;">
        <a href="<%=domain%>/about.jsp" accesskey="b" title="<%=cm.cmsPhrase("Information about EUNIS")%>"><%=cm.cmsPhrase("About EUNIS")%></a>
      </td>
    </tr>
  </table>
</div>
