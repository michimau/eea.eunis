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
    <%
        WebContentManagement cm = SessionManager.getWebContent();
    %>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" src="script/species-country.js" type="text/javascript"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
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
              alert('<%=cm.cms("species_country_19")%>');
              document.eunis.submit();
        } else
        {
              alert('<%=cm.cms("species_country_20")%>');
              document.eunis.action = 'species-country.jsp';
              document.eunis.submit();

        }
        }
            <%
            }
            %>

   //-->
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
  <div id="outline">
  <div id="alignment">
  <div id="content">
  <jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,country_biogeographic_region_location"/>
  </jsp:include>
  <h1>
      <%=cm.cmsText("species_country_01")%>
  </h1>
  <table summary="layout" width="100%" border="0">
    <tr>
      <td>
      <form name="eunis" action="species-country-result.jsp" method="post">
        <%=cm.cmsText("species_country_18")%>
        <br />
        <br />
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td style="background-color:#EEEEEE">
              <strong><%=cm.cmsText("species_country_03")%></strong>
            </td>
          </tr>
          <tr>
            <td style="background-color:#EEEEEE">
              <input id="checkbox1" title="<%=cm.cms("species_country_04")%>" alt="<%=cm.cms("species_country_04")%>" type="checkbox" name="showGroup" value="true" disabled="disabled" checked="checked" />
                <label for="checkbox1"><%=cm.cmsText("species_country_04")%></label>
                <%=cm.cmsTitle("species_country_04")%>
              <input id="checkbox2" title="<%=cm.cms("species_country_07")%>" alt="<%=cm.cms("species_country_07")%>" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" />
                <label for="checkbox2"><%=cm.cmsText("species_country_07")%></label>
                <%=cm.cmsTitle("species_country_07")%>
              <input id="checkbox3" title="<%=cm.cms("species_country_08")%>" alt="<%=cm.cms("species_country_08")%>" type="checkbox" name="showVernacularNames" value="true" checked="checked" />
                <label for="checkbox3"><%=cm.cmsText("species_country_08")%></label>
                <%=cm.cmsTitle("species_country_08")%>
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
                  <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("species_country_20_Alt")%>" title="<%=cm.cms("species_country_20_Alt")%>" src="images/mini/field_mandatory.gif" />
                  <%=cm.cmsAlt("species_country_20_Alt")%>
                <%
                  if (null == country)
                  {// If country is null then display the country selection texbox
                %>
                  <label for="Country" class="noshow"><%=cm.cms("species_country_21_Label")%></label>
                  <select title="<%=cm.cms("species_country_21_Title")%>" name="Country" id="Country" <%=onChange%> class="inputTextField">
                    <option value="species-country.jsp">
                        <%=cm.cms("species_country_11")%>
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
                  <%=cm.cmsLabel("species_country_21_Label")%>
                  <%=cm.cmsTitle("species_country_21_Title")%>
                <%
                } else
                { // or else put out the selected country and let the user select the region.
                    if (anyCountrySelected)
                    {
                  %>
                    <strong><%=cm.cmsText("species_country_12")%></strong>
                    &nbsp;
                    <strong><%=cm.cmsText("species_country_13")%></strong>&nbsp;
                    <%=cm.cmsText("species_country_14")%>
                  <%
                  } else
                  {
                  %>
                    <strong><%=speciesCountryUtil.countryCode2Name(country)%></strong>&nbsp;<strong><%=cm.cmsText("species_country_13")%>
                    </strong>&nbsp;<%=cm.cmsText("species_country_14")%>
                  <%
                    }
                  %>
                  <label for="Region" class="noshow"><%=cm.cms("species_country_22_Label")%></label>
                  <select title="<%=cm.cms("species_country_22_Title")%>" name="Region" id="Region" <%=onChange%>  class="inputTextField">
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
                  <%=cm.cmsLabel("species_country_22_Label")%>
                  <%=cm.cmsTitle("species_country_22_Title")%>
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
                  <input id="saveCriteriaCheckbox" title="<%=cm.cms("species_country_23_Title")%>" alt="<%=cm.cms("species_country_23_Title")%>" type="checkbox" name="saveCriteria" value="true" <%=gr%> /><label for="saveCriteriaCheckbox"><%=cm.cmsText("species_country_10")%></label>
                  <%=cm.cmsTitle("species_country_23_Title")%>
                  &nbsp;
                  <a title="<%=cm.cms("species_country_23_Title")%>" href="javascript:checkSaveCriteria()"><img alt="<%=cm.cms("species_country_23_Alt")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("species_country_23_Title")%>
                  <%=cm.cmsAlt("species_country_23_Alt")%>
                </td>
              </tr>
              <tr><td>&nbsp;</td></tr>
            <%
              }
            %>
            <tr><td colspan="2" style="text-align:center"><strong><%=cm.cmsText("species_country_17")%></strong></td></tr>
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
<%=cm.cmsMsg("species_country_19")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_country_20")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_country_02")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_country_11")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_country_12")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_country_15")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_country_16")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-country.jsp" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>