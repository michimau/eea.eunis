<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites size" function - results page.
--%>
<%@ page import="ro.finsiel.eunis.search.sites.size.SizeBean,
                 ro.finsiel.eunis.search.sites.size.SizePaginator,
                 ro.finsiel.eunis.jrfTables.sites.size.SizeDomain,
                 java.util.List,
                 ro.finsiel.eunis.search.sites.size.SizeSearchCriteria,
                 ro.finsiel.eunis.search.sites.size.SizeSortCriteria,
                 ro.finsiel.eunis.jrfTables.sites.size.SizePersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector,
                 ro.finsiel.eunis.search.*"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<%@ page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.size.SizeBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), SizeBean.HIDE);
  boolean showCountry = Utilities.checkedStringToBoolean(formBean.getShowCountry(), SizeBean.HIDE);
  boolean showDesignType = Utilities.checkedStringToBoolean(formBean.getShowDesignationTypes(), SizeBean.HIDE);
  boolean showCoord = Utilities.checkedStringToBoolean(formBean.getShowCoordinates(), SizeBean.HIDE);
  boolean showSize = Utilities.checkedStringToBoolean(formBean.getShowSize(), SizeBean.HIDE);
  boolean showLength = Utilities.checkedStringToBoolean(formBean.getShowLength(), SizeBean.HIDE);
  boolean[] source =
  {
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
  SizePaginator paginator = new SizePaginator(new SizeDomain(formBean.toSearchCriteria(),
    formBean.toSortCriteria(), SessionManager.getUsername(), source));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "sites-size-result.jsp";
  int resultsCount = paginator.countResults();
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
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-size.js"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
      // Change the operator list according to criteria selected element from criteria type list
      function changeCriteria() {
        var criteriaType = document.getElementById("criteriaType0").options[document.getElementById("criteriaType0").selectedIndex].value;
        var operList = document.getElementById("oper0");
        changeOperatorList(criteriaType, operList);
      }

      // Reconstruct the list items depending on the selected item
      function changeOperatorList(criteriaType, operList) {
        var SOURCE_DB = <%=SizeSearchCriteria.CRITERIA_SOURCE_DB%>;
        var COUNTRY = <%=SizeSearchCriteria.CRITERIA_COUNTRY%>;
        var NAME = <%=SizeSearchCriteria.CRITERIA_ENGLISH_NAME%>;
        var SIZE = <%=SizeSearchCriteria.CRITERIA_AREA%>;
        var LENGTH = <%=SizeSearchCriteria.CRITERIA_LENGTH%>;
        removeElementsFromList(operList);
        var optIS = document.createElement("OPTION");
        optIS.text = "<%=contentManagement.getContent("sites_size-result_02", false)%>";
        optIS.value = "<%=Utilities.OPERATOR_IS%>";
        var optSTART = document.createElement("OPTION");
        optSTART.text = "<%=contentManagement.getContent("sites_size-result_03", false)%>";
        optSTART.value = "<%=Utilities.OPERATOR_STARTS%>";
        var optCONTAIN = document.createElement("OPTION");
        optCONTAIN.text = "<%=contentManagement.getContent("sites_size-result_04", false)%>";
        optCONTAIN.value = "<%=Utilities.OPERATOR_CONTAINS%>";
        var optGREAT = document.createElement("OPTION");
        optGREAT.text = "<%=contentManagement.getContent("sites_size-result_05", false)%>";
        optGREAT.value = "<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>";
        var optSMALL = document.createElement("OPTION");
        optSMALL.text = "<%=contentManagement.getContent("sites_size-result_06", false)%>";
        optSMALL.value = "<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>";
        // Source data set
        if (criteriaType == SOURCE_DB) {
          operList.add(optIS, 0);
          document.getElementById("binocular").style.visibility = "visible";
        }
        // Country
        if (criteriaType == COUNTRY) {
          operList.add(optIS, 0);
          document.getElementById("binocular").style.visibility = "visible";
        }
        // Site name
        if (criteriaType == NAME) {
          operList.add(optIS, 0);
          operList.add(optSTART, 1);
          operList.add(optCONTAIN, 2);
          document.getElementById("binocular").style.visibility = "hidden";
        }
        // Site size
        if (criteriaType == SIZE) {
          operList.add(optIS, 0);
          operList.add(optGREAT, 1);
          operList.add(optSMALL, 2);
          document.getElementById("binocular").style.visibility = "hidden";
        }
        // Site length
        if (criteriaType == LENGTH) {
          operList.add(optIS, 0);
          operList.add(optGREAT, 1);
          operList.add(optSMALL, 2);
          document.getElementById("binocular").style.visibility = "hidden";
        }
      }
    //-->
    </script>
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_size-result_title", false )%></title>
  </head>
  <body>
<%
  String downloadLink = "javascript:openlink('reports/sites/tsv-sites-size.jsp?" + formBean.toURLParam(reportFields) + "')";
%>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Size#sites-size.jsp,Results"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
        <jsp:param name="downloadLink" value="<%=downloadLink%>"/>
      </jsp:include>
      <h5>
        <%=contentManagement.getContent("sites_size-result_01")%>
      </h5>

      <%=contentManagement.getContent("sites_size-result_07")%>
      <%=formBean.getMainSearchCriteria().toHumanString()%>
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

          <%=contentManagement.getContent("sites_size-result_08")%> <strong><%=resultsCount%></strong><br />
<%
          Vector mapFields = new Vector();
          mapFields.addElement("criteriaSearch");
          mapFields.addElement("oper");
          mapFields.addElement("criteriaType");
%>
          <jsp:include page="sites-map.jsp">
            <jsp:param name="resultsCount" value="<%=resultsCount%>"/>
            <jsp:param name="mapName" value="sites-size-map.jsp"/>
            <jsp:param name="toURLParam" value="<%=formBean.toURLParam(mapFields)%>"/>
          </jsp:include>
<%
          Vector pageSizeFormFields = new Vector();
          pageSizeFormFields.addElement("sort");
          pageSizeFormFields.addElement("ascendency");
          pageSizeFormFields.addElement("criteriaSearch");
 %>
          <jsp:include page="pagesize.jsp">
            <jsp:param name="guid" value="<%=guid%>"/>
            <jsp:param name="pageName" value="<%=pageName%>"/>
            <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>"/>
            <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>"/>
          </jsp:include>
<%
          Vector filterSearch = new Vector();
          filterSearch.addElement("sort");
          filterSearch.addElement("ascendency");
          filterSearch.addElement("criteriaSearch");
          filterSearch.addElement("pageSize");
%>
      <div class="grey_rectangle">
        <strong>
          <%=contentManagement.getContent("sites_size-result_09")%>
        </strong>
        <form title="refine search results" name="criteriaSearch" method="get" onsubmit="return(check(<%=noCriteria%>));" action="">
          <%=formBean.toFORMParam(filterSearch)%>
          <label for="criteriaType0" class="noshow">Criteria</label>
          <select id="criteriaType0" name="criteriaType" class="inputTextField" onchange="changeCriteria()" title="Criteria">
<%
  if (showSourceDB)
  {
%>
            <option value="<%=SizeSearchCriteria.CRITERIA_SOURCE_DB%>">
              <%=contentManagement.getContent("sites_size-result_10", false)%>
            </option>
<%
  }
  if (showCountry)
  {
%>
            <option value="<%=SizeSearchCriteria.CRITERIA_COUNTRY%>">
              <%=contentManagement.getContent("sites_size-result_11", false)%>
            </option>
<%
  }
%>
            <option value="<%=SizeSearchCriteria.CRITERIA_ENGLISH_NAME%>">
              <%=contentManagement.getContent("sites_size-result_12", false)%>
            </option>
<%
  if (showSize)
  {
%>
            <option value="<%=SizeSearchCriteria.CRITERIA_AREA%>">
              <%=contentManagement.getContent("sites_size-result_13", false)%>
            </option>
<%
  }
  if (showLength)
  {
%>
            <option value="<%=SizeSearchCriteria.CRITERIA_LENGTH%>">
              <%=contentManagement.getContent("sites_size-result_14", false)%>
            </option>
<%
  }
%>
          </select>
          <label for="oper0" class="noshow">Operator</label>
          <select id="oper0" name="oper" class="inputTextField" title="Operator">
            <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
              <%=contentManagement.getContent("sites_size-result_02", false)%>
            </option>
          </select>
          <label for="criteriaSearch0" class="noshow">Filter value</label>
          <input id="criteriaSearch0" name="criteriaSearch" type="text" size="30" class="inputTextField" title="Filter value" />
          <a title="<%=Accesibility.getText( "generic.refined.question" )%>" href="javascript:openRefineHint()" name="binocular" id="binocular"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.refined.question" )%>" title="<%=Accesibility.getText( "generic.refined.question" )%>" border="0" width="11" height="18" align="middle" /></a>
          <label for="submit" class="noshow">Search</label>
          <input id="submit" name="Submit" title="Search" value="<%=contentManagement.getContent("sites_size-result_15", false)%>" type="submit" class="inputTextField" />
          <%=contentManagement.writeEditTag( "sites_size-result_15" )%>
        </form>
<%
  ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
  if (criterias.length > 1)
  {
%>
        <%=contentManagement.getContent("sites_size-result_16")%>
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
          &nbsp;&nbsp;<strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
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
<%// Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  sortURLFields.addElement("criteriaSearch");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(SizeSortCriteria.SORT_SOURCE_DB);
  AbstractSortCriteria sortCountry = formBean.lookupSortCriteria(SizeSortCriteria.SORT_COUNTRY);
  AbstractSortCriteria sortName = formBean.lookupSortCriteria(SizeSortCriteria.SORT_NAME);
  AbstractSortCriteria sortSize = formBean.lookupSortCriteria(SizeSortCriteria.SORT_SIZE);
  AbstractSortCriteria sortLength = formBean.lookupSortCriteria(SizeSortCriteria.SORT_LENGTH);
  AbstractSortCriteria sortLat = formBean.lookupSortCriteria(SizeSortCriteria.SORT_LAT);
  AbstractSortCriteria sortLong = formBean.lookupSortCriteria(SizeSortCriteria.SORT_LONG);
  AbstractSortCriteria sortYear = formBean.lookupSortCriteria(SizeSortCriteria.SORT_YEAR);
%>
        <table summary="Search results" border="1" cellpadding="0" cellspacing="0" align="center" width="100%" style="border-collapse: collapse">
        <tr>
<%
  if(showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_size-result_17")%></a>
          </th>
<%
  }
  if(showCountry)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=contentManagement.getContent("sites_size-result_11")%></a>
          </th>
<%
  }
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=contentManagement.getContent("sites_size-result_12")%></a>
          </th>
<%
  if(showDesignType)
  {
%>
          <th class="resultHeader">
            <%=contentManagement.getContent("sites_size-result_18")%>
          </th>
<%
  }
  if (showCoord)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_size-result_19")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_size-result_20")%>
          </th>
<%
  }
  if(showSize)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=contentManagement.getContent("sites_size-result_21")%></a>
          </th>
<%
  }
  if(showLength)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_LENGTH%>&amp;ascendency=<%=formBean.changeAscendency(sortLength, null == sortLength)%>"><%=Utilities.getSortImageTag(sortLength)%><%=contentManagement.getContent("sites_size-result_22")%></a>
          </th>
<%
  }
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null == sortYear)%>"><%=Utilities.getSortImageTag(sortYear)%><%=contentManagement.getContent("sites_size-result_23")%></a>
          </th>
        </tr>
<%
  String bgcolor;
  for (int i = 0; i < results.size(); i++) {
    bgcolor = (0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF";
    SizePersist site = (SizePersist)results.get(i);
%>
        <tr>
<%
  if (showSourceDB)
  {
%>
          <td bgcolor="<%=bgcolor%>">
            <strong><%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>&nbsp;</strong>
          </td>
<%
  }
  if (showCountry)
  {
%>
          <td bgcolor="<%=bgcolor%>">
            <%=site.getAreaNameEn()%> &nbsp;
          </td>
<%
  }
%>
          <td bgcolor="<%=bgcolor%>">
            <a title="Site factsheet" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=Utilities.formatString(site.getName() )%></a>
          </td>
<%
  if (showDesignType)
  {
%>
           <td bgcolor="<%=bgcolor%>">
            <jsp:include page="sites-designations-detail.jsp">
              <jsp:param name="idDesignation" value="<%=site.getIdDesignation()%>"/>
              <jsp:param name="idGeoscope" value="<%=site.getIdGeoscope()%>"/>
              <jsp:param name="sourceDB" value="<%=site.getSourceDB()%>"/>
              <jsp:param name="bgcolor" value="<%=bgcolor%>"/>
            </jsp:include>
          </td>
<%
  }
  if (showCoord)
  {
%>
          <td align="center" bgcolor="<%=bgcolor%>" nowrap="nowrap">
            <%=SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec())%>
          </td>
          <td align="center" bgcolor="<%=bgcolor%>" nowrap="nowrap">
            <%=SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec())%>
          </td>
<%
  }
  if (showSize)
  {
%>
          <td align="right" bgcolor="<%=bgcolor%>">
            <%=Utilities.formatArea(site.getArea(), 9, 2, "&nbsp;")%>
          </td>
<%
  }
  if (showLength)
  {
%>
          <td align="right" bgcolor="<%=bgcolor%>">
            <%=Utilities.formatArea(site.getLength(), 9, 2, "&nbsp;")%>
          </td>
<%
  }
%>
          <td align="right" bgcolor="<%=bgcolor%>">
            <%=SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB())%>
          </td>
        </tr>
<%
  }
%>
        <tr>
<%
  if(showSourceDB)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=contentManagement.getContent("sites_size-result_17")%></a>
          </th>
<%
  }
  if(showCountry)
  {
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=contentManagement.getContent("sites_size-result_11")%></a>
          </th>
<%
  }
%>
          <th class="resultHeader">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=contentManagement.getContent("sites_size-result_12")%></a>
          </th>
<%
  if(showDesignType)
  {
%>
          <th class="resultHeader">
            <%=contentManagement.getContent("sites_size-result_18")%>
          </th>
<%
  }
  if (showCoord)
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_size-result_19")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=contentManagement.getContent("sites_size-result_20")%>
          </th>
<%
  }
  if(showSize)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=contentManagement.getContent("sites_size-result_21")%></a>
          </th>
<%
  }
  if(showLength)
  {
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_LENGTH%>&amp;ascendency=<%=formBean.changeAscendency(sortLength, null == sortLength)%>"><%=Utilities.getSortImageTag(sortLength)%><%=contentManagement.getContent("sites_size-result_22")%></a>
          </th>
<%
  }
%>
          <th class="resultHeader" style="text-align : right;">
            <a title="Sort results by this column" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SizeSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null == sortYear)%>"><%=Utilities.getSortImageTag(sortYear)%><%=contentManagement.getContent("sites_size-result_23")%></a>
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
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-size-result.jsp" />
      </jsp:include>
    </div>
  </body>
</html>