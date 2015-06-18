<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick habitat types, show sites" function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.List,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.jrfTables.sites.habitats.HabitatDomain,
                ro.finsiel.eunis.search.sites.habitats.HabitatSearchCriteria,
                ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.search.SourceDb" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.habitats.HabitatBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
  Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), HabitatDomain.SEARCH_EUNIS);
  Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), HabitatSearchCriteria.SEARCH_NAME);

  SourceDb sourceDb = SourceDb.allDatabases().remove(SourceDb.Database.NATURENET);  // Default search in all data sets
  // List of values (in accordance with searchAttribute)
  List results = new HabitatDomain().findPopupLOV(new HabitatSearchCriteria(searchAttribute,
                                                                            formBean.getSearchString(),
                                                                            relationOp),
                                                  database,
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
  if ( results != null && !results.isEmpty())
  {
    out.print( Utilities.getTextMaxLimitForPopup( cm,( results.size() ) ) );
    HabitatSearchCriteria habitatSearch = new HabitatSearchCriteria(searchAttribute,formBean.getSearchString(),relationOp);
%>
    <h2>
      <%=cm.cmsPhrase("List of values for:")%>:
    </h2>
    <u>
      <%=habitatSearch.getHumanMappings().get(searchAttribute)%>
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
    for (int i = 0; i < results.size(); i++)
    {
      String value = (String)results.get(i);
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
  }
  else
  {
%>
      <strong>
        <%=cm.cmsPhrase("No results were found.")%>
      </strong>
<%
      }
%>
    <br />
    <form action="">
      <label for="button2" class="noshow"><%=cm.cmsPhrase("Close window")%></label>
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cmsPhrase("Close")%>" title="<%=cm.cmsPhrase("Close window")%>" id="button2" name="button" class="standardButton" />
    </form>
  </body>
</html>
