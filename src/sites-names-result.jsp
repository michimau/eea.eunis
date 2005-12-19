<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites names" function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.sites.names.NamePaginator,
                 ro.finsiel.eunis.jrfTables.sites.names.NameDomain,
                 ro.finsiel.eunis.jrfTables.sites.names.NamePersist,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.sites.names.NameBean,
                 ro.finsiel.eunis.search.sites.names.NameSearchCriteria,
                 ro.finsiel.eunis.search.sites.names.NameSortCriteria,
                 ro.finsiel.eunis.search.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.SitesSearchCriteria,
                 ro.finsiel.eunis.jrfTables.Chm62edtSoundexPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtSoundexDomain"%>
<%@ page import="ro.finsiel.eunis.admin.FileUtils"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.names.NameBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  Utilities.dumpRequestParams( request );
  FileUtils.dumpToFile( request.getParameter("englishName").toString(), false );
  FileUtils.dumpToFile( java.net.URLDecoder.decode( request.getParameter("englishName").toString(), "UTF-8" ), false );
  boolean noSoundex = Utilities.checkedStringToBoolean( formBean.getNoSoundex(), false );
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Check columns to be displayed
  boolean showSourceDB = Utilities.checkedStringToBoolean(formBean.getShowSourceDB(), NameBean.HIDE);
  boolean showName = Utilities.checkedStringToBoolean(formBean.getShowName(), NameBean.HIDE);
  boolean showCountry = Utilities.checkedStringToBoolean(formBean.getShowCountry(), NameBean.HIDE);
  boolean showDesignType = Utilities.checkedStringToBoolean(formBean.getShowDesignationTypes(), NameBean.HIDE);
  boolean showCoord = Utilities.checkedStringToBoolean(formBean.getShowCoordinates(), NameBean.HIDE);
  boolean showSize = Utilities.checkedStringToBoolean(formBean.getShowSize(), NameBean.HIDE);
  boolean newName = Utilities.checkedStringToBoolean( formBean.getNewName(), false );
  boolean showYear = Utilities.checkedStringToBoolean( formBean.getShowYear(), false );
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
  NamePaginator paginator = new NamePaginator(new NameDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), SessionManager.getUsername(), source));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  final String pageName = "sites-names-result.jsp";
  int resultsCount = 0;
  int pagesCount = 0;// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = new ArrayList();
  try
  {
    pagesCount = paginator.countPages();
    resultsCount = paginator.countResults();
    if ( resultsCount > 0 )
    {
      results = paginator.getPage(currentPage);
    }
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  // Set number criteria for the search result
  int noCriteria = (null==formBean.getCriteriaSearch()?0:formBean.getCriteriaSearch().length);
  String downloadLink = "javascript:openTSVDownload('reports/sites/tsv-sites-names.jsp?" + formBean.toURLParam(reportFields) + "')";
  WebContentManagement cm = SessionManager.getWebContent();
  if (results.isEmpty() && !newName && !noSoundex )
  {
    String sname = formBean.getEnglishName();
    List list = new Vector();
    String cnstSoundex = new String(ro.finsiel.eunis.utilities.SQLUtilities.smartSoundex);
    cnstSoundex = cnstSoundex.replaceAll("<name>", sname.replaceAll( "'", "''" ) );
    cnstSoundex = cnstSoundex.replaceAll("<object_type>", "SITE");
    list = new Chm62edtSoundexDomain().findCustom(cnstSoundex);
    if (list != null && list.size() > 0)
    {
      Chm62edtSoundexPersist t = (Chm62edtSoundexPersist) list.get(0);
      String soundexName = t.getName();
      try {
        String URL = "sites-names-result.jsp?showName=true&showDesignationYear=true&showSourceDB=true&showCountry=true&showDesignationTypes=true&showCoordinates=true&showSize=true&relationOp=4&englishName="+soundexName+"&country=&yearMin=&yearMax=&Submit2=Search&DB_NATURA2000=ON&DB_CDDA_NATIONAL=ON&DB_DIPLOMA=ON&DB_CDDA_INTERNATIONAL=ON&DB_CORINE=ON&DB_BIOGENETIC=ON&newName=true&noSoundex=false&oldName="+sname;
        response.sendRedirect(URL);
        return;
      }  catch(Exception e) {
        e.printStackTrace();
      }
    }
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-names.js"></script>
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
          var SOURCE_DB = <%=SitesSearchCriteria.CRITERIA_SOURCE_DB%>;
          var COUNTRY = <%=SitesSearchCriteria.CRITERIA_COUNTRY%>;
          var NAME = <%=SitesSearchCriteria.CRITERIA_ENGLISH_NAME%>;
          var SIZE = <%=SitesSearchCriteria.CRITERIA_SIZE%>;
          removeElementsFromList(operList);
          var optIS = document.createElement("OPTION");
          optIS.text = "is";
          optIS.value = "<%=Utilities.OPERATOR_IS%>";
          var optSTART = document.createElement("OPTION");
          optSTART.text = "starts";
          optSTART.value = "<%=Utilities.OPERATOR_STARTS%>";
          var optCONTAIN = document.createElement("OPTION");
          optCONTAIN.text = "contains";
          optCONTAIN.value = "<%=Utilities.OPERATOR_CONTAINS%>";
          var optGREAT = document.createElement("OPTION");
          optGREAT.text = "greater";
          optGREAT.value = "<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>";
          var optSMALL = document.createElement("OPTION");
          optSMALL.text = "smaller";
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
        }
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_names-result_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,sites_names_location#sites-names.jsp,results_location"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
        <jsp:param name="downloadLink" value="<%=downloadLink%>"/>
      </jsp:include>
      <h1>
        <%=cm.cmsText("sites_names-result_01")%>
      </h1>
<%
  if (!results.isEmpty()) {
    if(newName)
    {
      String searchDescription = "";
      if(!formBean.getOldName().equalsIgnoreCase(formBean.getEnglishName()))
      {
        searchDescription = cm.cms( "no_match_was_found_for") + " <strong>"+formBean.getOldName()+"</strong>.&nbsp;";
        searchDescription += cm.cms( "phonetic_match" ) + ": <strong>"+formBean.getEnglishName()+"</strong>";
      }
      else
      {
        searchDescription += cm.cms( "phonetic_match" ) + ": <strong>"+formBean.getEnglishName()+"</strong>";
      }
%>
      <%=searchDescription%>
<%
    } else {
%>
      <%=cm.cmsText("sites_names-result_02")%>
      <strong>
        <%=formBean.getMainSearchCriteria().toHumanString()%>
      </strong>
<%
    }
  }

  if (results.isEmpty()) {
       boolean fromRefine = false;
       if(formBean != null && formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0)
         fromRefine = true;

      %>
         <br />
         <jsp:include page="noresults.jsp" >
           <jsp:param name="fromRefine" value="<%=fromRefine%>" />
         </jsp:include>
       <%
         return;
   }
   %>
  <br />
  <%=cm.cmsText("results_found")%>: <strong><%=resultsCount%></strong>
  <br />
<%
  Vector mapFields = new Vector();
  mapFields.addElement("criteriaSearch");
  mapFields.addElement("oper");
  mapFields.addElement("criteriaType");

  for (int i = 0; i < results.size(); i++)
  {
    NamePersist site = (NamePersist)results.get(i);
    String longitude = SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec());
    String latitude = SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec());
    if ( longitude.lastIndexOf( "n/a" ) < 0 && latitude.lastIndexOf( "n/a" ) < 0 )
    {
%>
      <jsp:include page="sites-map.jsp">
        <jsp:param name="resultsCount" value="<%=resultsCount%>" />
        <jsp:param name="mapName" value="sites-names-map.jsp"/>
        <jsp:param name="toURLParam" value="<%=formBean.toURLParam(mapFields)%>"/>
      </jsp:include>
<%
      break;
    };
  }

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
      <br />
      <div class="grey_rectangle">
        <%=cm.cmsText("sites_names-result_03")%>
        <form title="Refine search results" name="criteriaSearch" onsubmit="return(check(<%=noCriteria%>));" method="get" action="">
          <input type="hidden" name="noSoundex" value="true" />
          <strong>
            <%=formBean.toFORMParam(filterSearch)%>
          </strong>
          <label for="criteriaType0" class="noshow"><%=cm.cms("criteria_type_label")%></label>
          <select id="criteriaType0" name="criteriaType" class="inputTextField" onchange="changeCriteria()" title="<%=cm.cms("criteria_type_title")%>">
<%
  if ( showSourceDB )
  {
%>
            <option value="<%=NameSearchCriteria.CRITERIA_SOURCE_DB%>">
              <%=cm.cms("sites_names-result_04")%>
            </option>
<%
  }
  if ( showCountry )
  {
%>
            <option value="<%=NameSearchCriteria.CRITERIA_COUNTRY%>">
              <%=cm.cms("sites_names-result_05")%>
            </option>
<%
  }
  if ( showName )
  {
%>
            <option value="<%=NameSearchCriteria.CRITERIA_ENGLISH_NAME%>">
              <%=cm.cms("sites_names-result_06")%>
            </option>
<%
  }
  if ( showSize )
  {
%>
            <option value="<%=NameSearchCriteria.CRITERIA_SIZE%>">
              <%=cm.cms("sites_names-result_07")%>
            </option>
<%
  }
%>
          </select>
          <%=cm.cmsLabel("criteria_type_label")%>
          <%=cm.cmsTitle("criteria_type_title")%>
          <%=cm.cmsInput("sites_names-result_04")%>
          <%=cm.cmsInput("sites_names-result_05")%>
          <%=cm.cmsInput("sites_names-result_06")%>
          <%=cm.cmsInput("sites_names-result_07")%>

          <label for="oper0" class="noshow"><%=cm.cms("operator_label")%></label>
          <select id="oper0" name="oper" class="inputTextField" title="<%=cm.cms("operator_title")%>">
            <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cms("sites_names-result_08")%></option>
          </select>
          <%=cm.cmsLabel("operator_label")%>
          <%=cm.cmsTitle("operator_title")%>
          <%=cm.cmsInput("sites_names-result_08")%>

          <label for="criteriaSearch0" class="noshow"><%=cm.cms("filter_label")%></label>
          <input id="criteriaSearch0" name="criteriaSearch" type="text" size="30" class="inputTextField" title="<%=cm.cms("filter_title")%>" />
          <%=cm.cmsLabel("filter_label")%>
          <%=cm.cmsTitle("filter_title")%>

          <a href="javascript:openRefineHint()" title="<%=cm.cms("refine_lov_title")%>" name="binocular" id="binocular"><img src="images/helper/helper.gif" alt="<%=cm.cms("refine_lov_alt")%>" border="0" width="11" height="18" align="middle" /></a>
          <%=cm.cmsTitle("refine_lov_title")%>
          <%=cm.cmsAlt("refine_lov_alt")%>

          <label for="submit" class="noshow"><%=cm.cms("refine_btn_label")%></label>
          <input id="submit" name="Submit" type="submit" value="<%=cm.cms("refine_btn_value")%>" class="inputTextField" title="<%=cm.cms("refine_btn_title")%>" />
          <%=cm.cmsLabel("refine_btn_label")%>
          <%=cm.cmsTitle("refine_btn_title")%>
          <%=cm.cmsInput("refine_btn_value")%>
        </form>
<%
  ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
  if (criterias.length > 1)
  {
%>
        <%=cm.cmsText("sites_names-result_10")%>
        <br />
<%
  }
  for (int i = criterias.length - 1; i > 0; i--)
  {
    AbstractSearchCriteria criteria = criterias[i];
    if (null != criteria && null != formBean.getCriteriaSearch())
    {
%>
        <br />
        <a title="<%=cm.cms("removefilter_title")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img src="images/mini/delete.jpg" alt="<%=cm.cms("removefilter_alt")%>" border="0" align="middle" /></a>
        <%=cm.cmsTitle("removefilter_title")%>
        <%=cm.cmsAlt("removefilter_alt")%>
        <strong>
          <%= i + ". " + criteria.toHumanString()%>
        </strong>
<%
    }
  }
%>
      </div>
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
  AbstractSortCriteria sortSourceDB = formBean.lookupSortCriteria(NameSortCriteria.SORT_SOURCE_DB);
  AbstractSortCriteria sortCountry = formBean.lookupSortCriteria(NameSortCriteria.SORT_COUNTRY);
  AbstractSortCriteria sortName = formBean.lookupSortCriteria(NameSortCriteria.SORT_NAME);
  AbstractSortCriteria sortSize = formBean.lookupSortCriteria(NameSortCriteria.SORT_SIZE);
  AbstractSortCriteria sortLat = formBean.lookupSortCriteria(NameSortCriteria.SORT_LAT);
  AbstractSortCriteria sortLong = formBean.lookupSortCriteria(NameSortCriteria.SORT_LONG);
  AbstractSortCriteria sortYear = formBean.lookupSortCriteria(NameSortCriteria.SORT_YEAR);
%>
      <br />
      <table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
        <tr>
<%
  if ( showSourceDB )
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("sites_names-result_11")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if ( showCountry )
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsText("sites_names-result_05")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsText("sites_names-result_12")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  if ( showDesignType )
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("sites_names-result_13")%>
          </th>
<%
  }
  if ( showCoord )
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_names-result_14")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_names-result_15")%>
          </th>
<%
  }
  if ( showSize )
  {
%>
          <th class="resultHeader" style="text-align : right">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsText("sites_names-result_16")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if ( showYear )
  {
%>
          <th class="resultHeader" style="text-align : right">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null == sortYear)%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsText("sites_names-result_17")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
        </tr>
<%
  String bgColor;
  for (int i = 0; i < results.size(); i++)
  {
    bgColor = (0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF";
    NamePersist site = (NamePersist)results.get(i);
%>
        <tr>
<%
  if ( showSourceDB )
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <strong>
              <%=SitesSearchUtility.translateSourceDB(site.getSourceDB())%>
            </strong>
          </td>
<%
  }
  if (showCountry)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <%=Utilities.formatString(site.getAreaNameEn())%>&nbsp;
          </td>
<%
  }
%>
          <td class="resultCell" style="background-color : <%=bgColor%>;">
            <a title="<%=cm.cms("open_site_factsheet")%>" href="sites-factsheet.jsp?idsite=<%=site.getIdSite()%>"><%=Utilities.formatString( site.getName() )%></a>
            <%=cm.cmsTitle("open_site_factsheet")%>
          </td>
<%
  if (showDesignType)
  {
%>
          <td bgcolor="<%=bgColor%>">
            <jsp:include page="sites-designations-detail.jsp">
              <jsp:param name="idDesignation" value="<%=site.getIdDesignation()%>"/>
              <jsp:param name="idGeoscope" value="<%=site.getIdGeoscope()%>"/>
              <jsp:param name="sourceDB" value="<%=site.getSourceDB()%>"/>
              <jsp:param name="bgcolor" value="<%=bgColor%>"/>
              <jsp:param name="idSite" value="<%=site.getIdSite()%>"/>
            </jsp:include>
          </td>
<%
  }
  if ( showCoord )
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap; text-align : center;">
            <%=SitesSearchUtility.formatCoordinates(site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec())%>
          </td>
          <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap; text-align : center;">
            <%=SitesSearchUtility.formatCoordinates(site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec())%>
          </td>
<%
  }
  if (showSize)
  {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : right;">
            <%=Utilities.formatArea(site.getArea(), 9, 2, "&nbsp;")%>
          </td>
<%
    }
    if ( showYear )
    {
%>
          <td class="resultCell" style="background-color : <%=bgColor%>; text-align : right;">
            <%=SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB())%>
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
  if ( showSourceDB )
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_SOURCE_DB%>&amp;ascendency=<%=formBean.changeAscendency(sortSourceDB, null == sortSourceDB)%>"><%=Utilities.getSortImageTag(sortSourceDB)%><%=cm.cmsText("sites_names-result_11")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if ( showCountry )
  {
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_COUNTRY%>&amp;ascendency=<%=formBean.changeAscendency(sortCountry, null == sortCountry)%>"><%=Utilities.getSortImageTag(sortCountry)%><%=cm.cmsText("sites_names-result_05")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
%>
          <th class="resultHeader">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortName, null == sortName)%>"><%=Utilities.getSortImageTag(sortName)%><%=cm.cmsText("sites_names-result_12")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  if ( showDesignType )
  {
%>
          <th class="resultHeader">
            <%=cm.cmsText("sites_names-result_13")%>
          </th>
<%
  }
  if ( showCoord )
  {
%>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_names-result_14")%>
          </th>
          <th class="resultHeader" style="text-align : center; white-space:nowrap;">
            <%=cm.cmsText("sites_names-result_15")%>
          </th>
<%
  }
  if ( showSize )
  {
%>
          <th class="resultHeader" align="right" style="text-align : right">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_SIZE%>&amp;ascendency=<%=formBean.changeAscendency(sortSize, null == sortSize)%>"><%=Utilities.getSortImageTag(sortSize)%><%=cm.cmsText("sites_names-result_16")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </th>
<%
  }
  if ( showYear )
  {
%>
          <th class="resultHeader" style="text-align : right">
            <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=NameSortCriteria.SORT_YEAR%>&amp;ascendency=<%=formBean.changeAscendency(sortYear, null == sortYear)%>"><%=Utilities.getSortImageTag(sortYear)%><%=cm.cmsText("sites_names-result_17")%></a>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
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

      <%=cm.cmsMsg("sites_names-result_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("search_results")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-names-result.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>