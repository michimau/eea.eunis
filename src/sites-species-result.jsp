<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick species, show sites" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.species.SpeciesPaginator,
                 ro.finsiel.eunis.jrfTables.sites.species.SpeciesDomain,
                 ro.finsiel.eunis.jrfTables.sites.species.SpeciesPersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.species.SpeciesBean,
                 ro.finsiel.eunis.search.sites.species.SpeciesSearchCriteria,
                 ro.finsiel.eunis.search.sites.species.SpeciesSortCriteria,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.utilities.TableColumns"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.species.SpeciesBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
   // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), SpeciesBean.HIDE);
  boolean showName = Utilities.checkedStringToBoolean(formBean.getShowName(), true);
  boolean showDesignType = Utilities.checkedStringToBoolean(formBean.getShowDesignationTypes(), SpeciesBean.HIDE);
  boolean showCoord = Utilities.checkedStringToBoolean(formBean.getShowCoordinates(), SpeciesBean.HIDE);
  boolean showSpecies  = Utilities.checkedStringToBoolean(formBean.getShowSpecies(), true);
  boolean[] source = {
    formBean.getDB_NATURA2000() != null,
    formBean.getDB_CORINE() != null,
    formBean.getDB_DIPLOMA() != null,
    formBean.getDB_CDDA_NATIONAL() != null,
    formBean.getDB_CDDA_INTERNATIONAL() != null,
    formBean.getDB_BIOGENETIC() != null,
    false,
    formBean.getDB_EMERALD() != null
  };
  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME);
  SpeciesPaginator paginator = new SpeciesPaginator(new SpeciesDomain(formBean.toSearchCriteria(),
                                                                      formBean.toSortCriteria(),
                                                                      SessionManager.getShowEUNISInvalidatedSpecies(),
                                                                      source, searchAttribute));

  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "sites-species-result.jsp";
  int resultsCount = paginator.countResults();
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.

  List results = paginator.getPage(currentPage);
  // Set number criteria for the search result
  int noCriteria = (null==formBean.getCriteriaSearch()?0:formBean.getCriteriaSearch().length);
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");

  String tsvLink = "javascript:openTSVDownload('reports/sites/tsv-sites-species.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-names.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_species-result_title")%></title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,sites_species_location#sites-species.jsp,results_location"/>
        <jsp:param name="downloadLink" value="<%=tsvLink%>"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <h1>
        <%=cm.cmsText("sites_species-result_01")%>
      </h1>

      <%=cm.cmsText("sites_species-result_02")%> <strong><%=(formBean.getMainSearchCriteria()).toHumanString()%></strong>.
<%
    if (results.isEmpty())
    {
       boolean fromRefine = false;
       if(formBean != null && formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0)
         fromRefine = true;

      %>
       <br />
       <jsp:include page="noresults.jsp" >
         <jsp:param name="fromRefine" value="<%=fromRefine%>" />
       </jsp:include>
       <%
         return;
     }
       %>
      <br />
      <%=cm.cmsText("sites_species-result_03")%>:
      <strong>
        <%=resultsCount%>
      </strong>
      <br />
<%
  // Prepare parameters for pagesize.jsp
  Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
  pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
  pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
  pageSizeFormFields.addElement("criteriaSearch");/*   to page "0" aka first page. */
%>
      <jsp:include page="pagesize.jsp">
        <jsp:param name="guid" value="<%=guid%>"/>
        <jsp:param name="pageName" value="<%=pageName%>"/>
        <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>"/>
        <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>"/>
      </jsp:include>
<%
  // Prepare the form parameters.
  Vector filterSearch = new Vector();
  filterSearch.addElement("sort");
  filterSearch.addElement("ascendency");
  filterSearch.addElement("criteriaSearch");
  filterSearch.addElement("pageSize");
%>
      <br />
      <div class="grey_rectangle">
        <strong>
          <%=cm.cmsText("sites_species-result_04")%>
        </strong>
        <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
          <%=formBean.toFORMParam(filterSearch)%>
          <label for="criteriaType" class="noshow"><%=cm.cms("criteria_type_label")%></label>
          <select id="criteriaType" name="criteriaType" class="inputTextField" title="<%=cm.cms("criteria_type_title")%>">
<%
  if (showSourceDB)
  {
%>
            <option value="<%=SpeciesSearchCriteria.CRITERIA_SOURCE_DB%>">
              <%=cm.cms("sites_species-result_05")%>
            </option>
<%
   }
   if (showName)
   {
%>
            <option value="<%=SpeciesSearchCriteria.CRITERIA_ENGLISH_NAME%>">
              <%=cm.cms("sites_species-result_06")%>
            </option>
<%
    }
%>
          </select>
          <%=cm.cmsLabel("criteria_type_label")%>
          <%=cm.cmsTitle("criteria_type_title")%>
          <%=cm.cmsInput("sites_species-result_05")%>
          <%=cm.cmsInput("sites_species-result_06")%>

          <label for="oper" class="noshow"><%=cm.cms("operator_label")%></label>
          <select id="oper" name="oper" class="inputTextField" title="<%=cm.cms("operator_title")%>">
            <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cms("sites_species-result_07")%></option>
            <option value="<%=Utilities.OPERATOR_STARTS%>"><%=cm.cms("sites_species-result_08")%></option>
            <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("sites_species-result_09")%></option>
          </select>
          <%=cm.cmsLabel("operator_label")%>
          <%=cm.cmsInput("sites_species-result_07")%>
          <%=cm.cmsInput("sites_species-result_08")%>
          <%=cm.cmsInput("sites_species-result_09")%>

          <label for="criteriaSearch" class="noshow"><%=cm.cms("filter_label")%></label>
          <input id="criteriaSearch" name="criteriaSearch" type="text" size="30" class="inputTextField" title="<%=cm.cms("filter_title")%>" />
          <%=cm.cmsLabel("filter_label")%>
          <%=cm.cmsTitle("filter_title")%>

          <label for="submit" class="noshow"><%=cm.cms("refine_btn_label")%></label>
          <input id="submit" name="Submit" type="submit" value="<%=cm.cms("refine_btn_value")%>" class="inputTextField" title="<%=cm.cms("refine_btn_title")%>" />
          <%=cm.cmsLabel("refine_btn_label")%>
          <%=cm.cmsTitle("refine_btn_title")%>
          <%=cm.cmsInput("refine_btn_value")%>
        </form>
<%
  ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
  if (criterias.length > 1)
  {
%>
        <%=cm.cmsText("sites_species-result_10")%>
        <br />
<%
  }
  for (int i = criterias.length - 1; i > 0; i--)
  {
    AbstractSearchCriteria criteria = criterias[i];
    if (null != criteria && null != formBean.getCriteriaSearch())
    {
%>
        <a title="<%=cm.cms("removefilter_title")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img src="images/mini/delete.jpg" alt="<%=cm.cms("removefilter_alt")%>" border="0" align="middle" /></a>
        <%=cm.cmsTitle("removefilter_title")%>
        <%=cm.cmsAlt("removefilter_alt")%>
        <strong><%= i + ". " + criteria.toHumanString()%></strong>
        <br />
<%
    }
  }
%>
      </div>
      <br />
<%
  // Prepare parameters for navigator.jsp
  Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
  navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
  navigatorFormFields.addElement("sort");     /* <form name="..."> in the navigator.jsp!                               */
  navigatorFormFields.addElement("ascendency");
  navigatorFormFields.addElement("criteriaSearch");
%>
      <jsp:include page="navigator.jsp">
        <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
        <jsp:param name="pageName" value="<%=pageName%>"/>
        <jsp:param name="guid" value="<%=guid%>"/>
        <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
        <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
        <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
      </jsp:include>
<%
  // Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  sortURLFields.addElement("criteriaSearch");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_SOURCE_DB);
  AbstractSortCriteria sortName = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_NAME);
  //AbstractSortCriteria sortDesignType = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_DESIGNATION);
  //AbstractSortCriteria sortSpecies = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_SPECIES);
  AbstractSortCriteria sortLat = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_LAT);
  AbstractSortCriteria sortLong = formBean.lookupSortCriteria(SpeciesSortCriteria.SORT_LONG);
%>
      <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
        <tr>
<%
  if (showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("sites_species-result_11")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showDesignType)
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("sites_species-result_12")%>
          </th>
<%
  }
  if (showName)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsText("sites_species-result_13")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showCoord)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_species-result_14")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_species-result_15")%>
          </th>
<%
  }
  if (showSpecies)
  {
%>
          <th width="13%" class="resultHeader">
            <%=cm.cmsText("sites_species-result_16")%>
          </th>
<%
  }
%>
        </tr>
<%
  Iterator it = results.iterator();
  int i = 0; String bgColor;
  while (it.hasNext())
  {
    bgColor = (0 == (i++) % 2) ? "#EEEEEE" : "#FFFFFF";
    SpeciesPersist site = (SpeciesPersist)it.next();
%>
        <tr>
<%
  if (showSourceDB)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <strong>
              <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%>
            </strong>
          </td>
<%
  }
  if (showDesignType)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <jsp:include page="sites-designations-detail.jsp">
              <jsp:param name="idDesignation" value="<%=site.getIdDesignation()%>"/>
              <jsp:param name="idGeoscope" value="<%=site.getIdGeoscope()%>"/>
              <jsp:param name="sourceDB" value="<%=site.getSourceDB()%>"/>
              <jsp:param name="bgcolor" value="<%=bgColor%>"/>
              <jsp:param name="idSite" value="<%=site.getIdSite()%>"/>
            </jsp:include>
          </td>
<%
  }
  if (showName)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=Utilities.formatString(site.getName())%></a>
            <%=cm.cmsTitle("open_site_factsheet")%>
          </td>
<%
  }
  if (showCoord)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap; text-align : center;">
            <%=SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec())%>&nbsp;
          </td>
          <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap; text-align : center;">
            <%=SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec())%>&nbsp;
          </td>
<%
  }
  if (showSpecies)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
<%
//  Vector speciesURLFields = new Vector();
//  speciesURLFields.addElement("criteriaSearch");
//  String searchURL = formBean.toURLParam(speciesURLFields) + "&idNatureObject=" + site.getIdNatureObject();
    Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
    Integer idNatureObject = site.getIdNatureObject();
    // List of species attributes.
    List resultsSpecies = new SpeciesDomain().findSpeciesFromSite(new SpeciesSearchCriteria(searchAttribute,
                                                                                formBean.getSearchString(),
                                                                                relationOp),
                                                                         SessionManager.getShowEUNISInvalidatedSpecies(),
                                                                         idNatureObject,
                                                                         searchAttribute, source);
    if (resultsSpecies != null && resultsSpecies.size() > 0)
    {
%>
            <table border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse" summary="<%=cm.cms("species_from_site")%>">
<%
      for(int ii=0;ii<resultsSpecies.size();ii++)
      {
        TableColumns tableColumns = (TableColumns) resultsSpecies.get(ii);
        String scientificName = (String)tableColumns.getColumnsValues().get(0);
        Integer idSpecies = (Integer)tableColumns.getColumnsValues().get(1);
        Integer idSpeciesLink = (Integer)tableColumns.getColumnsValues().get(2);
%>
              <tr>
                <td>
                  <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=idSpecies%>&amp;idSpeciesLink=<%=idSpeciesLink%>"><%=scientificName%></a>
                  <%=cm.cmsTitle("open_species_factsheet")%>
                </td>
              </tr>
<%
      }
%>
            </table>
<%
  }
%>
          </td>
<%
  }
%>
        </tr>
<%
  }
%>
        <tr>
<%
  if (showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("sites_species-result_11")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showDesignType)
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("sites_species-result_12")%>
          </th>
<%
  }
  if (showName)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsText("sites_species-result_13")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showCoord)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_species-result_14")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_species-result_15")%>
          </th>
<%
  }
  if (showSpecies)
  {
%>
          <th width="13%" class="resultHeader">
            <%=cm.cmsText("sites_species-result_16")%>
          </th>
<%
  }
%>
        </tr>
      </table>
      <jsp:include page="navigator.jsp">
        <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
        <jsp:param name="pageName" value="<%=pageName%>"/>
        <jsp:param name="guid" value="<%=guid + 1%>"/>
        <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
        <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
        <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
      </jsp:include>

      <%=cm.cmsMsg("sites_species-result_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("search_results")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("species_from_site")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-species-result.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
<%
//  System.out.println("search took:" + Utilities.stopTimer());
%>