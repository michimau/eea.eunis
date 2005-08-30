<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick references, show species' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.search.species.references.ReferencesSearchCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-references.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_references_title", false )%>
    </title>
<%
  // Request parameters
  String author = Utilities.formatString(request.getParameter("author"), "");
  int relationOpAuthor = Utilities.checkedStringToInt(request.getParameter("relationOpAuthor"), Utilities.OPERATOR_STARTS.intValue());
  String date = Utilities.formatString(request.getParameter("date"), "");
  String date1 = Utilities.formatString(request.getParameter("date1"), "");
  String title = Utilities.formatString(request.getParameter("title"), "");
  int relationOpTitle = Utilities.checkedStringToInt(request.getParameter("relationOpTitle"), Utilities.OPERATOR_STARTS.intValue());
  String editor = Utilities.formatString(request.getParameter("editor"), "");
  int relationOpEditor = Utilities.checkedStringToInt(request.getParameter("relationOpEditor"), Utilities.OPERATOR_STARTS.intValue());
  String publisher = Utilities.formatString(request.getParameter("publisher"), "");
  int relationOpPublisher = Utilities.checkedStringToInt(request.getParameter("relationOpPublisher"), Utilities.OPERATOR_STARTS.intValue());

%>
  </head>
  <body style="background-color:#ffffff">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Pick references show species" />
      <jsp:param name="helpLink" value="species-help.jsp" />
    </jsp:include>
    <h5>
        <%=contentManagement.getContent("species_references_01")%>
    </h5>
    <form name="eunis" method="get" action="species-references-result.jsp" onsubmit="return validateForm();">
      <input type="hidden" name="typeForm" value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC%>" />
      <table summary="layout" width="100%" border="0">
        <tr>
          <td colspan="2">
            <%=contentManagement.getContent("species_references_22")%>
            <br />
            <br />
            <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="background-color:#EEEEEE">
                  <strong>
                    <%=contentManagement.getContent("species_references_02")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td style="background-color:#EEEEEE;text-align:left">
                  <input title="Group" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" /><label for="checkbox1"><%=contentManagement.getContent("species_references_03")%></label>
                  <input title="Order" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" /><label for="checkbox2"><%=contentManagement.getContent("species_references_04")%></label>
                  <input title="Family" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" /><label for="checkbox3"><%=contentManagement.getContent("species_references_05")%></label>
                  <input title="Scientific name" id="checkbox4" type="checkbox" name="showScientificName" value="true" checked="checked" disabled="disabled" /><label for="checkbox4"><%=contentManagement.getContent("species_references_06")%></label>
                  <input title="Vernacular name" id="checkbox5" type="checkbox" name="showVernacularName" value="true" /><label for="checkbox5"><%=contentManagement.getContent("species_references_07")%></label>
                </td>
              </tr>
            </table>
            <br />
          </td>
        </tr>
        <tr>
          <td>
            <table summary="layout" width="100%" border="0">
              <tr>
                <td colspan="2">
                  <img alt="Field included" src="images/mini/field_included.gif" />
                  &nbsp;
                  <strong>
                    <label for="author"><%=contentManagement.getContent("species_references_09")%></label>
                  </strong>
                </td>
                <td width="17%">
                  <label for="select1" class="noshow">Operator</label>
                  <select id="select1" title="Operator" name="relationOpAuthor" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpAuthor == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_10", false)%></option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpAuthor == Utilities.OPERATOR_CONTAINS.intValue()) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_11", false)%></option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpAuthor == Utilities.OPERATOR_STARTS.intValue()) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_12", false)%></option>
                  </select>
                </td>
                <td width="69%">
                  <input id="author" title="Author" alt="Author" size="32" name="author" value="<%=author%>" class="inputTextField" />
                  <a title="List of values. Link will open a new window." href="javascript:openHelper('species-references-choice.jsp','author',0)"><img height="18" style="vertical-align:middle" alt="List of authors starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <img alt="Field included" src="images/mini/field_included.gif" />
                  &nbsp;
                  <strong>
                    <label for="date1"><%=contentManagement.getContent("species_references_13")%></label>
                  </strong>
                </td>
                <td>
                  <label for="select2" class="noshow">Operator</label>
                  <select id="select2" title="Operator" name="relOpDate" onchange="MM_jumpMenu('parent',this,0)" class="inputTextField">
                    <option value="species-references.jsp?between=no" <%=(request.getParameter("between")==null?"selected=\"selected\"":(request.getParameter("between").equalsIgnoreCase("yes")?"":"selected=\"selected\""))%>><%=contentManagement.getContent("species_references_10", false)%></option>
                    <option value="species-references.jsp?between=yes" <%if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes")){%> selected="selected"<%}%>><%=contentManagement.getContent("species_references_15", false)%></option>
                  </select>
                </td>
                <%
                  // If relOpDate is between
                  if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes"))
                  {
                %>
                  <td>
                    <input id="date1" title="Begin date" alt="Begin Date" size="5" name="date" value="<%=date%>" class="inputTextField" />
                    &nbsp;
                    <a title="list of values. Link will open a new window." href="javascript:openHelper('species-references-choice.jsp','date',1)"><img height="18" style="vertical-align:middle" alt="Publication's year" src="images/helper/helper.gif" width="11" border="0" /></a>
                    <%=contentManagement.getContent("species_references_16")%>
                    <label for="date2" class="noshow">Last date</label>
                    <input id="date2" title="Last date" alt="Last date" size="5" name="date1" value="<%=date1%>" class="inputTextField" />
                    &nbsp;
                    <a title="List of values. Link will open a new window." href="javascript:openHelper('species-references-choice.jsp','date',2)"><img height="18" style="vertical-align:middle" alt="Publication's year" src="images/helper/helper.gif" width="11" border="0" /></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                  </td>
              <%
                  }
                  else
                  {
              %>
                    <td>
                      <label for="date3" class="noshow">Date</label>
                      <input id="date3" title="Date" alt="Date" size="5" name="date" value="<%=date%>" class="inputTextField" />
                      <a title="List of values. Link will open a new window." href="javascript:openHelper('species-references-choice.jsp','date',1)"><img height="18" style="vertical-align:middle" alt="Publication's year" src="images/helper/helper.gif" width="11" border="0" /></a>
                      &nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
              <%
                  }
                  // Set value for relationOpDate hidden field
                  Integer valDate=Utilities.OPERATOR_IS;
                  if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes")) valDate=Utilities.OPERATOR_BETWEEN;
              %>
              </tr>
              <tr>
                <td colspan="2">
                  <input type="hidden" name="relationOpDate" value="<%=valDate%>" />
                  <img alt="Field included" src="images/mini/field_included.gif" />
                  &nbsp;
                  <strong>
                    <label for="title"><%=contentManagement.getContent("species_references_17")%></label>
                  </strong>
                </td>
                <td>
                  <label for="select3" class="noshow">Operator</label>
                  <select id="select3" title="Operator" name="relationOpTitle" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpTitle == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_10", false)%></option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpTitle == Utilities.OPERATOR_CONTAINS.intValue())?"selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_11", false)%></option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpTitle == Utilities.OPERATOR_STARTS.intValue())?"selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_12", false)%></option>
                  </select>
                </td>
                <td>
                  <input id="title" title="Title" alt="Title" size="32" name="title" value="<%=title%>" class="inputTextField" />
                  <a title="List of values. Link will open a new window." href="javascript:openHelper('species-references-choice.jsp','title',0)"><img height="18" style="vertical-align:middle" alt="List of titles starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>
                  &nbsp;&nbsp;&nbsp;&nbsp;
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <img alt="Field included" src="images/mini/field_included.gif" />
                  &nbsp;
                  <strong>
                    <label for="editor"><%=contentManagement.getContent("species_references_14")%></label>
                  </strong>
                </td>
                <td>
                  <label for="select4" class="noshow">Operator</label>
                  <select id="select4" title="Operator" name="relationOpEditor" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpEditor == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_10", false)%></option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpEditor == Utilities.OPERATOR_CONTAINS.intValue()) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_11", false)%></option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpEditor == Utilities.OPERATOR_STARTS.intValue()) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_12", false)%></option>
                  </select>
                </td>
                <td>
                  <input id="editor" title="Editor" alt="Editor" size="32" name="editor" value="<%=editor%>" class="inputTextField" />
                  <a title="List of values. Link will open a new window." href="javascript:openHelper('species-references-choice.jsp','editor',0)"><img height="18" style="vertical-align:middle" alt="List of editors starting with/containing ..." src="images/helper/helper.gif" width="11" border="0" /></a>
                  &nbsp;&nbsp;&nbsp;&nbsp;
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <img alt="Field included" src="images/mini/field_included.gif" />
                  &nbsp;
                  <strong>
                    <label for="publisher"><%=contentManagement.getContent("species_references_18")%></label>
                  </strong>
                </td>
                <td>
                  <label for="select5" class="noshow">Operator</label>
                  <select id="select5" title="Operator" name="relationOpPublisher" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpPublisher == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_10", false)%></option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpPublisher == Utilities.OPERATOR_CONTAINS.intValue()) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_11", false)%></option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpPublisher == Utilities.OPERATOR_STARTS.intValue()) ? "selected=\"selected\"" : ""%>><%=contentManagement.getContent("species_references_12", false)%></option>
                  </select>
                </td>
                <td>
                  <input id="publisher" title="Publisher" alt="Publisher" size="32" name="publisher" value="<%=publisher%>" class="inputTextField" />
                  <a title="List of values. Link will open a new window." href="javascript:openHelper('species-references-choice.jsp','publisher',0)"><img height="18" style="vertical-align:middle" alt="List of publishers starting with/containing" src="images/helper/helper.gif" width="11" border="0" /></a>
                  &nbsp;&nbsp;&nbsp;&nbsp;
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
          <td style="text-align:right">
            <label for="Reset" class="noshow"><%=contentManagement.getContent("species_references_19", false )%></label>
            <input id="Reset" type="reset" value="<%=contentManagement.getContent("species_references_19", false )%>" name="Reset" class="inputTextField" title="Reset" />
            <%=contentManagement.writeEditTag("species_references_19")%>
            <label for="Search" class="noshow"><%=contentManagement.getContent("species_references_20", false )%></label>  
            <input id="Search" type="submit" value="<%=contentManagement.getContent("species_references_20", false)%>" name="submit2" class="inputTextField" title="Search" />
            <%=contentManagement.writeEditTag("species_references_20")%>
          </td>
        </tr>
      </table>
      </form>
      <%
        // Save search criteria
        if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
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
          <noscript>Your browser does not support JavaScript!</noscript>
          <br />
          <script language="JavaScript" type="text/javascript" src="script/species-references-save-criteria.js"></script>
          <%=contentManagement.getContent("species_references_21")%>:
          <a title="Save. Link will open a new window." href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-references.jsp','5','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="Save" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
          <%
            // Set Vector for URL string
            Vector show = new Vector();
            show.addElement("showGroup");
            show.addElement("showOrder");
            show.addElement("showFamily");
            show.addElement("showScientificName");
            show.addElement("showVernacularName");
            String pageName = "species-references.jsp";
            String pageNameResult = "species-references-result.jsp?"+Utilities.writeURLCriteriaSave(show);
            // Expand or not save criterias list
            String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
          %>
            <jsp:include page="show-criteria-search.jsp">
              <jsp:param name="pageName" value="<%=pageName%>" />
              <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
              <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
            </jsp:include>
      <%
        }
      %>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-references.jsp" />
    </jsp:include>
  </div>
  </body>
</html>