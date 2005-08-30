<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species Legal instruments' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
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
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
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

  String tsvLink = "javascript:openlink('reports/species/tsv-species-legal.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_legal-result_title", false )%>
    </title>
  </head>
  <body>
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Legal instruments#species-legal.jsp,Results" />
      <jsp:param name="helpLink" value="species-help.jsp" />
      <jsp:param name="downloadLink" value="<%=tsvLink%>" />
    </jsp:include>
    <h5>
      <%=contentManagement.getContent("species_legal-result_01")%>
    </h5>
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
                <%=contentManagement.getContent("species_legal-result_02")%>
                <strong>
                    <%=Utilities.treatURLAmp(groupCommonName)%>
                </strong>
                <%=contentManagement.getContent("species_legal-result_03")%>:
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
                <%=contentManagement.getContent("species_legal-result_04")%>
                <strong>
                    <%=Utilities.treatURLAmp(groupCommonName)%>
                </strong>
                <%=contentManagement.getContent("species_legal-result_05")%>:
                <%
                    if("any".equalsIgnoreCase(formBean.getAnnex()) && "any".equalsIgnoreCase(formBean.getLegalText()))
                    {
                %>
                      <strong>
                        <%=contentManagement.getContent("species_legal-result_any")%>
                      </strong>
                <%
                    }else {
                %>
                <strong>
                    <%=contentManagement.getContent("species_legal-result_06")%>
                    <%=Utilities.treatURLAmp(formBean.getAnnex())%> - <%=Utilities.treatURLAmp(formBean.getLegalText())%>
                </strong>
                <%
                    }
                %>
                <%=contentManagement.getContent("species_legal-result_07")%>
              </td>
            </tr>
          <%
              }
          %>
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
      <%=contentManagement.getContent("species_legal-result_08")%>:
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
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
              <td style="background-color:#EEEEEE">
                      <%=contentManagement.getContent("species_legal-result_09")%>
              </td>
          </tr>
          <tr>
            <td style="background-color:#EEEEEE">
              <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="">
              <%=formBean.toFORMParam(filterSearch)%>
              <label for="select1" class="noshow">Criteria</label>
                  <%
                      if (!showGroup || !isAnyGroup)
                      {
                   %>
                       <input type="hidden" name="criteriaType" value="<%=LegalSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>"  />
                  <%
                      }
                  %>

              <select id="select1" title="Criteria" name="criteriaType" class="inputTextField" <%=(showGroup && isAnyGroup ? "" : "disabled=\"disabled\"")%>>
               <%
                   if (showScientificName)
                   {
               %>
                  <option value="<%=LegalSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                      <%=contentManagement.getContent("species_legal-result_10", false)%>
                  </option>
                  <%
                      }
                      if (showGroup && isAnyGroup)
                      {
                   %>
                  <option value="<%=LegalSearchCriteria.CRITERIA_GROUP%>" selected="selected">
                      <%=contentManagement.getContent("species_legal-result_11", false)%>
                  </option>
                  <%
                      }
                  %>
                </select>
                <label for="select2" class="noshow">Operator</label>
                <select id="select2" title="Operator" name="oper" class="inputTextField">
                  <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                      <%=contentManagement.getContent("species_legal-result_12", false)%>
                  </option>
                  <option value="<%=Utilities.OPERATOR_STARTS%>">
                      <%=contentManagement.getContent("species_legal-result_13", false)%>
                  </option>
                  <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                      <%=contentManagement.getContent("species_legal-result_14", false)%>
                  </option>
                </select>
                <input type="hidden" name="typeForm" value="<%=LegalSearchCriteria.CRITERIA_SPECIES%>" />
                  <label for="criteriaSearch" class="noshow">
                    Criteria value
                  </label>
                <input id="criteriaSearch" title="Criteria value" alt="Criteria value" class="inputTextField" name="criteriaSearch" type="text" size="30" />
                  <label for="refine" class="noshow">
                    Search
                  </label>
                <input title="Search" id="refine" class="inputTextField" type="submit" name="Submit" value="Search" />
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
                    <%=contentManagement.getContent("species_legal-result_15")%>:
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
                <td style="background-color:#CCCCCC;text-align:left">
                  <a title="Delete this criteria search" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img alt="Delete" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" /></a>
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
      <table summary="List of results" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;text-align:left">
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
        <tr>
<%
  if (showScientificName)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("species_legal-result_10")%></span></a>
            </th>
<%
  }
  if (showGroup)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      <%=contentManagement.getContent("species_legal-result_11")%>
                  </span>
              </strong>
            </th>
<%
  }
  if (showLegalText)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      <%=contentManagement.getContent("species_legal-result_16")%>
                  </span>
             </strong>
            </th>
<%
  }
  if ( showAbbreviation )
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      <%=contentManagement.getContent("species_legal-result_17")%>
                  </span>
              </strong>
            </th>
<%
  }
  if (showComment)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      Comment
                  </span>
              </strong>
            </th>
<%
  }
  if (showURL)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      <%=contentManagement.getContent("species_legal-result_18")%>
                  </span>
              </strong>
            </th>
<%
  }
%>
        </tr>
<%
          Iterator it = results.iterator();
          // Coming from first form
          if (LegalSearchCriteria.CRITERIA_SPECIES.intValue() == typeForm)
          {
            while (it.hasNext())
            {
              ScientificLegalPersist specie = (ScientificLegalPersist)it.next();
%>
        <tr>
<%
              if (showScientificName)
              {
%>
                <td style="text-align:left">
                  <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                </td>
<%
              }
              if (showGroup)
              {
%>
                <td style="text-align:left">
                    &nbsp;
                    <%=Utilities.treatURLSpecialCharacters(specie.getCommonName())%>
                </td>
<%
              }
              if (showLegalText)
              {
%>
                <td style="text-align:left">
                    <%=Utilities.treatURLSpecialCharacters(specie.getTitle())%>
                </td>
<%
              }
              if ( showAbbreviation )
              {
%>
                <td style="text-align:left">
                    <%=Utilities.treatURLSpecialCharacters(specie.getAlternative() + "- Annex/Appendix " + specie.getAnnex())%>
                </td>
<%
              }
              if (showComment)
              {
%>
                <td style="text-align:left">
                    &nbsp;
                    <%=Utilities.treatURLSpecialCharacters(specie.getComment())%>
                </td>
<%
              }
              if (showURL)
              {
%>
                <td style="text-align:left">
<%
                if (null != specie.getUrl())
                {
%>
                  <a title="References" href="<%=specie.getUrl()%>"><%=Utilities.treatURLSpecialCharacters(specie.getUrl().replaceAll("#",""))%></a>
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
            while (it.hasNext())
            {
              LegalStatusPersist specie = (LegalStatusPersist)it.next();
%>
              <tr>
<%
              if (showScientificName)
              {
%>
                <td style="text-align:left">
                  <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                </td>
<%
              }
              if (showGroup)
              {
%>
                <td style="text-align:left">
                  &nbsp;
                  <%=Utilities.treatURLSpecialCharacters(specie.getCommonName())%>
                </td>
<%
              }
              if (showLegalText)
              {
%>
                <td style="text-align:left">
                    <%=Utilities.treatURLSpecialCharacters(specie.getTitle())%>
                </td>
<%
              }
              if ( showAbbreviation )
              {
%>
                <td style="text-align:left">
                    <%=Utilities.treatURLSpecialCharacters(specie.getAlternative() + "- Annex/Appendix " + specie.getAnnex())%>
                </td>
<%
              }
              if (showComment)
              {
%>
                  <td style="text-align:left">
                      &nbsp;
                      <%=Utilities.treatURLSpecialCharacters(specie.getComment())%>
                  </td>
<%
              }
              if (showURL)
              {
%>
                  <td style="text-align:left">
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
               <tr>
<%
  if (showScientificName)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sciNameCrit)%><%=contentManagement.getContent("species_legal-result_10")%></span></a>
            </th>
<%
  }
  if (showGroup)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      <%=contentManagement.getContent("species_legal-result_11")%>
                  </span>
              </strong>
            </th>
<%
  }
  if (showLegalText)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      <%=contentManagement.getContent("species_legal-result_16")%>
                  </span>
             </strong>
            </th>
<%
  }
  if ( showAbbreviation )
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      <%=contentManagement.getContent("species_legal-result_17")%>
                  </span>
              </strong>
            </th>
<%
  }
  if (showComment)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      Comment
                  </span>
              </strong>
            </th>
<%
  }
  if (showURL)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      <%=contentManagement.getContent("species_legal-result_18")%>
                  </span>
              </strong>
            </th>
<%
  }
%>
        </tr>
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
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-legal-result.jsp" />
    </jsp:include>
  </div>
  </body>
</html>