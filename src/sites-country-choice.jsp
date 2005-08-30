<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites country" function - Popup for list of values in search page.
--%>
<%@page contentType="text/html"%>
<%@page import="ro.finsiel.eunis.jrfTables.*,java.util.*,
                ro.finsiel.eunis.search.CountryUtil,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
  String field = request.getParameter("field");
  String _country = request.getParameter("country");
  if ( null == _country ) _country = "%";
  List list = CountryUtil.findAllCountriesMatchingName(_country);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=contentManagement.getContent("sites_country-choice_title", false )%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
      function setCountry(val) {
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
<%
  if (list!=null && list.size() > 0)
  {
%>
    <%=Utilities.getTextMaxLimitForPopup(contentManagement, list.size() )%>
    <h6>List of values for:</h6>
<%
    if ( _country.equalsIgnoreCase( "" ) )
    {
%>
    All countries
<%
    }
    else
    {
%>
    <u>
      <%=contentManagement.getContent("sites_country-choice_01")%>
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
      <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    int i = 0;
    Iterator regionsIt = list.iterator();
    while (regionsIt.hasNext())
    {
      Chm62edtCountryPersist country = (Chm62edtCountryPersist)regionsIt.next();
%>
        <tr>
          <td bgcolor="<%=(0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="Click link to select the value" href="javascript:setCountry('<%=country.getAreaNameEnglish()%>')"><%=country.getAreaNameEnglish()%></a>
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
      <%=contentManagement.getContent("sites_country-choice_02")%>
    </strong>
    <br />
    <br />
<%
  }
%>
    </div>
    <br />
    <form action="">
      <input title="Close window" type="button" value="Close" onclick="javascript:window.close()" name="button" class="inputTextField" />
    </form>
  </body>
</html>