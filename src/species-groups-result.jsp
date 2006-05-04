<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2004 European Environment Agency
  - Description : 'Species groups' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.species.groups.GroupsDomain,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.species.groups.GroupsPersist,
                 ro.finsiel.eunis.search.species.groups.GroupSearchCriteria,
                 ro.finsiel.eunis.search.species.groups.GroupSortCriteria,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.search.species.groups.GroupsBean"%>
<%@ page import="ro.finsiel.eunis.search.species.groups.GroupsPaginator"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.groups.GroupsBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_groups-result_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
        var errRefineMessage = "<%=cm.cms("enter_refine_criteria_correctly")%>.";
        // Used in refine search ; check if criteria are empty
        function checkRefineSearch(noCriteria)
        {
          if(noCriteria == 0)
          {
            Name = trim(document.resultSearch.criteriaSearch.value);
            if (Name == "")
            {
              alert(errRefineMessage);
              return false;
            } else {
              return true;
            }
          } else {
            var isSomeoneEmplty = 0;
            for (i = 0; i <= noCriteria; i++)
            {
              if (trim(document.resultSearch.criteriaSearch[i].value) == "")
              {
                isSomeoneEmplty = 1;
              }
            }
            if (isSomeoneEmplty == 1)
            {
              alert(errRefineMessage);
              return false;
            } else {
              return true;
            }
          }
        }
       //-->
    </script>
  </head>
  <%
    if(formBean.getGroupID() == null && formBean.getGroupName() != null)
      formBean.setGroupID(Utilities.getIdGroupSpeciesByGroupName(formBean.getGroupName()));


    // Prepare the search in results (fix)
    if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }

    // Columns to be displayed
    boolean showGroup = Utilities.checkedStringToBoolean(formBean.getShowGroup(), GroupsBean.HIDE);
    boolean showOrder = Utilities.checkedStringToBoolean(formBean.getShowOrder(), GroupsBean.HIDE);
    boolean showFamily = Utilities.checkedStringToBoolean(formBean.getShowFamily(), GroupsBean.HIDE);
    boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), GroupsBean.HIDE);
    boolean showVernacularNames = Utilities.checkedStringToBoolean(formBean.getShowVernacularNames(), GroupsBean.HIDE);

    int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
    // The main paginator
    GroupsPaginator paginator = new GroupsPaginator(new GroupsDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), SessionManager.getShowEUNISInvalidatedSpecies()));
    // Initialisation
    paginator.setSortCriteria(formBean.toSortCriteria());
    paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));

    List results = paginator.getPage(currentPage);
    int resultsCount = paginator.countResults();
    int pagesCount = paginator.countPages();// This is used in @page include...

    currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
//    int resultsCount = paginator.countResults();
    final String pageName = "species-groups-result.jsp";
//    int pagesCount = paginator.countPages();// This is used in @page include...
    int guid = 0;// This is used in @page include...
    // Now extract the results for the current page.

    // Prepare parameters for tsv
    Vector reportFields = new Vector();
    reportFields.addElement("sort");
    reportFields.addElement("ascendency");
    reportFields.addElement("criteriaSearch");
    reportFields.addElement("criteriaSearch");
    reportFields.addElement("oper");
    reportFields.addElement("criteriaType");
    reportFields.addElement("expand");

    // Set number criteria for the search result
    int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);
    String downloadLink = "javascript:openTSVDownload('reports/species/tsv-species-groups.jsp?" + formBean.toURLParam(reportFields) + "')";
  %>
  <body style="background-color:#ffffff">
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home#index.jsp,species#species.jsp,groups#species-groups.jsp,results" />
      <jsp:param name="helpLink" value="species-help.jsp" />
      <jsp:param name="downloadLink" value="<%=downloadLink%>" />
    </jsp:include>
<%--      <jsp:param name="printLink" value="<%=printLink%>"/>--%>
    <h1>
     <%=cm.cmsText("species_group")%>
    </h1>
    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td colspan="3">
            <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>
                  <%=cm.cmsText("species_groups-result_03")%>
                  <strong>
                    <%=Utilities.treatURLAmp(formBean.getGroupName())%>
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
        <%=cm.cmsText("results_found_1")%>:
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
          <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="background-color:#EEEEEE">
                    <%=cm.cmsText("refine_your_search")%>
              </td>
            </tr>
            <tr>
              <td style="background-color:#EEEEEE">
                <form name="resultSearch" method="get" onsubmit="return(checkRefineSearch(<%=noCriteria%>));" action="">
                  <%=formBean.toFORMParam(filterSearch)%>
                  <label for="select1" class="noshow"><%=cm.cms("criteria")%></label>
                  <input type="hidden" name="criteriaType" value="<%=GroupSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" />
                  <select id="select1" title="<%=cm.cms("criteria")%>" name="criteriaType" class="inputTextField" disabled="disabled">
<%
                 if (showScientificName)
                 {
%>
                    <option value="<%=GroupSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                      <%=cm.cms("scientific_name")%>
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
                  <label for="criteriaSearch" class="noshow">
                   <%=cm.cms("filter_value")%>
                  </label>
                  <input id="criteriaSearch"  title="<%=cm.cms("filter_value")%>" alt="<%=cm.cms("filter_value")%>" class="inputTextField" name="criteriaSearch" type="text" size="30" />
                  <%=cm.cmsLabel("filter_value")%>
                  <%=cm.cmsTitle("filter_value")%>
                  <input id="refine" title="<%=cm.cms("search")%>" class="inputTextField" type="submit" name="Submit" value="<%=cm.cms("search")%>" />
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
            <a title="<%=cm.cms("show_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsText("display_vernacular_names_in_results")%></a>
            <%=cm.cmsTitle("show_vernacular_list")%>
<%
          }
%>
        <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
          <%// Compute the sort criteria
            Vector sortURLFields = new Vector();      /* Used for sorting */
            sortURLFields.addElement("pageSize");
            sortURLFields.addElement("criteriaSearch");
            sortURLFields.addElement("oper");
            sortURLFields.addElement("criteriaType");
            sortURLFields.addElement("currentPage");
            sortURLFields.addElement("expand");
            String urlSortString = formBean.toURLParam(sortURLFields);
            AbstractSortCriteria groupCrit = formBean.lookupSortCriteria(GroupSortCriteria.SORT_GROUP);
            AbstractSortCriteria orderCrit = formBean.lookupSortCriteria(GroupSortCriteria.SORT_ORDER);
            AbstractSortCriteria familyCrit = formBean.lookupSortCriteria(GroupSortCriteria.SORT_FAMILY);
            AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(GroupSortCriteria.SORT_SCIENTIFIC_NAME);
          %>
          <tr>
<%
              if (showGroup)
              {
%>
              <th style="text-align:left" class="resultHeader">
                <%=cm.cmsText("group")%>
              </th>
<%
              }
              if (showOrder)
              {
%>
              <th style="text-align:left" class="resultHeader">
                <%=cm.cmsText("order_column")%>
              </th>
<%
              }
              if (showFamily)
              {
%>
              <th style="text-align:left" class="resultHeader">
                <%=cm.cmsText("family")%>
              </th>
<%
              }
              if (showScientificName)
              {
%>
              <th style="text-align:left" class="resultHeader">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=GroupSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("scientific_name")%></a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </th>
<%
              }
              if (showVernacularNames && isExpanded)
              {
%>
              <th style="text-align:left" class="resultHeader">
                <%=cm.cmsText("vernacular_names")%>
                [<a title="<%=cm.cms("hide_vernacular_list")%>" class="resultHeaderLink" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsText("hide")%></a>]
                <%=cm.cmsTitle("hide_vernacular_list")%>
              </th>
<%
              }
%>
          </tr>
<%
            Iterator it = results.iterator();
            int col = 0;
            while (it.hasNext())
            {
              String bgColor = col++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF";
              GroupsPersist specie = (GroupsPersist)it.next();
              Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
              // Sort this vernacular names in alphabetical order
              Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
%>
          <tr>
<%
              if ( showGroup )
              {
%>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getCommonName()),"&nbsp;")%>
            </td>
<%
              }
              if ( showOrder )
              {
%>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameOrder()),"&nbsp;")%>
            </td>
<%
              }
              if (showFamily)
              {
%>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getTaxonomicNameFamily()),"&nbsp;")%>
            </td>
<%
              }
              if (showScientificName)
              {
%>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScientificName())%></a>
              <%=cm.cmsTitle("open_species_factsheet")%>
            </td>
<%
              }
              if (showVernacularNames && isExpanded)
              {
%>
              <td class="resultCell" style="background-color : <%=bgColor%>">
                <table summary="<%=cm.cms("list_vernacular")%>" width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align:center">
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
                  String vernacularName = aVernName.getName();
                  String bgColor1 = (0 == i % 2) ? "#EEEEEE" : "#FFFFFF";
%>
                  <tr>
                    <td width="30%" style="background-color:<%=bgColor1%>;text-align:left">
                      <%=Utilities.treatURLSpecialCharacters(aVernName.getLanguage())%>
                    </td>
                    <td width="70%" style="background-color:<%=bgColor1%>;text-align:left">
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
%>
          <tr>
<%
              if (showGroup)
              {
%>
              <th style="text-align:left" class="resultHeader">
                <%=cm.cmsText("group")%>
              </th>
<%
              }
              if (showOrder)
              {
%>
              <th style="text-align:left" class="resultHeader">
                <%=cm.cmsText("order_column")%>
              </th>
<%
              }
              if (showFamily)
              {
%>
              <th style="text-align:left" class="resultHeader">
                <%=cm.cmsText("family")%>
              </th>
<%
              }
              if (showScientificName)
              {
%>
              <th style="text-align:left" class="resultHeader">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=GroupSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("scientific_name")%></a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </th>
<%
              }
              if (showVernacularNames && isExpanded)
              {
%>
              <th style="text-align:left" class="resultHeader">
                <%=cm.cmsText("vernacular_names")%>
                [<a title="<%=cm.cms("hide_vernacular_list")%>" class="resultHeaderLink" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsText("hide")%></a>]
                <%=cm.cmsTitle("hide_vernacular_list")%>
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
<%=cm.cmsMsg("species_groups-result_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("enter_refine_criteria_correctly")%>
<%=cm.br()%>
<%=cm.cmsMsg("scientific_name")%>
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

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-groups-result.jsp" />
    </jsp:include>
 </div>
 </div>
 </div>
  </body>
</html>