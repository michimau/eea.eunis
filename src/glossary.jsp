<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Glossary' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page import="ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
<script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<script language="JavaScript" type="text/javascript">
<!--
  function validateForm()
  {
  searchString = document.eunis.searchString.value;
  searchString = trim(searchString);
  if (searchString == "")
  {
   alert( '<%=contentManagement.getContent( "generic_glossary_02", false )%>' );
            return false;
  }
  else
  {
    if ( document.eunis.searchTerms.checked == false && document.eunis.searchDefinitions.checked == false )
    {
      alert('<%=contentManagement.getContent( "generic_glossary_03", false )%>');
      return false;
    }
  }
  return true;
}
//-->
</script>

<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=contentManagement.getContent( "generic_glossary_title", false )%>
</title>
<%
  // This parameter is optional. Possible values can be: species,habitats or sites.
  String module = request.getParameter("module");
%>
</head>
<body>
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="Home#index.jsp,Glossary"/>
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
      <h5>
        <%=contentManagement.getContent("generic_glossary_01")%>
      </h5>
      <%=contentManagement.getContent("generic_glossary_18")%>
      <br />
<%
      // Fix the paragraph header (If search in a particular module, show this to the user)
      if (null == module)
      {
        out.print("<strong>Note:</strong> Search is done in all terms used within all modules (species, habitat types, sites)");
      } else {
        if (module.equalsIgnoreCase("species")) {
          out.print("<strong>Note</strong>: Search is done in terms used within species module");
        }
        if (module.equalsIgnoreCase("habitat")) {
          out.print("<strong>Note</strong>: Search is done in terms used within habitat types module");
        }
        if (module.equalsIgnoreCase("sites")) {
          out.print("<strong>Note</strong>: Search is done in terms used within sites module");
        }
      }
%>
      <br />
      <br />
      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td bgcolor="#EEEEEE">
            <strong>
              <%=contentManagement.getContent( "generic_glossary_04" )%>
            </strong>
          </td>
        </tr>
        <tr bgcolor="#EEEEEE">
          <td nowrap="nowrap">
            <input type="checkbox" name="showTerm" id="showTerm" value="true" checked="checked" disabled="disabled" />
            <label for="showTerm"><%=contentManagement.getContent( "generic_glossary_05" )%></label>
            &nbsp;
            <input type="checkbox" name="showDefinition" id="showDefinition" value="true" checked="checked" disabled="disabled" />
            <label for="showDefinition"><%=contentManagement.getContent( "generic_glossary_06" )%></label>
            &nbsp;
            <input type="checkbox" name="showReference" id="showReference" value="true" checked="checked" />
            <label for="showReference"><%=contentManagement.getContent( "generic_glossary_07" )%></label>
            &nbsp;
            <input type="checkbox" name="showSource" id="showSource" value="true" checked="checked" />
            <label for="showSource"><%=contentManagement.getContent( "generic_glossary_08" )%></label>
            &nbsp;
            <input type="checkbox" name="showURL" id="showURL" value="true" checked="checked" />
            <label for="showURL"><%=contentManagement.getContent( "generic_glossary_09" )%></label>
          </td>
        </tr>
        <tr>
          <td>
            <br />
            <img width="11" height="12" align="middle" alt="Mandatory field" title="This field is mandatory" src="images/mini/field_mandatory.gif" />
            <strong>
              <%=contentManagement.getContent( "generic_glossary_10" )%>
            </strong>
            <label for="operand" class="noshow">Operator</label>
            <select title="Operator" name="operand" id="operand" class="inputTextField">
              <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent( "generic_glossary_11", false )%></option>
              <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent( "generic_glossary_12", false )%></option>
              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=contentManagement.getContent( "generic_glossary_13", false )%></option>
            </select>
            <label for="searchString" class="noshow">Search value</label>
            <input title="Search value" size="20" name="searchString" id="searchString" value="" class="inputTextField" />

            <div style="width : 740px; background-color : #EEEEEE">
              <input name="searchTerms" id="searchTerms" type="checkbox" value="true" checked="checked" />
              <label for="searchTerms"><%=contentManagement.getContent( "generic_glossary_14" )%></label>
              &nbsp;&nbsp;
              <input name="searchDefinitions" id="searchDefinitions" type="checkbox" value="true" checked="checked" />
              <label for="searchDefinitions"><%=contentManagement.getContent( "generic_glossary_15" )%></label>
            </div>

            <div style="width : 740px; text-align : right;">
              <label for="Reset" class="noshow">Reset values</label>
              <input title="Reset values" type="reset" value="<%=contentManagement.getContent( "generic_glossary_16", false )%>" name="Reset" id="Reset" class="inputTextField" />
               <%=contentManagement.writeEditTag( "generic_glossary_16" )%>
              <label for="Submit" class="noshow">Search</label>
              <input title="Search" type="submit" value="<%=contentManagement.getContent( "generic_glossary_17", false )%>" name="Submit" id="Submit" class="inputTextField" />
              <%=contentManagement.writeEditTag( "generic_glossary_17" )%>
            </div>
          </td>
        </tr>
      </table>
      </form>
    </td>
   </tr>
</table>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="glossary.jsp" />
</jsp:include>
    </div>
  </body>
</html>