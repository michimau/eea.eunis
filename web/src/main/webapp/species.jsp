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
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species";
%>

<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase( "Species database" ) %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
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
                <h1 class="documentFirstHeading">
                  <%=cm.cmsPhrase( "Species search" )%>
                </h1>
<!-- MAIN CONTENT -->

              <div class="documentDescription">
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

      <div class="eea-accordion-panels non-exclusive">

          <div class="eea-accordion-panel" style="clear: both;">
          <h2 class="notoc eea-icon-right-container">Easy search</h2>
          <div class="pane">
              <h4><%=cm.cmsPhrase("A set of predefined functions to search the database") %></h4>
              <table class="fullwidth">
              <colgroup>
                <col style="width: 310px; white-space: nowrap;">
                <col>
              </colgroup>
                <tbody>
                  <tr>
                    <td>
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-names.jsp" title="<%=cm.cmsPhrase("Search species by scientific name (in Latin) or by common name (popular name)")%>"><strong><%=cm.cmsPhrase("Names")%></strong></a>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Search species by scientific name (in Latin) or by common name (popular name)")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-groups.jsp" title="<%=cm.cmsPhrase("Species &amp; subspecies by Group (Invertebrates, Mammals etc.)")%>"><strong><%=cm.cmsPhrase("Groups")%></strong></a>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species &amp; subspecies by Group (Invertebrates, Mammals etc.)")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-legal.jsp"><strong><%=cm.cmsPhrase("Legal Instruments")%></strong></a>
                      <%=cm.cmsTitle("species_protected_by_legal_texts")%>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Species protected by legal texts at European level")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
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
          </div>
          </div>
          <div class="eea-accordion-panel" style="clear: both;">
          <h2 class="notoc eea-icon-right-container">Advanced search</h2>
          <div class="pane">
              <h4><%=cm.cmsPhrase("A flexible search tool to build your own query") %></h4>
              <table summary="layout" class="fullwidth">
                  <colgroup>
                      <col style="width: 310px; white-space: nowrap">
                      <col>
                  </colgroup>
                <tbody>
                  <tr>
                    <td>
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="species-advanced.jsp?natureobject=Species">
                          <strong><%=cm.cmsPhrase("Advanced Search")%></strong></a>
                    </td>
                    <td>
                        <%=cm.cmsPhrase("Search species information using more complex filtering capabilities")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                      <a href="advanced-help.jsp"><strong><%=cm.cmsPhrase("How to use Advanced search")%></strong></a>
                    </td>
                    <td>
                      <%=cm.cmsPhrase("Help on species <strong>Advanced Search</strong>")%>
                    </td>
                  </tr>
                </tbody>
              </table>
          </div>
          </div>
          <div class="eea-accordion-panel" style="clear: both;">
          <h2 class="notoc eea-icon-right-container">Statistical data</h2>
          <div class="pane">
              <h4><%=cm.cmsPhrase( "A search tool to build aggregated data" ) %></h4>
              <table summary="layout" class="fullwidth">
                  <colgroup>
                      <col style="width: 310px; white-space: nowrap">
                      <col>
                  </colgroup>
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
          </div>
          </div>
          <div class="eea-accordion-panel" style="clear: both;">
          <h2 class="notoc eea-icon-right-container">Help</h2>
          <div class="pane">
              <h4><%=cm.cmsPhrase( "General information on EUNIS application" ) %></h4>
              <table summary="layout" class="fullwidth">
                  <colgroup>
                      <col style="width: 310px; white-space: nowrap">
                      <col>
                  </colgroup>
                  <tbody>
                    <tr>
                      <td>
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="easy-help.jsp"><strong><%=cm.cmsPhrase("How to use Easy search")%></strong></a>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Help on species <strong>Easy Searches</strong>")%>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="http://biodiversity-chm.eea.europa.eu/search_html">
                            <strong><%=cm.cmsPhrase("Browse")%></strong></a>
                        <%=cm.cmsTitle("generic_information_tools_on_species")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Generic information tools on Species diversity")%>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <img src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" alt="" />
                        <a href="species-help.jsp"><strong><%=cm.cmsPhrase("How to use")%></strong></a>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Help on EUNIS Database species module search tools")%>
                      </td>
                    </tr>
                  </tbody>
                </table>

          </div>
          </div>
      </div>
    </stripes:layout-component>
</stripes:layout-render>
