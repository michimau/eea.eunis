<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick references, show habitats' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.habitatsByReferences.RefDomain,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.references.ReferencesSearchCriteria,
                 java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-references.js" type="text/javascript"></script>
  <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=cm.cms("habitats_references_title")%>
</title>
<script type="text/javascript" language="JavaScript">
<!--
var database = new Array (3);
var source = new Array (2);

// values of this constants from specific class Domain
database[0] = <%=RefDomain.SEARCH_EUNIS%>
database[1] = <%=RefDomain.SEARCH_ANNEX_I%>
database[2] = <%=RefDomain.SEARCH_BOTH%>

source[0] = <%=RefDomain.SOURCE%>
source[1] = <%=RefDomain.OTHER_INFO%>
//-->
</script>
<%
  // Request parameters
  String author = Utilities.formatString(request.getParameter("author"), "");
  int relationOpAuthor = Utilities.checkedStringToInt(request.getParameter("relationOpAuthor"), Utilities.OPERATOR_CONTAINS.intValue());
  String date = Utilities.formatString(request.getParameter("date"), "");
  String date1 = Utilities.formatString(request.getParameter("date1"), "");
  String title = Utilities.formatString(request.getParameter("title"), "");
  int relationOpTitle = Utilities.checkedStringToInt(request.getParameter("relationOpTitle"), Utilities.OPERATOR_CONTAINS.intValue());
  String editor = Utilities.formatString(request.getParameter("editor"), "");
  int relationOpEditor = Utilities.checkedStringToInt(request.getParameter("relationOpEditor"), Utilities.OPERATOR_CONTAINS.intValue());
  String publisher = Utilities.formatString(request.getParameter("publisher"), "");
  int relationOpPublisher = Utilities.checkedStringToInt(request.getParameter("relationOpPublisher"), Utilities.OPERATOR_CONTAINS.intValue());
%>
</head>

<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home#index.jsp,habitat_types#habitats.jsp,pick_habitat_type_show_references" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
</jsp:include>
<table summary="layout" width="100%" border="0">
<tr>
<td>
<form name="eunis" method="get" action="habitats-references-result.jsp" onsubmit="javascript: return validateForm();">
<input type="hidden" name="typeForm" value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC%>" />
<table summary="layout" width="100%" border="0">
<tr>
  <td colspan="2">
    <h1>
      <%=cm.cmsText("pick_references_show_habitat_types")%>
    </h1>
    <%=cm.cmsText("habitats_references_29")%>
    <br />
    <br />
    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td bgcolor="#EEEEEE">
          <strong>
            <%=cm.cmsText("search_will_provide")%>
          </strong>
        </td>
      </tr>
      <tr>
        <td bgcolor="#EEEEEE" valign="middle">&nbsp;
          <input type="checkbox" name="showLevel" id="showLevel" value="true" checked="checked" />
          <label for="showLevel"><%=cm.cmsText("generic_index_07")%></label>
          &nbsp;
          <input type="checkbox" name="showCode" id="showCode" value="true" checked="checked" />
          <label for="showCode"><%=cm.cmsText("code_column")%></label>
          &nbsp;
          <input type="checkbox" name="showScientificName" id="showScientificName" value="true" checked="checked" disabled="disabled" />
          <label for="showScientificName"><%=cm.cmsText("scientific_name")%></label>
          &nbsp;
          <input type="checkbox" name="showVernacularName" id="showVernacularName" value="true" />
          <label for="showVernacularName"><%=cm.cmsText("english_name")%></label>
          &nbsp;
        </td>
      </tr>
    </table>
  </td>
</tr>
<tr>
<td>
<table width="100%" border="0" summary="layout">
<tr>
  <td colspan="2">
    <img alt="<%=cm.cms("included_field")%>" src="images/mini/field_included.gif" /><%=cm.cmsTitle("included_field")%>
    &nbsp;
    <label for="author"><strong><%=cm.cmsText("author")%></strong></label>
  </td>
  <td width="17%">
    <label for="relationOpAuthor" class="noshow"><%=cm.cms("operator")%></label>
    <select title="<%=cm.cms("operator")%>" name="relationOpAuthor" id="relationOpAuthor" class="inputTextField">
      <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpAuthor == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("is")%></option>
      <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpAuthor == Utilities.OPERATOR_CONTAINS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("contains")%></option>
      <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpAuthor == Utilities.OPERATOR_STARTS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("starts_with")%></option>
    </select>
    <%=cm.cmsLabel("operator")%>
    <%=cm.cmsInput("is")%>
    <%=cm.cmsInput("contains")%>
    <%=cm.cmsInput("starts_with")%>
  </td>
  <td width="69%">
    <input title="<%=cm.cms("author")%>" size="32" name="author" id="author" value="<%=author%>" class="inputTextField" />
    <a title="<%=cm.cms("list_of_authors")%>" href="javascript:openHelper('habitats-references-choice.jsp','author',0,database,source)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("list_of_authors")%>" src="images/helper/helper.gif" width="11" border="0" /></a><%=cm.cmsTitle("list_of_authors")%>
  </td>
</tr>
<tr>
  <td colspan="2">
    <img alt="<%=cm.cms("included_field")%>" src="images/mini/field_included.gif" /><%=cm.cmsTitle("included_field")%>
    &nbsp;
  <%
  // If relOpDate is between
  if (request.getParameter("between") != null && request.getParameter("between").equalsIgnoreCase("yes")) {
  %>
    <label for="date_between"><strong><%=cm.cmsText("year")%></strong></label>
  <%
  } else {
  %>
    <label for="date_normal"><strong><%=cm.cmsText("year")%></strong></label>
  <%
  }
  %>
  </td>
  <td>
    <label for="relOpDate" class="noshow"><%=cm.cms("operator")%></label>
    <select title="<%=cm.cms("operator")%>" name="relOpDate" id="relOpDate" onchange="MM_jumpMenu('parent',this,0)" class="inputTextField">
      <option value="habitats-references.jsp?between=no" <%=(request.getParameter("between") == null ? "selected=\"selected\"" : (request.getParameter("between").equalsIgnoreCase("yes") ? "" : "selected=\"selected\""))%>><%=cm.cms("is")%></option>
      <option value="habitats-references.jsp?between=yes"
       <%if (request.getParameter("between") != null && request.getParameter("between").equalsIgnoreCase("yes")) { %>
         selected="selected"
       <% } %>
       ><%=cm.cms("between")%></option>
    </select>
    <%=cm.cmsLabel("operator")%>
    <%=cm.cmsInput("is")%>
    <%=cm.cmsInput("between")%>
  </td>
  <%
    // If relOpDate is between
    if (request.getParameter("between") != null && request.getParameter("between").equalsIgnoreCase("yes")) {
  %>
  <td>
    <input title="<%=cm.cms("date")%>" size="5" name="date" id="date_normal" value="<%=date%>" class="inputTextField" /><%=cm.cmsTitle("date")%>
    &nbsp;
    <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-references-choice.jsp','date',1,database,source)"><img alt="<%=cm.cms("list_of_values")%>" height="18" style="vertical-align:middle" src="images/helper/helper.gif" width="11" border="0" /></a><%=cm.cmsTitle("list_of_values")%>
    <%=cm.cmsText("and")%>
    <input title="<%=cm.cms("date")%>" size="5" name="date1" id="date1" value="<%=date1%>" class="inputTextField" /><%=cm.cmsTitle("date")%>
    &nbsp;
    <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-references-choice.jsp','date',2,database,source)"><img alt="<%=cm.cms("list_of_values")%>" height="18" style="vertical-align:middle" src="images/helper/helper.gif" width="11" border="0" /></a><%=cm.cmsTitle("list_of_values")%>
    &nbsp;&nbsp;&nbsp;&nbsp;
  <%
  } else {
  %>
  <td>
    <label for="date_between" class="noshow"><strong><%=cm.cms("year")%></strong></label>
    <input title="<%=cm.cms("year")%>" size="5" name="date" id="date_between" value="<%=date%>" class="inputTextField" />
    <%=cm.cmsLabel("year")%>
    <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-references-choice.jsp','date',1,database,source)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("list_of_values")%>" src="images/helper/helper.gif" width="11" border="0" /></a><%=cm.cmsTitle("list_of_values")%>
    &nbsp;&nbsp;&nbsp;&nbsp;
  <%
    }
    // Set value for relationOpDate hidden field
    Integer valDate = Utilities.OPERATOR_IS;
    if (request.getParameter("between") != null && request.getParameter("between").equalsIgnoreCase("yes")) valDate = Utilities.OPERATOR_BETWEEN;
  %>
  <input type="hidden" name="relationOpDate" value="<%=valDate%>" />
  </td>
</tr>
<tr>
  <td colspan="2">
    <img alt="<%=cm.cms("included_field")%>" src="images/mini/field_included.gif" /><%=cm.cmsTitle("included_field")%>
    &nbsp;
    <label for="title"><strong><%=cm.cmsText("title")%></strong>
    </label>
  </td>
  <td>
    <label for="relationOpTitle" class="noshow"><%=cm.cms("operator")%></label>
    <select title="<%=cm.cms("operator")%>" name="relationOpTitle" id="relationOpTitle" class="inputTextField">
      <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpTitle == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("is")%></option>
      <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpTitle == Utilities.OPERATOR_CONTAINS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("contains")%></option>
      <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpTitle == Utilities.OPERATOR_STARTS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("starts_with")%></option>
    </select>
    <%=cm.cmsLabel("operator")%>
    <%=cm.cmsInput("is")%>
    <%=cm.cmsInput("contains")%>
    <%=cm.cmsInput("starts_with")%>
  </td>
  <td>
    <input title="<%=cm.cms("title")%>" size="32" name="title" id="title" value="<%=title%>" class="inputTextField" />
    <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-references-choice.jsp','title',0,database,source)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("list_of_values")%>" src="images/helper/helper.gif" width="11" border="0" /></a><%=cm.cmsTitle("list_of_values")%>
    &nbsp;&nbsp;&nbsp;&nbsp;
  </td>
</tr>
<tr>
  <td colspan="2">
    <img alt="<%=cm.cms("included_field")%>" src="images/mini/field_included.gif" /><%=cm.cmsTitle("included_field")%>
    &nbsp;
    <label for="editor"><strong><%=cm.cmsText("editor")%></strong></label>
  </td>
  <td>
    <label for="relationOpEditor" class="noshow"><%=cm.cms("operator")%></label>
    <select title="<%=cm.cms("operator")%>" name="relationOpEditor" id="relationOpEditor" class="inputTextField">
      <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpEditor == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("is")%></option>
      <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpEditor == Utilities.OPERATOR_CONTAINS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("contains")%></option>
      <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpEditor == Utilities.OPERATOR_STARTS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("starts_with")%></option>
    </select>
    <%=cm.cmsLabel("operator")%>
    <%=cm.cmsInput("is")%>
    <%=cm.cmsInput("contains")%>
    <%=cm.cmsInput("starts_with")%>
  </td>
  <td>
    <input title="<%=cm.cms("editor")%>" size="32" name="editor" id="editor" value="<%=editor%>" class="inputTextField" />
    <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-references-choice.jsp','editor',0,database,source)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("list_of_values")%>" src="images/helper/helper.gif" width="11" border="0" /><%=cm.cmsTitle("list_of_values")%></a>
  </td>
</tr>
<tr>
  <td colspan="2">
    <img alt="<%=cm.cms("included_field")%>" src="images/mini/field_included.gif" /><%=cm.cmsTitle("included_field")%>
    &nbsp;
    <label for="publisher"><strong><%=cm.cmsText("publisher")%></strong></label>
  </td>
  <td>
    <label for="relationOpPublisher" class="noshow"><%=cm.cmsLabel("operator")%></label>
    <select title="<%=cm.cms("operator")%>" name="relationOpPublisher" id="relationOpPublisher" class="inputTextField">
      <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpPublisher == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("is")%></option>
      <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpPublisher == Utilities.OPERATOR_CONTAINS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("contains")%></option>
      <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpPublisher == Utilities.OPERATOR_STARTS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cms("starts_with")%></option>
    </select>
    <%=cm.cmsLabel("operator")%>
    <%=cm.cmsInput("is")%>
    <%=cm.cmsInput("contains")%>
    <%=cm.cmsInput("starts_with")%>
  </td>
  <td>
    <input title="<%=cm.cms("publisher")%>" size="32" name="publisher" id="publisher" value="<%=publisher%>" class="inputTextField" />
    <a title="<%=cm.cms("list_of_values")%>" href="javascript:openHelper('habitats-references-choice.jsp','publisher',0,database,source)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("list_of_values")%>" src="images/helper/helper.gif" width="11" border="0" /></a><%=cm.cmsTitle("list_of_values")%>
  </td>
</tr>
</table>
</td>
</tr>
<tr>
  <td bgcolor="#EEEEEE" colspan="3">
    <%=cm.cmsText("search_Database")%>:&nbsp;
    <input type="radio" id="database1" name="database" value="<%=RefDomain.SEARCH_EUNIS%>" checked="checked"
           title="<%=cm.cms("search_eunis")%>" />
    <%=cm.cmsTitle("search_eunis")%>
    <label for="database1"><%=cm.cmsText("eunis_habitat_types")%></label>
    &nbsp;&nbsp;
    <input type="radio" id="database2" name="database" value="<%=RefDomain.SEARCH_ANNEX_I%>"
           title="<%=cm.cms("search_annex1")%>" />
    <%=cm.cmsTitle("search_annex1")%>
    <label for="database2"><%=cm.cmsText("habitat_directive_annex")%></label>
    &nbsp;&nbsp;
    <input type="radio" id="database3" name="database" value="<%=RefDomain.SEARCH_BOTH%>"
           title="<%=cm.cms("search_both")%>" />
    <%=cm.cmsTitle("search_both")%>
    <label for="database3"><%=cm.cmsText("both")%></label>
  </td>
</tr>
<tr>
  <td bgcolor="#EEEEEE" colspan="3">
    <%=cm.cmsText("habitats_references_23")%>:&nbsp;
    <input id="source1" title="Search source" alt="Search source" type="radio" name="source" value="<%=RefDomain.SOURCE%>" checked="checked" />
    <label for="source1"><%=cm.cmsText("source")%></label>
    &nbsp;&nbsp;
    <input id="source2" title="Search other information" alt="Search other information" type="radio" name="source" value="<%=RefDomain.OTHER_INFO%>" />
    <label for="source2"><%=cm.cmsText("other_information")%></label>
  </td>
</tr>
<tr>
  <td>
    <br />
  </td>
</tr>
<tr>
  <td align="right">
    <input title="<%=cm.cms("reset")%>" alt="<%=cm.cms("reset")%>" type="reset" value="<%=cm.cms("reset")%>" name="Reset" id="Reset" class="inputTextField" />
    <%=cm.cmsTitle("reset")%>
    <%=cm.cmsInput("reset")%>
    <input title="<%=cm.cms("search")%>" alt="<%=cm.cms("search")%>" type="submit" id="submit2" value="<%=cm.cms("search")%>" name="submit2" class="inputTextField" />
    <%=cm.cmsTitle("search")%>
    <%=cm.cmsInput("search")%>
  </td>
</tr>
</table>
</form>
</td>
</tr>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT()) {

%>
<tr>
  <td>
    &nbsp;
    <script type="text/javascript" language="JavaScript">
    <!--
    // values of this constants from specific class Domain
    var source1='<%=RefDomain.SOURCE%>';
    var source2='<%=RefDomain.OTHER_INFO%>';
    var database1='<%=RefDomain.SEARCH_EUNIS%>';
    var database2='<%=RefDomain.SEARCH_ANNEX_I%>';
    var database3='<%=RefDomain.SEARCH_BOTH%>';
    //-->
    </script>
  </td>
</tr>
<tr>
  <td>
    <script language="JavaScript" src="script/habitats-references-save-criteria.js" type="text/javascript"></script>
    <%=cm.cmsText("save_your_criteria")%>:
    <a title="<%=cm.cms("save_criteria")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-references.jsp','7','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_criteria")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
    <%=cm.cmsTitle("save_criteria")%>
  </td>
</tr>
<%
  // Set Vector for URL string
  Vector show = new Vector();
  show.addElement("showLevel");
  show.addElement("showCode");
  show.addElement("showScientificName");
  show.addElement("showVernacularName");
  String pageName = "habitats-references.jsp";
  String pageNameResult = "habitats-references-result.jsp?" + Utilities.writeURLCriteriaSave(show);
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
<%
  }
%>
</table>
<%=cm.br()%>
<%=cm.cmsMsg("habitats_references_title")%>
<%=cm.br()%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-references.jsp" />
</jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>