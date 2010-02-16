<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species factsheet' - Display national threat status.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.*,
                 ro.finsiel.eunis.jrfTables.*,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.UniqueVector,
                 ro.finsiel.eunis.factsheet.species.ThreatColor,
                 ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.factsheet.species.NationalThreatWrapper,
                ro.finsiel.eunis.WebContentManagement"%>
  <jsp:useBean id="FormBean" class="ro.finsiel.eunis.formBeans.SpeciesFactSheetBean" scope="page">
    <jsp:setProperty name="FormBean" property="*"/>
  </jsp:useBean>
  <jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();

  Integer idSpecies=Utilities.checkedStringToInt( request.getParameter("idSpecies"), new Integer("-1") );
  SpeciesFactsheet factsheet = new SpeciesFactsheet( idSpecies, idSpecies );
  //String scientificName = factsheet.getSpeciesObject().getScientificName();

  // National threat status
  List nationalThreatStatus = new ArrayList();
  try
  {
    nationalThreatStatus = factsheet.getNationalThreatStatus( factsheet.getSpeciesObject() );
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }

  // List of species international threat status.
  List consStatus = new ArrayList();
  try
  {
    consStatus = factsheet.getConservationStatus(factsheet.getSpeciesObject());
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }

  for ( int i = 0; i < nationalThreatStatus.size(); i++ )
  {
    NationalThreatWrapper threat = ( NationalThreatWrapper )nationalThreatStatus.get(i);
    Chm62edtCountryPersist country = new Chm62edtCountryPersist();
    country.setAreaNameEnglish(threat.getCountry());
    country.setIso2l(threat.getIso2L());
  }
  if( nationalThreatStatus.size() > 0 )
  {
%>
  <h2>
    <%=cm.cmsPhrase("National threat status")%>
  </h2>
<%
    int COUNTRIES_PER_MAP = Utilities.checkedStringToInt( application.getInitParameter( "COUNTRIES_PER_MAP" ), 120 );
    // Mapping THREAT STATUS - COLOR
    Hashtable threatsColors;
    List threats = SpeciesSearchUtility.processThreats(nationalThreatStatus);
    // Fill the THREAT STATUS - COLOR mappings
    UniqueVector v = new UniqueVector();
    for (int i  = 0; i < threats.size(); i++)
    {
      NationalThreatWrapper tw = (NationalThreatWrapper)threats.get(i);
      v.addElement(tw.getStatus());
    }
    threatsColors = ThreatColor.getColorsForMap(v);

    //fix to display in map legend only visible colours
    v.clear();

    String mapURL = "";
    // Prepare the URL string for the map server (pairs of 'country_code:color')
    Vector addedThreats = new Vector();

    for (int i = 0; i < threats.size(); i++)
    {
      NationalThreatWrapper tw = (NationalThreatWrapper)threats.get(i);
      String code = tw.getIso2L();
      if ( !addedThreats.contains( tw.getCountry() ) )
      {
        if (null != code && !code.equalsIgnoreCase(""))
        {
          addedThreats.add( tw.getCountry() );
          String color = (String)threatsColors.get(tw.getStatus().toLowerCase());
          mapURL += code + ":H" + color;
          if (i < (threats.size() - 1)) mapURL += ",";
        }
        //fix to display in map legend only visible colours
        v.addElement( tw.getStatus() );
      }
    }

    //fix to display in map legend only visible colours
    threatsColors = ThreatColor.getColorsForMap(v);

    if ( addedThreats.size() < COUNTRIES_PER_MAP )
    {
      // Do the map request
      String extension=application.getInitParameter("EEA_MAP_SERVER_EXTENSION"); //default image type for maps
      String url = application.getInitParameter("EEA_MAP_SERVER") + "/getmap.asp";
      String parameters = "mapType=Standard_B&amp;Q=" + mapURL + "&amp;outline=1";
      String proxy = application.getInitParameter("PROXY_URL");
      int port = ro.finsiel.eunis.search.Utilities.checkedStringToInt(application.getInitParameter("PROXY_PORT"),0);
      String filename = url + "?" + parameters;
%>
  <table summary="layout" border="0" cellpadding="3" cellspacing="0" width="90%">
    <tr>
      <td>
<%
          if(filename.length() > 0)
          {
%>
        <img alt="<%=cm.cms("map_image_eea")%>" src="<%=filename%>" title="<%=cm.cms("map_image_eea")%>" />
        <%=cm.cmsAlt("map_image_eea")%>
        <br />
        <a title="<%=cm.cms("open_new_window")%>" href="javascript:openNewPage('<%=url + "?" + parameters%>');"><%=cm.cmsPhrase("Open map in new window")%></a>
        <%=cm.cmsTitle("open_new_window")%>
<%
          }
          else
          {
%>
        <%=cm.cmsPhrase("Image not available")%>.
<%
          }
%>
      </td>
      <td style="padding-left : 20px;">
        <%=cm.cmsPhrase("Legend")%>:
        <br />
<%
          Enumeration keys = threatsColors.keys();
          while ( keys.hasMoreElements() )
          {
            String key = ( String )keys.nextElement();
%>
        <img alt="<%=cm.cms("map_legend_eea")%>" src="<%=application.getInitParameter("EEA_MAP_SERVER")%>/getLegend.asp?Color=H<%=threatsColors.get(key)%>" title="<%=cm.cms("map_legend_eea")%>" /><%=cm.cmsAlt("map_legend_eea")%>&nbsp;<%=key%>
        <br />
<%
          }
%>
        <p>
          <%=cm.cmsPhrase("Map legend is based on the most recent information available,<br />additional older information is shown in table only.")%>
        </p>
      </td>
    </tr>
  </table>
<%
    }
%>
  <table summary="<%=cm.cms("national_threat_status")%>" class="listing" width="90%">
    <col style="width : 220px;"/>
    <col style="width : 120px;"/>
    <col style="width : 100px;"/>
    <col />
    <thead>
      <tr>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Country")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Status")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("National threat code")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Reference")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
  for (int i = 0; i < nationalThreatStatus.size(); i++)
  {
    String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
    NationalThreatWrapper threat = (NationalThreatWrapper)nationalThreatStatus.get(i);
%>
      <tr class="<%=cssClass%>">
        <td>
<%
    if(Utilities.isCountry(threat.getCountry()))
    {
%>
          <a href="javascript:goToCountryStatistics('<%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>')" title="<%=cm.cms("open_the_statistical_data_for")%> <%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>"><%=Utilities.treatURLSpecialCharacters(threat.getCountry())%></a>
          <%=cm.cmsTitle("open_the_statistical_data_for")%>
<%
    }
    else
    {
%>
         <%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>
<%
    }
%>
          &nbsp;
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(threat.getStatus())%>
        </td>
        <td>
          <span class="boldUnderline" title="<%=factsheet.getConservationStatusDescriptionByCode(threat.getThreatCode()).replaceAll("'"," ").replaceAll("\""," ")%>">
            <%=threat.getThreatCode()%>
          </span>
        </td>
        <td>
          <a href="documents/<%=threat.getIdDc()%>"><%=Utilities.treatURLSpecialCharacters(threat.getReference())%></a>
        </td>
      </tr>
        <%
          }
        %>
    </tbody>
  </table>
<%
    }

    // International threat status
    if( consStatus.size() > 0 )
    {
%>
  <br />
  <h2>
    <%=cm.cmsPhrase("International Threat Status")%>
  </h2>
  <table summary="<%=cm.cms("international_threat_status")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Area")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Status")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("International threat code")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Reference")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
       // Display results.
      for (int i = 0; i < consStatus.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
        NationalThreatWrapper threat = (NationalThreatWrapper)consStatus.get(i);
%>
      <tr class="<%=cssClass%>">
        <td>
          <%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(threat.getStatus())%>
        </td>
        <td>
        <span class="boldUnderline" title="<%=factsheet.getConservationStatusDescriptionByCode(threat.getThreatCode()).replaceAll("'"," ").replaceAll("\""," ")%>">
          <%=threat.getThreatCode()%>
        </span>
        </td>
        <td>
          <a href="documents/<%=threat.getIdDc()%>"><%=Utilities.treatURLSpecialCharacters(threat.getReference())%></a>
        </td>
      </tr>
<%
          }
%>
    </tbody>
  </table>
<%
    }
%>
  <%=cm.br()%>
  <%=cm.cmsMsg("national_threat_status")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("international_threat_status")%>
  <br />
  <br />
