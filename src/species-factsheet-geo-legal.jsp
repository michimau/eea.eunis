<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - legal informations.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.jrfTables.*,
                 java.util.List,
                 ro.finsiel.eunis.search.UniqueVector,
                 ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
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
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <script language="JavaScript" type="text/javascript" src="script/header.js"></script>
    <title><%=cm.cms("geographical_legal_information")%> <%=factsheet.getSpeciesObject().getScientificName()%></title>
  </head>
  <body>
    <strong>
      <%=cm.cmsText("geographical_legal_information")%>
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
            <%=cm.cmsText("title")%>:
          </strong>
          &nbsp;
          <%=Utilities.treatURLSpecialCharacters(title)%>
        </td>
      </tr>
      <tr>
        <td>
          <strong>
            <%=cm.cmsText("url")%>:
          </strong>
          &nbsp;
          <a title="<%=cm.cms("url")%>" href="<%=Utilities.treatURLSpecialCharacters(URL)%>"><%=Utilities.treatURLSpecialCharacters(URL)%></a>
          <%=cm.cmsTitle("url")%>
        </td>
      </tr>
      <tr>
        <td>
          <br />
          <img alt="<%=cm.cms("map_image_eea")%>" src="<%=filename%>" title="<%=cm.cms("map_image_eea")%>" border="0" />
          <%=cm.cmsTitle("map_image_eea")%>
          <p>
            <em>&quot;<%=cm.cmsText("species_factsheet-geo-legal_04")%>.&quot;</em>
          </p>
        </td>
      </tr>
    </table>
<%
    }
%>
    <br />
    <table summary="<%=cm.cms("species_factsheet-geo-legal_11_Sum")%>" width="640" border="0" cellspacing="0" cellpadding="0" id="legalevent" class="sortable">
      <tr>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <strong>
            <%=cm.cmsText("country")%>
          </strong>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <strong>
            <%=cm.cmsText("species_factsheet-geo-legal_06")%>
          </strong>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <strong>
            <%=cm.cmsText("species_factsheet-geo-legal_07")%>
          </strong>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
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
  WebContentManagement cm = SessionManager.getWebContent();
%>
    </table>
    <p style="text-align:left">
      <input id="button1" title="<%=cm.cms("close_window")%>" type="button" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" name="button" class="standardButton" />
      <%=cm.cmsTitle("close_window")%>
      <%=cm.cmsInput("close_btn")%>
    </p>

<%=cm.br()%>
<%=cm.cmsMsg("geographical_legal_information")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet-geo-legal_11_Sum")%>
<%=cm.br()%>

  </body>
</html>