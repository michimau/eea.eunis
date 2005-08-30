<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Designation types" function - search page.
--%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<%@page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-designated-codes.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-designations-save-criteria.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("sites_designations_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Designation types"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="sites-designations-result.jsp">
        <input type="hidden" name="source" value="sitedesignatedname" />
        <h5>
          <%=contentManagement.getContent("sites_designations_01")%>
        </h5>

        <%=contentManagement.getContent("sites_designations_19")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=contentManagement.getContent("sites_designations_02")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designations_03", false )%>" />
          <label for="showSourceDB"><%=contentManagement.getContent("sites_designations_03")%></label>

          <input id="showIso" name="showIso" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designations_07", false )%>" />
          <label for="showIso"><%=contentManagement.getContent("sites_designations_07")%></label>

          <input id="showDesignation" name="showDesignation" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designations_04", false )%>" />
          <label for="showDesignation"><%=contentManagement.getContent("sites_designations_04")%></label>

          <input id="showDesignationEn" name="showDesignationEn" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designations_05", false )%>" />
          <label for="showDesignationEn"><%=contentManagement.getContent("sites_designations_05")%></label>

          <input id="showDesignationFr" name="showDesignationFr" type="checkbox" value="true" title="<%=contentManagement.getContent("sites_designations_06", false )%>" />
          <label for="showDesignationFr"><%=contentManagement.getContent("sites_designations_06")%></label>

          <input id="showAbreviation" name="showAbreviation" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designations_08", false )%>" />
          <label for="showAbreviation"><%=contentManagement.getContent("sites_designations_08")%></label>
        </div>
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_designations_09")%>
        </strong>
        <label for="relationOp" class="noshow">Operator</label>
        <select id="relationOp" name="relationOp" class="inputTextField" title="Operator">
            <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("sites_designations_10", false)%></option>
            <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("sites_designations_11", false)%></option>
            <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("sites_designations_12", false)%></option>
        </select>
        <label for="searchString" class="noshow">Search string</label>
        <input id="searchString" name="searchString" value="" size="32" class="inputTextField" title="Search string" />
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:openHelper('sites-designations-choice.jsp','no')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <label for="category">
          <strong>
            <%=contentManagement.getContent("sites_designations_14")%>
          </strong>
        </label>
        <select id="category" name="category" class="inputTextField" title="Designation category">
          <option value="A">A</option>
          <option value="B">B</option>
          <option value="C">C</option>
          <option value="any" selected="selected"><%=contentManagement.getContent("sites_designations_15", false)%></option>
        </select>
        <div class="submit_buttons">
            <label for="Reset" class="noshow">Reset values</label>
            <input type="reset" value="<%=contentManagement.getContent("sites_designations_16", false )%>" id="Reset" name="Reset" class="inputTextField" title="Reset values" />
            <%=contentManagement.writeEditTag( "sites_designations_16" )%>
            <label for="submit2" class="noshow">Search</label>
            <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=contentManagement.getContent("sites_designations_17", false )%>" title="Search" />
            <%=contentManagement.writeEditTag( "sites_designations_17" )%>
        </div>
        <jsp:include page="sites-search-common.jsp" />
      </form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
  {
    // Set Vector for URL string
    Vector show = new Vector();
    show.addElement("showSource");
    show.addElement("showDesignation");
    show.addElement("showDesignationEn");
    show.addElement("showDesignationFr");
    show.addElement("showSourceDB");
    show.addElement("showIso");
    show.addElement("showAbreviation");
    String pageName = "sites-designations.jsp";
    String pageNameResult = "sites-designations-result.jsp?"+Utilities.writeURLCriteriaSave(show);
    // Expand or not save criterias list
    String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
%>
      <br />
    <%=contentManagement.getContent("sites_designations_18")%>
    <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-designations.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
<%
  }
%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-designations.jsp" />
      </jsp:include>
    </div>
  </body>
</html>