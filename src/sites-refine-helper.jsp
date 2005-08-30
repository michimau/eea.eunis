<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Popup page for refine criteria in sites search result pages
--%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.sites.names.NameSearchCriteria,
                 ro.finsiel.eunis.search.CountryUtil,
                 java.util.List,
                 java.util.Iterator,
                 ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist,
                 ro.finsiel.eunis.search.sites.size.SizeSearchCriteria,
                 ro.finsiel.eunis.search.sites.SitesSearchCriteria,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page contentType="text/html"%>
<%-- This is the helper displayed when user presses the question icon on the "Refine your search" in Sites module --%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();
  // What type of information this tip should display, for example Source data set, country etc.
  int criteria = Utilities.checkedStringToInt(request.getParameter( "criteria" ), -1);
%>
    <title>
      <%=contentManagement.getContent("sites_refine-helper_title", false )%>
    </title>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript">
      <!--
      function setLine(val)
      {
        var control = eval(window.opener.document.getElementById("criteriaSearch0")).value = val;
        window.close();
      }
      //-->
    </script>
  </head>
  <body>
<%
  if ( criteria == SitesSearchCriteria.CRITERIA_SOURCE_DB.intValue() )
  {
%>
      <%=contentManagement.getContent("sites_refine-helper_01")%>
    <table border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
      <tr>
        <td bgcolor="#EEEEEE">
          <a title="Click link to select the value" href="javascript:setLine('CDDA National')"><%=contentManagement.getContent("sites_refine-helper_02")%></a>
        </td>
      </tr>
      <tr>
        <td>
          <a title="Click link to select the value" href="javascript:setLine('CDDA International')"><%=contentManagement.getContent("sites_refine-helper_03")%></a>
        </td>
      </tr>
      <tr>
        <td bgcolor="#EEEEEE">
          <a title="Click link to select the value" href="javascript:setLine('Corine biotopes')"><%=contentManagement.getContent("sites_refine-helper_04")%></a>
        </td>
      </tr>
      <tr>
        <td>
          <a title="Click link to select the value" href="javascript:setLine('Biogenetic reserve')"><%=contentManagement.getContent("sites_refine-helper_05")%></a>
        </td>
      </tr>
      <tr>
        <td bgcolor="#EEEEEE">
          <a title="Click link to select the value" href="javascript:setLine('European diploma')"><%=contentManagement.getContent("sites_refine-helper_06")%></a>
        </td>
      </tr>
      <tr>
        <td>
          <a title="Click link to select the value" href="javascript:setLine('Natura 2000')"><%=contentManagement.getContent("sites_refine-helper_07")%></a>
        </td>
      </tr>
      <tr>
        <td>
          <a title="Click link to select the value" href="javascript:setLine('Emerald')">Emerald</a>
        </td>
      </tr>
    </table>
<%
  }
  if (criteria == SitesSearchCriteria.CRITERIA_COUNTRY.intValue())
  {
    // List of all countries.
    List list = CountryUtil.findAllCountries();
    int i = 0;
    Iterator regionsIt = list.iterator();
%>
    <%=contentManagement.getContent("sites_refine-helper_08")%>
    <table border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    while ( regionsIt.hasNext() )
    {
      Chm62edtCountryPersist country = (Chm62edtCountryPersist)regionsIt.next();
      String color = (0 == ( i++ % 2 ) ) ? "#EEEEEE" : "#FFFFFF";
%>
      <tr>
        <td bgcolor="<%=color%>">
          <a title="Click link to select the value" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(country.getAreaNameEnglish())%>')"><%=country.getAreaNameEnglish()%></a>
        </td>
      </tr>
<%
    }
%>
    </table>
<%
  }
  if (criteria == SitesSearchCriteria.CRITERIA_COUNTRY.intValue())
  {
    // List of all countries.
    List list = CountryUtil.findAllCountries();
    int i = 0;
    Iterator regionsIt = list.iterator();
%>
      <%=contentManagement.getContent("sites_refine-helper_08")%>
    <table border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    while (regionsIt.hasNext())
    {
      Chm62edtCountryPersist country = (Chm62edtCountryPersist)regionsIt.next();
      String color = (0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF";
%>
      <tr>
        <td bgcolor="<%=color%>">
          <a title="Click link to select the value" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(country.getAreaNameEnglish())%>')"><%=country.getAreaNameEnglish()%></a>
        </td>
      </tr>
<%
    }
%>
    </table>
<%
  }
%>
    <br />
    <form action="">
      <input title="Close window" type="button" value="Close" onclick="javascript:window.close()" name="button" class="inputTextField" />
    </form>
  </body>
</html>