<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species country' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.CountryUtil,
                 java.util.Iterator,
                 ro.finsiel.eunis.search.species.country.RegionWrapper,
                 ro.finsiel.eunis.search.species.country.CountryWrapper,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement cm = SessionManager.getWebContent();
      String eeaHome = application.getInitParameter( "EEA_HOME" );
      String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,country_biogeographic_region_location";
    %>
    <script language="JavaScript" src="script/species-country.js" type="text/javascript"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
        function onLoadFunction() {
            <%
              if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
              {
            %>
                 document.eunis.saveCriteria.style.display = 'none';
            <%
              }
            %>

        document.eunis.action = 'species-country-result.jsp';
     }

     <%
              if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
              {
      %>
        function checkSaveCriteria() {
        <%
           if(request.getParameter("country") != null)
           {
        %>
        var country = '<%=request.getParameter("country")%>';
        <%
           } else
           {
        %>
        var country = null;
        <%
           }
           if(request.getParameter("countryName") != null)
           {
        %>
        var countryName = '<%=request.getParameter("countryName")%>';
        <%
           } else
           {
        %>
        var countryName = null;
        <%
           }
        %>
        if(country != null && countryName != null)
        {
              var c = document.createElement("input");
              c.type= "hidden";
              c.name = "country";
              c.value = country;
              document.eunis.appendChild( c );

              var cn = document.createElement("input");
              cn.type= "hidden";
              cn.name = "countryName";
              cn.value = countryName;
              document.eunis.appendChild( cn );

              document.eunis.saveCriteria.checked=true;
              document.eunis.action = 'species-country.jsp';
              alert('<%=cm.cms("save_alert")%>');
              document.eunis.submit();
        } else
        {
              alert('<%=cm.cms("please_select_a_country")%>');
              document.eunis.action = 'species-country.jsp';
              document.eunis.submit();

        }
        }
            <%
            }
            %>

   //]]>
    </script>
    <title><%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_country_02")%>
    </title>
  </head>
<%
  // REQUEST PARAMETER(S) (not necessarily required)
  // country - Country where we do the search
  // countryName - The name of the country...
  CountryUtil speciesCountryUtil = new CountryUtil();
  String country = request.getParameter("country");
  String countryName = request.getParameter("countryName");
  final boolean anyCountrySelected = (null != country) ? country.equalsIgnoreCase("any") : false;

  String gr =((request.getParameter("saveCriteria")==null?"false":request.getParameter("saveCriteria")).equalsIgnoreCase("true")?"checked=\"checked\"":"");
  String onChange = (SessionManager.getUsername()!=null?"onchange=\"MM_jumpMenuCountry('parent',this,0)\"":"onchange=\"MM_jumpMenu('parent',this,0)\"");
%>
  <body onload="onLoadFunction()">
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <h1>
                    <%=cm.cmsPhrase("Country / Biogeographic region")%>
                </h1>
                <table summary="layout" width="100%" border="0">
                  <tr>
                    <td>
                    <form name="eunis" action="species-country-result.jsp" method="post">
                      <%=cm.cmsPhrase("Species present in a country and a biogeographic region<br/>(ex.: search for species present within <strong>continental</strong> biogeographic region of <strong>Denmark</strong>)")%>
                      <br />
                      <br />
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td style="background-color:#EEEEEE">
                            <strong><%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%></strong>
                          </td>
                        </tr>
                        <tr>
                          <td style="background-color:#EEEEEE">
                            <input id="checkbox1" title="<%=cm.cms("group")%>" alt="<%=cm.cms("group")%>" type="checkbox" name="showGroup" value="true" disabled="disabled" checked="checked" />
                              <label for="checkbox1"><%=cm.cmsPhrase("Group")%></label>
                              <%=cm.cmsTitle("group")%>
                            <input id="checkbox2" title="<%=cm.cms("scientific_name")%>" alt="<%=cm.cms("scientific_name")%>" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" />
                              <label for="checkbox2"><%=cm.cmsPhrase("Scientific name")%></label>
                              <%=cm.cmsTitle("scientific_name")%>
                            <input id="checkbox3" title="<%=cm.cms("vernacular_names")%>" alt="<%=cm.cms("vernacular_names")%>" type="checkbox" name="showVernacularNames" value="true" checked="checked" />
                              <label for="checkbox3"><%=cm.cmsPhrase("Vernacular names")%></label>
                              <%=cm.cmsTitle("vernacular_names")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <br />
                          </td>
                        </tr>
                      </table>
                        <table summary="layout" cellspacing="0" cellpadding="0" border="0" width="100%" style="text-align:left;">
                          <tr>
                            <td style="vertical-align:middle">
                                <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" />
                                <%=cm.cmsAlt("field_mandatory")%>
                              <%
                                if (null == country)
                                {// If country is null then display the country selection texbox
                              %>
                                <label for="Country" class="noshow"><%=cm.cms("country")%></label>
                                <select title="<%=cm.cms("country")%>" name="Country" id="Country" <%=onChange%>>
                                  <option value="species-country.jsp">
                                      <%=cm.cms("please_select_a_country")%>
                                  </option>
                                  <option value="species-country.jsp?country=any&amp;countryName=any">
                                      <%=cm.cms("species_country_12")%>
                                  </option><%// *Any* country%>
                                  <%
                                    // Fill in the countries
                                  Iterator countriesIt = speciesCountryUtil.findCountriesForRegion("any");
                                  CountryWrapper aCountry = null;
                                  while (countriesIt.hasNext())
                                  {
                                    aCountry = (CountryWrapper)countriesIt.next();
                                    if(!aCountry.getName().equalsIgnoreCase("Europe") && !aCountry.getName().equalsIgnoreCase("World"))
                                    {
                                  %>
                                    <option value="species-country.jsp?country=<%=aCountry.getCode()%>&amp;countryName=<%=aCountry.getName()%>">
                                        <%=aCountry.getName()%>
                                    </option><%// *A* country %>
                                  <%
                                    }
                                  }
                                  %>
                                </select>
                                <%=cm.cmsLabel("country")%>
                                <%=cm.cmsTitle("country")%>
                              <%
                              } else
                              { // or else put out the selected country and let the user select the region.
                                  if (anyCountrySelected)
                                  {
                                %>
                                  <strong><%=cm.cmsPhrase("Any country")%></strong>
                                  &nbsp;
                                  <strong><%=cm.cmsPhrase("and")%></strong>&nbsp;
                                  <%=cm.cmsPhrase("Country / Biogeographic region")%>
                                <%
                                } else
                                {
                                %>
                                  <strong><%=speciesCountryUtil.countryCode2Name(country)%></strong>&nbsp;<strong><%=cm.cmsPhrase("and")%>
                                  </strong>&nbsp;<%=cm.cmsPhrase("Biogeographic region")%>
                                <%
                                  }
                                %>
                                <label for="Region" class="noshow"><%=cm.cms("region")%></label>
                                <select title="<%=cm.cms("region")%>" name="Region" id="Region" <%=onChange%>>
                                  <option value="species-country.jsp?country=<%=country%>&amp;countryName=<%=countryName%>" selected="selected">
                                      <%=cm.cms("species_country_15")%>
                                  </option>
                                  <%
                                    // If user selected 'any' country do not let it select also 'any' region
                                    if (!anyCountrySelected)
                                    {
                                      // *A* COUNTRY AND *ANY* BIOGEOREGION
                                    %>
                                    <option value="species-country-result.jsp?country=<%=speciesCountryUtil.findCountryIdGeoscope((Object)country)%>&amp;countryName=<%=countryName%>&amp;region=any&amp;regionName=any">
                                        <%=cm.cms("species_country_16")%>
                                    </option>
                                  <%
                                    }
                                    // Fill in the regions
                                  Iterator regionsIt = speciesCountryUtil.findRegionsFromCountry(country);
                                  RegionWrapper aRegion = null;
                                  while (regionsIt.hasNext())
                                  {
                                    aRegion = (RegionWrapper)regionsIt.next();
                                    if(!aRegion.getName().equalsIgnoreCase("Biogeographic region not detailled in original data set")) {
                                      if (anyCountrySelected)
                                      {
                                        // *ANY* COUNTRY AND *A* BIOGEOREGION
                                      %>
                                      <option value="species-country-result.jsp?countryName=<%=countryName%>&amp;country=<%=speciesCountryUtil.findCountryIdGeoscope((Object)country)%>&amp;regionName=<%=aRegion.getName()%>&amp;region=<%=speciesCountryUtil.findRegionIdGeoscope(aRegion.getName())%>">
                                          <%=aRegion.getName()%>
                                      </option>
                                    <%
                                    } else
                                    {
                                        // *A* COUNTRY AND *A* REGION
                                      %>
                                      <option value="species-country-result.jsp?countryName=<%=countryName%>&amp;country=<%=speciesCountryUtil.findCountryIdGeoscope((Object)country)%>&amp;regionName=<%=aRegion.getName()%>&amp;region=<%=speciesCountryUtil.findRegionIdGeoscope(aRegion.getName())%>">
                                          <%=aRegion.getName()%>
                                      </option>
                                    <%
                                      }
                                    }
                                  }
                                  %>
                                </select>
                                <%=cm.cmsLabel("region")%>
                                <%=cm.cmsTitle("region")%>
                              <%
                                }
                              %>
                            </td>
                          </tr>
                          <tr><td>&nbsp;</td></tr>
                          <%
                            if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
                            {
                          %>
                            <tr>
                              <td>
                                <input id="saveCriteriaCheckbox" title="<%=cm.cms("save_criteria")%>" alt="<%=cm.cms("save_criteria")%>" type="checkbox" name="saveCriteria" value="true" <%=gr%> /><label for="saveCriteriaCheckbox"><%=cm.cmsPhrase("Save your criteria:")%></label>
                                <%=cm.cmsTitle("save_criteria")%>
                                <a title="<%=cm.cms("save_criteria")%>" href="javascript:checkSaveCriteria()"><img alt="<%=cm.cms("save")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                                <%=cm.cmsTitle("save_criteria")%>
                                <%=cm.cmsAlt("save")%>
                              </td>
                            </tr>
                            <tr><td>&nbsp;</td></tr>
                          <%
                            }
                          %>
                          <tr><td colspan="2" style="text-align:center"><strong><%=cm.cmsPhrase("Disclaimer: Databases does not contain data for all countries")%></strong></td></tr>
                        </table>
                    </form>
                    </td>
                  </tr>
                        <%
                          // Expand saved searches list for this jsp page
                          if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
                          {
                            // Set Vector for URL string
                            Vector show = new Vector();
                            show.addElement("showGroup");
//              show.addElement("showFamily");
//              show.addElement("showOrder");
                            show.addElement("showScientificName");
                            show.addElement("showVernacularNames");
                            String pageName = "species-country.jsp";
                            String pageNameResult = "species-country-result.jsp?"+Utilities.writeURLCriteriaSave(show) + "&amp;expand=true";
                            // Expand or not save criterias list
                            String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
                        %>
                       <tr><td>
                       <jsp:include page="show-criteria-search.jsp">
                         <jsp:param name="pageName" value="<%=pageName%>" />
                         <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                         <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                       </jsp:include>
                       </td></tr>
                      <%
                        }
                      %>
                  </table>

              <%=cm.br()%>
              <%=cm.cmsMsg("save_alert")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("please_select_a_country")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("species_country_02")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("please_select_a_country")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("species_country_12")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("species_country_15")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("species_country_16")%>
              <%=cm.br()%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="species-country.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
