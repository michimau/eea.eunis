<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show references' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.references.ReferencesSearchCriteria,
                 java.util.Vector" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <script language="JavaScript" src="script/species-books-save-criteria.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  <!--
      var errMessageForm = "<%=cm.cms("species_books_02")%>.";
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

  <title><%=application.getInitParameter("PAGE_TITLE")%><%=cm.cms("species_books_title")%></title>
</head>

<body style="background-color:#ffffff">
<div id="outline">
<div id="alignment">
<div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,pick_species_show_references_location"/>
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
            <h1>
              <%=cm.cmsText("species_books_01")%>
            </h1>
            <%=cm.cmsText("species_books_17")%>
            <br />
            <br />
            <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="layout">
              <tr>
                <td style="background-color:#EEEEEE">
                  <strong>
                    <%=cm.cmsText("species_books_03")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td style="background-color:#EEEEEE">
                  <input title="<%=cm.cms("species_books_04_Title")%>" alt="<%=cm.cms("species_books_04_Title")%>" id="checkbox1" name="checkbox1" type="checkbox" value="show" checked="checked" disabled="disabled" />
                  <label for="checkbox1"><%=cm.cmsText("species_books_04")%></label>
                  <%=cm.cmsTitle("species_books_04_Title")%>
                  <input title="<%=cm.cms("species_books_05_Title")%>" alt="<%=cm.cms("species_books_04_Title")%>" id="checkbox2" name="checkbox2" type="checkbox" value="show" checked="checked" disabled="disabled" />
                  <label for="checkbox2"><%=cm.cmsText("species_books_05")%></label>
                   <%=cm.cmsTitle("species_books_05_Title")%>
                  <input title="<%=cm.cms("species_books_06_Title")%>" alt="<%=cm.cms("species_books_04_Title")%>" id="checkbox3" name="checkbox3" type="checkbox" value="show" checked="checked" disabled="disabled" />
                  <label for="checkbox3"><%=cm.cmsText("species_books_06")%></label>
                  <%=cm.cmsTitle("species_books_06_Title")%>
                  <input title="<%=cm.cms("species_books_07_Title")%>" alt="<%=cm.cms("species_books_04_Title")%>" id="checkbox4" name="checkbox4" type="checkbox" value="show" checked="checked" disabled="disabled" />
                  <label for="checkbox4"><%=cm.cmsText("species_books_07")%></label>
                  <%=cm.cmsTitle("species_books_07_Title")%>
                  <input title="<%=cm.cms("species_books_08_Title")%>" alt="<%=cm.cms("species_books_04_Title")%>" id="checkbox5" name="checkbox5" type="checkbox" value="show" checked="checked" disabled="disabled" />
                  <label for="checkbox5"><%=cm.cmsText("species_books_08")%></label>
                  <%=cm.cmsTitle("species_books_08_Title")%>
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
            <img width="11" height="12" style="vertical-align : middle" alt="<%=cm.cms("species_books_18_Alt")%>" title="<%=cm.cms("species_books_18_Alt")%>" src="images/mini/field_mandatory.gif" />
            <%=cm.cmsAlt("species_books_18_Alt")%>
            &nbsp;
            <strong>
              <label for="scientificName"><%=cm.cmsText("species_books_09")%></label>
            </strong>
            <label for="select1" class="noshow"><%=cm.cms("species_books_19_Label")%></label>
            <select id="select1" title="<%=cm.cms("species_books_19_Title")%>" name="relationOp" class="inputTextField">
              <option value="<%=Utilities.OPERATOR_IS%>">
                  <%=cm.cms("species_books_10")%>
              </option>
              <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                  <%=cm.cms("species_books_11")%>
              </option>
              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
                  <%=cm.cms("species_books_12")%>
              </option>
            </select>
            <%=cm.cmsLabel("species_books_19_Label")%>
            <%=cm.cmsTitle("species_books_19_Title")%>
            <input id="scientificName" alt="<%=cm.cms("species_books_09_Alt")%>" title="<%=cm.cms("species_books_09_Alt")%>" size="32" name="scientificName" value="" class="inputTextField" />
            <%=cm.cmsAlt("species_books_09_Alt")%>
            <a title="<%=cm.cms("species_books_13_Title")%>" href="javascript:openHelper('species-books-choice.jsp?')"><img alt="<%=cm.cms("species_books_13")%>" style="vertical-align : middle" title="<%=cm.cms("species_books_13")%>" src="images/helper/helper.gif" border="0" /></a>
            <%=cm.cmsTitle("species_books_13_Title")%>
            <%=cm.cmsAlt("species_books_13")%>
          </td>
        </tr>
        <tr>
          <td style="text-align:right" colspan="2">
            <input id="Reset" type="reset" value="<%=cm.cms("species_books_14")%>" name="Reset" class="inputTextField" alt="Reset" title="<%=cm.cms("species_books_14_Title")%>" />
            <%=cm.cmsTitle("species_books_14_Title")%>
            <%=cm.cmsInput("species_books_14")%>
            <input id="submit" type="submit" value="<%=cm.cms("species_books_15")%>" name="submit2" class="inputTextField" alt="Search" title="<%=cm.cms("species_books_15_Title")%>" />
            <%=cm.cmsTitle("species_books_15_Title")%>
            <%=cm.cmsInput("species_books_15")%>
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
    <%=cm.cmsText("species_books_16")%>:
    <a title="<%=cm.cms("species_books_20_Title")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-books.jsp','1','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');">
      <img border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" alt="<%=cm.cms("species_books_20_Alt")%>" />
    </a>
    <%=cm.cmsTitle("species_books_20_Title")%>
    <%=cm.cmsAlt("species_books_20_Alt")%>
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

<%=cm.br()%>
<%=cm.cmsMsg("species_books_02")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books_10")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books_11")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_books_12")%>
<%=cm.br()%>

<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="species-books.jsp"/>
</jsp:include>
</div>
</div>
</div>
</body>
</html>