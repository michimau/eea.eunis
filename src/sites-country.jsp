<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites country" function - search page.
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
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-country.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-country-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
        function validateForm()
        {
          var errMessageForm = "<%=contentManagement.getContent("sites_country_02", false )%>";
          var errInvalidCountry = "<%=contentManagement.getContent("sites_country_03", false )%>";

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
      <%=contentManagement.getContent("sites_country_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Country"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="return validateForm();" action="sites-country-result.jsp">
        <input type="hidden" name="showName" value="true" />
        <input type="hidden" name="countryName" />
        <h5>
          <%=contentManagement.getContent("sites_country_01")%>
        </h5>

        <%=contentManagement.getContent("sites_country_16")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=contentManagement.getContent("sites_country_04")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_country_05", false )%>" />
          <label for="showSourceDB"><%=contentManagement.getContent("sites_country_05")%></label>

          <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=contentManagement.getContent("sites_country_07", false )%>" />
          <label for="showName"><%=contentManagement.getContent("sites_country_07")%></label>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_country_06", false )%>" />
          <label for="showDesignationTypes"><%=contentManagement.getContent("sites_country_06")%></label>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_country_08", false )%>" />
          <label for="showCoordinates"><%=contentManagement.getContent("sites_country_08")%></label>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_country_09", false )%>" />
          <label for="showSize"><%=contentManagement.getContent("sites_country_09")%></label>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_country_10", false )%>" />
          <label for="showDesignationYear"><%=contentManagement.getContent("sites_country_10")%></label>
        </div>
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        &nbsp;
        <label for="country"><strong><%=contentManagement.getContent("sites_country_12")%></strong>&nbsp;</label>
        <input id="country" name="country" type="text" size="30" class="inputTextField" title="Country" />
        &nbsp;
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <div class="submit_buttons">
          <label for="reset" class="noshow">Reset values</label>
          <input type="reset" value="<%=contentManagement.getContent("sites_country_13", false)%>" id="reset" name="Reset" class="inputTextField" title="Reset values" />
          <%=contentManagement.writeEditTag("sites_country_13")%>
          &nbsp;
          <label for="submit" class="noshow">Search</label>
          <input type="submit" value="<%=contentManagement.getContent("sites_country_14", false)%>" id="submit" name="Submit" class="inputTextField" title="Search" />
          <%=contentManagement.writeEditTag("sites_country_14")%>
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
    <%=contentManagement.getContent("sites_country_15")%>
    <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-country.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
<%
  }
%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-country.jsp" />
      </jsp:include>
    </div>
  </body>
</html>