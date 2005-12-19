<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species synonyms' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.synonyms.SynonymsSearchCriteria,
                 java.util.List,
                 java.util.Iterator,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesDomain,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_synonyms_02")%>
    </title>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-synonyms.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
  </head>
  <body style="background-color:#ffffff">
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,synonyms_location" />
      <jsp:param name="helpLink" value="species-help.jsp" />
    </jsp:include>
    <h1>
         <%=cm.cmsText("species_synonyms_01")%>
    </h1>
    <table summary="layout" width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td>
          <form name="eunis" method="get" onsubmit="return validateForm();" action="species-synonyms-result.jsp">
            <input type="hidden" name="typeForm" value="<%=SynonymsSearchCriteria.CRITERIA_SCIENTIFIC_NAME_PRIM%>" />
          <table summary="layout" width="100%" border="0" style="text-align:left" cellpadding="0" cellspacing="0">
              <tr>
                <td>
                  <%=cm.cmsText("species_synonyms_20")%>
                  <br />
                  <br />
                  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="background-color:#EEEEEE">
                        <strong>
                          <%=cm.cmsText("species_synonyms_03")%>
                        </strong>
                      </td>
                    </tr>
                    <tr>
                      <td style="background-color:#EEEEEE">
                        <input title="<%=cm.cms("group")%>" id="checkbox1" name="checkbox1" type="checkbox" value="show" checked="checked" disabled="disabled" />
                          <label for="checkbox1"><%=cm.cmsText("species_synonyms_04")%></label>
                          <%=cm.cmsTitle("group")%>
                        <input title="<%=cm.cms("synonym")%>" id="checkbox2" name="checkbox2" type="checkbox" value="show" checked="checked" disabled="disabled" />
                          <label for="checkbox2"><%=cm.cmsText("species_synonyms_07")%></label>
                          <%=cm.cmsTitle("synonym")%>
                        <input title="<%=cm.cms("species")%>" id="checkbox3" name="checkbox3" type="checkbox" value="show" checked="checked" disabled="disabled" />
                          <label for="checkbox3"><%=cm.cmsText("species")%></label>
                          <%=cm.cmsTitle("species")%>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        &nbsp;
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td>
                  <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_included.gif" />
                  <%=cm.cmsAlt("field_optional")%>
                  &nbsp;
                  <strong>
                    <%=cm.cmsText("species_synonyms_09")%>
                  </strong>
                  <label for="select1" class="noshow"><%=cm.cms("group_name")%></label>
                  <select id="select1" title="<%=cm.cms("group_name")%>" name="groupName" class="inputTextField">
                    <option value="0" selected="selected">
                      <%=cm.cms("species_synonyms_10")%>
                    </option>
                <%
                  // List of group species
                  List speciesNames = new Chm62edtGroupspeciesDomain().findOrderBy("COMMON_NAME");
                  Iterator it = speciesNames.iterator();
                  while (it.hasNext())
                  {
                      Chm62edtGroupspeciesPersist specieName = (Chm62edtGroupspeciesPersist)it.next();
                %>
                    <option value="<%=specieName.getIdGroupspecies()%>"><%=(specieName.getCommonName() != null ? specieName.getCommonName().replaceAll("&","&amp;") : "")%></option>
                <%
                  }
                speciesNames.clear();
                %>
                  </select>
                  <%=cm.cmsLabel("group_name")%>
                  <%=cm.cmsTitle("group_name")%>
                  &nbsp;&nbsp;&nbsp;
                  <strong>
                    <%=cm.cmsText("species_synonyms_11")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td>
                  <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" />
                  <%=cm.cmsTitle("field_mandatory")%>
                  &nbsp;
                  <strong>
                    <label for="scientificName"><%=cm.cmsText("species_synonyms_12")%></label>
                  </strong>
                  <label for="select2" class="noshow"><%=cm.cms("operator")%></label>
                  <select id="select2" title="<%=cm.cms("operator")%>" name="relationOp" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("species_synonyms_13")%></option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("species_synonyms_14")%></option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected" ><%=cm.cms("species_synonyms_15")%></option>
                  </select>
                  <%=cm.cmsLabel("operator")%>
                  <%=cm.cmsTitle("operator")%>
                  <input id="scientificName" alt="<%=cm.cms("scientific_name")%>" size="32" name="scientificName" value="" class="inputTextField" title="<%=cm.cms("scientific_name")%>" />
                  <%=cm.cmsAlt("scientific_name")%>
                  <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-synonyms-choice.jsp')"><img alt="<%=cm.cms("species_synonyms_16")%>" height="18" style="vertical-align:middle" title="<%=cm.cms("species_synonyms_16")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                  <%=cm.cmsTitle("list_values_link")%>
                  <%=cm.cmsAlt("species_synonyms_16")%>
                  &nbsp;&nbsp;&nbsp;&nbsp;
                </td>
              </tr>
              <tr>
                <td style="text-align:right">
                  <label for="Reset" class="noshow"><%=cm.cms("reset")%></label>
                  <input id="Reset" type="reset" value="<%=cm.cms("reset_btn")%>" name="Reset" class="inputTextField" title="<%=cm.cms("reset")%>" />
                  <%=cm.cmsLabel("reset")%>
                  <%=cm.cmsTitle("reset")%>
                  <%=cm.cmsInput("reset_btn")%>
                  <label for="Search" class="noshow"><%=cm.cms("search")%></label>
                  <input id="Search" type="submit" value="<%=cm.cms("search_btn")%>" name="submit2" class="inputTextField" title="<%=cm.cms("search")%>" />
                  <%=cm.cmsLabel("search")%>
                  <%=cm.cmsTitle("search")%>
                  <%=cm.cmsInput("search_btn")%>
                </td>
              </tr>
          </table>
           </form>
        </td>
      </tr>
  </table>
          <%
            // Save search criteria
            if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
            {
          %>
           <script type="text/javascript" language="JavaScript">
           <!--
           // values of source and database constants from specific class Domain(only in habitat searches, so here are all '')
           var source1='';
           var source2='';
           var database1='';
           var database2='';
           var database3='';
          //-->
          </script>
          <br />
          <script language="JavaScript" type="text/javascript" src="script/species-synonyms-save-criteria.js"></script>
          <%=cm.cmsText("species_synonyms_19")%>:
          <a title="<%=cm.cms("save_title")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-synonyms.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_title")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
          <%=cm.cmsTitle("save_title")%>
          <%
              // Set Vector for URL string
              Vector show = new Vector();
              String pageName = "species-synonyms.jsp";
              String pageNameResult = "species-synonyms-result.jsp?"+Utilities.writeURLCriteriaSave(show);
              // Expand or not save criterias list
              String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
          %>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
        <%
            }
        %>

<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms_02")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms_10")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms_13")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms_14")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms_15")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-synonyms.jsp" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>
