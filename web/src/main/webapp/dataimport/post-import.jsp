<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : News page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,ro.finsiel.eunis.utilities.SQLUtilities,java.util.*"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String domainName = application.getInitParameter( "DOMAIN_NAME" );
%>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,data import#dataimport/index.jsp,data importer";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("Post Import Scripts") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>
                <h1>
                  Post Import Scripts
                </h1>
<!-- MAIN CONTENT -->
                <%
                if( SessionManager.isAuthenticated() && SessionManager.isImportExportData_RIGHT() ){
                %>
                    <p class="documentDescription">
                    The purpose of this page is to run database scripts after import!
                    </p>
                    <form name="eunis" method="post" action="<%=domainName%>/postimport">
                <fieldset><legend>Scripts</legend>
                        <table border="0">
                            <tr>
                                <td><input type="checkbox" id="sites" name="sites"/></td>
                                <td><label for="sites">
                                    Replace NULL values in decimal degrees (table: chm62edt_sites)
                                </label></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" id="speciesTab" name="spiecesTab"/></td>
                                <td><label for="speciesTab">Generate species tab information<br/>
                                    <em>May take a long time to complete. It is recommended to also check "Run scripts in background" option</em>
                                </label></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" id="habitatsTab" name="habitatsTab"/></td>
                                <td><label for="habitatsTab">Generate habitats tab information</label></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" id="sitesTab" name="sitesTab"/></td>
                                <td><label for="sitesTab">Generate sites tab information<br/>
                                    <em>May take a long time to complete. It is recommended to also check "Run scripts in background" option</em>
                                </label></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" id="linkeddataTab" name="linkeddataTab"/></td>
                                <td><label for="linkeddataTab">Generate linked data tab information</label></td>
                            </tr>
                             <tr>
                                <td><input type="checkbox" id="conservationstatusTab" name="conservationstatusTab"/></td>
                                <td><label for="conservationstatusTab">Generate conservation status tab information</label></td>
                            </tr>
                        </table>
                </fieldset>
                <fieldset><legend>Fore-/background</legend>
                        <table border="0">
                            <tr>
                                <td><input type="checkbox" id="runBackground" name="runBackground"/></td>
                                <td><label for="runBackground">Run scripts in background</label></td>
                            </tr>
                            <tr>
                                <td align="right" colspan="2"><input type="submit" name="btn" value="Run"/></td>
                            </tr>
                        </table>
                </fieldset>
                    </form>
                    <%
                    List<String> errors = (List<String>)request.getSession().getAttribute("errors");
                    if(errors != null && errors.size() > 0){
                        if(errors.size() > 1){%>
                            <h2><%=errors.size()%> errors found:</h2>
                        <% } %>
                        <ul>
                        <%
                         for(int i = 0 ; i<errors.size() ; i++) {
                             String error = errors.get(i);
                             %>
                             <li><%=error%></li>
                             <%
                        }
                        %>
                        </ul>
                        <%
                        request.getSession().removeAttribute("errors");
                    } else {
                         String success = (String)request.getSession().getAttribute("success");
                         if(success != null){
                             %>
                                 <b><%=success%></b>
                             <%
                            request.getSession().removeAttribute("success");
                         }
                    }
                } else {
                    %>
                        <div class="error-msg">
                        <%=cm.cmsPhrase("You must be authenticated and have the proper right to access this page.")%>
                     </div>
                    <%
                }
                %>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>