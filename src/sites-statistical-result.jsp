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
  // Get Chm62edtCountryPersist object
  //Utilities.dumpRequestParams( request );
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <script language="JavaScript" type="text/javascript" src="script/sites-statistical.js"></script>
    <script language="JavaScript" src="script/sortable.js" type="text/javascript"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_statistical-result_title")%>
      <%=country.getAreaNameEnglish()%>
    </title>
</head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home#index.jsp,sites#sites.jsp,statistical_data#sites-statistical.jsp,results"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <img id="loading" alt="Loading" title="Loading" src="images/loading.gif" />
<%
  if (null != country)
  {
%>
      <h1>
        <%=cm.cmsText("sites_statistical_result_totalarea")%>
      </h1>
      <%=cm.cmsText("sites_statistical-result_01")%>
      <strong>
        <%=formBean.toHumanString()%>
      </strong>
      <br />
      <img src="<%=application.getInitParameter("EEA_MAP_SERVER")%>/getmap.asp?Q=<%=sbCCodes.toString().toUpperCase()%>&amp;outline=1" alt="<%=cm.cms("map_image_eea")%>" title="<%=cm.cms("map_image_eea")%>" />
      <%=cm.cmsTitle("map_image_eea")%>
      <%=cm.cmsAlt("map_image_eea")%>
      <br />
      <%
        Long nrSites = formBean.computeNumberOfSites();
        if ( nrSites == null || ( nrSites != null && nrSites.longValue() < 0 ) )
        {
          nrSites = new Long( 0 );
        }
      %>
      <%=cm.cmsText("sites_statistical-result_03")%>&nbsp;&nbsp;<%=nrSites%>
      <br /><br />
      <strong>
        <%=cm.cmsText("sites_statistical-result_04")%>
      </strong>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="Country information">
        <tr>
          <td width="221">
            <%=cm.cmsText("sites_statistical-result_05")%>
          </td>
          <td width="158">
            <strong>
              <%=Utilities.formatString(country.getAreaName(),"&nbsp;")%>
            </strong>
          </td>
          <td width="221">
            <%=cm.cmsText("sites_statistical-result_06")%>
          </td>
          <td width="158">
            <strong>
              <%=Utilities.formatString(country.getIso3l(),"&nbsp;")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td width="221">
            <%=cm.cmsText("sites_statistical-result_07")%>
          </td>
          <td width="158">
            <strong>
              <%=Utilities.formatString(country.getAreaNameEnglish(),"&nbsp;")%>
            </strong>
          </td>
          <td width="221">
            <%=cm.cmsText("sites_statistical-result_08")%>
          </td>
          <td width="158">
            <strong>
              <%=Utilities.formatString(country.getIsoN(),"&nbsp;")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td width="221">
            <%=cm.cmsText("sites_statistical-result_09")%>
          </td>
          <td width="158">
            <strong>
              <%=Utilities.formatString(country.getAreaNameFrench(),"&nbsp;")%>
            </strong>
          </td>
          <td width="221">
            <%=cm.cmsText("sites_statistical-result_10")%>
          </td>
          <td width="158">
            <strong>
              <%=Utilities.formatString(country.getCapital(),"&nbsp;")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td width="221">
            <%=cm.cmsText("sites_statistical-result_11")%>
          </td>
          <td width="158">
            <strong>
              <%=Utilities.formatString(country.getEunisAreaCode(),"&nbsp;")%>
            </strong>
          </td>
          <td width="202">
            <%=cm.cmsText("sites_statistical-result_12")%>
          </td>
          <td width="151">
            <strong>
              <%=Utilities.formatString(country.getSurface(),"&nbsp;")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td width="221">
            <%=cm.cmsText("sites_statistical-result_13")%>
          </td>
          <td width="158">
            <strong>
              <%=Utilities.formatString(country.getIso2l(),"&nbsp;")%>
            </strong>
          </td>
          <td width="202">
            <%=cm.cmsText("sites_statistical-result_14")%>
          </td>
          <td width="151">
            <strong>
              <%=Utilities.formatString(country.getPopulation(),"&nbsp;")%>
            </strong>
          </td>
        </tr>
      </table>
      <br />
<%
   // Country regions
   Iterator it = CountryUtil.findRegionsFromCountry(country.getEunisAreaCode());
   if (it != null && it.hasNext())
   {
 %>
      <strong>
        <%=cm.cmsText("sites_statistical-result_15")%>
      </strong>
      <table id="rsTable2" border="1" cellpadding="1" cellspacing="1" width="100%" summary="<%=cm.cms("biogeographic_regions")%>" class="sortable">
        <tr>
          <th title="<%=cm.cms("sort_results_on_this_column")%>">
            <%=cm.cmsText("biogeographic_region_name")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th style="text-align : right;" title="<%=cm.cms("sort_results_on_this_column")%>">
            <%=cm.cmsText("sites_statistical-result_17")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
        </tr>
<%
    int k=0;
    while (it.hasNext())
    {
      k++;
      RegionWrapper region = (RegionWrapper)it.next();
      String bgcolor = (0 == (k % 2) ? "#FFFFFF" : "#EEEEEE");
%>
        <tr bgcolor="<%=bgcolor%>">
          <td>
            <%=Utilities.formatString(region.getName())%>
          </td>
        <td align="right">
          <%=Utilities.formatString(region.getPercentage())%>
        </td>
      </tr>
<%
    }
%>
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
      <table border="1" cellpadding="1" cellspacing="1" width="100%" id="rsTable" summary="<%=cm.cms("sites_statistical_result_designations")%>" class="sortable">
        <tr>
          <th title="<%=cm.cms("sort_results_on_this_column")%>">
            <%=cm.cmsText("source_data_set")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th title="<%=cm.cms("sort_results_on_this_column")%>">
            <%=cm.cmsText("sites_statistical-result_19")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th title="<%=cm.cms("sort_results_on_this_column")%>">
            <%=cm.cmsText("sites_statistical-result_20")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th title="<%=cm.cms("sort_results_on_this_column")%>">
            <%=cm.cmsText("sites_statistical-result_21")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th title="<%=cm.cms("sort_results_on_this_column")%>">
            <%=cm.cmsText("category_location")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th title="<%=cm.cms("sort_results_on_this_column")%>">
            <%=cm.cmsText("sites_statistical-result_23")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
          <th title="<%=cm.cms("sort_results_on_this_column")%>">
            <%=cm.cmsText("total_area_ha")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
        </tr>
<%
      for(int i=0;i<design.size();i++)
      {
        Chm62edtDesignationsPersist d = (Chm62edtDesignationsPersist)design.get(i);
        //System.out.println( "Started iteration : " + i );
        //long l = new Date().getTime();
        List res = formBean.getValueForDesignations(idSitesList,d.getIdDesignation(),d.getIdGeoscope(),SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
        //long l1 = new Date().getTime();
        //System.out.println( "iteration took " +  ( l1 - l ) + " msecs");
        String bgcolor = (0 == (i % 2) ? "#FFFFFF" : "#EEEEEE");
%>
        <tr>
          <td bgcolor="<%=bgcolor%>">
            <%=(d.getOriginalDataSource() == null || d.getOriginalDataSource().trim().length() <= 0? "n/a" : d.getOriginalDataSource())%>
          </td>
          <td bgcolor="<%=bgcolor%>">
<%
        if (null != d.getDescription() && !d.getDescription().equalsIgnoreCase(""))
        {
%>
            <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?idDesign=<%=d.getIdDesignation()%>&amp;geoscope=<%=d.getIdGeoscope()%>"><%=d.getDescription()%></a>
            <%=cm.cmsTitle("open_designation_factsheet")%>
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
          <td bgcolor="<%=bgcolor%>">
<%
        if (null != d.getDescriptionEn() && !d.getDescriptionEn().equalsIgnoreCase(""))
        {
%>
            <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?idDesign=<%=d.getIdDesignation()%>&amp;geoscope=<%=d.getIdGeoscope()%>"><%=d.getDescriptionEn()%></a>
            <%=cm.cmsTitle("open_designation_factsheet")%>
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
          <td bgcolor="<%=bgcolor%>">
<%
        if (null != d.getDescriptionFr() && !d.getDescriptionFr().equalsIgnoreCase(""))
        {
%>
            <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?idDesign=<%=d.getIdDesignation()%>&amp;geoscope=<%=d.getIdGeoscope()%>"><%=d.getDescriptionFr()%></a>
            <%=cm.cmsTitle("open_designation_factsheet")%>
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
          <td bgcolor="<%=bgcolor%>">
            <%=Utilities.formatString(d.getNationalCategory())%>
          </td>
          <td bgcolor="<%=bgcolor%>" align="right">
            <%=Utilities.formatString((res.get(0)))%>
          </td>
          <td bgcolor="<%=bgcolor%>" align="right">
            <%=Utilities.formatArea((res.get(1)).toString(), 0, 2, "&nbsp;")%>
          </td>
        </tr>
<%
        out.flush();
      }
%>
      </table>
<%
    }
    else
    {
%>
      <br />
      <strong>
        <%=cm.cmsText("sites_statistical_result_nodesignations")%>.
      </strong>
<%
    }
  }
  else
  {
%>
      <br />
      <a title="<%=cm.cms( "sites_statistical-result_32")%>" href="sites-statistical-result.jsp?showDesignations=true&amp;yearMin=<%=formBean.getYearMin()%>&amp;yearMax=<%=formBean.getYearMax()%>&amp;designationCat=<%=formBean.getDesignationCat()%>&amp;designation=<%=formBean.getDesignation()%>&amp;country=<%=countryName%>&amp;DB_NATURA2000=<%=request.getParameter("DB_NATURA2000")%>&amp;DB_CORINE=<%=request.getParameter("DB_CORINE")%>&amp;DB_DIPLOMA=<%=request.getParameter("DB_DIPLOMA")%>&amp;DB_CDDA_NATIONAL=<%=request.getParameter("DB_CDDA_NATIONAL")%>&amp;DB_BIOGENETIC=<%=request.getParameter("DB_BIOGENETIC")%>&amp;DB_EMERALD=<%=request.getParameter("DB_EMERALD")%>&amp;DB_CDDA_INTERNATIONAL=<%=request.getParameter("DB_CDDA_INTERNATIONAL")%>"><%=cm.cmsText( "sites_statistical-result_32")%></a>
      <%=cm.cmsTitle("sites_statistical-result_32")%>
      <br />
      <strong>
        <%=cm.cmsText( "sites_statistical-result_31")%>
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
   <%=cm.cmsText( "sites_statistical-result_35")%> : <%=noSpecies%>
<%
  }
  else
  {
%>
        <br />
        <a title="<%=cm.cms("sites_statistical_result_species")%>" href="javascript:openNewPage('species-country-result.jsp?country=<%=country.getIdCountry()%>&amp;countryName=<%=countryName%>&amp;region=any&amp;regionName=any')"><%=cm.cmsText( "sites_statistical-result_35")%>(<%=noSpecies%> species)</a>
        <%=cm.cmsTitle("sites_statistical_result_species")%>
        <br />
        <strong>
          <%=cm.cmsText( "sites_statistical-result_31")%>
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
        <%=cm.cmsText( "sites_statistical-result_36")%>: <%=noHabitats%>
<%
  }
  else
  {
%>
      <br />
      <br />
      <a title="<%=cm.cms("sites_statistical_result_habitats")%>" href="javascript:openNewPage('habitats-country-result.jsp?database=2&amp;showScientificName=true&amp;showVernacularName=true&amp;country=<%=countryName%>&amp;region=')"><%=cm.cmsText( "sites_statistical-result_36")%>(<%=noHabitats%> habitat types)</a>
      <%=cm.cmsTitle("sites_statistical_result_habitats")%>
      <br />
      <strong>
        <%=cm.cmsText( "sites_statistical-result_31")%>
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
  if(result != null && result.size()>0)
  {
%>
      <table border="1" cellpadding="1" cellspacing="1" style="border-collapse: collapse" width="100%" id="rsTableNew" summary="<%=cm.cms("sites")%>">
        <tr>
          <th class="resultHeader">
            <%=cm.cmsText("source_data_set")%>
          </th>
<%
     for(int i=0;i<result.size();i++)
     {
       CountrySitesFactsheetPersist site = (CountrySitesFactsheetPersist)result.get(i);
%>
          <th class="resultHeader">
            <%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>
          </th>
<%
      }
%>
        </tr>
        <%=Utilities.getSitesCountryFactsheetInTable(result,cm )%>
      </table>
<%
    }
    }
%>

      <%=cm.cmsMsg("sites_statistical-result_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("biogeographic_regions")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_statistical_result_designations")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-statistical-result.jsp" />
      </jsp:include>
<%
  }
  else
  {
%>
    <br />
    <jsp:include page="noresults.jsp" />
<%
  }
%>
 <script language="javascript" type="text/javascript">
    <!--
      try
      {
        var ctrl_loading = document.getElementById( "loading" );
        ctrl_loading.style.display = "none";
      }
      catch ( e )
      {
      }
      //-->
    </script>
    </div>
    </div>
    </div>
  </body>
</html>
<%
  out.flush();
%>