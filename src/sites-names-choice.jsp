<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites names" function - Popup for list of values in search page. Also used in "Sites neighborhood" function.
--%>
<%@page contentType="text/html"%>
<%@page import="java.util.List, java.util.Iterator,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement"%>
<%@page import="ro.finsiel.eunis.jrfTables.Chm62edtSitesDomain"%>
<%@page import="ro.finsiel.eunis.jrfTables.Chm62edtSitesPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
  // getSearchString() - String to be searched
  String searchString = request.getParameter("englishName");
  boolean expandFullNames = Utilities.checkedStringToBoolean(request.getParameter("showAll"), false);
  Integer operand = Utilities.checkedStringToInt(request.getParameter("relationOp"), Utilities.OPERATOR_CONTAINS);
  boolean[] source = {
    request.getParameter( "DB_NATURA2000" ) != null,
    request.getParameter( "DB_CORINE" ) != null,
    request.getParameter( "DB_DIPLOMA" ) != null,
    request.getParameter( "DB_CDDA_NATIONAL" ) != null,
    request.getParameter( "DB_CDDA_INTERNATIONAL" ) != null,
    request.getParameter( "DB_BIOGENETIC" ) != null,
    false,
    request.getParameter( "DB_EMERALD" ) != null
  };
  String[] db = { "Natura2000","Corine","Diploma","CDDA_National","CDDA_International","Biogenetic","NatureNet","Emerald" };
  StringBuffer query = Utilities.prepareSQLOperator("NAME", searchString, operand);
  query = Utilities.getConditionForSourceDB(query,source,db,"CHM62EDT_SITES");
  query.append(" GROUP BY NAME ORDER BY NAME ASC ");
  if (!expandFullNames) { query.append(" LIMIT 0, " + Utilities.MAX_POPUP_RESULTS); }
  // Execute de query
  List sites = new Chm62edtSitesDomain().findWhere(query.toString());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=contentManagement.getContent("sites_names-choice_title", false )%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
      function setLine(val) {
        var str = new String( val );
        str = str.replace("QUOTE", "'");
        window.opener.document.eunis.englishName.value=str;
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
  if (sites != null && sites.size() > 0)
  {
    out.print(Utilities.getTextMaxLimitForPopup(contentManagement,(sites == null ? 0 : sites.size())));
  }
  Iterator it = sites.iterator();
  if (sites!=null && !sites.isEmpty())
  {
%>
    <h6>List of values for:</h6>
    <u>
      <%=contentManagement.getContent("sites_names-choice_01")%>
    </u>
    <em>
      <%=Utilities.ReturnStringRelatioOp(operand)%>
    </em>
    <strong>
      <%=searchString%>
    </strong>
    <br />
    <br />
    <div id="tab">
      <table border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
<%
    int i = 0;
    while (it.hasNext())
    {
      Chm62edtSitesPersist site = (Chm62edtSitesPersist)it.next();
%>
        <tr>
          <td bgcolor="<%=(0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="Click link to select the value" href="javascript:setLine('<%=site.getName().replaceAll( "'", "QUOTE")%>');"><%=Utilities.treatURLAmp( site.getName() )%></a>
          </td>
        </tr>
<%
    }
%>
      </table>
      </div>
      <br />
<%
  }
  else
  {
%>
      <strong>
        <%=contentManagement.getContent("sites_names-choice_02")%></strong>
      <br />
      <br />
<%
  }
%>
      <form action="">
        <input title="Close window" type="button" value="Close" onclick="javascript:window.close()" name="button" class="inputTextField" />
      </form>
  </body>
</html>