<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species National threat status' function - search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesDomain,
                 java.util.Vector,
                 ro.finsiel.eunis.search.species.national.NationalThreatStatusForGroupSpecies,
                 ro.finsiel.eunis.jrfTables.species.national.NationalThreatStatusPersist,
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

        document.eunis.action = 'species-threat-national-result.jsp';
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
              document.eunis.action = 'species-threat-national.jsp';
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
              document.eunis.action = 'species-threat-national.jsp';
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
      <%=contentManagement.getContent("species_threat-national_title", false )%>
    </title>
  </head>
<%
  String isSaveCriteriaChecked = ((request.getParameter("saveCriteria") == null ?
                                 "" :
                                 request.getParameter("saveCriteria")).equalsIgnoreCase("true") ?
                                 "checked=\"checked\"" :
                                 "");
  // REQUEST PARAMETER(S) (not necessarily required)
  // group - group where we do the search(id group)
  // groupName - The name of the group...
  String group = request.getParameter("idGroup");
  String country = request.getParameter("idCountry");
  String groupName = request.getParameter("groupName");
  String countryName = request.getParameter("countryName");
  final boolean anyGroupSelected = (null != groupName) ? groupName.equalsIgnoreCase("any") : false;


  boolean showGroup = false;
  boolean showCountry = false;
  boolean showStatus = false;
  boolean showVernacularNames = false;

   if(request.getParameter("firstTime") == null)
  {
      showGroup = true;
      showCountry = true;
      showStatus = true;
      showVernacularNames = true;

  } else
  {
      showGroup = Utilities.checkedStringToBoolean(request.getParameter("showGroup"), false);
      showCountry = Utilities.checkedStringToBoolean(request.getParameter("showCountry"), false);
      showStatus = Utilities.checkedStringToBoolean(request.getParameter("showStatus"), false);
      showVernacularNames = Utilities.checkedStringToBoolean(request.getParameter("showVernacularNames"), false);
  }

  String chekedGroup = (showGroup == true ? "checked=\"checked\"" : "");
  String chekedCountry = (showCountry == true ? "checked=\"checked\"" : "");
  String chekedStatus = (showStatus == true ? "checked=\"checked\"" : "");
  String chekedVernacular = (showVernacularNames == true ? "checked=\"checked\"" : "");

%>
  <body style="background-color:#ffffff" onload="onLoadFunction()">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,National threat status" />
      <jsp:param name="helpLink" value="species-help.jsp" />
    </jsp:include>
    <h5>
        <%=contentManagement.getContent("species_threat-national_01")%>
    </h5>
    <table summary="layout" width="100%" border="0">
      <tr>
        <td>
          <%=contentManagement.getContent("species_threat-national_21")%>
          <br />
          <br />
          <form name="eunis" method="post" action="species-threat-national-result.jsp">
          <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="background-color:#EEEEEE">
                <strong>
                  <%=contentManagement.getContent("species_threat-national_02")%>
                </strong>
              </td>
            </tr>
              <tr>
                <td style="background-color:#EEEEEE">                
                  <input title="Group" id="checkbox1" type="checkbox" name="showGroup" value="true" <%=chekedGroup%> /><label for="checkbox1"><%=contentManagement.getContent("species_threat-national_03")%></label>
                  <input title="Country" id="checkbox5" type="checkbox" name="showCountry" value="true" <%=chekedCountry%> /><label for="checkbox5"><%=contentManagement.getContent("species_threat-national_country")%></label>
                  <input title="Status" id="checkbox6" type="checkbox" name="showStatus" value="true" <%=chekedStatus%> /><label for="checkbox6"><%=contentManagement.getContent("species_threat-national_status")%></label>
<%--                  <input type="checkbox" name="showOrder" value="true' <%=chekedOrder%>><%=contentManagement.getContent("species_threat-national_04")%>&nbsp;--%>
<%--                  <input type="checkbox" name="showFamily" value="true' <%=chekedFamily%>><%=contentManagement.getContent("species_threat-national_05")%>&nbsp;--%>
                  <input title="Scientific name" id="checkbox2" type="checkbox" name="true" value="true" disabled="disabled" checked="checked" /><label for="checkbox2"><%=contentManagement.getContent("species_threat-national_06")%></label>
                  <input title="Vernacular name" id="checkbox3" type="checkbox" name="showVernacularNames" value="true" <%=chekedVernacular%> /><label for="checkbox3"><%=contentManagement.getContent("species_threat-national_07")%></label>
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
                <img width="11" height="12" style="vertical-align:middle" alt="<%=contentManagement.getContent("species_threat-national_11", false)%>" title="<%=contentManagement.getContent("species_threat-national_11", false)%>" src="images/mini/field_mandatory.gif" />&nbsp;
                <%=contentManagement.writeEditTag("species_threat-national_11",false)%>
                <%
                  if (null == group)
                  {
                    // If group is null then display the group selection texbox
                %>
                  <label for="select1" class="noshow">Group name</label>
                  <select id="select1" title="Group name" name="Group" onchange="MM_jumpMenuInternational('parent',this,0)" class="inputTextField">
                    <option value="species-threat-national.jsp"><%=contentManagement.getContent("species_threat-national_12", false)%></option>
                    <option value="species-threat-national.jsp?idGroup=-1&amp;groupName=any"
                            title="Species threat national status"><%=contentManagement.getContent("species_threat-national_13", false)%>
                    </option>
                    <% // Species groups list
                       List groups = new Chm62edtGroupspeciesDomain().findWhereDistinct("");
                       if (groups != null && groups.size() > 0)
                       {
                         for (int i = 0;i<groups.size();i++)
                         {
                            Chm62edtGroupspeciesPersist aGroup = (Chm62edtGroupspeciesPersist)groups.get(i);%>
                            <option value="species-threat-national.jsp?idGroup=<%=aGroup.getIdGroupspecies()%>&amp;groupName=<%=(aGroup.getCommonName() != null ? aGroup.getCommonName().replaceAll("&","&amp;") : "")%>">
                              <%=(aGroup.getCommonName() != null ? aGroup.getCommonName().replaceAll("&","&amp;") : "")%>
                            </option>
                    <%
                         }
                       }
                    %>
                  </select>
                <%
                  } else {
                    // or else put out the selected group and let the user select the country name.
                    if (null == country)
                    {
                      if (anyGroupSelected)
                      {
                %>
                        <strong>
                          <%=contentManagement.getContent("species_threat-national_13")%>
                        </strong>
                        &nbsp;
                        <strong>
                          <%=contentManagement.getContent("species_threat-national_15")%>
                        </strong>
                        &nbsp;
                        <%=contentManagement.getContent("species_threat-national_14")%>
                  <%
                      }
                      else
                      {
                        String groupNameDispayed = (-1 == groupName.lastIndexOf("Mosses") ? groupName : "Mosses &amp; Liverworts");
                    %>
                        <strong>
                          <%=groupNameDispayed%>
                        </strong>
                        &nbsp;
                        <strong>
                          <%=contentManagement.getContent("species_threat-national_15")%>
                        </strong>
                        &nbsp;
                        <%=contentManagement.getContent("species_threat-national_14")%>
                    <%
                      }
                    %>
                      <label for="select2" class="noshow">Country</label>
                      <select id="select2" title="Country" name="Contry" onchange="MM_jumpMenuInternational('parent',this,0)"
                              class="inputTextField">
                        <option value="species-threat-national.jsp?idGroup=<%=group%>&amp;groupName=<%=groupName%>" selected="selected">
                          <%=contentManagement.getContent("species_threat-national_16", false)%>
                        </option>
                        <%
                        NationalThreatStatusForGroupSpecies a = new NationalThreatStatusForGroupSpecies(group,"-1");
                        a.setCountriesForAnyGroup();
                        a.setCountriesForAGroup();
                        Vector CountriesForAnyGroup = a.getCountriesForAnyGroup();
                        Vector CountriesForAGroup = a.getCountriesForAGroup();
                        if (!anyGroupSelected)
                        {
                          if (CountriesForAGroup != null && CountriesForAGroup.size() > 0)
                          {
                            for (int i = 0;i<CountriesForAGroup.size();i++)
                            {
                        %>
                              <option value="species-threat-national.jsp?groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;countryName=<%=((NationalThreatStatusPersist)CountriesForAGroup.get(i)).getCountry()%>&amp;idCountry=<%=((NationalThreatStatusPersist)CountriesForAGroup.get(i)).getIdCountry()%>">
                                <%=((NationalThreatStatusPersist)CountriesForAGroup.get(i)).getCountry()%>
                              </option>
                      <%
                            }
                          }
                        } else {
                          if (CountriesForAnyGroup != null && CountriesForAnyGroup.size() > 0)
                          {
                            for (int i=0;i<CountriesForAnyGroup.size();i++)
                            {
                      %>
                              <option value="species-threat-national.jsp?groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;countryName=<%=((NationalThreatStatusPersist)CountriesForAnyGroup.get(i)).getCountry()%>&amp;idCountry=<%=((NationalThreatStatusPersist)CountriesForAnyGroup.get(i)).getIdCountry()%>">
                                <%=((NationalThreatStatusPersist)CountriesForAnyGroup.get(i)).getCountry()%>
                              </option>
                     <%
                            }
                          }
                        }
                     %>
                      </SELECT>
                  <%
                    }
                    else
                    {
                      if (anyGroupSelected)
                      {
                %>
                        <strong>
                          <%=contentManagement.getContent("species_threat-national_13")%>
                        </strong>
                        &nbsp;
                        <strong>
                          <%=contentManagement.getContent("species_threat-national_15")%>
                        </strong>
                        &nbsp;
                        <%=contentManagement.getContent("species_threat-national_14")%>
                  <%
                    } else {
                      String groupNameDispayed = (-1 == groupName.lastIndexOf("Mosses") ? groupName : "Mosses &amp; Liverworts");
                    %>
                        <strong>
                          <%=groupNameDispayed%>
                        </strong>
                        &nbsp;
                        <strong>
                          <%=contentManagement.getContent("species_threat-national_15")%>
                        </strong>
                        &nbsp;
                        <%=contentManagement.getContent("species_threat-national_14")%>
                    <%
                    }
                    %>
                      &nbsp;
                      <strong>
                        <%=countryName%>
                      </strong>
                      &nbsp;
                      <strong>
                        <%=contentManagement.getContent("species_threat-national_15")%>
                      </strong>
                      &nbsp;
                      <%=contentManagement.getContent("species_threat-national_17")%>
                      <label for="select3" class="noshow">Status</label>
                      <select id="select3" title="Status" name="Status" onchange="MM_jumpMenuInternational('parent',this,0)"
                              class="inputTextField">
                        <option value="species-threat-national.jsp?idGroup=<%=group%>&amp;groupName=<%=groupName%>&amp;idCountry=<%=country%>&amp;countryName=<%=countryName%>" selected="selected">
                          <%=contentManagement.getContent("species_threat-national_18", false)%>
                        </option>
                        <option value="species-threat-national-result.jsp?idCountry=<%=country%>&amp;countryName=<%=countryName%>&amp;idGroup=<%=group%>&amp;groupName=<%=groupName%>&amp;idConservation=-1&amp;statusName=any">
                          <%=contentManagement.getContent("species_threat-national_19", false)%>
                        </option>
                        <%
                          NationalThreatStatusForGroupSpecies a = new NationalThreatStatusForGroupSpecies(group,country);
                          a.setThreatStatusForAnyGroupAndACountry();
                          a.setThreatStatusForAGroupAndACountry();
                          Vector ThreatStatusForAnyGroupAndACountry = a.getThreatStatusForAnyGroupAndACountry();
                          Vector ThreatStatusForAGroupAndACountry = a.getThreatStatusForAGroupAndACountry();
                          if (!anyGroupSelected)
                          {
                            if (ThreatStatusForAGroupAndACountry != null && ThreatStatusForAGroupAndACountry.size() > 0)
                            {
                              for (int i = 0;i<ThreatStatusForAGroupAndACountry.size();i++)
                              {
                        %>
                                <option value="species-threat-national-result.jsp?idCountry=<%=country%>&amp;countryName=<%=countryName%>&amp;groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;statusName=<%=((NationalThreatStatusPersist)ThreatStatusForAGroupAndACountry.get(i)).getDefAbrev()%>&amp;idConservation=<%=((NationalThreatStatusPersist)ThreatStatusForAGroupAndACountry.get(i)).getIdCons()%>">
                                  <%=((NationalThreatStatusPersist)ThreatStatusForAGroupAndACountry.get(i)).getDefAbrev()%>
                                </option>
                        <%
                              }
                            }
                          }
                          else
                          {
                            if (ThreatStatusForAnyGroupAndACountry != null && ThreatStatusForAnyGroupAndACountry.size() > 0)
                            {
                              for (int i=0;i<ThreatStatusForAnyGroupAndACountry.size();i++)
                              {
                        %>
                                <option value="species-threat-national-result.jsp?idCountry=<%=country%>&amp;countryName=<%=countryName%>&amp;groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;statusName=<%=((NationalThreatStatusPersist)ThreatStatusForAnyGroupAndACountry.get(i)).getDefAbrev()%>&amp;idConservation=<%=((NationalThreatStatusPersist)ThreatStatusForAnyGroupAndACountry.get(i)).getIdCons()%>">
                                  <%=((NationalThreatStatusPersist)ThreatStatusForAnyGroupAndACountry.get(i)).getDefAbrev()%>
                                </option>
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
                if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
                {
              %>
                  <tr>
                    <td>&nbsp; <br />
                      <input title="Save criteria" id="saveCriteria" type="checkbox" name="saveCriteria" value="true" <%=isSaveCriteriaChecked%> />
                      <label for="saveCriteria"><%=contentManagement.getContent("species_threat-national_10")%></label>
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
    <tr>
      <td style="text-align:center">
        <strong>
          <%=contentManagement.getContent("species_threat-national_20")%>
        </strong>
      </td>
    </tr>
  </table>
<%
    // Expand saved searches list for this jsp page
    if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
    {
      // Set Vector for URL string
      Vector show = new Vector();
      show.addElement("showGroup");
      show.addElement("showFamily");
      show.addElement("showOrder");
      show.addElement("showScientificName");
      show.addElement("showVernacularNames");
      String pageName = "species-threat-national.jsp";
      String pageNameResult = "species-threat-national-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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
    <jsp:param name="page_name" value="species-threat-national.jsp" />
  </jsp:include>
  </div>
    </body>
</html>