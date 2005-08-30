<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'statistics species module'.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.utilities.SQLUtilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.List,
                 ro.finsiel.eunis.utilities.TableColumns"%>
<%@ page import="ro.finsiel.eunis.search.CountryUtil"%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
    <script language="JavaScript" type="text/javascript" src="script/sort-table.js"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
       function MM_jumpMenuCountry(targ,selObj,restore){ //v3.0
         eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
         if (restore) selObj.selectedIndex=0;
}
    //-->
    </script>
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();

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
      Statistics Species Module
    </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Species#species.jsp,Species statistics" />
      <jsp:param name="helpLink" value="species-help.jsp" />
    </jsp:include>
    <img alt="Loading" id="loading" src="images/loading.gif" />
<%
  out.flush();
%>
<h5>
Species Statistics
</h5>
<%
  out.flush();
%>
    <br />
    <strong>
    Statistical data at EUNIS Database level:
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
    <table summary="layout" width="100%" cellspacing="1" cellpadding="1" border="1" style="border-collapse:collapse">
      <tr style="background-color:#EEEEEE">
        <td width="80%">
          Number of distinct species:
        </td>
        <td width="20%">
          <%=nDistinctSpecies%>
        </td>
      </tr>
      <tr style="background-color:#FFFFFF">
        <td>
          Number of species names:
        </td>
        <td>
          <%=nSpeciesNames%>
        </td>
      </tr>
      <tr style="background-color:#EEEEEE">
        <td>
          Number of vernacular names:
        </td>
        <td>
          <%=nVernacularNames%>
        </td>
      </tr>
      <tr style="background-color:#FFFFFF">
        <td>
          Number of languages concerned in vernacular names search:
        </td>
        <td>
          <%=nLanguages%>
        </td>
      </tr>
      <tr style="background-color:#EEEEEE">
        <td>
          Number of species having international legal status:
        </td>
        <td>
          <%=nInternationalLegalStatus%>
        </td>
      </tr>
      <tr style="background-color:#FFFFFF">
        <td>
          Number of international legal instruments:
        </td>
        <td>
          <%=nInternationalLegalInstruments%>
        </td>
      </tr>
      <tr style="background-color:#EEEEEE">
        <td>
          Number of species having conservation status at international level:
        </td>
        <td>
          <%=nInternationalConservationStatus%>
        </td>
      </tr>
      <tr style="background-color:#FFFFFF">
        <td>
          Number of species having conservation status at national level:
        </td>
        <td>
          <%=nNationalConservationStatus%>
        </td>
      </tr>
      <tr style="background-color:#EEEEEE">
        <td>
          Number of countries concerned in conservation status at national level search:
        </td>
        <td>
          <%=nNationalConservationStatusCountries%>
        </td>
      </tr>
      <tr style="background-color:#FFFFFF">
        <td>
          Number of species having geographical distribution:
        </td>
        <td>
          <%=nGeographicalDistribution%>
        </td>
      </tr>
      <tr style="background-color:#EEEEEE">
        <td>
          Number of species having grid distribution:
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
    <span style="color:red">No data was found at Eunis Database level!</span>
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
    If you want statistical data at country level,
    <br />
    please choose a country: &nbsp;&nbsp;
    </strong>
    <label for="Country" class="noshow">Country</label>
    <select title="Country" name="Country" id="Country" onchange="MM_jumpMenuCountry('parent',this,0)" class="inputTextField">
    <option value="species-statistics-module.jsp">Please choose a country</option>
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
      <h6>Statistical data for <span style="font-style: italic"><%=countryName%></span>:</h6>
      <br />
    <table summary="Statistical data by country" width="100%" border="1" style="border-collapse:collapse">
      <tr style="background-color:#EEEEEE">
        <td width="80%">
          Number of distinct species:
        </td>
        <td width="20%">
          <%=nDistinctSpeciesByCountry%>
        </td>
      </tr>
      <tr style="background-color:#FFFFFF">
        <td>
          Number of species names:
        </td>
        <td>
          <%=nSpeciesNamesByCountry%>
        </td>
      </tr>
      <tr style="background-color:#EEEEEE">
        <td>
          Number of vernacular names:
        </td>
        <td>
          <%=nVernacularNamesByCountry%>
        </td>
      </tr>
      <tr style="background-color:#FFFFFF">
        <td>
          Number of languages concerned in vernacular names search:
        </td>
        <td>
          <%=nLanguagesByCountry%>
        </td>
      </tr>
      <tr style="background-color:#EEEEEE">
        <td>
          Number of species having international legal status:
        </td>
        <td>
          <%=nInternationalLegalStatusByCountry%>
        </td>
      </tr>
      <tr style="background-color:#FFFFFF">
        <td>
          Number of international legal instruments:
        </td>
        <td>
          <%=nInternationalLegalInstrumentsByCountry%>
        </td>
      </tr>
      <tr style="background-color:#EEEEEE">
        <td>
          Number of species having conservation status at national level:
        </td>
        <td>
          <%=nNationalConservationStatusByCountry%>
        </td>
      </tr>
      <tr style="background-color:#FFFFFF">
        <td>
          Number of species having geographical distribution:
        </td>
        <td>
          <%=nGeographicalDistributionByCountry%>
        </td>
      </tr>
      <tr style="background-color:#EEEEEE">
        <td>
          Number of species having grid distribution:
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
       <span style="color:red">No data was found at country <%=countryName%> level!</span>
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
    <noscript>Your browser does not support JavaScript!</noscript>
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-statistics-module.jsp" />
    </jsp:include>
  </div>
  </body>
</html>
<%
  out.flush();
%>

