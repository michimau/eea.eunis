<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species synonyms' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
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
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,synonyms";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("species_synonyms_02") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" helpLink="species-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-synonyms.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
          <h1>
            <%=cm.cmsPhrase("Synonyms")%>
          </h1>

<!-- MAIN CONTENT -->
                  <table summary="layout" width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                      <td>
                        <form name="eunis" method="get" onsubmit="return validateForm();" action="species-synonyms-result.jsp">
                          <input type="hidden" name="typeForm" value="<%=SynonymsSearchCriteria.CRITERIA_SCIENTIFIC_NAME_PRIM%>" />
                          <table summary="layout" width="100%" border="0" style="text-align:left" cellpadding="0" cellspacing="0">
                            <tr>
                              <td>
                                <%=cm.cmsPhrase("Search EUNIS Database for species synonyms<br />(ex.: search <strong>mammals</strong> group for <strong>vulpes vulpes</strong>)")%>
                                <br />
                                <br />
                                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                                  <tr>
                                    <td>
                                      <strong>
                                        <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%>
                                      </strong>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td>
                                      <input title="<%=cm.cmsPhrase("Group")%>" id="checkbox1" name="checkbox1" type="checkbox" value="show" checked="checked" disabled="disabled" />
                                        <label for="checkbox1"><%=cm.cmsPhrase("Group")%></label>
                                      <input title="<%=cm.cms("synonym")%>" id="checkbox2" name="checkbox2" type="checkbox" value="show" checked="checked" disabled="disabled" />
                                        <label for="checkbox2"><%=cm.cmsPhrase("Synonym name")%></label>
                                        <%=cm.cmsTitle("synonym")%>
                                      <input title="<%=cm.cms("species")%>" id="checkbox3" name="checkbox3" type="checkbox" value="show" checked="checked" disabled="disabled" />
                                        <label for="checkbox3"><%=cm.cmsPhrase("Species")%></label>
                                        <%=cm.cmsTitle("species")%>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr>
                              <td>
                                <br />
                                <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_included.gif" />
                                <%=cm.cmsAlt("field_optional")%>
                                &nbsp;
                                <strong>
                                  <%=cm.cmsPhrase("Group name")%>
                                </strong>
                                <label for="select1" class="noshow"><%=cm.cms("group_name")%></label>
                                <select id="select1" title="<%=cm.cms("group_name")%>" name="groupName">
                                  <option value="0" selected="selected">
                                    <%=cm.cms("any_group")%>
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
                                  <%=cm.cmsPhrase("and")%>
                                </strong>
                              </td>
                            </tr>
                            <tr>
                              <td>
                                <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" />
                                &nbsp;
                                <label for="scientificName"><%=cm.cmsPhrase("Species scientific name")%></label>
                                <select id="select2" title="<%=cm.cmsPhrase("Operator")%>" name="relationOp">
                                  <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cmsPhrase("is")%></option>
                                  <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cmsPhrase("contains")%></option>
                                  <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected" ><%=cm.cmsPhrase("starts with")%></option>
                                </select>
                                <input id="scientificName" alt="<%=cm.cmsPhrase("Scientific name")%>" size="32" name="scientificName" value="" title="<%=cm.cmsPhrase("Scientific name")%>" />
                                <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-synonyms-choice.jsp')"><img alt="<%=cm.cms("species_synonyms_16")%>" height="18" style="vertical-align:middle" title="<%=cm.cms("species_synonyms_16")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                                <%=cm.cmsTitle("list_values_link")%>
                                <%=cm.cmsAlt("species_synonyms_16")%>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                              </td>
                            </tr>
                            <tr>
                              <td style="text-align:right">
                                <input id="Reset" type="reset" value="<%=cm.cmsPhrase("Reset")%>" name="Reset" class="standardButton" title="<%=cm.cmsPhrase("Reset")%>" />
                                <input id="Search" type="submit" value="<%=cm.cmsPhrase("Search")%>" name="submit2" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" />
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
                         //<![CDATA[
                         // values of source and database constants from specific class Domain(only in habitat searches, so here are all '')
                         var source1='';
                         var source2='';
                         var database1='';
                         var database2='';
                         var database3='';
                        //]]>
                        </script>
                        <br />
                        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-synonyms-save-criteria.js"></script>
                        <%=cm.cmsPhrase("Save your criteria")%>:
                        <a title="<%=cm.cms("save_open_link")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-synonyms.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_open_link")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                        <%=cm.cmsTitle("save_open_link")%>
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
              <%=cm.cmsMsg("any_group")%>
              <%=cm.br()%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>