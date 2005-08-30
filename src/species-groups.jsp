<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2004 European Environment Agency
  - Description : 'Species groups' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="java.util.Iterator,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesPersist,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" src="script/species-groups-save-criteria.js" type="text/javascript"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
      function validateForm() {
        var invalidSelectMsg = "Please select a group.";
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
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_groups_title", false )%>
    </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Groups" />
      <jsp:param name="helpLink" value="species-help.jsp" />
    </jsp:include>
    <h5>
        <%=contentManagement.getContent("species_groups_01")%>
    </h5>
    <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <%=contentManagement.getContent("species_groups_16")%>
          <br />
          <br />
        <form name="eunis" onsubmit="return validateForm()" method="get" action="species-groups-result.jsp">
          <input type="hidden" name="showScientificName" value="true" />
          <input type="hidden" name="expand" value="false" />
          <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="background-color:#EEEEEE">
                <strong>
                  <%=contentManagement.getContent("species_groups_02")%>
                </strong>
              </td>
            </tr>
            <tr>
              <td style="background-color:#EEEEEE">
                <input title="Group" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" /><label for ="checkbox1"><%=contentManagement.getContent("species_groups_17")%></label>
                <input title="Order" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" /><label for ="checkbox2"><%=contentManagement.getContent("species_groups_03")%></label>
                <input title="Family" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" /><label for ="checkbox3"><%=contentManagement.getContent("species_groups_04")%></label>
                <input title="Scientific name" id="checkbox4" type="checkbox" name="showScientificName" value="true" checked="checked" disabled="disabled" /><label for ="checkbox4"><%=contentManagement.getContent("species_groups_05")%></label>
                <input title="Vernacular name" id="checkbox5" type="checkbox" name="showVernacularNames" value="true" /><label for ="checkbox5"><%=contentManagement.getContent("species_groups_06")%></label>
              </td>
            </tr>
          </table>
          <table summary="List of groups" cellspacing="0" cellpadding="0" width="100%" border="0">
            <%// Header row for group selection table %>
            <tr style="background-color:<%=SessionManager.getThemeManager().getMediumColor()%>">
              <th colspan="2" style="text-align:left">
                  <strong>
                      <span style="color:#FFFFFF">
                          <%=contentManagement.getContent("species_groups_08")%>
                      </span>
                  </strong>
              </th>
              <th width="167" style="text-align:center">
                  <strong>
                      <span style="color:#FFFFFF">
                          <%=contentManagement.getContent("species_groups_09")%>
                      </span>
                   </strong>
              </th>
              <th width="205" style="text-align:center">
                  <strong>
                      <span style="color:#FFFFFF">
                          <%=contentManagement.getContent("species_groups_10")%>
                      </span>
                  </strong>
              </th>
              <th width="93" style="text-align:center">
                  <strong>
                      <span style="color:#FFFFFF">
                          <%=contentManagement.getContent("species_groups_11")%>
                      </span>
                  </strong>
              </th>
            </tr>
            <jsp:useBean id="GroupSpeciesDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesDomain" scope="page" />
            <jsp:useBean id="SpeciesDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtSpeciesDomain" scope="page" />
            <tr>
              <td>
                &nbsp;
              </td>
            </tr>
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
                      <img alt="Group image" height="32" src="images/group/<%=group.getIdGroupspecies()%>.gif" width="32" />
                  </td>
                  <td>
                      <label for="radio_<%=ii%>">
                          <strong><%=(group.getCommonName() != null ? group.getCommonName().replaceAll("&","&amp;") : "&nbsp;")%></strong>
                      </label>
                  </td>
                  <td style="text-align:center">
                      <%=SpeciesDomain.countByGroupID(group.getIdGroupspecies())%>
                  </td>
                  <td style="text-align:center">
                      <%=SpeciesSearchUtility.countUniqueSpecies(group.getIdGroupspecies(), SessionManager.getShowEUNISInvalidatedSpecies())%>
                  </td>
                  <td style="text-align:center">
                    <input id="radio_<%=ii%>" type="radio" value="<%=group.getIdGroupspecies()%>" name="groupID" onclick="javascript:setGroupName('<%=(group.getCommonName() != null ? group.getCommonName().replaceAll("&","&amp;") : "")%>','<%=group.getIdGroupspecies()%>')"
                      title="Select <%=(group.getCommonName() != null ? group.getCommonName().replaceAll("&","&amp;") : " ")%> group" class="inputTextField" />
                  </td>
                </tr>
          <%
              }
          %>
            <tr style="background-color:<%=SessionManager.getThemeManager().getMediumColor()%>">
              <th colspan="2" style="text-align:left">
                  <strong>
                      <span style="color:#FFFFFF">
                          <%=contentManagement.getContent("species_groups_08")%>
                      </span>
                  </strong>
              </th>
              <th width="167" style="text-align:center">
                  <strong>
                      <span style="color:#FFFFFF">
                          <%=contentManagement.getContent("species_groups_09")%>
                      </span>
                   </strong>
              </th>
              <th width="205" style="text-align:center">
                  <strong>
                      <span style="color:#FFFFFF">
                          <%=contentManagement.getContent("species_groups_10")%>
                      </span>
                  </strong>
              </th>
              <th width="93" style="text-align:center">
                  <strong>
                      <span style="color:#FFFFFF">
                          <%=contentManagement.getContent("species_groups_11")%>
                      </span>
                  </strong>
              </th>
            </tr>
            <tr>
              <td colspan="5" style="text-align:center">
                <input type="hidden" name="groupName" />
                <%=contentManagement.getContent("species_groups_12")%>
                <br />
              </td>
            </tr>
            <tr>
              <td colspan="5" style="text-align:right">
                <br />
              </td>
            </tr>
            <tr>
              <td colspan="5" style="text-align:right">
                <label for="Reset" class="noshow">Reset</label>
                <input id="Reset" type="reset" value="<%=contentManagement.getContent("species_groups_13",false)%>" name="Reset" class="inputTextField" title="Reset" />
                <%=contentManagement.writeEditTag("species_groups_13")%>
                <label for="Search" class="noshow">Search</label>  
                <input id="Search" type="submit" value="<%=contentManagement.getContent("species_groups_14",false)%>" name="submit" class="inputTextField" title="Search" />
                <%=contentManagement.writeEditTag("species_groups_14")%>
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
          <noscript>Your browser does not support JavaScript!</noscript>
          <br />
          <%=contentManagement.getContent("species_groups_15")%>:
          <a title="Save. Link will open a new window." href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-groups.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="Save" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
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
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-groups.jsp" />
    </jsp:include>
  </div>
  </body>
</html>