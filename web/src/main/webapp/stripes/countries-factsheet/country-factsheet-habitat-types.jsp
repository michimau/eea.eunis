<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>

<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.formBeans.AbstractFormBean,
                 ro.finsiel.eunis.jrfTables.habitats.country.CountryDomain,
                 ro.finsiel.eunis.jrfTables.habitats.country.CountryPersist,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.country.CountryPaginator,
                 ro.finsiel.eunis.search.habitats.country.CountrySearchCriteria,
                 ro.finsiel.eunis.search.habitats.country.CountrySortCriteria,
                 java.util.Iterator,
                 java.util.List,
                 java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.country.CountryBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) {
    formBean.prepareFilterCriterias();
  }
  // Requets parameters
  boolean showLevel = Utilities.checkedStringToBoolean(formBean.getShowLevel(), AbstractFormBean.HIDE);
  boolean showCode = Utilities.checkedStringToBoolean(formBean.getShowCode(), AbstractFormBean.HIDE);
  boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), AbstractFormBean.HIDE);
  boolean showVernacularName = Utilities.checkedStringToBoolean(formBean.getShowVernacularName(), AbstractFormBean.HIDE);
  boolean showCountry = true;
  boolean showRegion = true;

  // Set number criteria for the search result
  int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);

  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), CountryDomain.SEARCH_EUNIS);
  // The main paginator
  CountryPaginator paginator = new CountryPaginator(new CountryDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), database));
  // Initialization
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  paginator.setSortCriteria(formBean.toSortCriteria());
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)

  // This is used in @page include...
  int resultsCount = paginator.countResults();

  String pageName = (String) request.getAttribute("javax.servlet.forward.request_uri");
  if (pageName == null || pageName.length()==0){
      pageName = request.getContextPath() + request.getServletPath();
  }

  int pagesCount = paginator.countPages();
  int guid = 0;
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);

  // Prepare parameters for tsvlink
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");

  String tsvLink = "javascript:openTSVDownload('reports/habitats/tsv-habitats-country.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,habitats_country_location#habitats-country.jsp,results";

%>
<stripes:layout-definition>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eea_search.css">

<%
    if (results.isEmpty()){
        %>
        <p>No habitat types found by this criteria!</p><%
    }
    else{ %>
	   <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td>
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <%AbstractSearchCriteria[] searchCriterias = formBean.toSearchCriteria();
                    int whoMuchCriteria = 0;
                    for (int i = 0; i < searchCriterias.length; i++) {
                      CountrySearchCriteria criteria = (CountrySearchCriteria) searchCriterias[i];
                      //System.out.println("criteria: " + criteria.isMainSearch());
                      if (null != criteria && criteria.isMainSearch()) {
                        whoMuchCriteria++;%>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("You searched for")%>
                      <strong>
                        <%=Utilities.getSourceHabitat(database, CountryDomain.SEARCH_ANNEX_I.intValue(), CountryDomain.SEARCH_BOTH.intValue())%>
                      </strong>
                      <%=cm.cmsPhrase("Habitat types")%>
                      <strong>
                        <%=criteria.toHumanString()%>
                      </strong>
                    </td>
                  </tr>
                  <%
                    }
                  %>
                  <%
                    }
                  %>
                </table>
                <%=cm.cmsPhrase("Results found")%>:&nbsp;<strong><%=resultsCount%></strong>
                <%// Prepare parameters for pagesize.jsp
                  Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
                  pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
                  pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
                  pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
                  pageSizeFormFields.addElement("oper");
                  pageSizeFormFields.addElement("criteriaType");
                  pageSizeFormFields.addElement("expand");
                %>
                <jsp:include page="../../pagesize.jsp">
                  <jsp:param name="guid" value="<%=guid%>" />
                  <jsp:param name="pageName" value="<%=pageName%>" />
                  <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>" />
                  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>" />
                </jsp:include>
                <br />
                <%// Prepare the form parameters.
                  Vector filterSearch = new Vector();
                  filterSearch.addElement("sort");
                  filterSearch.addElement("ascendency");
                  filterSearch.addElement("criteriaSearch");
                  filterSearch.addElement("oper");
                  filterSearch.addElement("criteriaType");
                  filterSearch.addElement("pageSize");
                  filterSearch.addElement("expand");%>
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <strong>
                        <%=cm.cmsPhrase("Refine your search")%>
                      </strong>
                    </td>
                  </tr>
                  <tr>
                    <td bgcolor="#EEEEEE">
                      <form name="resultSearch" method="get" onsubmit="return(checkHabitats(<%=noCriteria%>));" action="">
                        <%=formBean.toFORMParam(filterSearch)%>
                        <label for="criteriaType" class="noshow"><%=cm.cmsPhrase("Criteria")%></label>
                        <select title="Criteria" name="criteriaType" id="criteriaType">
                          <%
                            if (showCode && 0 == database.compareTo(CountryDomain.SEARCH_BOTH)) {
                          %>
                          <option value="<%=CountrySearchCriteria.CRITERIA_CODE_EUNIS%>"><%=cm.cms("eunis_code")%></option>
                          <option value="<%=CountrySearchCriteria.CRITERIA_CODE_ANNEX%>"><%=cm.cms("annex_code")%></option>
                          <%}%>
                          <%if (showCode && 0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {%>
                          <option value="<%=CountrySearchCriteria.CRITERIA_CODE_EUNIS%>"><%=cm.cms("eunis_code")%></option>
                          <%}%>
                          <%if (showCode && 0 == database.compareTo(CountryDomain.SEARCH_ANNEX_I)) {%>
                          <option value="<%=CountrySearchCriteria.CRITERIA_CODE_ANNEX%>"><%=cm.cms("annex_code")%></option>
                          <%}%>
                          <%if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS) && showLevel) {%>
                          <option value="<%=CountrySearchCriteria.CRITERIA_LEVEL%>"><%=cm.cms("generic_index_07")%></option><%}%>
                          <%if (showScientificName) {%>
                          <option value="<%=CountrySearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=cm.cms("habitat_type_name")%></option><%}%>
                          <%if (showVernacularName) {%>
                          <option value="<%=CountrySearchCriteria.CRITERIA_NAME%>"><%=cm.cms("habitat_type_english_name")%></option><%}%>
                        </select>
                        <%=cm.cmsInput("eunis_code")%>
                        <%=cm.cmsInput("annex_code")%>
                        <%=cm.cmsInput("generic_index_07")%>
                        <%=cm.cmsInput("habitat_type_name")%>
                        <%=cm.cmsInput("habitat_type_english_name")%>
                        <select title="Operator" name="oper" id="oper">
                          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cmsPhrase("is")%></option>
                          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=cm.cmsPhrase("starts with")%></option>
                          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                        </select>
                        <label for="criteriaSearch" class="noshow"><%=cm.cmsPhrase("Filter value")%></label>
                        <input title="<%=cm.cmsPhrase("Filter value")%>" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
                        <input title="<%=cm.cmsPhrase("Search")%>" class="submitSearchButton" type="submit" name="Submit" id="Submit" value="<%=cm.cmsPhrase("Search")%>" />
                      </form>
                    </td>
                  </tr>
                  <%-- This is the code which shows the search filters --%>
                  <%ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();%>
                  <%if (criterias.length > whoMuchCriteria) {%><tr>
                  <td bgcolor="#EEEEEE"><%=cm.cmsPhrase("Applied filters to the results")%>:</td></tr><%}%>
                  <%for (int i = criterias.length - 1; i > whoMuchCriteria - 1; i--) {%>
                  <%AbstractSearchCriteria criteria = criterias[i];%>
                  <%if (null != criteria && null != formBean.getCriteriaSearch()) {%>
                  <tr>
                    <td bgcolor="#CCCCCC">
                      <a title="<%=cm.cms("delete_filter")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i-whoMuchCriteria+1%>"><img src="images/mini/delete.jpg" alt="<%=cm.cms("delete_filter")%>" border="0" style="vertical-align:middle"></a>
                      <%=cm.cmsTitle("delete_filter")%>
                      &nbsp;&nbsp;
                      <strong><%= i + ". " + criteria.toHumanString()%></strong>
                    </td>
                  </tr>
                  <%}%>
                  <%}%>
                </table>
                <%
                  // Prepare parameters for navigator.jsp
                  Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
                  navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
                  navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
                  navigatorFormFields.addElement("ascendency");
                  navigatorFormFields.addElement("criteriaSearch");
                  navigatorFormFields.addElement("oper");
                  navigatorFormFields.addElement("criteriaType");
                  navigatorFormFields.addElement("expand");
                %>
                <jsp:include page="../../navigator.jsp">
                  <jsp:param name="pagesCount" value="<%=pagesCount%>" />
                  <jsp:param name="pageName" value="<%=pageName%>" />
                  <jsp:param name="guid" value="<%=guid%>" />
                  <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
                  <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
                  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
                </jsp:include>
                <%
                  // Compute the sort criteria
                  Vector sortURLFields = new Vector();      /* Used for sorting */
                  sortURLFields.addElement("pageSize");
                  sortURLFields.addElement("criteriaSearch");
                  sortURLFields.addElement("oper");
                  sortURLFields.addElement("criteriaType");
                  sortURLFields.addElement("currentPage");
                  sortURLFields.addElement("expand");
                  String urlSortString = formBean.toURLParam(sortURLFields);
                  AbstractSortCriteria levelCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_LEVEL);
                  AbstractSortCriteria eunisCodeCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_EUNIS_CODE);
                  AbstractSortCriteria annexCodeCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_ANNEX_CODE);
                  AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_SCIENTIFIC_NAME);
                  AbstractSortCriteria nameCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_VERNACULAR_NAME);
                %>
                <table class="sortable listing" width="100%" summary="<%=cm.cmsPhrase("Search results")%>">
                  <thead>
                    <tr>
                  <%
                    if (showCountry)
                    {
                  %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Country")%>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showRegion) {
                  %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Biogeographic region")%>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showLevel && 0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit))%>"><%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsPhrase("Level")%></a>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showCode) {
                  %>
                  <%
                    if (0 == database.compareTo(CountryDomain.SEARCH_BOTH)) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                      </th>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (0 == database.compareTo(CountryDomain.SEARCH_ANNEX_I)) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                      </th>
                  <%
                    }
                  %>
                  <%
                    }
                  %>
                  <%
                    if (showScientificName) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit))%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsPhrase("Habitat type name")%></a>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showVernacularName) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit))%>"><%=Utilities.getSortImageTag(nameCrit)%><%=cm.cmsPhrase("Habitat type english name")%></a>
                      </th>
                  <%
                    }
                  %>
                    </tr>
                  </thead>
                  <tbody>
                <%
                  // Display results
                  Iterator it = results.iterator();
                  int i = 0;
                  while (it.hasNext())
                  {
                    String cssClass = i++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                    CountryPersist habitat = (CountryPersist) it.next();
                    int level = habitat.getLevel().intValue();
                    String eunisCode = habitat.getEunisHabitatCode();
                    String annexCode = habitat.getCode2000();
                %>
                    <tr<%=cssClass%>>
                  <%
                    if (showCountry)
                    {
                  %>
                      <td>
                        <%=habitat.getCountry()%>
                      </td>
                  <%
                    }
                  %>
                  <%
                    if (showRegion)
                    {
                  %>
                      <td>
                        <%=habitat.getRegion()%>
                      </td>
                  <%
                    }
                  %>
                  <%
                    if (showLevel && 0 == database.compareTo(CountryDomain.SEARCH_EUNIS))
                    {
                  %>
                      <td style="white-space : nowrap">
                        <%for (int iter = 0; iter < level; iter++) {%>
                        <img alt="" src="images/mini/lev_blank.gif"><%}%><%=level%></td><%}%>
                  <%
                    if (showCode)
                    {
                  %>
                  <%
                      if (0 == database.compareTo(CountryDomain.SEARCH_BOTH))
                      {
                  %>
                      <td>
                        <%=eunisCode%>
                      </td>
                      <td>
                        <%=annexCode%>
                      </td>
                  <%
                      }
                  %>
                  <%
                      if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS))
                      {
                  %>
                      <td>
                        <%=eunisCode%>
                      </td>
                    <%
                      }
                    %>
                    <%
                      if (0 == database.compareTo(CountryDomain.SEARCH_ANNEX_I))
                      {
                    %>
                      <td>
                        <%=annexCode%>
                      </td>
                    <%
                      }
                    %>
                  <%
                    }
                  %>
                  <%
                    if (showScientificName)
                    {
                  %>
                      <td>
                        <a href="habitats/<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
                      </td>
                  <%
                    }
                    if (showVernacularName)
                    {
                  %>
                        <td>
                          <%=habitat.getDescription()%>
                        </td>
                  <%
                    }
                  %>
                    </tr>
                <%
                  }
                %>
                  </tbody>
                  <thead>
                    <tr>
                  <%
                    if (showCountry)
                    {
                  %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Country")%>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showRegion) {
                  %>
                      <th class="nosort" scope="col">
                        <%=cm.cmsPhrase("Biogeographic region")%>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showLevel && 0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit))%>"><%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsPhrase("Level")%></a>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showCode) {
                  %>
                  <%
                    if (0 == database.compareTo(CountryDomain.SEARCH_BOTH)) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                      </th>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (0 == database.compareTo(CountryDomain.SEARCH_ANNEX_I)) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                      </th>
                  <%
                    }
                  %>
                  <%
                    }
                  %>
                  <%
                    if (showScientificName) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit))%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsPhrase("Habitat type name")%></a>
                      </th>
                  <%
                    }
                  %>
                  <%
                    if (showVernacularName) {
                  %>
                      <th class="nosort" scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit))%>"><%=Utilities.getSortImageTag(nameCrit)%><%=cm.cmsPhrase("Habitat type english name")%></a>
                      </th>
                  <%
                    }
                  %>
                    </tr>
                  </thead>
                </table>
                </td>
                </tr>
                <tr>
                  <td>
                    <jsp:include page="../../navigator.jsp">
                      <jsp:param name="pagesCount" value="<%=pagesCount%>" />
                      <jsp:param name="pageName" value="<%=pageName%>" />
                      <jsp:param name="guid" value="<%=guid + 1%>" />
                      <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
                      <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
                      <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
                    </jsp:include>
                  </td>
                </tr>
                </table>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("habitats_country-result_title")%>
                  <%=cm.br()%>
    <%
    } // End else (if results found)
    %>
</stripes:layout-definition>
