<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Number/Total area" function - search page.
--%>
<%@ page import="java.util.Vector,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-statistical.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-statistical-save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript">
      <!--
      var countryListString = "<%=Utilities.getCountryListString()%>";
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_statistical_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp, Number / Total area"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <%=contentManagement.getContent("sites_statistical_01")%>
      <form name="eunis" onsubmit="javascript:return validateForm();" action="sites-statistical-result.jsp" method="get">
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.mandatory")%>" title="<%=Accesibility.getText( "generic.criteria.mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <label for="country">
          <strong>
            <%=contentManagement.getContent("sites_statistical_03")%>
          </strong>
        </label>
        <input id="country" name="country" type="text" class="inputTextField" title="Country" />&nbsp;
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:openHelperCountry('sites-country-choice.jsp?field=country')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <br />

        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <label for="designation">
          <strong>
            <%=contentManagement.getContent("sites_statistical_05")%>
          </strong>
        </label>
        <input id="designation" name="designation" type="text" size="30" class="inputTextField" />
        <a title="<%=Accesibility.getText( "generic.popup.lov" )%>" href="javascript:openHelperDesignation('sites-statistical-choice.jsp')"><img src="images/helper/helper.gif" alt="<%=Accesibility.getText( "generic.popup.lov" )%>" title="<%=Accesibility.getText( "generic.popup.lov" )%>" width="11" height="18" border="0" align="middle" /></a>
        <br />

        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <label for="designationCat">
          <strong>
            <%=contentManagement.getContent("sites_statistical_06")%>
          </strong>
        </label>
        <select id="designationCat" name="designationCat" class="inputTextField" title="Designation category">
          <option value="any" selected="selected"><%=contentManagement.getContent("sites_statistical_07", false)%></option>
          <option value="A">A</option>
          <option value="B">B</option>
          <option value="C">C</option>
        </select>
        <br />
        <img align="middle" alt="<%=Accesibility.getText( "generic.criteria.optional" )%>" title="<%=Accesibility.getText( "generic.criteria.optional" )%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <strong>
          <%=contentManagement.getContent("sites_statistical_08")%>&nbsp;
          <label for="yearMin" class="noshow">Minimum designation year</label>
          <input id="yearMin" name="yearMin" type="text" size="4" class="inputTextField" title="Minimum designation year" />
          <%=contentManagement.getContent("sites_statistical_09")%>
          <label for="yearMax" class="noshow">Maximum designation year</label>
          <input id="yearMax" name="yearMax" type="text" size="4" class="inputTextField" title="Maximum designation year" />
        </strong>
        <div class="submit_buttons">
          <input id="reset" name="Reset" type="reset" value="<%=contentManagement.getContent("sites_statistical_10", false )%>" class="inputTextField" title="Reset values"  />
          <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=contentManagement.getContent("sites_statistical_11", false )%>" title="Search" />
        </div>
        <jsp:include page="sites-search-common.jsp" />
      </form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
  {
 %>
      <br />
      <%=contentManagement.getContent("sites_statistical_13")%>
      <a title="<%=Accesibility.getText( "generic.criteria.save" )%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-statistical.jsp','5','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=Accesibility.getText( "generic.criteria.save" )%>" title="<%=Accesibility.getText( "generic.criteria.save" )%>" src="images/save.jpg" width="21" height="19" align="middle" /></a>
<%
  // Set Vector for URL string
  Vector show = new Vector();
  String pageName = "sites-statistical.jsp";
  String pageNameResult = "sites-statistical-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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
        <jsp:param name="page_name" value="sites-statistical.jsp" />
      </jsp:include>
    </div>
  </body>
</html>