<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitats, show references' function - Display in a popup habitats referenced by legal text.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksDomain,
                ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksPersist,
                ro.finsiel.eunis.search.Utilities"%>
<%@page import="java.util.List"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title>
    <%=contentManagement.getContent("habitats_habitats-books-detail_title", false )%>
  </title>
  <script language="JavaScript" type="text/javascript">
  <!--
   function setLine(val)
   {
     window.opener.document.eunis.scientificName.value=val;
     window.close();
   }
  // -->
  </script>
</head>
<%// Get form parameters here%>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.references.ReferencesBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  // Request parameter
  Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), HabitatsBooksDomain.SEARCH_EUNIS);
  HabitatsBooksDomain habitatsBooks = new HabitatsBooksDomain(formBean.toSearchCriteria(),database);
  // Set the result list
  List results = habitatsBooks.getHabitatsByReferences(request.getParameter("id"),true);
%>
<body>
<%
  // If results exist, list the results
  if (results.size() > 0)
  {
%>
<table summary="Reference details" width="275" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td bgcolor="#EEEEEE">
      <strong>
        <%=contentManagement.getContent("habitats_habitats-books-detail_01")%> :
      </strong>
    </td>
  </tr>
  <tr>
    <td>
      <%=contentManagement.getContent("habitats_habitats-books-detail_02")%> : <strong> <%=results.size()%> </strong>
    </td>
  </tr>
  <tr>
    <td>
      <table summary="Habitat type" width="275" border="1" cellspacing="0" cellpadding="0" style="border-collapse: collapse" >
        <%
          for(int i =0;i<results.size();i++)
          {
            HabitatsBooksPersist habitat = (HabitatsBooksPersist) results.get(i);
            String n = (habitat.getScientificName()==null?"":habitat.getScientificName());
            if(!n.equalsIgnoreCase(""))
            {
        %>
        <tr>
          <td bgcolor="<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>"><%=n%></td>
        </tr>
        <%
            }
          }
        %>
      </table>
    </td>
  </tr>
</table>
<%
}
else
{
%>
<br />
<%=contentManagement.getContent("habitats_habitats-books-detail_03")%>
<%
  }
%>
<br />
<label for="button" class="noshow">Close window</label>
<input type="button" title="Close window" value="<%=contentManagement.getContent("habitats_habitats-books-detail_04", false )%>" onclick="javascript:window.close()" name="button" id="button" class="inputTextField">
<%=contentManagement.writeEditTag( "habitats_habitats-books-detail_04" )%>
</body>
</html>