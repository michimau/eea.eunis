<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites names" function - search page.
--%>
<%@page contentType="text/html"%>
<%@ page import="java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.names.NameSortCriteria,
                 ro.finsiel.eunis.utilities.Accesibility,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.AbstractSortCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
  String siteNameFromFactsheet = (request.getParameter("siteNameFromFactsheet") == null ? "" : request.getParameter("siteNameFromFactsheet").trim());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
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
        }
      }
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_names_title", false )%>
    </title>
  </head>
  <body onload="functionOnLoad()">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Name"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form id="eunis" name="eunis" method="get" action="sites-names-result.jsp" onsubmit="return validateForm();">
        <input type="hidden" name="showName" value="true" />
        <input type="hidden" name="showDesignationYear" value="true" />
        <input type="hidden" name="sort" value="<%=NameSortCriteria.SORT_NAME%>" />
        <input type="hidden" name="ascendency" value="<%=AbstractSortCriteria.ASCENDENCY_ASC%>" />
        <input type="hidden" name="noSoundex" value="true" />
        <h5>
          <%=contentManagement.getContent("sites_names_01")%>
        </h5>
        <%=contentManagement.getContent("sites_names_21")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=contentManagement.getContent("sites_names_20")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_names_03", false )%>" />
          <label for="showSourceDB"><%=contentManagement.getContent("sites_names_03" )%></label>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_names_04", false )%>" />
          <label for="showCountry"><%=contentManagement.getContent("sites_names_04" )%></label>

          <input id="showName" name="showName" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_names_06", false )%>" />
          <label for="showName"><%=contentManagement.getContent("sites_names_06" )%></label>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_names_05", false )%>" />
          <label for="showDesignationTypes"><%=contentManagement.getContent("sites_names_05" )%></label>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_names_07", false )%>" />
          <label for="showCoordinates"><%=contentManagement.getContent("sites_names_07" )%></label>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_names_08", false )%>" />
          <label for="showSize"><%=contentManagement.getContent("sites_names_08")%></label>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_names_09", false )%>" />
          <label for="showDesignationYear"><%=contentManagement.getContent("sites_names_09")%></label>
        </div>
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_names_10")%>
        </strong>
        <label for="relationOp" class="noshow">Operator</label>
        <select id="relationOp" name="relationOp" class="inputTextField" title="Operator">
          <option value="<%=Utilities.OPERATOR_IS%>">
            <%=contentManagement.getContent("sites_names_13", false)%>
          </option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>">
            <%=contentManagement.getContent("sites_names_14", false)%>
          </option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
            <%=contentManagement.getContent("sites_names_15", false)%>
          </option>
        </select>
        <label for="englishName" class="noshow">Search term</label>
        <input id="englishName" name="englishName" size="32" class="inputTextField" value="<%=siteNameFromFactsheet%>" title="Search term" />
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:openHelper('sites-names-choice.jsp')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_names_11")%>
        </strong>
        <label for="country" class="noshow">Country</label>
        <input id="country" name="country" type="text" size="30" class="inputTextField" title="Country" />
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_names_12")%>
          <label for="yearMin" class="noshow">Minimum year</label>
          <input id="yearMin" name="yearMin" type="text" maxlength="4" size="4" class="inputTextField" title="Minimum year" />
          and
          <label for="yearMax" class="noshow">Maximum year</label>
          <input id="yearMax" name="yearMax" type="text" maxlength="4" size="4" class="inputTextField" title="Maximum year" />
        </strong>
        <div class="submit_buttons">
          <label for="reset" class="noshow">Reset values</label>
          <input type="reset" value="Reset" id="reset" name="Reset" title="Reset" class="inputTextField" />&nbsp;&nbsp;
          <label for="submit2" class="noshow">Search</label>
          <input type="submit" value="<%=contentManagement.getContent("sites_names_18", false)%>" id="submit2" name="Submit2" title="Search" class="inputTextField" />
          <%=contentManagement.writeEditTag( "sites_names_18" )%>
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
    <%=contentManagement.getContent("sites_names_19")%>
      <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-names.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
      <jsp:include page="show-criteria-search.jsp">
        <jsp:param name="pageName" value="<%=pageName%>" />
        <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
        <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
      </jsp:include>
<%
  }
%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-names.jsp" />
      </jsp:include>
    </div>
  </body>
</html>