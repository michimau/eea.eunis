<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : In this page are saved sites advanced search criteria .
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.search.sites.advanced.SaveAdvancedSearchCriteria,
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

    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
     function closeWindow(where){
       window.opener.location.href=where;
       self.close();
      }
    //]]>
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
    NatureObject="";
  }

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
           SourceDB);
 saveWithSuccess = sal.SaveCriteria();
}
%>
  <body>
    <form name="eunis" method="post" action="save-sites-advanced-search-criteria.jsp">
      <input type="hidden" name="saveThisCriteria" value = "true" />
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
              <%=cm.cmsPhrase("ave search criteria:")%>
            </strong>
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
            <textarea id="description" name="description" cols="70" rows="5" style="width : 300px; height: 80px;"><%=descr%></textarea>
            <%=cm.cmsLabel("description")%>
          </td>
        </tr>
        <tr>
          <td>
            <img title="<%=cm.cms("bullet_alt")%>" alt="<%=cm.cms("bullet_alt")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
            <%=cm.cmsAlt("bullet_alt")%>
            <%=cm.cmsTitle("bullet_alt")%>
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
    String saveOperationResult;
    if ( saveWithSuccess )
    {
      saveOperationResult = cm.cms("search_criteria_saved") + ".";
    }
    else
    {
      saveOperationResult = cm.cms( "criteria_not_saved" ) + ".";
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
            <input type="submit" id="submit" name="Submit" title="<%=cm.cmsPhrase("Save")%>" value="<%=cm.cmsPhrase("Save")%>" class="submitSearchButton" />

            <input type="reset" id="reset" name="Reset" title="<%=cm.cmsPhrase("Reset values")%>" value="<%=cm.cmsPhrase("Reset")%>" class="standardButton" />
<%
    }
%>
            <input type="button" id="close_window" name="Close" title="<%=cm.cmsPhrase("Close window")%>" value="<%=cm.cmsPhrase("Close")%>" onclick="javascript:closeWindow('<%=request.getParameter("fromWhere")%>','yes')" class="standardButton" />
          </td>
        </tr>
      </table>
    </form>
    <%=cm.br()%>
    <%=cm.cmsMsg("search_criteria_saved")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("criteria_not_saved")%>
    <%=cm.br()%>
  </body>
</html>
