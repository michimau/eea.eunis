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

  StringBuffer sql = new StringBuffer();
  sql.append("DESCRIPTION LIKE '%" + name + "%'");
  //sql = Utilities.getConditionForSourceDB(sql,source_db,db,"chm62edt_designations");
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
      <%=cm.cmsPhrase("List of values")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
      function setLine(val) {
        window.opener.document.eunis.designation.value=val;
        window.close();
      }
      //]]>
    </script>
  </head>
  <body>
    <h2>
      <%=cm.cmsPhrase("List of values for:")%>:
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
      <%=cm.cmsPhrase("Designation name")%>
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
      <table summary="<%=cm.cmsPhrase("List of values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
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
            <a title="<%=cm.cmsPhrase("Click link to select the value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(description)%>');"><%=description%></a>
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
      <%=cm.cmsPhrase("No results were found.")%>
    </strong>
    <br />
    <br />
<%
  }
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <form action="">
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cmsPhrase("Close")%>" title="<%=cm.cmsPhrase("Close window")%>" id="button2" name="button" class="standardButton" />
    </form>
  </body>
</html>
