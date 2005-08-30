<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : In this page are saved combined search criteria .
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page import="ro.finsiel.eunis.search.combined.SaveCombinedSearchCriteria,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=contentManagement.getContent("generic_save-search_title", false )%>
    </title>
     <%
       // Set IdSession variable
       String IdSession = request.getParameter("idsession");
       if( IdSession == null || IdSession.length()==0 || IdSession.equalsIgnoreCase("undefined") )
       {
         IdSession=request.getSession().getId();
       }

       // Set NatureObject variable
       String NatureObject = request.getParameter("natureobject");

       if( NatureObject == null || NatureObject.length()==0 || NatureObject.equalsIgnoreCase("undefined") )
       {
         System.out.println("No nature object found - Default to Species");
         NatureObject="";
       }
     %>
    <script language="JavaScript" type="text/javascript">
      <!--
        //Close this window and open another window with some parameters
        function closeWindow(where)
        {
          where = where + "?action=keep&natureobject=<%=NatureObject%>&expandCriterias=<%=request.getParameterValues("expandCriterias")%>";
          window.opener.location.href=where;
          self.close();
        }
      // -->
    </script>
  </head>
  <%
  // Set the database connection parameters
    String SQL_DRV = application.getInitParameter("JDBC_DRV");
    String SQL_URL = application.getInitParameter("JDBC_URL");
    String SQL_USR = application.getInitParameter("JDBC_USR");
    String SQL_PWD = application.getInitParameter("JDBC_PWD");

    String descr = (request.getParameter("description") == null ? "" : request.getParameter("description"));
    // fromWhere - in witch jsp page the save is done.
    String fromWhere=(request.getParameter("fromWhere") == null ? "" : request.getParameter("fromWhere"));

    // Save operation was made with success or not
    boolean saveWithSuccess = false;

    // If it was selected the save button.
    if (request.getParameter("saveThisCriteria") != null
       && request.getParameter("saveThisCriteria").equals("true")
       && request.getParameter("Reset2")==null
       && !NatureObject.equalsIgnoreCase(""))
    {
       // Set the SourceDB variable for NatureObject = 'Sites'
       String SourceDB = "";
      if (NatureObject.equalsIgnoreCase("Sites"))
      {
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
      }
       // Save search criteria
       SaveCombinedSearchCriteria sal = new SaveCombinedSearchCriteria(IdSession,
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
  <form name="eunis" method="post" action="combined-search-save-criteria.jsp">
   <input type="hidden" name="saveThisCriteria" value="true" class="inputTextField" />
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
   if(request.getParameter("expandCriterias") != null)
   {
%>
   <input type="hidden" name="expandCriterias" value="<%=request.getParameter("expandCriterias")%>" />
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
            <h6>
              <%=contentManagement.getContent("generic_save-search_01")%>
            </h6>
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
            <textarea title="Description" name="description" id="description" cols="70" rows="5" class="inputTextField"><%=descr%></textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" />
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
            String saveOperationResult = "";
            if ( saveWithSuccess )
            {
              saveOperationResult = contentManagement.getContent("generic_save-search_05");
            }
            else
            {
              saveOperationResult = contentManagement.getContent("generic_save-search_06");
            }
%>
            <tr>
              <td>
                <strong>
                  <%=saveOperationResult%>
                </strong>
              </td>
            </tr>
<%
          }
%>
        <tr>
          <td align="right">
            <br />
<%
              if (null == request.getParameter("description"))
              {
%>
              <label for="Submit" class="noshow">Save</label>
              <input title="Save" type="submit" name="Submit" id="Submit" value="<%=contentManagement.getContent("generic_save-search_07")%>" class="inputTextField" />
              <label for="Reset" class="noshow">Reset values</label>
              <input title="Reset values" type="reset" name="Reset" id="Reset" value="<%=contentManagement.getContent("generic_save-search_08")%>" class="inputTextField" />
<%
              }
%>
            <label for="Close" class="noshow">Close window</label>
            <input type="button" title="Close window" name="Close" id="Close" value="<%=contentManagement.getContent("generic_save-search_09")%>" onclick="javascript:closeWindow('<%=request.getParameter("fromWhere")%>')" class="inputTextField" />
          </td>
        </tr>
    </table>
  </form>
  </body>
</html>
