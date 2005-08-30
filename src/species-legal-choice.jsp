<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species Legal instruments' function - Popup for list of values in search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page import="java.util.*,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.species.legal.LegalSearchCriteria,
                ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.utilities.TableColumns"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=contentManagement.getContent("species_legal-choice_title", false )%>
    </title>
    <%// use form bean here%>
    <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.legal.LegalBean" scope="page">
      <jsp:setProperty name="formBean" property="*"/>
    </jsp:useBean>
    <script language="JavaScript" type="text/javascript">
    <!--
      function setScientificName(val) {
        window.opener.document.eunis.scientificName.value=val;
        window.close();
      }
      function setLegalText(val) {
        window.opener.document.eunis2.legalText.value=val;
        window.close();
      }
      function editContent( idPage )
      {
        var url = 'web-content-inline-editor.jsp?idPage=' + idPage;
        window.open( url ,'', 'width=540,height=500,status=0,scrollbars=0,toolbar=0,resizable=1,location=0');
      }
    // -->
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
        out.print(Utilities.getTextMaxLimitForPopup(contentManagement,(results == null ? 0 : results.size())));
      }
    %>
      <%
        if (results != null && !results.isEmpty())
        {
      %>
          <h6>List of values for:</h6>
          <u><%=contentManagement.getContent("species_legal-choice_01")%></u>
          <em><%=Utilities.ReturnStringRelatioOp(Utilities.OPERATOR_CONTAINS)%></em>
          <strong><%=formBean.getScientificName()%></strong>
          <br />
          <br />
          <div id="tab">
          <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
          <%
            if (typeForm == LegalSearchCriteria.CRITERIA_SPECIES.intValue())
            {
              int i=0;
              // Display results.
              while (it.hasNext())
              {
              String speciesName = (String)((TableColumns)it.next()).getColumnsValues().get(0);
          %>
            <tr style="background-color:<%=(0 == (i++ % 2) ? "#EEEEEE" : "#FFFFFF")%>">
             <td>
               <a title="Choose this value" href="javascript:setScientificName('<%=speciesName%>');">
                 <%=speciesName%>
               </a>
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
       <strong><%=contentManagement.getContent("species_legal-choice_02")%>.</strong>
       <br />
       <br />
     <%
        }
     %>
    <br />
    <form action="">
       <label for="button" class="noshow"><%=contentManagement.getContent("species_legal-choice_03", false)%></label>
      <input id="button" title="Close window" type="button" value="<%=contentManagement.getContent("species_legal-choice_03", false)%>" onclick="javascript:window.close()" name="button" class="inputTextField" />
    </form>
  </body>
</html>