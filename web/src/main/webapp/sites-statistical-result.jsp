<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Number/Total area" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.sites.statistics.CountrySitesFactsheetDomain,
                 ro.finsiel.eunis.jrfTables.sites.statistics.CountrySitesFactsheetPersist,
                 ro.finsiel.eunis.search.CountryUtil,
                 ro.finsiel.eunis.search.species.country.RegionWrapper"%>
<%@ page import="ro.finsiel.eunis.jrfTables.*" %>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="ro.finsiel.eunis.utilities.TableColumns"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.statistics.StatisticsBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String countryName = request.getParameter("country");
  Chm62edtCountryPersist country = CountryUtil.findCountry(countryName);
  StringBuffer sbCCodes = new StringBuffer();
  if(null != country)
  {
    if (!(country.getIso2l()==null ||
            country.getIso2l().equals("")) && country.getSelection().intValue() != 0)
    {
      sbCCodes.append((country.getIso2Wcmc()==null)?country.getIso2l():country.getIso2Wcmc());
    }
  }
  String showDesignations = (request.getParameter("showDesignations")==null ? "false" : request.getParameter("showDesignations"));
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,statistical_data#sites-statistical.jsp,results";
  if (country == null )
  {
%>
      <jsp:forward page="emptyresults.jsp">
        <jsp:param name="location" value="<%=location%>" />
      </jsp:forward>
<%
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-statistical.js"></script>
    <script language="JavaScript" src="script/sortable.js" type="text/javascript"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cmsPhrase("Statistical information for")%>
      <%=country.getAreaNameEnglish()%>
    </title>
  </head>
  <body>
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
                  <jsp:param name="location" value="<%=location%>"/>
                  <jsp:param name="mapLink" value="show"/>
                </jsp:include>
                <a name="documentContent"></a>
                <img id="loading" alt="Loading" title="Loading" src="images/loading.gif" />
                <h1>
                <%=cm.cmsPhrase("Statistical information for from:")%>
                  <%=formBean.toHumanString()%>
                </h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cmsPhrase("Print this page")%>"
                            title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cmsPhrase("Toggle full screen mode")%>"
                             title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
<div class="figure-right">
    <div class="figure">
	<img src="<%=application.getInitParameter("EEA_MAP_SERVER")%>/getmap.asp?Q=<%=sbCCodes.toString().toUpperCase()%>&amp;outline=1" alt="<%=cm.cmsPhrase("Map image. Provided by EEA")%>" title="<%=cm.cmsPhrase("Map image. Provided by EEA")%>" width="250" height="217" class="scaled"/>
    </div>
</div>

                
                <%=cm.cmsTitle("map_image_eea")%>
                <%=cm.cmsAlt("map_image_eea")%>
                <h2>
                  <%=cm.cmsPhrase("Country information")%>
                </h2>
                <table class="datatable">
                  <col style="width:25%"/>
                  <col style="width:25%"/>
                  <col style="width:25%"/>
                  <col style="width:25%"/>
                  <tr>
                    <th scope="row">
                      <%=cm.cmsPhrase("Original country name:")%>
                    </th>
                    <td>
                        <%=Utilities.formatString(country.getAreaName(),"&nbsp;")%>
                    </td>
                    <th scope="row">
                      <%=cm.cmsPhrase("ISO Three Letter Code:")%>
                    </th>
                    <td>
                        <%=Utilities.formatString(country.getIso3l(),"&nbsp;")%>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">
                      <%=cm.cmsPhrase("English country name:")%>
                    </th>
                    <td>
                        <%=Utilities.formatString(country.getAreaNameEnglish(),"&nbsp;")%>
                    </td>
                    <th scope="row">
                      <%=cm.cmsPhrase("ISO Numeric Code:")%>
                    </th>
                    <td>
                        <%=Utilities.formatString(country.getIsoN(),"&nbsp;")%>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">
                      <%=cm.cmsPhrase("French country name:")%>
                    </th>
                    <td>
                        <%=Utilities.formatString(country.getAreaNameFrench(),"&nbsp;")%>
                    </td>
                    <th scope="row">
                      <%=cm.cmsPhrase("Capital:")%>
                    </th>
                    <td>
                        <%=Utilities.formatString(country.getCapital(),"&nbsp;")%>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">
                      <%=cm.cmsPhrase("EUNIS area code:")%>
                    </th>
                    <td>
                        <%=Utilities.formatString(country.getEunisAreaCode(),"&nbsp;")%>
                    </td>
                    <th scope="row">
                      <%=cm.cmsPhrase("Surface(km2):")%>
                    </th>
                    <td>
                        <%=Utilities.formatString(country.getSurface(),"&nbsp;")%>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">
                      <%=cm.cmsPhrase("ISO Two Letter Code:")%>
                    </th>
                    <td>
                        <%=Utilities.formatString(country.getIso2l(),"&nbsp;")%>
                    </td>
                    <th scope="row">
                      <%=cm.cmsPhrase("Population number:")%>
                    </th>
                    <td>
                        <%=Utilities.formatString(country.getPopulation(),"&nbsp;")%>
                    </td>
                  </tr>
                </table>
          <%
             // Country regions
             Iterator it = CountryUtil.findRegionsFromCountry(country.getEunisAreaCode());
             if (it != null && it.hasNext())
             {
           %>
                <h2>
                  <%=cm.cmsPhrase("Biogeographic regions:")%>
                </h2>
                <table summary="<%=cm.cmsPhrase("Biogeographic regions")%>" class="listing">
                  <thead>
                    <tr>
                      <th>
                        <%=cm.cmsPhrase("Biogeographic region name")%>
                      </th>
                      <th style="text-align: right;">
                        <%=cm.cmsPhrase("Percentage(%)")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
          <%
              int k=0;
              while (it.hasNext())
              {
                k++;
                RegionWrapper region = (RegionWrapper)it.next();
                String bgcolor = (0 == (k % 2) ? "zebraodd" : "zebraeven");
          %>
                  <tr class="<%=bgcolor%>">
                    <td>
                      <%=Utilities.formatString(region.getName())%>
                    </td>
                  <td style="text-align:right">
                    <%=Utilities.formatString(region.getPercentage())%>
                  </td>
                </tr>
          <%
              }
          %>
                  </tbody>
                </table>
          <%
            }

            if(Utilities.isCountry(country.getAreaNameEnglish()))
            {
            if(showDesignations.equals("true"))
            {
              out.flush();
              // find list of sites for main search criteria
              String SQL_DRV = application.getInitParameter("JDBC_DRV");
              String SQL_URL = application.getInitParameter("JDBC_URL");
              String SQL_USR = application.getInitParameter("JDBC_USR");
              String SQL_PWD = application.getInitParameter("JDBC_PWD");

              SQLUtilities sqlc = new SQLUtilities();
              sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

              String sql = " SELECT DISTINCT A.ID_SITE FROM CHM62EDT_COUNTRY AS C " +
                           " INNER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS B ON C.ID_GEOSCOPE = B.ID_GEOSCOPE " +
                           " INNER JOIN CHM62EDT_SITES AS A ON B.ID_NATURE_OBJECT=A.ID_NATURE_OBJECT WHERE " + formBean.prepareSQLForFindSites();


              List idSitesListResult = sqlc.ExecuteSQLReturnList(sql, 1);
              List idSitesList = new ArrayList();
              if(idSitesListResult != null && idSitesListResult.size() > 0)
              {
               for(int i=0;i<idSitesListResult.size();i++) idSitesList.add(((TableColumns)idSitesListResult.get(i)).getColumnsValues().get(0));
              }


              //List designations
              List design = formBean.getDesignationsList(idSitesList);
              if(design != null && design.size()  > 0)
              {
                //System.out.println( "Found " + design.size() + " designations" );
          %>
                <br />
                <table summary="<%=cm.cmsPhrase("Designations")%>" class="listing">
                  <thead>
                    <tr>
                      <th>
                        <%=cm.cmsPhrase("Source data set")%>
                      </th>
                      <th>
                        <%=cm.cmsPhrase("Designation type name")%>
                      </th>
                      <th>
                        <%=cm.cmsPhrase("English designation type name")%>
                      </th>
                      <th>
                        <%=cm.cmsPhrase("Category")%>
                      </th>
                      <th>
                        <%=cm.cmsPhrase("Total number of sites")%>
                      </th>
                      <th>
                        <%=cm.cmsPhrase("Total area(ha)")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
          <%
                for(int i=0;i<design.size();i++)
                {
                  Chm62edtDesignationsPersist d = (Chm62edtDesignationsPersist)design.get(i);
                  //System.out.println( "Started iteration : " + i );
                  //long l = new Date().getTime();
                  List res = formBean.getValueForDesignations(idSitesList,d.getIdDesignation(),d.getIdGeoscope(),SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
                  //long l1 = new Date().getTime();
                  //System.out.println( "iteration took " +  ( l1 - l ) + " msecs");
                  String bgcolor = (0 == (i % 2) ? "zebraodd" : "zebraeven");
          %>
                  <tr class="<%=bgcolor%>">
                    <td>
                      <%=(d.getOriginalDataSource() == null || d.getOriginalDataSource().trim().length() <= 0? "n/a" : d.getOriginalDataSource())%>
                    </td>
                    <td>
          <%
                  if (null != d.getDescription() && !d.getDescription().equalsIgnoreCase(""))
                  {
          %>
                      <a href="designations/<%=d.getIdGeoscope()%>:<%=d.getIdDesignation()%>"><%=d.getDescription()%></a>
          <%
                  }
                  else
                  {
          %>
                      &nbsp;
          <%
                  }
          %>
                    </td>
                    <td>
          <%
                  if (null != d.getDescriptionEn() && !d.getDescriptionEn().equalsIgnoreCase(""))
                  {
          %>
                      <a href="designations/<%=d.getIdGeoscope()%>:<%=d.getIdDesignation()%>"><%=d.getDescriptionEn()%></a>
          <%
                  }
                  else
                  {
          %>
                      &nbsp;
          <%
                  }
          %>
                    </td>
                    <td>
                      <%=Utilities.formatString(d.getNationalCategory())%>
                    </td>
                    <td align="right">
                      <%=Utilities.formatString((res.get(0)))%>
                    </td>
                    <td align="right">
                      <%=Utilities.formatArea((res.get(1)).toString(), 0, 2, "&nbsp;")%>
                    </td>
                  </tr>
          <%
                  out.flush();
                }
          %>
                  </tbody>
                </table>
          <%
              }
              else
              {
          %>
                <br />
                <strong>
                  <%=cm.cmsPhrase("This country has no designation types")%>.
                </strong>
          <%
              }
            }
            else
            {
          %>
                <br />
                <a href="sites-statistical-result.jsp?showDesignations=true&amp;yearMin=<%=formBean.getYearMin()%>&amp;yearMax=<%=formBean.getYearMax()%>&amp;designationCat=<%=formBean.getDesignationCat()%>&amp;designation=<%=formBean.getDesignation()%>&amp;country=<%=countryName%>&amp;DB_NATURA2000=<%=request.getParameter("DB_NATURA2000")%>&amp;DB_CORINE=<%=request.getParameter("DB_CORINE")%>&amp;DB_DIPLOMA=<%=request.getParameter("DB_DIPLOMA")%>&amp;DB_CDDA_NATIONAL=<%=request.getParameter("DB_CDDA_NATIONAL")%>&amp;DB_BIOGENETIC=<%=request.getParameter("DB_BIOGENETIC")%>&amp;DB_EMERALD=<%=request.getParameter("DB_EMERALD")%>&amp;DB_CDDA_INTERNATIONAL=<%=request.getParameter("DB_CDDA_INTERNATIONAL")%>"><%=cm.cmsPhrase( "Show sites designation types from this country")%></a>
                <br />
                <strong>
                  <%=cm.cmsPhrase( "Warning: Expanding data might take a long time.")%>
                </strong>
          <%
            }
            // Prepare SQL
            StringBuffer sql = new StringBuffer();
            sql.append(" AREA_NAME_EN = '" );
            sql.append( request.getParameter("country") );
            sql.append( "'" );
            // Get result list

            List result = new ArrayList();
            try
            {
              result = new CountrySitesFactsheetDomain().findWhere(sql.toString());
            }
            catch ( Exception ex )
            {
              ex.printStackTrace();
            }
            int noSpecies = 0;
            if(result != null && result.size() > 0)
            {
              for (int k=0;k<result.size();k++)
              {
                 CountrySitesFactsheetPersist countrySitesFact = (CountrySitesFactsheetPersist) result.get(k);
                 noSpecies += Utilities.checkedStringToInt(countrySitesFact.getNumberOfSpecies(),0);
              }
            }
          %>
            <br />
          <%
            if(noSpecies <= 0)
            {
          %>
             <br />
             <%=cm.cmsPhrase( "Show species for this country")%> : <%=noSpecies%>
          <%
            }
            else
            {
          %>
                  <br />
                  <a href="javascript:openNewPage('species-country-result.jsp?country=<%=country.getIdCountry()%>&amp;countryName=<%=countryName%>&amp;region=any&amp;regionName=any')"><%=cm.cmsPhrase( "Show species for this country")%>(<%=noSpecies%> species)</a>
                  <br />
                  <strong>
                    <%=cm.cmsPhrase( "Warning: Expanding data might take a long time.")%>
                  </strong>
          <%
            }
            // No of habitats
            int noHabitats = 0;
            if(result != null && result.size() > 0)
            {
              for (int k=0;k<result.size();k++)
              {
                 CountrySitesFactsheetPersist countrySitesFact = (CountrySitesFactsheetPersist) result.get(k);
                 noHabitats += Utilities.checkedStringToInt(countrySitesFact.getNumberOfHabitats(),0);
              }
            }
             if(noHabitats == 0)
            {
          %>
                  <br />
                  <%=cm.cmsPhrase( "Show habitat types for this country")%>: <%=noHabitats%>
          <%
            }
            else
            {
          %>
                <br />
                <br />
                <a href="javascript:openNewPage('habitats-country-result.jsp?database=2&amp;showScientificName=true&amp;showVernacularName=true&amp;country=<%=countryName%>&amp;region=')"><%=cm.cmsPhrase( "Show habitat types for this country")%>(<%=noHabitats%> habitat types)</a>
                <br />
                <strong>
                  <%=cm.cmsPhrase( "Warning: Expanding data might take a long time.")%>
                </strong>
          <%
            }
          %>
                <br />
                <br />
          <%
            // Prepare SQL
            sql = new StringBuffer();
            sql.append(" AREA_NAME_EN = '" );
            sql.append( request.getParameter("country") );
            sql.append( "'" );
            // Contains true values if proper sourceDB checkbox was check
            boolean[] source =
            {
              request.getParameter( "DB_NATURA2000" ) != null,
              request.getParameter( "DB_CORINE" ) != null,
              request.getParameter( "DB_DIPLOMA" ) != null,
              request.getParameter( "DB_CDDA_NATIONAL" ) != null,
              request.getParameter( "DB_CDDA_INTERNATIONAL" ) != null,
              request.getParameter( "DB_BIOGENETIC" ) != null,
              false,
              request.getParameter( "DB_EMERALD" ) != null
            };

            if(source[0] == false && source[1] == false
                    && source[2] == false && source[3] == false
                    && source[4] == false && source[5] == false
                    && source[6] == false && source[7] == false)
            {
              source[0] = true;
              source[1] = true;
              source[2] = true;
              source[3] = true;
              source[4] = true;
              source[5] = true;
              source[6] = false;
              source[7] = true;
            }
            // List of sites source data set
            String[] db = {"Natura2000","Corine","Diploma","CDDA_National","CDDA_International","Biogenetic","NatureNet","Emerald"};

            sql = Utilities.getConditionForSourceDB(sql,source,db,"CHM62EDT_COUNTRY_SITES_FACTSHEET");
            // Get result list
            result = new ArrayList();
            try
            {
              result = new CountrySitesFactsheetDomain().findWhere(sql.toString());
            }
            catch( Exception ex )
            {
              ex.printStackTrace();
            }
                  Long nrSites = formBean.computeNumberOfSites();
                  if ( nrSites == null || ( nrSites != null && nrSites.longValue() < 0 ) )
                  {
                    nrSites = new Long( 0 );
                  }
                %>
		<p>
                <%=cm.cmsPhrase("Total number of sites:")%> <%=nrSites%>
		</p>
               <% 
            if(result != null && result.size()>0)
            {
          %>
                <table summary="<%=cm.cmsPhrase("Sites")%>" class="listing">
                  <thead>
                  <tr>
                    <th>
                      <%=cm.cmsPhrase("Source data set")%>
                    </th>
          <%
               for(int i=0;i<result.size();i++)
               {
                 CountrySitesFactsheetPersist site = (CountrySitesFactsheetPersist)result.get(i);
          %>
                    <th>
                      <%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>
                    </th>
          <%
                }
          %>
                  </tr>
                  </thead>
                  <tbody>
                    <%=Utilities.getSitesCountryFactsheetInTable(result,cm )%>
                  </tbody>
                </table>
          <%
              }
              }
          %>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="sites-statistical-result.jsp" />
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
    <script language="javascript" type="text/javascript">
      //<![CDATA[
        try
        {
          var ctrl_loading = document.getElementById( "loading" );
          ctrl_loading.style.display = "none";
        }
        catch ( e )
        {
        }
        //]]>
      </script>
  </body>
</html>
