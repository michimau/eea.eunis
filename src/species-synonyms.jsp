<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species synonyms' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.synonyms.SynonymsSearchCriteria,
                 java.util.List,
                 java.util.Iterator,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesDomain,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_synonyms_02", false )%>
    </title>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/species-synonyms.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
  </head>
  <body style="background-color:#ffffff">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Synonyms" />
      <jsp:param name="helpLink" value="species-help.jsp" />
    </jsp:include>
    <h5>
         <%=contentManagement.getContent("species_synonyms_01")%>
    </h5>
    <table summary="layout" width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td>
          <form name="eunis" method="get" onsubmit="return validateForm();" action="species-synonyms-result.jsp">
            <input type="hidden" name="typeForm" value="<%=SynonymsSearchCriteria.CRITERIA_SCIENTIFIC_NAME_PRIM%>" />
          <table summary="layout" width="100%" border="0" style="text-align:left" cellpadding="0" cellspacing="0">
              <tr>
                <td>
                  <%=contentManagement.getContent("species_synonyms_20")%>
                  <br />
                  <br />
                  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="background-color:#EEEEEE">
                        <strong>
                          <%=contentManagement.getContent("species_synonyms_03")%>
                        </strong>
                      </td>
                    </tr>
                    <tr>
                      <td style="background-color:#EEEEEE">
                        <input title="Group" id="checkbox1" name="checkbox1" type="checkbox" value="show" checked="checked" disabled="disabled" /><label for="checkbox1"><%=contentManagement.getContent("species_synonyms_04")%></label>
                        <input title="Synonym" id="checkbox2" name="checkbox2" type="checkbox" value="show" checked="checked" disabled="disabled" /><label for="checkbox2"><%=contentManagement.getContent("species_synonyms_07")%></label>
                        <input title="Species" id="checkbox3" name="checkbox3" type="checkbox" value="show" checked="checked" disabled="disabled" /><label for="checkbox3">Species</label>
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
                  <img width="11" height="12" style="vertical-align:middle" alt="This field is optional" title="This field is optional" src="images/mini/field_included.gif" />
                  &nbsp;
                  <strong>
                    <%=contentManagement.getContent("species_synonyms_09")%>
                  </strong>
                  <label for="select1" class="noshow">Group name</label>
                  <select id="select1" title="Group name" name="groupName" class="inputTextField">
                    <option value="0" selected="selected">
                      <%=contentManagement.getContent("species_synonyms_10", false)%>
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
                  &nbsp;&nbsp;&nbsp;
                  <strong>
                    <%=contentManagement.getContent("species_synonyms_11")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td>
                  <img width="11" height="12" style="vertical-align:middle" alt="This field is mandatory" title="This field is mandatory" src="images/mini/field_mandatory.gif" />
                  &nbsp;
                  <strong>
                    <label for="scientificName"><%=contentManagement.getContent("species_synonyms_12")%></label>
                  </strong>
                  <label for="select2" class="noshow">Operator</label>
                  <select id="select2" title="Operator" name="relationOp" class="inputTextField">
                    <option value="<%=Utilities.OPERATOR_IS%>"><%=contentManagement.getContent("species_synonyms_13", false )%></option>
                    <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=contentManagement.getContent("species_synonyms_14", false )%></option>
                    <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected" ><%=contentManagement.getContent("species_synonyms_15", false )%></option>
                  </select>
                  <input id="scientificName" alt="Scientific name" size="32" name="scientificName" value="" class="inputTextField" title="Scientific name" />
                  <a title="List of values. Link will open a new window." href="javascript:openHelper('species-synonyms-choice.jsp')"><img alt="<%=contentManagement.getContent("species_synonyms_16", false)%>" height="18" style="vertical-align:middle" title="<%=contentManagement.getContent("species_synonyms_16", false)%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                  <%=contentManagement.writeEditTag("species_synonyms_16",false)%>
                  &nbsp;&nbsp;&nbsp;&nbsp;
                </td>
              </tr>
              <tr>
                <td style="text-align:right">
                  <label for="Reset" class="noshow"><%=contentManagement.getContent("species_synonyms_17", false)%></label>
                  <input id="Reset" type="reset" value="<%=contentManagement.getContent("species_synonyms_17", false)%>" name="Reset" class="inputTextField" title="Reset" />
                  <%=contentManagement.writeEditTag("species_synonyms_17")%>
                  <label for="Search" class="noshow"><%=contentManagement.getContent("species_synonyms_18", false)%></label>  
                  <input id="Search" type="submit" value="<%=contentManagement.getContent("species_synonyms_18", false)%>" name="submit2" class="inputTextField" title="Search" />
                  <%=contentManagement.writeEditTag("species_synonyms_18")%>
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
          <noscript>Your browser does not support JavaScript!</noscript>
          <br />
          <script language="JavaScript" type="text/javascript" src="script/species-synonyms-save-criteria.js"></script>
          <%=contentManagement.getContent("species_synonyms_19")%>:
          <a title="Save. Link will open a new window." href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-synonyms.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="Save" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
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
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-synonyms.jsp" />
    </jsp:include>
  </div>
  </body>
</html>
