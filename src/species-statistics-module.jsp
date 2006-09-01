<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'statistics species module'.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.List,
                 ro.finsiel.eunis.utilities.TableColumns"%>
<%@ page import="ro.finsiel.eunis.search.CountryUtil"%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript">
    <!--
       function MM_jumpMenuCountry(targ,selObj,restore){ //v3.0
         eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
         if (restore) selObj.selectedIndex=0;
}
    //-->
    </script>
    <%
      WebContentManagement cm = SessionManager.getWebContent();

      String SQL_DRV = application.getInitParameter("JDBC_DRV");
      String SQL_URL = application.getInitParameter("JDBC_URL");
      String SQL_USR = application.getInitParameter("JDBC_USR");
      String SQL_PWD = application.getInitParameter("JDBC_PWD");

      SQLUtilities sqlc = new SQLUtilities();
      sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

    String countryName = (request.getParameter("countryName") == null ? "" : request.getParameter("countryName"));

    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("statistics_species_module")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_SERVER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
                <br clear="all" />
<!-- MAIN CONTENT -->
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="home#index.jsp,species#species.jsp,species_statistics" />
                  <jsp:param name="helpLink" value="species-help.jsp" />
                </jsp:include>
                <img alt="Loading" id="loading" src="images/loading.gif" />
            <%
              out.flush();
            %>
            <h1>
            <%=cm.cmsText("species_statistics")%>
            </h1>
            <%
              out.flush();
            %>
                <br />
                <strong>
                <%=cm.cmsText("statistical_data_EUNIS")%>
                </strong>
                  <br /><br/>
            <%
                  String statisticsForAll = " select NUMBER_OF_DISTINCT_SPECIES, NUMBER_OF_SPECIES_NAMES, NUMBER_OF_VERNACULAR_NAMES, " +
                          " NUMBER_OF_LANGUAGES, NUMBER_OF_LEGAL_STATUS, NUMBER_OF_LEGAL_INSTRUMENTS, " +
                          " NUMBER_OF_INTERN_CONS_STATUS, NUMBER_OF_NATIONAL_CONS_STATUS, NUMBER_OF_COUNTRIES_FOR_CONS_STATUS, " +
                          " NUMBER_OF_GEOGRAPHICAL_DIST, NUMBER_OF_GRID_DISTR " +
                          " from chm62edt_species_statistics_module where area_name_en = 'all' ";

                  List listOfStatisticsForAll = sqlc.ExecuteSQLReturnList(statisticsForAll,11);

                  if(listOfStatisticsForAll != null && listOfStatisticsForAll.size()>0)
                  {

                     String nDistinctSpecies = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(0);
                     String nSpeciesNames = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(1);
                     String nVernacularNames = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(2);
                     String nLanguages = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(3);
                     String nInternationalLegalStatus = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(4);
                     String nInternationalLegalInstruments = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(5);
                     String nInternationalConservationStatus = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(6);
                     String nNationalConservationStatus = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(7);
                     String nNationalConservationStatusCountries = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(8);
                     String nGeographicalDistribution = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(9);
                     String nGridDistribution = (String)((TableColumns) listOfStatisticsForAll.get(0)).getColumnsValues().get(10);
            %>
                <table summary="layout" width="90%" class="datatable">
                  <tr>
                    <td width="80%">
                     <%=cm.cmsText("number_distinct_species")%>
                    </td>
                    <td width="20%">
                      <%=nDistinctSpecies%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsText("number_species_names")%>
                    </td>
                    <td>
                      <%=nSpeciesNames%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("number_vernacular_names")%>
                    </td>
                    <td>
                      <%=nVernacularNames%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                     <%=cm.cmsText("number_languages")%>
                    </td>
                    <td>
                      <%=nLanguages%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("number_international_status")%>
                    </td>
                    <td>
                      <%=nInternationalLegalStatus%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsText("number_international_instruments")%>
                    </td>
                    <td>
                      <%=nInternationalLegalInstruments%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("number_international_conservation")%>
                    </td>
                    <td>
                      <%=nInternationalConservationStatus%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsText("number_national_conservation")%>
                    </td>
                    <td>
                      <%=nNationalConservationStatus%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("number_countries_conservation")%>
                    </td>
                    <td>
                      <%=nNationalConservationStatusCountries%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsText("number_geo")%>
                    </td>
                    <td>
                      <%=nGeographicalDistribution%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("number_grid")%>
                    </td>
                    <td>
                      <%=nGridDistribution%>
                    </td>
                  </tr>
                </table>
            <%
                } else
                {
            %>
                <span style="color:red"><%=cm.cmsText("no_data_eunis")%></span>
            <%
                }
              out.flush();
            %>
                    <%
                        List allCountries = CountryUtil.findAllCountries();
                        if (allCountries != null && allCountries.size()>0)
                        {
                    %>

                <br /><br />
                <strong>
                <%=cm.cmsText("if_want")%>
                <br />
                <%=cm.cmsText("please_choose")%> &nbsp;&nbsp;
                </strong>
                <label for="Country" class="noshow"><%=cm.cms("country")%></label>
                <select title="<%=cm.cms("country")%>" name="Country" id="Country" onchange="MM_jumpMenuCountry('parent',this,0)">
                <option value="species-statistics-module.jsp"><%=cm.cms("please_choose_country")%></option>
                  <%
                     for(int i=0;i<allCountries.size();i++)
                     {
                        Chm62edtCountryPersist aCountry = (Chm62edtCountryPersist)allCountries.get(i);
                        String selected = (aCountry.getAreaNameEnglish() != null && countryName != null && countryName.equals(aCountry.getAreaNameEnglish()) ? "selected=\"selected\"":"");
                  %>
                       <option value="species-statistics-module.jsp?countryName=<%=aCountry.getAreaNameEnglish()%>" <%=selected%>><%=aCountry.getAreaNameEnglish()%></option>
                  <%
                     }
                  %>
                </select>
                <%=cm.cmsLabel("country")%>
                <%=cm.cmsTitle("country")%>
                <br />
                <%
                   if(countryName.trim().length()>0)
                   {
                     String statisticsForACountry = " select NUMBER_OF_DISTINCT_SPECIES, NUMBER_OF_SPECIES_NAMES, NUMBER_OF_VERNACULAR_NAMES, " +
                          " NUMBER_OF_LANGUAGES, NUMBER_OF_LEGAL_STATUS, NUMBER_OF_LEGAL_INSTRUMENTS, " +
                          " NUMBER_OF_NATIONAL_CONS_STATUS, " +
                          " NUMBER_OF_GEOGRAPHICAL_DIST, NUMBER_OF_GRID_DISTR " +
                          " from chm62edt_species_statistics_module where area_name_en = '" + countryName + "' ";

                  List listOfStatisticsForACountry = sqlc.ExecuteSQLReturnList(statisticsForACountry,9);

                  if(listOfStatisticsForACountry != null && listOfStatisticsForACountry.size()>0)
                  {

                     String nDistinctSpeciesByCountry = (String)((TableColumns) listOfStatisticsForACountry.get(0)).getColumnsValues().get(0);
                     String nSpeciesNamesByCountry = (String)((TableColumns) listOfStatisticsForACountry.get(0)).getColumnsValues().get(1);
                     String nVernacularNamesByCountry = (String)((TableColumns) listOfStatisticsForACountry.get(0)).getColumnsValues().get(2);
                     String nLanguagesByCountry = (String)((TableColumns) listOfStatisticsForACountry.get(0)).getColumnsValues().get(3);
                     String nInternationalLegalStatusByCountry = (String)((TableColumns) listOfStatisticsForACountry.get(0)).getColumnsValues().get(4);
                     String nInternationalLegalInstrumentsByCountry = (String)((TableColumns) listOfStatisticsForACountry.get(0)).getColumnsValues().get(5);
                     String nNationalConservationStatusByCountry = (String)((TableColumns) listOfStatisticsForACountry.get(0)).getColumnsValues().get(6);
                     String nGeographicalDistributionByCountry = (String)((TableColumns) listOfStatisticsForACountry.get(0)).getColumnsValues().get(7);
                     String nGridDistributionByCountry = (String)((TableColumns) listOfStatisticsForACountry.get(0)).getColumnsValues().get(8);
                %>
                  <br /> <br />
                  <h2><%=cm.cmsText("statistical_data_for")%>&nbsp;<span style="font-style: italic"><%=countryName%></span>:</h2>
                  <br />
                <table summary="<%=cm.cms("statistical_data_country")%>" width="90%" class="datatable">
                  <tr>
                    <td width="80%">
                      <%=cm.cmsText("number_distinct_species")%>
                    </td>
                    <td width="20%">
                      <%=nDistinctSpeciesByCountry%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsText("number_species_names")%>
                    </td>
                    <td>
                      <%=nSpeciesNamesByCountry%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("number_vernacular_names")%>
                    </td>
                    <td>
                      <%=nVernacularNamesByCountry%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsText("number_languages")%>
                    </td>
                    <td>
                      <%=nLanguagesByCountry%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("number_international_status")%>
                    </td>
                    <td>
                      <%=nInternationalLegalStatusByCountry%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsText("number_international_instruments")%>
                    </td>
                    <td>
                      <%=nInternationalLegalInstrumentsByCountry%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("number_national_conservation")%>
                    </td>
                    <td>
                      <%=nNationalConservationStatusByCountry%>
                    </td>
                  </tr>
                  <tr class="zebraeven">
                    <td>
                      <%=cm.cmsText("number_geo")%>
                    </td>
                    <td>
                      <%=nGeographicalDistributionByCountry%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsText("number_grid")%>
                    </td>
                    <td>
                      <%=nGridDistributionByCountry%>
                    </td>
                  </tr>
                </table>

               <%
                   } else {
               %>
                   <br />
                   <span style="color:red"><%=cm.cmsText("no_data_country")%> <%=countryName%>!</span>
                   <br />
               <%
                       }
                   }
               %>
                <%
                    }
                %>


                <script language="JavaScript" type="text/javascript">
                 <!--
                  var load = document.getElementById( "loading" );
                  load.style.display="none";
                 //-->
                </script>

                <%=cm.br()%>
                <%=cm.cmsMsg("statistics_species_module")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("please_choose_country")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("statistical_data_country")%>
                <%=cm.br()%>

                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="species-statistics-module.jsp" />
                </jsp:include>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp" />
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_SERVER" ) )%>
    </div>
  </body>
</html>
