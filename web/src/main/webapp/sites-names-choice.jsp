<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites names" function - Popup for list of values in search page. Also used in "Sites neighborhood" function.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.List, java.util.Iterator,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement"%>
<%@page import="ro.finsiel.eunis.jrfTables.Chm62edtSitesDomain"%>
<%@page import="ro.finsiel.eunis.jrfTables.Chm62edtSitesPersist"%>
<%@ page import="ro.finsiel.eunis.search.SourceDb" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // getSearchString() - String to be searched
  String searchString = request.getParameter("englishName");
  boolean expandFullNames = Utilities.checkedStringToBoolean(request.getParameter("showAll"), false);
  Integer operand = Utilities.checkedStringToInt(request.getParameter("relationOp"), Utilities.OPERATOR_CONTAINS);

    SourceDb sourceDb = SourceDb.noDatabase();

    sourceDb.add(SourceDb.Database.NATURA2000,
            request.getParameter("DB_NATURA2000") != null);
    sourceDb.add(SourceDb.Database.CORINE,
            request.getParameter("DB_CORINE") != null);
    sourceDb.add(SourceDb.Database.DIPLOMA,
            request.getParameter("DB_DIPLOMA") != null);
    sourceDb.add(SourceDb.Database.CDDA_NATIONAL,
            request.getParameter("DB_CDDA_NATIONAL") != null);
    sourceDb.add(SourceDb.Database.CDDA_INTERNATIONAL,
            request.getParameter("DB_CDDA_INTERNATIONAL") != null);
    sourceDb.add(SourceDb.Database.BIOGENETIC,
            request.getParameter("DB_BIOGENETIC") != null);
    sourceDb.add(SourceDb.Database.EMERALD,
            request.getParameter("DB_EMERALD") != null);

  StringBuffer query = Utilities.prepareSQLOperator("NAME", searchString, operand);
  query = Utilities.getConditionForSourceDB(query,sourceDb,"chm62edt_sites");
  query.append(" GROUP BY NAME ORDER BY NAME ASC ");
  if (!expandFullNames) { query.append(" LIMIT 0, " + Utilities.MAX_POPUP_RESULTS); }
  // Execute de query
  List sites = new Chm62edtSitesDomain().findWhere(query.toString());
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
        var str = new String( val );
        str = str.replace("QUOTE", "'");
        window.opener.document.eunis.englishName.value=str;
        window.close();
      }
    //]]>
    </script>
  </head>
  <body>
<%
  if (sites != null && sites.size() > 0)
  {
    out.print(Utilities.getTextMaxLimitForPopup(cm,(sites == null ? 0 : sites.size())));
  }
  Iterator it = sites.iterator();
  if (sites!=null && !sites.isEmpty())
  {
%>
    <h2>
      <%=cm.cmsPhrase("List of values for:")%>:
    </h2>
    <u>
      <%=cm.cmsPhrase("Site name")%>
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
      <table summary="<%=cm.cmsPhrase("List of values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    int i = 0;
    while (it.hasNext())
    {
      Chm62edtSitesPersist site = (Chm62edtSitesPersist)it.next();
%>
        <tr>
          <td bgcolor="<%=(0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="<%=cm.cmsPhrase("Click link to select the value")%>" href="javascript:setLine('<%=site.getName().replaceAll( "'", "QUOTE")%>');"><%=Utilities.treatURLAmp( site.getName() )%></a>
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
        <%=cm.cmsPhrase("No results were found.")%></strong>
      <br />
      <br />
<%
  }
%>
      <form action="">
        <input type="button" onClick="javascript:window.close();" value="<%=cm.cmsPhrase("Close")%>" title="<%=cm.cmsPhrase("Close window")%>" id="button2" name="button" class="standardButton" />
      </form>
  </body>
</html>
