<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Designation types" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,designation_types";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Site designation types") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" helpLink="sites-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-designated-codes.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-designations-save-criteria.js"></script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
          <h1>
            <%=cm.cmsPhrase("Designation types")%>
          </h1>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="sites-designations-result.jsp">
                  <input type="hidden" name="source" value="sitedesignatedname" />
                  <p>
                  <%=cm.cmsText("sites_designations_19")%>
                  </p>
                  <fieldset class="large">
                  <legend>Search in</legend>
                  <jsp:include page="sites-search-common.jsp" />
                  </fieldset>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search what")%></legend>
                  <img style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                  <label for="relationOp"><%=cm.cmsPhrase("Original/English/French Designation name")%></label>
                  <select id="relationOp" name="relationOp" title="<%=cm.cmsPhrase("Operator")%>">
                    <option value="<%=Utilities.OPERATOR_IS%>">
                      <%=cm.cmsPhrase("is")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                      <%=cm.cmsPhrase("contains")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
                      <%=cm.cmsPhrase("starts with")%>
                    </option>
                  </select>
                  <label for="searchString" class="noshow"><%=cm.cms("designation_name")%></label>
                  <input id="searchString" name="searchString" value="" size="32" title="<%=cm.cms("designation_name")%>" />
                  <%=cm.cmsLabel("designation_name")%>
                  <%=cm.cmsTitle("designation_name")%>

                  <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-designations-choice.jsp','no')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_optional")%>
                  <label for="category">
                      <%=cm.cmsPhrase("Designation category")%>
                  </label>
                  <select id="category" name="category" title="<%=cm.cms("designation_category")%>">
                    <option value="A"><%=cm.cms("sites_designations_cata")%></option>
                    <option value="B"><%=cm.cms("sites_designations_catb")%></option>
                    <option value="C"><%=cm.cms("sites_designations_catc")%></option>
                    <option value="any" selected="selected">
                      <%=cm.cms("any")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("designation_category")%>
                  <%=cm.cmsTitle("designation_category")%>
                  <%=cm.cmsInput("any")%>
                  <%=cm.cmsInput("sites_designations_cata")%>
                  <%=cm.cmsInput("sites_designations_catb")%>
                  <%=cm.cmsInput("sites_designations_catc")%>
                  </fieldset>

                  <fieldset class="large">
                    <legend><%=cm.cmsPhrase("Output fields")%></legend>
                    <strong>
                      <%=cm.cmsPhrase("Search shall provide the following information (checked fields will be displayed)")%>
                    </strong>
                    <br />
                    <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set_2")%>" />
                    <label for="showSourceDB"><%=cm.cmsPhrase("Source data set")%></label>
                    <%=cm.cmsTitle("source_data_set_2")%>

                    <input id="showIso" name="showIso" type="checkbox" value="true" checked="checked" title="<%=cm.cms("country_1")%>" />
                    <label for="showIso"><%=cm.cmsPhrase("Country")%></label>
                    <%=cm.cmsTitle("country_1")%>

                    <input id="showDesignation" name="showDesignation" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_designations_04")%>" />
                    <label for="showDesignation"><%=cm.cmsPhrase("Designation name")%></label>
                    <%=cm.cmsTitle("sites_designations_04")%>

                    <input id="showDesignationEn" name="showDesignationEn" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_designations_05")%>" />
                    <label for="showDesignationEn"><%=cm.cmsPhrase("English designation name")%></label>
                    <%=cm.cmsTitle("sites_designations_05")%>

                    <input id="showDesignationFr" name="showDesignationFr" type="checkbox" value="true" title="<%=cm.cms("sites_designations_06")%>" />
                    <label for="showDesignationFr"><%=cm.cmsPhrase("French designation name")%></label>
                    <%=cm.cmsTitle("sites_designations_06")%>

                    <input id="showAbreviation" name="showAbreviation" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_designations_08")%>" />
                    <label for="showAbreviation"><%=cm.cmsPhrase("Designation abbreviation ")%></label>
                    <%=cm.cmsTitle("sites_designations_08")%>
                  </fieldset>

                  <div class="submit_buttons">
                    <input id="reset" name="Reset" type="reset" value="<%=cm.cmsPhrase("Reset")%>" class="standardButton" title="<%=cm.cmsPhrase("Reset values")%>" />

                    <input id="submit2" name="submit2" type="submit" class="submitSearchButton" value="<%=cm.cmsPhrase("Search")%>" title="<%=cm.cmsPhrase("Search")%>" />
                  </div>
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
              <%=cm.cmsPhrase("Save your criteria:")%>
              <a title="<%=cm.cmsPhrase("Save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-designations.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cmsPhrase("Save")%>" title="<%=cm.cmsPhrase("Save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
              <jsp:include page="show-criteria-search.jsp">
                <jsp:param name="pageName" value="<%=pageName%>" />
                <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
              </jsp:include>
          <%
            }
          %>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>