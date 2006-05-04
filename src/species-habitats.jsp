<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitat, show species' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.species.names.NameSearchCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.search.species.habitats.HabitateSearchCriteria,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.species.habitats.ScientificNameDomain"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" src="script/species-habitats-save-criteria.js" type="text/javascript"></script>
    <%
        WebContentManagement cm = SessionManager.getWebContent();
    %>
    <script language="JavaScript" type="text/javascript">
    <!--
     var errInvalidRegion = '<%=cm.cms("biogeographic_region_is_not_valid")%>';
      var errInvalidCountry = '<%=cm.cms("species_habitats_27")%>';
    function openHelper(URL)
    {
      document.eunis.scientificName.value = trim(document.eunis.scientificName.value);
      scientificName = document.eunis.scientificName.value;
      relationOp = document.eunis.relationOp.value;
      var database = document.eunis.database;
      var dat = 0;

      var searchAttribute = document.eunis.searchAttribute.value;
      // If selects attribute scientific name, validate the form for input.
      if (searchAttribute == <%=HabitateSearchCriteria.SEARCH_NAME%> && !validateForm()) {
        // Do nothing and return, form validation failed.
      } else {
        if (database != null)
        {
          if (database[0].checked == true) dat = 0; // EUNIS
          if (database[1].checked == true) dat = 1; // ANNEX I
          if (database[2].checked == true) dat = 2; // BOTH
        }
        URL2 = URL;
        URL2 += '?searchAttribute=' + searchAttribute;
        URL2 += '&scientificName=' + scientificName;
        URL2 += '&relationOp=' + relationOp;
        URL2 += '&database=' + dat;
        eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,resizable=no,location=0,width=400,height=500,left=500,top=0');");
      }
    }

    var errMessageForm = "<%=cm.cms("species_habitats_28")%>";

    function validateForm()
    {
      var  scientificName;
      scientificName = trim(document.eunis.scientificName.value);
      var criteriaType = document.getElementById("searchAttribute").options[document.getElementById("searchAttribute").selectedIndex].value;
      if (scientificName == "")
      {
        alert(errMessageForm);
        return false;
      }

      if(criteriaType == <%=HabitateSearchCriteria.SEARCH_COUNTRY%>)
      {
        // Check if country is a valid country
       if (!validateCountry('<%=Utilities.getCountryListString()%>',scientificName))
       {
         alert(errInvalidCountry);
         return false;
       }
     }

      if(criteriaType == <%=HabitateSearchCriteria.SEARCH_REGION%>)
      {
        // Check if region is a valid region
       if (!validateRegion('<%=Utilities.getRegionListString()%>',scientificName))
       {
         alert(errInvalidRegion);
         return false;
       }
     }
      return true;
    }
    //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("pick_habitat_types_show_species")%>
    </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home#index.jsp,habitat_types#habitats.jsp,pick_habitat_type_show_species_location" />
      <jsp:param name="helpLink" value="habitats-help.jsp" />
    </jsp:include>
      <h1>
            <%=cm.cmsText("species_habitats_01")%>
      </h1>
      <form name="eunis" method="get" onsubmit="return validateForm();" action="species-habitats-result.jsp">
      <table summary="layout" width="100%" border="0">
        <tr>
          <td>
            <input type="hidden" name="typeForm" value="<%=NameSearchCriteria.CRITERIA_SCIENTIFIC%>" />
            <%=cm.cmsText("species_habitats_25")%>
            <br />
            <br />
            <div class="grey_rectangle">
              <strong>
                <%=cm.cmsText("search_will_provide_2")%>
              </strong>
              <br />
              <input title="<%=cm.cms("group")%>" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" />
                <label for="checkbox1"><%=cm.cmsText("group")%></label>
                <%=cm.cmsTitle("group")%>
              <input title="<%=cm.cms("order_column")%>" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" />
                <label for="checkbox2"><%=cm.cmsText("order_column")%></label>
                <%=cm.cmsTitle("order_column")%>
              <input title="<%=cm.cms("family")%>" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" />
                <label for="checkbox3"><%=cm.cmsText("family")%></label>
                <%=cm.cmsTitle("family")%>
              <input title="<%=cm.cms("scientific_name")%>" id="checkbox4" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" />
                <label for="checkbox4"><%=cm.cmsText("species_scientific_name")%></label>
                <%=cm.cmsTitle("scientific_name")%>
              <input title="<%=cm.cms("habitat_types")%>" id="checkbox5" type="checkbox" name="showHabitats" value="true" checked="checked" disabled="disabled" />
                <label for="checkbox5"><%=cm.cmsText("habitat_types")%></label>
                <%=cm.cmsTitle("habitat_types")%>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <img title="<%=cm.cms("field_mandatory")%>" alt="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" /><%=cm.cmsAlt("field_mandatory")%>&nbsp;
            <label for="select1" class="noshow"><%=cm.cms("search_attribute")%></label>
            <select id="select1" title="<%=cm.cms("search_attribute")%>" name="searchAttribute" class="inputTextField">
              <option value="<%=HabitateSearchCriteria.SEARCH_NAME%>" selected="selected"><%=cm.cms("name_or_description")%></option>
              <option value="<%=HabitateSearchCriteria.SEARCH_CODE%>"><%=cm.cms("habitat_type_code")%></option>
              <option value="<%=HabitateSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>"><%=cm.cms("legal_instrument_name")%></option>
              <option value="<%=HabitateSearchCriteria.SEARCH_COUNTRY%>"><%=cm.cms("country_name")%></option>
              <option value="<%=HabitateSearchCriteria.SEARCH_REGION%>"><%=cm.cms("biogeographic_region_name")%></option>
            </select>
            <%=cm.cmsLabel("search_attribute")%>
            <%=cm.cmsTitle("search_attribute")%>
            &nbsp;
            <label for="select2" class="noshow"><%=cm.cms("operator")%></label>
            <select id="select2" title="<%=cm.cms("operator")%>" name="relationOp" class="inputTextField">
              <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("is")%></option>
              <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("contains")%></option>
              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("starts_with")%></option>
            </select>
            <label for="scientificName" class="noshow"><%=cm.cms("scientific_name")%></label>
            <input alt="<%=cm.cms("scientific_name")%>" size="32" id="scientificName" name="scientificName" value="" class="inputTextField" title="<%=cm.cms("habitat_type_name")%>" />
            <%=cm.cmsLabel("scientific_name")%>
            <%=cm.cmsAlt("scientific_name")%>
            <%=cm.cmsTitle("habitat_type_name")%>
            <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-habitats-choice.jsp')"><img alt="<%=cm.cms("species_habitats_17")%>" height="18" title="<%=cm.cms("species_habitats_17")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
              <%=cm.cmsTitle("list_of_values")%>
              <%=cm.cmsAlt("species_habitats_17")%>
          </td>
        </tr>
        <tr>
          <td style="text-align:left;background-color:#EEEEEE">
            <%=cm.cmsText("select_database")%>: &nbsp;
            <input id="radio1" type="radio" name="database" value="<%=ScientificNameDomain.SEARCH_EUNIS%>" checked="checked"
               title="<%=cm.cms("habitat_type_eunis")%>" /><label for="radio1"><%=cm.cmsText("eunis_habitat_types")%></label><%=cm.cmsTitle("habitat_type_eunis")%>&nbsp;&nbsp;
            <input id="radio2" type="radio" name="database" value="<%=ScientificNameDomain.SEARCH_ANNEX_I%>"
               title="<%=cm.cms("habitat_type_annexI")%>" /><label for="radio2"><%=cm.cmsText("habitat_directive_annex_1")%></label><%=cm.cmsTitle("habitat_type_annexI")%>&nbsp;
            <input id="radio3" type="radio" name="database" value="<%=ScientificNameDomain.SEARCH_BOTH%>"
               title="<%=cm.cms("habitat_type_both")%>" /><label for="radio3"><%=cm.cmsText("both")%><%=cm.cmsTitle("habitat_type_both")%></label>
          </td>
        </tr>
        <tr>
          <td style="text-align:right">
            <input id="Reset" type="reset" value="<%=cm.cms("reset")%>" name="Reset" class="inputTextField" title="<%=cm.cms("reset")%>" />
            <%=cm.cmsTitle("reset")%>
            <%=cm.cmsInput("reset")%>
            <input id="Search" type="submit" value="<%=cm.cms("search")%>" name="submit2" class="inputTextField" title="<%=cm.cms("search")%>" />
            <%=cm.cmsTitle("search")%>
            <%=cm.cmsInput("search")%>
          </td>
        </tr>
       </table>
     </form>
    <br />
    <strong>
      <%=cm.cmsText("might_take_long_time")%>
    </strong>
    <br />

<%
  // Save search criteria
  if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
  {
%>
           <script type="text/javascript" language="JavaScript">
           <!--
           // values of source and database constants from specific class Domain
           var source1='';
           var source2='';
           var database1='<%=ScientificNameDomain.SEARCH_EUNIS%>';
           var database2='<%=ScientificNameDomain.SEARCH_ANNEX_I%>';
           var database3='<%=ScientificNameDomain.SEARCH_BOTH%>';
          //-->
          </script>
          <br />
          <%=cm.cmsText("save_your_criteria")%>:
          <a title="<%=cm.cms("save_open_link")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-habitats.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_open_link")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
          <%=cm.cmsTitle("save_open_link")%>
    <%
              // Set Vector for URL string
              Vector show = new Vector();
              show.addElement("showGroup");
              show.addElement("showOrder");
              show.addElement("showScientificName");
              show.addElement("showFamily");
              show.addElement("showHabitats");
              String pageName = "species-habitats.jsp";
              String pageNameResult = "species-habitats-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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

<%=cm.br()%>
<%=cm.cmsMsg("biogeographic_region_is_not_valid")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_habitats_27")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_habitats_28")%>
<%=cm.br()%>
<%=cm.cmsMsg("pick_habitat_types_show_species")%>
<%=cm.br()%>
<%=cm.cmsMsg("name_or_description")%>
<%=cm.br()%>
<%=cm.cmsMsg("habitat_type_code")%>
<%=cm.br()%>
<%=cm.cmsMsg("legal_instrument_name")%>
<%=cm.br()%>
<%=cm.cmsMsg("country_name")%>
<%=cm.br()%>
<%=cm.cmsMsg("biogeographic_region_name")%>
<%=cm.br()%>
<%=cm.cmsMsg("is")%>
<%=cm.br()%>
<%=cm.cmsMsg("contains")%>
<%=cm.br()%>
<%=cm.cmsMsg("starts_with")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-habitats.jsp" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>