<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2004 European Environment Agency
  - Description : 'Species groups' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.Iterator,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesPersist,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" src="script/species-groups-save-criteria.js" type="text/javascript"></script>
    <%
        WebContentManagement cm = SessionManager.getWebContent();
    %>
    <script language="JavaScript" type="text/javascript">
    <!--
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
    //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_groups_title")%>
    </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,species_location#species.jsp,groups_location" />
      <jsp:param name="helpLink" value="species-help.jsp" />
    </jsp:include>
    <h1>
        <%=cm.cmsText("species_groups_01")%>
    </h1>
    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <%=cm.cmsText("species_groups_16")%>
          <br />
          <br />
        <form name="eunis" onsubmit="return validateForm()" method="get" action="species-groups-result.jsp">
          <input type="hidden" name="showScientificName" value="true" />
          <input type="hidden" name="expand" value="false" />
          <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="background-color:#EEEEEE">
                <strong>
                  <%=cm.cmsText("species_groups_02")%>
                </strong>
              </td>
            </tr>
            <tr>
              <td style="background-color:#EEEEEE">
                <input title="<%=cm.cms("group")%>" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" />
                  <%=cm.cmsTitle("group")%>
                  <label for ="checkbox1"><%=cm.cmsText("group")%></label>
                <input title="<%=cm.cms("order")%>" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" />
                  <%=cm.cmsTitle("order")%>
                  <label for ="checkbox2"><%=cm.cmsText("order")%></label>
                <input title="<%=cm.cms("family")%>" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" />
                  <%=cm.cmsTitle("family")%>
                  <label for ="checkbox3"><%=cm.cmsText("family")%></label>
                <input title="<%=cm.cms("scientific_name")%>" id="checkbox4" type="checkbox" name="showScientificName" value="true" checked="checked" disabled="disabled" />
                  <%=cm.cmsTitle("scientific_name")%>
                  <label for ="checkbox4"><%=cm.cmsText("scientific_name")%></label>
                  <input title="<%=cm.cms("vernacular_name")%>" id="checkbox5" type="checkbox" name="showVernacularNames" value="true" />
                  <%=cm.cmsTitle("vernacular_name")%>
                  <label for ="checkbox5"><%=cm.cmsText("vernacular_name")%></label>
              </td>
            </tr>
          </table>
          <table summary="<%=cm.cms("species_groups_19_Sum")%>" cellspacing="0" cellpadding="0" width="100%" border="0">
            <%// Header row for group selection table %>
            <tr>
              <th class="resultHeader" colspan="2" style="text-align:left">
                <%=cm.cmsText("species_groups_08")%>
              </th>
              <th class="resultHeader" width="167" style="text-align:center">
                <%=cm.cmsText("species_groups_09")%>
              </th>
              <th class="resultHeader" width="205" style="text-align:center">
                <%=cm.cmsText("species_groups_10")%>
              </th>
              <th class="resultHeader" width="93" style="text-align:center">
                <%=cm.cmsText("species_groups_11")%>
              </th>
            </tr>
            <jsp:useBean id="GroupSpeciesDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesDomain" scope="page" />
            <jsp:useBean id="SpeciesDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtSpeciesDomain" scope="page" />
            <%
              // List of species groups
              Iterator it = SpeciesSearchUtility.findAllGroups().iterator();
              boolean alternate = true;
              int ii=0;
              while (it.hasNext())
              {
                ii++;
                Chm62edtGroupspeciesPersist group = (Chm62edtGroupspeciesPersist)it.next();
                alternate = !alternate;
            %>
                <tr style="background-color:<%=alternate ? "#EEEEEE" : "#FFFFFF"%>;vertical-align:middle">
                  <td style="text-align:left">
                      <img alt="<%=cm.cms("species_groups_20_Alt")%>" height="32" src="images/group/<%=group.getIdGroupspecies()%>.gif" width="32" />
                      <%=cm.cmsAlt("species_groups_20_Alt")%>
                  </td>
                  <td>
                      <label for="radio_<%=ii%>">
                          <strong><%=(group.getCommonName() != null ? group.getCommonName().replaceAll("&","&amp;") : "&nbsp;")%></strong>
                      </label>
                  </td>
                  <td style="text-align:center">
                      <%=SpeciesDomain.countByGroupID(group.getIdGroupspecies())%>*
                  </td>
                  <td style="text-align:center">
                      <%=SpeciesSearchUtility.countUniqueSpecies(group.getIdGroupspecies(), SessionManager.getShowEUNISInvalidatedSpecies())%>*
                  </td>
                  <td style="text-align:center">
                    <input id="radio_<%=ii%>" type="radio" value="<%=group.getIdGroupspecies()%>" name="groupID" onclick="javascript:setGroupName('<%=(group.getCommonName() != null ? group.getCommonName().replaceAll("&","&amp;") : "")%>','<%=group.getIdGroupspecies()%>')"
                      title="<%=cm.cms("select")%> <%=(group.getCommonName() != null ? group.getCommonName().replaceAll("&","&amp;") : " ")%> <%=cm.cms("group")%>" class="inputTextField" />
                      <%=cm.cmsTitle("select")%>
                      <%=cm.cmsTitle("group")%>
                  </td>
                </tr>
          <%
              }
          %>
            <tr>
              <th class="resultHeader" colspan="2" style="text-align:left">
                <%=cm.cmsText("species_groups_08")%>
              </th>
              <th class="resultHeader" width="167" style="text-align:center">
                <%=cm.cmsText("species_groups_09")%>
              </th>
              <th class="resultHeader" width="205" style="text-align:center">
                <%=cm.cmsText("species_groups_10")%>
              </th>
              <th class="resultHeader" width="93" style="text-align:center">
                <%=cm.cmsText("species_groups_11")%>
              </th>
            </tr>
            <tr>
              <td colspan="5" style="text-align:center">
                <input type="hidden" name="groupName" />
                <%=cm.cmsText("species_groups_12")%>
                <br />
              </td>
            </tr>
            <tr>
              <td colspan="5" style="text-align:right">
                <br />
              </td>
            </tr>
            <tr>
              <td colspan="5" style="text-align:center">
                <strong>
                <%=cm.cmsText("species_groups_Note")%>
                </strong>
              </td>
            </tr>
            <tr>
              <td colspan="5" style="text-align:right">
                <br />
                <label for="Reset" class="noshow"><%=cm.cms("reset")%></label>
                <input id="Reset" type="reset" value="<%=cm.cms("reset_btn")%>" name="Reset" class="inputTextField" title="<%=cm.cms("reset")%>" />
                <%=cm.cmsLabel("reset")%>
                <%=cm.cmsTitle("reset")%>
                <%=cm.cmsInput("reset_btn")%>
                <label for="Search" class="noshow"><%=cm.cms("search")%></label>
                <input id="Search" type="submit" value="<%=cm.cms("search_btn")%>" name="submit" class="inputTextField" title="<%=cm.cms("search")%>" />
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
            if (SessionManager.isAuthenticated()&& SessionManager.isSave_search_criteria_RIGHT())
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
          <%=cm.cmsText("species_groups_15")%>:
          <a title="<%=cm.cms("save_title")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-groups.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_title")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
          <%=cm.cmsTitle("save_title")%>
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

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-groups.jsp" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>