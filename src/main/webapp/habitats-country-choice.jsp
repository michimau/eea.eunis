<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats country' function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.search.CountryUtil,
                ro.finsiel.eunis.search.Utilities" %>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="java.util.List"%>
<%@ page import="ro.finsiel.eunis.utilities.TableColumns"%>
<%@ page import="ro.finsiel.eunis.jrfTables.habitats.country.CountryDomain"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
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
    <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.country.CountryBean" scope="request">
      <jsp:setProperty name="formBean" property="*" />
    </jsp:useBean>

  <%
      //Utilities.dumpRequestParams(request);

    // Request parameters
    String field = request.getParameter("field");
    int whichclicked = Utilities.checkedStringToInt(request.getParameter("whichclicked"), 0);

    String SQL_DRV = application.getInitParameter("JDBC_DRV");
    String SQL_URL = application.getInitParameter("JDBC_URL");
    String SQL_USR = application.getInitParameter("JDBC_USR");
    String SQL_PWD = application.getInitParameter("JDBC_PWD");

    SQLUtilities sqlc = new SQLUtilities();
    sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

    Integer database = Utilities.checkedStringToInt(request.getParameter("database"), CountryDomain.SEARCH_EUNIS);

    String idNOList = CountryUtil.listIDNOForHabitatCountryLOV(request, sqlc, database);

    String sql =  "" ;
     if(0 == whichclicked)
       sql += " SELECT DISTINCT C.AREA_NAME_EN ";
     else
       sql += " SELECT DISTINCT D.NAME ";

      if(0 == whichclicked)
              sql += " FROM CHM62EDT_COUNTRY AS C ";
      else
              sql += " FROM CHM62EDT_BIOGEOREGION AS D ";


    if(0 == whichclicked)
    {
            sql += " INNER JOIN CHM62EDT_REPORTS AS B ON B.ID_GEOSCOPE = C.ID_GEOSCOPE ";
            sql += " LEFT OUTER JOIN CHM62EDT_BIOGEOREGION AS D ON B.ID_GEOSCOPE_LINK = D.ID_GEOSCOPE ";
    }
    else
    {
            sql += " INNER JOIN CHM62EDT_REPORTS AS B ON B.ID_GEOSCOPE_LINK = D.ID_GEOSCOPE ";
            sql += " LEFT OUTER JOIN CHM62EDT_COUNTRY AS C ON B.ID_GEOSCOPE = C.ID_GEOSCOPE ";
    }

     sql += idNOList.trim().length() > 0 ?  " where " + idNOList : "";

     String country = request.getParameter("_0country");
     String region = request.getParameter("_0region");

      if(null != country && country.trim().length() > 0)
        sql += " and c.area_name_en = '" + country + "' ";
      if(null != region && region.trim().length() > 0)
        sql += " and d.name = '" + region + "' "; 

     if(0 == whichclicked)
       sql += " ORDER BY C.AREA_NAME_EN ";
     else
       sql += " ORDER BY D.NAME ";

      List results = sqlc.ExecuteSQLReturnList(sql,1);

  %>
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
function setCountry(val) {
  window.opener.document.eunis.<%=field%>.value=val;
      window.close();
    }
    function setRegion(val) {
      window.opener.document.eunis.<%=field%>.value=val;
      window.close();
    }
    //]]>
  </script>
</head>

<body>
<h2><%=cm.cmsText("List of values for:")%></h2>
<u><%=(0 == whichclicked ? cm.cmsText("Country names") : cm.cmsText("Region names"))%></u>
<br />
<br />

<div id="tab">
  <table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
    <%
        int i = 0;
        for(int j=0;j<results.size();j++)
        {
          String name = (String)((TableColumns) results.get(j)).getColumnsValues().get(0);
    %>
    <tr>
      <td bgcolor="<%=(0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
     <%
         if(0 == whichclicked)
         {
     %>
        <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setCountry('<%=name%>');"><%=name%></a>
        <%=cm.cmsTitle("click_link_to_select_value")%>
     <%
     }else {
     %>
          <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setRegion('<%=name%>');"><%=name%></a>
          <%=cm.cmsTitle("click_link_to_select_value")%>
      <%
          }
      %>
      </td>
    </tr>
    <%
        }
    %>
  </table>
</div>
<%=Utilities.getTextMaxLimitForPopup(cm, results.size())%>
<form action="">
  <input title="<%=cm.cms("close_window")%>" type="button" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" name="button" id="button" class="standardButton" />
</form>
<%=cm.cmsInput("close_btn")%>
<%=cm.br()%>
<%=cm.cmsMsg("list_of_values")%>
<%=cm.br()%>
<%=cm.cmsTitle("list_of_values")%>
<%=cm.br()%>
</body>
</html>
