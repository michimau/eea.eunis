<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species International threat status' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesDomain,
                 java.util.Vector,
                 ro.finsiel.eunis.search.species.internationalthreatstatus.InternationalStatusForGroupSpecies,
                 ro.finsiel.eunis.jrfTables.species.internationalthreatstatus.InternationalThreatStatusPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" src="script/species-country.js" type="text/javascript"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
        function onLoadFunction() {
            <%
              if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
              {
            %>
                 document.eunis.saveCriteria.style.display = 'none';
            <%
              }
            %>

        document.eunis.action = 'species-threat-international-result.jsp';
     }

     <%
              if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
              {
      %>
        function checkSaveCriteria() {
        <%
           if(request.getParameter("idCountry") != null)
           {
        %>
        var country = '<%=request.getParameter("idCountry")%>';
        <%
           } else
           {
        %>
        var country = null;
        <%
           }
           if(request.getParameter("countryName") != null)
           {
        %>
        var countryName = '<%=request.getParameter("countryName")%>';
        <%
           } else
           {
        %>
        var countryName = null;
        <%
           }
           if(request.getParameter("idGroup") != null)
           {
        %>
        var group = '<%=request.getParameter("idGroup")%>';
        <%
           } else
           {
        %>
        var group = null;
        <%
           }
           if(request.getParameter("groupName") != null)
           {
        %>
        var groupName = '<%=request.getParameter("groupName")%>';
        <%
           } else
           {
        %>
        var groupName = null;
        <%
           }
        %>
        if(country != null && countryName != null && group != null && groupName != null)
        {
              var c = document.createElement("input");
              c.type= "hidden";
              c.name = "idCountry";
              c.value = country;
              document.eunis.appendChild( c );

              var cn = document.createElement("input");
              cn.type= "hidden";
              cn.name = "countryName";
              cn.value = countryName;
              document.eunis.appendChild( cn );

              var g = document.createElement("input");
              g.type= "hidden";
              g.name = "idGroup";
              g.value = group;
              document.eunis.appendChild( g );

              var gn = document.createElement("input");
              gn.type= "hidden";
              gn.name = "groupName";
              gn.value = groupName;
              document.eunis.appendChild( gn );

              document.eunis.saveCriteria.checked=true;
              document.eunis.action = 'species-threat-international.jsp';
              alert('You choose to save this search criteria.Saving will be made after the search is executed');
              document.eunis.submit();
        } else
        {
              if(group != null && groupName != null)
              {
                 alert('Please select a country');
                  var g = document.createElement("input");
                  g.type= "hidden";
                  g.name = "idGroup";
                  g.value = group;
                  document.eunis.appendChild( g );

                  var gn = document.createElement("input");
                  gn.type= "hidden";
                  gn.name = "groupName";
                  gn.value = groupName;
                  document.eunis.appendChild( gn );
              }
              else alert('Please select a group');
              document.eunis.action = 'species-threat-international.jsp';
              document.eunis.submit();

        }
        }
            <%
            }
            %>

   //-->
    </script>
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_threat-international_title", false )%>
    </title>
</head>
<%
  // Request parameters
  String isSaveCriteriaChecked =((request.getParameter("saveCriteria") == null ?
                                  "" :
                                  request.getParameter("saveCriteria")).equalsIgnoreCase("true") ?
                                  "checked=\"checked\"" : "");

  String group = request.getParameter("idGroup");
  String groupName = request.getParameter("groupName");
  String country = request.getParameter("idCountry");
  String countryName = request.getParameter("countryName");
  final boolean anyGroupSelected = (null != groupName) ? groupName.equalsIgnoreCase("any") : false;

  boolean showGroup = false;
  boolean showGeo = false;
  boolean showStatus = false;
  boolean showVernacularNames = false;

  if(request.getParameter("firstTime") == null)
  {
      showGroup = true;
      showGeo = true;
      showStatus = true;
      showVernacularNames = true;
      
  } else
  {
      showGroup = Utilities.checkedStringToBoolean(request.getParameter("showGroup"), false);
      showGeo = Utilities.checkedStringToBoolean(request.getParameter("showGeo"), false);
      showStatus = Utilities.checkedStringToBoolean(request.getParameter("showStatus"), false);
      showVernacularNames = Utilities.checkedStringToBoolean(request.getParameter("showVernacularNames"), false);
  }
%>
  <body style="background-color:#ffffff" onload="onLoadFunction()">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,International threat status" />
      <jsp:param name="helpLink" value="species-help.jsp" />
    </jsp:include>
    <h5>
        <%=contentManagement.getContent("species_threat-international_01")%>
    </h5>
    <table summary="layout" width="100%" border="0">
      <tr>
        <td>
          <%=contentManagement.getContent("species_threat-international_20")%>
          <br />
          <br />
          <form name="eunis" method="post" action="species-threat-international-result.jsp">
          <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="background-color:#EEEEEE">
                <strong>
                  <%=contentManagement.getContent("species_threat-international_02")%>
                </strong>
              </td>
            </tr>
              <tr>
                <td style="background-color:#EEEEEE">
                  <input title="Group" id="checkbox2" type="checkbox" name="showGroup" value="true" <%=(showGroup ? "checked=\"checked\"" : "")%> /><label for="checkbox2"><%=contentManagement.getContent("species_threat-international_03")%></label>
                  <input title="Geographic region" id="checkbox5" type="checkbox" name="showGeo" value="true" <%=(showGeo ? "checked=\"checked\"" : "")%> /><label for="checkbox5"><%=contentManagement.getContent("species_threat-international_08")%></label>
                  <input title="Status" id="checkbox1" type="checkbox" name="showStatus" value="true" <%=(showStatus ? "checked=\"checked\"" : "")%> /><label for="checkbox1"><%=contentManagement.getContent("species_threat-international_status")%></label>
                  <input title="Scientific name" id="checkbox3" type="checkbox" name="true" value="true" disabled="disabled" checked="checked" /><label for="checkbox3"><%=contentManagement.getContent("species_threat-international_06")%></label>
                  <input title="Vernacular name" id="checkbox4" type="checkbox" name="showVernacularNames" value="true" <%=(showVernacularNames ? "checked=\"checked\"" : "")%> /><label for="checkbox4"><%=contentManagement.getContent("species_threat-international_07")%></label>
                </td>
              </tr>
              <tr>
                <td style="background-color:#FFFFFF">&nbsp;</td>
              </tr>
          </table>
          <br />
          <table summary="layout" cellspacing="1" cellpadding="0" border="0" width="100%" style="text-align:left">
            <tr>
              <td style="vertical-align:middle">
                <img width="11" height="12" style="vertical-align:middle" alt="<%=contentManagement.getContent("species_threat-international_11", false)%>" title="<%=contentManagement.getContent("species_threat-international_11", false)%>" src="images/mini/field_mandatory.gif" />
                <%=contentManagement.writeEditTag("species_threat-international_11",false)%>
                <%
                  if (null == group)
                  {
                    // If group is null then display the group selection texbox
                %>
                    <label for="Group" class="noshow">Group name</label>
                    <select title="Group name" name="Group" id="Group" onchange="MM_jumpMenuInternational('parent',this,0)"
                            class="inputTextField">
                      <option value="species-threat-international.jsp">
                        <%=contentManagement.getContent("species_threat-international_12", false)%>
                      </option>
                      <option value="species-threat-international.jsp?idGroup=-1&amp;groupName=any">
                        <%=contentManagement.getContent("species_threat-international_13", false)%>
                      </option>
                    <%
                      // List of groups species
                      List groups = new Chm62edtGroupspeciesDomain().findWhereDistinct("");
                      if (groups != null && groups.size() > 0)
                      {
                        for (int i = 0;i<groups.size();i++)
                        {
                          Chm62edtGroupspeciesPersist aGroup = (Chm62edtGroupspeciesPersist)groups.get(i);
                    %>
                          <option value="species-threat-international.jsp?idGroup=<%=aGroup.getIdGroupspecies()%>&amp;groupName=<%=(aGroup.getCommonName() != null ? aGroup.getCommonName().replaceAll("&","&amp;") : "")%>">
                            <%=(aGroup.getCommonName() != null ? aGroup.getCommonName().replaceAll("&","&amp;") : "")%>
                          </option>
                    <%
                        }
                      }
                    %>
                  </select>
                <%
                  } else
                  { // or else put out the selected group and let the user select the area.
                    InternationalStatusForGroupSpecies a = new InternationalStatusForGroupSpecies();
                    if (country == null)
                    {
                      /// aici1
                    if (anyGroupSelected) {
                %>
                    <strong> <% //any group%>
                      <%=contentManagement.getContent("species_threat-international_13")%>
                    </strong>

                    <br />
                    &nbsp;
                    <strong>   <% //and%>
                      <%=contentManagement.getContent("species_threat-international_14")%>
                    </strong>
                    &nbsp;  <% //area%>
                    <%=contentManagement.getContent("species_threat-international_19")%>
                  <%
                    } else {
                      String groupNameDispayed = (-1 == groupName.lastIndexOf("Mosses") ? groupName : "Mosses & Liverworts");
                  %>
                      <strong>
                        <%=groupNameDispayed%>
                      </strong>

                      <br />
                        &nbsp;
                      <strong>
                        <%=contentManagement.getContent("species_threat-international_14")%>
                      </strong>
                      &nbsp;
                      <%=contentManagement.getContent("species_threat-international_19")%>
                  <%
                    }
                  %>
                       &nbsp;
                       <label for="Country" class="noshow">Country</label>
                       <select title="Country" name="Contry" id="Country" onchange="MM_jumpMenuInternational('parent',this,0)"
                              class="inputTextField">
                        <option value="species-threat-international.jsp?idGroup=<%=group%>&amp;groupName=<%=groupName%>" selected="selected">
                          <%=contentManagement.getContent("species_threat-international_18", false)%>
                        </option>
                        <%
                        if (!anyGroupSelected)
                        {
                          a.setCountryForAGroup(group);
                          Vector CountriesForAGroup = a.getCountryForAGroup();

                          if (CountriesForAGroup != null && CountriesForAGroup.size() > 0)
                          {
                            for (int i = 0;i<CountriesForAGroup.size();i++)
                            {

                              String name = ((InternationalThreatStatusPersist)CountriesForAGroup.get(i)).getAreaNameEn();
                              name = name != null ? (name.length()>=70 ? name.substring(0,70) : name) : "";
                        %>
                              <option value="species-threat-international.jsp?groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;countryName=<%=((InternationalThreatStatusPersist)CountriesForAGroup.get(i)).getAreaNameEn()%>&amp;idCountry=<%=((InternationalThreatStatusPersist)CountriesForAGroup.get(i)).getIdCountry()%>">
                                <%=name%>
                              </option>
                      <%
                            }
                          }
                        } else
                        {
                          a.setCountryForAnyGroup();
                          Vector CountriesForAnyGroup = a.getCountryForAnyGroup();
                          if (CountriesForAnyGroup != null && CountriesForAnyGroup.size() > 0)
                          {
                            for (int i=0;i<CountriesForAnyGroup.size();i++)
                            {
                                String name = ((InternationalThreatStatusPersist)CountriesForAnyGroup.get(i)).getAreaNameEn();
                                name = name != null ? (name.length()>=70 ? name.substring(0,70) : name) : "";
                      %>
                              <option value="species-threat-international.jsp?groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;countryName=<%=((InternationalThreatStatusPersist)CountriesForAnyGroup.get(i)).getAreaNameEn()%>&amp;idCountry=<%=((InternationalThreatStatusPersist)CountriesForAnyGroup.get(i)).getIdCountry()%>">
                                <%=name%>
                              </option>
                     <%
                            }
                          }
                        }
                     %>
                      </select>
                <%
                       ////aici2
                    } else {
                 %>
                 <%
                    if (anyGroupSelected) {
                %>
                    <strong>
                      <%=contentManagement.getContent("species_threat-international_13")%>
                    </strong>

                    <br />
                    &nbsp;
                    <strong>
                      <%=contentManagement.getContent("species_threat-international_14")%>
                    </strong>
                    &nbsp;
                    <%=contentManagement.getContent("species_threat-international_19")%>
                  <%
                    } else {
                      String groupNameDispayed = (-1 == groupName.lastIndexOf("Mosses") ? groupName : "Mosses & Liverworts");
                  %>
                      <strong>
                        <%=groupNameDispayed%>
                      </strong>

                      <br />
                        &nbsp;
                      <strong>
                        <%=contentManagement.getContent("species_threat-international_14")%>
                      </strong>
                      &nbsp;
                      <%=contentManagement.getContent("species_threat-international_19")%>
                  <%
                    }
                  %>

                      &nbsp;
                      <strong>
                        <%=countryName%>
                      </strong>
                      &nbsp;

                     <br />

                     <strong>
                     <%=contentManagement.getContent("species_threat-international_14")%>
                     </strong>
                     &nbsp;  <% //threat status%>
                    <%=contentManagement.getContent("species_threat-international_15")%>
                    &nbsp;
                    <label for="Status" class="noshow">Status</label>
                    <select title="Status" name="Status" id="Status" onchange="MM_jumpMenuInternational('parent',this,0)"
                            class="inputTextField">
                      <option value="species-threat-international.jsp?idGroup=<%=group%>&amp;groupName=<%=groupName%>&amp;countryName=<%=countryName%>&amp;idCountry=<%=country%>" selected="selected">
                        <%=contentManagement.getContent("species_threat-international_16", false)%>
                      </option>
                      <option value="species-threat-international-result.jsp?idGroup=<%=group%>&amp;groupName=<%=groupName%>&amp;countryName=<%=countryName%>&amp;idCountry=<%=country%>&amp;idConservation=-1&amp;statusName=any">
                        <%=contentManagement.getContent("species_threat-international_17", false)%>
                      </option>
                    <%
                    if (!anyGroupSelected)
                    {
                      a.setStatusForAGroupACountry(group,country);
                      Vector statusForAGroup = a.getStatusForAGroupACountry();

                      if (statusForAGroup != null && statusForAGroup.size() > 0)
                      {
                        for (int i = 0;i<statusForAGroup.size();i++)
                        {
                    %>
                          <option value="species-threat-international-result.jsp?groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;countryName=<%=countryName%>&amp;idCountry=<%=country%>&amp;statusName=<%=((InternationalThreatStatusPersist)statusForAGroup.get(i)).getDefAbrev()%>&amp;idConservation=<%=((InternationalThreatStatusPersist)statusForAGroup.get(i)).getIdCons()%>">
                            <%=((InternationalThreatStatusPersist)statusForAGroup.get(i)).getDefAbrev()%>
                          </option>
                  <%
                        }
                      }
                    } else
                    {
                      a.setStatusForAnyGroupACountry(country);
                      Vector statusForAnyGroup = a.getStatusForAnyGroupACountry();

                      if (statusForAnyGroup != null && statusForAnyGroup.size()>0)
                      {
                        for (int i=0;i<statusForAnyGroup.size();i++)
                        {
                  %>
                          <option value="species-threat-international-result.jsp?groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;countryName=<%=countryName%>&amp;idCountry=<%=country%>&amp;statusName=<%=((InternationalThreatStatusPersist)statusForAnyGroup.get(i)).getDefAbrev()%>&amp;idConservation=<%=((InternationalThreatStatusPersist)statusForAnyGroup.get(i)).getIdCons()%>"><%=((InternationalThreatStatusPersist)statusForAnyGroup.get(i)).getDefAbrev()%></option>
                  <%
                        }
                      }
                    }
                  %>
                 </select>
                 <%
                  }
                  }
                %>
              </td>
            </tr>
           <%
                if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
                {
              %>
                  <tr>
                    <td>&nbsp; <br />
                      <input title="Save criteria" id="saveCriteria" type="checkbox" name="saveCriteria" value="true" <%=isSaveCriteriaChecked%> />
                        <label for="saveCriteria"><%=contentManagement.getContent("species_threat-international_10")%></label>
                        &nbsp;
                        <a title="Save criteria" href="javascript:checkSaveCriteria()"><img alt="Save" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                    </td>
                  </tr>
                  <tr><td>&nbsp;</td></tr>
              <%
                }
              %>
         </table>
       </form>
      </td>
    </tr>
  </table>
          <%
            // Expand saved searches list for this jsp page
            if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
            {
          %>
          <%
              // Set Vector for URL string
              Vector show = new Vector();
              show.addElement("showStatus");
              show.addElement("showGeo");
//              show.addElement("showGroup");
//              show.addElement("showFamily");
              show.addElement("showOrder");
              show.addElement("showScientificName");
              show.addElement("showVernacularNames");
              String pageName = "species-threat-international.jsp";
              String pageNameResult = "species-threat-international-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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
      <jsp:param name="page_name" value="species-threat-international.jsp" />
    </jsp:include>
  </div>
  </body>
</html>