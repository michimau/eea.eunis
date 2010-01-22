<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitat, show species' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 java.sql.Timestamp,
                 ro.finsiel.eunis.search.species.habitats.HabitateSearchCriteria,
                 ro.finsiel.eunis.search.species.habitats.HabitatePaginator,
                 ro.finsiel.eunis.search.species.habitats.HabitateSortCriteria,
                 ro.finsiel.eunis.jrfTables.species.habitats.*,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.search.species.habitats.HabitateBean,
                 ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtSpeciesPersist"%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtReportsPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.habitats.HabitateBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  // Requets parameters
  boolean showGroup = Utilities.checkedStringToBoolean(formBean.getShowGroup(), HabitateBean.HIDE);
  boolean showOrder = Utilities.checkedStringToBoolean(formBean.getShowOrder(), HabitateBean.HIDE);
  boolean showFamily = Utilities.checkedStringToBoolean(formBean.getShowFamily(), HabitateBean.HIDE);
  boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), true);
  boolean showVernacularNames = Utilities.checkedStringToBoolean(formBean.getShowVernacularNames(), HabitateBean.HIDE);

  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }

  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  HabitatePaginator paginator = null;
  Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), HabitateSearchCriteria.SEARCH_NAME);
  Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), HabitateSearchCriteria.SEARCH_NAME);
  // The main paginator
  paginator = new HabitatePaginator(new ScientificNameDomain(formBean.toSearchCriteria(),
                                                             formBean.toSortCriteria(),
                                                             SessionManager.getShowEUNISInvalidatedSpecies(),
                                                             searchAttribute,
                                                             database));
  // Initialisation
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "species-habitats-result.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  // Set number criteria for the search result
  int noCriteria = (null==formBean.getCriteriaSearch()? 0 :formBean.getCriteriaSearch().length);
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");

  String tsvLink = "javascript:openTSVDownload('reports/species/tsv-species-habitats.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,pick_habitat_type_show_species_location#species-habitats.jsp,results";
  if (results.isEmpty())
  {
    boolean fromRefine = formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0;
%>
      <jsp:forward page="emptyresults.jsp">
        <jsp:param name="location" value="<%=location%>" />
        <jsp:param name="fromRefine" value="<%=fromRefine%>" />
      </jsp:forward>
<%
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_habitats-result_title")%>
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
                  <jsp:param name="location" value="<%=location%>" />
                  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
                </jsp:include>
                <a name="documentContent"></a>
                <h1>
                 <%=cm.cmsPhrase("Pick habitat, show species")%>
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
                    <li>
                      <a href="habitats-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                         <%
                           String descr = formBean.getMainSearchCriteria().toHumanString();
                         %>
                        <tr>
                          <td>
                            <%=cm.cmsPhrase("You searched for species in habitat types with")%>
                            <strong>
                              <%=Utilities.treatURLAmp(descr)%>
                            </strong>
                          </td>
                        </tr>
                      </table>
                      <br />
                      <%=cm.cmsPhrase("Results found")%>:
                      <strong>
                          <%=resultsCount%>
                      </strong>
                      <%// Prepare parameters for pagesize.jsp
                        Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
                        pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
                        pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
                        pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
                      %>
                      <jsp:include page="pagesize.jsp">
                        <jsp:param name="guid" value="<%=guid%>" />
                        <jsp:param name="pageName" value="<%=pageName%>" />
                        <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>" />
                        <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>" />
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
                    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                      <tr>
                        <td>
                          <%=cm.cmsPhrase("Refine your search")%>
                        </td>
                      </tr>
                      <tr>
                        <td>
                            <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="" >
                              <%=formBean.toFORMParam(filterSearch)%>
                              <label for="select1" class="noshow"><%=cm.cms("criteria")%></label>
                                 <%
                                    if (!showGroup)
                                    {
                                 %>
                                <input type="hidden" name="criteriaType" value="<%=HabitateSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>"  />
                                <%
                                    }
                                %>
                              <select id="select1" title="<%=cm.cms("criteria")%>" name="criteriaType" <%=(showGroup ? "" : "disabled=\"disabled\"")%>>
                                <%
                                    if (showGroup)
                                    {
                                %>
                                      <option value="<%=HabitateSearchCriteria.CRITERIA_GROUP%>">
                                          <%=cm.cms("group")%>
                                      </option>
                                  <%
                                      }
                                  %>
                                <%
                                    if (showScientificName)
                                    {
                                %>
                                       <option value="<%=HabitateSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                                           <%=cm.cms("scientific_name")%>
                                       </option>
                                  <%
                                      }
                                  %>
                              </select>
                              <%=cm.cmsLabel("criteria")%>
                              <%=cm.cmsTitle("criteria")%>
                              <select id="select2" title="<%=cm.cms("operator")%>" name="oper">
                                <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                                    <%=cm.cms("is")%>
                                </option>
                                <option value="<%=Utilities.OPERATOR_STARTS%>">
                                    <%=cm.cms("starts_with")%>
                                </option>
                                <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                                    <%=cm.cms("contains")%>
                                </option>
                              </select>
                              <%=cm.cmsLabel("operator")%>
                              <%=cm.cmsTitle("operator")%>
                                <label for="criteriaSearch" class="noshow">
                                   <%=cm.cms("filter_value")%>
                                </label>
                              <input id="criteriaSearch" title="<%=cm.cms("filter_value")%>" alt="<%=cm.cms("filter_value")%>" name="criteriaSearch" type="text" size="30" />
                              <%=cm.cmsLabel("filter_value")%>
                              <%=cm.cmsTitle("filter_value")%>
                              <input id="refine" title="<%=cm.cms("search")%>" class="submitSearchButton" type="submit" name="Submit" value="<%=cm.cms("search")%>" />
                              <%=cm.cmsTitle("search")%>
                              <%=cm.cmsInput("search")%>
                            </form>
                          </td>
                        </tr>

                        <%-- This is the code which shows the search filters --%>
                        <%
                            ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
                            if (criterias.length > 1)
                            {
                        %>
                        <tr>
                          <td>
                            <%=cm.cmsPhrase("Applied filters to the results")%>:
                          </td>
                        </tr>
                        <%
                            }
                            for (int i = criterias.length - 1; i > 0; i--)
                            {
                              AbstractSearchCriteria criteria = criterias[i];
                              if (null != criteria && null != formBean.getCriteriaSearch())
                              {
                          %>
                            <tr>
                              <td>
                                <a title="<%=cm.cms("delete_criteria")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img alt="<%=cm.cms("delete_criteria")%>" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" /></a>
                                <%=cm.cmsTitle("delete_criteria")%>
                                &nbsp;&nbsp;
                                <strong class="linkDarkBg">
                                  <%= i + ". " + criteria.toHumanString()%>
                                </strong>
                              </td>
                            </tr>
                          <%
                              }
                            }
                        %>
                    </table>
                    <%
                      Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
                      navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
                      navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
                      navigatorFormFields.addElement("ascendency");
                      navigatorFormFields.addElement("criteriaSearch");
                    %>
                    <jsp:include page="navigator.jsp">
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
                        sortURLFields.addElement( "pageSize" );
                        sortURLFields.addElement( "criteriaSearch" );
                        String urlSortString = formBean.toURLParam( sortURLFields );
                        AbstractSortCriteria sortGroup = formBean.lookupSortCriteria( HabitateSortCriteria.SORT_GROUP );
                        AbstractSortCriteria sortOrder = formBean.lookupSortCriteria( HabitateSortCriteria.SORT_ORDER );
                        AbstractSortCriteria sortFamily = formBean.lookupSortCriteria( HabitateSortCriteria.SORT_FAMILY );
                        AbstractSortCriteria sortSciName = formBean.lookupSortCriteria( HabitateSortCriteria.SORT_SCIENTIFIC_NAME );

                        // Expand/Collapse vernacular names
                        Vector expand = new Vector();
                        expand.addElement( "sort" );
                        expand.addElement( "ascendency" );
                        expand.addElement( "criteriaSearch" );
                        expand.addElement( "oper" );
                        expand.addElement( "criteriaType" );
                        expand.addElement( "pageSize" );
                        expand.addElement( "currentPage" );
                        String expandURL = formBean.toURLParam( expand );
                        boolean isExpanded = ( null != formBean.getExpand() ) && formBean.getExpand().equalsIgnoreCase( "true" );
                        if ( showVernacularNames && !isExpanded )
                        {
                      %>
                          <a title="<%=cm.cms("show_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Display vernacular names")%></a>
                          <%=cm.cmsTitle("show_vernacular_list")%>
                      <%
                      }
                      %>
                      <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                      <thead>
                        <tr>
                        <%
                            if (showGroup)
                            {
                        %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitateSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, null == sortGroup)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsPhrase("Group")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                          <%
                              }
                            if (showOrder)
                            {
                        %>
                          <th scope="col">
                            <%=cm.cmsPhrase("Order")%>
                          </th>
                          <%
                              }
                            if (showFamily)
                            {
                        %>
                          <th scope="col">
                            <%=cm.cmsPhrase("Family")%>
                          </th>
                          <%
                              }
                            if (showScientificName)
                            {
                        %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitateSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, null == sortSciName)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsPhrase("Species scientific name")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                        <%
                            }
                            if (showVernacularNames && isExpanded)
                            {
                        %>
                          <th scope="col">
                            <a title="<%=cm.cms("hide_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Vernacular names")%>[<%=cm.cmsPhrase("Hide")%>]</a><%=cm.cmsTitle("hide_vernacular_list")%>
                         </th>
                        <%
                            }
                        %>
                          <th scope="col">
                            <%=cm.cmsPhrase("Habitat type(s)")%>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                      <%
                        if (null!=results)
                        {
                        for(int j = 0;j<results.size();j++)
                        {
                            String cssClass = j % 2 == 0 ? " class=\"zebraeven\"" : "";
                            ScientificNamePersist specie = (ScientificNamePersist)results.get(j);
                            Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
                            // Sort this vernacular names in alphabetical order
                            Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
                      %>
                        <tr<%=cssClass%>>
                              <%
                                  if (showGroup)
                                  {
                              %>
                          <td>
                            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getCommonName()),"&nbsp;")%>
                          </td>
                                <%
                                    }
                                  if (showOrder)
                                  {
                              %>
                          <td>
                            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameOrder()),"&nbsp;")%>
                          </td>
                                <%
                                    }
                                  if (showFamily)
                                  {
                              %>
                          <td>
                            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameFamily()),"&nbsp;")%>
                          </td>
                                <%
                                    }
                                %>
                              <%
                                  if (showScientificName)
                                  {
                              %>
                          <td>
                            <a href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                            <%=cm.cmsTitle("open_species_factsheet")%>
                          </td>
                              <%
                                  }
                                  if (showVernacularNames && isExpanded)
                                  {
                              %>
                          <td>
                            <table summary="layout" width="100%" border="1" cellspacing="0" cellpadding="0">
                                  <%
                                      for (int i = 0; i < sortVernList.size(); i++)
                                      {
                                        VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(i);
                                        String vernacularName = aVernName.getName();
                                        String bgColor = (0 == i%2) ? "#EEEEEE" : "#FFFFFF";
                                    %>
                                    <tr>
                                      <td style="background-color:<%=bgColor%>;text-align:left">
                                          &nbsp;
                                          <%=Utilities.treatURLSpecialCharacters(aVernName.getLanguage())%>
                                      </td>
                                      <td style="background-color:<%=bgColor%>;text-align:left">
                                          &nbsp;
                                          <%=Utilities.treatURLSpecialCharacters(vernacularName)%>
                                      </td>
                                    </tr>
                                  <%
                                      }
                                  %>
                            </table>
                          </td>
                              <%
                               }
                                Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
                                Integer idNatureObject = specie.getIdNatureObject();
                                List resultsHabitats = new ScientificNameDomain().findHabitatsWithSpecies(
                                    new HabitateSearchCriteria(
                                                                 searchAttribute,
                                                                 formBean.getScientificName(),
                                                                 relationOp),
                                                                 database,
                                                                 searchAttribute,
                                                                 idNatureObject,
                                                                 SessionManager.getShowEUNISInvalidatedSpecies());
                              %>
                          <td>
                              <%
                              if (resultsHabitats != null && resultsHabitats.size() > 0)
                              {
                                String SQL_DRV = application.getInitParameter("JDBC_DRV");
                                String SQL_URL = application.getInitParameter("JDBC_URL");
                                String SQL_USR = application.getInitParameter("JDBC_USR");
                                String SQL_PWD = application.getInitParameter("JDBC_PWD");

                                SQLUtilities sqlc = new SQLUtilities();
                                sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
                              %>
                            <table summary="<%=cm.cms("list_habitat_types")%>" border="1" cellspacing="0" cellpadding="0">
                              <%
                                for(int i=0;i<resultsHabitats.size();i++)
                                {
                                  String habitatName = Utilities.treatURLSpecialCharacters((String) resultsHabitats.get(i));
                                  String isGoodHabitat = " IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',RIGHT(CHM62EDT_HABITAT.CODE_2000,2),1) <> IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '','00',2) AND IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',LENGTH(CHM62EDT_HABITAT.CODE_2000),1) = IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',4,1) ";
                                  String idHabitat = (habitatName == null ? "-1" : sqlc.ExecuteSQL("SELECT ID_HABITAT FROM chm62edt_habitat WHERE   "+isGoodHabitat+" AND SCIENTIFIC_NAME='"+habitatName.replaceAll("'","''")+"'"));
                                %>
                                <tr>
                                  <td style="text-align:left">
                                    <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=idHabitat%>"><%=habitatName%></a>
                                    <%=cm.cmsTitle("open_habitat_factsheet")%>
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
                          </tr>
                          <%
                                  }
                        }
                          %>
                      </tbody>
                      <thead>
                        <tr>
                        <%
                            if (showGroup)
                            {
                        %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitateSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, null == sortGroup)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsPhrase("Group")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                          <%
                              }
                            if (showOrder)
                            {
                        %>
                          <th scope="col">
                            <%=cm.cmsPhrase("Order")%>
                          </th>
                          <%
                              }
                            if (showFamily)
                            {
                        %>
                          <th scope="col">
                            <%=cm.cmsPhrase("Family")%>
                          </th>
                          <%
                              }
                            if (showScientificName)
                            {
                        %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=HabitateSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, null == sortSciName)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsPhrase("Species scientific name")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                        <%
                            }
                            if (showVernacularNames && isExpanded)
                            {
                        %>
                          <th scope="col">
                            <a title="<%=cm.cms("hide_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Vernacular names")%>[<%=cm.cmsPhrase("Hide")%>]</a><%=cm.cmsTitle("hide_vernacular_list")%>
                         </th>
                        <%
                            }
                        %>
                          <th scope="col">
                            <%=cm.cmsPhrase("Habitat type(s)")%>
                          </th>
                        </tr>
                      </thead>
                    </table>
                    <jsp:include page="navigator.jsp">
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
                  <%=cm.cmsMsg("species_habitats-result_title")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("group")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("scientific_name")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("is")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("starts_with")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("contains")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("search_results")%>
                  <%=cm.br()%>
                  <%=cm.cmsMsg("list_habitat_types")%>
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
                <jsp:param name="page_name" value="species-habitats-result.jsp" />
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
