<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : In this page are saved easy search criteria .
--%>
<%@page contentType="text/html"%>
<%@page import="java.util.List, java.util.Iterator, java.util.Vector,
                java.util.Enumeration,
                ro.finsiel.eunis.search.*,
                ro.finsiel.eunis.search.save_criteria.GroupsFromRequest,
                ro.finsiel.eunis.search.save_criteria.SaveSearchCriteria,
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
    <script language="JavaScript" src="script/header.js" type="text/javascript"></script>  
    <script language="JavaScript" type="text/javascript">
      <!--
        function closeWindow(where,exp)
        {
          window.opener.location.href=where+'?expandSearchCriteria='+exp;
          self.close();
        }
      // -->
    </script>
  </head>
<%
  // Set the database connection parameters
  String SQL_DRV="";
  String SQL_URL="";
  String SQL_USR="";
  String SQL_PWD="";

  SQL_DRV = application.getInitParameter("JDBC_DRV");
  SQL_URL = application.getInitParameter("JDBC_URL");
  SQL_USR = application.getInitParameter("JDBC_USR");
  SQL_PWD = application.getInitParameter("JDBC_PWD");

  // Number of the form elements used in this save search criteria
  int number = (request.getParameter("numberCriteria") == null ? 0 : Utilities.checkedStringToInt(request.getParameter("numberCriteria"),0));

  // Save operation was made with success or not
  boolean saveWithSuccess = false;

  // If it was selected the save button.
  if (request.getParameter("saveCriteria") != null
        && request.getParameter("saveCriteria").equals("true")
        && request.getParameter("Reset2")==null)
  {
    // Get parameters from request
    GroupsFromRequest requestParser = new GroupsFromRequest(request);

    String description = (request.getParameter("description") == null ? "" : request.getParameter("description"));
    // pageName - in witch jsp page the save is done.
    String pageName = (request.getParameter("pageName") == null ? "" : request.getParameter("pageName"));

    // values of this constants from specific class Domain
    Vector database = new Vector();
    database.add((request.getParameter("database1") == null ? "" : request.getParameter("database1"))); //eunis
    database.add((request.getParameter("database2") == null ? "" : request.getParameter("database2"))); //annex
    database.add((request.getParameter("database3") == null ? "" : request.getParameter("database3"))); //both


    // Save search criteria
    SaveSearchCriteria sal = new SaveSearchCriteria(database,
                                                  number,
                                                  SessionManager.getUsername(),
                                                  description,
                                                  pageName,
                                                  requestParser.getAttributes(),
                                                  requestParser.getFormFieldAttributes(),
                                                  requestParser.getFormFieldOperators(),
                                                  requestParser.getBooleans(),
                                                  requestParser.getOperators(),
                                                  requestParser.getFirstValues(),
                                                  requestParser.getLastValues(),
                                                  SQL_DRV,
                                                  SQL_URL,
                                                  SQL_USR,
                                                  SQL_PWD);
    saveWithSuccess = sal.SaveCriterias();
}

String descr = (request.getParameter("description") == null ? "" : request.getParameter("description"));
%>
  <body>
      <form name="eunis" method="post" action="save-criteria-search.jsp">
        <input type="hidden" name="saveCriteria" value="true" class="inputTextField" />
        <input type="hidden" name="numberCriteria" value="<%=request.getParameter("numberCriteria")%>" />
        <input type="hidden" name="pageName" value="<%=request.getParameter("pageName")%>" />
        <input type="hidden" name="expandSearchCriteria" value="<%=request.getParameter("expandSearchCriteria")%>" />
        <input type="hidden" name="database1" value="<%=request.getParameter("database1")%>" />
        <input type="hidden" name="database2" value="<%=request.getParameter("database2")%>" />
        <input type="hidden" name="database3" value="<%=request.getParameter("database3")%>" />
        <%
          for (int i=0;i<number;i++)
          {
        %>
          <input type="hidden" name="_<%=i%>attributesNames" value="<%=request.getParameter("_"+i+"attributesNames")%>" />
          <input type="hidden" name="_<%=i%>formFieldAttributes" value="<%=request.getParameter("_"+i+"formFieldAttributes")%>" />
          <input type="hidden" name="_<%=i%>formFieldOperators" value="<%=request.getParameter("_"+i+"formFieldOperators")%>" />
          <input type="hidden" name="_<%=i%>booleans" value="<%=request.getParameter("_"+i+"booleans")%>" />
          <input type="hidden" name="_<%=i%>operators" value="<%=request.getParameter("_"+i+"operators")%>" />
          <input type="hidden" name="_<%=i%>firstValues" value="<%=Utilities.treatURLSpecialCharacters(request.getParameter("_"+i+"firstValues"))%>" />
          <input type="hidden" name="_<%=i%>lastValues" value="<%=Utilities.treatURLSpecialCharacters(request.getParameter("_"+i+"lastValues"))%>" />
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
              <textarea id="description" name="description" cols="70" rows="5" style="width : 300px; height: 80px;" class="inputTextField"><%=descr%></textarea>
            </td>
          </tr>
          <tr>
            <td>
              <img title="Bullet" alt="Bullet" src="images/mini/bulletb.gif" width="6" height="6" align="middle" />
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
              <strong><%=saveOperationResult%></strong>
            </td>
          </tr>
<%
  }
%>
          <tr>
            <td align="right">
              <br />
<%
  if (null==request.getParameter("description"))
  {
%>
              <label for="submit" class="noshow">Save</label>
              <input type="submit" id="submit" name="Submit" title="Save" value="<%=contentManagement.getContent("generic_save-search_07",false)%>" class="inputTextField" />
              <label for="reset" class="noshow">Reset values</label>
              <input type="reset" id="reset" name="Reset" title="Reset values" value="<%=contentManagement.getContent("generic_save-search_08",false)%>" class="inputTextField" />
<%
  }
%>
            <label for="close" class="noshow">Close window</label>
            <input type="button" id="close" name="Close" value="<%=contentManagement.getContent("generic_save-search_09", false )%>" onclick="javascript:closeWindow('<%=request.getParameter("pageName")%>','<%=request.getParameter("expandSearchCriteria")%>')" class="inputTextField" />
            <%=contentManagement.writeEditTag( "generic_save-search_09",false )%>
          </td>
        </tr>
      </table>
    </form>
  </body>
</html>