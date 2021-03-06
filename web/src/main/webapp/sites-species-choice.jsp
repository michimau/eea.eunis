<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick species, show sites" function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.List,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.jrfTables.sites.species.SpeciesDomain,
                java.util.Vector,
                ro.finsiel.eunis.search.sites.species.SpeciesSearchCriteria,
                ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.search.SourceDb" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.species.SpeciesBean" scope="page">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
  Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME);

    SourceDb sourceDb = SourceDb.noDatabase();

    sourceDb.add(SourceDb.Database.NATURA2000,
            request.getParameter("DB_NATURA2000") != null && request.getParameter("DB_NATURA2000").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.CORINE,
            request.getParameter("DB_CORINE") != null && request.getParameter("DB_CORINE").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.DIPLOMA,
            request.getParameter("DB_DIPLOMA") != null && request.getParameter("DB_DIPLOMA").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.CDDA_NATIONAL,
            request.getParameter("DB_CDDA_NATIONAL") != null && request.getParameter("DB_CDDA_NATIONAL").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.CDDA_INTERNATIONAL,
            request.getParameter("DB_CDDA_INTERNATIONAL") != null && request.getParameter("DB_CDDA_INTERNATIONAL").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.BIOGENETIC,
            request.getParameter("DB_BIOGENETIC") != null && request.getParameter("DB_BIOGENETIC").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.EMERALD,
            request.getParameter("DB_EMERALD") != null && request.getParameter("DB_EMERALD").equalsIgnoreCase("true"));


    List results = new SpeciesDomain().findPopupLOV(new SpeciesSearchCriteria(searchAttribute,
                                                                       formBean.getSearchString(),
                                                                       relationOp),
                                                       SessionManager.getShowEUNISInvalidatedSpecies(),
                                                       searchAttribute,
                                                       sourceDb);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=cm.cmsPhrase("List of values")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
      function setLine(val) {
        window.opener.document.eunis.searchString.value = val;
        window.close();
      }
      //]]>
    </script>
  </head>
  <body>
<%
  if (results != null && results.size() > 0)
  {
    out.print(Utilities.getTextMaxLimitForPopup(cm,(results == null ? 0 : results.size())));
    SpeciesSearchCriteria speciesSearch = new SpeciesSearchCriteria(searchAttribute,formBean.getSearchString(),relationOp);
%>
    <h2>
      <%=cm.cmsPhrase("List of values for:")%>:
    </h2>
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
      <table summary="<%=cm.cmsPhrase("List of values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    for ( int i = 0; i < results.size(); i++ )
    {
      String value = ( String )results.get( i );
%>
        <tr>
          <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="<%=cm.cmsPhrase("Click link to select the value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(value)%>');"><%=value%></a>
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
      <%=cm.cmsPhrase("No results were found.")%>
    </strong>
    <br />
<%
  }
%>
    <br />
    <form action="">
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cmsPhrase("Close")%>" title="<%=cm.cmsPhrase("Close window")%>" id="button2" name="button" class="standardButton" />
    </form>
  </body>
</html>
