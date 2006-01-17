<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats names and descriptions' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-names.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
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
    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_names_title")%>
  </title>
</head>

<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home_location#index.jsp,habitats_location#habitats.jsp,habitats_names_location" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
</jsp:include>
<form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="habitats-names-result.jsp">
<input type="hidden" name="showScientificName" value="true" />
<input type="hidden" name="deleteIndex" value="-1" />
<input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_EUNIS_CODE%>" />
<input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
<input type="hidden" name="noSoundex" value="true" />
<table width="100%" border="0" summary="layout">
  <tr>
    <td>
      <h1>
        <%=cm.cmsText("habitats_names_01")%>
      </h1>
      <%=cm.cmsText("habitats_names_23")%>
      <br />
      <br />
      <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="layout">
        <tr>
          <td bgcolor="#EEEEEE">
            <strong>
              <%=cm.cmsText("habitats_names_02")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td bgcolor="#EEEEEE" valign="middle">
            <input type="checkbox" id="showLevel" name="showLevel" value="true" checked="checked" />
            <label for="showLevel"><%=cm.cmsText("habitats_names_03")%></label>
            <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
            <label for="showCode"><%=cm.cmsText("habitats_names_04")%></label>
            <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
            <label for="showScientificName"><%=cm.cmsText("habitats_names_05")%></label>
            <input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />
            <label for="showVernacularName"><%=cm.cmsText("habitats_names_06")%></label>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="3">
      <img alt="<%=cm.cms("mandatory_field")%>" src="images/mini/field_mandatory.gif" align="middle" /><%=cm.cmsTitle("mandatory_field")%>&nbsp;
      <label for="searchString" class="fontBold"><%=cm.cmsText("habitats_names_22")%></label>
      <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
      <select title="<%=cm.cms("operator")%>" name="relationOp" id="relationOp" class="inputTextField">
        <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("habitats_names_08")%></option>
        <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("habitats_names_09")%></option>
        <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("habitats_names_10")%></option>
      </select>
      <%=cm.cmsLabel("operator")%>
      <%=cm.cmsInput("habitats_names_08")%>
      <%=cm.cmsInput("habitats_names_09")%>
      <%=cm.cmsInput("habitats_names_10")%>
      <label for="searchString" class="noshow"><%=cm.cms("search_value")%></label>
      <input type="text" size="30" name="searchString" id="searchString" class="inputTextField" title="<%=cm.cms("search_value")%>" /><%=cm.cmsTitle("search_value")%>&nbsp;
      <a href="javascript:openHelper('habitats-names-choice.jsp')" title="<%=cm.cms("list_of_values")%>"><img alt="<%=cm.cms("list_of_values")%>" title="<%=cm.cms("list_of_values")%>" border="0" src="images/helper/helper.gif" width="11" height="18" align="middle" /></a><%=cm.cmsTitle("list_of_values")%>
    </td>
  </tr>
  <tr>
    <td bgcolor="#EEEEEE">
      <%=cm.cmsText("habitats_names_11")%>:&nbsp;
      <input type="radio" id="database1" name="database" value="<%=NamesDomain.SEARCH_EUNIS%>" checked="checked"
             title="<%=cm.cms("search_eunis")%>" />
      <%=cm.cmsTitle("search_eunis")%>
      <label for="database1"><%=cm.cmsText("habitats_names_12")%></label>
      &nbsp;&nbsp;
      <input type="radio" id="database2" name="database" value="<%=NamesDomain.SEARCH_ANNEX_I%>"
             title="<%=cm.cms("search_annex1")%>" />
      <%=cm.cmsTitle("search_annex1")%>
      <label for="database2"><%=cm.cmsText("habitats_names_13")%></label>
      &nbsp;&nbsp;
      <input type="radio" id="database3" name="database" value="<%=NamesDomain.SEARCH_BOTH%>"
             title="<%=cm.cms("search_both")%>" />
      <%=cm.cmsTitle("search_both")%>
      <label for="database3"><%=cm.cmsText("habitats_names_14")%></label>
    </td>
  </tr>
  <tr>
    <td>
      <%=cm.cmsText("habitats_names_15")%>:
      <input type="checkbox" name="useScientific" id="useScientific" value="true" checked="checked" />
      <label for="useScientific"><%=cm.cmsText("habitats_names_16")%></label>
      <input type="checkbox" name="useVernacular" id="useVernacular" value="true" checked="checked" />
      <label for="useVernacular"><%=cm.cmsText("habitats_names_17")%></label>
      <input type="checkbox" name="useDescription" id="useDescription" value="true" />
      <label for="useDescription"><%=cm.cmsText("habitats_names_18")%></label>
      &nbsp;
    </td>
  </tr>
  <tr>
    <td align="right">
      <input title="<%=cm.cms("reset_btn")%>" type="reset" value="<%=cm.cms("habitats_names_19")%>" name="Reset" id="Reset" class="inputTextField" />
      <%=cm.cmsTitle("reset_btn")%>
      <%=cm.cmsInput("habitats_names_19")%>
      <input title="<%=cm.cms("search_btn")%>" type="submit" value="<%=cm.cms("habitats_names_20")%>" name="action" id="action" class="inputTextField" />
      <%=cm.cmsTitle("search_btn")%>
      <%=cm.cmsInput("habitats_names_20")%>
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
    <script language="JavaScript" src="script/habitats-names-save-criteria.js" type="text/javascript"></script>
    <%=cm.cmsText("habitats_names_21")%>:
    <a title="<%=cm.cms("save_criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-names.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_criteria")%>" title="Save" border="0" src="images/save.jpg" width="21" height="19" align="middle" /></a>
    <%=cm.cmsTitle("save_criteria")%>
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
<%=cm.br()%>
<%=cm.cmsMsg("habitats_names_title")%>
<%=cm.br()%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-names.jsp" />
</jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>