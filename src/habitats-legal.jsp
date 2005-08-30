<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats legal instruments' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.Chm62edtClassCodePersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtHabitatPersist,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                 ro.finsiel.eunis.search.habitats.legal.LegalSortCriteria,
                 java.util.Iterator,
                 java.util.Vector" %>

<jsp:useBean id="HabitatDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtHabitatDomain" scope="page" />
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-legal.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_legal_title", false)%>
  </title>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Legal instruments" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
</jsp:include>
<table width="100%" border="0">
<tr>
<td>
<h5>
  <%=contentManagement.getContent("habitats_legal_01")%>
</h5>
<%=contentManagement.getContent("habitats_legal_17")%>
<br />
<br />
<form name="eunis" action="habitats-legal-result.jsp" method="get" onsubmit="javascript: return validateForm();">
<input type="hidden" name="sort" value="<%=LegalSortCriteria.SORT_EUNIS_CODE%>" />
<input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
<input type="hidden" name="showScientificName" value="true" />
<table width="100%" summary="layout" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td bgcolor="#EEEEEE">
      <strong>
        <%=contentManagement.getContent("habitats_legal_02")%>
      </strong>
    </td>
  </tr>
  <tr>
    <td bgcolor="#EEEEEE">
      <input title="Show level" type="checkbox" id="showLevel" name="showLevel" value="true" checked="checked" />
      <label for="showLevel"><%=contentManagement.getContent("habitats_legal_03")%></label>
      &nbsp;
      <input title="Show code" type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
      <label for="showCode"><%=contentManagement.getContent("habitats_legal_04")%></label>
      &nbsp;
      <input title="Show name" type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
      <label for="showScientificName"><%=contentManagement.getContent("habitats_legal_05")%></label>
      &nbsp;
      <input title="Show legal text" type="checkbox" name="showLegalText" id="showLegalText" value="true" checked="checked" />
      <label for="showLegalText"><%=contentManagement.getContent("habitats_legal_06")%></label>
      &nbsp;
    </td>
  </tr>
</table>
<table summary="Search criteria" cellspacing="2" cellpadding="0" border="0" align="center" width="100%">
  <tr>
    <td colspan="5">
      <br />
    </td>
  </tr>
  <tr>
    <td valign="bottom" colspan="2">
      <p>
        <img alt="Include" src="images/mini/field_included.gif" align="middle" />
        &nbsp;
        <label for="habitatType">
        <strong>
          <%=contentManagement.getContent("habitats_legal_08")%>
        </strong>
        </label>
      </p>
    </td>
    <td valign="bottom" colspan="2">
      <label for="habitatType" class="noshow">Habitat type</label>
      <select title="Habitat type" name="habitatType" id="habitatType" class="inputTextField">
        <option value="any" selected="selected"><%=contentManagement.getContent("habitats_legal_09", false)%></option>
        <%
          // List of EUNIS habitats from first level.
          Iterator it = HabitatsSearchUtility.findEUNISHabitatTypes().iterator();
          while (it.hasNext()) {
            Chm62edtHabitatPersist habitat = (Chm62edtHabitatPersist) it.next();%>
        <option value="<%=habitat.getEunisHabitatCode()%>"><%=habitat.getEunisHabitatCode()%>
          - <%=habitat.getScientificName()%></option>
        <%}%>
      </select>
    </td>
    <td width="6%" align="right">
      <strong>
        <%=contentManagement.getContent("habitats_legal_10")%>
      </strong>
    </td>
  </tr>
  <tr valign="middle">
    <td colspan="2">
      <br />
      <img alt="Include" src="images/mini/field_included.gif" align="middle" />
      &nbsp;
      <label for="searchString">
      <strong>
        <%=contentManagement.getContent("habitats_legal_11")%>
      </strong>
      </label>
    </td>
    <td colspan="2">
      <br />
      <input title="Legal text" size="30" name="searchString" id="searchString" class="inputTextField" />
      &nbsp;
      <a title="List of values" href="javascript:openHelper('habitats-legal-choice.jsp');">
        <img alt="List of values" height="18" src="images/helper/helper.gif"  align="middle" width="11" border="0" /></a>
    </td>
    <td width="6%" align="right">
      <br />
      <strong>
        <%=contentManagement.getContent("habitats_legal_10")%>
      </strong>
    </td>
  </tr>
  <tr valign="middle">
    <td valign="middle" colspan="2">
      <br />
      <img alt="Include" src="images/mini/field_included.gif" align="middle" />
      &nbsp;
      <label for="legalText">
      <strong>
        <%=contentManagement.getContent("habitats_legal_12")%>
      </strong>
      </label>
    </td>
    <td colspan="2">
      <br />
      <label for="legalText" class="noshow">Legal text</label>
      <select title="Legal text" name="legalText" id="legalText" class="inputTextField">
        <option value="any" selected="selected"><%=contentManagement.getContent("habitats_legal_13", false)%></option>
        <%
          // List of habitats legal instruments.
          it = HabitatsSearchUtility.findLegalTexts().iterator();
          while (it.hasNext()) {
            Chm62edtClassCodePersist element = (Chm62edtClassCodePersist) it.next();%>
        <option value="<%=element.getClassName()%>"><%=element.getClassName()%></option>
        <%}%>
      </select>
    </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="right" colspan="5">
      <label for="Reset" class="noshow">Reset values</label>
      <input title="Reset values" type="reset" value="<%=contentManagement.getContent("habitats_legal_14", false )%>" name="Reset" id="Reset" class="inputTextField" />
      <%=contentManagement.writeEditTag("habitats_legal_14")%>
      <label for="submit" class="noshow">Search</label>
      <input title="Search" type="submit" value="<%=contentManagement.getContent("habitats_legal_15", false )%>" id="submit" name="submit" class="inputTextField" />
      <%=contentManagement.writeEditTag("habitats_legal_15")%>
    </td>
  </tr>
</table>
</form>
</td>
</tr>
<%
  // Expand saved searches list for this jsp page
  if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT()) {
%>
<tr>
  <td>
    &nbsp;
    <script type="text/javascript" language="JavaScript">
    <!--
     // values of this constants from specific class Domain
     var source1='';
     var source2='';
     var database1='';
     var database2='';
     var database3='';
    //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
  </td>
</tr>
<tr>
  <td>
    <script language="JavaScript" src="script/habitats-legal-save-criteria.js" type="text/javascript"></script>
    <%=contentManagement.getContent("habitats_legal_16")%>:
    <a title="Save" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',true,'habitats-legal.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');">
      <img alt="Save" border="0" src="images/save.jpg" width="21" height="19" align="middle" /></a>
  </td>
</tr>
<%
  // Set Vector for URL string
  Vector show = new Vector();
  show.addElement("showLegalText");
  show.addElement("showCode");
  show.addElement("showScientificName");
  String pageName = "habitats-legal.jsp";
  String pageNameResult = "habitats-legal-result.jsp?" + Utilities.writeURLCriteriaSave(show);
  // Expand or not save criterias list
  String expandSearchCriteria = (request.getParameter("expandSearchCriteria") == null ? "no" : request.getParameter("expandSearchCriteria"));
%>
<tr>
  <td>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
  </td>
</tr>
<%}%>
</table>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-legal.jsp" />
</jsp:include>
    </div>
  </body>
</html>