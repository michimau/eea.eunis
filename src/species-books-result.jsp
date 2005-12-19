<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show references' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.references.ReferencesSearchCriteria,
                 ro.finsiel.eunis.search.species.references.ReferencesPaginator,
                 ro.finsiel.eunis.search.species.references.ReferencesSortCriteria,
                 ro.finsiel.eunis.jrfTables.species.references.*,
                 ro.finsiel.eunis.search.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.references.ReferencesBean" scope="request">
    <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
    <%
        // Prepare the search in results (fix)
        if (null != formBean.getRemoveFilterIndex()) {
            formBean.prepareFilterCriterias();
        }
        // Initialization
        int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
        ReferencesPaginator paginator = new ReferencesPaginator(new SpeciesBooksDomain(formBean.toSearchCriteria(), SessionManager.getShowEUNISInvalidatedSpecies()));

        paginator.setSortCriteria(formBean.toSortCriteria());
        paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
        currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
        final String pageName = "species-books-result.jsp";
        int resultsCount = 0;
        try {
            resultsCount = paginator.countResults();
        } catch (Exception e) {
            e.printStackTrace();
        }
        int pagesCount = 0;
        try {
            pagesCount = paginator.countPages();// This is used in @page include...
        } catch (Exception e) {
            e.printStackTrace();
        }
        int guid = 0;// This is used in @page include...
        // Now extract the results for the current page.
        List results = new ArrayList();
        try {
            results = paginator.getPage(currentPage);
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Set number criteria for the search result
        int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);
        // Prepare parameters for tsv
        Vector reportFields = new Vector();
        reportFields.addElement("sort");
        reportFields.addElement("ascendency");
        reportFields.addElement("criteriaSearch");
        reportFields.addElement("oper");
        reportFields.addElement("criteriaType");
        String tsvLink = "javascript:openTSVDownload('reports/species/tsv-species-books.jsp?" + formBean.toURLParam(reportFields) + "')";
        WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
        <%=application.getInitParameter("PAGE_TITLE")%>
        <%=cm.cms("species_books-result_title")%>
    </title>
</head>

<body>
<div id="outline">
<div id="alignment">
<div id="content">
<jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,pick_species_show_references_location#species-books.jsp,results_location"/>
    <jsp:param name="helpLink" value="species-help.jsp"/>
    <jsp:param name="downloadLink" value="<%=tsvLink%>"/>
</jsp:include>
<h1>
    <%=cm.cmsText("species_books-result_01")%>
</h1>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td colspan="3">
    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
        <%
            // Set search description
            StringBuffer descr = Utilities.prepareHumanString("scientific name", formBean.getScientificName(), Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS));
        %>
        <tr>
            <td>
                <%=cm.cmsText("species_books-result_02")%> <strong><%=Utilities.treatURLAmp(descr.toString())%></strong>
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

<%=cm.cmsText("species_books-result_03")%>:
<strong><%=resultsCount%></strong>

<%// Prepare parameters for pagesize.jsp
    Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
    pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
    pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
    pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
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
    filterSearch.addElement("criteriaSearch");
    filterSearch.addElement("pageSize");
%>

<br />
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td style="background-color:#EEEEEE">
            <strong>
                <%=cm.cmsText("species_books-result_04")%>
            </strong>
        </td>
    </tr>
    <tr>
        <td style="background-color:#EEEEEE">
            <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="">
                <%=formBean.toFORMParam(filterSearch)%>
                <label for="select1" class="noshow"><%=cm.cms("species_books-result_16_Label")%></label>
                <select id="select1" title="<%=cm.cms("species_books-result_16_Title")%>" name="criteriaType" class="inputTextField">
                    <option value="<%=ReferencesSearchCriteria.CRITERIA_AUTHOR%>">
                        <%=cm.cms("species_books-result_05")%>
                    </option>
                    <option value="<%=ReferencesSearchCriteria.CRITERIA_DATE%>">
                        <%=cm.cms("species_books-result_06")%>
                    </option>
                    <option value="<%=ReferencesSearchCriteria.CRITERIA_TITLE%>" selected="selected">
                        <%=cm.cms("species_books-result_07")%>
                    </option>
                    <option value="<%=ReferencesSearchCriteria.CRITERIA_EDITOR%>">
                        <%=cm.cms("species_books-result_08")%>
                    </option>
                    <option value="<%=ReferencesSearchCriteria.CRITERIA_PUBLISHER%>">
                        <%=cm.cms("species_books-result_09")%>
                    </option>
                </select>
                <%=cm.cmsLabel("species_books-result_16_Label")%>
                <%=cm.cmsTitle("species_books-result_16_Title")%>
                <label for="select2" class="noshow"><%=cm.cms("species_books-result_17_Label")%></label>
                <select id="select2" title="<%=cm.cms("species_books-result_17_Title")%>" name="oper" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                        <%=cm.cms("species_books-result_10")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>">
                        <%=cm.cms("species_books-result_11")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                        <%=cm.cms("species_books-result_12")%>
                    </option>
                </select>
                <%=cm.cmsLabel("species_books-result_17_Label")%>
                <%=cm.cmsTitle("species_books-result_17_Title")%>
                <label for="criteriaSearch" class="noshow">
                 <%=cm.cms("species_books-result_18_Label")%>
                </label>
                <input id="criteriaSearch" title="<%=cm.cms("species_books-result_18_Title")%>" alt="<%=cm.cms("species_books-result_18_Title")%>" class="inputTextField" name="criteriaSearch" type="text" size="30" />
                <%=cm.cmsLabel("species_books-result_18_Label")%>
                <%=cm.cmsTitle("species_books-result_18_Title")%>
                <label for="button1" class="noshow">
                 <%=cm.cms("species_books-result_13_Title")%>
                </label>
                <input id="button1" class="inputTextField" type="submit" name="Submit" title="<%=cm.cms("species_books-result_13_Title")%>"
                       value="<%=cm.cms("species_books-result_13")%>" />
                <%=cm.cmsLabel("species_books-result_13_Title")%>
                <%=cm.cmsTitle("species_books-result_13_Title")%>
                <%=cm.cmsInput("species_books-result_13")%>
            </form>
        </td>
    </tr>
    <%-- This is the code which shows the search filters --%>
    <%
        AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
        if (criterias.length > 1)
        {
    %>
    <tr>
        <td style="background-color:#EEEEEE"><%=cm.cmsText("species_books-result_14")%>:</td>
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
            <a title="<%=cm.cms("species_books-result_19_Title")%>"
               href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img
                    alt="<%=cm.cms("species_books-result_19_Alt")%>" src="images/mini/delete.jpg" border="0" style="vertical-align:middle"/></a>&nbsp;&nbsp;
            <%=cm.cmsTitle("species_books-result_19_Title")%>
            <%=cm.cmsAlt("species_books-result_19_Alt")%>
            <strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
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
    <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
    <jsp:param name="pageName" value="<%=pageName%>"/>
    <jsp:param name="guid" value="<%=guid%>"/>
    <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
    <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
    <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
</jsp:include>
<table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
<%// Compute the sort criteria
    Vector sortURLFields = new Vector();      /* Used for sorting */
    sortURLFields.addElement("pageSize");
    sortURLFields.addElement("criteriaSearch");
    String urlSortString = formBean.toURLParam(sortURLFields);
    AbstractSortCriteria sortAuthor = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_AUTHOR);
    AbstractSortCriteria sortDate = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_DATE);
    AbstractSortCriteria sortTitle = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_TITLE);
    AbstractSortCriteria sortEditor = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_EDITOR);
    AbstractSortCriteria sortPublisher = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_PUBLISHER);
    Vector speciesURLFields = new Vector();
    speciesURLFields.addElement("criteriaSearch");
    String search = formBean.toURLParam(speciesURLFields);
%>
<tr>
    <th style="text-align:left" class="resultHeader">
        <a title="<%=cm.cms("species_books-result_21_Title")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_AUTHOR%>&amp;ascendency=<%=formBean.changeAscendency(sortAuthor, (null == sortAuthor))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortAuthor)%><%=cm.cmsText("species_books-result_05")%>
            </span>
        </a>
        <%=cm.cmsTitle("species_books-result_21_Title")%>
    </th>
    <th style="text-align:right;" class="resultHeader">
        <a title="<%=cm.cms("species_books-result_21_Title")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortDate, (null == sortDate))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortDate)%><%=cm.cmsText("species_books-result_06")%>
            </span>
        </a>
        <%=cm.cmsTitle("species_books-result_21_Title")%>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <a title="<%=cm.cms("species_books-result_21_Title")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_TITLE%>&amp;ascendency=<%=formBean.changeAscendency(sortTitle, (null == sortTitle))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortTitle)%><%=cm.cmsText("species_books-result_07")%>
            </span>
        </a>
        <%=cm.cmsTitle("species_books-result_21_Title")%>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <a title="<%=cm.cms("species_books-result_21_Title")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EDITOR%>&amp;ascendency=<%=formBean.changeAscendency(sortEditor, (null == sortEditor))%>">
        <span style="color:#FFFFFF">
            <%=Utilities.getSortImageTag(sortEditor)%><%=cm.cmsText("species_books-result_08")%>
        </span>
    </a>
    <%=cm.cmsTitle("species_books-result_21_Title")%>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <a title="<%=cm.cms("species_books-result_21_Title")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_PUBLISHER%>&amp;ascendency=<%=formBean.changeAscendency(sortPublisher, (null == sortPublisher))%>">
        <span style="color:#FFFFFF">
            <%=Utilities.getSortImageTag(sortPublisher)%><%=cm.cmsText("species_books-result_09")%>
        </span>
    </a>
    <%=cm.cmsTitle("species_books-result_21_Title")%>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <span style="color:#FFFFFF">
            <%=cm.cmsText("species_books-result_15")%>
        </span>
    </th>
</tr>
<%
  Iterator it = results.iterator();
  int col = 0;
  while (it.hasNext())
  {
    String bgColor = col++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF";
    SpeciesBooksPersist book = (SpeciesBooksPersist) it.next();
    // Sort this vernacular names in alphabetical order
    String author = (book.getName() == null ? "" : book.getName());
    String url = book.getUrl().replaceAll("#", "");
%>
<tr>
    <td class="resultCell" style="background-color : <%=bgColor%>">
        <%
            if (null != url && !url.equalsIgnoreCase(""))
            {
        %>
        <a target="_blank" href="<%=url%>"><%=Utilities.treatURLSpecialCharacters(author)%></a>
        <%
        } else
        {
        %>
        <%=Utilities.treatURLSpecialCharacters(author)%>
        <%
        }
        %>
    </td>
    <td class="resultCell" style="background-color : <%=bgColor%>; text-align : right;">
      <%=Utilities.formatString(Utilities.formatReferencesDate(book.getDate()), "&nbsp;")%>
    </td>
    <td class="resultCell" style="background-color : <%=bgColor%>">
      <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.getTitle()), "&nbsp;")%>
    </td>
    <td class="resultCell" style="background-color : <%=bgColor%>">
      <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.getEditor()), "&nbsp;")%>
    </td>
    <td class="resultCell" style="background-color : <%=bgColor%>">
      <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.getPublisher()), "&nbsp;")%>
    </td>
    <%
        //string URLDetail = search + "&amp;id=" + book.getId();
    %>
    <td class="resultCell" style="background-color : <%=bgColor%>">
        <%
            SpeciesBooksDomain domain = new SpeciesBooksDomain(formBean.toSearchCriteria(), SessionManager.getShowEUNISInvalidatedSpecies());
            // List of species attributes related to this reference
            List resultsSpecies = new ArrayList();
            try
            {
                resultsSpecies = domain.getSpeciesForAReference(book.getId().toString());
            } catch(Exception e) {e.printStackTrace();}

            if (resultsSpecies != null && resultsSpecies.size() > 0)
            {
        %>
        <table summary="<%=cm.cms("species_books-result_22_Sum")%>" border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse;">
            <%
                for (int ii = 0; ii < resultsSpecies.size(); ii++)
                {
                    SpeciesBooksPersist specie = (SpeciesBooksPersist) resultsSpecies.get(ii);
                    String scientificName = Utilities.treatURLSpecialCharacters(specie.getName());
                    Integer idSpecies = specie.getId();
                    Integer idSpeciesLink = specie.getIdLink();
            %>
            <tr>
                <td>
                    <a href="species-factsheet.jsp?idSpecies=<%=idSpecies%>&amp;idSpeciesLink=<%=idSpeciesLink%>"
                       title="<%=cm.cms("species_books-result_23_Title")%>"><%=scientificName%></a>
                    <%=cm.cmsTitle("species_books-result_23_Title")%>
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
%>
<tr>
    <th style="text-align:left" class="resultHeader">
        <a title="<%=cm.cms("species_books-result_21_Title")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_AUTHOR%>&amp;ascendency=<%=formBean.changeAscendency(sortAuthor, (null == sortAuthor))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortAuthor)%><%=cm.cmsText("species_books-result_05")%>
            </span>
        </a>
        <%=cm.cmsTitle("species_books-result_21_Title")%>
    </th>
    <th style="text-align:right;" class="resultHeader">
        <a title="<%=cm.cms("species_books-result_21_Title")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortDate, (null == sortDate))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortDate)%><%=cm.cmsText("species_books-result_06")%>
            </span>
        </a>
        <%=cm.cmsTitle("species_books-result_21_Title")%>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <a title="<%=cm.cms("species_books-result_21_Title")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_TITLE%>&amp;ascendency=<%=formBean.changeAscendency(sortTitle, (null == sortTitle))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortTitle)%><%=cm.cmsText("species_books-result_07")%>
            </span>
        </a>
        <%=cm.cmsTitle("species_books-result_21_Title")%>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <a title="<%=cm.cms("species_books-result_21_Title")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EDITOR%>&amp;ascendency=<%=formBean.changeAscendency(sortEditor, (null == sortEditor))%>">
        <span style="color:#FFFFFF">
            <%=Utilities.getSortImageTag(sortEditor)%><%=cm.cmsText("species_books-result_08")%>
        </span>
    </a>
    <%=cm.cmsTitle("species_books-result_21_Title")%>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <a title="<%=cm.cms("species_books-result_21_Title")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_PUBLISHER%>&amp;ascendency=<%=formBean.changeAscendency(sortPublisher, (null == sortPublisher))%>">
        <span style="color:#FFFFFF">
            <%=Utilities.getSortImageTag(sortPublisher)%><%=cm.cmsText("species_books-result_09")%>
        </span>
    </a>
    <%=cm.cmsTitle("species_books-result_21_Title")%>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <span style="color:#FFFFFF">
            <%=cm.cmsText("species_books-result_15")%>
        </span>
    </th>
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
</td></tr>
</table>

<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_05")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_06")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_07")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_08")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_09")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_10")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_11")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_12")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_20_Sum")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books-result_22_Sum")%>
<%=cm.br()%>

<jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="species-books-result.jsp"/>
</jsp:include>
</div>
</div>
</div>
</body>
</html>