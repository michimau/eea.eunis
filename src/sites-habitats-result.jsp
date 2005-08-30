<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick habitat types, show sites" function - results page.
--%>
<%@ page contentType="text/html"%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.sites.habitats.HabitatPaginator,
                 ro.finsiel.eunis.jrfTables.sites.habitats.HabitatDomain,
                 ro.finsiel.eunis.jrfTables.sites.habitats.HabitatPersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.habitats.HabitatBean,
                 ro.finsiel.eunis.search.sites.habitats.HabitatSearchCriteria,
                 ro.finsiel.eunis.search.sites.habitats.HabitatSortCriteria,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="ro.finsiel.eunis.jrfTables.*" %>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-names.js"></script>
    <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.habitats.HabitatBean" scope="page">
      <jsp:setProperty name="formBean" property="*"/>
    </jsp:useBean>
    <%
    // Prepare the search in results (fix)
    if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
     // Check columns to be displayed
    boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), HabitatBean.HIDE);
    boolean showName = Utilities.checkedStringToBoolean(formBean.getShowName(), true);
    boolean showSiteCode = Utilities.checkedStringToBoolean(formBean.getShowName(), true);
    boolean showDesignType = Utilities.checkedStringToBoolean(formBean.getShowDesignationTypes(), HabitatBean.HIDE);
    boolean showCoord = Utilities.checkedStringToBoolean(formBean.getShowCoordinates(), HabitatBean.HIDE);
    boolean showHabitat  = Utilities.checkedStringToBoolean(formBean.getShowHabitat(), true);
//    boolean[] source = {(formBean.getDB_NATURA2000()==null?false:true),
//                        (formBean.getDB_CORINE()==null?false:true),
//                        (formBean.getDB_DIPLOMA()==null?false:true),
//                        (formBean.getDB_CDDA_NATIONAL()==null?false:true),
//                        (formBean.getDB_CDDA_INTERNATIONAL()==null?false:true),
//                        (formBean.getDB_BIOGENETIC()==null?false:true),
//                        false,
//                        (formBean.getDB_EMERALD()==null?false:true)
//    };
    boolean[] source = { true, true, true, true, true, true, false, true }; // Default search in all data sets

    // Initialization
    int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
    Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), HabitatSearchCriteria.SEARCH_NAME);
    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), HabitatDomain.SEARCH_EUNIS);
    HabitatPaginator paginator = new HabitatPaginator(new HabitatDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), Utilities.checkedStringToInt(formBean.getDatabase(), HabitatDomain.SEARCH_EUNIS), source, searchAttribute));
    paginator.setSortCriteria(formBean.toSortCriteria());
    paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
    currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
    int resultsCount = paginator.countResults();
    final String pageName = "sites-habitats-result.jsp";
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

    String tsvLink = "javascript:openlink('reports/sites/tsv-sites-habitats.jsp?" + formBean.toURLParam(reportFields) + "')";
    WebContentManagement contentManagement = SessionManager.getWebContent();
%>
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_habitats-result_title", false )%></title>
  </head>
<body>
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Sites#sites-habitats.jsp,Results"/>
      <jsp:param name="downloadLink" value="<%=tsvLink%>"/>
      <jsp:param name="mapLink" value="show"/>
    </jsp:include>
<%--    <jsp:param name="printLink" value="<%=pdfLink%>"/>--%>
    <h5>
      <%=contentManagement.getContent("sites_habitats-result_01")%>
    </h5>
    <%=contentManagement.getContent("sites_habitats-result_02")%>
    <%=Utilities.getSourceHabitat(database, HabitatDomain.SEARCH_ANNEX_I.intValue(), HabitatDomain.SEARCH_BOTH.intValue())%>
    <%=contentManagement.getContent("sites_habitats-result_03")%> <strong><%=formBean.getMainSearchCriteria().toHumanString()%>.</strong>
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
    <br />
    <%=contentManagement.getContent("sites_habitats-result_04")%>:
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
      <%=contentManagement.getContent("sites_habitats-result_05")%>
      <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
        <%=formBean.toFORMParam(filterSearch)%>
        <label for="criteriaType" class="noshow">Criteria</label>
        <select id="criteriaType" name="criteriaType" class="inputTextField" title="Criteria">
<%
  if (showSourceDB)
  {
%>
          <option value="<%=HabitatSearchCriteria.CRITERIA_SOURCE_DB%>">
            <%=contentManagement.getContent("sites_habitats-result_06", false)%>
          </option>
<%
  }
  if (showName)
  {
%>
          <option value="<%=HabitatSearchCriteria.CRITERIA_ENGLISH_NAME%>">
            <%=contentManagement.getContent("sites_habitats-result_07", false)%>
          </option>
<%
  }
  if (showHabitat)
  {
%>
          <option value="<%=HabitatSearchCriteria.CRITERIA_HABITAT%>">
            <%=contentManagement.getContent("sites_habitats-result_09", false)%>
          </option>
<%
  }
%>
        </select>
        <label for="oper" class="noshow">Operator</label>
        <select id="oper" name="oper" class="inputTextField" title="Operator">
          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=contentManagement.getContent("sites_habitats-result_10", false)%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=contentManagement.getContent("sites_habitats-result_11", false)%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("sites_habitats-result_12", false)%></option>
        </select>
        <label for="criteriaSearch" class="noshow">Filter value</label>
        <input id="criteriaSearch" name="criteriaSearch" type="text" size="30" class="inputTextField" title="Filter value" />
        <label for="submit" class="noshow">Search</label>
        <input id="submit" name="Submit" type="submit" title="Search" value="<%=contentManagement.getContent("sites_habitats-result_13", false)%>" class="inputTextField" />
        <%=contentManagement.writeEditTag( "sites_habitats-result_13" )%>
      </form>
<%
  ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
  if (criterias.length > 1)
  {
%>
      <%=contentManagement.getContent("sites_habitats-result_14")%>
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
      <strong class="linkDarkBg">
        <%= i + ". " + criteria.toHumanString()%>
      </strong>
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
  AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_SOURCE_DB);
  AbstractSortCriteria sortName = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_NAME);
  AbstractSortCriteria sortDesignType = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_DESIGNATION);
  AbstractSortCriteria sortHabitat = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_HABITAT);
  AbstractSortCriteria sortLat = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_LAT);
  AbstractSortCriteria sortLong = formBean.lookupSortCriteria(HabitatSortCriteria.SORT_LONG);
%>
      <br />
      <table summary="Search results" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
        <tr>
<%
  if (showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitatSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_habitats-result_15")%></a>
          </th>
<%
  }
  if (showDesignType)
  {
%>
          <th class="resultHeader">
            <%=contentManagement.getContent("sites_habitats-result_16")%>
          </th>
<%
  }
  if (showSiteCode)
  {
%>
          <th class="resultHeader">
            Site code
          </th>
<%
  }
  if (showName)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitatSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=contentManagement.getContent("sites_habitats-result_17")%></a>
          </th>
<%
  }
  if (showCoord)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_habitats-result_18")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_habitats-result_19")%>
          </th>
<%
  }
  if (showHabitat)
  {
%>
          <th class="resultHeader">
            <%=contentManagement.getContent("sites_habitats-result_20")%>
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
    HabitatPersist site = (HabitatPersist)it.next();
%>
        <tr>
<%
    if (showSourceDB)
    {
%>
          <td bgcolor="<%=bgCol%>">
            <strong>
              <%=Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()),"&nbsp;")%>
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
    if (showSiteCode)
    {
%>
          <td bgcolor="<%=bgCol%>">
            <strong>
              <%=site.getIdSite()%>
            </strong>
          </td>
<%
    }
    if (showName)
    {
%>
          <td bgcolor="<%=bgCol%>">
            <a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=site.getName()%></a>
          </td>
<%
    }
    if (showCoord)
    {
%>
          <td align="center" bgcolor="<%=bgCol%>" nowrap="nowrap">
            <%=SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec())%>
          </td>
          <td align="center" bgcolor="<%=bgCol%>" nowrap="nowrap">
            <%=SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec())%>
          </td>
<%
  }
    if (showHabitat)
    {
      Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
      boolean[] source_db = { true, true, true, true, true, true, false, true }; // Default search in all data sets
      List resultsHabitats = new HabitatDomain().findHabitatsFromSpecifiedSite(
          new HabitatSearchCriteria(searchAttribute,
                                              formBean.getSearchString(),
                                              relationOp),
                                              searchAttribute,
                                              source_db,
                                              Utilities.formatString(site.getName(),""));
%>
          <td bgcolor="<%=bgCol%>">
<%
      if (!resultsHabitats.isEmpty())
      {
        String SQL_DRV = application.getInitParameter("JDBC_DRV");
        String SQL_URL = application.getInitParameter("JDBC_URL");
        String SQL_USR = application.getInitParameter("JDBC_USR");
        String SQL_PWD = application.getInitParameter("JDBC_PWD");

        SQLUtilities sqlc = new SQLUtilities();
        sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
%>
            <table border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse" summary="Habitat types">
<%
        for(int ii=0;ii<resultsHabitats.size();ii++)
        {
          String isGoodHabitat = " IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',RIGHT(CHM62EDT_HABITAT.CODE_2000,2),1) <> IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '','00',2) AND IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',LENGTH(CHM62EDT_HABITAT.CODE_2000),1) = IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',4,1) ";
          String habitatName = (String) resultsHabitats.get(ii);
          String idHabitat = sqlc.ExecuteSQL("SELECT ID_HABITAT FROM chm62edt_habitat WHERE    "+isGoodHabitat+" AND SCIENTIFIC_NAME='"+habitatName+"'");
%>
              <tr>
                <td>
                  <a title="Habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=idHabitat%>"><%=habitatName%></a>
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
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitatSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_habitats-result_15")%></a>
          </th>
<%
  }
  if (showDesignType)
  {
%>
          <th class="resultHeader">
            <%=contentManagement.getContent("sites_habitats-result_16")%>
          </th>
<%
  }
  if (showSiteCode)
  {
%>
          <th class="resultHeader">
            Site code
          </th>
<%
  }
  if (showName)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitatSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=contentManagement.getContent("sites_habitats-result_17")%></a>
          </th>
<%
  }
  if (showCoord)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_habitats-result_18")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_habitats-result_19")%>
          </th>
<%
  }
  if (showHabitat)
  {
%>
          <th class="resultHeader">
            <%=contentManagement.getContent("sites_habitats-result_20")%>
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
        <jsp:param name="page_name" value="sites-habitats-result.jsp" />
      </jsp:include>
    </div>
  </body>
</html>