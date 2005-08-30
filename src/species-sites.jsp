<%--
<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show species' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.sites.SitesSearchCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--

      var errInvalidRegion = 'Biogeographic regions is not valid, please use helper to find biogeographic regions';
        // Change the operator list according to criteria selected element from criteria type list
        function changeCriteria() {
          var criteriaType = document.getElementById("searchAttribute").options[document.getElementById("searchAttribute").selectedIndex].value;
          var operList = document.getElementById("relationOp");
          changeOperatorList(criteriaType, operList);
        }

        // Reconstruct the list items depending on the selected item
        function changeOperatorList(criteriaType, operList) {
          removeElementsFromList(operList);
          var optIS = document.createElement("OPTION");
          optIS.text = "is";
          optIS.value = "<%=Utilities.OPERATOR_IS%>";
          var optSTART = document.createElement("OPTION");
          optSTART.text = "starts";
          optSTART.value = "<%=Utilities.OPERATOR_STARTS%>";
          var optCONTAIN = document.createElement("OPTION");
          optCONTAIN.text = "contains";
          optCONTAIN.value = "<%=Utilities.OPERATOR_CONTAINS%>";
          var optGREAT = document.createElement("OPTION");
          optGREAT.text = "greater";
          optGREAT.value = "<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>";
          var optSMALL = document.createElement("OPTION");
          optSMALL.text = "smaller";
          optSMALL.value = "<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>";
          // Site name
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_NAME%>)
          {
            operList.add(optCONTAIN, 2);
            operList.add(optIS, 0);
            operList.add(optSTART, 1);
          }
          // Site size
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_SIZE%>)
          {
            operList.add(optIS, 0);
            operList.add(optGREAT, 1);
            operList.add(optSMALL, 2);
          }
          // Site length
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_LENGTH%>)
          {
            operList.add(optIS, 0);
            operList.add(optGREAT, 1);
            operList.add(optSMALL, 2);
          }
          // Country
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_COUNTRY%>)
          {
            operList.add(optCONTAIN, 1);
            operList.add(optIS, 0);
          }
          // Region
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_REGION%>)
          {
            operList.add(optCONTAIN, 1);
            operList.add(optIS, 0);
          }
        }

        // This function removes all the elements of a list
        function removeElementsFromList(operList)
        {
          for (i = operList.length - 1; i >= 0; i--)
          {
            operList.remove(i);
          }
        }

        function validateForm()
        {
          document.criteria.scientificName.value = trim(document.criteria.scientificName.value);

          var errMessageName = "Please type a few letters from site name.";
          var errMessageSize = "Please enter size as a numerical value.";

          // Validate it's selected SIZE?LENGTH
          var criteriaType = document.getElementById("searchAttribute").options[document.getElementById("searchAttribute").selectedIndex].value;
          var searchString = document.criteria.scientificName.value;
          var fSearchString = parseFloat(searchString);

          if ((criteriaType == <%=SitesSearchCriteria.SEARCH_SIZE%> ||
              criteriaType == <%=SitesSearchCriteria.SEARCH_LENGTH%>) && isNaN(fSearchString))
          {
              alert(errMessageSize);
              return false;
          }

          if(criteriaType == <%=SitesSearchCriteria.SEARCH_COUNTRY%>)
          {
            // Check if country is a valid country
           if (!validateCountry('<%=Utilities.getCountryListString()%>',searchString))
           {
             alert(errInvalidCountry);
             return false;
           }
         }

          if(criteriaType == <%=SitesSearchCriteria.SEARCH_REGION%>)
          {
            // Check if region is a valid region
           if (!validateRegion('<%=Utilities.getRegionListString()%>',searchString))
           {
             alert(errInvalidRegion);
             return false;
           }
         }

          // Validate the input field
          var siteName;
          siteName = document.criteria.scientificName.value;
          if (siteName == "")
          {
            alert(errMessageName);
            return false;
          }
          // Validate selection of databases
          return checkValidSelection();// From sites-databases.jsp.
        }

        function openHelper(URL)
        {
          document.criteria.scientificName.value = trim(document.criteria.scientificName.value);
          var scientificName = document.criteria.scientificName.value;
          var relationOp = document.criteria.relationOp.value;
          var searchAttribute = document.criteria.searchAttribute.value;
          // If selects attribute scientific name, validate the form for input.
          if (searchAttribute == <%=SitesSearchCriteria.SEARCH_NAME%> && !validateForm())
          {
            // Return, form validation failed.
            return;
          }
          if (searchAttribute == <%=SitesSearchCriteria.SEARCH_SIZE%> || searchAttribute == <%=SitesSearchCriteria.SEARCH_LENGTH%>)
          {
            // Return, no popup for size or length
            alert("Helper not applicable for this criteria.");
            return;
          }
          if (!checkValidSelection())
          {
            // Return, no database selected
            return;
          }
          URL2 = URL;
          URL2 += '?searchAttribute=' + searchAttribute;
          URL2 += '&scientificName=' + scientificName;
          URL2 += '&relationOp=' + relationOp;
          URL2 += Db2Url();
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,resizable=no,location=0,width=400,height=500,left=500,top=0');");
        }
      //-->
    </script>
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_sites_title", false )%>
    </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Pick sites show species" />
    </jsp:include>
    <h5>
       <%=contentManagement.getContent("species_sites_01")%>
    </h5>
    <form name="criteria" method="get" onsubmit="javascript: return validateForm();" action="species-sites-result.jsp">
    <table summary="layout" width="100%" border="0">
        <tr>
          <td colspan="2">
            <%=contentManagement.getContent("species_sites_20")%>
            <br />
            <br />
            <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="background-color:#EEEEEE">
                  <strong>
                    <%=contentManagement.getContent("species_sites_02")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td style="background-color:#EEEEEE">
                  <input title="Group" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" />
                  <label for="checkbox1"><%=contentManagement.getContent("species_sites_03")%></label>

                  <input title="Order" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" />
                  <label for="checkbox2"><%=contentManagement.getContent("species_sites_04")%></label>

                  <input title="Family" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" />
                  <label for="checkbox3"><%=contentManagement.getContent("species_sites_05")%></label>

                  <input title="Scientific name" id="checkbox5" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" />
                  <label for="checkbox5"><%=contentManagement.getContent("species_sites_06")%></label>

                  <input title="Sites" id="checkbox4" type="checkbox" name="showSites" value="true" checked="checked" />
                  <label for="checkbox4"><%=contentManagement.getContent("species_sites_21")%></label>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <img width="11" height="12" style="vertical-align:middle" alt="This field is mandatory" title="This field is mandatory" src="images/mini/field_mandatory.gif" />&nbsp;
            <label for="select1" class="noshow">Search attribute</label>
            <select id="select1" title="Search attribute" name="searchAttribute" onchange="changeCriteria()" class="inputTextField">
              <option value="<%=SitesSearchCriteria.SEARCH_NAME%>" selected="selected"><%=contentManagement.getContent("species_sites_08", false)%></option>
              <option value="<%=SitesSearchCriteria.SEARCH_SIZE%>"><%=contentManagement.getContent("species_sites_09", false)%></option>
              <option value="<%=SitesSearchCriteria.SEARCH_LENGTH%>"><%=contentManagement.getContent("species_sites_10", false)%></option>
              <option value="<%=SitesSearchCriteria.SEARCH_COUNTRY%>"><%=contentManagement.getContent("species_sites_11", false)%></option>
              <option value="<%=SitesSearchCriteria.SEARCH_REGION%>"><%=contentManagement.getContent("species_sites_12", false)%></option>
            </select>&nbsp;
            <label for="select2" class="noshow">Operator</label>
            <select id="select2" title="Operator" name="relationOp" class="inputTextField">
              <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("species_sites_13", false)%></option>
              <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("species_sites_14", false)%></option>
              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent("species_sites_15", false)%></option>
            </select>

            <label for="scientificName" class="noshow">Searched value</label>
            <input title="Searched value" size="32" id="scientificName" name="scientificName" value="" class="inputTextField" />
            <a title="List of values. Link will open a new window." href="javascript:openHelper('species-sites-choice.jsp')"><img alt="List of values" height="18" src="images/helper/helper.gif" width="11" border="0" title="List of values" /></a>
          </td>
        </tr>
        <tr>
          <td style="text-align:right">
            <label for="Reset" class="noshow"><%=contentManagement.getContent("species_sites_17", false)%></label>
            <input id="Reset" type="reset" value="<%=contentManagement.getContent("species_sites_17", false)%>" name="Reset" class="inputTextField" title="Reset" />
            <%=contentManagement.writeEditTag( "species_sites_17")%>
            <label for="Search" class="noshow"><%=contentManagement.getContent("species_sites_18", false)%></label>
            <input id="Search" type="submit" value="<%=contentManagement.getContent("species_sites_18", false)%>" name="submit2" class="inputTextField" title="Search" />
            <%=contentManagement.writeEditTag( "species_sites_18")%>
          </td>
       </tr>
       <tr>
         <td>
           <jsp:include page="sites-databases.jsp" />
         </td>
       </tr>
    </table>
    </form>

          <%
            // Save search criteria
            if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
            {
          %>
              <br />
              <script type="text/javascript" language="JavaScript">
              <!--
              // values of source and database constants from specific class Domain(only in habitat searches, so here are all '')
              var source1='';
              var source2='';
              var database1='';
              var database2='';
              var database3='';
             //-->
             </script>
             <noscript>Your browser does not support JavaScript!</noscript>
              <%=contentManagement.getContent("species_sites_19")%>:
              <a title="Save. Link will open a new window." href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-sites.jsp','2','criteria',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="Save" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
          <%
              // Set Vector for URL string
              Vector show = new Vector();
              show.addElement("showGroup");
              show.addElement("showOrder");
              show.addElement("showScientificName");
              show.addElement("showFamily");
              show.addElement("showOtherInfo");

              String pageName = "species-sites.jsp";
              String pageNameResult = "species-sites-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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
      <jsp:param name="page_name" value="species-sites.jsp" />
    </jsp:include>
  </div>
  </body>
</html>