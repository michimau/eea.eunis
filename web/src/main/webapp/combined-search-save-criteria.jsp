<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : In this page are saved combined search criteria .
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.search.combined.SaveCombinedSearchCriteria,
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
      <%=cm.cmsPhrase("Save search criteria")%>
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
         System.out.println("No nature object found in save criteria!");
         NatureObject="";
       }
     %>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        //Close this window and open another window with some parameters
        function closeWindow(where)
        {
          where = where + "?action=keep&natureobject=<%=NatureObject%>&expandCriterias=<%=request.getParameterValues("expandCriterias")%>";
          window.opener.location.href=where;
          self.close();
        }
      //]]>
    </script>
  </head>
  <%

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
               SourceDB);
     saveWithSuccess = sal.SaveCriteria();
  }
  %>
  <body>
  <form name="eunis" method="post" action="combined-search-save-criteria.jsp">
   <input type="hidden" name="saveThisCriteria" value="true" />
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
            <h2>
              <%=cm.cmsPhrase("Save search criteria:")%>
            </h2>
          </td>
        </tr>
        <tr>
          <td>
            <%=cm.cmsPhrase("Please enter few words to describe this criteria for later reference")%>
          </td>
        </tr>
        <tr>
          <td>
            <label for="description" class="noshow"><%=cm.cms("description")%></label>
            <textarea title="<%=cm.cms("description")%>" name="description" id="description" cols="40" rows="5"><%=descr%></textarea>
            <%=cm.cmsLabel("description")%>
          </td>
        </tr>
        <tr>
          <td>
            <img alt="" src="images/mini/bulletb.gif" width="6" height="6" />
            &nbsp;
            <strong>
            <%=cm.cmsPhrase("Remark:")%>
            </strong>
            <%=cm.cmsPhrase("By leaving this field empty, a default description (based on your selections) will be associated with this criteria.")%>
          </td>
        </tr>
<%
          }
          else
          {
            String saveOperationResult = "";
            if ( saveWithSuccess )
            {
              saveOperationResult = cm.cmsPhrase("Your search criteria was saved in database.");
            }
            else
            {
              saveOperationResult = cm.cmsPhrase("Your search criterion wasn't saved in database. Please try again!");
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
              <input title="<%=cm.cmsPhrase("Save")%>" type="submit" name="Submit" id="Submit" value="<%=cm.cmsPhrase("Save")%>" class="submitSearchButton" />
              <input title="<%=cm.cmsPhrase("Reset")%>" type="reset" name="Reset" id="Reset" value="<%=cm.cmsPhrase("Reset")%>" class="standardButton" />
<%
              }
%>
            <input type="button" title="<%=cm.cmsPhrase("Close window")%>" name="Close" id="Close" value="<%=cm.cmsPhrase("Close")%>" onclick="javascript:closeWindow('<%=request.getParameter("fromWhere")%>')" class="standardButton" />
          </td>
        </tr>
    </table>
  </form>
  </body>
</html>
