<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats country' function - Popup for list of values in search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
<%@ page import="ro.finsiel.eunis.WebContentManagement,ro.finsiel.eunis.jrfTables.Chm62edtBiogeoregionPersist,
                ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist,
                ro.finsiel.eunis.search.CountryUtil,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.species.country.CountryWrapper,
                ro.finsiel.eunis.search.species.country.RegionWrapper" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities"%>
<%@ page import="java.util.List"%>
<%@ page import="ro.finsiel.eunis.utilities.TableColumns"%>
<%@ page import="ro.finsiel.eunis.jrfTables.habitats.country.CountryDomain"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=contentManagement.getContent("habitats_country-choice_title", false)%>
  </title>
    <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.country.CountryBean" scope="request">
      <jsp:setProperty name="formBean" property="*" />
    </jsp:useBean>

  <%
      //Utilities.dumpRequestParams(request);

    // Request parameters
    String field = request.getParameter("field");
    int whichclicked = Utilities.checkedStringToInt(request.getParameter("whichclicked"), 0);

    String SQL_DRV="";
    String SQL_URL="";
    String SQL_USR="";
    String SQL_PWD="";

    SQL_DRV = application.getInitParameter("JDBC_DRV");
    SQL_URL = application.getInitParameter("JDBC_URL");
    SQL_USR = application.getInitParameter("JDBC_USR");
    SQL_PWD = application.getInitParameter("JDBC_PWD");

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
  <!--
function setCountry(val) {
  window.opener.document.eunis.<%=field%>.value=val;
      window.close();
    }
    function setRegion(val) {
      window.opener.document.eunis.<%=field%>.value=val;
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
<h6>List of values for:</h6>
<u><%=(0 == whichclicked ? "Country names" : "Region names")%></u>
<br />
<br />

<div id="tab">
  <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
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
        <a title="Click link to select the value" href="javascript:setCountry('<%=name%>');"><%=name%></a>
     <%
     }else {
     %>
          <a title="Click link to select the value" href="javascript:setRegion('<%=name%>');"><%=name%></a>
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
<%=Utilities.getTextMaxLimitForPopup(contentManagement, results.size())%>
<form action="">
  <label for="button" class="noshow">Close window</label>
  <input title="Close window" type="button" value="<%=contentManagement.getContent("habitats_country-choice_01", false )%>" onclick="javascript:window.close()" name="button" id="button" class="inputTextField" />
</form>
<%=contentManagement.writeEditTag("habitats_country-choice_01")%>
</body>
</html>