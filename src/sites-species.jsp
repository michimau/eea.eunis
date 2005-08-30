<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick species, show sites" function - search page.
--%>
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.sites.species.SpeciesSearchCriteria"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
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
            alert("<%=contentManagement.getContent("sites_species_02", false)%>");
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
                  alert("<%=contentManagement.getContent("sites_species_02", false)%>");
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
      <%=contentManagement.getContent("sites_species_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Pick species show sites"/>
        <jsp:param name="helpLink" value="species-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="return(validateForm());" action="sites-species-result.jsp">
        <input type="hidden" name="source" value="sitename" />
        <h5>
          <%=contentManagement.getContent("sites_species_01")%>
        </h5>
        <%=contentManagement.getContent("sites_species_22")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=contentManagement.getContent("sites_species_03")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_species_04", false )%>" />
          <label for="showSourceDB"><%=contentManagement.getContent("sites_species_04")%></label>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_species_05", false)%>" />
          <label for="showDesignationTypes"><%=contentManagement.getContent("sites_species_05")%></label>

          <input id="showName" name="showName" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=contentManagement.getContent("sites_species_06", false)%>" />
          <label for="showName"><%=contentManagement.getContent("sites_species_06")%></label>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" title="<%=contentManagement.getContent("sites_species_07", false)%>" />
          <label for="showCoordinates"><%=contentManagement.getContent("sites_species_07")%></label>

          <input id="showSpecies" name="showSpecies" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=contentManagement.getContent("sites_species_08", false)%>" />
          <label for="showSpecies"><%=contentManagement.getContent("sites_species_08")%></label>
        </div>
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <label for="searchAttribute" class="noshow">Criteria</label>
        <select id="searchAttribute" name="searchAttribute" class="inputTextField" title="Criteria">
          <option value="<%=SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME%>" selected="selected"><%=contentManagement.getContent("sites_species_09", false)%></option>
          <option value="<%=SpeciesSearchCriteria.SEARCH_GROUP%>"><%=contentManagement.getContent("sites_species_10", false)%></option>
          <option value="<%=SpeciesSearchCriteria.SEARCH_VERNACULAR%>"><%=contentManagement.getContent("sites_species_11", false)%></option>
          <option value="<%=SpeciesSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>"><%=contentManagement.getContent("sites_species_12", false)%></option>
          <option value="<%=SpeciesSearchCriteria.SEARCH_COUNTRY%>"><%=contentManagement.getContent("sites_species_13", false)%></option>
          <option value="<%=SpeciesSearchCriteria.SEARCH_REGION%>"><%=contentManagement.getContent("sites_species_14", false)%></option>
        </select>&nbsp;
        <label for="relationOp" class="noshow">Operator</label>
        <select id="relationOp" name="relationOp" class="inputTextField" title="Operator">
          <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("sites_species_15", false)%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("sites_species_16", false)%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("sites_species_17", false)%></option>
        </select>
        <label for="searchString" class="noshow">Search string</label>
        <input id="searchString" name="searchString" value="" size="32" class="inputTextField" title="Search string" />
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:openHelper('sites-species-choice.jsp')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <div class="submit_buttons">
          <label for="reset" class="noshow">Reset values</label>
          <input type="reset" value="<%=contentManagement.getContent("sites_species_19", false )%>" id="reset" name="Reset" class="inputTextField" title="Reset values" />
          <%=contentManagement.writeEditTag("sites_species_19")%>
          <label for="submit2" class="noshow">Search</label>
          <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=contentManagement.getContent("sites_species_20", false )%>" title="Search" />
          <%=contentManagement.writeEditTag("sites_species_20")%>
        </div>
        <jsp:include page="sites-search-common.jsp" />
      </form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
  {
%>
      <br />
      <%=contentManagement.getContent("sites_species_21")%>
      <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-species.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
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
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-species.jsp" />
      </jsp:include>
    </div>
  </body>
</html>