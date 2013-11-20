<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites neighborhood" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,sites_neighborhood_location";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("site_neighborhood_1") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" helpLink="sites-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
<stripes:layout-component name="head">
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-names.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-neighborhood-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
      var countryListString = "<%=Utilities.getCountryListString()%>";
      //]]>
    </script>

    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
          <h1>
            <%=cm.cmsPhrase("Site neighborhood")%>
          </h1>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" action="sites-neighborhood-result.jsp" onsubmit="return validateForm();">
                  <input type="hidden" name="showName" value="true" />
                  <input type="hidden" name="showDesignationYear" value="true" />
                  <p>
                  <%=cm.cmsPhrase("Search neighbouring sites")%>
                  <br />
                  <%=cm.cmsPhrase("(ex. Site around site named <strong>Bluntautal</strong> from <strong>Austria</strong>) ")%>
                  </p>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search in")%></legend>
                  <jsp:include page="sites-search-common.jsp" />
                  </fieldset>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search what")%></legend>
                  <img style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                  <label for="relationOp"><%=cm.cmsPhrase("Site name")%></label>&nbsp;
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

                  <label for="englishName" class="noshow"><%=cm.cms("site_name")%></label>
                  <input id="englishName" name="englishName" size="32" title="<%=cm.cms("site_name")%>" />&nbsp;
                  <%=cm.cmsLabel("site_name")%>
                  <%=cm.cmsTitle("site_name")%>
                  <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-names-choice.jsp');"><img style="vertical-align:middle" width="11" height="18" src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" border="0" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_optional")%>
                  <label for="country"><%=cm.cmsPhrase("Country is")%>&nbsp;&nbsp;</label>
                  <input id="country" name="country" type="text" size="30" title="<%=cm.cms("country_name")%>" />&nbsp;
                  <%=cm.cmsLabel("country_name")%>
                  <%=cm.cmsTitle("country_name")%>
                  <a title="<%=cm.cms("helper")%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_optional")%>
                  <label for="yearMin"><%=cm.cmsPhrase("Designation year between")%>&nbsp;</label>
                  <input id="yearMin" name="yearMin" type="text" maxlength="4" size="4" title="<%=cm.cms("minimum_designation_year")%>" />
                  <%=cm.cmsLabel("minimum_designation_year")%>
                  <%=cm.cmsTitle("minimum_designation_year")%>

                  <%=cm.cmsPhrase("and")%>
                  <label for="yearMax" class="noshow"><%=cm.cms("maximum_designation_year")%></label>
                  <input id="yearMax" name="yearMax" type="text" maxlength="4" size="4" title="<%=cm.cms("maximum_designation_year")%>" />
                  <%=cm.cmsLabel("maximum_designation_year")%>
                  <%=cm.cmsTitle("maximum_designation_year")%>
                  </fieldset>

                  <fieldset class="large">
                    <legend><%=cm.cmsPhrase("Output fields")%></legend>
                    <strong>
                      <%=cm.cmsPhrase("Search shall provide the following information (checked fields will be displayed)")%>
                    </strong>
                    <br />
                    <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set_2")%>" />
                    <label for="showSourceDB"><%=cm.cmsPhrase("Source data set&nbsp;")%></label>
                    <%=cm.cmsTitle("source_data_set_2")%>

                    <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("country_1")%>" />
                    <label for="showCountry"><%=cm.cmsPhrase("Country &nbsp;")%></label>
                    <%=cm.cmsTitle("country_1")%>

                    <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("site_name")%>" />
                    <label for="showName"><%=cm.cmsPhrase("Site name")%></label>
                    <%=cm.cmsTitle("site_name")%>

                    <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("designation_type_1")%>" />
                    <label for="showDesignationTypes"><%=cm.cmsPhrase("Designation type &nbsp;")%></label>
                    <%=cm.cmsTitle("designation_type_1")%>

                    <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("coordinates_1")%>" />
                    <label for="showCoordinates"><%=cm.cmsPhrase("Coordinates &nbsp;")%></label>
                    <%=cm.cmsTitle("coordinates_1")%>

                    <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("size_1")%>" />
                    <label for="showSize"><%=cm.cmsPhrase("Size &nbsp;")%></label>
                    <%=cm.cmsTitle("size_1")%>

                    <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("designation_year")%>" />
                    <label for="showDesignationYear"><%=cm.cmsPhrase("Designation year")%></label>
                    <%=cm.cmsTitle("designation_year")%>
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
              show.addElement("showName");
              show.addElement("showSourceDB");
              show.addElement("showDesignationYear");
              show.addElement("showCountry");
              show.addElement("showDesignationTypes");
              show.addElement("showCoordinates");
              show.addElement("showSize");

              String pageName = "sites-neighborhood.jsp";
              String pageNameResult = "sites-neighborhood-result.jsp?"+Utilities.writeURLCriteriaSave(show);
              // Expand or not save criterias list
              String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
          %>
                <br />
                <%=cm.cmsPhrase("Save your criteria:")%>
                <a title="<%=cm.cmsPhrase("Save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-neighborhood.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cmsPhrase("Save")%>" title="<%=cm.cmsPhrase("Save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                <jsp:include page="show-criteria-search.jsp">
                  <jsp:param name="pageName" value="<%=pageName%>" />
                  <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                  <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                </jsp:include>
          <%
            }
          %>

                <%=cm.cmsMsg("site_neighborhood_1")%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>