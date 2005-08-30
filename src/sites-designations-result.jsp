<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Designation types" function - results page.
--%>
<%@ page contentType="text/html"%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.sites.designations.DesignationsPaginator,
                 ro.finsiel.eunis.jrfTables.sites.designations.DesignationsDomain,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.jrfTables.sites.designations.DesignationsPersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.designations.DesignationsBean,
                 ro.finsiel.eunis.search.sites.designations.DesignationsSearchCriteria,
                 ro.finsiel.eunis.search.sites.designations.DesignationsSortCriteria,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.AbstractSearchCriteria"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.designations.DesignationsBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), DesignationsBean.HIDE);
  boolean showDesignation = Utilities.checkedStringToBoolean(formBean.getShowDesignation(), true);
  boolean showDesignEn = Utilities.checkedStringToBoolean(formBean.getShowDesignationEn(), true);
  boolean showDesignFr = Utilities.checkedStringToBoolean(formBean.getShowDesignationFr(), DesignationsBean.HIDE);
  boolean showIso = Utilities.checkedStringToBoolean(formBean.getShowIso(), DesignationsBean.HIDE);
  boolean showAbreviation = Utilities.checkedStringToBoolean(formBean.getShowAbreviation(), DesignationsBean.HIDE);
  //boolean showSource = Utilities.checkedStringToBoolean(formBean.getShowSource(), DesignationsBean.HIDE);
  // Contains true values if proper sourceDB checkbox was check
  boolean[] source = {
      formBean.getDB_NATURA2000() != null,
      formBean.getDB_CORINE() != null,
      formBean.getDB_DIPLOMA() != null,
      formBean.getDB_CDDA_NATIONAL() != null,
      formBean.getDB_CDDA_INTERNATIONAL() != null,
      formBean.getDB_BIOGENETIC() != null,
      false,
      formBean.getDB_EMERALD() != null
  };
  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  DesignationsPaginator paginator = new DesignationsPaginator(new DesignationsDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(),source));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "sites-designations-result.jsp";
  int resultsCount = 0;
  int pagesCount = 0;// This is used in @page include...
  int guid = 0;// This is used in @page include...
  List results = new ArrayList();
  try
  {
    resultsCount = paginator.countResults();
    pagesCount = paginator.countPages();
    results = paginator.getPage(currentPage);
  }
  catch ( Exception ex )
  {
    ex.printStackTrace();
  }
  // Set number criteria for the search result
  int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  String downloadLink = "javascript:openlink('reports/sites/tsv-sites-designations.jsp?" + formBean.toURLParam(reportFields) + "')";

  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-designations.js"></script>
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_designations-result_title", false )%></title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Designations types#sites-designations.jsp,Result"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
        <jsp:param name="downloadLink" value="<%=downloadLink%>"/>
      </jsp:include>
<%--      <jsp:param name="printLink" value="<%=printLink%>"/>--%>
      <h5>
        <%=contentManagement.getContent("sites_designations-result_01")%>
      </h5>
      <%=((DesignationsSearchCriteria)formBean.getMainSearchCriteria()).toHumanStringMain()%>
<br />      
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
      <%=contentManagement.getContent("sites_designations-result_02")%>: <strong><%=resultsCount%></strong><br />
<%
  // Prepare parameters for pagesize.jsp
  Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
  pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
  pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
  pageSizeFormFields.addElement("criteriaSearch");/*   to page "0" aka first page. */
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
      <div class="grey_rectangle">
        <strong>
          <%=contentManagement.getContent("sites_designations-result_03")%>
        </strong>
        <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
          <%=formBean.toFORMParam(filterSearch)%>
          <label for="criteriaType0" class="noshow">Criteria</label>
          <select id="criteriaType0" name="criteriaType" class="inputTextField"  title="Criteria">
<%
  if (showSourceDB)
  {
%>
            <option value="<%=DesignationsSearchCriteria.CRITERIA_SOURCE_DB%>">
              <%=contentManagement.getContent("sites_designations-result_04", false)%>
            </option>
<%
  }
  if (showDesignation)
  {
%>
            <option value="<%=DesignationsSearchCriteria.CRITERIA_DESIGN%>">
              <%=contentManagement.getContent("sites_designations-result_05", false)%>
            </option>
<%
  }
  if (showDesignEn)
  {
%>
            <option value="<%=DesignationsSearchCriteria.CRITERIA_DESIGN_EN%>">
              <%=contentManagement.getContent("sites_designations-result_06", false)%>
            </option>
<%
  }
  if (showDesignFr)
  {
%>
            <option value="<%=DesignationsSearchCriteria.CRITERIA_DESIGN_FR%>">
              <%=contentManagement.getContent("sites_designations-result_07", false)%>
            </option>
<%
  }
  if (showAbreviation)
  {
%>
            <option value="<%=DesignationsSearchCriteria.CRITERIA_ABREVIATION%>">
              <%=contentManagement.getContent("sites_designations-result_08", false)%>
            </option>
<%
  }
  if (showIso)
  {
%>
            <option value="<%=DesignationsSearchCriteria.CRITERIA_COUNTRY%>">
              <%=contentManagement.getContent("sites_designations-result_09", false)%>
            </option>
<%
  }
%>
          </select>
          <label for="oper0" class="noshow">Operator</label>
          <select id="oper0" name="oper" class="inputTextField" title="Operator">
            <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
              <%=contentManagement.getContent("sites_designations-result_10", false)%>
            </option>
            <option value="<%=Utilities.OPERATOR_STARTS%>">
              <%=contentManagement.getContent("sites_designations-result_11", false)%>
            </option>
            <option value="<%=Utilities.OPERATOR_CONTAINS%>">
              <%=contentManagement.getContent("sites_designations-result_12", false)%>
            </option>
          </select>
          <label for="criteriaSearch0" class="noshow">Filter value</label>
          <input id="criteriaSearch0" class="inputTextField" name="criteriaSearch" type="text" size="30" title="Filter value" />
          <a title="<%=Accesibility.getText( "generic.refined.question" )%>" href="javascript:openRefineHint()" name="binocular" id="binocular"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.refined.question" )%>" title="<%=Accesibility.getText( "generic.refined.question" )%>" border="0" width="11" height="18" align="middle" /></a>
          <label for="submit" class="noshow">Search</label>
          <input id="submit" name="Submit" type="submit" title="Search" value="<%=contentManagement.getContent("sites_designations-result_13", false)%>" class="inputTextField" />
          <%=contentManagement.writeEditTag( "sites_designations-result_13" )%>
        </form>
<%
  ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
  if (criterias.length > 1)
  {
%>
        <%=contentManagement.getContent("sites_designations-result_14")%>
        <br />
<%
  }
  for (int i = criterias.length - 1; i > 0; i--)
  {
    AbstractSearchCriteria criteria = criterias[i];
    if (null != criteria && null != formBean.getCriteriaSearch())
    {
%>
          <a title="Remove filter" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img src="images/mini/delete.jpg" alt="<%=Accesibility.getText( "generic.refined.delete" )%>" title="<%=Accesibility.getText( "generic.refined.delete" )%>" border="0" align="middle" /></a>
          &nbsp;&nbsp;
          <strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
          <br />
<%
    }
  }
%>
      </div>
      <br />
<%
  // Prepare parameters for navigator.jsp
  Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
  navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
  navigatorFormFields.addElement("sort");     /* <form name="..."> in the navigator.jsp!                               */
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
<%
  // Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  sortURLFields.addElement("criteriaSearch");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_SOURCE_DB);
  //AbstractSortCriteria sortSource = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_SOURCE);
  //AbstractSortCriteria sortIso = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_ISO);
  AbstractSortCriteria sortAbreviation = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_ABREVIATION);
  AbstractSortCriteria sortDesignation = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_DESIGNATION);
  AbstractSortCriteria sortDesignEn = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_DESIGNATION_EN);
  AbstractSortCriteria sortDesignFr = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_DESIGNATION_FR);
  AbstractSortCriteria sortCountry = formBean.lookupSortCriteria(DesignationsSortCriteria.SORT_COUNTRY);
%>
      <table summary="Search results" border="1" cellpadding="0" cellspacing="0" align="center" width="100%" style="border-collapse: collapse">
        <tr>
<%
  if (showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, sortSourceDB == null )%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_designations-result_15")%></a>
          </th>
<%
  }
  if (showIso)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, sortCountry == null )%>"><%=Utilities.getSortImageTag(sortCountry)%><%=contentManagement.getContent("sites_designations-result_09")%></a>
          </th>
<%
  }
  if (showDesignation)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignation, sortDesignation == null )%>"><%=Utilities.getSortImageTag(sortDesignation)%><%=contentManagement.getContent("sites_designations-result_05")%></a>
          </th>
<%
  }
  if (showDesignEn)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION_EN%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignEn, sortDesignEn == null )%>"><%=Utilities.getSortImageTag(sortDesignEn)%><%=contentManagement.getContent("sites_designations-result_06")%></a>
          </th>
<%
  }
  if (showDesignFr)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION_FR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignFr, sortDesignFr == null )%>"><%=Utilities.getSortImageTag(sortDesignFr)%><%=contentManagement.getContent("sites_designations-result_07")%></a>
          </th>
<%
  }
  if (showAbreviation)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_ABREVIATION%>&amp;ascendency=<%=formBean.changeAscendency(sortAbreviation, sortAbreviation == null )%>"><%=Utilities.getSortImageTag(sortAbreviation)%><%=contentManagement.getContent("sites_designations-result_08")%></a>
          </th>
<%
  }
%>
        </tr>
<%
  String bgcolor;
  for (int i = 0; i < results.size(); i++)
  {
    bgcolor = (0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF";
    DesignationsPersist designation = (DesignationsPersist)results.get(i);
%>
        <tr>
<%
    if (showSourceDB)
    {
%>
          <td bgcolor="<%=bgcolor%>">
            <strong><%=SitesSearchUtility.translateSourceDB(designation.getDataSet())%></strong>
          </td>
<%
    }
    if (showIso)
    {
%>
          <td bgcolor="<%=bgcolor%>">
            <%=Utilities.formatString(designation.getCountry(), "&nbsp;")%>
          </td>
<%
    }
    if (showDesignation)
    {
%>
          <td bgcolor="<%=bgcolor%>">
<%
      if (null != designation.getDescription() && !designation.getDescription().equalsIgnoreCase(""))
      {
        String factsheetURL = "designations-factsheet.jsp?fromWhere=original&amp;idDesign=" + designation.getIdDesignation();
        factsheetURL += "&amp;geoscope=" + designation.getIdGeoscope();
%>
            <a title="Designation factsheet" href="<%=factsheetURL%>"><%=Utilities.formatString(designation.getDescription(), "&nbsp;")%></a>
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
    if (showDesignEn)
    {
%>
          <td bgcolor="<%=bgcolor%>">
<%
      if (null != designation.getDescriptionEn() && !designation.getDescriptionEn().equalsIgnoreCase(""))
      {
%>
            <a title="Designation factsheet" href="designations-factsheet.jsp?fromWhere=en&amp;idDesign=<%=designation.getIdDesignation()%>&amp;geoscope=<%=designation.getIdGeoscope()%>"><%=Utilities.formatString(designation.getDescriptionEn(), "&nbsp;")%></a>
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
    if (showDesignFr)
    {
%>
          <td bgcolor="<%=bgcolor%>">
<%
      if (null != designation.getDescriptionFr() && !designation.getDescriptionFr().equalsIgnoreCase(""))
      {
%>
            <a title="Designation factsheet" href="designations-factsheet.jsp?fromWhere=fr&amp;idDesign=<%=designation.getIdDesignation()%>&amp;geoscope=<%=designation.getIdGeoscope()%>"><%=Utilities.formatString(designation.getDescriptionFr(), "&nbsp;")%></a>
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
    if (showAbreviation)
    {
%>
          <td bgcolor="<%=bgcolor%>">
            <%=Utilities.formatString(designation.getAbbreviation(), "&nbsp;")%>
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
  if (showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, sortSourceDB == null )%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_designations-result_15")%></a>
          </th>
<%
  }
  if (showIso)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, sortCountry == null )%>"><%=Utilities.getSortImageTag(sortCountry)%><%=contentManagement.getContent("sites_designations-result_09")%></a>
          </th>
<%
  }
  if (showDesignation)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignation, sortDesignation == null )%>"><%=Utilities.getSortImageTag(sortDesignation)%><%=contentManagement.getContent("sites_designations-result_05")%></a>
          </th>
<%
  }
  if (showDesignEn)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION_EN%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignEn, sortDesignEn == null )%>"><%=Utilities.getSortImageTag(sortDesignEn)%><%=contentManagement.getContent("sites_designations-result_06")%></a>
          </th>
<%
  }
  if (showDesignFr)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_DESIGNATION_FR%>&amp;ascendency=<%=formBean.changeAscendency(sortDesignFr, sortDesignFr == null )%>"><%=Utilities.getSortImageTag(sortDesignFr)%><%=contentManagement.getContent("sites_designations-result_07")%></a>
          </th>
<%
  }
  if (showAbreviation)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=DesignationsSortCriteria.SORT_ABREVIATION%>&amp;ascendency=<%=formBean.changeAscendency(sortAbreviation, sortAbreviation == null )%>"><%=Utilities.getSortImageTag(sortAbreviation)%><%=contentManagement.getContent("sites_designations-result_08")%></a>
          </th>
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
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-designations-result.jsp" />
      </jsp:include>
    </div>
  </body>
</html>