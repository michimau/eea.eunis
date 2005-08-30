<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species International threat status' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html"%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.species.internationalthreatstatus.*,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.jrfTables.species.internationalthreatstatus.InternationalThreatStatusDomain,
                 ro.finsiel.eunis.jrfTables.species.internationalthreatstatus.InternationalThreatStatusPersist,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.search.save_criteria.SaveSearchCriteria,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.save_criteria.SetVectorsForSaveCriteria"%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.internationalthreatstatus.InternationalthreatstatusBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
<%
   String idGroup = (formBean.getIdGroup() == null ? "" : formBean.getIdGroup());
   // If user has right to save this search and he want to save it
     if (SessionManager.isAuthenticated() &&
         SessionManager.isSave_search_criteria_RIGHT() &&
         request.getParameter("saveCriteria")!= null &&
         request.getParameter("saveCriteria").equalsIgnoreCase("true")
         )
     {
       String SQL_DRV = application.getInitParameter("JDBC_DRV");
       String SQL_URL = application.getInitParameter("JDBC_URL");
       String SQL_USR = application.getInitParameter("JDBC_USR");
       String SQL_PWD = application.getInitParameter("JDBC_PWD");

  // Description of this search
  String description = "";
  String pageName = "species-threat-international.jsp";
  // values of database constants from specific class Domain(only in habitat searches, so here database vector is empty)
  Vector database = new Vector();
  // Request parameters
  String nameGroup = (request.getParameter("groupName") == null ? "" : request.getParameter("groupName"));
  String nameCountry = (request.getParameter("countryName") == null ? "" : request.getParameter("countryName"));
  String nameStatus = (request.getParameter("statusName") == null ? "" : request.getParameter("statusName"));
  // Create a new object SetVectorsForSaveCriteria
  SetVectorsForSaveCriteria setSaveParameters = new SetVectorsForSaveCriteria();
  // Set parameters for this save
  setSaveParameters.SetVectorsForSaveCriteriaSpeciesThreatInternational(formBean.getIdGroup(),
                                              formBean.getIdConservation(),
                                              formBean.getIdCountry(),
                                              formBean.getIndice().toString(),
                                              nameGroup,
                                              nameStatus,
                                              nameCountry);
 // Save this search
 SaveSearchCriteria save = new SaveSearchCriteria(database,
                                                 7,
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

  // Check columns to be displayed
  boolean showStatus = Utilities.checkedStringToBoolean(formBean.getShowStatus(), InternationalthreatstatusBean.HIDE);
  boolean showGeo = Utilities.checkedStringToBoolean(formBean.getShowGeo(), InternationalthreatstatusBean.HIDE);
  boolean showGroup = Utilities.checkedStringToBoolean(formBean.getShowGroup(), InternationalthreatstatusBean.HIDE);
  boolean showOrder = Utilities.checkedStringToBoolean(formBean.getShowOrder(), InternationalthreatstatusBean.HIDE);
  boolean showFamily = Utilities.checkedStringToBoolean(formBean.getShowFamily(), InternationalthreatstatusBean.HIDE);
  boolean showVernacularNames = Utilities.checkedStringToBoolean(formBean.getShowVernacularNames(), InternationalthreatstatusBean.HIDE);

  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  InternationalthreatstatusPaginator paginator = null;
  paginator = new InternationalthreatstatusPaginator(new InternationalThreatStatusDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(),SessionManager.getShowEUNISInvalidatedSpecies()));

  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "species-threat-international-result.jsp";
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
  String tsvLink = "javascript:openlink('reports/species/tsv-species-threat-international.jsp?" + formBean.toURLParam(reportFields) + "')";
%>
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_threat-international-result_title", false )%>
    </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,International threat status#species-threat-international.jsp,Results" />
      <jsp:param name="helpLink" value="species-help.jsp" />
      <jsp:param name="downloadLink" value="<%=tsvLink%>" />
    </jsp:include>
<%--      <jsp:param name="printLink" value="<%=pdfLink%>"/>--%>

    <h5>
      <%=contentManagement.getContent("species_threat-international-result_01")%>
    </h5>
    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
            <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
               <% // Description of this search
                 String descr = formBean.getStringMain();
               %>
              <tr>
                <td>
                  <%=contentManagement.getContent("species_threat-international-result_02")%>
                  <strong>
                  <%=Utilities.treatURLAmp(descr)%>
                  </strong>    
                </td>
              </tr>
            </table>
<%
    if (results.isEmpty())
    {
       boolean fromRefine = false;
       if(formBean != null && formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0)
         fromRefine = true;

      %>
       <jsp:include page="noresults.jsp" >
         <jsp:param name="fromRefine" value="<%=fromRefine%>" />
       </jsp:include>
       <%
         return;
     }
       %>
          <br />
          <%=contentManagement.getContent("species_threat-international-result_03")%>: <strong><%=resultsCount%></strong>
          <%
            // Prepare parameters for pagesize.jsp
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
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td style="background-color:#EEEEEE">
                <%=contentManagement.getContent("species_threat-international-result_04")%>
            </td>
          </tr>
          <tr>
            <td style="background-color:#EEEEEE">
              <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="" >
              <%=formBean.toFORMParam(filterSearch)%>
                <label for="select1" class="noshow">Criteria</label>
                  <%
                      if (!showGroup || !idGroup.equalsIgnoreCase("-1"))
                      {
                  %>
                        <input type="hidden" name="criteriaType" value="<%=InternationalthreatstatusSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" />
                  <%
                      }
                  %>

                <select id="select1" title="Criteria" name="criteriaType" class="inputTextField" <%=(showGroup && idGroup.equalsIgnoreCase("-1") ? "" : "disabled=\"disabled\"")%>>
                  <%
                      if (showGroup && idGroup.equalsIgnoreCase("-1"))
                      {
                  %>
                    <option value="<%=InternationalthreatstatusSearchCriteria.CRITERIA_GROUP%>">
                        Group
                    </option>
                    <%
                        }
                  %>
                  <option value="<%=InternationalthreatstatusSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                      Scientific name
                  </option>
                </select>
                <label for="select2" class="noshow">Operator</label>
                <select id="select2" title="Operator" name="oper" class="inputTextField">
                  <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                      <%=contentManagement.getContent("species_threat-international-result_05", false)%>
                  </option>
                  <option value="<%=Utilities.OPERATOR_STARTS%>">
                      <%=contentManagement.getContent("species_threat-international-result_06", false)%>
                  </option>
                  <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                      <%=contentManagement.getContent("species_threat-international-result_07", false)%>
                  </option>
                </select>
                <label for="criteriaSearch" class="noshow">Criteria value</label>
                <input id="criteriaSearch" title="Criteria value" alt="Criteria value" class="inputTextField" name="criteriaSearch" type="text" size="30" />
                <label for="refine" class="noshow">Search</label>
                <input id="refine" title="Search" class="inputTextField" type="submit" name="Submit" value="<%=contentManagement.getContent("species_threat-international-result_08", false )%>" />
                <%=contentManagement.writeEditTag( "species_threat-international-result_08" )%>
              </form>
            </td>
          </tr>
          <%-- This is the code which shows the search filters --%>
          <%
            ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
          %>
          <%
            if (criterias.length > 1)
            {
          %>
          <tr>
            <td style="background-color:#EEEEEE">
              <%=contentManagement.getContent("species_threat-international-result_09")%>:
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
                  <a title="Delete this search criteria" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img alt="Delete" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" /></a>&nbsp;&nbsp;<strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
                </td>
              </tr>
            <%
              }
            }
          %>
      </table>
      <br />
      <%
        // Prepare parameters for navigator.jsp
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
      <br />
<%
      // Compute the sort criteria
      Vector sortURLFields = new Vector();      /* Used for sorting */
      sortURLFields.addElement("pageSize");
      sortURLFields.addElement("criteriaSearch");
      String urlSortString = formBean.toURLParam(sortURLFields);
      AbstractSortCriteria sortGroup = formBean.lookupSortCriteria(InternationalthreatstatusSortCriteria.SORT_GROUP);
      AbstractSortCriteria sortOrder = formBean.lookupSortCriteria(InternationalthreatstatusSortCriteria.SORT_ORDER);
      AbstractSortCriteria sortFamily = formBean.lookupSortCriteria(InternationalthreatstatusSortCriteria.SORT_FAMILY);
      AbstractSortCriteria sortSciName = formBean.lookupSortCriteria(InternationalthreatstatusSortCriteria.SORT_SCIENTIFIC_NAME);

      // Expand/Collapse vernacular names
      Vector expand = new Vector();
      expand.addElement("sort");
      expand.addElement("ascendency");
      expand.addElement("criteriaSearch");
      expand.addElement("oper");
      expand.addElement("criteriaType");
      expand.addElement("pageSize");
      expand.addElement("currentPage");
      String expandURL = formBean.toURLParam(expand);
      boolean isExpanded = (null == formBean.getExpand()) ? false : (formBean.getExpand().equalsIgnoreCase("true")) ? true : false;
      if (showVernacularNames && !isExpanded)
      {
%>
        <a title="Show vernacular names list" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=contentManagement.getContent("species_threat-international-result_10")%></a>
<%
      }
%>
      <table summary="List of results" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;text-align:left">
        <tr>
<%
      if (showGroup && idGroup.equalsIgnoreCase("-1"))
        {
%>
          <th style="text-align:left" class="resultHeader">
            <a title="Sort results by this column" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=InternationalthreatstatusSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=contentManagement.getContent("species_threat-international-result_11")%></a>
          </th>
<%
        } else {
%>
        <th style="text-align:left" class="resultHeader">
          <%=contentManagement.getContent("species_threat-international-result_11")%>
        </th>
<%
        }
        if (showGeo)
        {
%>
          <th style="text-align:left" class="resultHeader">
            <strong>
                <%=contentManagement.getContent("species_threat-international-result_geoTh")%>
            </strong>
          </th>
<%
        }
        if (showStatus)
        {
%>
          <th style="text-align:left" class="resultHeader">
            <strong>
                <%=contentManagement.getContent("species_threat-international-result_statusTh")%>
            </strong>
          </th>
<%
        }
        if (showOrder)
        {
%>
          <th style="text-align:left" class="resultHeader">
            <%=contentManagement.getContent("species_threat-international-result_12")%>
          </th>
<%
        }
        if (showFamily)
        {
%>
          <th style="text-align:left" class="resultHeader">
            <%=contentManagement.getContent("species_threat-international-result_13")%>
          </th>
<%
        }
%>
          <th style="text-align:left" class="resultHeader">
            <a title="Sort results by this column" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=InternationalthreatstatusSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=contentManagement.getContent("species_threat-international-result_14")%></a>
          </th>
<%
        if (isExpanded && showVernacularNames)
        {
%>
          <th style="text-align:left" class="resultHeader">
            <%=contentManagement.getContent("species_threat-international-result_15")%>
            &nbsp;
            [<a title="Hide vernacular names list" class="resultHeaderLink" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=contentManagement.getContent("species_threat-international-result_16")%></a>]
          </th>
<%
        }
%>
        </tr>
<%
      if ( null != results )
      {
        Iterator it = results.iterator();
        while (it.hasNext())
        {
          InternationalThreatStatusPersist specie = (InternationalThreatStatusPersist)it.next();
          Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
          // Sort this vernacular names in alphabetical order
          Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
%>
        <tr>
<%
         if (showGroup)
          {
%>
          <td style="text-align:left" class="resultCell">
            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getCommonName()),"&nbsp;")%>
          </td>
<%
          }
    if (showGeo)
    {
%>
    <td style="text-align:left" class="resultCell">
            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getAreaNameEn()),"&nbsp;")%>
    </td>
<%
    }

          if (showStatus)
          {
%>
          <td style="text-align:left" class="resultCell">
            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getDefAbrev()),"&nbsp;")%>
          </td>
<%
          }
          if (showOrder)
          {
%>
          <td style="text-align:left" class="resultCell">
            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameOrder()),"&nbsp;")%>
          </td>
<%
          }
          if (showFamily)
          {
%>
          <td style="text-align:left" class="resultCell">
            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameFamily()),"&nbsp;")%>
          </td>
<%
          }
%>
          <td class="resultCell">
            <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScName())%></a>&nbsp;
          </td>
<%
          if (isExpanded && showVernacularNames)
          {
%>
          <td>
            <table summary="List of vernacular names" width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align:center">
<%               if(sortVernList == null || sortVernList.size()<=0)
                  {
%>
                 <tr><td>&nbsp;</td></tr>
<%
        } else
        {
            for (int i = 0; i < sortVernList.size(); i++)
            {
               VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(i);
               String bgColor = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
%>
              <tr style="text-align:left">
                <td style="white-space: nowrap;background-color:<%=bgColor%>;text-align:left" width="50%">
                  <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(aVernName.getLanguage()),"&nbsp;")%>
                </td>
                <td style="white-space: nowrap;background-color:#DDDDDD;text-align:left" width="50%">
                  <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(aVernName.getName()),"&nbsp;")%>
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
      }
%>
      <tr>
<%
      if (showGroup && idGroup.equalsIgnoreCase("-1"))
        {
%>
          <th style="text-align:left" class="resultHeader">
            <a title="Sort results by this column" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=InternationalthreatstatusSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=contentManagement.getContent("species_threat-international-result_11")%></a>
          </th>
<%
        } else {
%>
        <th style="text-align:left" class="resultHeader">
          <%=contentManagement.getContent("species_threat-international-result_11")%>
        </th>
<%
        }
        if (showGeo)
        {
%>
          <th style="text-align:left" class="resultHeader">
            <strong>
                <%=contentManagement.getContent("species_threat-international-result_geoTh")%>
            </strong>
          </th>
<%
        }
        if (showStatus)
        {
%>
          <th style="text-align:left" class="resultHeader">
            <strong>
                <%=contentManagement.getContent("species_threat-international-result_statusTh")%>
            </strong>
          </th>
<%
        }
        if (showOrder)
        {
%>
          <th style="text-align:left" class="resultHeader">
            <%=contentManagement.getContent("species_threat-international-result_12")%>
          </th>
<%
        }
        if (showFamily)
        {
%>
          <th style="text-align:left" class="resultHeader">
            <%=contentManagement.getContent("species_threat-international-result_13")%>
          </th>
<%
        }
%>
          <th style="text-align:left" class="resultHeader">
            <a title="Sort results by this column" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=InternationalthreatstatusSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=contentManagement.getContent("species_threat-international-result_14")%></a>
          </th>
<%
        if (isExpanded && showVernacularNames)
        {
%>
          <th style="text-align:left" class="resultHeader">
            <%=contentManagement.getContent("species_threat-international-result_15")%>
            &nbsp;
            [<a title="Hide vernacular names list" class="resultHeaderLink" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=contentManagement.getContent("species_threat-international-result_16")%></a>]
          </th>
<%
        }
%>
        </tr>
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
  <jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="species-threat-international-result.jsp" />
  </jsp:include>
  </div>
  </body>
</html>