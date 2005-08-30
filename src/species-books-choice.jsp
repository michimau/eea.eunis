<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show references' function - Popup for list of values in search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page import="java.util.List,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement"%>
<%@page import="ro.finsiel.eunis.jrfTables.species.references.SpeciesBooksDomain"%>
<%@page import="ro.finsiel.eunis.jrfTables.species.references.SpeciesBooksPersist"%><%@ page import="java.util.ArrayList"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=contentManagement.getContent("species_books-choice_title", false )%>
    </title>
     <script language="JavaScript" type="text/javascript">
    <!--
      function setLine(val)
      {
        window.opener.document.eunis.scientificName.value=val;
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
  <%// Get form parameters here%>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.references.ReferencesBean" scope="request">
    <jsp:setProperty name="formBean" property="*"/>
  </jsp:useBean>
  <%
    // List of species scientific names
    SpeciesBooksDomain domain = new SpeciesBooksDomain(formBean.toSearchCriteria(),SessionManager.getShowEUNISInvalidatedSpecies());
    // ID_DC value is NULL here
    List results = new ArrayList();
    try
    {
      results = domain.getSpeciesForAReference(null);
    } catch(Exception e) {e.printStackTrace();}
  %>
  <body style="background-color:#ffffff">
  <%     
      if (results != null && results.size() > 0)
      {
        out.print(Utilities.getTextMaxLimitForPopup(contentManagement,results.size()));
      }
    %>
<%
  // On can display the title of this popup, if exist results
  if (results != null && results.size() > 0) {
%>
<h6>List of values for:</h6>
<u><%=contentManagement.getContent("species_books-choice_01")%></u>
<em><%=Utilities.ReturnStringRelatioOp(Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS))%></em>
<strong><%=formBean.getScientificName()%></strong>
<br />
<br />
<%
  }
  if (results != null && results.size() > 0)
    {
  %>
      <div id="tab">
      <table summary="List of species" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse; border-color:#111111" width="100%">
      <%
        // Display results
        for(int i = 0; i < results.size(); i++)
        {
          SpeciesBooksPersist specie = (SpeciesBooksPersist) results.get(i);
      %>
          <tr>
            <td style="background-color:<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
              <a title="Choose an element" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(specie.getName())%>');"><%=specie.getName()%></a>
            </td>
          </tr>
      <%
        }
      %>
      </table>
      </div>
      <%
         //out.print(Utilities.getTextMaxLimitForPopup((results == null ? 0 : results.size())));
        } else
          {
      %>
          <strong><%=contentManagement.getContent("species_books-choice_02")%>.</strong>
          <br />
      <%
          }
      %>
    <br />
    <form action="">
      <label for="button1" class="noshow"><%=contentManagement.getContent("species_books-choice_03", false )%></label>
      <input id="button1" title="Close window" type="button" value="<%=contentManagement.getContent("species_books-choice_03", false )%>" onclick="javascript:window.close()" name="button" class="inputTextField" />
    </form>
  </body>
</html>