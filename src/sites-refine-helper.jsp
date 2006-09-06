<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Popup page for refine criteria in sites search result pages
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.CountryUtil,
                 java.util.List,
                 java.util.Iterator,
                 ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist,
                 ro.finsiel.eunis.search.sites.SitesSearchCriteria,
                 ro.finsiel.eunis.WebContentManagement"%>
<%-- This is the helper displayed when user presses the question icon on the "Refine your search" in Sites module --%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
<%
  // What type of information this tip should display, for example Source data set, country etc.
  int criteria = Utilities.checkedStringToInt(request.getParameter( "criteria" ), -1);
%>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=cm.cms("list_of_values")%>
    </title>
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
      <%=cm.cmsText("sites_refine-helper_01")%>
    <table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
      <tr>
        <td bgcolor="#EEEEEE">
          <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('CDDA National')"><%=cm.cmsText("cdda_national")%></a>
          <%=cm.cmsTitle("click_link_to_select_value")%>
        </td>
      </tr>
      <tr>
        <td>
          <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('CDDA International')"><%=cm.cmsText("cdda_international")%></a>
          <%=cm.cmsTitle("click_link_to_select_value")%>
        </td>
      </tr>
      <tr>
        <td bgcolor="#EEEEEE">
          <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('Corine biotopes')"><%=cm.cmsText("corine_biotopes")%></a>
          <%=cm.cmsTitle("click_link_to_select_value")%>
        </td>
      </tr>
      <tr>
        <td>
          <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('Biogenetic reserve')"><%=cm.cmsText("biogenetic_reserve")%></a>
          <%=cm.cmsTitle("click_link_to_select_value")%>
        </td>
      </tr>
      <tr>
        <td bgcolor="#EEEEEE">
          <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('European diploma')"><%=cm.cmsText("european_diploma")%></a>
          <%=cm.cmsTitle("click_link_to_select_value")%>
        </td>
      </tr>
      <tr>
        <td>
          <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('Natura 2000')"><%=cm.cmsText("natura_2000")%></a>
          <%=cm.cmsTitle("click_link_to_select_value")%>
        </td>
      </tr>
      <tr>
        <td>
          <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('Emerald')"><%=cm.cmsText("emerald")%></a>
          <%=cm.cmsTitle("click_link_to_select_value")%>
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
    <%=cm.cmsText("sites_refine-helper_08")%>
    <table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    while ( regionsIt.hasNext() )
    {
      Chm62edtCountryPersist country = (Chm62edtCountryPersist)regionsIt.next();
      String color = (0 == ( i++ % 2 ) ) ? "#EEEEEE" : "#FFFFFF";
%>
      <tr>
        <td bgcolor="<%=color%>">
          <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(country.getAreaNameEnglish())%>')"><%=country.getAreaNameEnglish()%></a>
          <%=cm.cmsTitle("click_link_to_select_value")%>
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
      <%=cm.cmsText("sites_refine-helper_08")%>
    <table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    while (regionsIt.hasNext())
    {
      Chm62edtCountryPersist country = (Chm62edtCountryPersist)regionsIt.next();
      String color = (0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF";
%>
      <tr>
        <td bgcolor="<%=color%>">
          <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(country.getAreaNameEnglish())%>')"><%=country.getAreaNameEnglish()%></a>
          <%=cm.cmsTitle("click_link_to_select_value")%>
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
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_btn")%>" title="<%=cm.cms("close_window")%>" id="button2" name="button" class="standardButton" />
      <%=cm.cmsTitle("close_window")%>
      <%=cm.cmsInput("close_btn")%>
    </form>
    <%=cm.cmsMsg("list_of_values")%>
  </body>
</html>
