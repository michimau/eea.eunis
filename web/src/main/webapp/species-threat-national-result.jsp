<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species National threat status' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.national.*,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.jrfTables.species.national.NationalThreatStatusDomain,
                 ro.finsiel.eunis.jrfTables.species.national.NationalThreatStatusPersist,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.search.save_criteria.SetVectorsForSaveCriteria,
                 ro.finsiel.eunis.search.save_criteria.SaveSearchCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.national.NationalBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  String idGroup = (formBean.getIdGroup() == null ? "" : formBean.getIdGroup());
  // If user has right to save this search and he want to save it
  if (SessionManager.isAuthenticated() &&
      SessionManager.isSave_search_criteria_RIGHT() &&
      request.getParameter("saveCriteria")!= null &&
      request.getParameter("saveCriteria").equalsIgnoreCase("true")
      )
  {
  // Set database parameters
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

   // Description of this search
  String description = "";
  String pageName = "species-threat-national.jsp";
  // values of database constants from specific class Domain(only in habitat searches, so here database vector is empty)
  Vector database = new Vector();
   // Create a new object SetVectorsForSaveCriteria
   SetVectorsForSaveCriteria setSaveParameters = new SetVectorsForSaveCriteria();
   // Set parameters for this save
   setSaveParameters.SetVectorsForSaveCriteriaSpeciesThreatNational(formBean.getIdGroup(),
                                          formBean.getIdConservation(),
                                          formBean.getIdCountry(),
                                          formBean.getIndice().toString(),
                                          formBean.getGroupName(),
                                          formBean.getStatusName(),
                                          formBean.getCountryName());
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
  boolean showGroup = Utilities.checkedStringToBoolean(formBean.getShowGroup(), NationalBean.HIDE);
  boolean showCountry = Utilities.checkedStringToBoolean(formBean.getShowCountry(), NationalBean.HIDE);
  boolean showStatus = Utilities.checkedStringToBoolean(formBean.getShowStatus(), NationalBean.HIDE);
  boolean showOrder = Utilities.checkedStringToBoolean(formBean.getShowOrder(), NationalBean.HIDE);
  boolean showFamily = Utilities.checkedStringToBoolean(formBean.getShowFamily(), NationalBean.HIDE);
  //boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), NationalBean.HIDE);
  boolean showVernacularNames = Utilities.checkedStringToBoolean(formBean.getShowVernacularNames(), NationalBean.HIDE);

// Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  NationalPaginator paginator = null;
  paginator = new NationalPaginator(new NationalThreatStatusDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(),SessionManager.getShowEUNISInvalidatedSpecies()));

  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "species-threat-national-result.jsp";
  int resultsCount = paginator.countResults();
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  // Set number criteria for the search result
  int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  String tsvLink = "javascript:openTSVDownload('reports/species/tsv-species-threat-national.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,national_threat_status#species-threat-national.jsp,results";
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
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("species_threat-national-result_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" helpLink="species-help.jsp" pageTitle="${title}" downloadLink="<%= tsvLink%>" btrail="<%= location%>">
    <stripes:layout-component name="head">
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eea_search.css">
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-result.js"></script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1>
          <%=cm.cmsPhrase("Species threatened at national level")%>
        </h1>
<!-- MAIN CONTENT -->
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                           <%String descr = formBean.getStringMain();%>
                          <tr>
                            <td>
                              <%=cm.cmsPhrase("You searched species with threat national level:")%>
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
                    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color: #EEEEEE" >
                      <tr>
                        <td>
                            <%=cm.cmsPhrase("Refine your search")%>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="" >
                          <%=formBean.toFORMParam(filterSearch)%>
                            <label for="select1" class="noshow"><%=cm.cmsPhrase("Criteria")%></label>
                              <%
                                  if (!showGroup || !idGroup.equalsIgnoreCase("-1"))
                                  {
                              %>
                                   <input type="hidden" name="criteriaType" value="<%=NationalSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" />
                              <%
                                  }
                              %>

                            <select id="select1" title="<%=cm.cmsPhrase("Criteria")%>" <%=(showGroup && idGroup.equalsIgnoreCase("-1") ? "" : "disabled=\"disabled\"")%>>
                              <%
                                  if (showGroup && idGroup.equalsIgnoreCase("-1"))
                                  {
                              %>
                                <option value="<%=NationalSearchCriteria.CRITERIA_GROUP%>">
                                    <%=cm.cmsPhrase("Group")%>
                                </option>
                                <%
                                    }
                                %>
                              <option value="<%=NationalSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                                  <%=cm.cmsPhrase("Scientific name")%>
                              </option>
                            </select>
                            <select id="select2" title="<%=cm.cmsPhrase("Operator")%>" name="oper">
                              <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                                  <%=cm.cmsPhrase("is")%>
                              </option>
                              <option value="<%=Utilities.OPERATOR_STARTS%>">
                                  <%=cm.cmsPhrase("starts with")%>
                              </option>
                              <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                                  <%=cm.cmsPhrase("contains")%>
                              </option>
                            </select>
                            <label for="criteriaSearch" class="noshow"><%=cm.cmsPhrase("Filter value")%></label>
                            <input id="criteriaSearch" title="<%=cm.cmsPhrase("Filter value")%>" alt="<%=cm.cmsPhrase("Filter value")%>" name="criteriaSearch" type="text" size="30" />
                            <input id="refine" title="<%=cm.cmsPhrase("Search")%>" class="standardButton" type="submit" name="Submit" value="<%=cm.cmsPhrase("Search")%>" />
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
                            <td style="background-color:#CCCCCC;text-align:left">
                              <a title="<%=cm.cms("delete_criteria")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img alt="<%=cm.cms("delete_criteria")%>" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" /></a><%=cm.cmsTitle("delete_criteria")%>&nbsp;&nbsp;<strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
                            </td>
                          </tr>
            <%
                            }
                         }
            %>
                  </table>
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
                      AbstractSortCriteria sortGroup = formBean.lookupSortCriteria(NationalSortCriteria.SORT_GROUP);
                      AbstractSortCriteria sortOrder = formBean.lookupSortCriteria(NationalSortCriteria.SORT_ORDER);
                      AbstractSortCriteria sortFamily = formBean.lookupSortCriteria(NationalSortCriteria.SORT_FAMILY);
                      AbstractSortCriteria sortSciName = formBean.lookupSortCriteria(NationalSortCriteria.SORT_SCIENTIFIC_NAME);

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
                      <a title="<%=cm.cms("show_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Display vernacular names in results table")%></a>
                      <%=cm.cmsTitle("show_vernacular_list")%>
                    <%
                        }
                    %>
                  <table class="sortable listing" width="100%" summary="<%=cm.cmsPhrase("Search results")%>">
                    <thead>
                      <tr>
                      <%
                          if (showGroup && idGroup.equalsIgnoreCase("-1"))
                          {
                      %>
                        <th class="nosort" scope="col">
                          <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NationalSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsPhrase("Group")%></a>
                        </th>
                      <%
                          } else {
                      %>
                        <th class="nosort" scope="col">
                          <%=cm.cmsPhrase("Group")%>
                        </th>
                      <%
                          }
                         if(showCountry)
                         {
                      %>
                        <th class="nosort" scope="col">
                          <%=cm.cmsPhrase("Country")%>
                        </th>
                      <%
                          }
                          if(showStatus)
                          {
                      %>
                        <th class="nosort" scope="col">
                         <%=cm.cmsPhrase("Threat Status")%>
                        </th>
                      <%
                           }
                      %>
                        <th class="nosort" scope="col">
                          <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NationalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsPhrase("Scientific name")%></a>
                        </th>
                      <%
                        if (isExpanded && showVernacularNames)
                        {
                      %>
                        <th class="nosort" scope="col">
                          <a title="<%=cm.cms("hide_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Vernacular names")%>[<%=cm.cmsPhrase("Hide")%>]</a><%=cm.cmsTitle("hide_vernacular_list")%>
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
                      int col = 0;
                      while (it.hasNext())
                      {
                        NationalThreatStatusPersist specie = (NationalThreatStatusPersist)it.next();
                        Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
                        // Sort this vernacular names in alphabetical order
                        Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);%>
                          <tr>
                            <%
                                if (showGroup)
                                {
                            %>
                              <td>
                                  <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getCommonName()),"&nbsp;")%>
                              </td>
                              <%
                                }
                                if (showCountry)
                                {
                            %>
                              <td>
                                  <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getCountry()),"&nbsp;")%>
                              </td>
                              <%
                                }
                                  if (showStatus)
                                  {
                            %>
                                <td>
                                  <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getDefAbrev()),"&nbsp;")%>
                                </td>
                              <%
                                  }
                              %>
                            <td>
                              &nbsp;
                              <a href="species/<%=specie.getIdSpecies()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScName())%></a>
                            </td>
                            <%
                                if (isExpanded && showVernacularNames)
                                {
                            %>
                              <td>
                                <%-- I display the vernacular names within a table inside the cell, DON'T USE ROWSPAN, YOU'L REGRET IT --%>
                                <table summary="<%=cm.cms("list_vernacular")%>" width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align:center">
                    <%            if(sortVernList == null || sortVernList.size()<=0)
                                  {
            %>
                                    <tr><td>&nbsp;</td></tr>
            <%
                                } else
                                {
                                    for (int i = 0; i < sortVernList.size(); i++)
                                    {
                                      VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(i);
                                      String vernacularName = aVernName.getName();
                                      String bgColor1 = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
                                  %>
                                  <tr>
                                    <td width="30%" style="background-color:<%=bgColor1%>;text-align:left">
                                        <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(aVernName.getLanguage()),"&nbsp;")%>
                                    </td>
                                    <td width="70%" style="background-color:<%=bgColor1%>;text-align:left">
                                        <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(vernacularName),"&nbsp;")%>
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
                      <%
                          if (showGroup && idGroup.equalsIgnoreCase("-1"))
                          {
                      %>
                        <th class="nosort" scope="col">
                          <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NationalSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsPhrase("Group")%></a>
                        </th>
                      <%
                          } else {
                      %>
                        <th class="nosort" scope="col">
                          <%=cm.cmsPhrase("Group")%>
                        </th>
                      <%
                          }
                         if(showCountry)
                         {
                      %>
                        <th class="nosort" scope="col">
                          <%=cm.cmsPhrase("Country")%>
                        </th>
                      <%
                          }
                          if(showStatus)
                          {
                      %>
                        <th class="nosort" scope="col">
                          <%=cm.cmsPhrase("Threat Status")%>
                        </th>
                      <%
                           }
                      %>
                        <th class="nosort" scope="col">
                          <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NationalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsPhrase("Scientific name")%></a>
                        </th>
                      <%
                        if (isExpanded && showVernacularNames)
                        {
                      %>
                        <th class="nosort" scope="col">
                          <a title="<%=cm.cms("hide_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Vernacular names")%>[<%=cm.cmsPhrase("Hide")%>]</a><%=cm.cmsTitle("hide_vernacular_list")%>
                        </th>
                      <%
                        }
                      %>
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
            <%=cm.cmsMsg("species_threat-national-result_title")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("list_vernacular")%>
            <%=cm.br()%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>