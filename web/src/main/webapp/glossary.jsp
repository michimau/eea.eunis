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
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,glossary";
%>
<script language="JavaScript" type="text/javascript">
//<![CDATA[
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
//]]>
</script>

<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=cm.cmsPhrase("Glossary")%>
</title>
<%
  // This parameter is optional. Possible values can be: species,habitats or sites.
  String module = request.getParameter("module");
%>
</head>
  <body>
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                      <h1>
                        <%=cm.cmsPhrase("Glossary")%>
                      </h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cmsPhrase("Print this page")%>"
                            title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cmsPhrase("Toggle full screen mode")%>"
                             title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
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
                      <%=cm.cmsPhrase("Search for specific terms used in this web site<br />(ex.: terms containing <strong>alpine</strong>)")%>
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
                     <%=cm.cmsPhrase("No data is available for glossary at this time.")%>
                <%
                } else {
                %>
                      <br />
                      <br />
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td bgcolor="#EEEEEE">
                            <strong>
                              <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%>
                            </strong>
                          </td>
                        </tr>
                        <tr bgcolor="#EEEEEE">
                          <td nowrap="nowrap">
                            <input type="checkbox" name="showTerm" id="showTerm" value="true" checked="checked" disabled="disabled" />
                            <label for="showTerm"><%=cm.cmsPhrase( "Term" )%></label>
                            &nbsp;
                            <input type="checkbox" name="showDefinition" id="showDefinition" value="true" checked="checked" disabled="disabled" />
                            <label for="showDefinition"><%=cm.cmsPhrase( "Definition" )%></label>
                            &nbsp;
                            <input type="checkbox" name="showReference" id="showReference" value="true" checked="checked" />
                            <label for="showReference"><%=cm.cmsPhrase( "Reference" )%></label>
                            &nbsp;
                            <input type="checkbox" name="showSource" id="showSource" value="true" checked="checked" />
                            <label for="showSource"><%=cm.cmsPhrase( "Source" )%></label>
                            &nbsp;
                            <input type="checkbox" name="showURL" id="showURL" value="true" checked="checked" />
                            <label for="showURL"><%=cm.cmsPhrase( "Url" )%></label>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <br />
                            <img width="11" height="12" style="vertical-align:middle" alt="Mandatory field" title="This field is mandatory" src="images/mini/field_mandatory.gif" />
                            <label for="searchString"><%=cm.cmsPhrase( "Term" )%></label>
                            <select title="Operator" name="operand" id="operand">
                              <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cmsPhrase("is")%></option>
                              <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cmsPhrase("starts with")%></option>
                            </select>
                            <label for="searchString" class="noshow"><%=cm.cms("glossary_search_value")%></label>
                            <input type="text" title="Search value" size="20" name="searchString" id="searchString" value="" />
                            <%=cm.cmsInput("glossary_search_value")%>
                            <div style="width : 100%; background-color : #EEEEEE">
                              <input name="searchTerms" id="searchTerms" type="checkbox" value="true" checked="checked" />
                              <label for="searchTerms"><%=cm.cmsPhrase( "Search terms" )%></label>
                              &nbsp;&nbsp;
                              <input name="searchDefinitions" id="searchDefinitions" type="checkbox" value="true" checked="checked" />
                              <label for="searchDefinitions"><%=cm.cmsPhrase( "Search definitions" )%></label>
                            </div>

                            <div style="width : 100%; text-align : right;">
                              <input title="<%=cm.cms("reset")%>" type="reset" value="<%=cm.cms("reset")%>" name="Reset" id="Reset" class="standardButton" />
                               <%=cm.cmsInput( "reset" )%>
                              <input title="<%=cm.cmsPhrase("Search")%>" type="submit" value="<%=cm.cmsPhrase("Search")%>" name="Submit" id="Submit" class="submitSearchButton" />
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
                <%=cm.cmsMsg("glossary_note")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("glossary_note_species")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("glossary_note_habitats")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("glossary_note_sites")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="glossary.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
