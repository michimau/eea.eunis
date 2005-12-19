<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Glossary' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
<script language="JavaScript" type="text/javascript">
<!--
  function validateForm()
  {
  searchString = document.eunis.searchString.value;
  searchString = trim(searchString);
  if (searchString == "")
  {
   alert( '<%=cm.cms("generic_glossary_02")%>' );
            return false;
  }
  else
  {
    if ( document.eunis.searchTerms.checked == false && document.eunis.searchDefinitions.checked == false )
    {
      alert('<%=cm.cms("generic_glossary_03")%>');
      return false;
    }
  }
  return true;
}
//-->
</script>

<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=cm.cms("generic_glossary_title")%>
</title>
<%
  // This parameter is optional. Possible values can be: species,habitats or sites.
  String module = request.getParameter("module");
%>
</head>
<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home_location#index.jsp,glossary_location"/>
</jsp:include>
<table summary="layout" width="100%" border="0">
  <tr>
    <td>
      <form name="eunis" method="get" onsubmit="return validateForm();" action="glossary-result.jsp">
<%
      // If search in particular nature object, put the hidden field with that nature object
      if (null != module)
      {
%>
      <input type="hidden" name="module" value="<%=module%>" />
<%
  }
%>
      <h1>
        <%=cm.cmsText("generic_glossary_01")%>
      </h1>
      <%=cm.cmsText("generic_glossary_18")%>
      <br />
<%
      // Fix the paragraph header (If search in a particular module, show this to the user)
      if (null == module)
      {
        out.print(cm.cms("glossary_note"));
      } else {
        if (module.equalsIgnoreCase("species")) {
          out.print(cm.cms("glossary_note_species"));
        }
        if (module.equalsIgnoreCase("habitat")) {
          out.print(cm.cms("glossary_note_habitats"));
        }
        if (module.equalsIgnoreCase("sites")) {
          out.print(cm.cms("glossary_note_sites"));
        }
      }

      String SQL_DRV = application.getInitParameter("JDBC_DRV");
      String SQL_URL = application.getInitParameter("JDBC_URL");
      String SQL_USR = application.getInitParameter("JDBC_USR");
      String SQL_PWD = application.getInitParameter("JDBC_PWD");

      SQLUtilities sqlc = new SQLUtilities();
      sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

      String SQL = "";
      if (module == null || module.trim().length() <= 0)
        SQL = "SELECT COUNT(*) FROM CHM62EDT_GLOSSARY WHERE TERM_DOMAIN in ('species','sites','habitat')";
      else
        SQL = "SELECT COUNT(*) FROM CHM62EDT_GLOSSARY WHERE TERM_DOMAIN = '" + module + "'";
      String noTerms = sqlc.ExecuteSQL(SQL);
      int no = Utilities.checkedStringToInt(noTerms,0);

      if (no <= 0) {
%>
     <br /> <br />
     <%=cm.cmsText("glossary_no_data_available")%>
<%
} else {
%>
      <br />
      <br />
      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td bgcolor="#EEEEEE">
            <strong>
              <%=cm.cmsText("generic_glossary_04")%>
            </strong>
          </td>
        </tr>
        <tr bgcolor="#EEEEEE">
          <td nowrap="nowrap">
            <input type="checkbox" name="showTerm" id="showTerm" value="true" checked="checked" disabled="disabled" />
            <label for="showTerm"><%=cm.cmsText( "generic_glossary_05" )%></label>
            &nbsp;
            <input type="checkbox" name="showDefinition" id="showDefinition" value="true" checked="checked" disabled="disabled" />
            <label for="showDefinition"><%=cm.cmsText( "generic_glossary_06" )%></label>
            &nbsp;
            <input type="checkbox" name="showReference" id="showReference" value="true" checked="checked" />
            <label for="showReference"><%=cm.cmsText( "generic_glossary_07" )%></label>
            &nbsp;
            <input type="checkbox" name="showSource" id="showSource" value="true" checked="checked" />
            <label for="showSource"><%=cm.cmsText( "generic_glossary_08" )%></label>
            &nbsp;
            <input type="checkbox" name="showURL" id="showURL" value="true" checked="checked" />
            <label for="showURL"><%=cm.cmsText( "generic_glossary_09" )%></label>
          </td>
        </tr>
        <tr>
          <td>
            <br />
            <img width="11" height="12" align="middle" alt="Mandatory field" title="This field is mandatory" src="images/mini/field_mandatory.gif" />
            <strong>
              <%=cm.cmsText( "generic_glossary_10" )%>
            </strong>
            <label for="operand" class="noshow"><%=cm.cms("glossary_operator")%></label>
            <select title="Operator" name="operand" id="operand" class="inputTextField">
              <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("generic_glossary_11")%></option>
              <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("generic_glossary_12")%></option>
              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("generic_glossary_13")%></option>
            </select>
            <%=cm.cmsLabel("glossary_operator")%>
            <label for="searchString" class="noshow"><%=cm.cms("glossary_search_value")%></label>
            <input title="Search value" size="20" name="searchString" id="searchString" value="" class="inputTextField" />
            <%=cm.cmsInput("glossary_search_value")%>
            <div style="width : 100%; background-color : #EEEEEE">
              <input name="searchTerms" id="searchTerms" type="checkbox" value="true" checked="checked" />
              <label for="searchTerms"><%=cm.cmsText( "generic_glossary_14" )%></label>
              &nbsp;&nbsp;
              <input name="searchDefinitions" id="searchDefinitions" type="checkbox" value="true" checked="checked" />
              <label for="searchDefinitions"><%=cm.cmsText( "generic_glossary_15" )%></label>
            </div>

            <div style="width : 100%; text-align : right;">
              <label for="Reset" class="noshow"><%=cm.cms("reset_btn")%></label>
              <input title="<%=cm.cms("reset_btn")%>" type="reset" value="<%=cm.cms("generic_glossary_16")%>" name="Reset" id="Reset" class="inputTextField" />
               <%=cm.cmsInput( "generic_glossary_16" )%>
              <%=cm.cmsLabel("reset_btn")%>
              <label for="Submit" class="noshow"><%=cm.cms("search_btn")%></label>
              <input title="<%=cm.cms("search_btn")%>" type="submit" value="<%=cm.cms("generic_glossary_17")%>" name="Submit" id="Submit" class="inputTextField" />
              <%=cm.cmsInput( "generic_glossary_17" )%>
              <%=cm.cmsLabel("search_btn")%>
            </div>
          </td>
        </tr>
      </table>
<%
    }
%>
      </form>
    </td>
   </tr>
</table>
<%=cm.cmsMsg("generic_glossary_02")%>
<%=cm.br()%>
<%=cm.cmsMsg("generic_glossary_03")%>
<%=cm.br()%>
<%=cm.cmsMsg("generic_glossary_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("glossary_note")%>
<%=cm.br()%>
<%=cm.cmsMsg("glossary_note_species")%>
<%=cm.br()%>
<%=cm.cmsMsg("glossary_note_habitats")%>
<%=cm.br()%>
<%=cm.cmsMsg("glossary_note_sites")%>
<%=cm.br()%>
<%=cm.cmsMsg("generic_glossary_11")%>
<%=cm.br()%>
<%=cm.cmsMsg("generic_glossary_12")%>
<%=cm.br()%>
<%=cm.cmsMsg("generic_glossary_13")%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="glossary.jsp" />
</jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>