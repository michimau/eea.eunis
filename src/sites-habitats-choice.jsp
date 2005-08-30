<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Pick habitat types, show sites" function - Popup for list of values in search page.
--%>
<%@page contentType="text/html"%>
<%@page import="java.util.List,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.jrfTables.sites.habitats.HabitatDomain,
                ro.finsiel.eunis.search.sites.habitats.HabitatSearchCriteria,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.sites.habitats.HabitatBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
  Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
  Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), HabitatDomain.SEARCH_EUNIS);
  Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), HabitatSearchCriteria.SEARCH_NAME);
//    boolean[] source_db = {
//      (request.getParameter("DB_NATURA2000") != null && request.getParameter("DB_NATURA2000").equalsIgnoreCase("true") ? true : false),
//      (request.getParameter("DB_CORINE") != null && request.getParameter("DB_CORINE").equalsIgnoreCase("true") ? true : false),
//      (request.getParameter("DB_DIPLOMA") != null && request.getParameter("DB_DIPLOMA").equalsIgnoreCase("true") ? true : false),
//      (request.getParameter("DB_CDDA_NATIONAL") != null && request.getParameter("DB_CDDA_NATIONAL").equalsIgnoreCase("true") ? true : false),
//      (request.getParameter("DB_CDDA_INTERNATIONAL") != null && request.getParameter("DB_CDDA_INTERNATIONAL").equalsIgnoreCase("true") ? true : false),
//      (request.getParameter("DB_BIOGENETIC") != null && request.getParameter("DB_BIOGENETIC").equalsIgnoreCase("true") ? true : false),
//      false,
//      (request.getParameter("DB_EMERALD") != null && request.getParameter("DB_EMERALD").equalsIgnoreCase("true") ? true:false)
//    };
  boolean[] source_db = { true, true, true, true, true, true, false, true }; // Default search in all data sets
  // List of values (in accordance with searchAttribute)
  List results = new HabitatDomain().findPopupLOV(new HabitatSearchCriteria(searchAttribute,
                                                                            formBean.getSearchString(),
                                                                            relationOp),
                                                  database,
                                                  searchAttribute,
                                                  source_db);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=contentManagement.getContent("sites_habitats-choice_title", false )%>
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
  if ( results != null && !results.isEmpty())
  {
    out.print( Utilities.getTextMaxLimitForPopup( contentManagement,( results.size() ) ) );
    HabitatSearchCriteria habitatSearch = new HabitatSearchCriteria(searchAttribute,formBean.getSearchString(),relationOp);
%>
    <h6>List of values for:</h6>
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
      <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    for (int i = 0; i < results.size(); i++)
    {
      String value = (String)results.get(i);
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
  }
  else
  {
%>
      <strong>
        <%=contentManagement.getContent("sites_habitats-choice_01")%>
      </strong>
<%
      }
%>
    <br />
    <form action="">
      <input title="Close window" type="button" value="Close" onclick="javascript:window.close()" name="button" class="inputTextField" />
    </form>
  </body>
</html>