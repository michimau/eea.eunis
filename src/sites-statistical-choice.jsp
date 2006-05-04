<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Number/Total area" function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.List,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.sites.SitesSearchUtility,
                ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String name = Utilities.formatString( request.getParameter("designation"), "%" );
//  boolean[] source_db =
//  {
//    request.getParameter( "DB_NATURA2000" ) != null && request.getParameter( "DB_NATURA2000" ).equalsIgnoreCase( "true" ),
//    request.getParameter( "DB_CORINE" ) != null && request.getParameter( "DB_CORINE" ).equalsIgnoreCase( "true" ),
//    request.getParameter( "DB_DIPLOMA" ) != null && request.getParameter( "DB_DIPLOMA" ).equalsIgnoreCase( "true" ),
//    request.getParameter( "DB_CDDA_NATIONAL" ) != null && request.getParameter( "DB_CDDA_NATIONAL" ).equalsIgnoreCase( "true" ),
//    request.getParameter( "DB_CDDA_INTERNATIONAL" ) != null && request.getParameter( "DB_CDDA_INTERNATIONAL" ).equalsIgnoreCase( "true" ),
//    request.getParameter( "DB_BIOGENETIC" ) != null && request.getParameter( "DB_BIOGENETIC" ).equalsIgnoreCase( "true" ),
//    false,
//    request.getParameter( "DB_EMERALD" ) != null && request.getParameter( "DB_EMERALD" ).equalsIgnoreCase( "true" )
//  };
//  String[] db = {"Natura2000", "Corine", "Diploma", "CDDA_National", "CDDA_International", "Biogenetic", "NatureNet", "Emerald"};
  StringBuffer sql = new StringBuffer();
  sql.append("DESCRIPTION LIKE '%" + name + "%'");
  //sql = Utilities.getConditionForSourceDB(sql,source_db,db,"CHM62EDT_DESIGNATIONS");
  sql.append(" GROUP BY DESCRIPTION");

  List sites = SitesSearchUtility.findDesignationsWhere(sql.toString());
  if (sites.size() > 0)
  {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=cm.cms("list_of_values")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
      function setLine(val) {
        window.opener.document.eunis.designation.value=val;
        window.close();
      }
      // -->
    </script>
  </head>
  <body>
    <h2>
      <%=cm.cmsText("list_of_values_for")%>:
    </h2>
<%
  if ( name.equalsIgnoreCase( "%" ) )
  {
%>
    <%=cm.cms("sites_designations_choice_alldesignations")%>
<%
  }
  else
  {
%>
    <u>
      <%=cm.cmsText("designation_name")%>
    </u>
    <em>
      <%=Utilities.ReturnStringRelatioOp(Utilities.OPERATOR_CONTAINS)%>
    </em>
    <strong>
      <%=name%>
    </strong>
<%
  }
%>
    <br />
    <br />
    <div id="tab">
      <table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    for (int i = 0; i < sites.size(); i++)
    {
      Chm62edtDesignationsPersist designation = (Chm62edtDesignationsPersist)sites.get(i);
      String description = designation.getDescription();
      if (null != description && !description.equalsIgnoreCase(""))
      {
%>
        <tr bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
          <td>
            <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(description)%>');"><%=description%></a>
            <%=cm.cmsTitle("click_link_to_select_value")%>
          </td>
        </tr>
<%
        }
      }
%>
      </table>
    </div>
<%
    out.print(Utilities.getTextWarningForPopup((sites == null ? 0 : sites.size())));
  }
  else
  {
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <strong>
      <%=cm.cmsText("no_results_found_1")%>
    </strong>
    <br />
    <br />
<%
  }
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <form action="">
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_btn")%>" title="<%=cm.cms("close_window")%>" id="button2" name="button" class="inputTextField" />
      <%=cm.cmsTitle("close_window")%>
      <%=cm.cmsInput("close_btn")%>
    </form>
    <%=cm.cmsMsg("list_of_values")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("list_of_values")%>
  </body>
</html>