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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.speciesByReferences.ReferencesBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
      function MM_openBrWindow(theURL,winName,features) { //v2.0
        window.open(theURL,winName,features);
      }
    //-->
    </script>
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
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_references-result_title")%>
    </title>
  </head>
  <body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,pick_references_show_species_location#species-references.jsp,results_location" />
      <jsp:param name="helpLink" value="sites-help.jsp" />
      <jsp:param name="downloadLink" value="<%=downloadLink%>" />
    </jsp:include>
    <h1>
      <%=cm.cmsText("species_references-result_01")%>
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
              <%=cm.cmsText("species_references-result_02")%>
<%
              if( mainCriteria.toHumanString().length() > 0 )
              {
%>
                (<%=cm.cmsText("species_references-result_03")%> <strong><%=Utilities.treatURLAmp(mainCriteria.toHumanString())%></strong>)
<%
              }
%>
              <%=cm.cmsText("species_references-result_04")%>
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
      <%=cm.cmsText("species_references-result_05")%>:
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
                <%=cm.cmsText("species_references-result_06")%>
            </td>
          </tr>
          <tr>
            <td style="background-color:#EEEEEE">
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

              <select id="select1" title="<%=cm.cms("criteria")%>" name="criteriaType" class="inputTextField" <%=(showGroup ? "" : "disabled=\"disabled\"")%>>
                  <%
                      if (showGroup)
                      {
                   %>
                        <option value="<%=ReferencesSearchCriteria.CRITERIA_GROUP%>" selected="selected">
                            <%=cm.cms("species_references-result_07")%>
                        </option>
                  <%
                      }
                  %>
                  <option value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>">
                      <%=cm.cms("species_references-result_10")%>
                  </option>
                </select>
                <%=cm.cmsLabel("criteria")%>
                <%=cm.cmsTitle("criteria")%>
                <label for="select2" class="noshow"><%=cm.cms("operator")%></label>
                <select id="select2" title="<%=cm.cms("operator")%>" name="oper" class="inputTextField">
                  <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                      <%=cm.cms("species_references-result_11")%>
                  </option>
                  <option value="<%=Utilities.OPERATOR_STARTS%>">
                      <%=cm.cms("species_references-result_12")%>
                  </option>
                  <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                      <%=cm.cms("species_references-result_13")%>
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
            ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
            if (criterias.length > 1)
            {
          %>
          <tr>
            <td style="background-color:#EEEEEE">
              <%=cm.cmsText("species_references-result_15")%>:
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
            <a title="<%=cm.cms("show_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><%=cm.cmsText("species_references-result_16")%></a>
            <%=cm.cmsTitle("show_vernacular_list")%>
        <%
          }
        %>
      <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
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
          <tr>
            <%
              if (showGroup)
              {
            %>
              <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(groupCrit, (null == groupCrit) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(groupCrit)%><%=cm.cmsText("species_references-result_07")%></span></a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </th>
            <%
              }
              if (showOrder)
              {
            %>
              <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                <%=cm.cmsText("species_references-result_08")%>

            </th>
            <%
              }
              if (showFamily)
              {
            %>
              <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                <%=cm.cmsText("species_references-result_09")%>
              </th>
            <%
              }
            %>
            <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
              <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("species_references-result_10")%></span></a>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <%
              if (showVernacularNames && isExpanded)
              {
            %>
              <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                <span style="color:#FFFFFF">
                  <%=cm.cmsText("species_references-result_17")%>&nbsp;
                  [<a title="<%=cm.cms("hide_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><span style="color:#FFFFFF"><%=cm.cmsText("species_references-result_18")%></span></a><%=cm.cmsTitle("hide_vernacular_list")%>]
                </span>
              </th>
             <%
              }
             %>
          </tr>

<%
  //===== Dynamic content =====
  if(null!=results)
  {
    Iterator it = results.iterator();
    int col = 0;
    while (it.hasNext())
    {
      String bgColor = col++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF";
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
          <td class="resultCell" style="background-color : <%=bgColor%>">
            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getGroupName()),"&nbsp;")%>
          </td>
  <%
    }
    if (showOrder)
    {
  %>
          <td class="resultCell" style="background-color : <%=bgColor%>">
            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getOrderName()),"&nbsp;")%>
          </td>
  <%
    }
    if (showFamily)
    {
  %>
          <td class="resultCell" style="background-color : <%=bgColor%>">
            <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(specie.getFamilyName()),"&nbsp;")%>
          </td>
  <%
    }
  %>
          <td class="resultCell" style="background-color : <%=bgColor%>">
            &nbsp;
            <a title="<%=cm.cms("open_species_factsheet")%>" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(Utilities.formatString(specie.getScientificName(),""))%></a>
            <%=cm.cmsTitle("open_species_factsheet")%>
          </td>
  <%
   if (showVernacularNames && isExpanded)
   {
  %>
          <td class="resultCell" style="background-color : <%=bgColor%>">
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
            <tr>
            <%
              if (showGroup)
              {
            %>
              <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(groupCrit, (null == groupCrit) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(groupCrit)%><%=cm.cmsText("species_references-result_07")%></span></a>
                <%=cm.cmsTitle("sort_results_on_this_column")%>
              </th>
            <%
              }
              if (showOrder)
              {
            %>
              <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                <%=cm.cmsText("species_references-result_08")%>

            </th>
            <%
              }
              if (showFamily)
              {
            %>
              <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                <%=cm.cmsText("species_references-result_09")%>
              </th>
            <%
              }
            %>
            <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
              <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit) ? true : false)%>"><span style="color:#FFFFFF"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("species_references-result_10")%></span></a>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <%
              if (showVernacularNames && isExpanded)
              {
            %>
              <th style="text-align:left;background-color:<%=SessionManager.getThemeManager().getDarkColor()%>">
                <span style="color:#FFFFFF">
                  <%=cm.cmsText("species_references-result_17")%>&nbsp;
                  [<a title="<%=cm.cms("hide_vernacular_list")%>" href="<%=pageName + "?expand=" + !isExpanded + expandURL%>"><span style="color:#FFFFFF"><%=cm.cmsText("species_references-result_18")%></span></a><%=cm.cmsTitle("hide_vernacular_list")%>]
                </span>
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
<%=cm.cmsMsg("species_references-result_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_references-result_07")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_references-result_10")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_references-result_11")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_references-result_12")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_references-result_13")%>
<%=cm.br()%>
<%=cm.cmsMsg("search_results")%>
<%=cm.br()%>
<%=cm.cmsMsg("list_vernacular")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-references-result.jsp" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>