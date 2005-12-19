<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species advanced search results.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.jrfTables.species.advanced.DictionaryPersist,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.JavaSorter,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.search.species.advanced.DictionaryPaginator,
                 ro.finsiel.eunis.jrfTables.species.advanced.DictionaryDomain,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.advanced.AdvancedSortCriteria,
                 ro.finsiel.eunis.search.Utilities"%>
<%@ page import="ro.finsiel.eunis.session.SessionManager"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
    <%
        WebContentManagement cm = SessionManager.getWebContent();
    %>
    <jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
      <jsp:setProperty name="formBean" property="*"/>
    </jsp:useBean>
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=cm.cms("species_advanced_result_title")%></title>
  </head>
<%
//  Utilities.dumpRequestParams(request);

  AbstractPaginator paginator = null;
  String searchedDatabase = formBean.getSearchedNatureObject();
  paginator = new DictionaryPaginator(new DictionaryDomain(request.getSession().getId()));
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "species-advanced-results.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  Iterator it = (null != results) ? results.iterator() : new Vector().iterator();

  Vector columnsDisplayed = formBean.parseShowColumns();
  boolean showGroup = (columnsDisplayed.contains("showGroup")) ? true : false;
  boolean showOrder = (columnsDisplayed.contains("showOrder")) ? true : false;
  boolean showFamily = (columnsDisplayed.contains("showFamily")) ? true : false;
  boolean showScientificName = (columnsDisplayed.contains("showScientificName")) ? true : false;
  boolean showVernacularName = (columnsDisplayed.contains("showVernacularName")) ? true : false;
  boolean showDistribution = (columnsDisplayed.contains("showDistribution")) ? true : false;
  boolean showThreat = (columnsDisplayed.contains("showThreat")) ? true : false;
  boolean showCountry = (columnsDisplayed.contains("showCountry")) ? true : false;
  boolean showRegion = (columnsDisplayed.contains("showRegion")) ? true : false;
  boolean showSynonyms = (columnsDisplayed.contains("showSynonyms")) ? true : false;
  boolean showReferences = (columnsDisplayed.contains("showReferences")) ? true : false;
  boolean showSource = (columnsDisplayed.contains("showSource")) ? true : false;
  boolean showEditor = (columnsDisplayed.contains("showEditor")) ? true : false;
  boolean showBookTitle = (columnsDisplayed.contains("showBookTitle")) ? true : false;


  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  String downloadLink = "javascript:openTSVDownload('reports/species/tsv-species-advanced.jsp?" + formBean.toURLParam(reportFields) + "')";
%>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,advanced_search_location#species-advanced.jsp,results_location"/>
        <jsp:param name="downloadLink" value="<%=downloadLink%>"/>
      </jsp:include>
      <h1>
        <%=cm.cmsText("species_advanced_result_01")%>
      </h1>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <%=cm.cmsText("species_advanced_result_02")%>
          </td>
        </tr>
        <tr>
          <td>
            <%=cm.cmsText("species_advanced_result_03")%> <%=SessionManager.getExplainedcriteria()%><%=cm.cmsText("species_advanced_result_04")%>
          </td>
        </tr>
        <tr>
          <td>
            <%=SessionManager.getListcriteria()%>
          </td>
        </tr>
      </table>
<%
  if (results.isEmpty())
  {
%>
    <jsp:include page="noresults.jsp" />
<%
    return;
  }
%>
    <br />
    <%=cm.cmsText("species_advanced_result_05")%> <strong><%=resultsCount%></strong>
    <br />
<%
  // Prepare parameters for pagesize.jsp
  Vector pageSizeFormFields = new Vector();
  pageSizeFormFields.addElement("sort");
  pageSizeFormFields.addElement("ascendency");
%>
    <jsp:include page="pagesize.jsp">
      <jsp:param name="guid" value="<%=guid%>"/>
      <jsp:param name="pageName" value="<%=pageName%>"/>
      <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>"/>
      <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>"/>
    </jsp:include>
  <%
    // Prepare the form parameters.
    Vector filterSearch = new Vector();
    filterSearch.addElement("sort");
    filterSearch.addElement("ascendency");
    filterSearch.addElement("pageSize");
  %>
    <br />
<%
  Vector navigatorFormFields = new Vector();
  navigatorFormFields.addElement("pageSize");
  navigatorFormFields.addElement("sort");
  navigatorFormFields.addElement("ascendency");
%>
    <jsp:include page="navigator.jsp">
      <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
      <jsp:param name="pageName" value="<%=pageName%>"/>
      <jsp:param name="guid" value="<%=guid%>"/>
      <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
      <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
      <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
    </jsp:include>
    <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
<%
  Vector sortURLFields = new Vector();
  sortURLFields.addElement("pageSize");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria sortGroup = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_GROUP);
  AbstractSortCriteria sortOrder = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_ORDER);
  AbstractSortCriteria sortFamily = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_FAMILY);
  AbstractSortCriteria sortSciName = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SCIENTIFIC_NAME);
%>
      <tr>
<%
  if (showGroup)
  {
%>
        <th class="resultHeader">
          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, null == sortGroup)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsText("group")%></a>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
<%
  }
  if (showOrder)
  {
%>
        <th class="resultHeader">
          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ORDER%>&amp;ascendency=<%=formBean.changeAscendency(sortOrder, null == sortOrder)%>"><%=Utilities.getSortImageTag(sortOrder)%><%=cm.cmsText("order")%></a>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
<%
  }
  if (showFamily)
  {
%>
        <th class="resultHeader">
          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_FAMILY%>&amp;ascendency=<%=formBean.changeAscendency(sortFamily, null == sortFamily)%>"><%=Utilities.getSortImageTag(sortFamily)%><%=cm.cmsText("family")%></a>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
<%
  }
  if (showScientificName)
  {
%>
        <th class="resultHeader">
          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, null == sortSciName)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsText("scientific_name")%></a>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
<%
  }
  if (showVernacularName)
  {
%>
        <th class="resultHeader"><%=cm.cmsText("vernacular_name")%></th>
<%
  }
  if (showSource)
  {
%>
        <th class="resultHeader"><%=cm.cmsText("source")%></th>
<%
  }
  if (showEditor)
  {
%>
        <th class="resultHeader"><%=cm.cmsText("editor")%></th>
<%
  }
  if (showBookTitle)
  {
%>
        <th class="resultHeader"><%=cm.cmsText("title")%></th>
<%
  }
%>
      </tr>
<%
  int col = 0;
  while (it.hasNext())
  {
    String bgColor = col++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF";
    DictionaryPersist specie = (DictionaryPersist)it.next();
    String order = Utilities.formatString(specie.getTaxonomicNameOrder());
    String family = Utilities.formatString(specie.getTaxonomicNameFamily());
    Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
    Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
%>
      <tr>
<%
  if (showGroup)
  {
%>
        <td class="resultCell" style="background-color : <%=bgColor%>">
          <%=specie.getCommonName()%>
        </td>
<%
  }
  if (showOrder)
  {
%>
        <td class="resultCell" style="background-color : <%=bgColor%>">
          <%=order%>
        </td>
<%
  }
  if (showFamily)
  {
%>
        <td class="resultCell" style="background-color : <%=bgColor%>">
          <%=family%>
        </td>
<%
  }
  if (showScientificName)
  {
%>
        <td class="resultCell" style="background-color : <%=bgColor%>">
          <a href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=specie.getScientificName()%></a>
        </td>
<%
  }
  if (showVernacularName)
  {
%>
        <td class="resultCell" style="background-color : <%=bgColor%>">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<%
    String bgColor1 = "";
    for (int i = 0; i < sortVernList.size(); i++)
    {
      VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(i);
      String vernacularName = aVernName.getName();
      bgColor1 = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
%>
            <tr>
              <td bgcolor="<%=bgColor1%>">
                <%=aVernName.getLanguage()%>
              </td>
              <td bgcolor="<%=bgColor1%>">
                <%=vernacularName%>
              </td>
            </tr>
<%
    }
%>
          </table>
        </td>
<%
  }
  if (showSource)
  {
%>
        <td class="resultCell" style="background-color : <%=bgColor%>">
          <%=specie.getSource()%>
        </td>
<%
  }
  if (showEditor)
  {
%>
        <td class="resultCell" style="background-color : <%=bgColor%>">
          <%=specie.getEditor()%>
        </td>
<%
  }
  if (showBookTitle) {%>
        <td>
          <%=specie.getBookTitle()%>&nbsp;
        </td>
<%
  }
%>
      </tr>
<%
  }
%>
    <tr>
<%
  if (showGroup)
  {
%>
        <th class="resultHeader">
          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, null == sortGroup)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsText("group")%></a>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
<%
  }
  if (showOrder)
  {
%>
        <th class="resultHeader">
          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ORDER%>&amp;ascendency=<%=formBean.changeAscendency(sortOrder, null == sortOrder)%>"><%=Utilities.getSortImageTag(sortOrder)%><%=cm.cmsText("order")%></a>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
<%
  }
  if (showFamily)
  {
%>
        <th class="resultHeader">
          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_FAMILY%>&amp;ascendency=<%=formBean.changeAscendency(sortFamily, null == sortFamily)%>"><%=Utilities.getSortImageTag(sortFamily)%><%=cm.cmsText("family")%></a>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
<%
  }
  if (showScientificName)
  {
%>
        <th class="resultHeader">
          <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, null == sortSciName)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsText("scientific_name")%></a>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
<%
  }
  if (showVernacularName)
  {
%>
        <th class="resultHeader"><%=cm.cmsText("vernacular_name")%></th>
<%
  }
  if (showSource)
  {
%>
        <th class="resultHeader"><%=cm.cmsText("source")%></th>
<%
  }
  if (showEditor)
  {
%>
        <th class="resultHeader"><%=cm.cmsText("editor")%></th>
<%
  }
  if (showBookTitle)
  {
%>
        <th class="resultHeader"><%=cm.cmsText("title")%></th>
<%
  }
%>
      </tr>
  </table>
          <jsp:include page="navigator.jsp">
            <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
            <jsp:param name="pageName" value="<%=pageName%>"/>
            <jsp:param name="guid" value="<%=guid + 1%>"/>
            <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
            <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
            <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
          </jsp:include>
    <%=cm.br()%>
    <%=cm.cmsMsg("species_advanced_result_title")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("species_advanced_result_06")%>
    <%=cm.br()%>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-advanced-results.jsp" />
    </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>