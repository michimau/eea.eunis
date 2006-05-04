<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats module' function - display links to all habitat searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                ro.finsiel.eunis.search.Utilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" type="text/javascript" src="script/tabs/listener.js"></script>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
    int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
    String []tabs = { cm.cms("easy_search"), cm.cms("advanced_search"), cm.cms("links_and_downloads"), cm.cms("help") };
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitat_type_search")%>
  </title>
</head>

<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home#index.jsp,habitat_types" />
</jsp:include>
<div id="loading" class="dynamic_content">
<%=cm.cms("loading_data")%>
</div>
<div style="width : 100%;">
  <h1 align="center">
    <%=cm.cmsText("habitat_type_search")%>
  </h1>
  <h2 align="center">
    <%=cm.cmsText("habitats_main_description")%>
  </h2>
</div>
<br />
<div id="qs" align="center" style="padding-left : 10px; width : 100%; vertical-align : middle;">
  <form name="quick_search" action="habitats-names-result.jsp" method="post" onsubmit="javascript:if(trim(document.quick_search.searchString.value) == '' || trim(document.quick_search.searchString.value) == 'Enter habitat name here...') {alert('Before searching, please type a few letters from habitat name.');return false;} else return true; ">
    <input type="hidden" name="showLevel" value="true" />
    <input type="hidden" name="showCode" value="true" />
    <input type="hidden" name="showScientificName" value="true" />
    <input type="hidden" name="showVernacularName" value="true" />
    <input type="hidden" name="showOtherInfo" value="true" />
    <input type="hidden" name="database" value="<%=NamesDomain.SEARCH_BOTH%>" />
    <input type="hidden" name="useScientific" value="true" />
    <input type="hidden" name="useVernacular" value="true" />
    <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_STARTS%>" />
    <label for="searchString"><%=cm.cmsText("quick_search_habitats_01")%></label>
    <input id="searchString" type="text"
           size="30" name="searchString" class="inputTextField"
           title="<%=cm.cms("habitat_to_search_for")%>"
           value="<%=cm.cms("enter_habitat_name_here")%>"
           onfocus="javascript:document.quick_search.searchString.select();" />
    <%=cm.cmsTitle("habitat_to_search_for")%>
    <%=cm.cmsInput("enter_habitat_name_here")%>
    <input type="submit"
           value="<%=cm.cms("search")%>"
           name="Submit"
           id="Submit"
           class="inputTextField"
           title="Search" />
    <%=cm.cmsInput("search")%>
    <a href="fuzzy-search-help.jsp" title="<%=cm.cms("help_fuzzy_search")%>"><img alt="<%=cm.cms("help_fuzzy_search")%>" title="<%=cm.cms("help_fuzzy_search")%>" src="images/mini/help.jpg" border="0" style="vertical-align:middle" /></a>
    <%=cm.cmsTitle("help_fuzzy_search")%>
  </form>
<br />
</div>
<div id="tabbedmenu">
  <ul>
<%
  String currentTab = "";
  for ( int i = 0; i < tabs.length; i++ )
  {
    currentTab = "";
    if ( tab == i ) currentTab = " id=\"currenttab\"";
%>
      <li<%=currentTab%>>
        <a title="<%=cm.cms("show")%> <%=tabs[i]%>" href="habitats.jsp?tab=<%=i%>"><%=tabs[i]%></a>
        <%=cm.cmsTitle("show")%>
      </li>
<%
    }
%>
      </ul>
    </div>
    <br clear="all" />
    <br />
<%
  if ( tab == 0 )
  {
%>
<span style="text-align : center; width : 640px;">
  <span class="fontNormal">
    <%=cm.cmsText("habitats_main_easySearchesDesc") %>
  </span>
</span>
<br />
<br />
<table summary="<%=cm.cms("easy_searches")%>" cellspacing="1" cellpadding="3"  width="100%" border="0" class="fontNormal">
<tr bgcolor="#EEEEEE">
  <th width="40%" style="white-space:nowrap">
    <%=cm.cmsText("links_to_easy_searches")%>
  </th>
  <th width="60%">
    <%=cm.cmsText("description")%>
  </th>
</tr>
<tr bgcolor="#EEEEEE">
  <td width="40%" style="white-space:nowrap">
    <img alt="<%=cm.cms("names_and_descriptions")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("names_and_descriptions")%>
    <a title="<%=cm.cms("habitats_main_namesDesc")%>" href="habitats-names.jsp"><strong><%=cm.cmsText("names_and_descriptions")%></strong></a>
    <%=cm.cmsTitle("habitats_main_namesDesc")%>
  </td>
  <td width="60%">
    <%=cm.cmsText("habitats_main_namesDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="<%=cm.cms("legal_instruments")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("legal_instruments")%>
    <a title="<%=cm.cms("habitats_main_legalDesc")%>"  href="habitats-legal.jsp"><strong><%=cm.cmsText("legal_instruments")%></strong></a>
    <%=cm.cmsTitle("habitats_main_legalDesc")%>
  </td>
  <td>
    <%=cm.cmsText("habitats_main_legalDesc")%>
  </td>
</tr>
<tr bgcolor="#EEEEEE">
  <td style="white-space:nowrap">
    <img alt="<%=cm.cms("country_biogeographic_region_location")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("country_biogeographic_region_location")%>
    <a title="<%=cm.cms("habitats_main_countryDesc")%>"  href="habitats-country.jsp"><strong><%=cm.cmsText("country_biogeographic_region_location")%></strong></a>
    <%=cm.cmsTitle("habitats_main_countryDesc")%>
  </td>
  <td>
    <%=cm.cmsText("habitats_main_countryDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="<%=cm.cms("code_classifications")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("code_classifications")%>
    <a title="<%=cm.cms("habitats_main_codeDesc")%>"  href="habitats-code.jsp"><strong><%=cm.cmsText("code_classifications")%></strong></a>
    <%=cm.cmsTitle("habitats_main_codeDesc")%>
  </td>
  <td>
    <%=cm.cmsText("habitats_main_codeDesc")%>
  </td>
</tr>
<tr bgcolor="#EEEEEE">
  <td style="white-space:nowrap">
    <img alt="<%=cm.cms("pick_habitat_types_show_species")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("pick_habitat_types_show_species")%>
    <a title="<%=cm.cms("habitats_main_showSpeciesDesc")%>"  href="species-habitats.jsp"><strong><%=cm.cmsText("pick_habitat_types_show_species")%></strong></a>
    <%=cm.cmsTitle("habitats_main_showSpeciesDesc")%>
  </td>
  <td>
    <%=cm.cmsText("habitats_main_showSpeciesDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="<%=cm.cms("pick_habitat_types_show_sites")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("pick_habitat_types_show_sites")%>
    <a title="<%=cm.cms("habitats_main_showSitesDesc")%>"  href="sites-habitats.jsp"><strong><%=cm.cmsText("pick_habitat_types_show_sites")%></strong></a>
    <%=cm.cmsTitle("habitats_main_showSitesDesc")%>
  </td>
  <td>
    <%=cm.cmsText("habitats_main_showSitesDesc")%>
  </td>
</tr>
<tr bgcolor="#EEEEEE">
  <td style="white-space:nowrap">
    <img alt="<%=cm.cms("habitats_main_showReferences")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("habitats_main_showReferences")%>
    <a title="<%=cm.cms("habitats_main_showReferencesDesc")%>"  href="habitats-books.jsp"><strong><%=cm.cmsText("habitats_main_showReferences")%></strong></a>
    <%=cm.cmsTitle("habitats_main_showReferencesDesc")%>
  </td>
  <td>
    <%=cm.cmsText("habitats_main_showReferencesDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="<%=cm.cms("pick_references_show_habitat_types")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("pick_references_show_habitat_types")%>
    <a title="<%=cm.cms("habitats_main_showHabitatsDesc")%>"  href="habitats-references.jsp"><strong><%=cm.cmsText("pick_references_show_habitat_types")%></strong></a>
    <%=cm.cmsTitle("habitats_main_showHabitatsDesc")%>
  </td>
  <td>
    <%=cm.cmsText("habitats_main_showHabitatsDesc")%>
  </td>
</tr>
<tr bgcolor="#EEEEEE">
  <td style="white-space:nowrap">
    <img alt="<%=cm.cms("habitats_main_key")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("habitats_main_key")%>
    <a title="<%=cm.cms("habitats_main_keyDesc")%>"  href="habitats-key.jsp"><strong><%=cm.cmsText("habitats_main_key")%></strong></a>
    <%=cm.cmsTitle("habitats_main_keyDesc")%>
  </td>
  <td>
    <%=cm.cmsText("habitats_main_keyDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="<%=cm.cms("habitats_main_EUNIShierarchy")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("habitats_main_EUNIShierarchy")%>
    <a title="<%=cm.cms("habitats_main_EUNIShierarchyDesc")%>"  href="habitats-code-browser.jsp"><strong><%=cm.cmsText("habitats_main_EUNIShierarchy")%></strong></a>
    <%=cm.cmsTitle("habitats_main_EUNIShierarchyDesc")%>
  </td>
  <td>
    <%=cm.cmsText("habitats_main_EUNIShierarchyDesc")%>
  </td>
</tr>
<tr bgcolor="#EEEEEE">
  <td style="white-space:nowrap">
    <img alt="<%=cm.cms("habitats_main_ANNEXhierarchy")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("habitats_main_ANNEXhierarchy")%>
    <a title="<%=cm.cms("habitats_main_ANNEXhierarchyDesc")%>"  href="habitats-annex1-browser.jsp"><strong><%=cm.cmsText("habitats_main_ANNEXhierarchy")%></strong></a>
    <%=cm.cmsTitle("habitats_main_ANNEXhierarchyDesc")%>
  </td>
  <td>
    <%=cm.cmsText("habitats_main_ANNEXhierarchyDesc")%>
  </td>
</tr>
</table>
<%
  }
  if ( tab == 1 )
  {
%>
  <span style="text-align : center; width : 640px;">
    <span class="fontNormal">
      <%=cm.cmsText("habitats_main_advSearchDesc") %>
    </span>
  </span>
  <br />
  <br />
  <table summary="<%=cm.cms("advanced_searches")%>" cellspacing="1" cellpadding="3" width="100%" border="0" class="fontNormal">
    <tr bgcolor="#EEEEEE">
      <th width="40%" style="white-space:nowrap">
        <%=cm.cmsText("links_to_advanced_searches")%>
      </th>
      <th width="60%">
        <%=cm.cmsText("description")%>
      </th>
    </tr>
    <tr bgcolor="#EEEEEE">
      <td width="40%" style="white-space:nowrap">
        <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
        <a title="<%=cm.cms("habitats_main_advSearchSearchDesc")%>"  href="habitats-advanced.jsp?natureobject=Habitat"><strong><%=cm.cmsText("advanced_search")%></strong></a>
        <%=cm.cmsTitle("habitats_main_advSearchSearchDesc")%>
      </td>
      <td width="60%">
        <%=cm.cmsText("habitats_main_advSearchSearchDesc")%>
      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td style="white-space:nowrap">
        <img alt="<%=cm.cms("how_to_use_advanced_search")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("how_to_use_advanced_search")%>
        <a title="<%=cm.cms("habitats_main_advSearchHelpDesc")%>"  href="advanced-help.jsp"><strong><%=cm.cmsText("how_to_use_advanced_search")%></strong></a>
        <%=cm.cmsTitle("habitats_main_advSearchHelpDesc")%>
      </td>
      <td>
        <%=cm.cmsText("habitats_main_advSearchHelpDesc")%>
      </td>
    </tr>
  </table>
<%
  }
  if ( tab == 2 )
  {
%>
  <span style="text-align : center; width : 640px;">
    <span class="fontNormal">
      <%=cm.cmsText("habitats_links_and_downloads_tab")%>
    </span>
  </span>
  <br />
  <br />
  <table summary="Links and downloads" cellspacing="1" cellpadding="3" width="100%" border="0">
    <tr>
      <th width="40%">
        <%=cm.cmsText("links_to_data_downloads")%>
      </th>
      <th width="60%">
        <%=cm.cmsText("description")%>
      </th>
    </tr>
    <tr bgcolor="#EEEEEE">
      <td width="40%">
        <img alt="<%=cm.cms("links_and_downloads_2")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("links_and_downloads_2")%>
        <a title="<%=cm.cms("links_and_downloads_2")%>"  href="habitats-download.jsp"><strong><%=cm.cmsText("links_and_downloads_2")%></strong></a>
        <%=cm.cmsTitle("links_and_downloads_2")%>
      </td>
      <td width="60%">
        <%=cm.cmsText("links_and_downloads_2")%>
      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td style="white-space:nowrap">
        <img alt="Habitat type indicators" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
          <%=cm.cmsText("habitats_main_indicators")%>
      </td>
      <td>
        <%=cm.cmsText("habitats_main_indicatorsDesc")%>
      </td>
    </tr>
  </table>
<%
  }
  if ( tab == 3 )
  {
%>
  <span style="text-align : center; width : 640px;">
          <span class="fontNormal">
            <%=cm.cmsText("general_information_on_eunis") %>
          </span>
        </span>
  <br />
  <br />
  <table summary="Help" cellspacing="1" cellpadding="3" width="100%" border="0" class="fontNormal">
    <tr bgcolor="#EEEEEE">
      <th width="40%" style="white-space:nowrap">
        <%=cm.cmsText("links_to_online_help")%>
      </th>
      <th width="60%">
        <%=cm.cmsText("description")%>
      </th>
    </tr>
    <tr bgcolor="#EEEEEE">
      <td width="40%" style="white-space:nowrap">
        <img alt="<%=cm.cms("habitats_main_easyHelp")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("habitats_main_easyHelp")%>
        <a title="<%=cm.cms("habitats_main_easyHelpDesc")%>"  href="easy-help.jsp"><strong><%=cm.cmsText("habitats_main_easyHelp")%></strong></a>
        <%=cm.cmsTitle("habitats_main_easyHelpDesc")%>
      </td>
      <td width="60%">
        <%=cm.cmsText("habitats_main_easyHelpDesc")%>
      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td style="white-space:nowrap">
        <img alt="<%=cm.cms("glossary")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("glossary")%>
        <a title="<%=cm.cms("habitats_main_glossaryDesc")%>"  href="glossary.jsp?module=habitat"><strong><%=cm.cmsText("glossary")%></strong></a>
        <%=cm.cmsTitle("habitats_main_glossaryDesc")%>
      </td>
      <td>
        <%=cm.cmsText("habitats_main_glossaryDesc")%>
      </td>
    </tr>
    <tr bgcolor="#EEEEEE">
      <td style="white-space:nowrap">
        <img alt="<%=cm.cms("how_to_use")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("how_to_use")%>
        <a title="<%=cm.cms("habitats_main_howToDesc")%>"  href="habitats-help.jsp"><strong><%=cm.cmsText("how_to_use")%></strong></a>
        <%=cm.cmsTitle("habitats_main_howToDesc")%>
      </td>
      <td>
        <%=cm.cmsText("habitats_main_howToDesc")%>
      </td>
    </tr>
  </table>
<%
  }
%>
<%=cm.br()%>
<%=cm.cmsMsg("habitat_type_search")%>
<%=cm.br()%>
<%=cm.cmsMsg("easy_searches")%>
<%=cm.br()%>
<%=cm.cmsMsg("advanced_searches")%>
<%=cm.br()%>
<%=cm.cmsMsg("easy_search")%>
<%=cm.br()%>
<%=cm.cmsMsg("advanced_search")%>
<%=cm.br()%>
<%=cm.cmsMsg("links_and_downloads")%>
<%=cm.br()%>
<%=cm.cmsMsg("help")%>
<%=cm.br()%>
<%=cm.cmsMsg("loading_data")%>
<%=cm.br()%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats.jsp" />
</jsp:include>
<script language="javascript" type="text/javascript">
try
  {
    var ctrl_loading = document.getElementById("loading");
    ctrl_loading.style.display = "none";
  }
  catch ( e )
  {
  }
</script>
</div>
</div>
</div>
</body>
</html>