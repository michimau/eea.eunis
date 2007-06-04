<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species country' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.List,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Iterator,
                 java.util.Vector,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 net.sf.jrf.domain.PersistentObject,
                 ro.finsiel.eunis.search.species.country.CountryPaginator,
                 ro.finsiel.eunis.jrfTables.species.country.CountryRegionDomain,
                 ro.finsiel.eunis.jrfTables.species.country.RegionDomain,
                 ro.finsiel.eunis.jrfTables.species.country.CountryDomain,
                 ro.finsiel.eunis.jrfTables.species.country.CountryRegionPersist,
                 ro.finsiel.eunis.jrfTables.species.country.RegionPersist,
                 ro.finsiel.eunis.jrfTables.species.country.CountryPersist,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.search.save_criteria.SaveSearchCriteria,
                 ro.finsiel.eunis.search.save_criteria.SetVectorsForSaveCriteria"%>
<%@ page import="ro.finsiel.eunis.search.species.country.CountrySearchCriteria"%>
<%@ page import="ro.finsiel.eunis.search.species.country.CountrySortCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.country.CountryBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  // If user has right to save this search and he want to save it
  if (SessionManager.isAuthenticated() &&
      SessionManager.isSave_search_criteria_RIGHT() &&
      request.getParameter("saveCriteria")!= null &&
      request.getParameter("saveCriteria").equalsIgnoreCase("true")
      )
  {
    // Set database parameters
    String SQL_DRV="";
    String SQL_URL="";
    String SQL_USR="";
    String SQL_PWD="";

    SQL_DRV = application.getInitParameter("JDBC_DRV");
    SQL_URL = application.getInitParameter("JDBC_URL");
    SQL_USR = application.getInitParameter("JDBC_USR");
    SQL_PWD = application.getInitParameter("JDBC_PWD");

    // Description of this search
    String description = "";
    String pageName = "species-country.jsp";
    // values of database constants from specific class Domain(only in habitat searches, so here database vector is empty)
    Vector database = new Vector();
    // Create a new object SetVectorsForSaveCriteria
    SetVectorsForSaveCriteria setSaveParameters = new SetVectorsForSaveCriteria();
    // Set parameters for this save
    setSaveParameters.SetVectorsForSaveCriteriaSpeciesCountry(formBean.getCountry()[0],
                                    formBean.getRegion()[0],
                                    formBean.getCountryName(),
                                    formBean.getRegionName());
    // Save this search
    SaveSearchCriteria save = new SaveSearchCriteria(database,
                                                    4,
                                                    SessionManager.getUsername(),
                                                    description,
                                                    pageName,
                                                    setSaveParameters.getAttributesNames(),
                                                    setSaveParameters.getFormFieldAttributes(),
                                                    setSaveParameters.getFormFieldOperators(),
                                                    setSaveParameters.getBooleans(),
                                                    setSaveParameters.getOperators(),
                                                    setSaveParameters.getFirstValue(),
                                                    setSaveParameters.getLastValue(),
                                                    SQL_DRV,
                                                    SQL_URL,
                                                    SQL_USR,
                                                    SQL_PWD);
    save.SaveCriterias();

  }

  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }

  // Decide the type of search
  final String countryName = formBean.getCountryName();
  final String regionName = formBean.getRegionName();
  CountryPaginator paginator = null;
  // INIT THE PAGINATOR DEPENDING ON THE TYPE OF SEARCH
  // *a* country / *a* region
  if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any")) {
    paginator = new CountryPaginator(new CountryRegionDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), SessionManager.getShowEUNISInvalidatedSpecies()));
  }
  // *any* country / *a* region
  if (null != countryName && countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any")) {
    paginator = new CountryPaginator(new RegionDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), SessionManager.getShowEUNISInvalidatedSpecies()));
  }
  // *a* country / *any* region
  if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && regionName.equalsIgnoreCase("any")) {
    paginator = new CountryPaginator(new CountryDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), SessionManager.getShowEUNISInvalidatedSpecies()));
  }

  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));

  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)

  int resultsCount = paginator.countResults();
  final String pageName = "species-country-result.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);

  Vector reportFields = new Vector();
  reportFields.addElement("country"); /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
  reportFields.addElement("region");  /*   is overriden & also pageSize is set to default           */
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  reportFields.addElement("expand");

  // Set number criteria for the search result
  int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);
  String tsvLink = "javascript:openTSVDownload('reports/species/tsv-species-country.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,country_biogeographic_region_location#species-country.jsp,results";
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
      <%=cm.cms("species_country-result_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        var errRefineMessage = "<%=cm.cms("enter_refine_criteria_correctly")%>.";
        // Used in refine search ; check if criteria are empty
        function checkRefineSearch(noCriteria)
        {
          if(noCriteria == 0)
          {
            Name = trim(document.resultSearch.criteriaSearch.value);
            if (Name == "")
            {
              alert(errRefineMessage);
              return false;
            } else {
              return true;
            }
          } else {
            isSomeoneEmplty = 0;
            for (i = 0; i <= noCriteria; i++)
            {
              if (trim(document.resultSearch.criteriaSearch[i].value) == "")
              {
                isSomeoneEmplty = 1;
              }
            }
            if (isSomeoneEmplty == 1)
            {
              alert(errRefineMessage);
              return false;
            } else {
              return true;
            }
          }
        }
       //]]>
    </script>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
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
                  <jsp:param name="helpLink" value="species-help.jsp"/>
                  <jsp:param name="downloadLink" value="<%=tsvLink%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
            <%--      <jsp:param name="printLink" value="<%=pdfLink%>"/>--%>
                <h1>
                    <%=cm.cmsText("species_country-result_01")%>
                </h1>
               <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
                    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>
                          <%=cm.cmsText("species_country-result_03")%>
                          <strong><%=Utilities.treatURLAmp(formBean.getRegionName())%></strong>
                          <%=cm.cmsText("species_country-result_04")%>
                          <strong><%=Utilities.treatURLAmp(formBean.getCountryName())%></strong>
                        </td>
                      </tr>
                    </table>
                    <br />
                    <%=cm.cmsText("results_found_1")%>: <strong><%=resultsCount%></strong>
                    <%// Prepare parameters for pagesize.jsp
                      Vector pageSizeFormFields = new Vector(); /*  These fields are used by pagesize.jsp, included below.    */
                      pageSizeFormFields.addElement("country"); /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
                      pageSizeFormFields.addElement("region");  /*   is overriden & also pageSize is set to default           */
                      pageSizeFormFields.addElement("sort");    /*   to page '0' aka first page. */
                      pageSizeFormFields.addElement("ascendency");
                      pageSizeFormFields.addElement("criteriaSearch");
                      pageSizeFormFields.addElement("oper");
                      pageSizeFormFields.addElement("criteriaType");
                      pageSizeFormFields.addElement("expand");
                    %>
                    <jsp:include page="pagesize.jsp">
                      <jsp:param name="guid" value="<%=guid%>"/>
                      <jsp:param name="pageName" value="<%=pageName%>"/>
                      <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>"/>
                      <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>"/>
                    </jsp:include>
                    <%// Prepare the form parameters.
                      Vector filterSearch = new Vector();
                      filterSearch.addElement("country");
                      filterSearch.addElement("region");
                      filterSearch.addElement("sort");
                      filterSearch.addElement("ascendency");
                      filterSearch.addElement("criteriaSearch");
                      filterSearch.addElement("oper");
                      filterSearch.addElement("criteriaType");
                      filterSearch.addElement("pageSize");
                      filterSearch.addElement("expand");
                    %>
                    <br />
                    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td style="background-color:#EEEEEE">
                          <strong>
                            <%=cm.cmsText("refine_your_search")%>
                          </strong>
                        </td>
                      </tr>
                      <tr>
                        <td style="background-color:#EEEEEE">
                          <form name="resultSearch" method="get" onsubmit="return(checkRefineSearch(<%=noCriteria%>));" action="">
                          <%=formBean.toFORMParam(filterSearch)%>
                            <label for="select1" class="noshow"><%=cm.cms("criteria")%></label>
                            <select id="select1" title="<%=cm.cms("criteria")%>" name="criteriaType">
                              <option value="<%=CountrySearchCriteria.CRITERIA_GROUP%>">
                                  <%=cm.cms("group")%>
                              </option>
            <%--                  <option value="<%=CountrySearchCriteria.CRITERIA_ORDER%>"><%=cm.cms("order_column")%></option>--%>
            <%--                  <option value="<%=CountrySearchCriteria.CRITERIA_FAMILY%>"><%=cm.cms("family")%></option>--%>
                              <option value="<%=CountrySearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                                  <%=cm.cms("scientific_name")%>
                              </option>
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
                            <input id="search" title="<%=cm.cms("search")%>" class="searchButton" type="submit" name="Submit" value="<%=cm.cms("search")%>" />
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
                            <td style="background-color:#EEEEEE">
                                <%=cm.cmsText("applied_filters_to_the_results")%>:
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
                              <td style="background-color:#CCCCCC;text-align:left">
                                  <a title="<%=cm.cms("delete_criteria")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img alt="<%=cm.cms("delete_criteria")%>" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" /></a>
                                  <%=cm.cmsTitle("delete_criteria")%>
                                  &nbsp;&nbsp;
                                  <strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
                              </td>
                          </tr>
                        <%
                            }
                          }
                      %>
                    </table>
                    <%
                      Vector navigatorFormFields = new Vector(); /*  The following fields are used by paginator.jsp, included below.      */
                      navigatorFormFields.addElement("country"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
                      navigatorFormFields.addElement("region");  /* <form name='..."> in the navigator.jsp!                               */
                      navigatorFormFields.addElement("pageSize");
                      navigatorFormFields.addElement("sort");
                      navigatorFormFields.addElement("ascendency");
                      navigatorFormFields.addElement("criteriaSearch");
                      navigatorFormFields.addElement("oper");
                      navigatorFormFields.addElement("criteriaType");
                      navigatorFormFields.addElement("expand");
                    %>
                  <jsp:include page="navigator.jsp">
                    <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
                    <jsp:param name="pageName" value="<%=pageName%>"/>
                    <jsp:param name="guid" value="<%=guid%>"/>
                    <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
                    <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
                    <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
                  </jsp:include>
                    <%// Expand/Collapse vernacular names
                      Vector expand = new Vector();
                      expand.addElement("country"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
                      expand.addElement("region");  /* <form name='..."> in the navigator.jsp!                               */
                      expand.addElement("pageSize");
                      expand.addElement("sort");
                      expand.addElement("ascendency");
                      expand.addElement("criteriaSearch");
                      expand.addElement("oper");
                      expand.addElement("criteriaType");
                      String expandURL = formBean.toURLParam(expand);
                      boolean isExpanded = (null == formBean.getExpand()) ? false : (formBean.getExpand().equalsIgnoreCase("true")) ? true : false;
                      if (!isExpanded)
                      {
                    %>
                         <a title="<%=cm.cms("species_country-result_24_Title")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsText("display_vernacular_names_in_results")%></a>
                         <%=cm.cmsTitle("species_country-result_24_Title")%>
                    <%
                      }
                      // Compute the sort criteria
                      Vector sortURLFields = new Vector();      /* Used for sorting */
                      sortURLFields.addElement("country");
                      sortURLFields.addElement("region");
                      sortURLFields.addElement("pageSize");
                      sortURLFields.addElement("criteriaSearch");
                      sortURLFields.addElement("oper");
                      sortURLFields.addElement("criteriaType");
                      sortURLFields.addElement("currentPage");
                      sortURLFields.addElement("expand");
                      String urlSortString = formBean.toURLParam(sortURLFields);

                      AbstractSortCriteria groupCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_GROUP);
                      //AbstractSortCriteria orderCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_ORDER);
                      //AbstractSortCriteria familyCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_FAMILY);
                      AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_SCIENTIFIC_NAME);
                    %>
                    <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                      <thead>
                        <tr>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_by_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(groupCrit, (null == groupCrit))%>"><%=Utilities.getSortImageTag(groupCrit)%>
                                <%=cm.cmsText("group")%>
                            </a>
                            <%=cm.cmsTitle("sort_by_column")%>
                          </th>
                          <th scope="col">
                            <%=cm.cmsText("country")%>
                          </th>
                          <th scope="col">
                            <%=cm.cmsText("biogeoregion")%>
                          </th>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_by_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit)) %>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("scientific_name")%></a>
                            <%=cm.cmsTitle("sort_by_column")%>
                          </th>
            <%
                        if (isExpanded)
                        {
            %>
                          <th scope="col">
                            <a title="<%=cm.cms("species_country-result_17_Title")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsText("vernacular_names")%>[<%=cm.cmsText("hide")%>]</a>
                            <%=cm.cmsTitle("species_country-result_17_Title")%>
                          </th>
            <%
                        }
            %>
                        </tr>
                      </thead>
                      <tbody>
            <%
                        Iterator it = results.iterator();
                        int col = 0;
                        while (it.hasNext())
                        {
                          String bgColor = col++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF";
                          PersistentObject specie = (PersistentObject)it.next();
                          Vector vernNamesList = new Vector();
                          // FIND VERNACULAR NAMES DEPENDING ON THE TYPE OF SEARCH
                          // *a* country / *a* region
                          if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any")) {
                            vernNamesList = SpeciesSearchUtility.findVernacularNames(((CountryRegionPersist)specie).getIdNatureObject());
                          }
                          // *any* country / *a* region
                          if (null != countryName && countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any")) {
                            vernNamesList = SpeciesSearchUtility.findVernacularNames(((RegionPersist)specie).getIdNatureObjectRep());
                          }
                          // *a* country / *any* region
                          if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && regionName.equalsIgnoreCase("any")) {
                            vernNamesList = SpeciesSearchUtility.findVernacularNames(((CountryPersist)specie).getIdNatureObjectRep());
                          }
                          // Sort this vernacular names in alphabetical order
                          Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
            %>
                        <tr>
            <%
                          // GROUP
                          // *a* country / *a* region
                          if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))
                          {
            %>
                          <td>
                            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(((CountryRegionPersist)specie).getCommonName()),"&nbsp;")%>
                          </td>
            <%
                          }
                          // *any* country / *a* region
                          if (null != countryName && countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))
                          {
            %>
                          <td>
                            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(((RegionPersist)specie).getCommonName()),"&nbsp;")%>
                          </td>
            <%
                          }
                          // *a* country / *any* region
                          if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && regionName.equalsIgnoreCase("any"))
                          {
            %>
                          <td>
                            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(((CountryPersist)specie).getCommonName()),"&nbsp;")%>
                          </td>
            <%
                          }
            %>
            <%--              // ORDER--%>
            <%--              // *a* country / *a* region--%>
            <%--              if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))--%>
            <%--              {--%>
            <%--%>--%>
            <%--              <td width="15%">--%>
            <%--                <%=Utilities.formatString(((CountryRegionPersist)specie).getTaxonomicNameOrder(),"&nbsp;")%>--%>
            <%--              </td>--%>
            <%--<%--%>
            <%--              }--%>
            <%--              // *any* country / *a* region--%>
            <%--              if (null != countryName && countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))--%>
            <%--              {--%>
            <%--%>--%>
            <%--              <td width="15%">--%>
            <%--                <%=Utilities.formatString(((RegionPersist)specie).getTaxonomicNameOrder(),"&nbsp;")%>--%>
            <%--              </td>--%>
            <%--<%--%>
            <%--              }--%>
            <%--              // *a* country / *any* region--%>
            <%--              if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && regionName.equalsIgnoreCase("any"))--%>
            <%--              {--%>
            <%--%>--%>
            <%--              <td width="15%">--%>
            <%--                <%=Utilities.formatString(((CountryPersist)specie).getTaxonomicNameOrder(),"&nbsp;")%>--%>
            <%--              </td>--%>
            <%--<%--%>
            <%--              }--%>
            <%
                          //Country
                          if (null != countryName)
                          {
            %>
                          <td>
                            <%=Utilities.treatURLSpecialCharacters(countryName)%>
                          </td>
            <%
                          } else {
            %>
                          <td>
                            &nbsp;
                          </td>
            <%
                          }
                          //Region
                          if (null != regionName)
                          {
            %>
                          <td>
                            <%=Utilities.treatURLSpecialCharacters(regionName)%>
                          </td>
            <%
                          } else {
            %>
                          <td>
                            &nbsp;
                          </td>
            <%
                          }
            %>
            <%--              // FAMILY--%>
            <%--              // *a* country / *a* region--%>
            <%--              if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))--%>
            <%--              {--%>
            <%--              String familyName = (((CountryRegionPersist)specie).getTaxonomicLevel()!=null&&((CountryRegionPersist)specie).getTaxonomicLevel().equalsIgnoreCase("family") ? (((CountryRegionPersist)specie).getTaxonomicNameFamily()!=null&&!((CountryRegionPersist)specie).getTaxonomicNameFamily().equalsIgnoreCase("null")?((CountryRegionPersist)specie).getTaxonomicNameFamily():"") : "");--%>
            <%--%>--%>
            <%--              <td width="15%">--%>
            <%--                <%=familyName%>--%>
            <%--              </td>--%>
            <%--<%--%>
            <%--              }--%>
            <%--              // *any* country / *a* region--%>
            <%--              if (null != countryName && countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any")) {--%>
            <%--              String familyName = (((RegionPersist)specie).getTaxonomicLevel()!=null&&((RegionPersist)specie).getTaxonomicLevel().equalsIgnoreCase("family") ? (((RegionPersist)specie).getTaxonomicNameFamily()!=null&&!((RegionPersist)specie).getTaxonomicNameFamily().equalsIgnoreCase("null")?((RegionPersist)specie).getTaxonomicNameFamily():"") : "");--%>
            <%--%>--%>
            <%--              <td width="15%">--%>
            <%--                <%=familyName%>--%>
            <%--              </td>--%>
            <%--<%--%>
            <%--              }--%>
            <%--              // *a* country / *any* region--%>
            <%--              if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && regionName.equalsIgnoreCase("any"))--%>
            <%--              {--%>
            <%--%>--%>
            <%--              <td width="15%">--%>
            <%--                <%=Utilities.formatString(((CountryPersist)specie).getTaxonomicNameFamily(),"&nbsp;")%>--%>
            <%--              </td>--%>
            <%
                          // SCIENTIFIC NAME
                          // *a* country / *a* region
                          if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))
                          {
            %>
                          <td>
                            <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=((CountryRegionPersist)specie).getIdSpecies()%>&amp;idSpeciesLink=<%=((CountryRegionPersist)specie).getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(((CountryRegionPersist)specie).getScientificName())%></a>
                          </td>
            <%
                          }
                          // *any* country / *a* region
                          if (null != countryName && countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))
                          {
            %>
                          <td>
                            <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=((RegionPersist)specie).getIdSpecies()%>&amp;idSpeciesLink=<%=((RegionPersist)specie).getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(((RegionPersist)specie).getScientificName())%></a>
                          </td>
            <%
                          }
                          // *a* country / *any* region
                          if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && regionName.equalsIgnoreCase("any"))
                          {
            %>
                          <td>
                            <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=((CountryPersist)specie).getIdSpecies()%>&amp;idSpeciesLink=<%=((CountryPersist)specie).getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(((CountryPersist)specie).getScientificName())%></a>
                          </td>
            <%
                          }
                          if (isExpanded)
                          {
            %>
                          <td>
                            <table summary="List of vernacular names" width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align:center">
            <%                  if(sortVernList == null || sortVernList.size()<=0)
                                 {
            %>
                                <tr><td>&nbsp;</td></tr>
            <%
                               }
                               else
                               {
                                for (int i = 0; i < sortVernList.size(); i++)
                                {
                                  VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(i);
                                  String vernacularName = aVernName.getName();
                                  String bgColor1 = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
            %>
                              <tr>
                                <td>
                                  <%=Utilities.treatURLSpecialCharacters(aVernName.getLanguage())%>
                                </td>
                                <td>
                                  <%=Utilities.treatURLSpecialCharacters(vernacularName)%>
                                </td>
                              </tr>
            <%
                              }
                            }
            %>
                            </table>
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
                        <th scope="col">
                          <a title="<%=cm.cms("sort_by_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(groupCrit, (null == groupCrit))%>"><%=Utilities.getSortImageTag(groupCrit)%>
                              <%=cm.cmsText("group")%>
                          </a>
                          <%=cm.cmsTitle("sort_by_column")%>
                        </th>
            <%--          <th>--%>
            <%--            <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_ORDER%>&amp;ascendency=<%=formBean.changeAscendency(orderCrit, (null == orderCrit) ? true : false)%>"><%=Utilities.getSortImageTag(orderCrit)%><%=cm.cms("order_column")%></a>--%>
            <%--          </th>--%>
            <%--          <th>--%>
            <%--            <a href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_FAMILY%>&amp;ascendency=<%=formBean.changeAscendency(familyCrit, (null == familyCrit) ? true : false)%>"><%=Utilities.getSortImageTag(familyCrit)%><%=cm.cms("family")%></a>--%>
            <%--          </th>--%>
                        <th scope="col">
                          <%=cm.cmsText("country")%>
                        </th>
                        <th scope="col">
                          <%=cm.cmsText("biogeoregion")%>
                        </th>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_by_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit)) %>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("scientific_name")%></a>
                          <%=cm.cmsTitle("sort_by_column")%>
                        </th>
            <%
                        if (isExpanded)
                        {
            %>
                        <th scope="col">
                          <a title="<%=cm.cms("species_country-result_17_Title")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsText("vernacular_names")%>[<%=cm.cmsText("hide")%>]</a>
                          <%=cm.cmsTitle("species_country-result_17_Title")%>]
                        </th>
            <%
                        }
            %>
                      </tr>
                    </thead>
                  </table>
                  <br />
                  <jsp:include page="navigator.jsp">
                    <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
                    <jsp:param name="pageName" value="<%=pageName%>"/>
                    <jsp:param name="guid" value="<%=guid + 1%>"/>
                    <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
                    <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
                    <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
                  </jsp:include>
                </td>
              </tr>
            </table>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_country-result_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("enter_refine_criteria_correctly")%>
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
                <%=cm.cmsMsg("table_of_results")%>
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
                <jsp:param name="page_name" value="species-country-result.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
