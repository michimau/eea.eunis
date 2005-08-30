<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - legal informations.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.factsheet.species.LegalStatusWrapper,
                 java.util.Vector,
                 ro.finsiel.eunis.jrfTables.*,
                 java.util.List,
                 ro.finsiel.eunis.search.UniqueVector,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.WebContentManagement"%>

<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement contentManagement = SessionManager.getWebContent();
  // Request parameters.
  boolean expanded = Utilities.checkedStringToBoolean(request.getParameter("expanded"), false);
  Integer idSpecies = Utilities.checkedStringToInt(request.getParameter("idSpecies"), new Integer(0));
  Integer idSpeciesLink = Utilities.checkedStringToInt(request.getParameter("idSpeciesLink"), new Integer(0));
  String title = request.getParameter("Title");
  String URL = request.getParameter("URL");
  String refs = request.getParameter("refs");
  SpeciesFactsheet factsheet = new SpeciesFactsheet(idSpecies, idSpeciesLink);
  String str="";
  try
  {
    List DC = new Chm62edtDcIndexDomain().findWhere(" REFERENCE IN (" + refs + ")");
    if( DC.size() > 0 )
    {
      for( int i = 0; i < DC.size(); i++ )
      {
        Chm62edtDcIndexPersist dcindex = (Chm62edtDcIndexPersist)DC.get( i );
        if( i == DC.size() - 1 )
        {
          str += dcindex.getIdDc();
        }
        else
        {
          str += dcindex.getIdDc() + ",";
        }
      }
    }
    else
    {
      str = "-1";
    }
    // List of geographical legal information
    List countries = new Chm62edtAreaLegalTextDomain().findWhere(" ID_DC IN (" + str + ")");
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/sort-table.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/header.js"></script>
    <title><%=contentManagement.getContent("species_factsheet-geo-legal_title", false )%> <%=factsheet.getSpeciesObject().getScientificName()%></title>
  </head>
  <body>
    <strong>
      <%=contentManagement.getContent("species_factsheet-geo-legal_01")%>
      <%=Utilities.treatURLSpecialCharacters(factsheet.getSpeciesObject().getScientificName())%>
    </strong>
    <br />
    <br />
<%
    // Map
    UniqueVector countryCodes = new UniqueVector();
    for (int i = 0; i < countries.size(); i++)
    {
      Chm62edtAreaLegalTextPersist countryObj = ( Chm62edtAreaLegalTextPersist )countries.get( i );
      countryCodes.addElement((countryObj.getIso2Wcmc() == null) ? countryObj.getIso2l() : countryObj.getIso2Wcmc());
    }
    String proxy = application.getInitParameter("PROXY_URL");
    int port = ro.finsiel.eunis.search.Utilities.checkedStringToInt(application.getInitParameter("PROXY_PORT"),0);
    String extension=application.getInitParameter("EEA_MAP_SERVER_EXTENSION"); //default image type for maps
    String mapserverURL = application.getInitParameter("EEA_MAP_SERVER") + "/getmap.asp";
    String parameters = "Q=" + countryCodes.getElementsSeparatedByComma() + "&amp;outline=1";
    String filename = mapserverURL + "?" + parameters;
    int COUNTRIES_PER_MAP = Utilities.checkedStringToInt( application.getInitParameter( "COUNTRIES_PER_MAP" ), 120 );
    if ( countryCodes.size() < COUNTRIES_PER_MAP )
    {
%>
    <table summary="layout" width="640" border="1" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <strong>
            <%=contentManagement.getContent("species_factsheet-geo-legal_02")%>:
          </strong>
          &nbsp;
          <%=Utilities.treatURLSpecialCharacters(title)%>
        </td>
      </tr>
      <tr>
        <td>
          <strong>
            <%=contentManagement.getContent("species_factsheet-geo-legal_03")%>:
          </strong>
          &nbsp;
          <a title="URL" href="<%=Utilities.treatURLSpecialCharacters(URL)%>"><%=Utilities.treatURLSpecialCharacters(URL)%></a>
        </td>
      </tr>
      <tr>
        <td>
          <br />
          <img alt="Map image. Provided by EEA" src="<%=filename%>" title="Map image. Provided by EEA" border="0" />
          <p>
            <em>&amp;&quot;<%=contentManagement.getContent("species_factsheet-geo-legal_04")%>.&amp;&quot;</em>
          </p>
        </td>
      </tr>
    </table>
<%
    }
%>
    <br />
    <table summary="List of countries" width="640" border="0" cellspacing="0" cellpadding="0"  id="legalevent">
      <tr style="background-color:#DDDDDD">
        <th class="resultHeader">
          <a title="Sort by Country" href="javascript:sortTable(3, 0, 'legalevent', false);">
          <strong>
            <%=contentManagement.getContent("species_factsheet-geo-legal_05")%>
          </strong>
          </a>
        </th>
        <th class="resultHeader">
          <a title="Sort by Date of event" href="javascript:sortTable(3, 1, 'legalevent', false);">
          <strong>
            <%=contentManagement.getContent("species_factsheet-geo-legal_06")%>
          </strong>
          </a>
        </th>
        <th class="resultHeader">
          <a title="Sort by event" href="javascript:sortTable(3, 2, 'legalevent', false);">
          <strong>
            <%=contentManagement.getContent("species_factsheet-geo-legal_07")%>
          </strong>
          </a>
        </th>
      </tr>
<%
    // Display results.
    if ( !countries.isEmpty() )
    {
      for( int i = 0; i < countries.size(); i++ )
      {
        Chm62edtAreaLegalTextPersist countryObj = (Chm62edtAreaLegalTextPersist)countries.get(i);
%>
        <tr style="background-color:<%=(0 == (i % 2) ? "#FFFFFF" : "#EEEEEE")%>">
          <td>
            <%=Utilities.formatString( Utilities.treatURLSpecialCharacters(countryObj.getAreaNameEn()), "&nbsp;" )%>
          </td>
          <td>
            <%=Utilities.formatString( countryObj.getLegalDate(), "&nbsp;" )%>
          </td>
          <td>
            <%=Utilities.formatString( Utilities.treatURLSpecialCharacters(countryObj.getName()), "&nbsp;" )%>
          </td>
        </tr>
<%
      }
    }
  } catch  (Exception _ex) {
    _ex.printStackTrace();
  }
%>
    </table>
    <p style="text-align:left">
    <label for="button1" class="noshow"><%=contentManagement.getContent("species_factsheet-geo-legal_08", false )%></label>    
      <input id="button1" title="Close window" type="button" value="<%=contentManagement.getContent("species_factsheet-geo-legal_08", false )%>" onclick="javascript:window.close()" name="button" class="inputTextField" />
      <%=contentManagement.writeEditTag( "species_factsheet-geo-legal_08" )%>
    </p>
  </body>
</html>