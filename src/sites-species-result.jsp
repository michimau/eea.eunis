<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick species, show sites" function - results page.
--%>
<%@ page contentType="text/html"%>
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

  String tsvLink = "javascript:openlink('reports/sites/tsv-sites-species.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement contentManagement = SessionManager.getWebContent();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-names.js"></script>
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_species-result_title", false )%></title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Sites#sites-species.jsp,Results"/>
        <jsp:param name="downloadLink" value="<%=tsvLink%>"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <h5>
        <%=contentManagement.getContent("sites_species-result_01")%>
      </h5>

      <%=contentManagement.getContent("sites_species-result_02")%> <strong><%=(formBean.getMainSearchCriteria()).toHumanString()%></strong>.
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
      <%=contentManagement.getContent("sites_species-result_03")%>:
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
          <%=contentManagement.getContent("sites_species-result_04")%>
        </strong>
        <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
          <%=formBean.toFORMParam(filterSearch)%>
          <label for="criteriaType" class="noshow">Criteria</label>
          <select id="criteriaType" name="criteriaType" class="inputTextField" title="Criteria">
<%
  if (showSourceDB)
  {
%>
            <option value="<%=SpeciesSearchCriteria.CRITERIA_SOURCE_DB%>">
              <%=contentManagement.getContent("sites_species-result_05")%>
            </option>
<%
   }
   if (showName)
   {
%>
            <option value="<%=SpeciesSearchCriteria.CRITERIA_ENGLISH_NAME%>">
              <%=contentManagement.getContent("sites_species-result_06")%>
            </option>
<%
    }
%>
          </select>
          <label for="oper" class="noshow">Operator</label>
          <select id="oper" name="oper" class="inputTextField" title="Operator">
            <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=contentManagement.getContent("sites_species-result_07", false)%></option>
            <option value="<%=Utilities.OPERATOR_STARTS%>"><%=contentManagement.getContent("sites_species-result_08", false)%></option>
            <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("sites_species-result_09", false)%></option>
          </select>
          <label for="criteriaSearch" class="noshow">Filter value</label>
          <input id="criteriaSearch" name="criteriaSearch" type="text" size="30" class="inputTextField" title="Filter value" />

          <label for="submit" class="noshow">Search</label>
          <input id="submit" name="Submit" title="Search" type="submit" value="Search" class="inputTextField" />
        </form>
<%
  ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
  if (criterias.length > 1)
  {
%>
        <%=contentManagement.getContent("sites_species-result_10")%>
        <br />
<%
  }
  for (int i = criterias.length - 1; i > 0; i--)
  {
    AbstractSearchCriteria criteria = criterias[i];
    if (null != criteria && null != formBean.getCriteriaSearch())
    {
%>
        <a title="Remove filter" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img src="images/mini/delete.jpg" alt="<%=Accesibility.getText( "generic.refined.delete" )%>" title="<%=Accesibility.getText( "generic.refined.delete" )%>" border="0" align="middle" /></a>
        &nbsp;&nbsp;
        <strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
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
      <table summary="Search results" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
        <tr>
<%
  if (showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_species-result_11")%></a>
          </th>
<%
  }
  if (showDesignType)
  {
%>
          <th class="resultHeader">
            <%=contentManagement.getContent("sites_species-result_12")%>
          </th>
<%
  }
  if (showName)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=contentManagement.getContent("sites_species-result_13")%></a>
          </th>
<%
  }
  if (showCoord)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_species-result_14")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_species-result_15")%>
          </th>
<%
  }
  if (showSpecies)
  {
%>
          <th align="left" width="13%" bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
            <%=contentManagement.getContent("sites_species-result_16")%>
          </th>
<%
  }
%>
        </tr>
<%
  Iterator it = results.iterator();
  int i = 0; String bgCol;
  while (it.hasNext())
  {
    bgCol = (0 == (i++) % 2) ? "#EEEEEE" : "#FFFFFF";
    SpeciesPersist site = (SpeciesPersist)it.next();
%>
        <tr>
<%
  if (showSourceDB)
  {
%>
          <td bgcolor="<%=bgCol%>">
            <strong>
              <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()))%>
            </strong>
          </td>
<%
  }
  if (showDesignType)
  {
%>
            <td bgcolor="<%=bgCol%>">
              <jsp:include page="sites-designations-detail.jsp">
                <jsp:param name="idDesignation" value="<%=site.getIdDesignation()%>"/>
                <jsp:param name="idGeoscope" value="<%=site.getIdGeoscope()%>"/>
                <jsp:param name="sourceDB" value="<%=site.getSourceDB()%>"/>
                <jsp:param name="bgcolor" value="<%=bgCol%>"/>
              </jsp:include>
            </td>
<%
  }
  if (showName)
  {
%>
          <td bgcolor="<%=bgCol%>">
            <a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=Utilities.formatString(site.getName())%></a>
          </td>
<%
  }
  if (showCoord)
  {
%>
          <td align="center"  bgcolor="<%=bgCol%>" nowrap="nowrap">
            <%=SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec())%>&nbsp;
          </td>
          <td align="center"  bgcolor="<%=bgCol%>" nowrap="nowrap">
            <%=SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec())%>&nbsp;
          </td>
<%
  }
  if (showSpecies)
  {
%>
          <td bgcolor="<%=bgCol%>">
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
            <table border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse" summary="Species from this site">
<%
      for(int ii=0;ii<resultsSpecies.size();ii++)
      {
        TableColumns tableColumns = (TableColumns) resultsSpecies.get(ii);
        String scientificName = (String)tableColumns.getColumnsValues().get(0);
        Integer idSpecies = (Integer)tableColumns.getColumnsValues().get(1);
        Integer idSpeciesLink = (Integer)tableColumns.getColumnsValues().get(2);
%>
              <tr bgcolor="#FFFFFF">
                <td>
                  <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=idSpecies%>&amp;idSpeciesLink=<%=idSpeciesLink%>"><%=scientificName%></a>
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
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_species-result_11")%></a>
          </th>
<%
  }
  if (showDesignType)
  {
%>
          <th class="resultHeader">
            <%=contentManagement.getContent("sites_species-result_12")%>
          </th>
<%
  }
  if (showName)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SpeciesSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=contentManagement.getContent("sites_species-result_13")%></a>
          </th>
<%
  }
  if (showCoord)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_species-result_14")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_species-result_15")%>
          </th>
<%
  }
  if (showSpecies)
  {
%>
          <th align="left" width="13%" bgcolor="<%=SessionManager.getThemeManager().getMediumColor()%>">
            <%=contentManagement.getContent("sites_species-result_16")%>
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
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-species-result.jsp" />
      </jsp:include>
    </div>
  </body>
</html>
<%
//  System.out.println("search took:" + Utilities.stopTimer());
%>