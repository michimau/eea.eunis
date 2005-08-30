<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display saved search criterias per user, in all search pages.
--%>
<%@ page import="ro.finsiel.eunis.jrfTables.save_criteria.CriteriasForUsersDomain,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.save_criteria.CriteriasForUsersPersist,
                 ro.finsiel.eunis.search.save_criteria.SaveSearchCriteria"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%@page contentType="text/html"%>
<form name="saveForm" method="post" action="delete-save-criteria.jsp">
  <input type ="hidden" name="userName" value="" />
  <input type ="hidden" name="pageName" value="" />
  <input type ="hidden" name="criteriaName" value="" />
</form>
<script language="JavaScript" type="text/javascript">
<!--
function setFormAndSubmit(userName,pageName,criteriaName) {
      document.saveForm.userName.value = userName;
      document.saveForm.pageName.value = pageName;
      document.saveForm.criteriaName.value = criteriaName;

      document.saveForm.submit();
   }
//-->
</script>
<%
// If user has this right
if( SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT() )
{
  String pageName = request.getParameter( "pageName" );
  String pageNameResult = request.getParameter( "pageNameResult" );
  String expandSearchCriteria = request.getParameter( "expandSearchCriteria" );
  List criterias = new CriteriasForUsersDomain().findWhere("USERNAME= '" + SessionManager.getUsername() + "' " +
          " AND FROM_WHERE= '" + pageName + "' " +
          " GROUP BY EUNIS_GROUP_SEARCH_CRITERIA.CRITERIA_NAME");
  if( criterias != null && criterias.size() > 0 )
  {
%>
    <img alt="Expand - Collapse" border="0" align="middle" src="images/mini/<%=(expandSearchCriteria.equals("yes") ? "collapse.gif" : "expand.gif")%>" />
    &nbsp;
    <a title="Expand-Collapse" href="<%=pageName%>?expandSearchCriteria=<%=(expandSearchCriteria.equals("yes") ? "no" : "yes")%>"><%=(expandSearchCriteria.equalsIgnoreCase("yes") ? "Hide" : "Show")%> saved search criteria</a>
<%
    if( expandSearchCriteria.equalsIgnoreCase( "yes" ) )
    {
      for ( int i = 0; i < criterias.size(); i++ )
      {
         CriteriasForUsersPersist criteria = (CriteriasForUsersPersist) criterias.get(i);
         // Get saved search criteria description
         String description = (criteria.getDescription() == null ? "" : criteria.getDescription());
         // Set URL parameters list
         String parameters = SaveSearchCriteria.getURLForUserNameAndPageName(SessionManager.getUsername(),
                                                                             pageName,
                                                                             criteria.getNameCriteria());
         String url = pageNameResult;
         if(parameters != null && parameters.length()>0)
         {
           url += parameters;
         }
%>
    <br />
    <a title="Delete saved criteria" href="javascript:setFormAndSubmit('<%=SessionManager.getUsername()%>','<%=pageName%>','<%=criteria.getNameCriteria()%>');"><img alt="Delete" src="images/mini/delete.jpg" border="0" align="middle" /></a>
    &nbsp;
    <a title="Saved criteria" href="<%=url%>"><%=description%></a>
<%
      }
    }
  }
}
%>
<br />