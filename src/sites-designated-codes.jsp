<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites by designation types" function - search page.
--%>
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.Accesibility"%>
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
    <script language="JavaScript" type="text/javascript" src="script/sites-designated-codes-save-criteria.js"></script>
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_designated-codes_title", false )%></title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Pick designation types show sites"/>
        <jsp:param name="helpLink" value="species-help.jsp"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="sites-designated-codes-result.jsp">
      <input type="hidden" name="source" value="sitedesignatedname" />
      <h5>
        <%=contentManagement.getContent("sites_designated-codes_01")%>
      </h5>

      <%=contentManagement.getContent("sites_designated-codes_21")%>
      <br />
      <br />
      <div class="grey_rectangle">
        <strong>
          <%=contentManagement.getContent("sites_designated-codes_02")%>
        </strong>
        <br />
        <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designated-codes_03", false )%>" />
        <label for="showSourceDB"><%=contentManagement.getContent("sites_designated-codes_03")%></label>

        <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designated-codes_04", false )%>" />
        <label for="showCountry"><%=contentManagement.getContent("sites_designated-codes_04")%></label>

        <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designated-codes_06", false )%>" />
        <label for="showName"><%=contentManagement.getContent("sites_designated-codes_06")%></label>

        <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designated-codes_05", false )%>" />
        <label for="showDesignationTypes"><%=contentManagement.getContent("sites_designated-codes_05")%></label>

        <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designated-codes_07", false )%>" />
        <label for="showCoordinates"><%=contentManagement.getContent("sites_designated-codes_07")%></label>

        <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_designated-codes_08", false )%>" />
        <label for="showSize"><%=contentManagement.getContent("sites_designated-codes_08")%></label>

        <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_designated-codes_09", false )%>" />
        <label for="showDesignationYear"><%=contentManagement.getContent("sites_designated-codes_09")%></label>
      </div>
      <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
      <strong>
        <%=contentManagement.getContent("sites_designated-codes_11")%>
      </strong>
      <label for="relationOp" class="noshow">Operator</label>
      <select id="relationOp" name="relationOp" class="inputTextField" title="Operator">
          <option value="<%=Utilities.OPERATOR_IS%>">
            <%=contentManagement.getContent("sites_designated-codes_12", false)%>
          </option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>">
            <%=contentManagement.getContent("sites_designated-codes_13", false)%>
          </option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
            <%=contentManagement.getContent("sites_designated-codes_14", false)%>
          </option>
      </select>
      <label for="searchString" class="noshow">Search string</label>
      <input id="searchString" name="searchString" value="" size="32" class="inputTextField" title="Search string" />
      <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:openHelper('sites-designations-choice.jsp','yes')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>&nbsp;
      <br />
      <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
      <label for="category">
        <strong>
          Designation category
        </strong>
      </label>
      <select id="category" name="category" class="inputTextField" title="Designation category">
        <option value="A">A</option>
        <option value="B">B</option>
        <option value="C">C</option>
        <option value="any" selected="selected"><%=contentManagement.getContent("sites_designated-codes_17", false)%></option>
      </select>
      <div class="submit_buttons">
        <label for="reset" class="noshow">Reset values</label>
        <input type="reset" value="<%=contentManagement.getContent("sites_designated-codes_18", false )%>" id="reset" name="Reset" class="inputTextField" title="Reset values" />
        <%=contentManagement.writeEditTag( "sites_designated-codes_18" )%>
        <label for="submit2" class="noshow">Search</label>
        <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=contentManagement.getContent("sites_designated-codes_19", false )%>" title="Search" />
        <%=contentManagement.writeEditTag( "sites_designated-codes_19" )%>
      </div>
      <jsp:include page="sites-search-common.jsp" />
    </form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
  {
    // Set Vector for URL string
    Vector show = new Vector();
    show.addElement("showName");
    show.addElement("showSourceDB");
    show.addElement("showDesignationYear");
    show.addElement("showCountry");
    show.addElement("showDesignationTypes");
    show.addElement("showCoordinates");
    show.addElement("showSize");
    String pageName = "sites-designated-codes.jsp";
    String pageNameResult = "sites-designated-codes-result.jsp?"+Utilities.writeURLCriteriaSave(show);
    // Expand or not save criterias list
    String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
%>
    <%=contentManagement.getContent("sites_designated-codes_20")%>
    <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-designated-codes.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
<%
  }
%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-designated-codes.jsp" />
      </jsp:include>
    </div>
  </body>
</html>
