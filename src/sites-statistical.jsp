<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Number/Total area" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sites-statistical.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-statistical-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
      var countryListString = "<%=Utilities.getCountryListString()%>";
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_statistical_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,sites_statistical_location"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <%=cm.cmsText("sites_statistical_01")%>
      <form name="eunis" onsubmit="javascript:return validateForm();" action="sites-statistical-result.jsp" method="get">
        <br />
        <img align="middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_mandatory")%>
        <label for="country">
          <strong>
            <%=cm.cmsText("sites_statistical_03")%>
          </strong>
        </label>
        <input id="country" name="country" type="text" class="inputTextField" title="<%=cm.cms("sites_statistical_03")%>" />&nbsp;
        <a title="<%=cm.cms("helper")%>" href="javascript:openHelperCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
        <br />

        <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <label for="designation">
          <strong>
            <%=cm.cmsText("sites_statistical_05")%>
          </strong>
        </label>
        <input id="designation" name="designation" type="text" size="30" class="inputTextField" title="<%=cm.cms("sites_statistical_05")%>" />
        <%=cm.cmsTitle("sites_statistical_05")%>

        <a title="<%=cm.cms("helper")%>" href="javascript:openHelperDesignation('sites-statistical-choice.jsp')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
        <br />

        <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <label for="designationCat">
          <strong>
            <%=cm.cmsText("sites_statistical_06")%>
          </strong>
        </label>
        <select id="designationCat" name="designationCat" class="inputTextField" title="<%=cm.cms("sites_statistical_06")%>">
          <option value="any" selected="selected"><%=cm.cms("sites_statistical_07")%></option>
          <option value="A"><%=cm.cms("sites_designations_cata")%></option>
          <option value="B"><%=cm.cms("sites_designations_catb")%></option>
          <option value="C"><%=cm.cms("sites_designations_catc")%></option>
        </select>
        <%=cm.cmsTitle("sites_statistical_06")%>
        <%=cm.cmsLabel("sites_statistical_06")%>
        <%=cm.cmsInput("sites_statistical_07")%>
        <%=cm.cmsInput("sites_designations_cata")%>
        <%=cm.cmsInput("sites_designations_catb")%>
        <%=cm.cmsInput("sites_designations_catc")%>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <strong>
          <%=cm.cmsText("sites_statistical_08")%>&nbsp;
          <label for="yearMin" class="noshow"><%=cm.cms("minimum_designation_year")%></label>
          <input id="yearMin" name="yearMin" type="text" size="4" class="inputTextField" title="<%=cm.cms("minimum_designation_year")%>" />
          <%=cm.cmsLabel("minimum_designation_year")%>

          <%=cm.cmsText("sites_statistical_09")%>
          <label for="yearMax" class="noshow"><%=cm.cms("maximum_designation_year")%></label>
          <input id="yearMax" name="yearMax" type="text" size="4" class="inputTextField" title="<%=cm.cms("maximum_designation_year")%>" />
          <%=cm.cmsLabel("maximum_designation_year")%>
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
 %>
      <br />
      <%=cm.cmsText("sites_statistical_13")%>
      <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-statistical.jsp','5','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
      <%=cm.cmsTitle("save")%>
      <%=cm.cmsAlt("save")%>
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

      <%=cm.cmsMsg("sites_statistical_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-statistical.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>