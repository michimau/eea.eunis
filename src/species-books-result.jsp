<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show references' function - results page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.references.ReferencesSearchCriteria,
                 ro.finsiel.eunis.search.species.references.ReferencesPaginator,
                 ro.finsiel.eunis.search.species.references.ReferencesSortCriteria,
                 ro.finsiel.eunis.jrfTables.species.references.*,
                 ro.finsiel.eunis.search.*" %>
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
        String tsvLink = "javascript:openlink('reports/species/tsv-species-books.jsp?" + formBean.toURLParam(reportFields) + "')";
        WebContentManagement contentManagement = SessionManager.getWebContent();
%>
    <title>
        <%=application.getInitParameter("PAGE_TITLE")%>
        <%=contentManagement.getContent("species_books-result_title", false)%>
    </title>
</head>

<body>
<div id="content">
<jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,References#species-books.jsp,Results"/>
    <jsp:param name="helpLink" value="species-help.jsp"/>
    <jsp:param name="downloadLink" value="<%=tsvLink%>"/>
</jsp:include>
<h5>
    <%=contentManagement.getContent("species_books-result_01")%>
</h5>
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
                <%=contentManagement.getContent("species_books-result_02")%> <strong><%=Utilities.treatURLAmp(descr.toString())%></strong>
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

<%=contentManagement.getContent("species_books-result_03")%>:
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
                <%=contentManagement.getContent("species_books-result_04")%>
            </strong>
        </td>
    </tr>
    <tr>
        <td style="background-color:#EEEEEE">
            <form name="refineSearch" method="get" onsubmit="return(validateRefineForm(<%=noCriteria%>));" action="">
                <%=formBean.toFORMParam(filterSearch)%>
                <label for="select1" class="noshow">Criteria</label>
                <select id="select1" title="Criteria" name="criteriaType" class="inputTextField">
                    <option value="<%=ReferencesSearchCriteria.CRITERIA_AUTHOR%>"><%=contentManagement.getContent("species_books-result_05", false)%></option>
                    <option value="<%=ReferencesSearchCriteria.CRITERIA_DATE%>"><%=contentManagement.getContent("species_books-result_06", false)%></option>
                    <option value="<%=ReferencesSearchCriteria.CRITERIA_TITLE%>" selected="selected"><%=contentManagement.getContent("species_books-result_07", false)%></option>
                    <option value="<%=ReferencesSearchCriteria.CRITERIA_EDITOR%>"><%=contentManagement.getContent("species_books-result_08", false)%></option>
                    <option value="<%=ReferencesSearchCriteria.CRITERIA_PUBLISHER%>"><%=contentManagement.getContent("species_books-result_09", false)%></option>
                </select>
                <label for="select2" class="noshow">Operator</label>
                <select id="select2" title="Criteria type" name="oper" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>"
                            selected="selected"><%=contentManagement.getContent("species_books-result_10", false)%></option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>"><%=contentManagement.getContent("species_books-result_11", false)%></option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("species_books-result_12", false)%></option>
                </select>
                <label for="criteriaSearch" class="noshow">
                 Criteria value
                </label>
                <input id="criteriaSearch" title="Criteria value" alt="Criteria value" class="inputTextField" name="criteriaSearch" type="text" size="30" />
                <label for="button1" class="noshow">
                 Search
                </label>
                <input id="button1" class="inputTextField" type="submit" name="Submit" title="<%=contentManagement.getContent("species_books-result_13", false )%>"
                       value="<%=contentManagement.getContent("species_books-result_13", false )%>" />
                <%=contentManagement.writeEditTag("species_books-result_13")%>
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
        <td style="background-color:#EEEEEE"><%=contentManagement.getContent("species_books-result_14")%>:</td>
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
            <a title="Delete a criteria"
               href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img
                    alt="Delete a criteria" src="images/mini/delete.jpg" border="0" style="vertical-align:middle"/></a>&nbsp;&nbsp;
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
<table summary="Table result" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse; vertical-align:middle;">
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
        <a title="Sort by Author" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_AUTHOR%>&amp;ascendency=<%=formBean.changeAscendency(sortAuthor, (null == sortAuthor))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortAuthor)%><%=contentManagement.getContent("species_books-result_05")%>
            </span>
        </a>
    </th>
    <th style="text-align:right;" class="resultHeader">
        <a title="Sort by Date" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortDate, (null == sortDate))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortDate)%><%=contentManagement.getContent("species_books-result_06")%>
            </span>
        </a>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <a title="Sort by Title" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_TITLE%>&amp;ascendency=<%=formBean.changeAscendency(sortTitle, (null == sortTitle))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortTitle)%><%=contentManagement.getContent("species_books-result_07")%>
            </span>
        </a>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <a title="Sort by Editor" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EDITOR%>&amp;ascendency=<%=formBean.changeAscendency(sortEditor, (null == sortEditor))%>">
        <span style="color:#FFFFFF">
            <%=Utilities.getSortImageTag(sortEditor)%><%=contentManagement.getContent("species_books-result_08")%>
        </span>
    </a></th>
    <th style="text-align:left;" class="resultHeader">
        <a title="Sort by Publisher" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_PUBLISHER%>&amp;ascendency=<%=formBean.changeAscendency(sortPublisher, (null == sortPublisher))%>">
        <span style="color:#FFFFFF">
            <%=Utilities.getSortImageTag(sortPublisher)%><%=contentManagement.getContent("species_books-result_09")%>
        </span>
    </a></th>
    <th style="text-align:left;" class="resultHeader">
        <span style="color:#FFFFFF">
            <%=contentManagement.getContent("species_books-result_15")%>
        </span>
    </th>
</tr>
<%
    Iterator it = results.iterator();
    while (it.hasNext()) {
        SpeciesBooksPersist book = (SpeciesBooksPersist) it.next();
        // Sort this vernacular names in alphabetical order
        String author = (book.getName() == null ? "" : book.getName());
        String url = book.getUrl().replaceAll("#", "");
%>
<tr>
    <td style="text-align:left">
        <%
            if (null != url && !url.equalsIgnoreCase("")) {
        %>
        <a target="_blank" href="<%=url%>"><%=Utilities.treatURLSpecialCharacters(author)%></a>
        <%
        } else {
        %>
        <%=Utilities.treatURLSpecialCharacters(author)%>
        <%
            }
        %>
    </td>
    <td style="text-align:right"><%=Utilities.formatString(Utilities.formatReferencesDate(book.getDate()), "&nbsp;")%></td>
    <td style="text-align:left"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.getTitle()), "&nbsp;")%></td>
    <td style="text-align:left"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.getEditor()), "&nbsp;")%></td>
    <td style="text-align:left"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(book.getPublisher()), "&nbsp;")%></td>
    <%
        //string URLDetail = search + "&amp;id=" + book.getId();
    %>
    <td style="text-align:left">
        <%--                  <a href="javascript:openlink('species-books-detail.jsp?<%=URLDetail%>')"><img src="images/group/5.gif" border="0"></a>--%>
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
        <table summary="List of species" border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse; background-color:#DDDDDD">
            <%
                for (int ii = 0; ii < resultsSpecies.size(); ii++)
                {
                    SpeciesBooksPersist specie = (SpeciesBooksPersist) resultsSpecies.get(ii);
                    String scientificName = Utilities.treatURLSpecialCharacters(specie.getName());
                    Integer idSpecies = specie.getId();
                    Integer idSpeciesLink = specie.getIdLink();
            %>
            <tr style="background-color:#FFFFFF">
                <td>
                    <a href="species-factsheet.jsp?idSpecies=<%=idSpecies%>&amp;idSpeciesLink=<%=idSpeciesLink%>"
                       title="Species factsheet"><%=scientificName%></a>
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
        <a title="Sort by Author" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_AUTHOR%>&amp;ascendency=<%=formBean.changeAscendency(sortAuthor, (null == sortAuthor))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortAuthor)%><%=contentManagement.getContent("species_books-result_05")%>
            </span>
        </a>
    </th>
    <th style="text-align:right;" class="resultHeader">
        <a title="Sort by Date" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_DATE%>&amp;ascendency=<%=formBean.changeAscendency(sortDate, (null == sortDate))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortDate)%><%=contentManagement.getContent("species_books-result_06")%>
            </span>
        </a>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <a title="Sort by Title" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_TITLE%>&amp;ascendency=<%=formBean.changeAscendency(sortTitle, (null == sortTitle))%>">
            <span style="color:#FFFFFF">
                <%=Utilities.getSortImageTag(sortTitle)%><%=contentManagement.getContent("species_books-result_07")%>
            </span>
        </a>
    </th>
    <th style="text-align:left;" class="resultHeader">
        <a title="Sort by Editor" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EDITOR%>&amp;ascendency=<%=formBean.changeAscendency(sortEditor, (null == sortEditor))%>">
        <span style="color:#FFFFFF">
            <%=Utilities.getSortImageTag(sortEditor)%><%=contentManagement.getContent("species_books-result_08")%>
        </span>
    </a></th>
    <th style="text-align:left;" class="resultHeader">
        <a title="Sort by Publisher" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_PUBLISHER%>&amp;ascendency=<%=formBean.changeAscendency(sortPublisher, (null == sortPublisher))%>">
        <span style="color:#FFFFFF">
            <%=Utilities.getSortImageTag(sortPublisher)%><%=contentManagement.getContent("species_books-result_09")%>
        </span>
    </a></th>
    <th style="text-align:left;" class="resultHeader">
        <span style="color:#FFFFFF">
            <%=contentManagement.getContent("species_books-result_15")%>
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
<jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="species-books-result.jsp"/>
</jsp:include>
</div>
</body>
</html>