<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites by designation types" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-designated-codes.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-designated-codes-save-criteria.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_designated-codes_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,Sites#sites.jsp,sites_designated_codes_location"/>
        <jsp:param name="helpLink" value="species-help.jsp"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="sites-designated-codes-result.jsp">
      <input type="hidden" name="source" value="sitedesignatedname" />
      <h1>
        <%=cm.cmsText("sites_designated-codes_01")%>
      </h1>
      <%=cm.cmsText("sites_designated-codes_21")%>
      <br />
      <br />
      <div class="grey_rectangle">
        <strong>
          <%=cm.cmsText("sites_designated-codes_02")%>
        </strong>
        <br />
        <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_designated-codes_03")%>" />
        <label for="showSourceDB"><%=cm.cmsText("sites_designated-codes_03")%></label>
        <%=cm.cmsTitle("sites_designated-codes_03")%>

        <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_designated-codes_04")%>" />
        <label for="showCountry"><%=cm.cmsText("sites_designated-codes_04")%></label>
        <%=cm.cmsTitle("sites_designated-codes_04")%>

        <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_designated-codes_06")%>" />
        <label for="showName"><%=cm.cmsText("sites_designated-codes_06")%></label>
        <%=cm.cmsTitle("sites_designated-codes_06")%>

        <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_designated-codes_05")%>" />
        <label for="showDesignationTypes"><%=cm.cmsText("sites_designated-codes_05")%></label>
        <%=cm.cmsTitle("sites_designated-codes_05")%>

        <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_designated-codes_07")%>" />
        <label for="showCoordinates"><%=cm.cmsText("sites_designated-codes_07")%></label>
        <%=cm.cmsTitle("sites_designated-codes_07")%>

        <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_designated-codes_08")%>" />
        <label for="showSize"><%=cm.cmsText("sites_designated-codes_08")%></label>
        <%=cm.cmsTitle("sites_designated-codes_08")%>

        <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("sites_designated-codes_09")%>" />
        <label for="showDesignationYear"><%=cm.cmsText("sites_designated-codes_09")%></label>
        <%=cm.cmsTitle("sites_designated-codes_09")%>
      </div>
      <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
      <strong>
        <%=cm.cmsText("sites_designated-codes_11")%>
      </strong>
      <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
      <select id="relationOp" name="relationOp" class="inputTextField" title="<%=cm.cms("operator")%>">
        <option value="<%=Utilities.OPERATOR_IS%>">
          <%=cm.cms("sites_designated-codes_12")%>
        </option>
        <option value="<%=Utilities.OPERATOR_CONTAINS%>">
          <%=cm.cms("sites_designated-codes_13")%>
        </option>
        <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
          <%=cm.cms("sites_designated-codes_14")%>
        </option>
      </select>
      <%=cm.cmsLabel("operator")%>
      <%=cm.cmsTitle("operator")%>
      <%=cm.cmsInput("sites_designated-codes_12")%>
      <%=cm.cmsInput("sites_designated-codes_13")%>
      <%=cm.cmsInput("sites_designated-codes_14")%>

      <label for="searchString" class="noshow"><%=cm.cms("sites_designated_codes_designationname")%></label>
      <input id="searchString" name="searchString" value="" size="32" class="inputTextField" title="<%=cm.cms("sites_designated_codes_designationname")%>" />
      <%=cm.cmsLabel("sites_designated_codes_designationname")%>
      <%=cm.cmsTitle("sites_designated_codes_designationname")%>
      <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-designations-choice.jsp','yes')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>&nbsp;
      <%=cm.cmsTitle("helper")%>
      <%=cm.cmsAlt("helper")%>
      <br />
      <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
      <%=cm.cmsAlt("field_optional")%>
      <label for="category">
        <strong>
          <%=cm.cmsText("sites_designated_codes_designationcategory")%>
        </strong>
      </label>
      <select id="category" name="category" class="inputTextField" title="Designation category">
          <option value="A"><%=cm.cms("sites_designations_cata")%></option>
          <option value="B"><%=cm.cms("sites_designations_catb")%></option>
          <option value="C"><%=cm.cms("sites_designations_catc")%></option>
          <option value="any" selected="selected">
            <%=cm.cms("sites_designated-codes_17")%>
          </option>
      </select>
      <%=cm.cmsInput("sites_designations_cata")%>
      <%=cm.cmsInput("sites_designations_catb")%>
      <%=cm.cmsInput("sites_designations_catc")%>

      <div class="submit_buttons">
        <label for="reset" class="noshow"><%=cm.cms("reset_btn_label")%></label>
        <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset_btn_value")%>" class="inputTextField" title="<%=cm.cms("reset_btn_title")%>" />
        <%=cm.cmsLabel("reset_btn_label")%>
        <%=cm.cmsTitle("reset_btn_title")%>
        <%=cm.cmsInput("reset_btn_value")%>

        <label for="submit2" class="noshow"><%=cm.cms("search_btn_label")%></label>
        <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=cm.cms("search_btn_value")%>" title="<%=cm.cms("search_btn_title")%>" />
        <%=cm.cmsLabel("search_btn_label")%>
        <%=cm.cmsTitle("search_btn_title")%>
        <%=cm.cmsInput("search_btn_value")%>
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
    <%=cm.cmsText("sites_designated-codes_20")%>
    <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-designated-codes.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
    <%=cm.cmsTitle("save")%>
    <%=cm.cmsAlt("save")%>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
<%
  }
%>

      <%=cm.cmsMsg("sites_designated-codes_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-designated-codes.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
