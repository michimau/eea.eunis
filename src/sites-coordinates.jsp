<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites coordinates" function - search page.
--%>
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
  //String relationOpParam = request.getParameter("relationOp");
  //int relationOp = Utilities.checkedStringToInt(relationOpParam, -1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
    <script type="text/javascript" language="Javascript" src="script/sites-coordinates.js"></script>
    <script type="text/javascript" language="Javascript" src="script/save-criteria.js"></script>
    <script type="text/javascript" language="Javascript" src="script/sites-coordinates-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
     var countryListString = "<%=Utilities.getCountryListString()%>";
        //-->
    </script>
    <title>
      <%=contentManagement.getContent("sites_coordinates_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Coordinates"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" action="sites-coordinates-result.jsp" onsubmit="return validateForm();">
        <h5>
          <%=contentManagement.getContent("sites_coordinates_01")%>
        </h5>

        <%=contentManagement.getContent("sites_coordinates_18")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=contentManagement.getContent("sites_coordinates_02")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_coordinates_03", false )%>" />
          <label for="showSourceDB"><%=contentManagement.getContent("sites_coordinates_03")%></label>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_coordinates_04", false )%>" />
          <label for="showCountry"><%=contentManagement.getContent("sites_coordinates_04")%></label>

          <input id="showName" name="showName" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_coordinates_06", false )%>" />
          <label for="showName"><%=contentManagement.getContent("sites_coordinates_06")%></label>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_coordinates_05", false )%>" />
          <label for="showDesignationTypes"><%=contentManagement.getContent("sites_coordinates_05")%></label>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_coordinates_07", false )%>" />
          <label for="showCoordinates"><%=contentManagement.getContent("sites_coordinates_07")%></label>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_coordinates_08", false )%>" />
          <label for="showSize"><%=contentManagement.getContent("sites_coordinates_08")%></label>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_coordinates_09", false )%>" />
          <label for="showDesignationYear"><%=contentManagement.getContent("sites_coordinates_09")%></label>
        </div>
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.included" )%>" title="<%=Accesibility.getText( "generic.criteria.included" )%>" src="images/mini/field_included.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_coordinates_11")%>
        </strong>
        <%=contentManagement.getContent("sites_coordinates_12")%>
        <label for="longMin" class="noshow">Minimum longitude</label>
        <input id="longMin" name="longMin" type="text" class="inputTextField" title="Minimum longitude" />
        <%=contentManagement.getContent("sites_coordinates_13")%>
        <label for="longMax" class="noshow">Maximum longitude</label>
        <input id="longMax" name="longMax" type="text" class="inputTextField" title="Maximum longitude" />&nbsp;
        <script type="text/javascript" language="Javascript">
          IE  = (document.all && true);
          IE5 = (document.getElementById && IE);
          if (IE5)
          {
            document.write('<a href="javascript:chooseCoordinates(\'world\');">');
            document.write('<img src="images/mini/globe.gif" alt="Open world map in a popup window" title="Open world map" width="16" height="16" border="0" align="middle" />');
            document.write('</a>');
          }
        </script>
        <!--<a href="javascript:chooseCoordinates('world');"><img src="images/mini/globe.gif" alt="Open world map.<%=Accesibility.getText( "generic.popup" )%>" title="Open world map.<%=Accesibility.getText( "generic.popup" )%>" width="16" height="16" border="0" align="middle" /></a>-->
        &nbsp;
        <a href="javascript:openCalculator();"><img src="images/mini/calculator.gif" alt="Coordinates calculator.<%=Accesibility.getText( "generic.popup" )%>" title="Coordinates calculator.<%=Accesibility.getText( "generic.popup" )%>" width="11" height="15" border="0" align="middle" /></a>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.included" )%>" title="<%=Accesibility.getText( "generic.criteria.included" )%>" src="images/mini/field_included.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_coordinates_14")%>
        </strong>
        <%=contentManagement.getContent("sites_coordinates_12")%>
        <label for="latMin" class="noshow">Minimum latitude</label>
        <input id="latMin" name="latMin" type="text" class="inputTextField" title="Minimum latitude" />
        <%=contentManagement.getContent("sites_coordinates_13")%>
        <label for="latMax" class="noshow">Maximum latitude</label>
        <input id="latMax" name="latMax" type="text" class="inputTextField" title="Maximum latitude" />&nbsp;
        <script type="text/javascript" language="Javascript">
          IE  = (document.all && true);
          IE5 = (document.getElementById && IE);
          if (IE5)
          {
            document.write('<a href="javascript:chooseCoordinates(\'europe\');">');
            document.write('<img src="images/mini/europe.gif" alt="Open Europe map in a popup window" title="Open Europe map" width="16" height="16" border="0" align="middle" />');
            document.write('</a>');
          }
        </script>
        <!--<a href="javascript:chooseCoordinates('europe');"><img src="images/mini/europe.gif" alt="Open europe map.<%=Accesibility.getText( "generic.popup" )%>" title="Open europe map.<%=Accesibility.getText( "generic.popup" )%>" width="16" height="16" border="0" align="middle" /></a>-->
        &nbsp;
        <a href="javascript:openCalculator();"><img src="images/mini/calculator.gif" alt="Coordinates calculator.<%=Accesibility.getText( "generic.popup" )%>" title="Coordinates calculator.<%=Accesibility.getText( "generic.popup" )%>" width="11" height="15" border="0" align="middle" /></a>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <label for="country">
          <strong>
            Country name
          </strong>
        </label>
        <input name="country" type="text" id="country" class="inputTextField" title="Country name" />&nbsp;
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <div class="submit_buttons">
          <label for="reset" class="noshow">Reset values</label>
          <input id="reset" name="Reset" type="reset" value="Reset" class="inputTextField" title="Reset values" />
          &nbsp;
          <label for="submit" class="noshow">Search</label>
          <input id="submit" name="Submit" type="submit" class="inputTextField" value="Search" title="Search" />
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

    String pageName = "sites-coordinates.jsp";
    String pageNameResult = "sites-coordinates-result.jsp?"+Utilities.writeURLCriteriaSave(show);
    // Expand or not save criterias list
    String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
%>
      <br />
        <%=contentManagement.getContent("sites_coordinates_17")%>
        <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-coordinates.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
      <jsp:include page="show-criteria-search.jsp">
        <jsp:param name="pageName" value="<%=pageName%>" />
        <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
        <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
      </jsp:include>
<%
  }
%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-coordinates.jsp" />
      </jsp:include>
    </div>
  </body>
</html>