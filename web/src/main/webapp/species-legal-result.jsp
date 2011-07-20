<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species Legal instruments' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.*,
                ro.finsiel.eunis.search.species.legal.LegalSearchCriteria,
                ro.finsiel.eunis.search.species.legal.LegalPaginator,
                ro.finsiel.eunis.jrfTables.species.legal.ScientificLegalDomain,
                ro.finsiel.eunis.jrfTables.species.legal.LegalStatusDomain,
                ro.finsiel.eunis.search.species.legal.LegalSortCriteria,
                ro.finsiel.eunis.jrfTables.species.legal.ScientificLegalPersist,
                ro.finsiel.eunis.jrfTables.species.legal.LegalStatusPersist,
                ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                ro.finsiel.eunis.formBeans.AbstractFormBean,
                ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.search.*,
                ro.finsiel.eunis.search.save_criteria.SetVectorsForSaveCriteria,
                ro.finsiel.eunis.search.save_criteria.SaveSearchCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.legal.LegalBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%

  //Utilities.dumpRequestParams(request);

  // If user has right to save this search and he want to save it
  if (SessionManager.isAuthenticated()
          && SessionManager.isSave_search_criteria_RIGHT()
          && request.getParameter("saveCriteria") != null
          && request.getParameter("saveCriteria").equalsIgnoreCase("true"))
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
    String pageName = "species-legal.jsp";
    // values of database constants from specific class Domain(only in habitat searches, so here database vector is empty)
    Vector database = new Vector();
    String typeForm = (request.getParameter("typeForm") == null? "": request.getParameter("typeForm"));
     // Create a new object SetVectorsForSaveCriteria
     SetVectorsForSaveCriteria setSaveParameters = new SetVectorsForSaveCriteria();
     // Set parameters for this save
     setSaveParameters.SetVectorsForSaveCriteriaSpeciesLegal(formBean.getGroupName(),
             formBean.getLegalText(),
             formBean.getAnnex(),
             formBean.getScientificName(),
             typeForm);
    // Save this search
    SaveSearchCriteria save = new SaveSearchCriteria(database,
            6,
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

  // Request parameters.
  boolean showGroup = Utilities.checkedStringToBoolean(formBean.getShowGroup(), AbstractFormBean.HIDE);
  //boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), AbstractFormBean.HIDE);
  boolean showScientificName = true;
  boolean showLegalText = Utilities.checkedStringToBoolean(formBean.getShowLegalText(), AbstractFormBean.HIDE);
  boolean showURL = Utilities.checkedStringToBoolean(formBean.getShowURL(), AbstractFormBean.HIDE);
  boolean showAbbreviation = Utilities.checkedStringToBoolean(formBean.getShowAbbreviation(), AbstractFormBean.HIDE);
  boolean showComment = Utilities.checkedStringToBoolean(formBean.getShowComment(), AbstractFormBean.HIDE);

  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  int typeForm = Utilities.checkedStringToInt(formBean.getTypeForm(), LegalSearchCriteria.CRITERIA_SPECIES.intValue());
  boolean isAnyGroup = (null != formBean.getGroupName() && formBean.getGroupName().equalsIgnoreCase("any")) ? true : false;
  LegalPaginator paginator = null;
  // Coming from form 1
  if (LegalSearchCriteria.CRITERIA_SPECIES.intValue() == typeForm) {
    paginator = new LegalPaginator(new ScientificLegalDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), SessionManager.getShowEUNISInvalidatedSpecies()));
  }
  // Coming from form 2
  if (LegalSearchCriteria.CRITERIA_LEGAL.intValue() == typeForm) {
    paginator = new LegalPaginator(new LegalStatusDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), SessionManager.getShowEUNISInvalidatedSpecies()));
  }
  // Initialisation
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "species-legal-result.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);

  // Prepare parameters for tsvlink
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");

  // Set number criteria for the search result
  int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);

  String tsvLink = "javascript:openTSVDownload('reports/species/tsv-species-legal.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,legal_instruments#species-legal.jsp,results";
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
      <%=cm.cms("species_legal-result_title")%>
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
                  <%=cm.cmsPhrase("Legal Instruments")%>
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
                      <a href="species-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cmsPhrase("Help information")%>"
                             title="<%=cm.cmsPhrase("Help information")%>" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                      <%
                          if (typeForm == LegalSearchCriteria.CRITERIA_SPECIES.intValue())
                          {
                            String groupCommonName = SpeciesSearchUtility.findGroupName(formBean.getGroupName());
                      %>
                        <tr>
                          <td>
                            <%=cm.cmsPhrase("You searched legal instruments for")%>
                            <strong>
                                <%=Utilities.treatURLAmp(groupCommonName)%>
                            </strong>
                            <%=cm.cmsPhrase("group and <strong>scientific name</strong> contains")%>:
                            <strong>
                                <%=Utilities.treatURLAmp(formBean.getScientificName())%>
                            </strong>
                          </td>
                        </tr>
                      <%
                          }
                          if (typeForm == LegalSearchCriteria.CRITERIA_LEGAL.intValue())
                          {
                            String groupCommonName = SpeciesSearchUtility.findGroupName(formBean.getGroupName());
                      %>
                        <tr>
                          <td>
                            <%=cm.cmsPhrase("You searched species from")%>
                            <strong>
                                <%=Utilities.treatURLAmp(groupCommonName)%>
                            </strong>
                            <%=cm.cmsPhrase("group, referenced by")%>:
                            <%
                                if("any".equalsIgnoreCase(formBean.getAnnex()) && "any".equalsIgnoreCase(formBean.getLegalText()))
                                {
                            %>
                                  <strong>
                                    <%=cm.cmsPhrase("Any")%>
                                  </strong>
                            <%
                                }else {
                            %>
                            <strong>
                                <%=cm.cmsPhrase("Annex/Appendix")%>
                                <%=Utilities.treatURLAmp(formBean.getAnnex())%> - <%=Utilities.treatURLAmp(formBean.getLegalText())%>
                            </strong>
                            <%
                                }
                            %>
                            <%=cm.cmsPhrase("legal text")%>
                          </td>
                        </tr>
                      <%
                          }
                      %>
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
                    pageSizeFormFields.addElement("oper");
                    pageSizeFormFields.addElement("criteriaType");
                  %>
                  <jsp:include page="pagesize.jsp">
                    <jsp:param name="guid" value="<%=guid + 1%>" />
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
                    filterSearch.addElement("oper");
                    filterSearch.addElement("criteriaType");
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
                          <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="">
                          <%=formBean.toFORMParam(filterSearch)%>
                          <label for="select1" class="noshow"><%=cm.cmsPhrase("Criteria")%></label>
                              <%
                                  if (!showGroup || !isAnyGroup)
                                  {
                               %>
                                   <input type="hidden" name="criteriaType" value="<%=LegalSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>"  />
                              <%
                                  }
                              %>

                          <select id="select1" title="<%=cm.cmsPhrase("Criteria")%>" name="criteriaType" <%=(showGroup && isAnyGroup ? "" : "disabled=\"disabled\"")%>>
                           <%
                               if (showScientificName)
                               {
                           %>
                              <option value="<%=LegalSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                                  <%=cm.cms("scientific_name")%>
                              </option>
                              <%
                                  }
                                  if (showGroup && isAnyGroup)
                                  {
                               %>
                              <option value="<%=LegalSearchCriteria.CRITERIA_GROUP%>" selected="selected">
                                  <%=cm.cmsPhrase("Group")%>
                              </option>
                              <%
                                  }
                              %>
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
                            <input type="hidden" name="typeForm" value="<%=LegalSearchCriteria.CRITERIA_SPECIES%>" />
                              <label for="criteriaSearch" class="noshow">
                                <%=cm.cms("filter_value")%>
                              </label>
                            <input id="criteriaSearch" title="<%=cm.cms("filter_value")%>" alt="<%=cm.cms("filter_value")%>" name="criteriaSearch" type="text" size="30" />
                            <%=cm.cmsLabel("filter_value")%>
                            <%=cm.cmsTitle("filter_value")%>
                            <input title="<%=cm.cms("search")%>" id="refine" class="submitSearchButton" type="submit" name="Submit" value="<%=cm.cms("search")%>" />
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
                        %>
                      <%
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
                    navigatorFormFields.addElement("oper");
                    navigatorFormFields.addElement("criteriaType");
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
                    <%// Compute the sort criteria
                      Vector sortURLFields = new Vector();      /* Used for sorting */
                      sortURLFields.addElement("pageSize");
                      sortURLFields.addElement("criteriaSearch");
                      sortURLFields.addElement("oper");
                      sortURLFields.addElement("criteriaType");
                      sortURLFields.addElement("currentPage");
                      String urlSortString = formBean.toURLParam(sortURLFields);
                      AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(LegalSortCriteria.SORT_SCIENTIFIC_NAME);
                    %>
                  <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
                    <thead>
                      <tr>
            <%
              if (showScientificName)
              {
            %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsPhrase("Scientific name")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
            <%
              }
              if (showGroup)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsPhrase("Group")%>
                        </th>
            <%
              }
              if (showLegalText)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsPhrase("legal text")%>
                        </th>
            <%
              }
              if ( showAbbreviation )
              {
            %>
                        <th scope="col">
                          <%=cm.cmsPhrase("Abbreviation")%>
                        </th>
            <%
              }
              if (showComment)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsPhrase("Comment")%>
                        </th>
            <%
              }
              if (showURL)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsPhrase("Url")%>
                        </th>
            <%
              }
            %>
                      </tr>
                    </thead>
                    <tbody>
            <%
                      Iterator it = results.iterator();
                      // Coming from first form
                      if (LegalSearchCriteria.CRITERIA_SPECIES.intValue() == typeForm)
                      {
                        int col = 0;
                        while (it.hasNext())
                        {
                          String bgColor = col++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF";
                          ScientificLegalPersist specie = (ScientificLegalPersist)it.next();
            %>
                    <tr>
            <%
                          if (showScientificName)
                          {
            %>
                            <td>
                              <a href="species/<%=specie.getIdSpecies()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                            </td>
            <%
                          }
                          if (showGroup)
                          {
            %>
                            <td>
                              &nbsp;
                              <%=Utilities.treatURLSpecialCharacters(specie.getCommonName())%>
                            </td>
            <%
                          }
                          if (showLegalText)
                          {
            %>
                            <td>
                              <%=Utilities.treatURLSpecialCharacters(specie.getTitle())%>
                            </td>
            <%
                          }
                          if ( showAbbreviation )
                          {
            %>
                            <td>
                              <%=Utilities.treatURLSpecialCharacters(specie.getAlternative() + "- Annex/Appendix " + specie.getAnnex())%>
                            </td>
            <%
                          }
                          if (showComment)
                          {
            %>
                            <td>
                              &nbsp;
                              <%=Utilities.treatURLSpecialCharacters(specie.getComment())%>
                            </td>
            <%
                          }
                          if (showURL)
                          {
            %>
                            <td>
            <%
                                if(null != specie.getUrl().replaceAll("#",""))
                                {
                                  String sFormattedURL = Utilities.formatString(specie.getUrl()).replaceAll("#","");
                                  if(sFormattedURL.length()>30)
                                  {
                                    sFormattedURL = sFormattedURL.substring(0,30) + "...";
                                  }
            %>
                                <a href="<%=Utilities.formatString(specie.getUrl()).replaceAll("#","")%>" target="_blank" title="<%=Utilities.treatURLSpecialCharacters(Utilities.formatString(specie.getUrl()).replaceAll("#",""))%>"><%=Utilities.treatURLSpecialCharacters(sFormattedURL)%></a>
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
            <%
                          }
            %>
                          </tr>
            <%
                       }
                     }
                      // Coming from second form
                      if (LegalSearchCriteria.CRITERIA_LEGAL.intValue() == typeForm)
                      {
                        int col = 0;
                        while (it.hasNext())
                        {
                          String bgColor = col++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF";
                          LegalStatusPersist specie = (LegalStatusPersist)it.next();
            %>
                          <tr>
            <%
                          if (showScientificName)
                          {
            %>
                            <td>
                              <a href="species/<%=specie.getIdSpecies()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                            </td>
            <%
                          }
                          if (showGroup)
                          {
            %>
                            <td>
                              &nbsp;
                              <%=Utilities.treatURLSpecialCharacters(specie.getCommonName())%>
                            </td>
            <%
                          }
                          if (showLegalText)
                          {
            %>
                            <td>
                              <%=Utilities.treatURLSpecialCharacters(specie.getTitle())%>
                            </td>
            <%
                          }
                          if ( showAbbreviation )
                          {
            %>
                            <td>
                                <%=Utilities.treatURLSpecialCharacters(specie.getAlternative() + "- Annex/Appendix " + specie.getAnnex())%>
                            </td>
            <%
                          }
                          if (showComment)
                          {
            %>
                            <td>
                              &nbsp;
                              <%=Utilities.treatURLSpecialCharacters(specie.getComment())%>
                            </td>
            <%
                          }
                          if (showURL)
                          {
            %>
                            <td>
            <%
                                if(null != specie.getUrl().replaceAll("#",""))
                                {
                                  String sFormattedURL = Utilities.formatString(specie.getUrl()).replaceAll("#","");
                                  if(sFormattedURL.length()>30)
                                  {
                                    sFormattedURL = sFormattedURL.substring(0,30) + "...";
                                  }
            %>
                              <a href="<%=Utilities.formatString(specie.getUrl()).replaceAll("#","")%>" target="_blank" title="<%=Utilities.treatURLSpecialCharacters(Utilities.formatString(specie.getUrl()).replaceAll("#",""))%>"><%=Utilities.treatURLSpecialCharacters(sFormattedURL)%></a>
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
            <%
                          }
            %>
                          </tr>
            <%
                        }
                      }
            %>
                    </tbody>
                    <thead>
                      <tr>
            <%
              if (showScientificName)
              {
            %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsPhrase("Scientific name")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
            <%
              }
              if (showGroup)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsPhrase("Group")%>
                        </th>
            <%
              }
              if (showLegalText)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsPhrase("legal text")%>
                        </th>
            <%
              }
              if ( showAbbreviation )
              {
            %>
                        <th scope="col">
                          <%=cm.cmsPhrase("Abbreviation")%>
                        </th>
            <%
              }
              if (showComment)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsPhrase("Comment")%>
                        </th>
            <%
              }
              if (showURL)
              {
            %>
                        <th scope="col">
                          <%=cm.cmsPhrase("Url")%>
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
            <%=cm.cmsMsg("species_legal-result_title")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("scientific_name")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("search_results")%>
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
                <jsp:param name="page_name" value="species-legal-result.jsp" />
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
