<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2004 European Environment Agency
  - Description : 'Species groups' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.Iterator,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesPersist,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,groups";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("species_groups_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" helpLink="species-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
<stripes:layout-component name="head">
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
    <script language="JavaScript" src="<%=request.getContextPath()%>/script/species-groups-save-criteria.js" type="text/javascript"></script>
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
      function validateForm() {
        var invalidSelectMsg = "<%=cm.cms("species_groups_18")%>";
        var len = document.eunis.groupID.length;
        var isOK = false;
        if (len == null) {
          // len == null it means that this is not an array but a single item (radio button)
          if (document.eunis.groupID.checked == true)
          {
            return true;
          }
        } else {
          // Else means that are more fields, so this must be an array of radio buttons
          for (i = 0; i < len; i++)
          {
            var item = document.eunis.groupID[i];
            if (item.checked == true)
            {
              isOK = true;
            }
          }
          if (isOK == true) return true;
          alert(invalidSelectMsg);
          return false;
        }
      }
      function setGroupName( group, id )
      {
        document.eunis.groupName.value=group;
      }
    //]]>
    </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>
                <h1>
                    <%=cm.cmsPhrase("Groups")%>
                </h1>

<!-- MAIN CONTENT -->
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Species and subspecies by main groups<br />(ex.: search species and subspecies belonging to <strong>invertebrates</strong> group)")%>
                      <br />
                      <br />
                    <form name="eunis" onsubmit="return validateForm()" method="get" action="species-groups-result.jsp">
                      <input type="hidden" name="showScientificName" value="true" />
                      <input type="hidden" name="expand" value="false" />
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
                            <input title="<%=cm.cmsPhrase("Group")%>" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" />
                              <label for ="checkbox1"><%=cm.cmsPhrase("Group")%></label>
                            <input title="<%=cm.cms("order_column")%>" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" />
                              <%=cm.cmsTitle("order_column")%>
                              <label for ="checkbox2"><%=cm.cmsPhrase("Order")%></label>
                            <input title="<%=cm.cms("family")%>" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" />
                              <%=cm.cmsTitle("family")%>
                              <label for ="checkbox3"><%=cm.cmsPhrase("Family")%></label>
                            <input title="<%=cm.cmsPhrase("Scientific name")%>" id="checkbox4" type="checkbox" name="showScientificName" value="true" checked="checked" disabled="disabled" />
                              <label for ="checkbox4"><%=cm.cmsPhrase("Scientific name")%></label>
                              <input title="<%=cm.cms("vernacular_name")%>" id="checkbox5" type="checkbox" name="showVernacularNames" value="true" />
                              <%=cm.cmsTitle("vernacular_name")%>
                              <label for ="checkbox5"><%=cm.cmsPhrase("Vernacular Name")%></label>
                          </td>
                        </tr>
                      </table>
                      <table summary="<%=cm.cms("species_groups_19_Sum")%>" class="datatable" >
                        <tr>
                          <th colspan="2">
                            <%=cm.cmsPhrase("Group")%>
                          </th>
                          <th style="text-align:right">
                            <%=cm.cmsPhrase("Number of scientific species names")%>
                          </th>
                          <th style="text-align:right">
                            <%=cm.cmsPhrase("Actual number of taxa")%>
                          </th>
                          <th style="text-align:center">
                            <%=cm.cmsPhrase("Select")%>
                          </th>
                        </tr>
                        <jsp:useBean id="GroupSpeciesDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesDomain" scope="page" />
                        <jsp:useBean id="SpeciesDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtSpeciesDomain" scope="page" />
                        <%
                          // List of species groups
                          Iterator it = SpeciesSearchUtility.findAllGroups().iterator();
                          int ii=0;
                          while (it.hasNext())
                          {

                            Chm62edtGroupspeciesPersist group = (Chm62edtGroupspeciesPersist)it.next();
                            String cssClass = ii++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                        %>
                            <tr<%=cssClass%>>
                              <td>
                                  <img alt="<%=cm.cms("species_groups_20_Alt")%>" height="32" src="images/group/<%=group.getIdGroupspecies()%>.gif" width="32" />
                                  <%=cm.cmsAlt("species_groups_20_Alt")%>
                              </td>
                              <td>
                                <label for="radio_<%=ii%>">
                                  <%=(group.getCommonName() != null ? group.getCommonName().replaceAll("&","&amp;") : "&nbsp;")%>
                                </label>
                              </td>
                              <td style="text-align:right">
                                <%=SpeciesDomain.countByGroupID(group.getIdGroupspecies())%>*
                              </td>
                              <td style="text-align:right;">
                                  <%=SpeciesSearchUtility.countUniqueSpecies(group.getIdGroupspecies(), SessionManager.getShowEUNISInvalidatedSpecies())%>*
                              </td>
                              <td style="text-align:center">
                                <input id="radio_<%=ii%>" type="radio" value="<%=group.getIdGroupspecies()%>" name="groupID" onclick="javascript:setGroupName('<%=(group.getCommonName() != null ? group.getCommonName().replaceAll("&","&amp;") : "")%>','<%=group.getIdGroupspecies()%>')"
                                  title="<%=cm.cms("select")%> <%=(group.getCommonName() != null ? group.getCommonName().replaceAll("&","&amp;") : " ")%> <%=cm.cmsPhrase("Group")%>" />
                                  <%=cm.cmsTitle("select")%>
                              </td>
                            </tr>
                      <%
                          }
                      %>
                        <tr>
                          <th colspan="2">
                            <%=cm.cmsPhrase("Group")%>
                          </th>
                          <th style="text-align:right;">
                            <%=cm.cmsPhrase("Number of scientific species names")%>
                          </th>
                          <th style="text-align:right;">
                            <%=cm.cmsPhrase("Actual number of taxa")%>
                          </th>
                          <th style="text-align:center">
                            <%=cm.cmsPhrase("Select")%>
                          </th>
                        </tr>
                        <tr>
                          <td colspan="5" style="text-align:center">
                            <input type="hidden" name="groupName" />
                            <%=cm.cmsPhrase("<strong>WARNING:</strong>Getting results for a group with many species can take a longer time.")%>
                            <br />
                          </td>
                        </tr>
                        <tr>
                          <td colspan="5" style="text-align:center">
                            <strong>
                            <%=cm.cmsPhrase("* - The number of actual species retrieved by the Search might be different, depending on your user rights")%>
                            </strong>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="5" style="text-align:right">
                            <br />
                            <input id="Reset" type="reset" value="<%=cm.cmsPhrase("Reset")%>" name="Reset" class="standardButton" title="<%=cm.cmsPhrase("Reset")%>" />
                            <input id="Search" type="submit" value="<%=cm.cmsPhrase("Search")%>" name="submit" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" />
                          </td>
                        </tr>
                      </table>
                    </form>
                  </td>
                </tr>
                </table>
                      <%
                        // Save search criteria
                        if (SessionManager.isAuthenticated()&& SessionManager.isSave_search_criteria_RIGHT())
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
                      <%=cm.cmsPhrase("Save your criteria")%>:
                      <a title="<%=cm.cms("save_open_link")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-groups.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_open_link")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                      <%=cm.cmsTitle("save_open_link")%>
                      <%
                          // Set Vector for URL string
                          Vector show = new Vector();
                          show.addElement("showGroup");
                          show.addElement("showFamily");
                          show.addElement("showOrder");
                          show.addElement("showScientificName");
                          show.addElement("showVernacularNames");

                          String pageName = "species-groups.jsp";
                          String pageNameResult = "species-groups-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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
            <%=cm.cmsMsg("species_groups_18")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("species_groups_title")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("species_groups_19_Sum")%>
            <%=cm.br()%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>