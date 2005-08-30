<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites altitude" function - search page.
--%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                  java.util.Vector,
                  ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<%@page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();

  // Request parameters
  String country = (request.getParameter("country")==null?"":request.getParameter("country"));
  String altitude1 = (request.getParameter("altitude1")==null?"":request.getParameter("altitude1"));
  String altitude2 = (request.getParameter("altitude2")==null?"":request.getParameter("altitude2"));
  String altitude21 = (request.getParameter("altitude21")==null?"":request.getParameter("altitude21"));
  String altitude22 = (request.getParameter("altitude22")==null?"":request.getParameter("altitude22"));
  String altitude31 = (request.getParameter("altitude31")==null?"":request.getParameter("altitude31"));
  String altitude32 = (request.getParameter("altitude32")==null?"":request.getParameter("altitude32"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-altitude.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-altitude-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
       var countryListString = "<%=Utilities.getCountryListString()%>";
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_altitude_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Altitude"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="return validateForm();" action="sites-altitude-result.jsp">
        <input type="hidden" name="source" value="sitename" />
        <h5>
          <%=contentManagement.getContent("sites_altitude_01")%>
        </h5>
        <%=contentManagement.getContent("sites_altitude_20")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=contentManagement.getContent("sites_altitude_02")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_altitude_03", false )%>" />
          <label for="showSourceDB"><%=contentManagement.getContent("sites_altitude_03")%></label>

          <input id="showCountry" name="showCountry" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_altitude_04", false )%>" />
          <label for="showCountry"><%=contentManagement.getContent("sites_altitude_04")%></label>

          <input id="showName" name="showName" type="checkbox" value="true" checked="checked" disabled="disabled" title="<%=contentManagement.getContent("sites_altitude_06", false )%>" />
          <label for="showName"><%=contentManagement.getContent("sites_altitude_06")%></label>

          <input id="showDesignationTypes" name="showDesignationTypes" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_altitude_05", false )%>" />
          <label for="showDesignationTypes"><%=contentManagement.getContent("sites_altitude_05")%></label>

          <input id="showCoordinates" name="showCoordinates" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_altitude_07", false )%>" />
          <label for="showCoordinates"><%=contentManagement.getContent("sites_altitude_07")%></label>

          <input id="showAltitude" name="showAltitude" type="checkbox" value="true" checked="checked" title="<%=contentManagement.getContent("sites_altitude_08", false )%>" />
          <label for="showAltitude"><%=contentManagement.getContent("sites_altitude_08")%></label>
        </div>
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.included" )%>" title="<%=Accesibility.getText( "generic.criteria.included" )%>" src="images/mini/field_included.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_altitude_10")%>
        </strong>
        <label for="relOp" class="noshow">Operator</label>
        <select id="relOp" name="relOp" onchange="MM_jumpMenuAlt('parent',this,0)" class="inputTextField" title="Operator">
<%
  String selected = "";
  String no = Utilities.formatString( request.getParameter( "no" ), "" );
  if ( no.equalsIgnoreCase( "" ) || no.equalsIgnoreCase( "1" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
          <option value="sites-altitude.jsp?between=no&amp;no=1&amp;between2=<%=request.getParameter("between2")%>&amp;no2=<%=request.getParameter("no2")%>&amp;between3=<%=request.getParameter("between3")%>&amp;no3=<%=request.getParameter("no3")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_11", false)%>
          </option>
<%
  selected = "";
  if ( no.equalsIgnoreCase( "2" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
          <option value="sites-altitude.jsp?between=yes&amp;no=2&amp;between2=<%=request.getParameter("between2")%>&amp;no2=<%=request.getParameter("no2")%>&amp;between3=<%=request.getParameter("between3")%>&amp;no3=<%=request.getParameter("no3")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_12", false)%>
          </option>
<%
  selected = "";
  if ( no.equalsIgnoreCase( "3" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
          <option value="sites-altitude.jsp?between=no&amp;no=3&amp;between2=<%=request.getParameter("between2")%>&amp;no2=<%=request.getParameter("no2")%>&amp;between3=<%=request.getParameter("between3")%>&amp;no3=<%=request.getParameter("no3")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_13", false)%>
          </option>
<%
  selected = "";
  if ( no.equalsIgnoreCase( "4" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
          <option value="sites-altitude.jsp?between=no&amp;no=4&amp;between2=<%=request.getParameter("between2")%>&amp;no2=<%=request.getParameter("no2")%>&amp;between3=<%=request.getParameter("between3")%>&amp;no3=<%=request.getParameter("no3")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_14", false)%>
          </option>
        </select>
<%
  // request.getParameter("between") is true if operator for Mean Altitude is "between"
  // no = 1 if operator is "is"
  // no = 2 if operator is "between"
  // no = 3 if operator is "greater than"
  // no = 4 if operator is "smaller than"
  if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes"))
  {
%>
        <label for="altitude1" class="noshow">Minimum mean altitude</label>
        <input id="altitude1" name="altitude1" value="<%=altitude1%>" size="5" class="inputTextField" title="Minimum mean altitude" />
        and
        <label for="altitude2" class="noshow">Maximum mean altitude</label>
        <input id="altitude2" name="altitude2" value="<%=altitude2%>" size="5" class="inputTextField" title="Maximum mean altitude" />
<%
  }
  else
  {
%>
        <label for="altitude1" class="noshow">Mean altitude</label>
        <input id="altitude1" name="altitude1" value="<%=altitude1%>" size="5" class="inputTextField" title="Mean altitude" />
<%
  }
  Integer valAl=Utilities.checkedStringToInt(request.getParameter("no"),new Integer(1));
  // Set value for relationOp hidden field
  Integer valAltitude = Utilities.OPERATOR_IS;
  if(valAl.compareTo(new Integer(2))==0) valAltitude = Utilities.OPERATOR_BETWEEN;
  if(valAl.compareTo(new Integer(3))==0) valAltitude = Utilities.OPERATOR_GREATER_OR_EQUAL;
  if(valAl.compareTo(new Integer(4))==0) valAltitude = Utilities.OPERATOR_SMALLER_OR_EQUAL;
%>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.included" )%>" title="<%=Accesibility.getText( "generic.criteria.included" )%>" src="images/mini/field_included.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_altitude_16")%>
        </strong>
<%
  selected = "";
  String no2 = Utilities.formatString( request.getParameter( "no2" ), "" );
  if ( no2.equalsIgnoreCase( "" ) || no2.equalsIgnoreCase( "1" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
        <label for="relOp2" class="noshow">Operator</label>
        <select id="relOp2" name="relOp2" onchange="MM_jumpMenuAlt('parent',this,0)" class="inputTextField" title="Operator">
          <option value="sites-altitude.jsp?between2=no&amp;no2=1&amp;between=<%=request.getParameter("between")%>&amp;no=<%=request.getParameter("no")%>&amp;between3=<%=request.getParameter("between3")%>&amp;no3=<%=request.getParameter("no3")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_11", false)%>
          </option>
<%
  selected = "";
  if ( no2.equalsIgnoreCase( "2" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
          <option value="sites-altitude.jsp?between2=yes&amp;no2=2&amp;between=<%=request.getParameter("between")%>&amp;no=<%=request.getParameter("no")%>&amp;between3=<%=request.getParameter("between3")%>&amp;no3=<%=request.getParameter("no3")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_12", false)%>
          </option>
<%
  selected = "";
  if ( no2.equalsIgnoreCase( "3" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
          <option value="sites-altitude.jsp?between2=no&amp;no2=3&amp;between=<%=request.getParameter("between")%>&amp;no=<%=request.getParameter("no")%>&amp;between3=<%=request.getParameter("between3")%>&amp;no3=<%=request.getParameter("no3")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_13", false)%>
          </option>
<%
  selected = "";
  if ( no2.equalsIgnoreCase( "4" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
          <option value="sites-altitude.jsp?between2=no&amp;no2=4&amp;between=<%=request.getParameter("between")%>&amp;no=<%=request.getParameter("no")%>&amp;between3=<%=request.getParameter("between3")%>&amp;no3=<%=request.getParameter("no3")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_14", false)%>
          </option>
        </select>
<%
  // request.getParameter("between2") is true if operator for Minimum Altitude is "between"
  // no2 = 1 if operator is "is"
  // no2 = 2 if operator is "between"
  // no2 = 3 if operator is "greater than"
  // no2 = 4 if operator is "smaller than"
  if (request.getParameter("between2")!=null && request.getParameter("between2").equalsIgnoreCase("yes"))
  {
%>
        <label for="altitude21" class="noshow">Minimum min altitude</label>
        <input id="altitude21" name="altitude21" value="<%=altitude21%>" size="5" class="inputTextField" title="Minimum min altitude" />
        and
        <label for="altitude22" class="noshow">Maximum min altitude</label>
        <input id="altitude22" name="altitude22" value="<%=altitude22%>" size="5" class="inputTextField" title="Maximum min altitude" />
<%
  }
  else
  {
%>
        <label for="altitude21" class="noshow">Minimum altitude</label>
        <input id="altitude21" name="altitude21" value="<%=altitude21%>" size="5" class="inputTextField" title="Minimum altitude" />
<%
  }
  Integer valAl2=Utilities.checkedStringToInt(request.getParameter("no2"),new Integer(1));
  // Set value for relationOp2 hidden field
  Integer valAltitude2 = Utilities.OPERATOR_IS;
  if(valAl2.compareTo(new Integer(2))==0) valAltitude2 = Utilities.OPERATOR_BETWEEN;
  if(valAl2.compareTo(new Integer(3))==0) valAltitude2 = Utilities.OPERATOR_GREATER_OR_EQUAL;
  if(valAl2.compareTo(new Integer(4))==0) valAltitude2 = Utilities.OPERATOR_SMALLER_OR_EQUAL;
%>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.included" )%>" title="<%=Accesibility.getText( "generic.criteria.included" )%>" src="images/mini/field_included.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_altitude_17")%>
        </strong>
<%
  selected = "";
  String no3 = Utilities.formatString( request.getParameter( "no3" ), "" );
  if ( no3.equalsIgnoreCase( "" ) || no3.equalsIgnoreCase( "1" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
        <label for="relOp3" class="noshow">Operator</label>
        <select id="relOp3" name="relOp3" onchange="MM_jumpMenuAlt('parent',this,0)" class="inputTextField" title="Operator">
          <option value="sites-altitude.jsp?between3=no&amp;no3=1&amp;between=<%=request.getParameter("between")%>&amp;no=<%=request.getParameter("no")%>&amp;between2=<%=request.getParameter("between2")%>&amp;no2=<%=request.getParameter("no2")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_11", false)%>
          </option>
<%
  selected = "";
  if ( no3.equalsIgnoreCase( "2" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
          <option value="sites-altitude.jsp?between3=yes&amp;no3=2&amp;between=<%=request.getParameter("between")%>&amp;no=<%=request.getParameter("no")%>&amp;between2=<%=request.getParameter("between2")%>&amp;no2=<%=request.getParameter("no2")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_12", false)%>
          </option>
<%
  selected = "";
  if ( no3.equalsIgnoreCase( "3" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
          <option value="sites-altitude.jsp?between3=no&amp;no3=3&amp;between=<%=request.getParameter("between")%>&amp;no=<%=request.getParameter("no")%>&amp;between2=<%=request.getParameter("between2")%>&amp;no2=<%=request.getParameter("no2")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_13", false)%>
          </option>
<%
  selected = "";
  if ( no3.equalsIgnoreCase( "4" ) )
  {
    selected = "selected=\"selected\"";
  }
%>
          <option value="sites-altitude.jsp?between3=no&amp;no3=4&amp;between=<%=request.getParameter("between")%>&amp;no=<%=request.getParameter("no")%>&amp;between2=<%=request.getParameter("between2")%>&amp;no2=<%=request.getParameter("no2")%>" <%=selected%>>
            <%=contentManagement.getContent("sites_altitude_14", false)%>
          </option>
        </select>
<%
  // request.getParameter("between3") is true if operator for Maximum Altitude is "between"
  // no3 = 1 if operator is "is"
  // no3 = 2 if operator is "between"
  // no3 = 3 if operator is "greater than"
  // no3 = 4 if operator is "smaller than"
  if (request.getParameter("between3")!=null && request.getParameter("between3").equalsIgnoreCase("yes"))
  {
%>
        <label for="altitude31" class="noshow">Minimum max altitude</label>
        <input id="altitude31" name="altitude31" value="<%=altitude31%>" size="5" class="inputTextField" title="Minimum max altitude" />
        and
        <label for="altitude32" class="noshow">Maximum max altitude</label>
        <input id="altitude32" name="altitude32" value="<%=altitude32%>" size="5" class="inputTextField" title="Maximum max altitude" />
<%
  }
  else
  {
%>
        <label for="altitude31" class="noshow">Maximum altitude</label>
        <input id="altitude31" name="altitude31" value="<%=altitude31%>" size="5" class="inputTextField" title="Maximum altitude" />
<%
  }
  Integer valAl3=Utilities.checkedStringToInt(request.getParameter("no3"),new Integer(1));
  // Set value for relationOp3 hidden field
  Integer valAltitude3 = Utilities.OPERATOR_IS;
  if(valAl3.compareTo(new Integer(2))==0) valAltitude3 = Utilities.OPERATOR_BETWEEN;
  if(valAl3.compareTo(new Integer(3))==0) valAltitude3 = Utilities.OPERATOR_GREATER_OR_EQUAL;
  if(valAl3.compareTo(new Integer(4))==0) valAltitude3 = Utilities.OPERATOR_SMALLER_OR_EQUAL;
%>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <label for="country"><strong><%=contentManagement.getContent("sites_altitude_18")%></strong></label>
        <input id="country" name="country" type="text" size="30" value="<%=country%>" class="inputTextField" title="Country" />
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:chooseCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <input type="hidden" name="relationOp" value="<%=valAltitude%>" />
        <input type="hidden" name="relationOp2" value="<%=valAltitude2%>" />
        <input type="hidden" name="relationOp3" value="<%=valAltitude3%>" />
        <div class="submit_buttons">
          <label for="reset" class="noshow">Reset</label>
          <input id="reset" name="Reset" type="reset" value="Reset" class="inputTextField" title="Reset" />
          <label for="submit2" class="noshow">Submit</label>
          <input id="submit2" name="submit2" type="submit" class="inputTextField" value="Search" title="Search" />
        </div>
        <jsp:include page="sites-search-common.jsp" />
     </form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
  {
%>
        <br />
        Save your criteria:
        <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-altitude.jsp','5','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
<%
  // Set Vector for URL string
  Vector show = new Vector();
  show.addElement("showName");
  show.addElement("showSourceDB");
  show.addElement("showDesignationYear");
  show.addElement("showCountry");
  show.addElement("showDesignationTypes");
  show.addElement("showCoordinates");
  show.addElement("showAltitude");
  String pageName = "sites-altitude.jsp";
  String pageNameResult = "sites-altitude-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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
        <jsp:param name="page_name" value="sites-altitude.jsp" />
      </jsp:include>
    </div>
  </body>
</html>