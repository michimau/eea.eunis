<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick references, show species' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.species.speciesByReferences.RefDomain,
                 ro.finsiel.eunis.search.species.speciesByReferences.*,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.search.species.speciesByReferences.ReferencesPaginator"%>
<%@ page import="ro.finsiel.eunis.jrfTables.*" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.speciesByReferences.ReferencesBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  //System.out.println("author="+formBean.getAuthor());
  // Set the database connection parameters
  String SQL_DRV="";
  String SQL_URL="";
  String SQL_USR="";
  String SQL_PWD="";

  SQL_DRV = application.getInitParameter("JDBC_DRV");
  SQL_URL = application.getInitParameter("JDBC_URL");
  SQL_USR = application.getInitParameter("JDBC_USR");
  SQL_PWD = application.getInitParameter("JDBC_PWD");
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Check columns to be displayed
  boolean showGroup = Utilities.checkedStringToBoolean(formBean.getShowGroup(), ReferencesBean.HIDE);
  boolean showOrder = Utilities.checkedStringToBoolean(formBean.getShowOrder(), ReferencesBean.HIDE);
  boolean showFamily = Utilities.checkedStringToBoolean(formBean.getShowFamily(), ReferencesBean.HIDE);
  boolean showScientificName = true;
  boolean showVernacularNames = Utilities.checkedStringToBoolean(formBean.getShowVernacularName(), ReferencesBean.HIDE);
  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);

  // The main paginator
  ReferencesPaginator paginator = new ReferencesPaginator(new RefDomain(formBean.toSearchCriteria(),
                                                                        formBean.toSortCriteria(),
                                                                        SessionManager.getShowEUNISInvalidatedSpecies(),
                                                                        SQL_DRV,
                                                                        SQL_URL,
                                                                        SQL_USR,
                                                                        SQL_PWD));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "species-references-result.jsp";
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
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  WebContentManagement cm = SessionManager.getWebContent();
  String downloadLink = "javascript:openTSVDownload('reports/species/tsv-species-references.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,pick_references_show_species_location#species-references.jsp,results";
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
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
      function MM_openBrWindow(theURL,winName,features) { //v2.0
        window.open(theURL,winName,features);
      }
    //]]>
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_references-result_title")%>
    </title>
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
                  <jsp:param name="location" value="<%=location%>" />
                  <jsp:param name="downloadLink" value="<%=downloadLink%>" />
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
                    <li>
                      <a href="species-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <h1>
                  <%=cm.cmsPhrase("References")%>
                </h1>
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
                    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                      <%
                        ReferencesSearchCriteria mainCriteria = (ReferencesSearchCriteria)formBean.getMainSearchCriteria();
                      %>
                      <tr>
                        <td>
                          <%=cm.cmsPhrase("You searched species for which the selected references")%>
            <%
                          if( mainCriteria.toHumanString().length() > 0 )
                          {
            %>
                            (<%=cm.cmsPhrase("with")%> <strong><%=Utilities.treatURLAmp(mainCriteria.toHumanString())%></strong>)
            <%
                          }
            %>
                          <%=cm.cmsPhrase("are recorded in the database")%>
                        </td>
                      </tr>
                    </table>
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
                    pageSizeFormFields.addElement("oper");
                    pageSizeFormFields.addElement("criteriaType");
                    pageSizeFormFields.addElement("expand");
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
                      filterSearch.addElement("oper");
                      filterSearch.addElement("criteriaType");
                      filterSearch.addElement("pageSize");
                      filterSearch.addElement("expand");
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
                              <input type="hidden" name="criteriaType" value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>"  />
                              <%
                                  }
                              %>

                          <select id="select1" title="<%=cm.cms("criteria")%>" name="criteriaType" <%=(showGroup ? "" : "disabled=\"disabled\"")%>>
                              <%
                                  if (showGroup)
                                  {
                               %>
                                    <option value="<%=ReferencesSearchCriteria.CRITERIA_GROUP%>" selected="selected">
                                        <%=cm.cms("group")%>
                                    </option>
                              <%
                                  }
                              %>
                              <option value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>">
                                  <%=cm.cms("species_scientific_name")%>
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
                            <label for="criteriaSearch" class="noshow"><%=cm.cms("filter_value")%></label>
                            <input id="criteriaSearch" title="<%=cm.cms("filter_value")%>" alt="<%=cm.cms("filter_value")%>" name="criteriaSearch" type="text" size="30" />
                            <%=cm.cmsLabel("filter_value")%>
                            <%=cm.cmsTitle("filter_value")%>
                            <input id="refine" title="<%=cm.cms("search")%>" class="searchButton" type="submit" name="Submit" value="<%=cm.cms("search")%>" />
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
                                  <%= i + ". " + criteria.toHumanString()%></strong>
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
                    navigatorFormFields.addElement("oper");
                    navigatorFormFields.addElement("criteriaType");
                    navigatorFormFields.addElement("expand");
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
                        <a title="<%=cm.cms("show_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Display vernacular names in results list")%></a>
                        <%=cm.cmsTitle("show_vernacular_list")%>
                    <%
                      }
                    %>
                  <table class="sortable" width="100%" summary="<%=cm.cms("search_results")%>">
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
                      AbstractSortCriteria groupCrit = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_GROUP);
                      AbstractSortCriteria orderCrit = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_ORDER);
                      AbstractSortCriteria familyCrit = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_FAMILY);
                      AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_SCIENTIFIC_NAME);
                    %>
                    <thead>
                      <tr>
                        <%
                          if (showGroup)
                          {
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(groupCrit, null == groupCrit ? true : false)%>"><%=Utilities.getSortImageTag(groupCrit)%><%=cm.cmsPhrase("Group")%></a>
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
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, null == sciNameCrit)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsPhrase("Species scientific name")%></a>
                          <%=cm.cmsTitle("sort_results_on_this_column")%>
                        </th>
                        <%
                          if (showVernacularNames && isExpanded)
                          {
                        %>
                        <th scope="col">
                          <a title="<%=cm.cms("hide_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Vernacular names")%>[<%=cm.cmsPhrase("Hide")%>]</a><%=cm.cmsTitle("hide_vernacular_list")%>
                        </th>
                         <%
                          }
                         %>
                      </tr>
                    </thead>
                    <tbody>
            <%
              //===== Dynamic content =====
              if(null!=results)
              {
                Iterator it = results.iterator();
                int col = 0;
                while (it.hasNext())
                {
                  SpeciesRefWrapper specie = (SpeciesRefWrapper)it.next();
                  Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
                  // Sort this vernacular names in alphabetical order
                  Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
                  //String rowBgColor = (0 == (i++ % 2)) ? "#FFFFFF" : "#EEEEEE";
            %>
                      <tr>
               <%
                if (showGroup)
                {
               %>
                        <td>
                          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getGroupName()),"&nbsp;")%>
                        </td>
              <%
                }
                if (showOrder)
                {
              %>
                        <td>
                          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getOrderName()),"&nbsp;")%>
                        </td>
              <%
                }
                if (showFamily)
                {
              %>
                        <td>
                          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getFamilyName()),"&nbsp;")%>
                        </td>
              <%
                }
              %>
                        <td>
                          <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(Utilities.formatString(specie.getScientificName(),""))%></a>
                          <%=cm.cmsTitle("open_species_factsheet")%>
                        </td>
              <%
               if (showVernacularNames && isExpanded)
               {
              %>
                        <td>
                          <%-- I display the vernacular names within a table inside the cell, DON'T USE ROWSPAN, YOU'L REGRET IT --%>
                          <table summary="<%=cm.cms("list_vernacular")%>" width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align:center">
            <%               if(sortVernList == null || sortVernList.size()<=0)
                             {
            %>
                               <tr><td>&nbsp;</td></tr>
            <%
                        } else
                        {
                          for (int ii = 0; ii < sortVernList.size(); ii++)
                          {
                          VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(ii);
                          String vernacularName = aVernName.getName();
                          String bgColor1 = (0 == ii % 2) ? "#EEEEEE" : "#FFFFFF";
                          %>
                            <tr>
                              <td width="30%" style="background-color:<%=bgColor1%>;text-align:left">
                                &nbsp;
                                <%=Utilities.treatURLSpecialCharacters(aVernName.getLanguage())%>
                              </td>
                              <td width="70%" style="background-color:<%=bgColor1%>;text-align:left">
                                &nbsp;
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
            %>
                    </tbody>
                    <thead>
                      <tr>
                        <%
                          if (showGroup)
                          {
                        %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(groupCrit, null == groupCrit ? true : false)%>"><%=Utilities.getSortImageTag(groupCrit)%><%=cm.cmsPhrase("Group")%></a>
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
                        %>
                          <th scope="col">
                            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, null == sciNameCrit ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsPhrase("Species scientific name")%></a>
                            <%=cm.cmsTitle("sort_results_on_this_column")%>
                          </th>
                        <%
                          if (showVernacularNames && isExpanded)
                          {
                        %>
                          <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                            <a title="<%=cm.cms("hide_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsPhrase("Vernacular names")%>[<%=cm.cmsPhrase("Hide")%>]</a><%=cm.cmsTitle("hide_vernacular_list")%>
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
                <%=cm.cmsMsg("species_references-result_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("group")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("species_scientific_name")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("is")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("starts_with")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("contains")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("search_results")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("list_vernacular")%>
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
                <jsp:param name="page_name" value="species-references-result.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
