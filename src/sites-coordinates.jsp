<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites coordinates" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  //String relationOpParam = request.getParameter("relationOp");
  //int relationOp = Utilities.checkedStringToInt(relationOpParam, -1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script type="text/javascript" language="Javascript" src="script/sites-coordinates.js"></script>
    <script type="text/javascript" language="Javascript" src="script/save-criteria.js"></script>
    <script type="text/javascript" language="Javascript" src="script/sites-coordinates-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
     var countryListString = "<%=Utilities.getCountryListString()%>";
        //-->
    </script>
    <title>
      <%=cm.cms("sites_coordinates_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,sites_coordinates_location"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" action="sites-coordinates-result.jsp" onsubmit="return validateForm();">
        <h1>
          <%=cm.cmsText("sites_coordinates_01")%>
        </h1>

        <%=cm.cmsText("sites_coordinates_18")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=cm.cmsText("search_will_provide_following_information")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_coordinates_03")%>" />
          <label for="showSourceDB"><%=cm.cmsText("sites_coordinates_03")%></label>
          <%=cm.cmsTitle("sites_coordinates_03")%>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_coordinates_04")%>" />
          <label for="showCountry"><%=cm.cmsText("sites_coordinates_04")%></label>
          <%=cm.cmsTitle("sites_coordinates_04")%>

          <input id="showName" name="showName" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("sites_coordinates_06")%>" />
          <label for="showName"><%=cm.cmsText("sites_coordinates_06")%></label>
          <%=cm.cmsTitle("sites_coordinates_06")%>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_coordinates_05")%>" />
          <label for="showDesignationTypes"><%=cm.cmsText("sites_coordinates_05")%></label>
          <%=cm.cmsTitle("sites_coordinates_05")%>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_coordinates_07")%>" />
          <label for="showCoordinates"><%=cm.cmsText("sites_coordinates_07")%></label>
          <%=cm.cmsTitle("sites_coordinates_07")%>

          <input id="showSize" name="showSize" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_coordinates_08")%>" />
          <label for="showSize"><%=cm.cmsText("sites_coordinates_08")%></label>
          <%=cm.cmsTitle("sites_coordinates_08")%>

          <input id="showDesignationYear" name="showDesignationYear" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=cm.cms("sites_coordinates_09")%>" />
          <label for="showDesignationYear"><%=cm.cmsText("sites_coordinates_09")%></label>
          <%=cm.cmsTitle("sites_coordinates_09")%>
        </div>
        <img align="middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_included")%>
        <strong>
          <%=cm.cmsText("sites_coordinates_11")%>
        </strong>
        <%=cm.cmsText("sites_coordinates_12")%>
        <label for="longMin" class="noshow"><%=cm.cms("sites_coordinates_minlongitude")%></label>
        <input id="longMin" name="longMin" type="text" class="inputTextField" title="<%=cm.cms("sites_coordinates_minlongitude")%>" />
        <%=cm.cmsLabel("sites_coordinates_minlongitude")%>
        <%=cm.cmsTitle("sites_coordinates_minlongitude")%>

        <%=cm.cmsText("sites_coordinates_13")%>
        <label for="longMax" class="noshow"><%=cm.cms("sites_coordinates_maxlongitude")%></label>
        <input id="longMax" name="longMax" type="text" class="inputTextField" title="<%=cm.cms("sites_coordinates_maxlongitude")%>" />&nbsp;
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
        <a href="javascript:openCalculator();"><img src="images/mini/calculator.gif" alt="<%=cm.cms("calculator")%>" title="<%=cm.cms("calculator")%>" width="11" height="15" border="0" align="middle" /></a>
        <%=cm.cmsTitle("calculator")%>
        <%=cm.cmsAlt("calculator")%>
        <br />
        <img align="middle" alt="<%=cm.cms("field_included")%>" title="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" width="11" height="12" />
        <%=cm.cmsTitle("field_included")%>
        <%=cm.cmsAlt("field_included")%>
        <strong>
          <%=cm.cmsText("sites_coordinates_14")%>
        </strong>
        <%=cm.cmsText("sites_coordinates_12")%>
        <label for="latMin" class="noshow"><%=cm.cms("sites_coordinates_minlatitude")%></label>
        <input id="latMin" name="latMin" type="text" class="inputTextField" title="<%=cm.cms("sites_coordinates_minlatitude")%>" />
        <%=cm.cmsTitle("sites_coordinates_minlatitude")%>
        <%=cm.cmsLabel("sites_coordinates_minlatitude")%>

        <%=cm.cmsText("sites_coordinates_13")%>
        <label for="latMax" class="noshow"><%=cm.cms("sites_coordinates_maxlatitude")%></label>
        <input id="latMax" name="latMax" type="text" class="inputTextField" title="<%=cm.cms("sites_coordinates_maxlatitude")%>" />
        <%=cm.cmsLabel("sites_coordinates_maxlatitude")%>
        <%=cm.cmsTitle("sites_coordinates_maxlatitude")%>
        &nbsp;
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
        <a href="javascript:openCalculator();"><img src="images/mini/calculator.gif" alt="<%=cm.cms("calculator")%>" title="<%=cm.cms("calculator")%>" width="11" height="15" border="0" align="middle" /></a>
        <%=cm.cmsTitle("calculator")%>
        <%=cm.cmsAlt("calculator")%>
        <br />
        <img align="middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <label for="country">
          <strong>
            <%=cm.cmsText("sites_coordinates_countryname")%>
          </strong>
        </label>
        <input name="country" type="text" id="country" class="inputTextField" title="<%=cm.cms("sites_coordinates_countryname")%>" />&nbsp;
        <%=cm.cmsTitle("sites_coordinates_countryname")%>
        <a title="<%=cm.cms("helper")%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" align="middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
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
      <%=cm.cmsText("sites_coordinates_17")%>
      <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-coordinates.jsp','4','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
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

      <%=cm.cmsMsg("sites_coordinates_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-coordinates.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>