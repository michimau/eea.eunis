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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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

  String tsvLink = "javascript:openTSVDownload('reports/species/tsv-species-legal.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_legal-result_title")%>
    </title>
  </head>
  <body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home#index.jsp,species#species.jsp,legal_instruments#species-legal.jsp,results" />
      <jsp:param name="helpLink" value="species-help.jsp" />
      <jsp:param name="downloadLink" value="<%=tsvLink%>" />
    </jsp:include>
    <h1>
      <%=cm.cmsText("legal_instruments")%>
    </h1>
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
                <%=cm.cmsText("species_legal-result_02")%>
                <strong>
                    <%=Utilities.treatURLAmp(groupCommonName)%>
                </strong>
                <%=cm.cmsText("species_legal-result_03")%>:
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
                <%=cm.cmsText("species_legal-result_04")%>
                <strong>
                    <%=Utilities.treatURLAmp(groupCommonName)%>
                </strong>
                <%=cm.cmsText("species_legal-result_05")%>:
                <%
                    if("any".equalsIgnoreCase(formBean.getAnnex()) && "any".equalsIgnoreCase(formBean.getLegalText()))
                    {
                %>
                      <strong>
                        <%=cm.cmsText("any")%>
                      </strong>
                <%
                    }else {
                %>
                <strong>
                    <%=cm.cmsText("species_legal-result_06")%>
                    <%=Utilities.treatURLAmp(formBean.getAnnex())%> - <%=Utilities.treatURLAmp(formBean.getLegalText())%>
                </strong>
                <%
                    }
                %>
                <%=cm.cmsText("legal_text")%>
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
      <%=cm.cmsText("results_found_1")%>:
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
                      <%=cm.cmsText("refine_your_search")%>
              </td>
          </tr>
          <tr>
            <td style="background-color:#EEEEEE">
              <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="">
              <%=formBean.toFORMParam(filterSearch)%>
              <label for="select1" class="noshow"><%=cm.cms("criteria")%></label>
                  <%
                      if (!showGroup || !isAnyGroup)
                      {
                   %>
                       <input type="hidden" name="criteriaType" value="<%=LegalSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>"  />
                  <%
                      }
                  %>

              <select id="select1" title="<%=cm.cms("criteria")%>" name="criteriaType" class="inputTextField" <%=(showGroup && isAnyGroup ? "" : "disabled=\"disabled\"")%>>
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
                      <%=cm.cms("group")%>
                  </option>
                  <%
                      }
                  %>
                </select>
                <%=cm.cmsLabel("criteria")%>
                <%=cm.cmsTitle("criteria")%>
                <label for="select2" class="noshow"><%=cm.cms("operator")%></label>
                <select id="select2" title="<%=cm.cms("operator")%>" name="oper" class="inputTextField">
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
                <input type="hidden" name="typeForm" value="<%=LegalSearchCriteria.CRITERIA_SPECIES%>" />
                  <label for="criteriaSearch" class="noshow">
                    <%=cm.cms("filter_value")%>
                  </label>
                <input id="criteriaSearch" title="<%=cm.cms("filter_value")%>" alt="<%=cm.cms("filter_value")%>" class="inputTextField" name="criteriaSearch" type="text" size="30" />
                <%=cm.cmsLabel("filter_value")%>
                <%=cm.cmsTitle("filter_value")%>
                <input title="<%=cm.cms("search")%>" id="refine" class="inputTextField" type="submit" name="Submit" value="<%=cm.cms("search")%>" />
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
      <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
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
              <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("scientific_name")%></span></a>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
<%
  }
  if (showGroup)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      <%=cm.cmsText("group")%>
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
                      <%=cm.cmsText("legal_text")%>
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
                      <%=cm.cmsText("abbreviation")%>
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
                      <%=cm.cmsText("comment")%>
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
                      <%=cm.cmsText("url")%>
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
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                  <%=cm.cmsTitle("open_species_factsheet")%>
                </td>
<%
              }
              if (showGroup)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  &nbsp;
                  <%=Utilities.treatURLSpecialCharacters(specie.getCommonName())%>
                </td>
<%
              }
              if (showLegalText)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=Utilities.treatURLSpecialCharacters(specie.getTitle())%>
                </td>
<%
              }
              if ( showAbbreviation )
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=Utilities.treatURLSpecialCharacters(specie.getAlternative() + "- Annex/Appendix " + specie.getAnnex())%>
                </td>
<%
              }
              if (showComment)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  &nbsp;
                  <%=Utilities.treatURLSpecialCharacters(specie.getComment())%>
                </td>
<%
              }
              if (showURL)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
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
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                  <%=cm.cmsTitle("open_species_factsheet")%>
                </td>
<%
              }
              if (showGroup)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  &nbsp;
                  <%=Utilities.treatURLSpecialCharacters(specie.getCommonName())%>
                </td>
<%
              }
              if (showLegalText)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=Utilities.treatURLSpecialCharacters(specie.getTitle())%>
                </td>
<%
              }
              if ( showAbbreviation )
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                    <%=Utilities.treatURLSpecialCharacters(specie.getAlternative() + "- Annex/Appendix " + specie.getAnnex())%>
                </td>
<%
              }
              if (showComment)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  &nbsp;
                  <%=Utilities.treatURLSpecialCharacters(specie.getComment())%>
                </td>
<%
              }
              if (showURL)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
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
              <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=LegalSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("scientific_name")%></span></a>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
<%
  }
  if (showGroup)
  {
%>
            <th style="text-align:left;vertical-align:top;" class="resultHeader">
              <strong>
                  <span style="color:#FFFFFF">
                      <%=cm.cmsText("group")%>
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
                      <%=cm.cmsText("legal_text")%>
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
                      <%=cm.cmsText("abbreviation")%>
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
                      <%=cm.cmsText("comment")%>
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
                      <%=cm.cmsText("url")%>
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

<%=cm.br()%>
<%=cm.cmsMsg("species_legal-result_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("scientific_name")%>
<%=cm.br()%>
<%=cm.cmsMsg("group")%>
<%=cm.br()%>
<%=cm.cmsMsg("is")%>
<%=cm.br()%>
<%=cm.cmsMsg("starts_with")%>
<%=cm.br()%>
<%=cm.cmsMsg("contains")%>
<%=cm.br()%>
<%=cm.cmsMsg("search_results")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-legal-result.jsp" />
    </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>