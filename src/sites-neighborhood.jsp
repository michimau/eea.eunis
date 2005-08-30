<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites neighborhood" function - search page.
--%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<%@page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_neighborhoods_title", false )%></title>
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
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
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Neighborhood"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" action="sites-neighborhood-result.jsp" onsubmit="return validateForm();">
        <input type="hidden" name="showName" value="true" />
        <input type="hidden" name="showDesignationYear" value="true" />
        <h5>
          <%=contentManagement.getContent("sites_neighborhoods_01")%>
        </h5>

        <%=contentManagement.getContent("sites_neighborhoods_20")%>
        <br />
        <%=contentManagement.getContent("sites_neighborhoods_21")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=contentManagement.getContent("sites_neighborhoods_02")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_neighborhoods_03", false )%>" />
          <label for="showSourceDB"><%=contentManagement.getContent("sites_neighborhoods_03")%></label>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_neighborhoods_04", false )%>" />
          <label for="showCountry"><%=contentManagement.getContent("sites_neighborhoods_04")%></label>

          <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=contentManagement.getContent("sites_neighborhoods_06", false )%>" />
          <label for="showName"><%=contentManagement.getContent("sites_neighborhoods_06")%></label>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_neighborhoods_05", false )%>" />
          <label for="showDesignationTypes"><%=contentManagement.getContent("sites_neighborhoods_05")%></label>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_neighborhoods_07", false )%>" />
          <label for="showCoordinates"><%=contentManagement.getContent("sites_neighborhoods_07")%></label>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_neighborhoods_08", false )%>" />
          <label for="showSize"><%=contentManagement.getContent("sites_neighborhoods_08")%></label>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_neighborhoods_09", false )%>" />
          <label for="showDesignationYear"><%=contentManagement.getContent("sites_neighborhoods_09")%></label>
        </div>
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_neighborhoods_06")%>
        </strong>&nbsp;
        <label for="relationOp" class="noshow">Operator</label>
        <select id="relationOp" name="relationOp" class="inputTextField" title="Operator">
          <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("sites_neighborhoods_10", false)%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("sites_neighborhoods_11", false)%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("sites_neighborhoods_12", false)%></option>
        </select>
        <label for="englishName" class="noshow">Search string</label>
        <input id="englishName" name="englishName" size="32" class="inputTextField" title="Search string" />&nbsp;
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:openHelper('sites-names-choice.jsp');"><img align="middle" width="11" height="18" src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" border="0" /></a>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <strong><%=contentManagement.getContent("sites_neighborhoods_14")%>&nbsp;&nbsp;</strong>
        <label for="country" class="noshow">Country name</label>
        <input id="country" name="country" type="text" size="30" class="inputTextField" title="Country" />&nbsp;
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_neighborhoods_15")%>&nbsp;
        </strong>
        <label for="yearMin" class="noshow">Minimum designation year</label>
        <input id="yearMin" name="yearMin" type="text" maxlength="4" size="4" class="inputTextField" title="Minimum designation year" />
        <%=contentManagement.getContent("sites_neighborhoods_16")%>
        <label for="yearMax" class="noshow">Maximum designation year</label>
        <input id="yearMax" name="yearMax" type="text" maxlength="4" size="4" class="inputTextField" title="Maximum designation year" />
        <div class="submit_buttons">
          <label for="reset" class="noshow">Reset values</label>
          <input id="reset" name="Reset" type="reset" value="<%=contentManagement.getContent("sites_neighborhoods_17", false )%>" class="inputTextField" title="Reset values" />
          &nbsp;&nbsp;
          <%=contentManagement.writeEditTag( "sites_neighborhoods_17" )%>
          <label for="submit2" class="noshow">Search</label>
          <input id="submit2" name="submit2" type="submit" value="<%=contentManagement.getContent("sites_neighborhoods_18", false )%>" class="inputTextField" title="Search" />
          <%=contentManagement.writeEditTag( "sites_neighborhoods_18" )%>
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
      <%=contentManagement.getContent("sites_neighborhoods_19")%>
      <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-neighborhood.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
      <jsp:include page="show-criteria-search.jsp">
        <jsp:param name="pageName" value="<%=pageName%>" />
        <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
        <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
      </jsp:include>
<%
  }
%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-neighborhood.jsp" />
      </jsp:include>
    </div>
  </body>
</html>