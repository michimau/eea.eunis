<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats module' function - display links to all habitat searches.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                ro.finsiel.eunis.search.Utilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript" src="script/tabs/listener.js"></script>
  <script language="javascript" type="text/javascript">
  function popIndicators(URL)
    {
    //URL = "http://themes.eea.eu.int/Environmental_issues/biodiversity/indicators/";
      eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=700,height=500,left=200,top=100')");
    }
  </script>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
    int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );

    String []tabs = { "Easy search", "Advanced search", "Links &amp; Downloads", "Help" };
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.getContent("habitats_main_title", false)%>
  </title>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitats" />
</jsp:include>
<div id="loading" class="dynamic_content">
  Loading page, please wait...
</div>
<div style="width : 740px;">
  <h5 align="center">
    <%=cm.getContent("habitats_main_habitatsSearch")%>
  </h5>
  <h6 align="center">
    <%=cm.getContent("habitats_main_description")%>
  </h6>
</div>
<br />
<div id="qs" align="center" style="padding-left : 10px; width : 740px; vertical-align : middle;">
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
    <label for="searchString"><%=cm.getContent("quick_search_habitats_01")%></label>
    <input id="searchString" type="text"
           size="30" name="searchString" class="inputTextField"
           title="Habitat type name to search for"
           value="Enter habitat name here..."
           onfocus="javascript:document.quick_search.searchString.select();" />
    <label for="Submit" class="noshow">Search</label>
    <input type="submit"
           value="<%=cm.getContent("habitats_main_btnSearch", false)%>"
           name="Submit"
           id="Submit"
           class="inputTextField"
           title="Search" />
    <%=cm.writeEditTag("habitats_main_btnSearch")%>
    <a href="fuzzy-search-help.jsp" title="Help on fuzzy search feature">
      <img alt="Help" title="Help on fuzzy search" src="images/mini/help.jpg" border="0" align="middle" />
    </a>
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
        <a title="Show <%=tabs[i]%>" href="habitats.jsp?tab=<%=i%>"><%=tabs[i]%></a>
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
            <%=cm.getContent("habitats_main_easySearchesDesc") %>
          </span>
        </span>
<br />
<br />
<table summary="Easy searches" cellspacing="1" cellpadding="3"  width="100%" border="0" class="fontNormal">
<tr bgcolor="#EEEEEE">
  <th width="40%" style="white-space:nowrap">
    Links to easy searches
  </th>
  <th width="60%">
    Description
  </th>
</tr>
<tr bgcolor="#EEEEEE">
  <td width="40%" style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_names",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_namesDesc",false)%>" href="habitats-names.jsp"><strong><%=cm.getContent("habitats_main_names")%></strong></a>
  </td>
  <td width="60%">
    <%=cm.getContent("habitats_main_namesDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_legal",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_legalDesc",false)%>"  href="habitats-legal.jsp"><strong><%=cm.getContent("habitats_main_legal")%></strong></a>
  </td>
  <td>
    <%=cm.getContent("habitats_main_legalDesc")%>
  </td>
</tr>
<tr bgcolor="#EEEEEE">
  <td style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_country",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_countryDesc",false)%>"  href="habitats-country.jsp"><strong><%=cm.getContent("habitats_main_country")%></strong></a>
  </td>
  <td>
    <%=cm.getContent("habitats_main_countryDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_code",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_codeDesc",false)%>"  href="habitats-code.jsp"><strong><%=cm.getContent("habitats_main_code")%></strong></a>
  </td>
  <td>
    <%=cm.getContent("habitats_main_codeDesc")%>
  </td>
</tr>
<tr bgcolor="#EEEEEE">
  <td style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_showSpecies",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_showSpeciesDesc",false)%>"  href="species-habitats.jsp"><strong><%=cm.getContent("habitats_main_showSpecies")%></strong></a>
  </td>
  <td>
    <%=cm.getContent("habitats_main_showSpeciesDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_showSites",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_showSitesDesc",false)%>"  href="sites-habitats.jsp"><strong><%=cm.getContent("habitats_main_showSites")%></strong></a>
  </td>
  <td>
    <%=cm.getContent("habitats_main_showSitesDesc")%>
  </td>
</tr>
<tr bgcolor="#EEEEEE">
  <td style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_showReferences",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_showReferencesDesc",false)%>"  href="habitats-books.jsp"><strong><%=cm.getContent("habitats_main_showReferences")%></strong></a>
  </td>
  <td>
    <%=cm.getContent("habitats_main_showReferencesDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_showHabitats",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_showHabitatsDesc",false)%>"  href="habitats-references.jsp"><strong><%=cm.getContent("habitats_main_showHabitats")%></strong></a>
  </td>
  <td>
    <%=cm.getContent("habitats_main_showHabitatsDesc")%>
  </td>
</tr>
<tr bgcolor="#EEEEEE">
  <td style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_key",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_keyDesc",false)%>"  href="habitats-key.jsp"><strong><%=cm.getContent("habitats_main_key")%></strong></a>
  </td>
  <td>
    <%=cm.getContent("habitats_main_keyDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_EUNIShierarchy",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_EUNIShierarchyDesc",false)%>"  href="habitats-code-browser.jsp"><strong><%=cm.getContent("habitats_main_EUNIShierarchy")%></strong>
    </a>
  </td>
  <td>
    <%=cm.getContent("habitats_main_EUNIShierarchyDesc")%>
  </td>
</tr>
<tr bgcolor="#EEEEEE">
  <td style="white-space:nowrap">
    <img alt="<%=cm.getContent("habitats_main_ANNEXhierarchy",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <a title="<%=cm.getContent("habitats_main_ANNEXhierarchyDesc",false)%>"  href="habitats-annex1-browser.jsp"><strong><%=cm.getContent("habitats_main_ANNEXhierarchy")%></strong></a>
  </td>
  <td>
    <%=cm.getContent("habitats_main_ANNEXhierarchyDesc")%>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td style="white-space:nowrap">
    <img alt="Habitat type indicators" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
    <%=cm.getContent("habitats_main_indicators")%>
  </td>
  <td>
    <%=cm.getContent("habitats_main_indicatorsDesc")%>
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
      <%=cm.getContent("habitats_main_advSearchDesc") %>
    </span>
  </span>
  <br />
  <br />
  <table summary="Advanced searches" cellspacing="1" cellpadding="3" width="100%" border="0" class="fontNormal">
    <tr bgcolor="#EEEEEE">
      <th width="40%" style="white-space:nowrap">
        Links to advanced searches
      </th>
      <th width="60%">
        Description
      </th>
    </tr>
    <tr bgcolor="#EEEEEE">
      <td width="40%" style="white-space:nowrap">
        <img alt="" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
        <a title="<%=cm.getContent("habitats_main_advSearchSearchDesc",false)%>"  href="habitats-advanced.jsp?natureobject=Habitat"><strong>Advanced Search</strong></a>
      </td>
      <td width="60%">
        <%=cm.getContent("habitats_main_advSearchSearchDesc")%>
      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td style="white-space:nowrap">
        <img alt="<%=cm.getContent("habitats_main_advSearchHelp",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
        <a title="<%=cm.getContent("habitats_main_advSearchHelpDesc",false)%>"  href="advanced-help.jsp"><strong><%=cm.getContent("habitats_main_advSearchHelp")%></strong></a>
      </td>
      <td>
        <%=cm.getContent("habitats_main_advSearchHelpDesc")%>
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
      Habitats links and downloads
    </span>
  </span>
  <br />
  <br />
  <table summary="Links and downloads" cellspacing="1" cellpadding="3" width="100%" border="0">
    <tr>
      <th width="40%">
        Links to data downloads
      </th>
      <th width="60%">
        Description
      </th>
    </tr>
    <tr bgcolor="#EEEEEE">
      <td width="40%">
        <img alt="Links and Downloads" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
        <a title="Links and Downloads"  href="habitats-download.jsp"><strong>Links and Downloads</strong></a>
      </td>
      <td width="60%">
        Links and downloads
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
            <%=cm.getContent("habitats_main_helpDesc") %>
          </span>
        </span>
  <br />
  <br />
  <table summary="Help" cellspacing="1" cellpadding="3" width="100%" border="0" class="fontNormal">
    <tr bgcolor="#EEEEEE">
      <th width="40%" style="white-space:nowrap">
        Links to online help
      </th>
      <th width="60%">
        Description
      </th>
    </tr>
    <tr bgcolor="#EEEEEE">
      <td width="40%" style="white-space:nowrap">
        <img alt="<%=cm.getContent("habitats_main_easyHelp",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
        <a title="<%=cm.getContent("habitats_main_easyHelpDesc",false)%>"  href="easy-help.jsp"><strong><%=cm.getContent("habitats_main_easyHelp")%></strong></a>
      </td>
      <td width="60%">
        <%=cm.getContent("habitats_main_easyHelpDesc")%>
      </td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td style="white-space:nowrap">
        <img alt="<%=cm.getContent("habitats_main_glossary",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
        <a title="<%=cm.getContent("habitats_main_glossaryDesc",false)%>"  href="glossary.jsp?module=habitat"><strong><%=cm.getContent("habitats_main_glossary")%></strong></a>
      </td>
      <td>
        <%=cm.getContent("habitats_main_glossaryDesc")%>
      </td>
    </tr>
    <tr bgcolor="#EEEEEE">
      <td style="white-space:nowrap">
        <img alt="<%=cm.getContent("habitats_main_howTo",false)%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
        <a title="<%=cm.getContent("habitats_main_howToDesc",false)%>"  href="habitats-help.jsp"><strong><%=cm.getContent("habitats_main_howTo")%></strong></a>
      </td>
      <td>
        <%=cm.getContent("habitats_main_howToDesc")%>
      </td>
    </tr>
  </table>
<%
  }
%>
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
<noscript>Your browser does not support JavaScript!</noscript>
    </div>
  </body>
</html>