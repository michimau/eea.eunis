<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites country" function - search page.
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-country.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-country-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
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
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_country_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,sites_country_location"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="return validateForm();" action="sites-country-result.jsp">
        <input type="hidden" name="showName" value="true" />
        <input type="hidden" name="countryName" />
        <h1>
          <%=cm.cmsText("sites_country_01")%>
        </h1>

        <%=cm.cmsText("sites_country_16")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=cm.cmsText("search_will_provide_following_information")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_country_05")%>" />
          <label for="showSourceDB"><%=cm.cmsText("sites_country_05")%></label>
          <%=cm.cmsTitle("sites_country_05")%>

          <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_country_07")%>" />
          <label for="showName"><%=cm.cmsText("sites_country_07")%></label>
          <%=cm.cmsTitle("sites_country_07")%>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_country_06")%>" />
          <label for="showDesignationTypes"><%=cm.cmsText("sites_country_06")%></label>
          <%=cm.cmsTitle("sites_country_06")%>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_country_08")%>" />
          <label for="showCoordinates"><%=cm.cmsText("sites_country_08")%></label>
          <%=cm.cmsTitle("sites_country_08")%>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_country_09")%>" />
          <label for="showSize"><%=cm.cmsText("sites_country_09")%></label>
          <%=cm.cmsTitle("sites_country_09")%>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("sites_country_10")%>" />
          <label for="showDesignationYear"><%=cm.cmsText("sites_country_10")%></label>
          <%=cm.cmsTitle("sites_country_10")%>
        </div>
        <img align="middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_mandatory")%>
        &nbsp;
        <label for="country">
          <strong>
            <%=cm.cmsText("sites_country_12")%>
          </strong>
          &nbsp;
        </label>
        <input id="country" name="country" type="text" size="30" class="inputTextField" title="<%=cm.cms("sites_country_12")%>" />
        <%=cm.cmsLabel("sites_country_12")%>
        <%=cm.cmsTitle("sites_country_12")%>
        &nbsp;
        <a title="<%=cm.cms("helper")%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>

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
    String pageName = "sites-country.jsp";
    String pageNameResult = "sites-country-result.jsp?"+Utilities.writeURLCriteriaSave(show);
    // Expand or not save criterias list
    String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
%>
      <br />
    <%=cm.cmsText("sites_country_15")%>
    <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-country.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
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

      <%=cm.cmsMsg("sites_country_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_country_02")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_country_03")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-country.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>