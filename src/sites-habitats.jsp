<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick habitat types, show sites" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.sites.habitats.HabitatDomain,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.habitats.HabitatSearchCriteria"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement cm = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
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
      <%=cm.cms("sites_habitats_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,habitats_location#habitats.jsp,sites_habitats_location"/>
        <jsp:param name="mapLink" value="show"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="return validateForm();" action="sites-habitats-result.jsp">
        <h1>
          <%=cm.cmsText("sites_habitats_01")%>
        </h1>

        <%=cm.cmsText("sites_habitats_24")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=cm.cmsText("search_will_provide_following_information")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_habitats_03")%>" />
          <label for="showSourceDB"><%=cm.cmsText("sites_habitats_03")%></label>
          <%=cm.cmsTitle("sites_habitats_03")%>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_habitats_04")%>" />
          <label for="showDesignationTypes"><%=cm.cmsText("sites_habitats_04")%></label>
          <%=cm.cmsTitle("sites_habitats_04")%>

          <input id="showSiteCode" name="showSiteCode" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_habitats_codecolumn")%>" />
          <label for="showSiteCode"><%=cm.cmsText("sites_habitats_codecolumn")%></label>
          <%=cm.cmsTitle("sites_habitats_codecolumn")%>

          <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_habitats_05")%>" />
          <label for="showName"><%=cm.cmsText("sites_habitats_05")%></label>
          <%=cm.cmsTitle("sites_habitats_05")%>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" title="<%=cm.cms("sites_habitats_06")%>" />
          <label for="showCoordinates"><%=cm.cmsText("sites_habitats_06")%></label>
          <%=cm.cmsTitle("sites_habitats_06")%>

          <input id="showHabitat" name="showHabitat" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_habitats_07")%>" />
          <label for="showHabitat"><%=cm.cmsText("sites_habitats_07")%></label>
          <%=cm.cmsTitle("sites_habitats_07")%>
        </div>
        <img align="middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_mandatory")%>
        <label for="searchAttribute" class="noshow"><%=cm.cms("search_attribute")%></label>
        <select id="searchAttribute" name="searchAttribute" class="inputTextField" title="<%=cm.cms("search_attribute")%>">
          <option value="<%=HabitatSearchCriteria.SEARCH_NAME%>" selected="selected">
            <%=cm.cms("sites_habitats_08")%>
          </option>
          <option value="<%=HabitatSearchCriteria.SEARCH_CODE%>">
            <%=cm.cms("sites_habitats_09")%>
          </option>
          <option value="<%=HabitatSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>">
            <%=cm.cms("sites_habitats_10")%>
          </option>
          <option value="<%=HabitatSearchCriteria.SEARCH_COUNTRY%>">
            <%=cm.cms("sites_habitats_11")%>
          </option>
          <option value="<%=HabitatSearchCriteria.SEARCH_REGION%>">
            <%=cm.cms("sites_habitats_12")%>
          </option>
        </select>
        <%=cm.cmsLabel("search_attribute")%>
        <%=cm.cmsTitle("search_attribute")%>
        <%=cm.cmsInput("sites_habitats_08")%>
        <%=cm.cmsInput("sites_habitats_09")%>
        <%=cm.cmsInput("sites_habitats_10")%>
        <%=cm.cmsInput("sites_habitats_11")%>
        <%=cm.cmsInput("sites_habitats_12")%>
        &nbsp;
        <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
        <select id="relationOp" name="relationOp" class="inputTextField" title="<%=cm.cms("operator")%>">
          <option value="<%=Utilities.OPERATOR_IS%>">
            <%=cm.cms("sites_habitats_13")%>
          </option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>">
            <%=cm.cms("sites_habitats_14")%>
          </option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
            <%=cm.cms("sites_habitats_15")%>
          </option>
        </select>
        <%=cm.cmsLabel("operator")%>
        <%=cm.cmsTitle("operator")%>
        <%=cm.cmsInput("sites_habitats_13")%>
        <%=cm.cmsInput("sites_habitats_14")%>
        <%=cm.cmsInput("sites_habitats_15")%>
        <label for="searchString" class="noshow"><%=cm.cms("search_string")%></label>
        <input id="searchString" name="searchString" value="" size="32" class="inputTextField" title="<%=cm.cms("search_string")%>" />
        <%=cm.cmsLabel("search_string")%>
        <%=cm.cmsTitle("search_string")%>
        <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-habitats-choice.jsp');"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
        <div class="grey_rectangle">
          <%=cm.cmsText("sites_habitats_17")%>
          <input id="database1" name="database" type="radio" value="<%=HabitatDomain.SEARCH_EUNIS%>" checked="checked" title="<%=cm.cms("sites_habitats_18")%>" />
          <label for="database1"><%=cm.cmsText("sites_habitats_18")%></label>
          <%=cm.cmsTitle("sites_habitats_18")%>

          <input id="database2" name="database" type="radio" value="<%=HabitatDomain.SEARCH_ANNEX_I%>" disabled="disabled" title="<%=cm.cms("sites_habitats_19")%>" />
          <label for="database2"><%=cm.cmsText("sites_habitats_19")%></label>
          <%=cm.cmsTitle("sites_habitats_19")%>

          <input id="database3" name="database" type="radio" value="<%=HabitatDomain.SEARCH_BOTH%>" disabled="disabled" title="<%=cm.cms("sites_habitats_20")%>" />
          <label for="database3"><%=cm.cmsText("sites_habitats_20")%></label>
          <%=cm.cmsTitle("sites_habitats_20")%>
        </div>
        <div class="submit_buttons">
          <label for="reset" class="noshow"><%=cm.cms("reset_btn_label")%></label>
          <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset_btn_value")%>" class="inputTextField" title="<%=cm.cms("reset_btn_title")%>" />
          <%=cm.cmsLabel("reset_btn_label")%>
          <%=cm.cmsTitle("reset_btn_title")%>
          <%=cm.cmsInput("reset_btn_value")%>

          <label for="submit2" class="noshow"><%=cm.cms("search_btn_label")%></label>
          <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=cm.cms("search_btn_value")%>" title="<%=cm.cms("search_btn_title")%>" />
          <%=cm.cmsLabel("search_btn_label")%>
          <%=cm.cmsTitle("search_btn_title")%>
          <%=cm.cmsInput("search_btn_value")%>
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
    <%=cm.cmsText("sites_habitats_23")%>
    <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-habitats.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
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

      <%=cm.cmsMsg("sites_habitats_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-habitats.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
