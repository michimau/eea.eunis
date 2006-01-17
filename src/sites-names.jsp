<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites names" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.names.NameSortCriteria,
                 ro.finsiel.eunis.utilities.Accesibility,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.AbstractSortCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement cm = SessionManager.getWebContent();
  String siteNameFromFactsheet = (request.getParameter("siteNameFromFactsheet") == null ? "" : request.getParameter("siteNameFromFactsheet").trim());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-names.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-names-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
      var countryListString = "<%=Utilities.getCountryListString()%>";
      function functionOnLoad()
      {
        var siteName = "<%=siteNameFromFactsheet%>";
        if(siteName != "")
        {
          document.eunis.DB_CDDA_NATIONAL.checked = true;
          document.eunis.DB_DIPLOMA.checked = true;
          document.eunis.DB_CDDA_INTERNATIONAL.checked = true;
          document.eunis.DB_BIOGENETIC.checked = true;
          document.eunis.DB_EMERALD.checked = true;
          document.eunis.DB_CORINE.checked = true;
          document.eunis.DB_NATURA2000.checked = true;
        }
      }
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_names_title")%>
    </title>
  </head>
  <body onload="functionOnLoad()">
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,sites_names_location"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form id="eunis" name="eunis" method="get" action="sites-names-result.jsp" onsubmit="return validateForm();">
        <input type="hidden" name="showName" value="true" />
        <input type="hidden" name="showDesignationYear" value="true" />
        <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_NAME%>" />
        <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
        <input type="hidden" name="noSoundex" value="true" />
        <h1>
          <%=cm.cmsText("sites_names_01")%>
        </h1>
        <%=cm.cmsText("sites_names_21")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=cm.cmsText("search_will_provide_following_information")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_names_03")%>" />
          <label for="showSourceDB"><%=cm.cmsText("sites_names_03" )%></label>
          <%=cm.cmsTitle("sites_names_03")%>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_names_04")%>" />
          <label for="showCountry"><%=cm.cmsText("sites_names_04" )%></label>
          <%=cm.cmsTitle("sites_names_04")%>

          <input id="showName" name="showName" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("sites_names_06")%>" />
          <label for="showName"><%=cm.cmsText("sites_names_06" )%></label>
          <%=cm.cmsTitle("sites_names_06")%>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_names_05")%>" />
          <label for="showDesignationTypes"><%=cm.cmsText("sites_names_05" )%></label>
          <%=cm.cmsTitle("sites_names_05")%>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_names_07")%>" />
          <label for="showCoordinates"><%=cm.cmsText("sites_names_07" )%></label>
          <%=cm.cmsTitle("sites_names_07")%>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_names_08")%>" />
          <label for="showSize"><%=cm.cmsText("sites_names_08")%></label>
          <%=cm.cmsTitle("sites_names_08")%>

          <!--<input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("sites_names_09")%>" />-->
          <!--<label for="showDesignationYear"><%=cm.cmsText("sites_names_09")%></label>-->
          <%--<%=cm.cmsTitle("sites_names_09")%>--%>
        </div>
        <img align="middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_mandatory")%>
        <strong>
          <%=cm.cmsText("sites_names_10")%>
        </strong>
        <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
        <select id="relationOp" name="relationOp" class="inputTextField" title="<%=cm.cms("operator")%>">
          <option value="<%=Utilities.OPERATOR_IS%>">
            <%=cm.cms("sites_names_13")%>
          </option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>">
            <%=cm.cms("sites_names_14")%>
          </option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
            <%=cm.cms("sites_names_15")%>
          </option>
        </select>
        <%=cm.cmsLabel("operator")%>
        <%=cm.cmsTitle("operator")%>
        <%=cm.cmsInput("sites_names_13")%>
        <%=cm.cmsInput("sites_names_14")%>
        <%=cm.cmsInput("sites_names_15")%>

        <label for="englishName" class="noshow"><%=cm.cms("sites_names_sitename")%></label>
        <input id="englishName" name="englishName" size="32" class="inputTextField" value="<%=siteNameFromFactsheet%>" title="<%=cm.cms("sites_names_sitename")%>" />
        <%=cm.cmsLabel("sites_names_sitename")%>
        <%=cm.cmsInput("sites_names_sitename")%>

        <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-names-choice.jsp')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
        <br />
        <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <strong>
          <%=cm.cmsText("sites_names_11")%>
        </strong>
        <label for="country" class="noshow"><%=cm.cms("sites_names_countryname")%></label>
        <input id="country" name="country" type="text" size="30" class="inputTextField" title="<%=cm.cms("sites_names_countryname")%>" />
        <%=cm.cmsLabel("sites_names_countryname")%>
        <%=cm.cmsTitle("sites_names_countryname")%>
        <a title="<%=cm.cms("helper")%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
        <br />
        <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <strong>
          <%=cm.cmsText("sites_names_12")%>
          <label for="yearMin" class="noshow"><%=cm.cms("minimum_designation_year")%></label>
          <input id="yearMin" name="yearMin" type="text" maxlength="4" size="4" class="inputTextField" title="<%=cm.cms("minimum_designation_year")%>" />
          <%=cm.cmsLabel("minimum_designation_year")%>
          <%=cm.cmsTitle("minimum_designation_year")%>
          and
          <label for="yearMax" class="noshow"><%=cm.cms("maximum_designation_year")%></label>
          <input id="yearMax" name="yearMax" type="text" maxlength="4" size="4" class="inputTextField" title="<%=cm.cms("maximum_designation_year")%>" />
          <%=cm.cmsLabel("maximum_designation_year")%>
          <%=cm.cmsTitle("maximum_designation_year")%>
        </strong>
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

    String pageName = "sites-names.jsp";
    String pageNameResult = "sites-names-result.jsp?"+Utilities.writeURLCriteriaSave(show);
    String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
%>
      <br />
      <%=cm.cmsText("sites_names_19")%>
      <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-names.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
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

      <%=cm.cmsMsg("sites_names_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-names.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>