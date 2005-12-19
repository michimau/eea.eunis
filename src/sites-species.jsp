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
<%
  // Web content manager used in this page.
  WebContentManagement cm = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-species-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
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
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_species_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,sites_species_location"/>
        <jsp:param name="helpLink" value="species-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="return(validateForm());" action="sites-species-result.jsp">
        <input type="hidden" name="source" value="sitename" />
        <h1>
          <%=cm.cmsText("sites_species_01")%>
        </h1>
        <%=cm.cmsText("sites_species_22")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=cm.cmsText("search_will_provide_following_information")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_species_04")%>" />
          <label for="showSourceDB"><%=cm.cmsText("sites_species_04")%></label>
          <%=cm.cmsTitle("sites_species_04")%>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_species_05")%>" />
          <label for="showDesignationTypes"><%=cm.cmsText("sites_species_05")%></label>
          <%=cm.cmsTitle("sites_species_05")%>

          <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_species_06")%>" />
          <label for="showName"><%=cm.cmsText("sites_species_06")%></label>
          <%=cm.cmsTitle("sites_species_06")%>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" title="<%=cm.cms("sites_species_07")%>" />
          <label for="showCoordinates"><%=cm.cmsText("sites_species_07")%></label>
          <%=cm.cmsTitle("sites_species_07")%>

          <input id="showSpecies" name="showSpecies" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_species_08")%>" />
          <label for="showSpecies"><%=cm.cmsText("sites_species_08")%></label>
          <%=cm.cmsTitle("sites_species_08")%>
        </div>
        <img align="middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_mandatory")%>
        <label for="searchAttribute" class="noshow"><%=cm.cms("criteria_type_label")%></label>
        <select id="searchAttribute" name="searchAttribute" class="inputTextField" title="<%=cm.cms("criteria_type_title")%>">
          <option value="<%=SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME%>" selected="selected">
            <%=cm.cms("sites_species_09")%>
          </option>
          <option value="<%=SpeciesSearchCriteria.SEARCH_GROUP%>">
            <%=cm.cms("sites_species_10")%>
          </option>
          <option value="<%=SpeciesSearchCriteria.SEARCH_VERNACULAR%>">
            <%=cm.cms("sites_species_11")%>
          </option>
          <option value="<%=SpeciesSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>">
            <%=cm.cms("sites_species_12")%>
          </option>
          <option value="<%=SpeciesSearchCriteria.SEARCH_COUNTRY%>">
            <%=cm.cms("sites_species_13")%>
          </option>
          <option value="<%=SpeciesSearchCriteria.SEARCH_REGION%>">
            <%=cm.cms("sites_species_14")%>
          </option>
        </select>
        <%=cm.cmsTitle("criteria_type_title")%>
        <%=cm.cmsLabel("criteria_type_label")%>
        <%=cm.cmsInput("sites_species_09")%>
        <%=cm.cmsInput("sites_species_10")%>
        <%=cm.cmsInput("sites_species_11")%>
        <%=cm.cmsInput("sites_species_12")%>
        <%=cm.cmsInput("sites_species_13")%>
        <%=cm.cmsInput("sites_species_14")%>
        &nbsp;
        <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
        <select id="relationOp" name="relationOp" class="inputTextField" title="<%=cm.cms("operator")%>">
          <option value="<%=Utilities.OPERATOR_IS%>">
            <%=cm.cms("sites_species_15")%>
          </option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>">
            <%=cm.cms("sites_species_16")%>
          </option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
            <%=cm.cms("sites_species_17")%>
          </option>
        </select>
        <%=cm.cmsLabel("operator")%>
        <%=cm.cmsTitle("operator")%>
        <%=cm.cmsInput("sites_species_15")%>
        <%=cm.cmsInput("sites_species_16")%>
        <%=cm.cmsInput("sites_species_17")%>
        <label for="searchString" class="noshow"><%=cm.cms("search_string")%></label>
        <input id="searchString" name="searchString" value="" size="32" class="inputTextField" title="<%=cm.cms("search_string")%>" />
        <%=cm.cmsLabel("search_string")%>
        <%=cm.cmsTitle("search_string")%>
        <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-species-choice.jsp')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
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
        <jsp:include page="sites-search-common.jsp" />
      </form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
  {
%>
      <br />
      <%=cm.cmsText("sites_species_21")%>
      <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-species.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
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

      <%=cm.cmsMsg("sites_species_title")%>
      <%=cm.br()%>
      <%=cm.cmsMsg("sites_species_02")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-species.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>