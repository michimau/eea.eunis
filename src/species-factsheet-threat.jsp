<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species factsheet' - Display national threat status.
--%>
<%@page contentType="text/html"%>
<%@page import="java.util.*,
                 ro.finsiel.eunis.jrfTables.*,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.UniqueVector,
                 ro.finsiel.eunis.factsheet.species.ThreatColor,
                 java.net.URL,
                 java.net.HttpURLConnection,
                 java.io.*,
                 ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.factsheet.species.NationalThreatWrapper,
                ro.finsiel.eunis.WebContentManagement"%>
  <jsp:useBean id="FormBean" class="ro.finsiel.eunis.formBeans.SpeciesFactSheetBean" scope="page">
    <jsp:setProperty name="FormBean" property="*"/>
  </jsp:useBean>
  <jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
    WebContentManagement contentManagement = SessionManager.getWebContent();

    Integer idSpecies=Utilities.checkedStringToInt( request.getParameter("idSpecies"), new Integer("-1") );
    SpeciesFactsheet factsheet = new SpeciesFactsheet( idSpecies, idSpecies );
    String scientificName = factsheet.getSpeciesObject().getScientificName();

    // National threat status
    List nationalThreatStatus = factsheet.getNationalThreatStatus( factsheet.getSpeciesObject() );

    // List of species international threat status.
    List consStatus = factsheet.getConservationStatus(factsheet.getSpeciesObject());

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
    <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">National threat status</div>
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
      <table summary="layout" border="0" cellpadding="3" cellspacing="0" width="100%">
        <tr>
          <td>
<%
          if(filename.length() > 0)
          {
%>
            <img alt="Map image. Provided by EEA" src="<%=filename%>" title="Map image. Provided by EEA" />
            <br />
            <a title="Open map in new window" href="javascript:openNewPage('<%=url + "?" + parameters%>');">Open map in new window</a>
<%
          }
          else
          {
%>
            <%=contentManagement.getContent("species_factsheet-threat_02")%>.
<%
          }
%>
          </td>
          <td style="padding-left : 20px;">
            Legend:
            <br />
<%
          Enumeration keys = threatsColors.keys();
          while ( keys.hasMoreElements() )
          {
            String key = ( String )keys.nextElement();
%>
            <img alt="Map legend. Provided by EEA" src="<%=application.getInitParameter("EEA_MAP_SERVER")%>/getLegend.asp?Color=H<%=threatsColors.get(key)%>" title="Map legend. Provided by EEA" />&nbsp;<%=key%>
            <br />
<%
          }
%>
            <p>
              <%=contentManagement.getContent("species_factsheet-threat_03")%>
            </p>
          </td>
        </tr>
      </table>
<%
    }
%>
      <table summary="National threat status" width="100%" border="1" cellspacing="1" cellpadding="0"  id="threat" style="border-collapse:collapse">
        <tr>
          <th class="resultHeaderForFactsheet" style="width : 220px;">
            <strong>
              <a title="Sort by Country" href="javascript:sortTable(4,0, 'threat', false);"><%=contentManagement.getContent("species_factsheet-threat_04")%></a>
            </strong>
          </th>
          <th class="resultHeaderForFactsheet" style="width : 120px;">
            <strong>
              <a title="Sort by Status" href="javascript:sortTable(4,1, 'threat', false);"><%=contentManagement.getContent("species_factsheet-threat_05")%></a>
            </strong>
          </th>
          <th class="resultHeaderForFactsheet" style="width : 100px;">
            <strong>
              <a title="Sort by National threat code" href="javascript:sortTable(4,2, 'threat', false);"><%=contentManagement.getContent("species_factsheet-threat_06")%></a>
            </strong>
          </th>
          <th class="resultHeaderForFactsheet">
            <strong>
              <a title="Sort by Reference" href="javascript:sortTable(4,3, 'threat', false);"><%=contentManagement.getContent("species_factsheet-threat_07")%></a>
            </strong>
          </th>
        </tr>
<%
  for (int i = 0; i < nationalThreatStatus.size(); i++)
  {
    NationalThreatWrapper threat = (NationalThreatWrapper)nationalThreatStatus.get(i);
%>
        <tr style="background-color:<%=((0 == i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
              <a href="sites-statistical-result.jsp?country=<%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>&amp;DB_CDDA_NATIONAL=true&amp;DB_DIPLOMA=true&amp;DB_CDDA_INTERNATIONAL=true&amp;DB_CORINE=true&amp;DB_BIOGENETIC=true" title="Open the statistical data for <%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>"><%=Utilities.treatURLSpecialCharacters(threat.getCountry())%></a>
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
            <%=Utilities.treatURLSpecialCharacters(threat.getReference())%>
          </td>
        </tr>
        <%
          }
        %>
      </table>
<%
    }

    // International threat status
    if( consStatus.size() > 0 )
    {
%>
      <br />
      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">International threat status</div>
      <table summary="International threat status" width="100%" border="1" cellspacing="1" cellpadding="0"  id="intlthreat" style="border-collapse:collapse">
        <tr>
          <th class="resultHeaderForFactsheet">
            <strong>
              <a title="Sort by Area" href="javascript:sortTable(4,0, 'intlthreat', false);"><%=contentManagement.getContent("species_factsheet-conservation_08")%></a>
            </strong>
          </th>
          <th class="resultHeaderForFactsheet">
            <strong>
              <a title="Sort by Status" href="javascript:sortTable(4,1, 'intlthreat', false);"><%=contentManagement.getContent("species_factsheet-conservation_03")%></a>
            </strong>
          </th>
          <th class="resultHeaderForFactsheet">
            <strong>
              <a title="Sort by International threat code" href="javascript:sortTable(4,2, 'intlthreat', false);"><%=contentManagement.getContent("species_factsheet-conservation_09")%></a>
            </strong>
          </th>
          <th class="resultHeaderForFactsheet">
            <strong>
              <a title="Sort by Reference" href="javascript:sortTable(4,3, 'intlthreat', false);"><%=contentManagement.getContent("species_factsheet-conservation_05")%></a>
            </strong>
          </th>
        </tr>
<%
       // Display results.
      for (int i = 0; i < consStatus.size(); i++)
      {
        NationalThreatWrapper threat = (NationalThreatWrapper)consStatus.get(i);
%>
        <tr style="background-color:<%=((0 == i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
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
            <%=Utilities.treatURLSpecialCharacters(threat.getReference())%>
          </td>
        </tr>
<%
          }
%>
      </table>
<%
    }
%>
<br />
<br />