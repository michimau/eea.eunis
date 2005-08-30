<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species module' function - display links to all species searches.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.species.names.NameSortCriteria,
                ro.finsiel.eunis.search.AbstractSortCriteria" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
  String []tabs = { "Easy search", "Advanced search", "Statistical data", "Links &amp; Downloads", "Help" };
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/tabs/listener.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/tabs/tabs.js"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
    function popIndicators(URL)
    {
        //URL = "http://themes.eea.eu.int/Environmental_issues/biodiversity/indicators/";
        eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=700,height=500,left=200,top=100')");
    }
    function validateQuickSearch()
    {
        if (trim(document.search.scientificName.value) == '' || trim(document.search.scientificName.value) == 'Enter species name here...' )
        {
            alert('Before searching, please type a few letters from species name.');
            return false;
        }
        else return true;
    }
    //-->
    </script>
    <title>
        <%=application.getInitParameter("PAGE_TITLE")%>
        <%=cm.getContent("species_main_title", false)%>
    </title>
</head>

<body>
<div id="content">
<jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="Home#index.jsp,Species"/>
</jsp:include>
<img id="loading" alt="Loading progress" title="Loading progress" src="images/loading.gif" />
    <div style="text-align : center; width : 740px;">
      <h5>
        <%=cm.getContent( "species_main_speciesSearch" )%>
      </h5>
      <h6>
       <%=cm.getContent( "species_main_description" )%>
      </h6>
    </div>
<br />
<div id="qs" style="padding-left : 10px; width : 740px; vertical-align : middle;text-align:center">
    <form name="search" action="species-names-result.jsp" method="get" onsubmit="return validateQuickSearch(); ">
        <input type="hidden" name="showGroup" value="true" />
        <input type="hidden" name="showOrder" value="true" />
        <input type="hidden" name="showFamily" value="true" />
        <input type="hidden" name="showScientificName" value="true" />
        <input type="hidden" name="showVernacularNames" value="true" />
        <input type="hidden" name="showValidName" value="true" />
        <input type="hidden" name="showOtherInfo" value="true" />
        <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_STARTS%>" />
        <input type="hidden" name="searchVernacular" value="true" />
        <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>"/>
        <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>"/>
        <label for="scientificName"><%=cm.getContent("quick_search_species_01")%></label>
        <input size="32"
               id="scientificName"
               name="scientificName"
               value="Enter species name here..."
               class="inputTextField"
               alt="Quick search Species by name"
               title="Quick search Species by name"
               onfocus="javascript:document.search.scientificName.select();" />
        <label for="search" class="noshow">Quick search</label>
        <input id="search" type="submit"
               value="<%=cm.getContent( "species_main_btnSearch", false )%>"
               name="Submit"
               class="inputTextField"
               alt="Execute search" title="Execute search"
               />
        <%=cm.writeEditTag("species_main_btnSearch")%>
        <a href="fuzzy-search-help.jsp" title="Help on fuzzy search"><img src="images/mini/help.jpg" border="0" style="vertical-align:middle;" alt="Help on fuzzy search feature" /></a>
    </form>
</div>
<br />
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
        <a title="<%=tabs[ i ]%>" href="species.jsp?tab=<%=i%>"><%=tabs[ i ]%></a>
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
        <%=cm.getContent("species_main_easySearchesDesc") %>
      </span>
</span>
<br />
<br />
<table summary="Easy searches" cellspacing="1" cellpadding="3" width="100%" border="0" class="fontNormal">
<tr style="background-color:#EEEEEE">
  <th width="40%" style="white-space: nowrap">
    Links to easy searches
  </th>
  <th width="60%">
    Description
  </th>
</tr>
<tr style="background-color:#EEEEEE">
    <td width="40%" style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="species-names.jsp" title="<%=cm.getContent("species_main_namesDesc",false)%>"><strong><%=cm.getContent("species_main_names")%></strong></a>
    </td>
    <td width="60%">
        <%=cm.getContent("species_main_namesDesc")%>
    </td>
</tr>
<tr style="background-color:#FFFFFF">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="species-groups.jsp" title="<%=cm.getContent("species_main_groupsDesc",false)%>"><strong><%=cm.getContent("species_main_groups")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_groupsDesc")%>
    </td>
</tr>
<tr style="background-color:#EEEEEE">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="species-synonyms.jsp" title="<%=cm.getContent("species_main_synonymsDesc",false)%>"><strong><%=cm.getContent("species_main_synonyms")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_synonymsDesc")%>
    </td>
</tr>
<tr style="background-color:#FFFFFF">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="species-country.jsp" title="<%=cm.getContent("species_main_countryDesc",false)%>"><strong><%=cm.getContent("species_main_country")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_countryDesc")%>
    </td>
</tr>
<tr style="background-color:#EEEEEE">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="species-threat-international.jsp" title="<%=cm.getContent("species_main_internationalDesc",false)%>"><strong><%=cm.getContent("species_main_international")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_internationalDesc")%>
    </td>
</tr>
<tr style="background-color:#FFFFFF">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="species-threat-national.jsp" title="<%=cm.getContent("species_main_nationalDesc",false)%>"><strong><%=cm.getContent("species_main_national")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_nationalDesc")%>
    </td>
</tr>
<tr style="background-color:#EEEEEE">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="species-legal.jsp" title="<%=cm.getContent("species_main_legalDesc",false)%>"><strong><%=cm.getContent("species_main_legal")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_legalDesc")%>
    </td>
</tr>
<tr style="background-color:#FFFFFF">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="habitats-species.jsp?expandare=no&amp;showCode=on&amp;showLevel=on&amp;showVernacularName=on" title="<%=cm.getContent("species_main_showHabDesc",false)%>">
            <strong><%=cm.getContent("species_main_showHab")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_showHabDesc")%>
    </td>
</tr>
<tr style="background-color:#EEEEEE">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="sites-species.jsp" title="<%=cm.getContent("species_main_showSitesDesc",false)%>"><strong><%=cm.getContent("species_main_showSites")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_showSitesDesc")%>
    </td>
</tr>
<tr style="background-color:#FFFFFF">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="species-books.jsp" title="<%=cm.getContent("species_main_showReferencesDesc",false)%>"><strong><%=cm.getContent("species_main_showReferences")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_showReferencesDesc")%>
    </td>
</tr>
<tr style="background-color:#EEEEEE">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="species-references.jsp" title="<%=cm.getContent("species_main_ReferencesDesc",false)%>"><strong><%=cm.getContent("species_main_References")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_ReferencesDesc")%>
    </td>
</tr>
<tr style="background-color:#FFFFFF">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <a href="species-taxonomic-browser.jsp" title="<%=cm.getContent("species_main_taxonomyDesc",false)%>"><strong><%=cm.getContent("species_main_taxonomy")%></strong></a>
    </td>
    <td>
        <%=cm.getContent("species_main_taxonomyDesc")%>
    </td>
</tr>
<tr style="background-color:#EEEEEE">
    <td style="white-space: nowrap">
        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
        <%=cm.getContent("species_main_indicators")%>
    </td>
    <td>
        <%=cm.getContent("species_main_indicatorsDesc")%>
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
            <%=cm.getContent("species_main_advSearchDesc") %>
          </span>
        </span>
    <br />
    <br />
    <table summary="Advanced searches" cellspacing="1" cellpadding="3" width="100%" border="0" class="fontNormal">
    <tr style="background-color:#EEEEEE">
      <th width="40%" style="white-space: nowrap">
        Links to advanced searches
      </th>
      <th width="60%">
        Description
      </th>
    </tr>
        <tr style="background-color:#EEEEEE">
            <td width="40%" style="white-space: nowrap">
                <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                <a href="species-advanced.jsp?natureobject=Species" title="<%=cm.getContent("species_main_advSearchSearchDesc",false)%>">
                    <strong><%=cm.getContent("species_main_advSearch")%></strong></a></td>
            <td width="60%">
                <%=cm.getContent("species_main_advSearchSearchDesc")%>
            </td>
        </tr>
        <tr style="background-color:#FFFFFF">
            <td style="white-space: nowrap">
                <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                <a href="advanced-help.jsp" title="<%=cm.getContent("species_main_advSearchHelpDesc",false)%>"><strong><%=cm.getContent("species_main_advSearchHelp")%></strong></a></td>
            <td>
                <%=cm.getContent("species_main_advSearchHelpDesc")%>
            </td>
        </tr>
    </table>
<%
  }

  if ( tab == 2 )
  {
%>
          <table cellspacing="1" cellpadding="3" width="100%" border="0" summary="Statistical data">
            <caption><%=cm.getContent( "species_main_statisticDesc" ) %></caption>
            <tr>
              <th>
                Links to statistical data
              </th>
              <th>
                Description
              </th>
            </tr>
            <tr>
              <td class="grey_cell">
                <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
                <a title="<%=cm.getContent("species_main_numberDesc", false )%>" href="species-statistics-module.jsp">
                  <strong>
                    <%=cm.getContent("species_main_number")%>
                  </strong>
                </a>
              </td>
              <td class="grey_cell">
                <%=cm.getContent("species_main_numberDesc")%>
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
            Species links and downloads
          </span>
        </span>
    <br />
    <br />
    <table summary="Links &amp; Downloads" cellspacing="1" cellpadding="3" width="100%" border="0" class="fontNormal">
     <tr style="background-color:#EEEEEE">
     <th width="40%">
       Links to data downloads
     </th>
     <th width="60%">
       Description
     </th>
     </tr>
        <tr style="background-color:#EEEEEE">
            <td width="40%">
                <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                <a href="species-download.jsp" title="Links and downloads"><strong>Links and Downloads</strong></a>
            </td>
            <td width="60%">
                Links and downloads
            </td>
        </tr>
    </table>
<%
  }
  if ( tab == 4 )
  {
%>
    <span style="text-align : center; width : 640px;">
          <span class="fontNormal">
            <%=cm.getContent("species_main_helpDesc") %>
          </span>
        </span>
    <br />
    <br />
    <table summary="Help" cellspacing="1" cellpadding="3" width="100%" border="0" class="fontNormal">
     <tr style="background-color:#EEEEEE">
      <th width="40%" style="white-space: nowrap">
        Links to online help
      </th>
      <th width="60%">
        Description
      </th>
    </tr>
        <tr style="background-color:#EEEEEE">
            <td width="30%" style="white-space: nowrap">
                <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                <a href="easy-help.jsp" title="<%=cm.getContent("species_main_easyHelpDesc",false)%>"><strong><%=cm.getContent("species_main_easyHelp")%></strong></a>
            </td>
            <td width="60%">
                <%=cm.getContent("species_main_easyHelpDesc")%>
            </td>
        </tr>
        <tr style="background-color:#FFFFFF">
            <td style="white-space: nowrap">
                <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                <a href="glossary.jsp?module=species" title="<%=cm.getContent("species_main_glossaryDesc",false)%>"><strong><%=cm.getContent("species_main_glossary")%></strong></a>
            </td>
            <td>
                <%=cm.getContent("species_main_glossaryDesc")%>
            </td>
        </tr>
        <tr style="background-color:#EEEEEE">
            <td style="white-space: nowrap">
                <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                <a href="http://biodiversity-chm.eea.eu.int/search.html" title="<%=cm.getContent("species_main_browseDesc",false)%>">
                    <strong><%=cm.getContent("species_main_browse")%></strong></a>
            </td>
            <td>
                <%=cm.getContent("species_main_browseDesc")%>
            </td>
        </tr>
        <tr style="background-color:#FFFFFF">
            <td style="white-space: nowrap">
                <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                <a href="species-help.jsp" title="<%=cm.getContent("species_main_howToDesc",false)%>"><strong><%=cm.getContent("species_main_howTo")%></strong></a>
            </td>
            <td>
                <%=cm.getContent("species_main_howToDesc")%>
            </td>
        </tr>
    </table>
<%
  }
%>
<jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="species.jsp"/>
</jsp:include>
<script language="javascript" type="text/javascript">
<!--
try
{
    var ctrl_loading = document.getElementById("loading");
    ctrl_loading.style.display = "none";
}
catch (e)
{
}
//-->
</script>
<noscript>Your browser does not support JavaScript!</noscript>
</div>
</body>
</html>