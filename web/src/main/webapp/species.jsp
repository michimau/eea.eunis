<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species module' function - display links to all species searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.species.names.NameSortCriteria,
                ro.finsiel.eunis.search.AbstractSortCriteria" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>

<%
  WebContentManagement cm = SessionManager.getWebContent();
  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
  String []tabs = { cm.cmsPhrase("Easy search"), cm.cmsPhrase("Advanced search"), cm.cmsPhrase("Statistical data"), cm.cmsPhrase("Help") };
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species";
%>

<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase( "Species database" ) %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">

    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
    function popIndicators(URL)
    {
        //URL = "http://themes.eea.europa.eu/Environmental_issues/biodiversity/indicators/";
        eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=700,height=500,left=200,top=100')");
    }
    function validateQuickSearch()
    {
        if (trim(document.search.scientificName.value) == '' || trim(document.search.scientificName.value) == 'Enter species name here...' )
        {
            alert('<%=cm.cmsPhrase("Before searching, please type a few letters from species name.")%>');
            return false;
        }
        else return true;
    }
    //]]>
    </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">

              <a name="documentContent"></a>
              <img id="loading" alt="" title="<%=cm.cmsPhrase("Loading progress")%>" src="images/loading.gif" />
                <h1 class="documentFirstHeading">
                  <%=cm.cmsPhrase( "Species search" )%>
                </h1>
<!-- MAIN CONTENT -->

              <div class="documentDescription">
                 <!--%=cm.cmsPhrase( "species_main_description" )%-->
                 <%=cm.cmsPhrase( "Access information about species of interest for biodiversity and nature protection" )%>
              </div>

              <div id="qs" style="padding-left : 10px; width : 90%; vertical-align : middle;text-align:center">
                <form name="search" action="species-names-result.jsp" method="get" onsubmit="return validateQuickSearch(); ">
                  <input type="hidden" name="comeFromQuickSearch" value="true" />
                  <input type="hidden" name="showGroup" value="true" />
                  <input type="hidden" name="showOrder" value="true" />
                  <input type="hidden" name="showFamily" value="true" />
                  <input type="hidden" name="showScientificName" value="true" />
                  <input type="hidden" name="showVernacularNames" value="true" />
                  <input type="hidden" name="showValidName" value="true" />
                  <input type="hidden" name="showOtherInfo" value="true" />
                  <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_STARTS%>" />
                  <input type="hidden" name="searchVernacular" value="true" />
                  <input type="hidden" name="searchSynonyms" value="true" />
                  <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>" />
                  <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
                  <label for="scientificName"><%=cm.cmsPhrase("Search species with names starting with:")%></label>
                  <input size="32"
                         id="scientificName"
                         name="scientificName"
                         value="<%=cm.cmsPhrase("Enter species name here...")%>"
                         onfocus="if(this.value=='<%=cm.cmsPhrase("Enter species name here...")%>')this.value='';"
                         onblur="if(this.value=='')this.value='<%=cm.cmsPhrase("Enter species name here...")%>';" />
                  <input id="search" type="submit"
                         value="<%=cm.cmsPhrase("Search")%>"
                         name="Submit"
                         class="submitSearchButton"
                         title="<%=cm.cmsPhrase("Execute search")%>"
                         />
                  <a href="fuzzy-search-help.jsp" title="<%=cm.cmsPhrase("Help on fuzzy search")%>"><img src="images/mini/help.jpg" border="0" style="vertical-align:middle;" alt="" /></a>
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
                <li<%=currentTab%>><a href="species.jsp?tab=<%=i%>"><%=tabs[ i ]%></a></li>
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
              <table class="datatable fullwidth">
                <caption>
                  <%=cm.cmsPhrase("A set of predefined functions to search the database") %>
                </caption>
                <thead>
                  <tr>
                    <th width="40%" style="white-space: nowrap">
                      <%=cm.cmsPhrase("Links to easy searches")%>
                    </th>
                    <th width="60%">
                      <%=cm.cmsPhrase("Description")%>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-names.jsp" title="<%=cm.cmsPhrase("Search species by scientific name (in Latin) or by vernacular name (popular name)")%>"><strong><%=cm.cmsPhrase("Names")%></strong></a>
                    </td>
                    <td width="60%">
                      <%=cm.cmsPhrase("Search species by scientific name (in Latin) or by vernacular name (popular name)")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-groups.jsp" title="<%=cm.cmsPhrase("Species &amp; subspecies by Group (Invertebrates, Mammals etc.)")%>"><strong><%=cm.cmsPhrase("Groups")%></strong></a>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species &amp; subspecies by Group (Invertebrates, Mammals etc.)")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-synonyms.jsp" title="<%=cm.cmsPhrase("Identify synonym names for species")%>"><strong><%=cm.cmsPhrase("Synonyms")%></strong></a>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Identify synonym names for species")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-country.jsp"><strong><%=cm.cmsPhrase("Country/Biogeographic region")%></strong></a>
                      <%=cm.cmsTitle("find_species_located_in_country_region")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find species located within a country and/or a biogeographic region")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-threat-international.jsp"><strong><%=cm.cmsPhrase("International Threat Status")%></strong></a>
                      <%=cm.cmsTitle("species_threatened_at_international_level")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species threatened at international level")%>
                    </td>
                  </tr>
<!--
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-threat-national.jsp"><strong><%=cm.cmsPhrase("National threat status")%></strong></a>
                      <%=cm.cmsTitle("species_threatened_at_country_level")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species threatened at country level")%>
                    </td>
                  </tr>
-->
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-legal.jsp"><strong><%=cm.cmsPhrase("Legal Instruments")%></strong></a>
                      <%=cm.cmsTitle("species_protected_by_legal_texts")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species protected by legal texts at European level")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="habitats-species.jsp?expandare=no&amp;showCode=on&amp;showLevel=on&amp;showVernacularName=on">
                          <strong><%=cm.cmsPhrase("Pick species, show habitat types")%></strong></a>
                      <%=cm.cmsTitle("find_habitat_types_characterized_by_species")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find habitat types characterised by a particular species")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="sites-species.jsp"><strong><%=cm.cmsPhrase("Pick species, show sites")%></strong></a>
                      <%=cm.cmsTitle("find_sites_types_characterized_by_species")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find sites characterized by a particular species")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-books.jsp"><strong><%=cm.cmsPhrase("Pick species, show references")%></strong></a>
                      <%=cm.cmsTitle("find_books_articles")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find books, articles which refers to species")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-references.jsp"><strong><%=cm.cmsPhrase("Pick references, show species")%></strong></a>
                      <%=cm.cmsTitle("fins_species_reffered_by_books")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find species referred by books, articles etc.")%>
                    </td>
                  </tr>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-taxonomic-browser.jsp"><strong><%=cm.cmsPhrase("Taxonomic classification")%></strong></a>
                      <%=cm.cmsTitle("taxonomic_classification_for_species")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Taxonomic classification for species")%>
                    </td>
                  </tr>
                </tbody>
              </table>
          <%
            }
            if ( tab == 1 )
            {
          %>
              <table summary="layout" class="datatable fullwidth">
                <caption>
                  <%=cm.cmsPhrase("A flexible search tool to build your own query") %>
                </caption>
                <thead>
                  <tr>
                    <th width="40%" style="white-space: nowrap">
                      <%=cm.cmsPhrase("Description")%>
                    </th>
                    <th width="60%">
                      <%=cm.cmsPhrase("Description")%>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-advanced.jsp?natureobject=Species">
                          <strong><%=cm.cmsPhrase("Advanced Search")%></strong></a>
                    </td>
                    <td>
                        <%=cm.cmsPhrase("Search species information using more complex filtering capabilities")%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td style="white-space: nowrap">
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="advanced-help.jsp"><strong><%=cm.cmsPhrase("How to use Advanced search")%></strong></a>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Help on species <strong>Advanced Search</strong>")%>
                    </td>
                  </tr>
                </tbody>
              </table>
          <%
            }

            if ( tab == 2 )
            {
          %>
              <table class="datatable fullwidth">
                <caption>
                  <%=cm.cmsPhrase( "A search tool to build aggregated data" ) %>
                </caption>
                <thead>
                  <tr>
                    <th>
                      <%=cm.cmsPhrase("Links to statistical data")%>
                    </th>
                    <th>
                      <%=cm.cmsPhrase("Description")%>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                      <a href="species-statistics-module.jsp">
                        <strong>
                          <%=cm.cmsPhrase("Statistical data")%>
                        </strong>
                      </a>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Find statistical data about species")%>
                    </td>
                  </tr>
                </tbody>
              </table>
          <%
            }
            if ( tab == 3 )
            {
          %>
                <table class="datatable fullwidth">
                  <caption>
                    <%=cm.cmsPhrase("General information on EUNIS application") %>
                  </caption>
                  <thead>
                    <tr>
                      <th width="40%" style="white-space: nowrap">
                        <%=cm.cmsPhrase("Links to online help")%>
                      </th>
                      <th width="60%">
                        <%=cm.cmsPhrase("Description")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="easy-help.jsp"><strong><%=cm.cmsPhrase("How to use Easy search")%></strong></a>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Help on species <strong>Easy Searches</strong>")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="glossary.jsp?module=species"><strong><%=cm.cmsPhrase("Glossary")%></strong></a>
                        <%=cm.cmsTitle("species_main_glossary_Title")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Glossary of the terms used in EUNIS Database species module")%>
                      </td>
                    </tr>
                    <tr>
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="http://biodiversity-chm.eea.europa.eu/search_html">
                            <strong><%=cm.cmsPhrase("Browse")%></strong></a>
                        <%=cm.cmsTitle("generic_information_tools_on_species")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Generic information tools on Species diversity")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space: nowrap">
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="species-help.jsp"><strong><%=cm.cmsPhrase("How to use")%></strong></a>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Help on EUNIS Database species module search tools")%>
                      </td>
                    </tr>
                  </tbody>
                </table>
          <%
            }
          %>

          <%=cm.br()%>
          <%=cm.cmsMsg("easy_search")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("advanced_search")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("statistical_data")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("links_and_downloads")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("help")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("species_main_01_Msg")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("species_main_title")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("easy_searches")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("advanced_searches")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("statistical_data")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("links_and_downloads")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("help")%>
          <%=cm.br()%>
                <script language="javascript" type="text/javascript">
                //<![CDATA[
                try
                {
                    var ctrl_loading = document.getElementById("loading");
                    ctrl_loading.style.display = "none";
                }
                catch (e)
                {
                }
                //]]>
                </script>
    </stripes:layout-component>
</stripes:layout-render>
