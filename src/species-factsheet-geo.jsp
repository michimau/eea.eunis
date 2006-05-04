<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - geographical informations.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.factsheet.species.GeographicalStatusWrapper,
                 ro.finsiel.eunis.jrfTables.Chm62edtSpeciesStatusPersist,
                 ro.finsiel.eunis.search.UniqueVector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.factsheet.species.ThreatColor"%>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.formBeans.SpeciesFactSheetBean" scope="page">
  <jsp:setProperty name="FormBean" property="*" />
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  // List of geographical status information.
  Vector v = SpeciesFactsheet.getBioRegionIterator(FormBean.getIdNatureObject());
  if( v.size() > 0 )
  {
    // Display map
    UniqueVector colorURL = new UniqueVector();
    UniqueVector statuses = new UniqueVector();
    // Get all distinct statuses
    for (int i = 0;  i < v.size(); i++)
    {
      GeographicalStatusWrapper aRow = ( GeographicalStatusWrapper )v.get(i);
      statuses.addElement( aRow.getStatus() );
    }
    // Compute distinct color for each status
    Hashtable statusColorPair = ThreatColor.getColorsForMap(statuses);
    Vector addedCountries = new Vector();
    //fix to display in map legend only visible colours
    statuses.clear();
    for ( int i = 0; i < v.size(); i++ )
    {
      GeographicalStatusWrapper aRow = (GeographicalStatusWrapper)v.get(i);
      Chm62edtCountryPersist cntry = aRow.getCountry();
      if ( cntry != null && !addedCountries.contains( cntry.getAreaNameEnglish() ) )
      {
        String color = ":H" + (String)statusColorPair.get(aRow.getStatus().toLowerCase());
        String countryColPair = (cntry.getIso2Wcmc()==null)?cntry.getIso2l():cntry.getIso2Wcmc() + color;
        colorURL.addElement(countryColPair);
        addedCountries.add(  cntry.getAreaNameEnglish() );
        //fix to display in map legend only visible colours
        statuses.addElement( aRow.getStatus() );
      }
    }
    //fix to display in map legend only visible colours
    statusColorPair = ThreatColor.getColorsForMap(statuses);

    int COUNTRIES_PER_MAP = Utilities.checkedStringToInt( application.getInitParameter( "COUNTRIES_PER_MAP" ), 120 );
    if ( addedCountries.size() < COUNTRIES_PER_MAP )
    {
      String proxy = application.getInitParameter("PROXY_URL");
      int port = ro.finsiel.eunis.search.Utilities.checkedStringToInt(application.getInitParameter("PROXY_PORT"),0);
      String extension=application.getInitParameter("EEA_MAP_SERVER_EXTENSION"); //default image type for maps
      String mapserverURL = application.getInitParameter("EEA_MAP_SERVER") + "/getmap.asp";
      String parameters = "mapType=Standard_B&amp;Q=" + colorURL.getElementsSeparatedByComma() + "&amp;outline=1";
      String filename = mapserverURL + "?" + parameters;
%>
    <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("geographical_distribution")%></div>
    <table summary="layout" border="0" cellpadding="3" cellspacing="0" width="100%">
      <tr>
        <td>
<%
      if(colorURL.elements().size() > 0)
      {
%>
          <img alt="<%=cm.cms("map_image_eea")%>" src="<%=filename%>" title="<%=cm.cms("map_image_eea")%>" />
          <%=cm.cmsAlt("map_image_eea")%>
<%
      }
%>
          <br />
          <a title="<%=cm.cms("open_new_window")%>" href="javascript:openLink('<%=mapserverURL + "?" + parameters%>');"><%=cm.cmsText("open_new_window")%></a>
          <%=cm.cmsTitle("open_new_window")%>
        </td>
        <td>
          <%=cm.cmsText("legend")%>:
          <br />
<%
        Enumeration keys = statusColorPair.keys();
        while (keys.hasMoreElements())
        {
          String key = (String)keys.nextElement();
%>
          <img alt="<%=cm.cms("map_image_eea")%>" src="<%=application.getInitParameter("EEA_MAP_SERVER")%>/getLegend.asp?Color=H<%=statusColorPair.get(key)%>" title="<%=cm.cms("map_image_eea")%>" /><%=cm.cmsTitle("map_image_eea")%>&nbsp;<%=key%>
          <br />
<%
        }
%>
        </td>
      </tr>
<%
    }
%>
    </table>
    <br />
    <table summary="<%=cm.cms("geographical_distribution")%>" width="100%" border="1" cellspacing="1" cellpadding="0" id="geographic" class="sortable">
      <tr>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet-geo_04")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("biogeographic_region")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("status")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
         <%=cm.cmsText("reference")%>
         <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
      </tr>
<%
    for (int i = 0; i < v.size(); i++)
    {
      GeographicalStatusWrapper aRow = (GeographicalStatusWrapper)v.get(i);
      String country = (null != aRow.getCountry()) ? aRow.getCountry().getAreaNameEnglish() : "nbsp;";
      String reference = Utilities.getReferencesByIdDc(aRow.getReference());
      Vector authorURL = Utilities.getAuthorAndUrlByIdDc(aRow.getReference());
%>
      <tr style="background-color:<%=( 0 == ( i % 2 ) ) ? "#EEEEEE" : "#FFFFFF"%>">
        <td>
        <%
            if(Utilities.isCountry(country))
            {
        %>
          <a href="javascript:goToCountryStatistics('<%=Utilities.treatURLSpecialCharacters(country)%>')" title="<%=cm.cms("open_the_statistical_data_for")%> <%=Utilities.treatURLSpecialCharacters(country)%>"><%=Utilities.treatURLSpecialCharacters(country)%></a>
          <%=cm.cmsTitle("open_the_statistical_data_for")%>
        <%
            } else {
        %>
             <%=Utilities.treatURLSpecialCharacters(country)%>
        <%
             }
        %>

          &nbsp;
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(aRow.getRegion())%>&nbsp;
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(aRow.getStatus())%>&nbsp;
        </td>
<%
        if ( !( ( String )authorURL.get( 1 ) ).toString().equalsIgnoreCase( "" ) )
        {
%>
        <td width="25%">
          <span onmouseover="return showtooltip('<%=reference%>')" onmouseout="hidetooltip()">
            <span class="boldUnderline">
              <a href="<%=Utilities.treatURLSpecialCharacters((String)authorURL.get( 1 ))%>"><%=Utilities.treatURLSpecialCharacters((String)authorURL.get( 0 ))%></a>
            </span>
          </span>
        </td>
<%
        }
        else
        {
%>
        <td width="25%">
          <span onmouseover="return showtooltip('<%=reference%>')" onmouseout="hidetooltip()">
            <span class="boldUnderline">
            <%=Utilities.treatURLSpecialCharacters((String)authorURL.get( 0 ))%>
            </span>
          </span>
        </td>
<%
        }
%>
      </tr>
<%
    }
%>
    </table>
<%
  }
%>

<%=cm.br()%>
<%=cm.cmsMsg("geographical_distribution")%>

    <br />
    <br />
