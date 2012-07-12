<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species International threat status' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesDomain,
                 java.util.Vector,
                 ro.finsiel.eunis.search.species.internationalthreatstatus.InternationalStatusForGroupSpecies,
                 ro.finsiel.eunis.jrfTables.species.internationalthreatstatus.InternationalThreatStatusPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" src="<%=request.getContextPath()%>/script/species-country.js" type="text/javascript"></script>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,international_threat_status";
%>
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
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
              alert('<%=cm.cms("save_alert")%>');
              document.eunis.submit();
        } else
        {
              if(group != null && groupName != null)
              {
                 alert('<%=cm.cms("please_select_a_country")%>');
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
              else alert('<%=cm.cms("please_select_a_group")%>');
              document.eunis.action = 'species-threat-international.jsp';
              document.eunis.submit();

        }
        }
            <%
            }
            %>

   //]]>
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_international_threat_status")%>
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
  <body onload="onLoadFunction()">
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
                <jsp:param name="location" value="<%=btrail%>" />
              </jsp:include>
              <a name="documentContent"></a>
                <h1>
                    <%=cm.cmsPhrase("International Threat Status")%>
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
                  <li>
                      <a href="species-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cmsPhrase("Help information")%>"
                             title="<%=cm.cmsPhrase("Help information")%>" /></a>
                    </li>
                </ul>
              </div>
<!-- MAIN CONTENT -->
                <table summary="layout" width="100%" border="0">
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Search species threatened at international level <br />(ex.: search birds from <strong>Europe</strong> which are marked as <strong>declining</strong>)")%>
                      <br />
                      <br />
                      <form name="eunis" method="post" action="species-threat-international-result.jsp">
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
                            <input title="<%=cm.cmsPhrase("Group")%>" id="checkbox2" type="checkbox" name="showGroup" value="true" <%=(showGroup ? "checked=\"checked\"" : "")%> />
                              <label for="checkbox2"><%=cm.cmsPhrase("Group")%></label>
                            <input title="<%=cm.cms("geographic_region")%>" id="checkbox5" type="checkbox" name="showGeo" value="true" <%=(showGeo ? "checked=\"checked\"" : "")%> />
                              <label for="checkbox5"><%=cm.cmsPhrase("Geographical region")%></label>
                              <%=cm.cmsTitle("geographic_region")%>
                            <input title="<%=cm.cms("status")%>" id="checkbox1" type="checkbox" name="showStatus" value="true" <%=(showStatus ? "checked=\"checked\"" : "")%> />
                              <label for="checkbox1"><%=cm.cmsPhrase("Threat Status")%></label>
                              <%=cm.cmsTitle("status")%>
                            <input title="<%=cm.cmsPhrase("Scientific name")%>" id="checkbox3" type="checkbox" name="true" value="true" disabled="disabled" checked="checked" />
                              <label for="checkbox3"><%=cm.cmsPhrase("Scientific name")%></label>
                            <input title="<%=cm.cms("vernacular_name")%>" id="checkbox4" type="checkbox" name="showVernacularNames" value="true" <%=(showVernacularNames ? "checked=\"checked\"" : "")%> />
                              <label for="checkbox4"><%=cm.cmsPhrase("Vernacular names")%></label>
                              <%=cm.cmsTitle("vernacular_name")%>
                          </td>
                        </tr>
                      </table>
                      <br />
                      <table summary="layout" cellspacing="1" cellpadding="0" border="0" width="100%" style="text-align:left">
                        <tr>
                          <td style="vertical-align:middle">
                            <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" />
                            <%
                              if (null == group)
                              {
                                // If group is null then display the group selection texbox
                            %>
                                <label for="Group" class="noshow"><%=cm.cms("group_name")%></label>
                                <select title="<%=cm.cms("group_name")%>" name="Group" id="Group" onchange="MM_jumpMenuInternational('parent',this,0)">
                                  <option value="species-threat-international.jsp">
                                    <%=cm.cms("please_select_a_group")%>
                                  </option>
                                  <option value="species-threat-international.jsp?idGroup=-1&amp;groupName=any">
                                    <%=cm.cms("any_group")%>
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
                              <%=cm.cmsLabel("group_name")%>
                              <%=cm.cmsTitle("group_name")%>
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
                                  <%=cm.cmsPhrase("Any group")%>
                                </strong>

                                <br />
                                &nbsp;
                                <strong>   <% //and%>
                                  <%=cm.cmsPhrase("and")%>
                                </strong>
                                &nbsp;  <% //area%>
                                <%=cm.cmsPhrase("Area")%>
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
                                    <%=cm.cmsPhrase("and")%>
                                  </strong>
                                  &nbsp;
                                  <%=cm.cmsPhrase("Area")%>
                              <%
                                }
                              %>
                                   &nbsp;
                                   <label for="Country" class="noshow"><%=cm.cmsPhrase("Country")%></label>
                                   <select title="<%=cm.cmsPhrase("Country")%>" name="Contry" id="Country" onchange="MM_jumpMenuInternational('parent',this,0)">
                                    <option value="species-threat-international.jsp?idGroup=<%=group%>&amp;groupName=<%=groupName%>" selected="selected">
                                      <%=cm.cms("species_threat-international_18")%>
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
                                } else {
                             %>
                             <%
                                if (anyGroupSelected) {
                            %>
                                <strong>
                                  <%=cm.cmsPhrase("Any group")%>
                                </strong>

                                <br />
                                &nbsp;
                                <strong>
                                  <%=cm.cmsPhrase("and")%>
                                </strong>
                                &nbsp;
                                <%=cm.cmsPhrase("Area")%>
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
                                    <%=cm.cmsPhrase("and")%>
                                  </strong>
                                  &nbsp;
                                  <%=cm.cmsPhrase("Area")%>
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
                                 <%=cm.cmsPhrase("and")%>
                                 </strong>
                                 &nbsp;  <% //threat status%>
                                <%=cm.cmsPhrase("Threat Status")%>
                                &nbsp;
                                <label for="Status" class="noshow"><%=cm.cms("status")%></label>
                                <select title="<%=cm.cms("status")%>" name="Status" id="Status" onchange="MM_jumpMenuInternational('parent',this,0)">
                                  <option value="species-threat-international.jsp?idGroup=<%=group%>&amp;groupName=<%=groupName%>&amp;countryName=<%=countryName%>&amp;idCountry=<%=country%>" selected="selected">
                                    <%=cm.cms("please_select_a_threat_status")%>
                                  </option>
                                  <option value="species-threat-international-result.jsp?idGroup=<%=group%>&amp;groupName=<%=groupName%>&amp;countryName=<%=countryName%>&amp;idCountry=<%=country%>&amp;idConservation=-1&amp;statusName=any">
                                    <%=cm.cms("any_threat_status")%>
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
                             <%=cm.cmsLabel("status")%>
                             <%=cm.cmsTitle("status")%>
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
                                  <input title="<%=cm.cmsPhrase("Save search criteria")%>" id="saveCriteria" type="checkbox" name="saveCriteria" value="true" <%=isSaveCriteriaChecked%> />
                                    <label for="saveCriteria"><%=cm.cmsPhrase("Save this criteria")%></label>
                                    <a title="<%=cm.cmsPhrase("Save search criteria")%>" href="javascript:checkSaveCriteria()"><img alt="<%=cm.cmsPhrase("Save search criteria")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
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
              <%=cm.br()%>
              <%=cm.cmsMsg("save_alert")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("please_select_a_country")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("please_select_a_group")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("species_international_threat_status")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("please_select_a_group")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("any_group")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("species_threat-international_18")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("please_select_a_threat_status")%>
              <%=cm.br()%>
              <%=cm.cmsMsg("any_threat_status")%>
              <%=cm.br()%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="species-threat-international.jsp" />
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
