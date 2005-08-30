<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats names and descriptions' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.names.NameSortCriteria,
                 java.util.Vector" %>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.names.NameBean" scope="page">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-names.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <%// Get form parameters here%>
  <%
    String action = formBean.getAction();
    boolean doAdd = false;
    // Add criteria.
    if (null != action && action.equalsIgnoreCase("search")) {%><jsp:forward page="habitats-names-result.jsp" /><%}
    if (null != action && action.equalsIgnoreCase("add")) {
      // Process the request
      doAdd = true;
    }
    // Delete criteria.
    if (null != action && action.equalsIgnoreCase("delete")) {
      int deleteIndex = Utilities.checkedStringToInt(formBean.getDeleteIndex(), -1);
      formBean.removeCriteriaExtra(deleteIndex);
      doAdd = true;
    }%>
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_names_title", false)%>
  </title>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Names and Descriptions" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
</jsp:include>
<form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="habitats-names-result.jsp">
<input type="hidden" name="showScientificName" value="true" />
<input type="hidden" name="deleteIndex" value="-1" />
<input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_EUNIS_CODE%>" />
<input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
<input type="hidden" name="noSoundex" value="true" />
<table width="100%" border="0" summary="Search criteria">
  <tr>
    <td>
      <h5>
        <%=contentManagement.getContent("habitats_names_01")%>
      </h5>
      <%=contentManagement.getContent("habitats_names_23")%>
      <br />
      <br />
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td bgcolor="#EEEEEE">
            <strong>
              <%=contentManagement.getContent("habitats_names_02")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td bgcolor="#EEEEEE" valign="middle">
            <input type="checkbox" id="showLevel" name="showLevel" value="true" checked="checked" />
            <label for="showLevel"><%=contentManagement.getContent("habitats_names_03")%></label>
            <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
            <label for="showCode"><%=contentManagement.getContent("habitats_names_04")%></label>
            <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
            <label for="showScientificName"><%=contentManagement.getContent("habitats_names_05")%></label>
            <input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />
            <label for="showVernacularName"><%=contentManagement.getContent("habitats_names_06")%></label>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align="left" colspan="3">
      <img alt="Mandatory" src="images/mini/field_mandatory.gif" align="middle" />&nbsp;
      <label for="searchString" class="fontBold"><%=contentManagement.getContent("habitats_names_22")%></label>
      <label for="relationOp" class="noshow">Operator</label>
      <select title="Operator" name="relationOp" id="relationOp" class="inputTextField">
        <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_names_08", false)%></option>
        <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("habitats_names_09", false)%></option>
        <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("habitats_names_10", false)%></option>
      </select>
      <label for="searchString" class="noshow">Search value</label>
      <input type="text" size="30" name="searchString" id="searchString" class="inputTextField" title="Search value" />&nbsp;
      <a href="javascript:openHelper('habitats-names-choice.jsp')"><img alt="List of values" title="List of values" border="0" src="images/helper/helper.gif" width="11" height="18" align="middle" /></a>
    </td>
  </tr>
  <tr>
    <td align="left" bgcolor="#EEEEEE">
      <%=contentManagement.getContent("habitats_names_11")%>:&nbsp;
      <input type="radio" id="database1" name="database" value="<%=NamesDomain.SEARCH_EUNIS%>" checked="checked"
             title="Search the EUNIS habitat types database" />
      <label for="database1"><%=contentManagement.getContent("habitats_names_12")%></label>
      &nbsp;&nbsp;
      <input type="radio" id="database2" name="database" value="<%=NamesDomain.SEARCH_ANNEX_I%>"
             title="Search the Annex I habitat types database" />
      <label for="database2"><%=contentManagement.getContent("habitats_names_13")%></label>
      &nbsp;&nbsp;
      <input type="radio" id="database3" name="database" value="<%=NamesDomain.SEARCH_BOTH%>"
             title="Search both in EUNIS and Annex I habitat types" />
      <label for="database3"><%=contentManagement.getContent("habitats_names_14")%></label>
    </td>
  </tr>
  <tr>
    <td align="left">
      <%=contentManagement.getContent("habitats_names_15")%>:
      <input type="checkbox" name="useScientific" id="useScientific" value="true" checked="checked" />
      <label for="useScientific"><%=contentManagement.getContent("habitats_names_16")%></label>
      <input type="checkbox" name="useVernacular" id="useVernacular" value="true" checked="checked" />
      <label for="useVernacular"><%=contentManagement.getContent("habitats_names_17")%></label>
      <input type="checkbox" name="useDescription" id="useDescription" value="true" />
      <label for="useDescription"><%=contentManagement.getContent("habitats_names_18")%></label>
      &nbsp;
    </td>
  </tr>
  <tr>
    <td align="right">
      <label for="Reset" class="noshow">Reset values</label>
      <input title="Reset values" type="reset" value="<%=contentManagement.getContent("habitats_names_19", false )%>" name="Reset" id="Reset" class="inputTextField" />
      <%=contentManagement.writeEditTag("habitats_names_19")%>
      <label for="action" class="noshow">Search</label>
      <input title="Search" type="submit" value="<%=contentManagement.getContent("habitats_names_20", false )%>" name="action" id="action" class="inputTextField" />
      <%=contentManagement.writeEditTag("habitats_names_20")%>
    </td>
  </tr>
</table>
</form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT()) {
%>
    <br />
    &nbsp;
    <script type="text/javascript" language="JavaScript">
    <!--
    // values of this constants from specific class Domain
    var source1='';
    var source2='';
    var database1='<%=NamesDomain.SEARCH_EUNIS%>';
    var database2='<%=NamesDomain.SEARCH_ANNEX_I%>';
    var database3='<%=NamesDomain.SEARCH_BOTH%>';
    //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
    <script language="JavaScript" src="script/habitats-names-save-criteria.js" type="text/javascript"></script>
    <%=contentManagement.getContent("habitats_names_21")%>:
    <a href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-names.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');">
      <img alt="Save criteria" title="Save" border="0" src="images/save.jpg" width="21" height="19" align="middle" />
    </a>
<%
  // Set Vector for URL string
  Vector show = new Vector();
  show.addElement("showLevel");
  show.addElement("showCode");
  show.addElement("showScientificName");
  show.addElement("showVernacularName");
  String pageName = "habitats-names.jsp";
  String pageNameResult = "habitats-names-result.jsp?" + Utilities.writeURLCriteriaSave(show);
  // Expand or not save criterias list
  String expandSearchCriteria = (request.getParameter("expandSearchCriteria") == null ? "no" : request.getParameter("expandSearchCriteria"));
%>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
<%}%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-names.jsp" />
</jsp:include>
    </div>
  </body>
</html>