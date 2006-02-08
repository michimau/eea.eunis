<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites neighborhood" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_neighborhoods_title")%>
    </title>
    <script language="JavaScript" type="text/javascript" src="script/sites-names.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-neighborhood-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
      var countryListString = "<%=Utilities.getCountryListString()%>";
      //-->
    </script>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,sites_neighborhood_location"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" action="sites-neighborhood-result.jsp" onsubmit="return validateForm();">
        <input type="hidden" name="showName" value="true" />
        <input type="hidden" name="showDesignationYear" value="true" />
        <h1>
          <%=cm.cmsText("sites_neighborhoods_01")%>
        </h1>

        <%=cm.cmsText("sites_neighborhoods_20")%>
        <br />
        <%=cm.cmsText("sites_neighborhoods_21")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=cm.cmsText("search_will_provide_following_information")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_neighborhoods_03")%>" />
          <label for="showSourceDB"><%=cm.cmsText("sites_neighborhoods_03")%></label>
          <%=cm.cmsTitle("sites_neighborhoods_03")%>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_neighborhoods_04")%>" />
          <label for="showCountry"><%=cm.cmsText("sites_neighborhoods_04")%></label>
          <%=cm.cmsTitle("sites_neighborhoods_04")%>

          <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_neighborhoods_06")%>" />
          <label for="showName"><%=cm.cmsText("sites_neighborhoods_06")%></label>
          <%=cm.cmsTitle("sites_neighborhoods_06")%>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_neighborhoods_05")%>" />
          <label for="showDesignationTypes"><%=cm.cmsText("sites_neighborhoods_05")%></label>
          <%=cm.cmsTitle("sites_neighborhoods_05")%>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_neighborhoods_07")%>" />
          <label for="showCoordinates"><%=cm.cmsText("sites_neighborhoods_07")%></label>
          <%=cm.cmsTitle("sites_neighborhoods_07")%>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_neighborhoods_08")%>" />
          <label for="showSize"><%=cm.cmsText("sites_neighborhoods_08")%></label>
          <%=cm.cmsTitle("sites_neighborhoods_08")%>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("sites_neighborhoods_09")%>" />
          <label for="showDesignationYear"><%=cm.cmsText("sites_neighborhoods_09")%></label>
          <%=cm.cmsTitle("sites_neighborhoods_09")%>
        </div>
        <img align="middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_mandatory")%>
        <strong>
          <%=cm.cmsText("sites_neighborhoods_06")%>
        </strong>&nbsp;
        <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
        <select id="relationOp" name="relationOp" class="inputTextField" title="<%=cm.cms("operator")%>">
          <option value="<%=Utilities.OPERATOR_IS%>">
            <%=cm.cms("sites_neighborhoods_10")%>
          </option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>">
            <%=cm.cms("sites_neighborhoods_11")%>
          </option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
            <%=cm.cms("sites_neighborhoods_12")%>
          </option>
        </select>
        <%=cm.cmsLabel("operator")%>
        <%=cm.cmsTitle("operator")%>
        <%=cm.cmsInput("sites_neighborhoods_10")%>
        <%=cm.cmsInput("sites_neighborhoods_11")%>
        <%=cm.cmsInput("sites_neighborhoods_12")%>

        <label for="englishName" class="noshow"><%=cm.cms("sites_neighorhood_sitename")%></label>
        <input id="englishName" name="englishName" size="32" class="inputTextField" title="<%=cm.cms("sites_neighorhood_sitename")%>" />&nbsp;
        <%=cm.cmsLabel("sites_neighorhood_sitename")%>
        <%=cm.cmsTitle("sites_neighorhood_sitename")%>
        <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-names-choice.jsp');"><img align="middle" width="11" height="18" src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" border="0" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
        <br />
        <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <strong><%=cm.cmsText("sites_neighborhoods_14")%>&nbsp;&nbsp;</strong>
        <label for="country" class="noshow"><%=cm.cms("sites_neighorhood_countryname")%></label>
        <input id="country" name="country" type="text" size="30" class="inputTextField" title="<%=cm.cms("sites_neighorhood_countryname")%>" />&nbsp;
        <%=cm.cmsLabel("sites_neighorhood_countryname")%>
        <%=cm.cmsTitle("sites_neighorhood_countryname")%>
        <a title="<%=cm.cms("helper")%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
        <br />
        <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <strong>
          <%=cm.cmsText("sites_neighborhoods_15")%>&nbsp;
        </strong>
        <label for="yearMin" class="noshow"><%=cm.cms("minimum_designation_year")%></label>
        <input id="yearMin" name="yearMin" type="text" maxlength="4" size="4" class="inputTextField" title="<%=cm.cms("minimum_designation_year")%>" />
        <%=cm.cmsLabel("minimum_designation_year")%>
        <%=cm.cmsTitle("minimum_designation_year")%>

        <%=cm.cmsText("sites_neighborhoods_16")%>
        <label for="yearMax" class="noshow"><%=cm.cms("maximum_designation_year")%></label>
        <input id="yearMax" name="yearMax" type="text" maxlength="4" size="4" class="inputTextField" title="<%=cm.cms("maximum_designation_year")%>" />
        <%=cm.cmsLabel("maximum_designation_year")%>
        <%=cm.cmsTitle("maximum_designation_year")%>
        <div class="submit_buttons">
          <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset_btn_value")%>" class="inputTextField" title="<%=cm.cms("reset_btn_title")%>" />
          <%=cm.cmsTitle("reset_btn_title")%>
          <%=cm.cmsInput("reset_btn_value")%>

          <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=cm.cms("search_btn_value")%>" title="<%=cm.cms("search_btn_title")%>" />
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

    String pageName = "sites-neighborhood.jsp";
    String pageNameResult = "sites-neighborhood-result.jsp?"+Utilities.writeURLCriteriaSave(show);
    // Expand or not save criterias list
    String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
%>
      <br />
      <%=cm.cmsText("sites_neighborhoods_19")%>
      <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-neighborhood.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
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

      <%=cm.cmsMsg("sites_neighborhoods_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-neighborhood.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>