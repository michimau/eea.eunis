<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick species, show references' function - Display in a popup species which are referenced by legal instrument.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page import="java.util.List,
                ro.finsiel.eunis.jrfTables.species.references.*,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement,
                java.util.ArrayList" %>
<%// Get form parameters here%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.references.ReferencesBean" scope="request">
<jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=contentManagement.getContent("species_books-detail_title", false )%>
    </title>
    <script language="JavaScript" type="text/javascript">
    <!--
      function setLine(val) {
        window.opener.document.eunis.scientificName.value=val;
        window.close();
      }
    // -->
    </script>
  </head>
  <%
    SpeciesBooksDomain domain = new SpeciesBooksDomain(formBean.toSearchCriteria(),SessionManager.getShowEUNISInvalidatedSpecies());
    // List of species scientific names related to this reference
    List results = new ArrayList();
    try
    {
      results = domain.getSpeciesForAReference(request.getParameter("id"));
    } catch(Exception e) {e.printStackTrace();}
    int resultSize = (null == results ? 0 : results.size());
  %>
  <body style="background-color:#ffffff">
    <table summary="layout" width="275" border="0" cellspacing="0" cellpadding="0">
      <tr style="background-color:#EEEEEE">
        <td>
          <strong>
            <%=contentManagement.getContent("species_books-detail_01")%>:
          </strong>
        </td>
      </tr>
      <tr>
       <td width="201">
          <%=contentManagement.getContent("species_books-detail_02")%>:<strong> <%=resultSize%> </strong>
       </td>
      </tr>
      <%
      if (results != null && results.size() > 0)
      {
      %>
      <tr>
       <td>
       <table summary="list of species" width="275" border="1" cellspacing="0" cellpadding="0">
        <%
        // Display results.
        for(int i =0;i<results.size();i++)
        {
        SpeciesBooksPersist specie = (SpeciesBooksPersist) results.get(i);
        %>
        <tr>
          <td style="background-color:<%=(0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE"%>">
             <%=Utilities.formatString(specie.getName(),"&nbsp;")%>
          </td>
        </tr>
      <%
        }
      %>
       </table>
       </td>
      </tr>
       <%
      } else {
       %>
         <tr>
           <td>
             <strong>
              <%=contentManagement.getContent("species_books-detail_03")%>.
            </strong>
           </td>
         </tr>
         <%
             }
         %>
    </table>
    <br />
    <form action="">
      <label for="button1" class="noshow"><%=contentManagement.getContent("species_books-detail_04")%></label>
      <input id="button1" type="button" title="Close window" value="<%=contentManagement.getContent("species_books-detail_04")%>" onclick="javascript:window.close()" name="button2" class="inputTextField" />
    </form>
  </body>
</html>