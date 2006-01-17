<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species names' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.species.names.NameSearchCriteria,
                 ro.finsiel.eunis.search.species.names.NamePaginator,
                 ro.finsiel.eunis.search.species.names.NameSortCriteria,
                 ro.finsiel.eunis.jrfTables.species.names.*,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.names.NameBean,
                 ro.finsiel.eunis.jrfTables.Chm62edtSoundexPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtSoundexDomain"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.names.NameBean" scope="page">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  //Utilities.dumpRequestParams( request );
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Check columns to be displayed
  boolean showGroup = Utilities.checkedStringToBoolean(formBean.getShowGroup(), NameBean.HIDE);
  boolean showOrder = Utilities.checkedStringToBoolean(formBean.getShowOrder(), NameBean.HIDE);
  boolean showFamily = Utilities.checkedStringToBoolean(formBean.getShowFamily(), NameBean.HIDE);
  boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), NameBean.HIDE);
  boolean showValidName = Utilities.checkedStringToBoolean(formBean.getShowValidName(), NameBean.HIDE);
  boolean showVernacularNames = Utilities.checkedStringToBoolean(formBean.getShowVernacularNames(), NameBean.HIDE);
  boolean searchSynonyms = Utilities.checkedStringToBoolean( formBean.getSearchSynonyms(), false );
  boolean newName = Utilities.checkedStringToBoolean( formBean.getNewName(), false );
  boolean searchVernacular = formBean.getSearchVernacular().booleanValue();
  boolean noSoundex = Utilities.checkedStringToBoolean( formBean.getNoSoundex(), false );
  // Initialization
  String languageReq = formBean.getLanguage();
  boolean isAnyLanguage = null != languageReq && languageReq.equalsIgnoreCase( "any" ) ? true : false;
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  int typeForm = Utilities.checkedStringToInt(formBean.getTypeForm(), NameSearchCriteria.CRITERIA_SCIENTIFIC.intValue());
  NamePaginator paginator = null;
  // Coming from form 1
  if (NameSearchCriteria.CRITERIA_SCIENTIFIC.intValue() == typeForm)
  {
      String cqs =  "" + request.getParameter("comeFromQuickSearch");
      boolean showInvalidatedSpecies = cqs.length() > 0 && !cqs.equalsIgnoreCase( "null" ) || SessionManager.getShowEUNISInvalidatedSpecies();
      paginator = new NamePaginator(new ScientificNameDomain(formBean.toSearchCriteria(),
                                                           formBean.toSortCriteria(),
                                                           searchSynonyms,
                                                           showInvalidatedSpecies,
                                                           formBean.getSearchVernacular()));
  }
  // Coming from form 2
  if (NameSearchCriteria.CRITERIA_VERNACULAR.intValue() == typeForm)
  {
    if (isAnyLanguage)
    {
      paginator = new NamePaginator(new VernacularNameAnyDomain(formBean.toSearchCriteria(),
                                                                formBean.toSortCriteria(),
                                                                SessionManager.getShowEUNISInvalidatedSpecies()));
    }
    else
    {
      paginator = new NamePaginator(new VernacularNameDomain(formBean.toSearchCriteria(),
                                                             formBean.toSortCriteria(),
                                                             SessionManager.getShowEUNISInvalidatedSpecies()));
    }
  }
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "species-names-result.jsp";
  int resultsCount = paginator.countResults();
  int pagesCount = paginator.countPages();// This is used in included page...
  int guid = 0;// This is used in included page...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  // Prepare parameters for tsvlink
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  reportFields.addElement("useVernacular");

  // Set number criteria for the search result
  int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);

  String downloadLink = "javascript:openTSVDownload('reports/species/tsv-species-names.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();

  if ( results.isEmpty() && !newName && !noSoundex )
  {
    String sname;
    if (NameSearchCriteria.CRITERIA_SCIENTIFIC.intValue() == typeForm) {
       sname = formBean.getScientificName();
    } else {
      sname = formBean.getVernacularName();
    }
    String sname_first = "";
    StringTokenizer st = new StringTokenizer(sname," ");
    if(st.hasMoreTokens()) {
      sname_first = st.nextToken();
    }
    List list;
    String cnstSoundex = new String(ro.finsiel.eunis.utilities.SQLUtilities.smartSoundex);
    cnstSoundex = cnstSoundex.replaceAll("<name>", sname_first.replaceAll( "'", "''" ) );
    cnstSoundex = cnstSoundex.replaceAll("<object_type>", "SPECIES");
    list = new Chm62edtSoundexDomain().findCustom(cnstSoundex);
    if (list != null && list.size() > 0)
    {
      Chm62edtSoundexPersist t = (Chm62edtSoundexPersist) list.get(0);
      String soundexName = t.getName();
      try
      {
        String URL = "species-names-result.jsp?typeForm=0&showScientificName=true&showGroup=true&showOrder=true&showFamily=true&showVernacularNames=true&showValidName=true&relationOp=4&scientificName="+soundexName+"&searchSynonyms=true&noSoundex=false&newName=true&oldName="+sname;
        URL += "&searchVernacular=" + searchVernacular;
        response.sendRedirect(URL);
        return;
      }
      catch(Exception e)
      {
        e.printStackTrace();
      }
    }
  }
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_names-result_pageTitle")%>
    </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,species_names_location#species-names.jsp,results_location" />
      <jsp:param name="helpLink" value="species-help.jsp" />
      <jsp:param name="downloadLink" value="<%=downloadLink%>" />
    </jsp:include>
    <h1>
       <%
          if(newName) {
          %>
            <%=cm.cmsText("species_names-result_mainTitleSN")%>
          <%
          } else
          {
            if (NameSearchCriteria.CRITERIA_SCIENTIFIC.intValue() == typeForm)
              {
           %>
                 <%=cm.cmsText("species_names-result_mainTitleSN")%>
           <%
              }
              // Coming from form 2
              if (NameSearchCriteria.CRITERIA_VERNACULAR.intValue() == typeForm)
              {
            %>
                 <%=cm.cmsText("species_names-result_mainTitleVN")%>
            <%
              }
          }
          %>
    </h1>
    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table width="100%" summary="layout" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td>
<%
  if (!results.isEmpty())
  {
          if(newName)
          {
            if(!formBean.getOldName().equalsIgnoreCase(formBean.getScientificName())) {
  %>
             <%=cm.cmsText("species_names-result_descriptionSearchN1")%>
             <strong><%=Utilities.treatURLSpecialCharacters(formBean.getOldName())%></strong>.&nbsp;
             <%=cm.cmsText("species_names-result_descriptionSearchN2")%>
             <strong><%=Utilities.treatURLSpecialCharacters(formBean.getScientificName())%></strong>
  <%
            } else {
  %>
             <%=cm.cmsText("species_names-result_descriptionSearchN2")%>
             <strong><%=Utilities.treatURLSpecialCharacters(formBean.getScientificName())%></strong>
  <%
            }
          } else
          {
%>
             <%=cm.cmsText("species_names-result_descriptionSearchSN1")%>
             <strong>
<%
            String searchCriteria = "";
            String name = "";
            Integer oper = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
            if ( typeForm == NameSearchCriteria.CRITERIA_SCIENTIFIC.intValue() )
            {

              if ( searchVernacular )
              {
                searchCriteria = "name";
              }
              else
              {
                searchCriteria = "scientific name";
              }
              name = formBean.getScientificName();
            }
            if ( typeForm == NameSearchCriteria.CRITERIA_VERNACULAR.intValue() )
            {
              searchCriteria = "vernacular name";
              name = formBean.getVernacularName();
            }
%>
              <%=Utilities.prepareHumanString(searchCriteria, name, oper)%>
             </strong>
<%
            if ( formBean.getLanguage() != null )
            {
%>
               <%=cm.cmsText("species_names-result_descriptionSearchSN2")%>
               <strong><%=formBean.getLanguage()%></strong>
<%
            }
          }
  }
%>
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
          <br />
            <%=cm.cmsText("species_names-result_resultFound")%>:
            <strong>
                <%=resultsCount%>
            </strong>
<%
              // Prepare parameters for pagesize.jsp
              Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
              pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
              pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
              pageSizeFormFields.addElement("criteriaSearch");/*   to page '0', first page. */
              pageSizeFormFields.addElement("useVernacular");/*   to page '0', first page. */
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
            filterSearch.addElement("useVernacular");
%>
            <br />
            <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="background-color:#EEEEEE">
                  <%=cm.cmsText("species_names-result_refineSearch")%>
              </td>
            </tr>
            <tr>
              <td style="background-color:#EEEEEE">
                <form name="refineSearch" method="get" onsubmit="return validateRefineForm(<%=noCriteria%>);" action="<%=pageName%>">
                  <input type="hidden" name="noSoundex" value="true" />
                  <%=formBean.toFORMParam(filterSearch)%>
                  <label for="select1" class="noshow"><%=cm.cms("result_01_Label")%></label>
<%
                  if (!showGroup)
                  {
%>
                   <input type="hidden" name="criteriaType" value="<%=NameSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" /> 
<%
                  }
%>
                  <select id="select1" title="<%=cm.cms("result_01_Title")%>" name="criteriaType" class="inputTextField" <%=(showGroup ? "" : "disabled=\"disabled\"")%>>
<%
                  if (showGroup)
                  {
%>
                    <option value="<%=NameSearchCriteria.CRITERIA_GROUP%>">
                        <%=cm.cms("species_names-result_thGroup")%>
                    </option>
<%
                  }
                  if (showScientificName)
                  {
%>
                    <option value="<%=NameSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                        <%=cm.cms("species_names-result_thScientificName")%>
                    </option>
<%
                  }
%>
                  </select>
                  <%=cm.cmsLabel("result_01_Label")%>
                  <%=cm.cmsTitle("result_01_Title")%>
                  <label for="select2" class="noshow"><%=cm.cms("species_names-result_02_Label")%></label>
                  <select id="select2" title="<%=cm.cms("species_names-result_02_Title")%>" name="oper" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                        <%=cm.cms("species_names-result_operatorIs")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>">
                        <%=cm.cms("species_names-result_operatorStartWith")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                        <%=cm.cms("species_names-result_operatorContains")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("species_names-result_02_Label")%>
                  <%=cm.cmsTitle("species_names-result_02_Title")%>
                  <input type="hidden" name="typeForm" value="<%=typeForm%>" />
                    <label for="criteriaSearch" class="noshow">
                      <%=cm.cms("species_names-result_03_Label")%>
                    </label>
                  <input id="criteriaSearch" title="<%=cm.cms("species_names-result_03_Title")%>" alt="<%=cm.cms("species_names-result_03_Title")%>" class="inputTextField" name="criteriaSearch" type="text" size="30" />
                  <%=cm.cmsLabel("species_names-result_03_Label")%>
                  <%=cm.cmsTitle("species_names-result_03_Title")%>
                  <input id="refine" title="<%=cm.cms("species_names-result_btnSearch_Title")%>" class="inputTextField" type="submit" name="Submit" value="<%=cm.cms("species_names-result_btnSearch")%>" />
                  <%=cm.cmsTitle("species_names-result_btnSearch_Title")%>
                  <%=cm.cmsInput("species_names-result_btnSearch")%>
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
                  <%=cm.cmsText("species_names-result_appliedFilters")%>:
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
                  <td style="background-color:#CCCCCC">
                    <a title="<%=cm.cms("species_names-result_04_Title")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>">
                      <img alt="<%=cm.cms("species_names-result_04_Alt")%>" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" />
                    </a>
                    <%=cm.cmsTitle("species_names-result_04_Title")%>
                    <%=cm.cmsAlt("species_names-result_04_Alt")%>
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
          <br />
<%
            Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
            navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
            navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
            navigatorFormFields.addElement("ascendency");
            navigatorFormFields.addElement("criteriaSearch");
            navigatorFormFields.addElement("useVernacular");
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
            sortURLFields.addElement("pageSize");
            sortURLFields.addElement("criteriaSearch");
            sortURLFields.addElement("useVernacular");
            String urlSortString = formBean.toURLParam(sortURLFields);
            AbstractSortCriteria sortGroup = formBean.lookupSortCriteria(NameSortCriteria.SORT_GROUP);
            AbstractSortCriteria sortOrder = formBean.lookupSortCriteria(NameSortCriteria.SORT_ORDER);
            AbstractSortCriteria sortFamily = formBean.lookupSortCriteria(NameSortCriteria.SORT_FAMILY);
            AbstractSortCriteria sortSciName = formBean.lookupSortCriteria(NameSortCriteria.SORT_SCIENTIFIC_NAME);
            AbstractSortCriteria sortValidName = formBean.lookupSortCriteria(NameSortCriteria.SORT_VALID_NAME);

            // Expand/Collapse vernacular names
            Vector expand = new Vector();
            expand.addElement("sort");
            expand.addElement("ascendency");
            expand.addElement("criteriaSearch");
            expand.addElement("oper");
            expand.addElement("criteriaType");
            expand.addElement("pageSize");
            expand.addElement("currentPage");
            expand.addElement("useVernacular");
            String expandURL = formBean.toURLParam(expand);
            boolean isExpanded = Utilities.checkedStringToBoolean(formBean.getExpand(), false);
            if (showVernacularNames && !isExpanded)
            {
          %>
              <a title="<%=cm.cms("species_names-result_05_Title")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsText("species_names-result_lnkDisplayVernNames")%></a>
              <%=cm.cmsTitle("species_names-result_05_Title")%>
          <%
            }
          %>
          <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
            <tr>
<%
            if (showGroup)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <a title="<%=cm.cms("species_names-result_07_Title")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsText("species_names-result_thGroup")%></a>
                <%=cm.cmsTitle("species_names-result_07_Title")%>
              </th>
<%
            }
            if (showOrder)
            {
%>
              <th style="text-align:left" class="resultHeader">
                    <%=cm.cmsText("species_names-result_thOrder")%>
              </th>
<%
            }
            if (showFamily)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <%=cm.cmsText("species_names-result_thFamily")%>
              </th>
<%
            }
            if (showScientificName)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <a title="<%=cm.cms("species_names-result_07_Title")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsText("species_names-result_thScientificName")%></a>
                <%=cm.cmsTitle("species_names-result_07_Title")%>
              </th>
<%
            }
            if (showValidName)
            {
%>
              <th class="resultHeader" style="text-align:center">
                <a title="<%=cm.cms("species_names-result_07_Title")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_VALID_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortValidName, (null == sortValidName) ? true : false)%>"><%=Utilities.getSortImageTag(sortValidName)%><%=cm.cmsText("species_names-result_thValidName")%></a>
                <%=cm.cmsTitle("species_names-result_07_Title")%>
              </th>
<%
            }
            if (showVernacularNames && isExpanded)
            {
%>
              <th style="text-align:left" class="resultHeader">
                  <%=cm.cmsText("species_names-result_thVernacularNames")%>
                  [<a title="<%=cm.cms("species_names-result_08_Title")%>" class="resultHeaderLink" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsText("species_names-result_hide")%></a><%=cm.cmsTitle("species_names-result_08_Title")%>]
              </th>
<%
            }
%>
            </tr>
<%
            Iterator it = results.iterator();
            // Coming from first form
            if (NameSearchCriteria.CRITERIA_SCIENTIFIC.intValue() == typeForm)
            {
              int col = 0;
              while ( it.hasNext() )
              {
                String bgColor = col++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF";
                ScientificNamePersist specie = ( ScientificNamePersist ) it.next();

                Vector vernNamesList = SpeciesSearchUtility.findVernacularNames( specie.getIdNatureObject() );
                // Sort this vernacular names in alphabetical order
                Vector sortVernList = new JavaSorter().sort( vernNamesList, JavaSorter.SORT_ALPHABETICAL );%>
            <tr>
            <%
              if ( showGroup )
              {
            %>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <%=Utilities.treatURLSpecialCharacters( specie.getCommonName() )%>
            </td>
            <%
              }
              if ( showOrder )
              {
            %>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <%=Utilities.formatString( Utilities.treatURLSpecialCharacters( specie.getTaxonomicNameOrder() ), "&nbsp;" )%>
            </td>
            <%
              }
              if ( showFamily )
              {
            %>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <%=Utilities.formatString( Utilities.treatURLSpecialCharacters( specie.getTaxonomicNameFamily() ), "&nbsp;" )%>
            </td>
            <%
              }
              if ( showScientificName )
              {
            %>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <a title="Open species factsheet" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters( specie.getScientificName() )%></a>
              <%
                if ( !specie.getTypeRelatedSpecies().equalsIgnoreCase( "Species" ) )
                {
              %>
              (<%=specie.getTypeRelatedSpecies()%>)
              <%
                }
              %>
            </td>
            <%
              }
              boolean isValid;
              if ( specie.getValidName() == null )
              {
                isValid = false;
              }
              else
              {
                isValid = specie.getValidName().intValue() == 1;
              }
              if ( showValidName )
              {
                if ( isValid )
                {
            %>
            <td class="resultCell" style="background-color : <%=bgColor%>; text-align : center;">
              <img alt="Valid species name" src="images/mini/check_green.gif" width="15" height="16" style="vertical-align:middle"
                   title="Yes"/>
            </td>
            <%
            }
            else
            {
            %>
            <td class="resultCell" style="background-color : <%=bgColor%>; text-align : center;">
              <img alt="Invalid species name" src="images/mini/invalid.gif" width="15" height="16" style="vertical-align:middle"
                   title="No"/>
            </td>
            <%
                }
              }
              if ( showVernacularNames && isExpanded )
              {
            %>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <%-- I display the vernacular names within a table inside the cell, DON'T USE ROWSPAN, YOU'L REGRET IT --%>
              <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                <%                  if ( sortVernList == null || sortVernList.size() <= 0 )
                {
                %>
                <tr><td>&nbsp;</td></tr>
                <%
                }
                else
                {
                  for ( int i = 0; i < sortVernList.size(); i++ )
                  {
                    VernacularNameWrapper aVernName = ( VernacularNameWrapper ) sortVernList.get( i );
                    String vernacularName = aVernName.getName();
                    String searchedName = formBean.getVernacularName();
                    String bgColor1 = ( 0 == i % 2 ) ? "#EEEEEE" : "#FFFFFF";
                    if ( null != searchedName && -1 != vernacularName.toLowerCase().lastIndexOf( searchedName.toLowerCase() ) )
                    {
                      bgColor1 = "#BBBBFF";
                    }
                %>
                <tr>
                  <td width="30%" style="background-color:<%=bgColor1%>" class="resultCell">
                    <%=Utilities.treatURLSpecialCharacters( aVernName.getLanguage() )%>
                  </td>
                  <td width="70%" style="background-color:<%=bgColor1%>" class="resultCell">
                    <%=Utilities.treatURLSpecialCharacters( vernacularName )%>
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
            // Coming from second form - ANY LANGUAGE
            if (NameSearchCriteria.CRITERIA_VERNACULAR.intValue() == typeForm && isAnyLanguage)
            {
              int col = 0;
              while (it.hasNext())
              {
                String bgColor = col++ % 2 == 0  ? "#EEEEEE" : "#FFFFFF";
                VernacularNameAnyPersist specie = (VernacularNameAnyPersist)it.next();
                Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
                // Sort this vernacular names in alphabetical order
                Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
%>
              <tr>
<%
              if (showGroup)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=Utilities.treatURLSpecialCharacters(specie.getCommonName())%>
                </td>
<%
              }
              if (showOrder)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=Utilities.treatURLSpecialCharacters(Utilities.formatString(specie.getTaxonomicNameOrder()))%>
                </td>
<%
              }
              if (showFamily)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <%=Utilities.treatURLSpecialCharacters(Utilities.formatString(specie.getTaxonomicNameFamily()))%>
                </td>
<%
              }
              if (showScientificName)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                  <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                </td>
<%
              }

                boolean isValid = specie.getValidName() != null && specie.getValidName().intValue() == 1 ? true : false;
                if ( showValidName )
                {
                  if ( isValid )
                  {
%>
                    <td class="resultCell" style="background-color : <%=bgColor%>; text-align : center;">
                      <img alt="Valid species name" src="images/mini/check_green.gif" width="15" height="16" style="vertical-align:middle"
                        title="Yes" />
                    </td>
<%
                  }
                  else
                  {
%>
                    <td class="resultCell" style="background-color : <%=bgColor%>; text-align : center;">
                      <img alt="Invalid species name" src="images/mini/invalid.gif" width="15" height="16" style="vertical-align:middle"
                        title="No" />
                    </td>
<%
                  }
                }

              if (showVernacularNames && isExpanded)
              {
%>
                <td class="resultCell" style="background-color : <%=bgColor%>">
                   <%-- I display the vernacular names within a table inside the cell, DON'T USE ROWSPAN, YOU'L REGRET IT --%>
                  <table summary="List of vernacular names" width="100%" border="0" cellspacing="0" cellpadding="0">
<%
                  if(sortVernList == null || sortVernList.size()<=0)
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
                  String searchedName = formBean.getVernacularName();
                  String bgColor1 = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
                  int relationOp = Utilities.checkedStringToInt( formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS).intValue();
                  if ( null != searchedName )
                  {
                    if ( relationOp == Utilities.OPERATOR_IS.intValue() && vernacularName.toLowerCase().equalsIgnoreCase( searchedName.toLowerCase() ) )
                    {
                      bgColor1 = "#BBBBFF";
                    }
                    if ( relationOp == Utilities.OPERATOR_CONTAINS.intValue() && vernacularName.toLowerCase().lastIndexOf( searchedName.toLowerCase() ) != -1 )
                    {
                      bgColor1 = "#BBBBFF";
                    }
                    if ( relationOp == Utilities.OPERATOR_STARTS.intValue() && vernacularName.toLowerCase().startsWith( searchedName.toLowerCase() ) )
                    {
                      bgColor1 = "#BBBBFF";
                    }
                  }
%>
                    <tr>
                      <td width="30%" style="background-color:<%=bgColor1%>" class="resultCell">
                        <%=Utilities.treatURLSpecialCharacters(aVernName.getLanguage())%>
                      </td>
                      <td width="70%" style="background-color:<%=bgColor1%>" class="resultCell">
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
              }
              // Coming from second form - A LANGUAGE
              if (NameSearchCriteria.CRITERIA_VERNACULAR.intValue() == typeForm && !isAnyLanguage)
              {
                int col = 0;
                while (it.hasNext())
                {
                  String bgColor = col++ % 2 == 0  ? "#EEEEEE" : "#FFFFFF";
                  VernacularNamePersist specie = (VernacularNamePersist)it.next();
                  Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
                  // Sort this vernacular names in alphabetical order
                  Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);%>
                  <tr>
<%
                  if (showGroup)
                  {
%>
                    <td class="resultCell" style="background-color : <%=bgColor%>">
                      <%=Utilities.treatURLSpecialCharacters(specie.getCommonName())%>
                    </td>
<%
                  }
                  if (showOrder)
                  {
%>
                    <td class="resultCell" style="background-color : <%=bgColor%>">
                      <%=Utilities.treatURLSpecialCharacters(Utilities.formatString(specie.getTaxonomicNameOrder()))%>
                    </td>
<%
                  }
                  if (showFamily)
                  {
%>
                    <td class="resultCell" style="background-color : <%=bgColor%>">
                      <%=Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameFamily())%>
                    </td>
<%
                  }
                  if (showScientificName)
                  {
%>
                    <td class="resultCell" style="background-color : <%=bgColor%>">
                      <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
                    </td>
<%
                  }

                boolean isValid = specie.getValidName() != null && specie.getValidName().intValue() == 1;
                if ( showValidName )
                {
                  if ( isValid )
                  {
%>
                    <td class="resultCell" style="background-color : <%=bgColor%>; text-align:center">
                      <img alt="Valid species name" src="images/mini/check_green.gif" width="15" height="16" style="vertical-align:middle"
                        title="Yes" />
                    </td>
<%
                  }
                  else
                  {
%>
                    <td class="resultCell" style="background-color : <%=bgColor%>; text-align:center">
                      <img alt="Invalid species name" src="images/mini/invalid.gif" width="15" height="16" style="vertical-align:middle"
                        title="No" />
                    </td>
<%
                  }
                }
    
                  if (showVernacularNames && isExpanded)
                  {
%>
                    <td class="resultCell" style="background-color : <%=bgColor%>">
                       <!-- I display the vernacular names within a table inside the cell, DON'T USE ROWSPAN, YOU'L REGRET IT -->
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<%                  if(sortVernList == null || sortVernList.size()<=0)
{
%>
<tr><td>&nbsp;</td></tr>
<%
} else
{

  for (int i = 0; i < sortVernList.size(); i++)
  {
    VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(i);
    String language = formBean.getLanguage();
    String specieLangName = aVernName.getLanguage();
    String vernacularName = aVernName.getName();
    String searchedName = formBean.getVernacularName();
    int relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS).intValue();
    if (language.toLowerCase().equalsIgnoreCase( specieLangName.toLowerCase()) || language.toLowerCase().equalsIgnoreCase("english") )
    {
      String bgColor1 = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
      if ( null != searchedName )
      {
        if ( relationOp == Utilities.OPERATOR_IS.intValue() && vernacularName.toLowerCase().equalsIgnoreCase( searchedName.toLowerCase() ) )
        {
          bgColor1 = "#BBBBFF";
        }
        if ( relationOp == Utilities.OPERATOR_CONTAINS.intValue() && vernacularName.toLowerCase().lastIndexOf( searchedName.toLowerCase() ) != -1 )
        {
          bgColor1 = "#BBBBFF";
        }
        if ( relationOp == Utilities.OPERATOR_STARTS.intValue() && vernacularName.toLowerCase().startsWith( searchedName.toLowerCase() ) )
        {
        bgColor1 = "#BBBBFF";
        }
      }
%>
                        <tr>
                          <td style="background-color:<%=bgColor1%>;white-space: nowrap" width="50%" class="resultCell">
                            <%=Utilities.treatURLSpecialCharacters(aVernName.getLanguage())%>
                          </td>
                          <td style="background-color:<%=bgColor1%>;white-space: nowrap" width="50%" class="resultCell">
                            <%=Utilities.treatURLSpecialCharacters(aVernName.getName())%>
                          </td>
                        </tr>
<%
    }
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
            if (showGroup)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <a title="<%=cm.cms("species_names-result_07_Title")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsText("species_names-result_thGroup")%></a>
                <%=cm.cmsTitle("species_names-result_07_Title")%>
              </th>
<%
            }
            if (showOrder)
            {
%>
              <th style="text-align:left" class="resultHeader">
                    <%=cm.cmsText("species_names-result_thOrder")%>
              </th>
<%
            }
            if (showFamily)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <%=cm.cmsText("species_names-result_thFamily")%>
              </th>
<%
            }
            if (showScientificName)
            {
%>
              <th style="text-align:left" class="resultHeader">
                <a title="<%=cm.cms("species_names-result_07_Title")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsText("species_names-result_thScientificName")%></a>
                <%=cm.cmsTitle("species_names-result_07_Title")%>
              </th>
<%
            }
            if (showValidName)
            {
%>
              <th class="resultHeader" style="text-align:center">
                <a title="<%=cm.cms("species_names-result_07_Title")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_VALID_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortValidName, (null == sortValidName) ? true : false)%>"><%=Utilities.getSortImageTag(sortValidName)%><%=cm.cmsText("species_names-result_thValidName")%></a>
                <%=cm.cmsTitle("species_names-result_07_Title")%>
              </th>
<%
            }
            if (showVernacularNames && isExpanded)
            {
%>
              <th style="text-align:left" class="resultHeader">
                  <%=cm.cmsText("species_names-result_thVernacularNames")%>
                  [<a title="<%=cm.cms("species_names-result_08_Title")%>" class="resultHeaderLink" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsText("species_names-result_hide")%></a><%=cm.cmsTitle("species_names-result_08_Title")%>]
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

<%=cm.br()%>
<%=cm.cmsMsg("species_names-result_pageTitle")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names-result_thGroup")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names-result_thScientificName")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names-result_operatorIs")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names-result_operatorStartWith")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_names-result_operatorContains")%>
<%=cm.br()%>
<%=cm.cmsMsg("search_results")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="<%=pageName%>" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>