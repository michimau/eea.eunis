<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick species, show sites" function - Popup for list of values in search page.
--%>
<%@page contentType="text/html"%>
<%@page import="java.util.List, java.util.Iterator,
                ro.finsiel.eunis.search.Utilities,
                java.util.Enumeration,
                ro.finsiel.eunis.jrfTables.sites.species.SpeciesDomain,
                ro.finsiel.eunis.jrfTables.sites.species.SpeciesPersist,
                java.util.Vector,
                ro.finsiel.eunis.search.sites.species.SpeciesSearchCriteria,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.species.SpeciesBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
  Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
  Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME);
  boolean[] source_db = {(request.getParameter("DB_NATURA2000")!=null&&request.getParameter("DB_NATURA2000").equalsIgnoreCase("true")?true:false),(request.getParameter("DB_CORINE")!=null&&request.getParameter("DB_CORINE").equalsIgnoreCase("true")?true:false),(request.getParameter("DB_DIPLOMA")!=null&&request.getParameter("DB_DIPLOMA").equalsIgnoreCase("true")?true:false),(request.getParameter("DB_CDDA_NATIONAL")!=null&&request.getParameter("DB_CDDA_NATIONAL").equalsIgnoreCase("true")?true:false),(request.getParameter("DB_CDDA_INTERNATIONAL")!=null&&request.getParameter("DB_CDDA_INTERNATIONAL").equalsIgnoreCase("true")?true:false),(request.getParameter("DB_BIOGENETIC")!=null&&request.getParameter("DB_BIOGENETIC").equalsIgnoreCase("true")?true:false),false,(request.getParameter("DB_EMERALD")!=null&&request.getParameter("DB_EMERALD").equalsIgnoreCase("true")?true:false)};
  List results = new Vector();
  // List of values (in accordance with searchAttribute)
  results = new SpeciesDomain().findPopupLOV(new SpeciesSearchCriteria(searchAttribute,
                                                                       formBean.getSearchString(),
                                                                       relationOp),
                                                       SessionManager.getShowEUNISInvalidatedSpecies(),
                                                       searchAttribute,
                                                       source_db);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=contentManagement.getContent("sites_species-choice_title", false )%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
      function setLine(val) {
        window.opener.document.eunis.searchString.value = val;
        window.close();
      }

      function editContent( idPage )
      {
        var url = "web-content-inline-editor.jsp?idPage=" + idPage;
        window.open( url ,'', "width=540,height=500,status=0,scrollbars=0,toolbar=0,resizable=1,location=0");
      }
      // -->
    </script>
  </head>
  <body>
<%
  if (results != null && results.size() > 0)
  {
    out.print(Utilities.getTextMaxLimitForPopup(contentManagement,(results == null ? 0 : results.size())));
    SpeciesSearchCriteria speciesSearch = new SpeciesSearchCriteria(searchAttribute,formBean.getSearchString(),relationOp);
%>
    <h6>List of values for:</h6>
    <u>
      <%=speciesSearch.getHumanMappings().get(searchAttribute)%>
    </u>
<%
    if (null != formBean.getSearchString() && null != relationOp)
    {
%>
    <em>
      <%=Utilities.ReturnStringRelatioOp(relationOp)%>
    </em >
    <strong>
      <%=formBean.getSearchString()%>
    </strong>
<%
    }
%>
    <br />
    <br />
    <div id="tab">
      <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    for ( int i = 0; i < results.size(); i++ )
    {
      String value = ( String )results.get( i );
%>
        <tr>
          <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="Click link to select the value" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(value)%>');"><%=value%></a>
          </td>
        </tr>
<%
    }
%>
      </table>
    </div>
<%
    if(searchAttribute.intValue() == SpeciesSearchCriteria.SEARCH_GROUP.intValue() ||
            searchAttribute.intValue() == SpeciesSearchCriteria.SEARCH_VERNACULAR.intValue() ||
            searchAttribute.intValue() == SpeciesSearchCriteria.SEARCH_COUNTRY.intValue() ||
            searchAttribute.intValue() == SpeciesSearchCriteria.SEARCH_REGION.intValue())
    {
        out.print(Utilities.getTextWarningForPopup((results == null ? 0 : results.size())));
    }
  }
  else
  {
%>
    <strong>
      <%=contentManagement.getContent("sites_species-choice_01")%>
    </strong>
    <br />
<%
  }
%>
    <br />
    <form action="">
      <input title="Close window" type="button" value="Close" onclick="javascript:window.close()" name="button" class="inputTextField" />
    </form>
  </body>
</html>