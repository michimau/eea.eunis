<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show references' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.references.ReferencesSearchCriteria,
                 java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <script language="JavaScript" src="script/species-books-save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
      var errMessageForm = "<%=contentManagement.getContent("species_books_02", false)%>.";
      function openHelper(URL)
      {
        document.eunis.scientificName.value = trim(document.eunis.scientificName.value);
        scientificName = document.eunis.scientificName.value;
        if(scientificName=="") {
          alert(errMessageForm);
        } else {
            relationOp=escape(document.eunis.relationOp.value);
            URL2= URL + '&scientificName=' + scientificName+'&relationOp='+relationOp;
            eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
        }
      }

      function validateForm()
      {
        document.eunis.scientificName.value = trim(document.eunis.scientificName.value);
        scientificName = document.eunis.scientificName.value;
        if (scientificName == "")
        {
          alert(errMessageForm);
          return false;
        }
        return true;
      }
    //-->
  </script>
<%
  // Save search criteria
  if(SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
  {
%>
<script type="text/javascript" language="JavaScript">
<!--
 // values of source and database constants from specific class Domain(only in habitat searches, so here are all '')
 var source1='';
 var source2='';
 var database1='';
 var database2='';
 var database3='';
//-->
</script>
<%
  }
%>

  <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("species_books_title", false)%></title>
</head>

<body style="background-color:#ffffff">
<div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Pick species show references"/>
  <jsp:param name="helpLink" value="species-help.jsp"/>
</jsp:include>
<table width="100%" border="0" summary="layout">
<tr>
  <td>
    <form name="eunis" method="get" onsubmit="return(validateForm());" action="species-books-result.jsp">
      <input type="hidden" name="typeForm" value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC%>" />
      <table width="100%" border="0" style="text-align : left" summary="layout">
        <tr>
          <td colspan="2">
            <h5>
              <%=contentManagement.getContent("species_books_01")%>
            </h5>
            <%=contentManagement.getContent("species_books_17")%>
            <br />
            <br />
            <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="layout">
              <tr>
                <td style="background-color:#EEEEEE">
                  <strong>
                    <%=contentManagement.getContent("species_books_03")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td style="background-color:#EEEEEE">
                  <input title="Check author" alt="Check author" id="checkbox1" name="checkbox1" type="checkbox" value="show" checked="checked" disabled="disabled" />
                  <label for="checkbox1"><%=contentManagement.getContent("species_books_04")%></label>
                  <input title="Check date" alt="Check date" id="checkbox2" name="checkbox2" type="checkbox" value="show" checked="checked" disabled="disabled" />
                  <label for="checkbox2"><%=contentManagement.getContent("species_books_05")%></label>
                  <input title="Check title" alt="Check title" id="checkbox3" name="checkbox3" type="checkbox" value="show" checked="checked" disabled="disabled" />
                  <label for="checkbox3"><%=contentManagement.getContent("species_books_06")%></label>
                  <input title="Check editor" alt="Check editor" id="checkbox4" name="checkbox4" type="checkbox" value="show" checked="checked" disabled="disabled" />
                  <label for="checkbox4"><%=contentManagement.getContent("species_books_07")%></label>
                  <input title="Check publisher" alt="Check publisher" id="checkbox5" name="checkbox5" type="checkbox" value="show" checked="checked" disabled="disabled" />
                  <label for="checkbox5"><%=contentManagement.getContent("species_books_08")%></label>
                </td>
              </tr>
              <tr>
                <td>
                  <br />
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <img width="11" height="12" style="vertical-align : middle" alt="This field is mandatory" title="This field is mandatory" src="images/mini/field_mandatory.gif" />
            &nbsp;
            <strong>
              <label for="scientificName"><%=contentManagement.getContent("species_books_09")%></label>
            </strong>
            <label for="select1" class="noshow">Relation type</label>  
            <select id="select1" title="Relation type" name="relationOp" class="inputTextField">
              <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("species_books_10", false)%></option>
              <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("species_books_11", false)%></option>
              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("species_books_12", false)%></option>
            </select>
            <input id="scientificName" alt="Species scientific name (in Latin)" title="Species scientific name (in Latin)" size="32" name="scientificName" value="" class="inputTextField" />
            <a title="Open species list. Link will open a new window." href="javascript:openHelper('species-books-choice.jsp?')"><img alt="<%=contentManagement.getContent("species_books_13", false)%>" style="vertical-align : middle" title="<%=contentManagement.getContent("species_books_13", false)%>" src="images/helper/helper.gif" border="0" /></a>
            <%=contentManagement.writeEditTag("species_books_13",false)%>
          </td>
        </tr>
        <tr>
          <td style="text-align:right" colspan="2">
            <label for="Reset" class="noshow"><%=contentManagement.getContent("species_books_14", false)%></label>
            <input id="Reset" type="reset" value="<%=contentManagement.getContent("species_books_14", false)%>" name="Reset" class="inputTextField" alt="Reset" title="Reset" />
            <%=contentManagement.writeEditTag("species_books_14")%>
            <label for="submit" class="noshow"><%=contentManagement.getContent("species_books_15", false)%></label>
            <input id="submit" type="submit" value="<%=contentManagement.getContent("species_books_15", false)%>" name="submit2" class="inputTextField" alt="Search" title="Search" />
            <%=contentManagement.writeEditTag("species_books_15")%>
          </td>
        </tr>
      </table>
    </form>
  </td>
</tr>
<%
  // Save search criteria
  if(SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT()) {
%>
<tr><td>&nbsp;</td></tr>
<tr style="background-color:#EEEEEE">
  <td>
    <%=contentManagement.getContent("species_books_16")%>:
    <a title="Show save criteria list" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-books.jsp','1','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');">
      <img border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" alt="Save criteria" />
    </a>
  </td>
</tr>
<%
  // Set Vector for URL string
  Vector show = new Vector();
  String pageName = "species-books.jsp";
  String pageNameResult = "species-books-result.jsp?" + Utilities.writeURLCriteriaSave(show);
  // Expand or not save criterias list
  String expandSearchCriteria = (request.getParameter("expandSearchCriteria") == null ? "no" : request.getParameter("expandSearchCriteria"));
%>
<tr><td>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
</td></tr>
<%
  }
%>
</table>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="species-books.jsp"/>
</jsp:include>
</div>
</body>
</html>