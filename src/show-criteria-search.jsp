<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display saved search criterias per user, in all search pages.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.save_criteria.CriteriasForUsersDomain,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.save_criteria.CriteriasForUsersPersist,
                 ro.finsiel.eunis.search.save_criteria.SaveSearchCriteria"%><%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
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
  WebContentManagement cm = SessionManager.getWebContent();
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
    <img alt="<%=cm.cms("show_criteria_search_expand")%>" border="0" style="vertical-align:middle" src="images/mini/<%=(expandSearchCriteria.equals("yes") ? "collapse.gif" : "expand.gif")%>" />
    <%=cm.cmsAlt("show_criteria_search_expand")%>
    &nbsp;
    <a title="<%=cm.cms("show_criteria_search_expand")%>" href="<%=pageName%>?expandSearchCriteria=<%=(expandSearchCriteria.equals("yes") ? "no" : "yes")%>"><%=(expandSearchCriteria.equalsIgnoreCase("yes") ? cm.cms( "hide" ) :cm.cms( "show"))%> <%=cm.cmsText("saved_criteria")%></a>
    <%=cm.cmsTitle("show_criteria_search_expand")%>

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
    <a title="<%=cm.cms("show_criteria_search_delete")%>" href="javascript:setFormAndSubmit('<%=SessionManager.getUsername()%>','<%=pageName%>','<%=criteria.getNameCriteria()%>');"><img alt="<%=cm.cms("show_criteria_search_delete")%>" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" /></a>
    <%=cm.cmsTitle("show_criteria_search_delete")%>
    &nbsp;
    <a title="<%=cm.cms("saved_criteria")%>" href="<%=url%>"><%=description%></a>
<%
      }
    }
  }
}
%>
<br />
<%=cm.br()%>
<%=cm.cmsMsg( "hide" )%>
<%=cm.br()%>
<%=cm.cmsMsg( "show")%>
<%=cm.br()%>