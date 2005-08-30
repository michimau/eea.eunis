<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : In this page are saved sites advanced search criteria .
--%>
<%@page contentType="text/html"%>
<%@page import="java.util.List, java.util.Iterator, java.util.Vector,
                  java.util.Enumeration,
                  ro.finsiel.eunis.search.*,
                  ro.finsiel.eunis.search.sites.advanced.SaveAdvancedSearchCriteria,
                  ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=contentManagement.getContent("generic_save-search_title", false )%>
    </title>

    <script language="JavaScript" type="text/javascript">
    <!--
     function closeWindow(where){
       window.opener.location.href=where;
       self.close();
      }
    // -->
    </script>
  </head>
<%
  // Set IdSession variable
  String IdSession = request.getParameter("idsession");

  if(IdSession == null || IdSession.length()==0 || IdSession.equalsIgnoreCase("undefined")) {
    IdSession=request.getSession().getId();
  }

  // Set NatureObject variable
  String NatureObject = request.getParameter("natureobject");

  if(NatureObject == null || NatureObject.length()==0 || NatureObject.equalsIgnoreCase("undefined")) {
    System.out.println("No nature object found - Default to Species");
    NatureObject="";
  }

  // Set the database connection parameters
  String SQL_DRV="";
  String SQL_URL="";
  String SQL_USR="";
  String SQL_PWD="";
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
   //Set SourceDB variable
   String SourceDB = "";
  if(request.getParameter("DIPLOMA") != null) SourceDB+=",'DIPLOMA'";
  if(request.getParameter("CDDA_NATIONAL") != null) SourceDB+=",'CDDA_NATIONAL'";
  if(request.getParameter("CDDA_INTERNATIONAL") != null) SourceDB+=",'CDDA_INTERNATIONAL'";
  if(request.getParameter("BIOGENETIC") != null) SourceDB+=",'BIOGENETIC'";
  if(request.getParameter("NATURA2000") != null) SourceDB+=",'NATURA2000'";
  if(request.getParameter("NATURENET") != null) SourceDB+=",'NATURENET'";
  if(request.getParameter("EMERALD") != null) SourceDB+=",'EMERALD'";
  if(request.getParameter("CORINE") != null) SourceDB+=",'CORINE'";

  if(SourceDB.equalsIgnoreCase(""))
  {
    SourceDB = "''";
  } else
  {
    if(SourceDB.length()>1)
    {
      // First comma is eliminated
      SourceDB = SourceDB.substring(1,SourceDB.length());
    }
  }

   // Save search criteria
   SaveAdvancedSearchCriteria sal = new SaveAdvancedSearchCriteria( IdSession,
                                                                  NatureObject,
                                                                  request.getParameter("username"),
                                                                  descr,
                                                                  fromWhere,
                                                                  SQL_DRV,
                                                                  SQL_URL,
                                                                  SQL_USR,
                                                                  SQL_PWD,
                                                                  SourceDB);
 saveWithSuccess = sal.SaveCriteria();
}
%>
  <body>
    <form name="eunis" method="post" action="save-sites-advanced-search-criteria.jsp">
      <input type="hidden" name="saveThisCriteria' value = 'true" class="inputTextField" />
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
  if(request.getParameter("DIPLOMA") != null)
  {
%>
      <input type="hidden" name="DIPLOMA" value="<%=request.getParameter("DIPLOMA")%>" />
<%
  }
  if(request.getParameter("CDDA_NATIONAL") != null)
  {
%>
      <input type="hidden" name="CDDA_NATIONAL" value="<%=request.getParameter("CDDA_NATIONAL")%>" />
<%
  }
  if(request.getParameter("CDDA_INTERNATIONAL") != null)
  {
%>
      <input type="hidden" name="CDDA_INTERNATIONAL" value="<%=request.getParameter("CDDA_INTERNATIONAL")%>" />
<%
  }
  if(request.getParameter("BIOGENETIC") != null)
  {
%>
      <input type="hidden" name="BIOGENETIC" value="<%=request.getParameter("BIOGENETIC")%>" />
<%
  }
  if(request.getParameter("NATURA2000") != null)
  {
%>
      <input type="hidden" name="NATURA2000" value="<%=request.getParameter("NATURA2000")%>" />
<%
  }
  if(request.getParameter("NATURENET") != null)
  {
%>
      <input type="hidden" name="NATURENET" value="<%=request.getParameter("NATURENET")%>" />
<%
  }
  if(request.getParameter("EMERALD") != null)
  {
%>
      <input type="hidden" name="EMERALD" value="<%=request.getParameter("EMERALD")%>" />
<%
  }
  if(request.getParameter("CORINE") != null)
  {
%>
      <input type="hidden" name="CORINE" value="<%=request.getParameter("CORINE")%>" />
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
              <%=contentManagement.getContent("generic_save-search_01")%>
            </strong>
          </td>
        </tr>
        <tr>
          <td>
            <%=contentManagement.getContent("generic_save-search_02")%>
          </td>
        </tr>
        <tr>
          <td>
            <label for="description" class="noshow">Description</label>
            <textarea id="description" name="description" cols="70" rows="5" style="width : 100px; height: 80px;" class="inputTextField"><%=descr%></textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img alt="Bullet" title="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
            &nbsp;
            <strong>
            <%=contentManagement.getContent("generic_save-search_03")%>
            </strong>
            <%=contentManagement.getContent("generic_save-search_04")%>
          </td>
        </tr>
<%
  }
  else
  {
    String saveOperationResult = (saveWithSuccess?"Your search criterion was saved in database.":"Your search criterion wasn't saved in database.<br />Please try again!");
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
                <label for="submit" class="noshow">Save</label>
                <input type="submit" id="submit" name="Submit" title="Save" value="<%=contentManagement.getContent("generic_save-search_07")%>" class="inputTextField" />
                <label for="reset" class="noshow">Reset values</label>
                <input type="reset" id="reset" name="Reset" title="Reset values" value="<%=contentManagement.getContent("generic_save-search_08")%>" class="inputTextField" />
            <%
              }
            %>
            <label for="close" class="noshow">Close window</label>
            <input type="button" id="close" name="Close" value="<%=contentManagement.getContent("generic_save-search_09", false )%>" onclick="javascript:closeWindow('<%=request.getParameter("fromWhere")%>')" class="inputTextField" />
            <%=contentManagement.writeEditTag( "generic_save-search_09" )%>
          </td>
        </tr>
      </table>
    </form>
  </body>
</html>
