<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick species, show sites" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.species.SpeciesSearchCriteria"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,sites_species_location";
%>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-species-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        function validateForm()
        {
          document.eunis.searchString.value = trim(document.eunis.searchString.value);
          var searchString = document.eunis.searchString.value;
          if (searchString == "") {
            alert("<%=cm.cms("sites_species_02")%>");
            return false;
          }
          return checkValidSelection();
        }

        function openHelper(URL) {
          document.eunis.searchString.value = trim(document.eunis.searchString.value);
          var searchString = document.eunis.searchString.value;
          var relationOp = escape(document.eunis.relationOp.value);
          var searchAttribute = document.eunis.searchAttribute.value;
          // If selects attribute scientific name, validate the form for input.
          if ((searchAttribute == <%=SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME%> ||
              searchAttribute == <%=SpeciesSearchCriteria.SEARCH_VERNACULAR%>))
          {
                document.eunis.searchString.value = trim(document.eunis.searchString.value);
                var searchString = document.eunis.searchString.value;
                if (searchString == "")
                {
                  alert("<%=cm.cms("sites_species_02")%>");
                } else
                {
                    var DB_NATURA2000 = false;
                    var DB_CORINE = false;
                    var DB_DIPLOMA = false;
                    var DB_CDDA_NATIONAL = false;
                    var DB_CDDA_INTERNATIONAL = false;
                    var DB_BIOGENETIC = false;
                    var DB_EMERALD = false;

                    if (document.eunis.DB_NATURA2000.checked == true) DB_NATURA2000 = true;
                    if (document.eunis.DB_CORINE.checked == true) DB_CORINE = true;
                    if (document.eunis.DB_DIPLOMA.checked == true) DB_DIPLOMA = true;
                    if (document.eunis.DB_CDDA_NATIONAL.checked == true) DB_CDDA_NATIONAL = true;
                    if (document.eunis.DB_CDDA_INTERNATIONAL.checked == true) DB_CDDA_INTERNATIONAL = true;
                    if (document.eunis.DB_BIOGENETIC.checked == true) DB_BIOGENETIC = true;
                    if (document.eunis.DB_EMERALD.checked == true) DB_EMERALD = true;

                    URL2 = URL + "?searchString=" + searchString;
                    URL2 = URL2 + "&searchAttribute=" + searchAttribute;
                    URL2 = URL2 + "&relationOp=" + relationOp;

                    URL2 += "&DB_NATURA2000=" + DB_NATURA2000;
                    URL2 += "&DB_CORINE=" + DB_CORINE;
                    URL2 += "&DB_DIPLOMA=" + DB_DIPLOMA;
                    URL2 += "&DB_CDDA_NATIONAL=" + DB_CDDA_NATIONAL;
                    URL2 += "&DB_CDDA_INTERNATIONAL=" + DB_CDDA_INTERNATIONAL;
                    URL2 += "&DB_BIOGENETIC=" + DB_BIOGENETIC;
                    URL2 += "&DB_EMERALD=" + DB_EMERALD;

                    eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,resizable=no,location=0,width=400,height=500,left=500,top=0');");
          }
          }
        }
      //]]>
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("pick_species_show_sites")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
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
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                    <li>
                      <a href="species-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" onsubmit="return(validateForm());" action="sites-species-result.jsp">
                  <input type="hidden" name="source" value="sitename" />
                  <h1>
                    <%=cm.cmsPhrase("Pick species, show sites")%>
                  </h1>
                  <%=cm.cmsPhrase("Search sites with species <br />(ex.: sites which are related to <strong>Acrocephalus paludicola</strong>)")%>
                  <br />
                  <br />
                  <div class="grey_rectangle">
                    <strong>
                      <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed)")%>
                    </strong>
                    <br />
                    <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set")%>" />
                    <label for="showSourceDB"><%=cm.cmsPhrase("Source data set")%></label>
                    <%=cm.cmsTitle("source_data_set")%>

                    <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("designation_type")%>" />
                    <label for="showDesignationTypes"><%=cm.cmsPhrase("Designation type")%></label>
                    <%=cm.cmsTitle("designation_type")%>

                    <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("site_name")%>" />
                    <label for="showName"><%=cm.cmsPhrase("Site name")%></label>
                    <%=cm.cmsTitle("site_name")%>

                    <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" title="<%=cm.cms("coordinates")%>" />
                    <label for="showCoordinates"><%=cm.cmsPhrase("Coordinates")%></label>
                    <%=cm.cmsTitle("coordinates")%>

                    <input id="showSpecies" name="showSpecies" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("species_scientific_name")%>" />
                    <label for="showSpecies"><%=cm.cmsPhrase("Species scientific name")%></label>
                    <%=cm.cmsTitle("species_scientific_name")%>
                  </div>
                  <img style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
                  <%=cm.cmsAlt("field_mandatory")%>
                  <label for="searchAttribute" class="noshow"><%=cm.cms("criteria")%></label>
                  <select id="searchAttribute" name="searchAttribute" title="<%=cm.cms("criteria")%>">
                    <option value="<%=SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME%>" selected="selected">
                      <%=cm.cms("species_scientific_name")%>
                    </option>
                    <option value="<%=SpeciesSearchCriteria.SEARCH_GROUP%>">
                      <%=cm.cms("species_group")%>
                    </option>
                    <option value="<%=SpeciesSearchCriteria.SEARCH_VERNACULAR%>">
                      <%=cm.cms("species_vernacular_name")%>
                    </option>
                    <option value="<%=SpeciesSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>">
                      <%=cm.cms("legal_instrument_name")%>
                    </option>
                    <option value="<%=SpeciesSearchCriteria.SEARCH_COUNTRY%>">
                      <%=cm.cms("country_name")%>
                    </option>
                    <option value="<%=SpeciesSearchCriteria.SEARCH_REGION%>">
                      <%=cm.cms("biogeographic_region_name")%>
                    </option>
                  </select>
                  <%=cm.cmsTitle("criteria")%>
                  <%=cm.cmsLabel("criteria")%>
                  <%=cm.cmsInput("species_scientific_name")%>
                  <%=cm.cmsInput("species_group")%>
                  <%=cm.cmsInput("species_vernacular_name")%>
                  <%=cm.cmsInput("legal_instrument_name")%>
                  <%=cm.cmsInput("country_name")%>
                  <%=cm.cmsInput("biogeographic_region_name")%>
                  &nbsp;
                  <select id="relationOp" name="relationOp" title="<%=cm.cms("operator")%>">
                    <option value="<%=Utilities.OPERATOR_IS%>">
                      <%=cm.cms("is")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                      <%=cm.cms("contains")%>
                    </option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
                      <%=cm.cms("starts_with")%>
                    </option>
                  </select>
                  <%=cm.cmsLabel("operator")%>
                  <%=cm.cmsTitle("operator")%>
                  <%=cm.cmsInput("is")%>
                  <%=cm.cmsInput("contains")%>
                  <%=cm.cmsInput("starts_with")%>
                  <label for="searchString" class="noshow"><%=cm.cms("search_string")%></label>
                  <input id="searchString" name="searchString" value="" size="32" title="<%=cm.cms("search_string")%>" />
                  <%=cm.cmsLabel("search_string")%>
                  <%=cm.cmsTitle("search_string")%>
                  <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-species-choice.jsp')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
                  <div class="submit_buttons">
                    <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset")%>" class="standardButton" title="<%=cm.cms("reset_values")%>" />
                    <%=cm.cmsTitle("reset_values")%>
                    <%=cm.cmsInput("reset")%>

                    <input id="submit2" name="submit2" type="submit" class="searchButton" value="<%=cm.cms("search")%>" title="<%=cm.cms("search")%>" />
                    <%=cm.cmsTitle("search")%>
                    <%=cm.cmsInput("search")%>
                  </div>
                  <jsp:include page="sites-search-common.jsp" />
                </form>
          <%
            // Save search criteria
            if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
            {
          %>
                <br />
                <%=cm.cmsPhrase("Save your criteria:")%>
                <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-species.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                <%=cm.cmsTitle("save")%>
                <%=cm.cmsAlt("save")%>
          <%
              // Set Vector for URL string
              Vector show = new Vector();
              show.addElement("showSourceDB");
              show.addElement("showDesignationTypes");
              show.addElement("showName");
              show.addElement("showCoordinates");
              show.addElement("showSpecies");

              String pageName = "sites-species.jsp";
              String pageNameResult = "sites-species-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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

                <%=cm.cmsMsg("pick_species_show_sites")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("sites_species_02")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="sites-species.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
