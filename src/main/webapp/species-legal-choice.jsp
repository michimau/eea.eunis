<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species Legal instruments' function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
	request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.*,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.species.legal.LegalSearchCriteria,
                ro.finsiel.eunis.search.species.SpeciesSearchUtility,"%>
<%@ page import="ro.finsiel.eunis.utilities.TableColumns"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
    	WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title>
      <%=cm.cms("list_of_values")%>
    </title>
    <%// use form bean here%>
    <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.legal.LegalBean" scope="page">
      <jsp:setProperty name="formBean" property="*"/>
    </jsp:useBean>
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
      function setScientificName(val) {
        window.opener.document.eunis.scientificName.value=val;
        window.close();
      }
      function setLegalText(val) {
        window.opener.document.eunis2.legalText.value=val;
        window.close();
      }
    //]]>
    </script>
  <%
    boolean expandFullNames = Utilities.checkedStringToBoolean(request.getParameter("showAll"), false);
    int typeForm = Utilities.checkedStringToInt(formBean.getTypeForm(), 0);
    List results = new Vector();
    // Coming from form 1
    if (typeForm == LegalSearchCriteria.CRITERIA_SPECIES.intValue())
    {
      // List of species related to a species group name
      String SQL_DRV = application.getInitParameter("JDBC_DRV");
      String SQL_URL = application.getInitParameter("JDBC_URL");
      String SQL_USR = application.getInitParameter("JDBC_USR");
      String SQL_PWD = application.getInitParameter("JDBC_PWD");

      results = SpeciesSearchUtility.findSpeciesFromGroup(formBean.getGroupName(), formBean.getScientificName(), expandFullNames,SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
    }
    Iterator it = results.iterator();
    %>
  </head>
  <body>
  <%
      if (results != null && results.size() > 0)
      {
        out.print(Utilities.getTextMaxLimitForPopup(cm,(results == null ? 0 : results.size())));
      }
    %>
      <%
        if (results != null && !results.isEmpty())
        {
      %>
          <h2><%=cm.cmsPhrase("List of values for:")%></h2>
          <u><%=cm.cmsPhrase("Species scientific name")%></u>
          <em><%=Utilities.ReturnStringRelatioOp(Utilities.OPERATOR_CONTAINS)%></em>
          <strong><%=formBean.getScientificName()%></strong>
          <br />
          <br />
          <div id="tab">
          <table summary="<%=cm.cms("list_of_values")%>" class="datatable">
          <%
            if (typeForm == LegalSearchCriteria.CRITERIA_SPECIES.intValue())
            {
              int i=0;
              // Display results.
              while (it.hasNext())
              {
                String cssClass = i++ % 2 == 0 ? "" : " class=\"zebraeven\"";
              String speciesName = (String)((TableColumns)it.next()).getColumnsValues().get(0);
          %>
            <tr<%=cssClass%>>
             <td>
               <a title="<%=cm.cms("choose_this_value")%>" href="javascript:setScientificName('<%=speciesName%>');">
                 <%=speciesName%>
               </a>
               <%=cm.cmsTitle("choose_this_value")%>
            </td>
           </tr>
          <%
              }
            }
        %>
          </table>
          </div>
      <%
          //out.print(Utilities.getTextWarningForPopup(100));
         } else
        {
      %>
       <strong><%=cm.cmsPhrase("No results were found")%>.</strong>
       <br />
       <br />
     <%
        }
     %>
    <br />
    <form action="">
      <input id="button" title="<%=cm.cms("close_window")%>" type="button" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" name="button" class="standardButton" />
      <%=cm.cmsTitle("close_window")%>
      <%=cm.cmsInput("close_btn")%>
    </form>

<%=cm.br()%>
<%=cm.cmsMsg("list_of_values")%>
<%=cm.br()%>
<%=cm.cmsMsg("list_of_values")%>
<%=cm.br()%>

  </body>
</html>
