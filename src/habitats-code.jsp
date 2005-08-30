<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats code' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.jrfTables.Chm62edtClassCodePersist,
                ro.finsiel.eunis.jrfTables.habitats.code.CodeDomain,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.habitats.HabitatsSearchUtility,
                java.util.Iterator,
                java.util.Vector"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" src="script/habitats-code.js" type="text/javascript"></script>
    <script language="JavaScript" src="script/save-criteria.js" type="text/javascript"></script>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=contentManagement.getContent("habitats_code_title", false)%>
</title>
<script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript">
<!--
// Open popup for first form
function openHelper(URL)
{
document.eunis.searchString.value = trim(document.eunis.searchString.value);
classificationCode = document.eunis.classificationCode.value;
searchString = escape(document.eunis.searchString.value);
relationOp = document.eunis.relationOp.value;
database = <%=CodeDomain.SEARCH_EUNIS%>;
        if (document.eunis.database[0].checked)
        {
          database = <%=CodeDomain.SEARCH_EUNIS%>;
        }
        if (document.eunis.database[1].checked)
        {
          database = <%=CodeDomain.SEARCH_ANNEX%>;
        }
        if (document.eunis.database[2].checked)
        {
          database = <%=CodeDomain.SEARCH_BOTH%>;
        }
        if (null == database)
        {
          alert( '<%=contentManagement.getContent("habitats_code_02", false )%>' );
        }
        else
        {
          URL2 = URL + '?classificationCode=' + classificationCode;
          URL2 += '&relationOp=' + relationOp;
          URL2 += '&searchString=' + searchString;
          URL2 += '&database=' + database;
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=0');");
        }
      }
    //-->
</script>
</head>

<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Code/Classification" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
</jsp:include>
<form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="habitats-code-result.jsp">
<input type="hidden" value="true" name="clearsubs" />
<input type="hidden" name="sortCriteria" value="code" />
<input type="hidden" name="sortAscendency" value="descending" />
<input type="hidden" name="showScientificName" value="true" />
<input type="hidden" name="showCode" value="true" />
<table width="100%" border="0" cellspacing="0">
<tr>
<td>
<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <h5>
        <%=contentManagement.getContent("habitats_code_01")%>
      </h5>
      <%=contentManagement.getContent("habitats_code_20")%>
      <br />
      <br />
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr bgcolor="#EEEEEE">
          <td>
            <strong>
              <%=contentManagement.getContent("habitats_code_03")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td style="white-space:nowrap">
            <input type="checkbox" id="showLevel" name="showLevel" value="true" checked="checked" />
            <label for="showLevel"><%=contentManagement.getContent("habitats_code_04")%></label>
            &nbsp;
            <input type="checkbox" id="showCode" name="showCode" value="true" checked="checked" disabled="disabled" />
            <label for="showCode"><%=contentManagement.getContent("habitats_code_05")%></label>
            &nbsp;
            <input type="checkbox" id="showScientificName" name="showScientificName" value="true" checked="checked" disabled="disabled" />
            <label for="showScientificName"><%=contentManagement.getContent("habitats_code_07")%></label>
            &nbsp;
            <input type="checkbox" id="showOtherCodes" name="showOtherCodes" value="true" checked="checked" />
            <label for="showOtherCodes"><%=contentManagement.getContent("habitats_code_06")%></label>
            &nbsp;
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>
      <br />
    </td>
  </tr>
  <tr>
    <td>
      <img alt="Mandatory field" src="images/mini/field_mandatory.gif" />&nbsp;
      <label for="classificationCode" class="noshow">Classification code</label>
      <select title="Classification code" name="classificationCode" id="classificationCode" class="inputTextField">
        <jsp:useBean id="HabitatClassCodeDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtHabitatClassCodeDomain" scope="page" />
        <%
          // List of classifications
          Iterator it = HabitatsSearchUtility.getDatabaseClassifications().iterator();
          while (it.hasNext()) {
            Chm62edtClassCodePersist element = (Chm62edtClassCodePersist) it.next();
        %>
        <option value="<%=element.getIdClassCode()%>"
          <%=(element.getCurrentClassification().intValue() == 1 ? "selected=\"selected\"" : "")%>>
          <%=(element.getCurrentClassification().intValue() == 1 ? Utilities.treatURLSpecialCharacters(element.getClassName()) + " (Current classification)" : Utilities.treatURLSpecialCharacters(element.getClassName()))%>
          <%
            if (HabitatsSearchUtility.countHabitatsInClassification(element.getIdClassCode()) <= 0) {
          %> (empty)
          <%
            }
          %>
        </option>
        <%
          }
        %>
      </select>
      <label for="searchString">
      <strong>
        <%=contentManagement.getContent("habitats_code_09")%>
      </strong>
      </label>  
      <label for="relationOp" class="noshow">Operator</label>
      <select title="Operator" name="relationOp" id="relationOp" class="inputTextField">
        <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("habitats_code_10", false)%></option>
        <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("habitats_code_11", false)%></option>
        <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("habitats_code_12", false)%></option>
      </select>
      <label for="searchString" class="noshow">Search value</label>
      <input title="Search value" size="20" name="searchString" id="searchString" value="" class="inputTextField" />
      <a title="List of values" href="javascript:openHelper('habitats-code-choice.jsp')"><img alt="List of values" border="0" src="images/helper/helper.gif" width="11" height="18" align="middle" /></a>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td align="left" bgcolor="#EEEEEE">
      <%=contentManagement.getContent("habitats_code_13")%>: &nbsp;
      <input type="radio" id="database1" name="database" value="<%=CodeDomain.SEARCH_EUNIS%>" checked="checked" />
      <label for="database1"><%=contentManagement.getContent("habitats_code_14")%></label>
      &nbsp;&nbsp;
      <input type="radio" id="database2" name="database" value="<%=CodeDomain.SEARCH_ANNEX%>" />
      <label for="database2"><%=contentManagement.getContent("habitats_code_15")%></label>
      &nbsp;&nbsp;
      <input type="radio" id="database3" name="database" value="<%=CodeDomain.SEARCH_BOTH%>" />
      <label for="database3"><%=contentManagement.getContent("habitats_code_16")%></label>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td align="right">
      <label for="Reset" class="noshow">Reset values</label>
      <input title="Reset values" alt="Reset values" type="reset" value="<%=contentManagement.getContent("habitats_code_17", false )%>" name="Reset" id="Reset" class="inputTextField" />
      <%=contentManagement.writeEditTag("habitats_code_17")%>
      <label for="submit2" class="noshow">Search</label>
      <input title="Search" alt="Search" type="submit" value="<%=contentManagement.getContent("habitats_code_18", false )%>" name="submit2" id="submit2" class="inputTextField" />
      <%=contentManagement.writeEditTag("habitats_code_18")%>
    </td>
  </tr>
</table>
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
    var database1='<%=CodeDomain.SEARCH_EUNIS%>';
    var database2='<%=CodeDomain.SEARCH_ANNEX%>';
    var database3='<%=CodeDomain.SEARCH_BOTH%>';
    //-->
    </script>
    <noscript>Your browser does not support JavaScript!</noscript>
    <script language="JavaScript" src="script/habitats-code-save-criteria.js" type="text/javascript"></script>
    <%=contentManagement.getContent("habitats_code_19")%>:
    <a title="Save criteria" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'habitats-code.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');">
      <img border="0" alt="Save criteria" src="images/save.jpg" width="21" height="19" align="middle" /></a>
<%
  // Set Vector for URL string
  Vector show = new Vector();
  show.addElement("showLevel");
  show.addElement("showCode");
  show.addElement("showScientificName");
  show.addElement("showVernacularName");
  String pageName = "habitats-code.jsp";
  String pageNameResult = "habitats-code-result.jsp?" + Utilities.writeURLCriteriaSave(show);
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
      <jsp:param name="page_name" value="habitats-code.jsp" />
    </jsp:include>
  </div>
</body>
</html>