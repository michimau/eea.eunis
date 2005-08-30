<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick habitat types, show sites" function - search page.
--%>
<%@ page import="ro.finsiel.eunis.jrfTables.sites.habitats.HabitatDomain,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.habitats.HabitatSearchCriteria"%>
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
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-habitats.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-habitats-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
    var errInvalidRegion = "Biogeographic regions is not valid, please use helper to find biogeographic regions";
    function validateForm()
    {
      document.eunis.searchString.value = trim(document.eunis.searchString.value);
      var searchString = document.eunis.searchString.value;
      var criteriaType = document.getElementById("searchAttribute").options[document.getElementById("searchAttribute").selectedIndex].value;
      if (searchString == "")
      {
        alert('Search criteria is mandatory.'); // From sites-habitats.js
        return false;
      }

       if(criteriaType == <%=HabitatSearchCriteria.SEARCH_COUNTRY%>)
      {
        // Check if country is a valid country
       if (!validateCountry('<%=Utilities.getCountryListString()%>',searchString))
       {
         alert(errInvalidCountry);
         return false;
       }
     }

      if(criteriaType == <%=HabitatSearchCriteria.SEARCH_REGION%>)
      {
        // Check if region is a valid region
       if (!validateRegion('<%=Utilities.getRegionListString()%>',searchString))
       {
         alert(errInvalidRegion);
         return false;
       }
     }
      return true;
    }

    function openHelper(URL)
    {
      document.eunis.searchAttribute.value = trim(document.eunis.searchAttribute.value);
      var searchAttribute = document.eunis.searchAttribute.value;
      var relationOp = escape(document.eunis.relationOp.value);
      if (searchAttribute == <%=HabitatSearchCriteria.SEARCH_NAME%> && !validateForm())
      {
        // Do nothing and return, form validation failed.
      } else {
        var db = <%=HabitatDomain.SEARCH_EUNIS%>;
        var database = document.eunis.database;
        var URL2 = URL;
        URL2 = URL2 + "?searchString=" + trim(document.eunis.searchString.value);
        URL2 = URL2 + "&searchAttribute=" + searchAttribute;
        if (database[0].checked == true) sr = <%=HabitatDomain.SEARCH_EUNIS%>; // EUNIS
        if (database[1].checked == true) sr = <%=HabitatDomain.SEARCH_ANNEX_I%>; // ANNEX I
        if (database[2].checked == true) sr = <%=HabitatDomain.SEARCH_BOTH%>; // BOTH

        URL2 = URL2 + "&database=" + db;
        eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
      }
    }
    //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("sites_habitats_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Pick habitat type show sites"/>
        <jsp:param name="mapLink" value="show"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="return validateForm();" action="sites-habitats-result.jsp">
        <h5>
          <%=contentManagement.getContent("sites_habitats_01")%>
        </h5>

        <%=contentManagement.getContent("sites_habitats_24")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=contentManagement.getContent("sites_habitats_02")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_habitats_03", false )%>" />
          <label for="showSourceDB"><%=contentManagement.getContent("sites_habitats_03")%></label>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_habitats_04", false )%>" />
          <label for="showDesignationTypes"><%=contentManagement.getContent("sites_habitats_04")%></label>

          <input id="showSiteCode" name="showSiteCode" type="checkbox" value="true" checked="checked" title="Site code" />
          <label for="showSiteCode">Site code</label>

          <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=contentManagement.getContent("sites_habitats_05", false )%>" />
          <label for="showName"><%=contentManagement.getContent("sites_habitats_05")%></label>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" title="<%=contentManagement.getContent("sites_habitats_06", false )%>" />
          <label for="showCoordinates"><%=contentManagement.getContent("sites_habitats_06")%></label>

          <input id="showHabitat" name="showHabitat" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=contentManagement.getContent("sites_habitats_07", false )%>" />
          <label for="showHabitat"><%=contentManagement.getContent("sites_habitats_07")%></label>
        </div>
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <label for="searchAttribute" class="noshow">Search attribute</label>
        <select id="searchAttribute" name="searchAttribute" class="inputTextField" title="Search attribute">
          <option value="<%=HabitatSearchCriteria.SEARCH_NAME%>" selected="selected"><%=contentManagement.getContent("sites_habitats_08", false)%></option>
          <option value="<%=HabitatSearchCriteria.SEARCH_CODE%>"><%=contentManagement.getContent("sites_habitats_09", false)%></option>
          <option value="<%=HabitatSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>"><%=contentManagement.getContent("sites_habitats_10", false)%></option>
          <option value="<%=HabitatSearchCriteria.SEARCH_COUNTRY%>"><%=contentManagement.getContent("sites_habitats_11", false)%></option>
          <option value="<%=HabitatSearchCriteria.SEARCH_REGION%>"><%=contentManagement.getContent("sites_habitats_12", false)%></option>
        </select>&nbsp;
        <label for="relationOp" class="noshow">Operator</label>
        <select id="relationOp" name="relationOp" class="inputTextField" title="Operator">
          <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("sites_habitats_13", false)%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("sites_habitats_14", false)%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("sites_habitats_15", false)%></option>
        </select>
        <label for="searchString" class="noshow">Filter value</label>
        <input id="searchString" name="searchString" value="" size="32" class="inputTextField" title="Filter value" />
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:openHelper('sites-habitats-choice.jsp');"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <div class="grey_rectangle">
          <%=contentManagement.getContent("sites_habitats_17")%>
          <input id="database1" name="database" type="radio" value="<%=HabitatDomain.SEARCH_EUNIS%>" checked="checked" title="<%=contentManagement.getContent("sites_habitats_18", false )%>" />
          <label for="database1"><%=contentManagement.getContent("sites_habitats_18")%></label>

          <input id="database2" name="database" type="radio" value="<%=HabitatDomain.SEARCH_ANNEX_I%>" disabled="disabled" title="<%=contentManagement.getContent("sites_habitats_19", false )%>" />
          <label for="database2"><%=contentManagement.getContent("sites_habitats_19")%></label>

          <input id="database3" name="database" type="radio" value="<%=HabitatDomain.SEARCH_BOTH%>" disabled="disabled" title="<%=contentManagement.getContent("sites_habitats_20", false )%>" />
          <label for="database3"><%=contentManagement.getContent("sites_habitats_20")%></label>
        </div>
          <div class="submit_buttons">
            <label for="reset" class="noshow">Reset values</label>
            <input id="reset" name="Reset" type="reset" value="<%=contentManagement.getContent("sites_habitats_21", false )%>" class="inputTextField" title="Reset values" />
            <%=contentManagement.writeEditTag("sites_habitats_21")%>
            <label for="submit2" class="noshow">Search</label>
            <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=contentManagement.getContent("sites_habitats_22", false)%>" title="Search" />
            <%=contentManagement.writeEditTag("sites_habitats_22")%>
          </div>
        </form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
  {
    // Set Vector for URL string
    Vector show = new Vector();
    show.addElement("showSourceDB");
    show.addElement("showDesignationTypes");
    show.addElement("showName");
    show.addElement("showCoordinates");
    show.addElement("showHabitat");

    String pageName = "sites-habitats.jsp";
    String pageNameResult = "sites-habitats-result.jsp?"+Utilities.writeURLCriteriaSave(show);
    // Expand or not save criterias list
    String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
%>
        <br />
    <%=contentManagement.getContent("sites_habitats_23")%>
    <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-habitats.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
<%
  }
%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-habitats.jsp" />
      </jsp:include>
    </div>
  </body>
</html>
