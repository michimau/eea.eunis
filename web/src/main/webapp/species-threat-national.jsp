<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species National threat status' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesDomain,
                 java.util.Vector,
                 ro.finsiel.eunis.search.species.national.NationalThreatStatusForGroupSpecies,
                 ro.finsiel.eunis.jrfTables.species.national.NationalThreatStatusPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />

<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,national_threat_status";
%>

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
    final boolean anyCountrySelected = (null != countryName) ? countryName.equalsIgnoreCase("any") : false;


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

<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("species_threat-national_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" helpLink="species-help.jsp" pageTitle="${title}" btrail="<%= btrail%>">
<stripes:layout-component name="head">
    <script language="JavaScript" src="<%=request.getContextPath()%>/script/species-country.js" type="text/javascript"></script>
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
        window.onload = function() {
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
              document.eunis.action = 'species-threat-national.jsp';
              document.eunis.submit();

        }
        }
            <%
            }
            %>

   //]]>
   </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>
                <h1>
                    <%=cm.cmsPhrase("National threat status")%>
                </h1>
  <!-- MAIN CONTENT -->
                <table summary="layout" width="100%" border="0">
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Species threatened at country level<br />(ex.: search for <strong>birds</strong> from <strong>Poland</strong> which are marked as <strong>critically endangered</strong>)")%>
                      <br />
                      <br />
                      <form name="eunis" method="post" action="species-threat-national-result.jsp">
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
                              <input title="<%=cm.cmsPhrase("Group")%>" id="checkbox1" type="checkbox" name="showGroup" value="true" <%=chekedGroup%> />
                                <label for="checkbox1"><%=cm.cmsPhrase("Group")%></label>
                              <input title="<%=cm.cmsPhrase("Country")%>" id="checkbox5" type="checkbox" name="showCountry" value="true" <%=chekedCountry%> />
                                <label for="checkbox5"><%=cm.cmsPhrase("Country")%></label>
                              <input title="<%=cm.cms("status")%>" id="checkbox6" type="checkbox" name="showStatus" value="true" <%=chekedStatus%> />
                                <label for="checkbox6"><%=cm.cmsPhrase("Threat Status")%></label>
                                <%=cm.cmsTitle("status")%>
                              <input title="<%=cm.cmsPhrase("Scientific name")%>" id="checkbox2" type="checkbox" name="true" value="true" disabled="disabled" checked="checked" />
                                <label for="checkbox2"><%=cm.cmsPhrase("Scientific name")%></label>
                              <input title="<%=cm.cms("vernacular_name")%>" id="checkbox3" type="checkbox" name="showVernacularNames" value="true" <%=chekedVernacular%> />
                                <label for="checkbox3"><%=cm.cmsPhrase("Vernacular names")%></label>
                                <%=cm.cmsTitle("vernacular_name")%>
                            </td>
                          </tr>
                      </table>
                      <br />
                      <table summary="layout" cellspacing="1" cellpadding="0" border="0" width="100%" style="text-align:left">
                        <tr>
                          <td style="vertical-align:middle">
                            <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cmsPhrase("This field is mandatory")%>" title="<%=cm.cmsPhrase("This field is mandatory")%>" src="images/mini/field_mandatory.gif" />&nbsp;
                            <%
                              if (null == group)
                              {
                                // If group is null then display the group selection texbox
                            %>
                              <label for="select1" class="noshow"><%=cm.cms("group_name")%></label>
                              <select id="select1" title="<%=cm.cms("group_name")%>" name="Group" onchange="MM_jumpMenuInternational('parent',this,0)">
                                <option value="species-threat-national.jsp"><%=cm.cms("please_select_a_group")%></option>
                                <option value="species-threat-national.jsp?idGroup=-1&amp;groupName=any"
                                        title="Species threat national status"><%=cm.cms("any_group")%>
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
                              <%=cm.cmsLabel("group_name")%>
                              <%=cm.cmsTitle("group_name")%>
                            <%
                              } else {
                                // or else put out the selected group and let the user select the country name.
                                if (null == country)
                                {
                                  if (anyGroupSelected)
                                  {
                            %>
                                    <strong>
                                      <%=cm.cmsPhrase("Any group")%>
                                    </strong>
                                    &nbsp;
                                    <strong>
                                      <%=cm.cmsPhrase("and")%>
                                    </strong>
                                    &nbsp;
                                    <%=cm.cmsPhrase("Country name")%>
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
                                      <%=cm.cmsPhrase("and")%>
                                    </strong>
                                    &nbsp;
                                    <%=cm.cmsPhrase("Country name")%>
                                <%
                                  }
                                %>
                                  <label for="select2" class="noshow"><%=cm.cmsPhrase("Country")%></label>
                                  <select id="select2" title="<%=cm.cmsPhrase("Country")%>" name="Contry" onchange="MM_jumpMenuInternational('parent',this,0)">
                                    <option value="species-threat-national.jsp?idGroup=<%=group%>&amp;groupName=<%=groupName%>" selected="selected">
                                      <%=cm.cms("please_select_a_country")%>
                                    </option>
                                    <option value="species-threat-national.jsp?groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;countryName=any&amp;idCountry=-1">
                                      <%=cm.cms("any_country")%>
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
                                  </select>
                              <%
                                }
                                else
                                {
                                  if (anyGroupSelected)
                                  {
                            %>
                                    <strong>
                                      <%=cm.cmsPhrase("Any group")%>
                                    </strong>
                                    &nbsp;
                                    <strong>
                                      <%=cm.cmsPhrase("and")%>
                                    </strong>
                                    &nbsp;
                                    <%=cm.cmsPhrase("Country name")%>
                              <%
                                } else {
                                  String groupNameDispayed = (-1 == groupName.lastIndexOf("Mosses") ? groupName : "Mosses &amp; Liverworts");
                                %>
                                    <strong>
                                      <%=groupNameDispayed%>
                                    </strong>
                                    &nbsp;
                                    <strong>
                                      <%=cm.cmsPhrase("and")%>
                                    </strong>
                                    &nbsp;
                                    <%=cm.cmsPhrase("Country name")%>
                                <%
                                }
                                %>
                                  &nbsp;
                                  <strong>
                                    <%=countryName%>
                                  </strong>
                                  &nbsp;
                                  <strong>
                                    <%=cm.cmsPhrase("and")%>
                                  </strong>
                                  &nbsp;
                                  <%=cm.cmsPhrase("Threat Status")%>
                                  <label for="select3" class="noshow"><%=cm.cms("status")%></label>
                                  <select id="select3" title="<%=cm.cms("status")%>" name="Status" onchange="MM_jumpMenuInternational('parent',this,0)">
                                    <option value="species-threat-national.jsp?idGroup=<%=group%>&amp;groupName=<%=groupName%>&amp;idCountry=<%=country%>&amp;countryName=<%=countryName%>" selected="selected">
                                      <%=cm.cms("please_select_a_threat_status")%>
                                    </option>
                                    <option value="species-threat-national-result.jsp?idCountry=<%=country%>&amp;countryName=<%=countryName%>&amp;idGroup=<%=group%>&amp;groupName=<%=groupName%>&amp;idConservation=-1&amp;statusName=any">
                                      <%=cm.cms("any_threat_status")%>
                                    </option>
                                    <%
                                      NationalThreatStatusForGroupSpecies a = new NationalThreatStatusForGroupSpecies(group,country);
                                      a.setThreatStatusForAnyGroupAndACountry();
                                      a.setThreatStatusForAGroupAndACountry();
                                      a.setThreatStatusForAnyGroupAndAnyCountry();
                                      a.setThreatStatusForAGroupAndAnyCountry();
                                      Vector ThreatStatusForAnyGroupAndACountry = a.getThreatStatusForAnyGroupAndACountry();
                                      Vector ThreatStatusForAGroupAndACountry = a.getThreatStatusForAGroupAndACountry();
                                      Vector ThreatStatusForAnyGroupAndAnyCountry = a.getThreatStatusForAnyGroupAndAnyCountry();
                                      Vector ThreatStatusForAGroupAndAnyCountry = a.getThreatStatusForAGroupAndAnyCountry();
                                      if (!anyGroupSelected && !anyCountrySelected)
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
                                      else if (anyGroupSelected && !anyCountrySelected)
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
                                      else if (!anyGroupSelected && anyCountrySelected)
                                      {
                                        if (ThreatStatusForAGroupAndAnyCountry != null && ThreatStatusForAGroupAndAnyCountry.size() > 0)
                                        {
                                          for (int i=0;i<ThreatStatusForAGroupAndAnyCountry.size();i++)
                                          {
                                    %>
                                            <option value="species-threat-national-result.jsp?countryName=any&amp;groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;statusName=<%=((NationalThreatStatusPersist)ThreatStatusForAGroupAndAnyCountry.get(i)).getDefAbrev()%>&amp;idConservation=<%=((NationalThreatStatusPersist)ThreatStatusForAGroupAndAnyCountry.get(i)).getIdCons()%>">
                                              <%=((NationalThreatStatusPersist)ThreatStatusForAGroupAndAnyCountry.get(i)).getDefAbrev()%>
                                            </option>
                                    <%
                                          }
                                        }
                                      }
                                      else if (anyGroupSelected && anyCountrySelected)
                                      {
                                        if (ThreatStatusForAnyGroupAndAnyCountry != null && ThreatStatusForAnyGroupAndAnyCountry.size() > 0)
                                        {
                                          for (int i=0;i<ThreatStatusForAnyGroupAndAnyCountry.size();i++)
                                          {
                                    %>
                                            <option value="species-threat-national-result.jsp?countryName=any&amp;groupName=<%=groupName%>&amp;idGroup=<%=group%>&amp;statusName=<%=((NationalThreatStatusPersist)ThreatStatusForAnyGroupAndAnyCountry.get(i)).getDefAbrev()%>&amp;idConservation=<%=((NationalThreatStatusPersist)ThreatStatusForAnyGroupAndAnyCountry.get(i)).getIdCons()%>">
                                              <%=((NationalThreatStatusPersist)ThreatStatusForAnyGroupAndAnyCountry.get(i)).getDefAbrev()%>
                                            </option>
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
                            if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
                            {
                          %>
                              <tr>
                                <td>&nbsp; <br />
                                  <input title="<%=cm.cmsPhrase("Save search criteria")%>" id="saveCriteria" type="checkbox" name="saveCriteria" value="true" <%=isSaveCriteriaChecked%> />
                                  <label for="saveCriteria"><%=cm.cmsPhrase("Save your criteria:")%></label>
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
                <tr>
                  <td style="text-align:center">
                    <strong>
                      <%=cm.cmsPhrase("Disclaimer: Database does not contain data for all countries")%>
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

            <%=cm.br()%>
            <%=cm.cmsMsg("save_alert")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("please_select_a_country")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("please_select_a_group")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("species_threat-national_title")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("please_select_a_group")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("any_group")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("please_select_a_country")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("please_select_a_threat_status")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("any_threat_status")%>
            <%=cm.br()%>
  <!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>