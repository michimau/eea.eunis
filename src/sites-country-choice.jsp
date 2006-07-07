<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites country" function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.jrfTables.*,java.util.*,
                ro.finsiel.eunis.search.CountryUtil,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String field = request.getParameter("field");
  String _country = request.getParameter("country");
  if ( null == _country ) _country = "%";
  List list = CountryUtil.findAllCountriesMatchingName(_country);
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
      function setCountry(val) {
        window.opener.document.eunis.<%=field%>.value=val;
        window.close();
      }
      // -->
    </script>
  </head>
  <body>
<%
  if (list!=null && list.size() > 0)
  {
%>
    <%=Utilities.getTextMaxLimitForPopup(cm, list.size() )%>
    <h2>
      <%=cm.cmsText("list_of_values_for")%>:
    </h2>
<%
    if ( _country.equalsIgnoreCase( "" ) )
    {
%>
    <%=cm.cms("sites_country_choice_allcountries")%>
<%
    }
    else
    {
%>
    <u>
      <%=cm.cmsText("country_name")%>
    </u>
    <em>
      <%=Utilities.ReturnStringRelatioOp( Utilities.OPERATOR_CONTAINS )%>
    </em>
    <strong>
      <%=_country%>
    </strong>
<%
    }
%>
    <br />
    <br />
    <div id="tab">
      <table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    int i = 0;
    Iterator regionsIt = list.iterator();
    while (regionsIt.hasNext())
    {
      Chm62edtCountryPersist country = (Chm62edtCountryPersist)regionsIt.next();
%>
        <tr>
          <td bgcolor="<%=(0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setCountry('<%=country.getAreaNameEnglish()%>')"><%=country.getAreaNameEnglish()%></a>
            <%=cm.cmsTitle("click_link_to_select_value")%>
          </td>
        </tr>
<%
    }
%>
      </table>
<%
  }
  else
  {
%>
    <strong>
      <%=cm.cmsText("no_results_found_1")%>
    </strong>
    <br />
    <br />
<%
  }
%>
    </div>
    <br />
      <form action="">
        <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_btn")%>" title="<%=cm.cms("close_window")%>" id="button2" name="button" class="standardButton" />
        <%=cm.cmsTitle("close_window")%>
        <%=cm.cmsInput("close_btn")%>
      </form>
    <%=cm.cmsMsg("list_of_values")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("list_of_values")%>
  </body>
</html>