<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites country" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
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
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,country";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("site_country") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" helpLink="sites-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-country.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/sites-country-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        function validateForm()
        {
          var errMessageForm = "<%=cm.cms("sites_country_02")%>";
          var errInvalidCountry = "<%=cm.cms("sites_country_03")%>";

          document.eunis.country.value = trim(document.eunis.country.value);
          var searchString = document.eunis.country.value;
          document.eunis.countryName.value = searchString;// Set the hidden field
          if (document.eunis.countryName.value == "")
          {
            alert(errMessageForm);
            return false;
          }
          if (!validateCountry("<%=Utilities.getCountryListString()%>",searchString))
          {
            alert(errInvalidCountry);
            return false;
          }
          return checkValidSelection(); // from sites-search-common.jsp
        }
      //]]>
    </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1>
        <%=cm.cmsPhrase("Site country")%>
        </h1>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" onsubmit="return validateForm();" action="sites-country-result.jsp">
                  <input type="hidden" name="showName" value="true" />
                  <input type="hidden" name="countryName" />
                  <p>
                  <%=cm.cmsPhrase("Search sites by geographical location<br />(ex.: Sites located in <strong>Romania</strong>)")%>
                  </p>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search in")%></legend>
                  <jsp:include page="sites-search-common.jsp" />
                  </fieldset>

                  <fieldset class="large">
                  <legend><%=cm.cmsPhrase("Search what")%></legend>
                  <img style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                  &nbsp;
                  <label for="country">
                      <%=cm.cmsPhrase("Country is")%>
                    &nbsp;
                  </label>
                  <input id="country" name="country" type="text" size="30" title="<%=cm.cms("country_is")%>" />
                  <%=cm.cmsLabel("country_is")%>
                  <%=cm.cmsTitle("country_is")%>
                  &nbsp;
                  <a title="<%=cm.cms("helper")%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
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

                    <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("site_name_1")%>" />
                    <label for="showName"><%=cm.cmsPhrase("Site name &nbsp;")%></label>
                    <%=cm.cmsTitle("site_name_1")%>

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
              String pageName = "sites-country.jsp";
              String pageNameResult = "sites-country-result.jsp?"+Utilities.writeURLCriteriaSave(show);
              // Expand or not save criterias list
              String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
          %>
                <br />
              <%=cm.cmsPhrase("Save your criteria:")%>
              <a title="<%=cm.cmsPhrase("Save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-country.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cmsPhrase("Save")%>" title="<%=cm.cmsPhrase("Save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
              <jsp:include page="show-criteria-search.jsp">
                <jsp:param name="pageName" value="<%=pageName%>" />
                <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
              </jsp:include>
          <%
            }
          %>

                <%=cm.cmsMsg("site_country")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_country_02")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_country_03")%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
