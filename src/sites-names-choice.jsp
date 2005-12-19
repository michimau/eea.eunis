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
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement cm = SessionManager.getWebContent();
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
      <%=cm.cms("sites_names-choice_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
      function setLine(val) {
        var str = new String( val );
        str = str.replace("QUOTE", "'");
        window.opener.document.eunis.englishName.value=str;
        window.close();
      }
    // -->
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
      <%=cm.cmsText("list_of_values_for")%>:
    </h2>
    <u>
      <%=cm.cmsText("sites_names-choice_01")%>
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
      <table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    int i = 0;
    while (it.hasNext())
    {
      Chm62edtSitesPersist site = (Chm62edtSitesPersist)it.next();
%>
        <tr>
          <td bgcolor="<%=(0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=site.getName().replaceAll( "'", "QUOTE")%>');"><%=Utilities.treatURLAmp( site.getName() )%></a>
            <%=cm.cmsTitle("click_link_to_select_value")%>
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
        <%=cm.cmsText("sites_names-choice_02")%></strong>
      <br />
      <br />
<%
  }
%>
      <form action="">
        <label for="button2" class="noshow"><%=cm.cms("close_window_label")%></label>
        <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_window_value")%>" title="<%=cm.cms("close_window_title")%>" id="button2" name="button" class="inputTextField" />
        <%=cm.cmsLabel("close_window_label")%>
        <%=cm.cmsTitle("close_window_title")%>
        <%=cm.cmsInput("close_window_value")%>
      </form>
    <%=cm.cmsMsg("sites_names-choice_title")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("list_of_values")%>
  </body>
</html>