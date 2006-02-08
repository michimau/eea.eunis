<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Results for references
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.formBeans.ReferencesBean,
                 ro.finsiel.eunis.jrfTables.*,
                 ro.finsiel.eunis.formBeans.ReferencesSortCriteria,
                 ro.finsiel.eunis.formBeans.ReferencesSearchCriteria"%><%@ page import="ro.finsiel.eunis.exceptions.CriteriaMissingException"%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.ReferencesBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
  <%
  // Set the database connection parameters
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }

  // Request parameters.
  boolean showAuthor = true;
  boolean showYear = Utilities.checkedStringToBoolean(formBean.getShowYear(), ReferencesBean.HIDE);
  boolean showTitle = Utilities.checkedStringToBoolean(formBean.getShowTitle(), ReferencesBean.HIDE);
  boolean showEditor = Utilities.checkedStringToBoolean(formBean.getShowEditor(), ReferencesBean.HIDE);
  boolean showPublisher = Utilities.checkedStringToBoolean(formBean.getShowPublisher(), ReferencesBean.HIDE);
  boolean showURL = Utilities.checkedStringToBoolean(formBean.getShowURL(), ReferencesBean.HIDE);

  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);

  // The main paginator
  ReferencesPaginator paginator = new ReferencesPaginator(new ReferencesDomain(formBean.toSearchCriteria(),
                                                                        formBean.toSortCriteria(),
                                                                        SQL_DRV,
                                                                        SQL_URL,
                                                                        SQL_USR,
                                                                        SQL_PWD));

  // Initialisation.
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "references-result.jsp";
  int guid = 0;

  int resultsCount = 0;
  int pagesCount = 0;
  List results = null;
  try
  {
    resultsCount = paginator.countResults();
    pagesCount = paginator.countPages();
    results = paginator.getPage(currentPage);
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }

  int noCriteria = (null==formBean.getCriteriaSearch()?0:formBean.getCriteriaSearch().length);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <script language="JavaScript" type="text/javascript" src="script/references-result.js"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
      function MM_openBrWindow(theURL,winName,features) { //v2.0
        window.open(theURL,winName,features);
      }
    //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("references_references-result_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,references_location#references.jsp,results_location"/>
      </jsp:include>
      <h1>
        <%=cm.cmsText("references_references-result_01")%>
      </h1>
<%
  ReferencesSearchCriteria mainCriteria = (ReferencesSearchCriteria)formBean.getMainSearchCriteria();
%>
      <%=cm.cmsText("references_references-result_02")%>
<%
  if(mainCriteria.toHumanString().length()>0)
  {
%>
      <br />
      <%=cm.cmsText("references_references-result_03")%>&nbsp;
      <strong>
        <%=mainCriteria.toHumanString()%>
      </strong>
<%
  }
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
      <%=cm.cmsText("references_references-result_05")%>
      <strong><%=resultsCount%></strong>
<%
  // Prepare parameters for pagesize.jsp
  Vector pageSizeFormFields = new Vector();        /*  These fields are used by pagesize.jsp, included below.    */
  pageSizeFormFields.addElement("sort");           /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
  pageSizeFormFields.addElement("ascendency");     /*   is overriden & also pageSize is set to default           */
  pageSizeFormFields.addElement("criteriaSearch"); /*   to page '0' aka first page. */
  pageSizeFormFields.addElement("oper");
  pageSizeFormFields.addElement("criteriaType");
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
    filterSearch.addElement("oper");
    filterSearch.addElement("criteriaType");
    filterSearch.addElement("pageSize");
%>
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=cm.cmsText("references_references-result_06")%>
          </strong>
          <br />
          <form name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="" >
           <%=formBean.toFORMParam(filterSearch)%>
            <label for="criteriaType" class="noshow"><%=cm.cms("criteria_type_label")%></label>
            <select id="criteriaType" name="criteriaType" class="inputTextField">
<%
  if (showEditor)
  {
%>
              <option value="<%=ReferencesSearchCriteria.CRITERIA_EDITOR%>" selected="selected">
                <%=cm.cms("references_references-result_07")%>
              </option>
<%
  }
  if (showPublisher)
  {
%>
              <option value="<%=ReferencesSearchCriteria.CRITERIA_PUBLISHER%>">
                <%=cm.cms("references_references-result_08")%>
              </option>
<%
  }
  if (showYear)
  {
%>
              <option value="<%=ReferencesSearchCriteria.CRITERIA_YEAR%>">
                <%=cm.cms("references_references-result_09")%>
              </option>
<%
  }
  if (showTitle)
  {
%>
              <option value="<%=ReferencesSearchCriteria.CRITERIA_TITLE%>">
                <%=cm.cms("references_references-result_10")%>
              </option>
<%
  }
%>
              <option value="<%=ReferencesSearchCriteria.CRITERIA_AUTHOR%>">
                <%=cm.cms("references_references-result_11")%>
              </option>
            </select>
            <%=cm.cmsLabel("criteria_type_label")%>
            <%=cm.cmsInput("references_references-result_07")%>
            <%=cm.cmsInput("references_references-result_08")%>
            <%=cm.cmsInput("references_references-result_09")%>
            <%=cm.cmsInput("references_references-result_10")%>
            <%=cm.cmsInput("references_references-result_11")%>

            <label for="oper" class="noshow"><%=cm.cms("operator_label")%></label>
            <select id="oper" name="oper" class="inputTextField">
              <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                <%=cm.cms("references_references-result_12")%>
              </option>
              <option value="<%=Utilities.OPERATOR_STARTS%>">
                <%=cm.cms("references_references-result_13")%>
              </option>
              <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                <%=cm.cms("references_references-result_14")%>
              </option>
            </select>
            <%=cm.cmsLabel("operator_label")%>
            <%=cm.cmsInput("references_references-result_12")%>
            <%=cm.cmsInput("references_references-result_13")%>
            <%=cm.cmsInput("references_references-result_14")%>

            <label for="criteriaSearch" class="noshow"><%=cm.cms("filter_label")%></label>
            <input class="inputTextField" title="<%=cm.cms("filter_title")%>" id="criteriaSearch" name="criteriaSearch" type="text" size="30" />
            <%=cm.cmsLabel("filter_label")%>
            <%=cm.cmsTitle("filter_title")%>

            <input class="inputTextField" type="submit" id="submit" name="Submit" value="<%=cm.cms("refine_btn_value")%>" title="<%=cm.cms("refine_btn_title")%>" />
            <%=cm.cmsTitle("refine_btn_title")%>
            <%=cm.cmsInput("refine_btn_value")%>
          </form>
<%
    ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
    if (criterias.length > 1)
    {
%>
          <%=cm.cmsText("references_references-result_15")%><%}%>
<%
      for (int i = criterias.length - 1; i > 0; i--)
      {
        AbstractSearchCriteria criteria = criterias[i];
        if (null != criteria && null != formBean.getCriteriaSearch())
        {
%>
              <a title="<%=cm.cms("removefilter_title")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img src="images/mini/delete.jpg" border="0" align="middle" alt="<%=cm.cms("references_result_removefilter_alt")%>"></a>
              <%=cm.cmsTitle("removefilter_title")%>
              <%=cm.cmsAlt("removefilter_alt")%>
              &nbsp;&nbsp;
              <strong><%= i + ". " + criteria.toHumanString()%></strong>
<%
    }
  }
%>
      </div>
<%
  // Prepare parameters for navigator.jsp
  Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
  navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
  navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
  navigatorFormFields.addElement("ascendency");
  navigatorFormFields.addElement("criteriaSearch");
  navigatorFormFields.addElement("oper");
  navigatorFormFields.addElement("criteriaType");
%>
      <jsp:include page="navigator.jsp">
        <jsp:param name="pagesCount" value="<%=pagesCount%>"/>
        <jsp:param name="pageName" value="<%=pageName%>"/>
        <jsp:param name="guid" value="<%=guid%>"/>
        <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>"/>
        <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>"/>
        <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>"/>
      </jsp:include>
      <br />
      <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
<%
  // Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  sortURLFields.addElement("criteriaSearch");
  sortURLFields.addElement("oper");
  sortURLFields.addElement("criteriaType");
  sortURLFields.addElement("currentPage");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria sortAuthor = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_AUTHOR);
  AbstractSortCriteria sortYear = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_YEAR);
  AbstractSortCriteria sortTitle = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_TITLE);
  AbstractSortCriteria sortEditor = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_EDITOR);
  AbstractSortCriteria sortPublisher = formBean.lookupSortCriteria(ReferencesSortCriteria.SORT_PUBLISHER);
%>
        <tr>
<%
  if (showAuthor)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_AUTHOR%>&amp;ascendency=<%=formBean.changeAscendency(sortAuthor, null==sortAuthor)%>"><%=Utilities.getSortImageTag(sortAuthor)%><%=cm.cmsText("references_references-result_11")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showYear)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null==sortYear)%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsText("references_references-result_09")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showTitle)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_TITLE%>&amp;ascendency=<%=formBean.changeAscendency(sortTitle, null==sortTitle)%>"><%=Utilities.getSortImageTag(sortTitle)%><%=cm.cmsText("references_references-result_10")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showEditor)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EDITOR%>&amp;ascendency=<%=formBean.changeAscendency(sortEditor, null==sortEditor)%>"><%=Utilities.getSortImageTag(sortEditor)%><%=cm.cmsText("references_references-result_07")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showPublisher)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_PUBLISHER%>&amp;ascendency=<%=formBean.changeAscendency(sortPublisher, null==sortPublisher)%>"><%=Utilities.getSortImageTag(sortPublisher)%><%=cm.cmsText("references_references-result_08")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showURL)
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("references_references-result_16")%></th><%}%>
          <th class="resultHeader" style="text-align : center;">
            <%=cm.cmsText("references_references-result_17")%>
          </th>
          <th class="resultHeader" style="text-align : center;">
            <%=cm.cmsText("references_references-result_18")%>
          </th>
        </tr>
<%
  Iterator it = results.iterator();
  int col = 0;
  while (it.hasNext())
  {
    String bgColor = col++ % 2 == 0 ? "#EEEEEE" : "#FFFFFF";
    ReferencesWrapper ref = (ReferencesWrapper)it.next();
%>
        <tr>
<%
    if (showAuthor)
    {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>">
<%
      String author = Utilities.formatString( ref.getAuthor() );
      if ( author.equalsIgnoreCase( "" ) )
      {
        author = "&nbsp;";
      }
      else
      {
        author = Utilities.treatURLAmp( author );
      }
%>
            <%=author%>
          </td>
<%
    }
    if (showYear)
    {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>">
            <%=Utilities.formatDate( ref.getYear() )%>
          </td>
<%
  }
  if (showTitle)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>">
<%
  String title = Utilities.formatString( ref.getTitle() );
  if ( title.equalsIgnoreCase( "" ) )
  {
    title = "&nbsp;";
  }
  else
  {
    title = Utilities.treatURLAmp( title );
  }
%>
            <%=title%>
          </td>
<%
  }
  if (showEditor)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>">
<%
  String editor = Utilities.formatString( ref.getEditor() );
  if ( editor.equalsIgnoreCase( "" ) )
  {
    editor = "&nbsp;";
  }
  else
  {
    editor = Utilities.treatURLAmp( editor );
  }
%>
            <%=editor%>
          </td>
<%}%>
<%
  if (showPublisher)
{
%>
          <td class="resultCell" style="background-color : <%=bgColor%>">
<%
  String publisher = Utilities.formatString( ref.getPublisher() );
  if ( publisher.equalsIgnoreCase( "" ) )
  {
    publisher = "&nbsp;";
  }
  else
  {
    publisher = Utilities.treatURLAmp( publisher );
  }
%>
            <%=publisher%>
          </td>
<%
  }
  if (showURL)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>">
<%
  String url = Utilities.formatString( ref.getURL() );
  if ( url.equalsIgnoreCase( "" ) )
  {
    url = "&nbsp;";
  }
  else
  {
    url = Utilities.treatURLAmp( url );
  }
%>
            <%=url%>
          </td>
<%
  }
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : center;">
<%
      SQL_DRV = application.getInitParameter("JDBC_DRV");
      SQL_URL = application.getInitParameter("JDBC_URL");
      SQL_USR = application.getInitParameter("JDBC_USR");
      SQL_PWD = application.getInitParameter("JDBC_PWD");
      // List of species scientific names related to this reference
  List speciesResults = null;
  try
  {
    speciesResults = ReferencesDomain.getSpeciesForAReference(ref.getIdDc(),SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
  }
  catch ( CriteriaMissingException e )
  {
    e.printStackTrace();
  }
  int speciesResultSize = (null == speciesResults ? 0 : speciesResults.size());
      if(speciesResultSize>0)
      {
%>
            <table border="0" cellspacing="0" cellpadding="0">
<%
        for(int i=0;i<speciesResultSize;i++)
        {
          List speciesData = (List)speciesResults.get(i);
          String speciesName = (String)speciesData.get(1);
          String speciesId = (String)speciesData.get(0);
%>
              <tr>
                <td bgcolor="<%=(0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE"%>" style="text-align : left;">
                  <a title="<%=cm.cms("open_species_factsheet")%>" href="javascript:openlink('species-factsheet.jsp?idSpecies=<%=speciesId%>')"><%=speciesName%></a>
                  <%=cm.cmsTitle("open_species_factsheet")%>
                </td>
              </tr>
<%
        }
%>
              </table>
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
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : center;">
<%
      // List of species scientific names related to this reference
      List habitatsResults = ReferencesDomain.getHabitatsForAReferences(ref.getIdDc(),SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
      int habitatsResultSize = (null == habitatsResults ? 0 : habitatsResults.size());
      if(habitatsResultSize>0)
      {
%>
            <table border="0" cellspacing="0" cellpadding="0">
<%
        for(int i=0;i<habitatsResultSize;i++)
        {
          List habitatsData = (List)habitatsResults.get(i);
          String habitatsName = (String)habitatsData.get(1);
          String habitatsId = (String)habitatsData.get(0);
%>
              <tr>
                <td bgcolor="<%=(0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE"%>" style="text-align : left;">
                  <a title="<%=cm.cms("open_habitat_factsheet")%>" href="javascript:openlink('habitats-factsheet.jsp?idHabitat=<%=habitatsId%>')"><%=habitatsName%></a>
                  <%=cm.cmsTitle("open_habitat_factsheet")%>
                </td>
              </tr>
<%
        }
%>
            </table>
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
        </tr>
<%
    }
%>
        <tr>
<%
  if (showAuthor)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_AUTHOR%>&amp;ascendency=<%=formBean.changeAscendency(sortAuthor, null==sortAuthor)%>"><%=Utilities.getSortImageTag(sortAuthor)%><%=cm.cmsText("references_references-result_11")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showYear)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null==sortYear)%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsText("references_references-result_09")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showTitle)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_TITLE%>&amp;ascendency=<%=formBean.changeAscendency(sortTitle, null==sortTitle)%>"><%=Utilities.getSortImageTag(sortTitle)%><%=cm.cmsText("references_references-result_10")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showEditor)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_EDITOR%>&amp;ascendency=<%=formBean.changeAscendency(sortEditor, null==sortEditor)%>"><%=Utilities.getSortImageTag(sortEditor)%><%=cm.cmsText("references_references-result_07")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showPublisher)
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=ReferencesSortCriteria.SORT_PUBLISHER%>&amp;ascendency=<%=formBean.changeAscendency(sortPublisher, null==sortPublisher)%>"><%=Utilities.getSortImageTag(sortPublisher)%><%=cm.cmsText("references_references-result_08")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if (showURL)
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("references_references-result_16")%>
          </th>
<%
  }
%>
          <th class="resultHeader" style="text-align : center;">
            <%=cm.cmsText("references_references-result_17")%>
          </th>
          <th class="resultHeader" style="text-align : center;">
            <%=cm.cmsText("references_references-result_18")%>
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

      <%=cm.cmsMsg("references_references-result_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("search_results")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="references-result.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>