<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : In this page are saved species or habitats advanced search criteria.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.search.advanced.SaveAdvancedSearchCriteria,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title>
      <%=cm.cmsText("generic_save-search_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
        function closeWindow(where)
        {
          window.opener.location.href=where;
          self.close();
        }
      // -->
    </script>
  </head>
<%
  // Set IdSession and NatureObject variables
  String IdSession = request.getParameter("idsession");

  if(IdSession == null || IdSession.length()==0 || IdSession.equalsIgnoreCase("undefined")) {
    IdSession=request.getSession().getId();
  }

  String NatureObject = request.getParameter("natureobject");

  if(NatureObject == null || NatureObject.length()==0 || NatureObject.equalsIgnoreCase("undefined")) {
    NatureObject="";
  }

  // Set the database connection parameters
  String SQL_DRV;
  String SQL_URL;
  String SQL_USR;
  String SQL_PWD;
  SQL_DRV = application.getInitParameter("JDBC_DRV");
  SQL_URL = application.getInitParameter("JDBC_URL");
  SQL_USR = application.getInitParameter("JDBC_USR");
  SQL_PWD = application.getInitParameter("JDBC_PWD");

  String descr = (request.getParameter("description")==null ? "" : request.getParameter("description"));
  // fromWhere - in witch jsp page the save is done.
  String fromWhere=(request.getParameter("fromWhere")==null ? "" : request.getParameter("fromWhere"));

// Save operation was made with success or not
  boolean saveWithSuccess = false;

 // If it was selected the save button.
 if (request.getParameter("saveThisCriteria") != null
     && request.getParameter("saveThisCriteria").equals("true")
     && request.getParameter("Reset2")==null
     && !NatureObject.equalsIgnoreCase(""))
{
   // Save search criteria
   SaveAdvancedSearchCriteria sal = new SaveAdvancedSearchCriteria(IdSession,
                                                                  NatureObject,
                                                                  request.getParameter("username"),
                                                                  descr,
                                                                  fromWhere,
                                                                  SQL_DRV,
                                                                  SQL_URL,
                                                                  SQL_USR,
                                                                  SQL_PWD);
  saveWithSuccess = sal.SaveCriteria();
}
%>
  <body>
    <form name="eunis" method="post" action="save-species-or-habitats-advanced-search-criteria.jsp">
      <input type="hidden" name="saveThisCriteria" value = "true" class="inputTextField" />
<%
  if(request.getParameter("fromWhere") != null)
  {
%>
      <input type="hidden" name="fromWhere" value="<%=request.getParameter("fromWhere")%>" />
<%
  }
%>
      <input type="hidden" name="idsession" value="<%=IdSession%>" />
      <input type="hidden" name="natureobject" value="<%=NatureObject%>" />
<%
  if(request.getParameter("username") != null)
  {
%>
      <input type="hidden" name="username" value="<%=request.getParameter("username")%>" />
<%
  }
%>
      <table width="356" border="0" cellspacing="0" cellpadding="0">
<%
  if (null==request.getParameter("description"))
  {
%>
        <tr bgcolor="#EEEEEE">
          <td>
            <strong>
              <%=cm.cmsText("generic_save-search_01")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td>
            <%=cm.cmsText("generic_save-search_02")%>
          </td>
        </tr>
        <tr>
          <td>
            <label for="description" class="noshow"><%=cm.cms("save_species_or_habitats_advanced_search_criteria_description_label")%></label>
            <textarea id="description" name="description" cols="70" rows="5" style="width : 300px; height: 80px;" class="inputTextField"><%=descr%></textarea>
            <%=cm.cmsLabel("save_species_or_habitats_advanced_search_criteria_description_label")%>
          </td>
        </tr>
        <tr>
          <td>
            <img title="<%=cm.cms("bullet_title")%>" alt="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
            <%=cm.cmsAlt("bullet_alt")%>
            <%=cm.cmsTitle("bullet_title")%>
            &nbsp;
            <strong>
              <%=cm.cmsText("generic_save-search_03")%>
            </strong>
            <%=cm.cmsText("generic_save-search_04")%>
          </td>
        </tr>
<%
  }
  else
  {
    String saveOperationResult;
    if ( saveWithSuccess )
    {
      saveOperationResult = cm.cmsText( "save_species_or_habitats_advanced_search_criteria_success") + ".";
    }
    else
    {
      saveOperationResult = cm.cmsText( "save_species_or_habitats_advanced_search_criteria_failure" ) + ".";
    }
%>
        <tr>
          <td>
            <strong><%=saveOperationResult%></strong>
          </td>
        </tr>
        <%
          }
%>
        <tr>
          <td align="right">
<%
  if (null == request.getParameter("description"))
  {
%>
            <label for="submit" class="noshow"><%=cm.cms("save_btn_label")%></label>
            <input type="submit" id="submit" name="Submit" title="<%=cm.cms("save_btn_title")%>" value="<%=cm.cms("save_btn_value")%>" class="inputTextField" />
            <%=cm.cmsLabel("save_btn_label")%>
            <%=cm.cmsTitle("save_btn_title")%>
            <%=cm.cmsInput("save_btn_value")%>

            <label for="reset" class="noshow"><%=cm.cms("reset_btn_label")%></label>
            <input type="reset" id="reset" name="Reset" title="<%=cm.cms("reset_btn_title")%>" value="<%=cm.cms("reset_btn_value")%>" class="inputTextField" />
            <%=cm.cmsLabel("reset_btn_label")%>
            <%=cm.cmsTitle("reset_btn_title")%>
            <%=cm.cmsInput("reset_btn_value")%>
<%
  }
%>
            <label for="close" class="noshow"><%=cm.cms("reset_btn_label")%></label>
            <input type="button" id="close" name="Close" title="<%=cm.cms("close_window_title")%>" value="<%=cm.cms("close_window_value")%>" onclick="javascript:closeWindow('<%=request.getParameter("fromWhere")%>','yes')" class="inputTextField" />
            <%=cm.cmsLabel("reset_btn_label")%>
            <%=cm.cmsTitle("close_window_title")%>
            <%=cm.cmsInput("close_window_value")%>
          </td>
        </tr>
      </table>
    </form>
    <%=cm.cmsMsg("generic_save-search_title")%>
  </body>
</html>
