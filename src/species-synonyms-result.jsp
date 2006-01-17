<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species synonyms' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.synonyms.SynonymsSearchCriteria,
                 ro.finsiel.eunis.search.species.synonyms.SynonymsPaginator,
                 ro.finsiel.eunis.search.species.synonyms.SynonymsSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.jrfTables.species.synonyms.ScientificNameDomain,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.jrfTables.species.synonyms.ScientificNamePersist,
                 ro.finsiel.eunis.utilities.TableColumns"%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.synonyms.SynonymsBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
  <%
      WebContentManagement cm = SessionManager.getWebContent();
  %>
    <script language="JavaScript" type="text/javascript">
      <!--
        var errRefineMessage = "<%=cm.cms("species_synonyms-result_15")%>";
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
<%
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  SynonymsPaginator paginator = new SynonymsPaginator(new ScientificNameDomain(formBean.toSearchCriteria(),
                                                                                formBean.toSortCriteria(),
                                                                                SessionManager.getShowEUNISInvalidatedSpecies()));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  String pageName = "species-synonyms-result.jsp";
  int resultsCount = paginator.countResults();
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = new ArrayList();
  try
  {
   results = paginator.getPage(currentPage);
  }
  catch ( Exception ex )
  {
    ex.printStackTrace();
  }
  // Set number criteria for the search result
  int noCriteria = (null==formBean.getCriteriaSearch()? 0 : formBean.getCriteriaSearch().length);
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  String tsvLink = "javascript:openTSVDownload('reports/species/tsv-species-synonyms.jsp?" + formBean.toURLParam(reportFields) + "')";
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("species_synonyms-result_title")%>
  </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,synonyms_location#species-synonyms.jsp,results_location" />
      <jsp:param name="helpLink" value="species-help.jsp" />
      <jsp:param name="downloadLink" value="<%=tsvLink%>" />
    </jsp:include>
<%--      <jsp:param name="printLink" value="<%=pdfLink%>"/>--%>
    <h1>
          <%=cm.cmsText("species_synonyms-result_01")%>
    </h1>
    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
            <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<%
                 // Get search description
                 StringBuffer descr = Utilities.prepareHumanString("", formBean.getScientificName(), Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS));
                 String s = "";
                 // Not any group
                 if (!formBean.getGroupName().equals("0"))
                 {
                   String groupName = Utilities.getGroupName(formBean.getGroupName());
                   groupName = (groupName == null ? "" : groupName.replaceAll("&","&amp;"));
                   s = " from group <strong>" + Utilities.treatURLAmp(groupName) +"</strong>";
                 }
%>
              <tr>
                <td>
                  <%=cm.cmsText("species_synonyms-result_02")%>
                  <strong>
                      <%=Utilities.treatURLAmp(descr.toString())%>
                  </strong>
                  <%=s%>.
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
            <%=cm.cmsText("species_synonyms-result_03")%>: <strong><%=resultsCount%></strong>
<%// Prepare parameters for pagesize.jsp
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
          <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="background-color:#EEEEEE">
                  <%=cm.cmsText("species_synonyms-result_04")%>
              </td>
            </tr>
            <tr>
              <td style="background-color:#EEEEEE">
                <form name="resultSearch" method="get" onsubmit="return(checkRefineSearch(<%=noCriteria%>));" action="" >
                  <%=formBean.toFORMParam(filterSearch)%>
                  <label for="select1" class="noshow"><%=cm.cms("criteria")%></label>
<%
    // Not any group
    if (!formBean.getGroupName().equals("0"))
    {
%>
       <input type="hidden" name="criteriaType" value="<%=SynonymsSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" />
<%
    }
%>

                  <select id="select1" title="<%=cm.cms("criteria")%>" name="criteriaType" class="inputTextField" <%=(formBean.getGroupName().equals("0") ? "" : "disabled=\"disabled\"")%>>
<%
                    // Any group
                    if (formBean.getGroupName().equals("0"))
                    {
%>
                      <option value="<%=SynonymsSearchCriteria.CRITERIA_GROUP%>">
                        <%=cm.cms("species_synonyms-result_05")%>
                      </option>
<%
                    }
%>
<%--                    <OPTION value="<%=SynonymsSearchCriteria.CRITERIA_ORDER%>" selected>--%>
<%--                      Order--%>
<%--                    </OPTION>--%>
<%--                    <OPTION value="<%=SynonymsSearchCriteria.CRITERIA_FAMILY%>" selected>--%>
<%--                      Family--%>
<%--                    </OPTION>--%>
                    <option value="<%=SynonymsSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                      <%=cm.cms("species_synonyms-result_06")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("criteria")%>
                  <%=cm.cmsTitle("criteria")%>
                  <label for="select2" class="noshow"><%=cm.cms("operator")%></label>
                  <select id="select2" title="<%=cm.cms("operator")%>" name="oper" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                        <%=cm.cms("species_synonyms-result_07")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>">
                        <%=cm.cms("species_synonyms-result_08")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                        <%=cm.cms("species_synonyms-result_09")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("operator")%>
                  <%=cm.cmsTitle("operator")%>
                  <label for="criteriaSearch" class="noshow"><%=cm.cms("criteria_value")%></label>
                  <input id="criteriaSearch" title="<%=cm.cms("criteria_value")%>" alt="<%=cm.cms("criteria_value")%>" class="inputTextField" name="criteriaSearch" type="text" size="30" />
                  <%=cm.cmsLabel("criteria_value")%>
                  <%=cm.cmsTitle("criteria_value")%>
                  <input id="refine" title="<%=cm.cms("search")%>" class="inputTextField" type="submit" name="Submit" value="<%=cm.cms("search_btn")%>" />
                  <%=cm.cmsTitle("search")%>
                  <%=cm.cmsInput("search_btn")%>
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
                  <td style="background-color:#EEEEEE">
                    <%=cm.cmsText("species_synonyms-result_11")%>:
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
        <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
<%
            // Compute the sort criteria
            Vector sortURLFields = new Vector();      /* Used for sorting */
            sortURLFields.addElement("pageSize");
            sortURLFields.addElement("criteriaSearch");
            String urlSortString = formBean.toURLParam(sortURLFields);
            AbstractSortCriteria sortGroup = formBean.lookupSortCriteria(SynonymsSortCriteria.SORT_GROUP);
//            AbstractSortCriteria sortOrder = formBean.lookupSortCriteria(SynonymsSortCriteria.SORT_ORDER);
//            AbstractSortCriteria sortFamily = formBean.lookupSortCriteria(SynonymsSortCriteria.SORT_FAMILY);
            AbstractSortCriteria sortSciName = formBean.lookupSortCriteria(SynonymsSortCriteria.SORT_SCIENTIFIC_NAME);
%>
          <tr>
            <th style="text-align:left" class="resultHeader">
<%
if (formBean.getGroupName().equals("0"))
    {
%>
              <a title="<%=cm.cms("sort_results_on_this_column")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SynonymsSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsText("species_synonyms-result_05")%></span></a>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
<%
    }else
    {
%>
      <%=cm.cmsText("species_synonyms-result_05")%>
<%
    }
%>
            </th>
            <th style="text-align:left" class="resultHeader">
              <a title="<%=cm.cms("sort_results_on_this_column")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SynonymsSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsText("species_synonyms-result_06")%></span></a>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th style="text-align:left">
              <%=cm.cmsText("species_scientific_name")%>
            </th>
          </tr>
<%
            Iterator it = results.iterator();
            int col = 0;
            while (it.hasNext())
            {
              String bgColor = col++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF";
              ScientificNamePersist specie = (ScientificNamePersist)it.next();
%>
          <tr>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <%=Utilities.treatURLSpecialCharacters(Utilities.formatString(specie.getGrName()))%>
            </td>
<%--            <td>--%>
<%--              <%=Utilities.formatString(specie.getTaxonomicNameOrder(),"&nbsp;")%>--%>
<%--            </td>--%>
<%--            <td>--%>
<%--              <%=Utilities.formatString(specie.getTaxonomicNameFamily(),"&nbsp;")%>--%>
<%--            </td>--%>
            <td class="resultCell" style="background-color : <%=bgColor%>">
              <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpec()%>&amp;idSpeciesLink=<%=specie.getIdSpecLink()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScName())%></a>
              <%=cm.cmsTitle("open_species_factsheet")%>
            </td>
            <td class="resultCell" style="background-color : <%=bgColor%>">
            <%
               List resultsSpecies = new ScientificNameDomain(formBean.toSearchCriteria(),formBean.toSortCriteria(),SessionManager.getShowEUNISInvalidatedSpecies()).geSpeciesListForASynonym(specie.getIdSpec());
               if (resultsSpecies != null && resultsSpecies.size() > 0)
             {
             %>
             <table summary="<%=cm.cms("list_species")%>" border="1" cellspacing="1" cellpadding="1" style="border-collapse: collapse; background-color : <%=bgColor%>">
             <%
               for(int ii=0;ii<resultsSpecies.size();ii++)
               {
                 TableColumns tableColumns = (TableColumns) resultsSpecies.get(ii);
                 String scientificName = (String)tableColumns.getColumnsValues().get(0);
                 Integer idSpecies = (Integer)tableColumns.getColumnsValues().get(1);
                 Integer idSpeciesLink = (Integer)tableColumns.getColumnsValues().get(2);
               %>
               <tr>
                 <td>
                   <a href="species-factsheet.jsp?idSpecies=<%=idSpecies%>&amp;idSpeciesLink=<%=idSpeciesLink%>" title="<%=cm.cms("open_species_factsheet")%>"><%=Utilities.treatURLSpecialCharacters(scientificName)%></a>
                   <%=cm.cmsTitle("open_species_factsheet")%>
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
<%
if (formBean.getGroupName().equals("0"))
    {
%>
              <a title="<%=cm.cms("sort_results_on_this_column")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SynonymsSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsText("species_synonyms-result_05")%></span></a>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
<%
    }else
    {
%>
      <%=cm.cmsText("species_synonyms-result_05")%>
<%
    }
%>
            </th>
            <th style="text-align:left" class="resultHeader">
              <a title="<%=cm.cms("sort_results_on_this_column")%>" class="resultHeaderLink" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SynonymsSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsText("species_synonyms-result_06")%></span></a>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th style="text-align:left">
              <%=cm.cmsText("species_scientific_name")%>
            </th>
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
<%=cm.cmsMsg("species_synonyms-result_15")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms-result_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms-result_05")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms-result_06")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms-result_07")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms-result_08")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms-result_09")%>
<%=cm.br()%>
<%=cm.cmsMsg("search_results")%>
<%=cm.br()%>
<%=cm.cmsMsg("list_species")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-synonyms-result.jsp" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>