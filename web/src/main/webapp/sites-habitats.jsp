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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,sites_habitats_location";
%>
    <script language="JavaScript" type="text/javascript" src="script/sites-habitats.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-habitats-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
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
        eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=450,height=500,left=490,top=0');");
      }
    }
    //]]>
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("pick_habitat_types_show_sites")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                  <jsp:param name="mapLink" value="show"/>
                </jsp:include>
                <a name="documentContent"></a>
                  <h1>
                    <%=cm.cmsPhrase("Pick habitat type, show sites")%>
                  </h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cmsPhrase("Print this page")%>"
                            title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cmsPhrase("Toggle full screen mode")%>"
                             title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                    </li>
                    <li>
                      <a href="sites-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cmsPhrase("Help information")%>"
                             title="<%=cm.cmsPhrase("Help information")%>" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" onsubmit="return validateForm();" action="sites-habitats-result.jsp">

                  <%=cm.cmsPhrase("Find sites containing a particular habitat type<br />(ex.: EUNIS habitat types <strong>Mires, bogs and fens</strong>)")%>
                  <br />
                  <br />
                  <div class="grey_rectangle">
                    <strong>
                      <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed)")%>
                    </strong>
                    <br />
                    <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set_2")%>" />
                    <label for="showSourceDB"><%=cm.cmsPhrase("Source data set&nbsp;")%></label>
                    <%=cm.cmsTitle("source_data_set_2")%>

                    <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("designation_type_1")%>" />
                    <label for="showDesignationTypes"><%=cm.cmsPhrase("Designation type &nbsp;")%></label>
                    <%=cm.cmsTitle("designation_type_1")%>

                    <input id="showSiteCode" name="showSiteCode" type="checkbox" value="true" checked="checked" title="<%=cm.cms("site_code")%>" />
                    <label for="showSiteCode"><%=cm.cmsPhrase("Site code")%></label>
                    <%=cm.cmsTitle("site_code")%>

                    <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("site_name_1")%>" />
                    <label for="showName"><%=cm.cmsPhrase("Site name &nbsp;")%></label>
                    <%=cm.cmsTitle("site_name_1")%>

                    <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" title="<%=cm.cms("coordinates_1")%>" />
                    <label for="showCoordinates"><%=cm.cmsPhrase("Coordinates &nbsp;")%></label>
                    <%=cm.cmsTitle("coordinates_1")%>

                    <input id="showHabitat" name="showHabitat" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_habitats_07")%>" />
                    <label for="showHabitat"><%=cm.cmsPhrase("Habitat types&nbsp;")%></label>
                    <%=cm.cmsTitle("sites_habitats_07")%>
                  </div>
                  <img style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                  <label for="searchAttribute" class="noshow"><%=cm.cms("search_attribute")%></label>
                  <select id="searchAttribute" name="searchAttribute" title="<%=cm.cms("search_attribute")%>">
                    <option value="<%=HabitatSearchCriteria.SEARCH_NAME%>" selected="selected">
                      <%=cm.cms("name_or_description")%>
                    </option>
                    <option value="<%=HabitatSearchCriteria.SEARCH_CODE%>">
                      <%=cm.cms("habitat_type_code")%>
                    </option>
                    <option value="<%=HabitatSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>">
                      <%=cm.cms("legal_instrument_name")%>
                    </option>
                    <option value="<%=HabitatSearchCriteria.SEARCH_COUNTRY%>">
                      <%=cm.cms("country_name")%>
                    </option>
                    <option value="<%=HabitatSearchCriteria.SEARCH_REGION%>">
                      <%=cm.cms("biogeographic_region_name")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("search_attribute")%>
                  <%=cm.cmsTitle("search_attribute")%>
                  <%=cm.cmsInput("name_or_description")%>
                  <%=cm.cmsInput("habitat_type_code")%>
                  <%=cm.cmsInput("legal_instrument_name")%>
                  <%=cm.cmsInput("country_name")%>
                  <%=cm.cmsInput("biogeographic_region_name")%>
                  &nbsp;
                  <select id="relationOp" name="relationOp" title="<%=cm.cmsPhrase("Operator")%>">
                    <option value="<%=Utilities.OPERATOR_IS%>">
                      <%=cm.cmsPhrase("is")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                      <%=cm.cmsPhrase("contains")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
                      <%=cm.cmsPhrase("starts with")%>
                    </option>
                  </select>
                  <label for="searchString" class="noshow"><%=cm.cms("search_string")%></label>
                  <input id="searchString" name="searchString" value="" size="32" title="<%=cm.cms("search_string")%>" />
                  <%=cm.cmsLabel("search_string")%>
                  <%=cm.cmsTitle("search_string")%>
                  <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-habitats-choice.jsp');"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <%=cm.cmsTitle("helper")%>
                  <%=cm.cmsAlt("helper")%>
                  <div class="grey_rectangle">
                    <%=cm.cmsPhrase("Select database: &nbsp;")%>
                    <input id="database1" name="database" type="radio" value="<%=HabitatDomain.SEARCH_EUNIS%>" checked="checked" title="<%=cm.cms("sites_habitats_18")%>" />
                    <label for="database1"><%=cm.cmsPhrase("EUNIS habitat types")%></label>
                    <%=cm.cmsTitle("sites_habitats_18")%>

                    <input id="database2" name="database" type="radio" value="<%=HabitatDomain.SEARCH_ANNEX_I%>" disabled="disabled" title="<%=cm.cms("sites_habitats_19")%>" />
                    <label for="database2"><%=cm.cmsPhrase("Habitat type Directive Annex I")%></label>
                    <%=cm.cmsTitle("sites_habitats_19")%>

                    <input id="database3" name="database" type="radio" value="<%=HabitatDomain.SEARCH_BOTH%>" disabled="disabled" title="<%=cm.cms("both")%>" />
                    <label for="database3"><%=cm.cmsPhrase("Both")%></label>
                    <%=cm.cmsTitle("both")%>
                  </div>
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
              <%=cm.cmsPhrase("Save your criteria:")%>
              <a title="<%=cm.cmsPhrase("Save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-habitats.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cmsPhrase("Save")%>" title="<%=cm.cmsPhrase("Save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
              <jsp:include page="show-criteria-search.jsp">
                <jsp:param name="pageName" value="<%=pageName%>" />
                <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
              </jsp:include>
          <%
            }
          %>

                <%=cm.cmsMsg("pick_habitat_types_show_sites")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="sites-habitats.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
