<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitat, show species' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.search.species.names.NameSearchCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.search.species.habitats.HabitateSearchCriteria,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.species.habitats.ScientificNameDomain"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" src="script/species-habitats-save-criteria.js" type="text/javascript"></script>
    <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
     var errInvalidRegion = 'Biogeographic regions is not valid, please use helper to find biogeographic regions';
      var errInvalidCountry = 'Countries is not valid, please use helper to find countries';
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

    var errMessageForm = "Search criteria is mandatory.";

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
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_habitats_title", false )%>
    </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Pick habitat type show species" />
      <jsp:param name="helpLink" value="habitats-help.jsp" />
    </jsp:include>
      <h5>
            <%=contentManagement.getContent("species_habitats_01")%>
      </h5>
      <form name="eunis" method="get" onsubmit="return validateForm();" action="species-habitats-result.jsp">
      <table summary="layout" width="100%" border="0">
        <tr>
          <td>
            <input type="hidden" name="typeForm" value="<%=NameSearchCriteria.CRITERIA_SCIENTIFIC%>" />
            <%=contentManagement.getContent("species_habitats_25")%>
            <br />
            <br />
            <div class="grey_rectangle">
              <strong>
                <%=contentManagement.getContent("species_habitats_02")%>
              </strong>
              <br />
              <input title="Group" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" /><label for="checkbox1"><%=contentManagement.getContent("species_habitats_03")%></label>
              <input title="Order" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" /><label for="checkbox2"><%=contentManagement.getContent("species_habitats_04")%></label>
              <input title="Family" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" /><label for="checkbox3"><%=contentManagement.getContent("species_habitats_05")%></label>
              <input title="Scientific name" id="checkbox4" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" /><label for="checkbox4"><%=contentManagement.getContent("species_habitats_06")%></label>
              <input title="Habitats" id="checkbox5" type="checkbox" name="showHabitats" value="true" checked="checked" disabled="disabled" /><label for="checkbox5"><%=contentManagement.getContent("species_habitats_07")%></label>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <img title="Field mandatory" alt="Field mandatory" src="images/mini/field_mandatory.gif" />&nbsp;
            <label for="select1" class="noshow">Search attribute</label>
            <select id="select1" title="Search attribute" name="searchAttribute" class="inputTextField">
              <option value="<%=HabitateSearchCriteria.SEARCH_NAME%>" selected="selected"><%=contentManagement.getContent("species_habitats_09", false)%></option>
              <option value="<%=HabitateSearchCriteria.SEARCH_CODE%>"><%=contentManagement.getContent("species_habitats_10", false)%></option>
              <option value="<%=HabitateSearchCriteria.SEARCH_LEGAL_INSTRUMENTS%>"><%=contentManagement.getContent("species_habitats_11", false)%></option>
              <option value="<%=HabitateSearchCriteria.SEARCH_COUNTRY%>"><%=contentManagement.getContent("species_habitats_12", false)%></option>
              <option value="<%=HabitateSearchCriteria.SEARCH_REGION%>"><%=contentManagement.getContent("species_habitats_13", false)%></option>
            </select>
            &nbsp;
            <label for="select2" class="noshow">Operator</label>
            <select id="select2" title="Operator" name="relationOp" class="inputTextField">
              <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("species_habitats_14", false)%></option>
              <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("species_habitats_15", false)%></option>
              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("species_habitats_16", false)%></option>
            </select>
            <label for="scientificName" class="noshow">Scientific name</label>
            <input alt="Scientific name" size="32" id="scientificName" name="scientificName" value="" class="inputTextField" title="Habitat type name" />
            <a title="List of values. Link will open a new window." href="javascript:openHelper('species-habitats-choice.jsp')"><img alt="List of values" height="18" title="<%=contentManagement.getContent("species_habitats_17", false)%>" src="images/helper/helper.gif" width="11" border="0" /></a>
            <%=contentManagement.writeEditTag("species_habitats_17",false)%>
          </td>
        </tr>
        <tr>
          <td style="text-align:left;background-color:#EEEEEE">
            <%=contentManagement.getContent("species_habitats_18")%>: &nbsp;
            <input id="radio1" type="radio" name="database" value="<%=ScientificNameDomain.SEARCH_EUNIS%>" checked="checked"
               title="Habitat type Eunis" /><label for="radio1"><%=contentManagement.getContent("species_habitats_19")%></label>&nbsp;&nbsp;
            <input id="radio2" type="radio" name="database" value="<%=ScientificNameDomain.SEARCH_ANNEX_I%>"
               title="Habitat type AnnexI" /><label for="radio2"><%=contentManagement.getContent("species_habitats_20")%></label>&nbsp;
            <input id="radio3" type="radio" name="database" value="<%=ScientificNameDomain.SEARCH_BOTH%>"
               title="Habitat type Eunis and AnnexI" /><label for="radio3"><%=contentManagement.getContent("species_habitats_21")%></label>
          </td>
        </tr>
        <tr>
          <td style="text-align:right">
            <label for="Reset" class="noshow">Reset</label>
            <input id="Reset" type="reset" value="<%=contentManagement.getContent("species_habitats_22", false)%>" name="Reset" class="inputTextField" title="Reset" />
            <%=contentManagement.writeEditTag("species_habitats_22")%>
            <label for="Search" class="noshow">Search</label>
            <input id="Search" type="submit" value="<%=contentManagement.getContent("species_habitats_23", false)%>" name="submit2" class="inputTextField" title="Search" />
            <%=contentManagement.writeEditTag("species_habitats_23")%>
          </td>
        </tr>
       </table>
     </form>
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
          <noscript>Your browser does not support JavaScript!</noscript>
          <br />
          <%=contentManagement.getContent("species_habitats_24")%>:
          <a title="Save. Link will open a new window." href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-habitats.jsp','2','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="Save" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
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
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-habitats.jsp" />
    </jsp:include>
  </div>
  </body>
</html>