<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Number/Total area" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.Vector,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,statistical_data";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cmsPhrase("Sites statistical information") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" helpLink="sites-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-statistical.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-statistical-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
      var countryListString = "<%=Utilities.getCountryListString()%>";
      //]]>
    </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
		<h1><%=cm.cmsPhrase( "Number / Total area " )%></h1>
<!-- MAIN CONTENT -->
                <%=cm.cmsText("sites_statistical_01")%>
                <form name="eunis" onsubmit="javascript:return validateForm();" action="sites-statistical-result.jsp" method="get">
                  <br />
                  <img style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                  <label for="country">
                      <%=cm.cmsPhrase("Country is")%>
                  </label>
                  <input id="country" name="country" type="text" title="<%=cm.cms("country_is")%>" />&nbsp;
                  <a title="<%=cm.cms("helper")%>" href="javascript:openHelperCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  <br />

                  <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_optional")%>
                  <label for="designation">
                      <%=cm.cmsPhrase("Designation name contains")%>
                  </label>
                  <input id="designation" name="designation" type="text" size="30" title="<%=cm.cms("sites_statistical_05")%>" />
                  <%=cm.cmsTitle("sites_statistical_05")%>

                  <a title="<%=cm.cms("helper")%>" href="javascript:openHelperDesignation('sites-statistical-choice.jsp')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  <br />

                  <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_optional")%>
                  <label for="designationCat">
                      <%=cm.cmsPhrase("Designation category is")%>
                  </label>
                  <select id="designationCat" name="designationCat" title="<%=cm.cms("sites_statistical_06")%>">
                    <option value="any" selected="selected"><%=cm.cms("any")%></option>
                    <option value="A"><%=cm.cms("sites_designations_cata")%></option>
                    <option value="B"><%=cm.cms("sites_designations_catb")%></option>
                    <option value="C"><%=cm.cms("sites_designations_catc")%></option>
                  </select>
                  <%=cm.cmsTitle("sites_statistical_06")%>
                  <%=cm.cmsLabel("sites_statistical_06")%>
                  <%=cm.cmsInput("any")%>
                  <%=cm.cmsInput("sites_designations_cata")%>
                  <%=cm.cmsInput("sites_designations_catb")%>
                  <%=cm.cmsInput("sites_designations_catc")%>
                  <br />
                  <img style="vertical-align:middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
                  <strong>
                    <%=cm.cmsPhrase("Designation year is between")%>&nbsp;
                    <label for="yearMin" class="noshow"><%=cm.cms("minimum_designation_year")%></label>
                    <input id="yearMin" name="yearMin" type="text" size="4" title="<%=cm.cms("minimum_designation_year")%>" />
                    <%=cm.cmsLabel("minimum_designation_year")%>

                    <%=cm.cmsPhrase("and")%>
                    <label for="yearMax" class="noshow"><%=cm.cms("maximum_designation_year")%></label>
                    <input id="yearMax" name="yearMax" type="text" size="4" title="<%=cm.cms("maximum_designation_year")%>" />
                    <%=cm.cmsLabel("maximum_designation_year")%>
                  </strong>
                  <div class="submit_buttons">
                    <input id="reset" name="Reset" type="reset" value="<%=cm.cmsPhrase("Reset")%>" class="standardButton" title="<%=cm.cmsPhrase("Reset values")%>" />

                    <input id="submit2" name="submit2" type="submit" class="submitSearchButton" value="<%=cm.cmsPhrase("Search")%>" title="<%=cm.cmsPhrase("Search")%>" />
                  </div>
                  <jsp:include page="sites-search-common.jsp" />
                </form>
          <%
            // Save search criteria
            if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
            {
           %>
                <br />
                <%=cm.cmsPhrase("Save your criteria:")%>
                <a title="<%=cm.cmsPhrase("Save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-statistical.jsp','5','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cmsPhrase("Save")%>" title="<%=cm.cmsPhrase("Save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
          <%
            // Set Vector for URL string
            Vector show = new Vector();
            String pageName = "sites-statistical.jsp";
            String pageNameResult = "sites-statistical-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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
<!-- END MAIN CONTENT -->

    </stripes:layout-component>
</stripes:layout-render>
