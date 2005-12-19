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
                 ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector,
                 ro.finsiel.eunis.factsheet.species.LegalStatusWrapper"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// Request parameters:
  // idSpecies - ID of specie
  // idSpeciesLink - ID of specie (Link to species base)
  String idSpecies = request.getParameter("idSpecies");
  String idSpeciesLink = request.getParameter("idSpeciesLink");
  SpeciesFactsheet factsheet = new SpeciesFactsheet(Utilities.checkedStringToInt(idSpecies, new Integer(0)),
          Utilities.checkedStringToInt(idSpeciesLink, new Integer(0)));
  WebContentManagement cm = SessionManager.getWebContent();

  // Species legal instruments
  Vector legals = factsheet.getLegalStatus();
  if (legals.size() > 0)
  {
%>
    <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("species_factsheet_legalInstruments")%></div>
    <table summary="<%=cm.cms("species_factsheet_legalInstruments_01_Sum")%>" width="100%" border="1" cellspacing="1" cellpadding="0"  id="legalInstr" class="sortable">
      <tr style="background-color:#DDDDDD">
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <strong>
            <%=cm.cmsText("species_factsheet_legalInstrumentsDetailedRef")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </strong>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <strong>
            <%=cm.cmsText("species_factsheet_legalInstrumentsText")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </strong>
        </th>
        <th style="text-align:left" title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet_legalInstruments_02")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet_legalInstrumentsURL")%>
        </th>
        <th style="text-align:center" title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet_legalInstrumentsGeoImplem")%>
        </th>
        <th style="text-align:center" title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet_legalInstrumentsObligations")%>
        </th>
      </tr>
<%
  for (int i = 0; i < legals.size(); i++)
  {
    LegalStatusWrapper legal = (LegalStatusWrapper)legals.get(i);
%>
<%--          <tr bgcolor="<%=(0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE"%>">--%>
      <tr style="background-color:<%=(0 == (i % 2)) ? "#EEEEEE" : "#EEEEEE"%>">
        <td>
          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(legal.getDetailedReference()))%>
        </td>
        <td>
          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(legal.getLegalText()))%>
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(legal.getComments())%>
        </td>
        <td>
<%
              if(null != legal.getUrl().replaceAll("#",""))
              {
                String sFormattedURL = Utilities.formatString(legal.getUrl()).replaceAll("#","");
                if(sFormattedURL.length()>30) {
                  sFormattedURL = sFormattedURL.substring(0,30) + "...";
                }
%>
              <a href="<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(legal.getUrl())).replaceAll("#","")%>" title="<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(legal.getUrl())).replaceAll("#","")%>"><%=sFormattedURL%></a>
<%
              }
%>
                      &nbsp;
            </td>
            <td align="center">
<%
              if(!legal.getReference().equalsIgnoreCase("10333"))
              {
%>
              <a title="<%=cm.cms("species_factsheet_legalInstruments_03_Title")%>" href="javascript:MM_openBrWindow('species-factsheet-geo-legal.jsp?country=<%=Utilities.treatURLSpecialCharacters(legal.getArea())%>&amp;idSpecies=<%=factsheet.getIdSpecies()%>&amp;idSpeciesLink=<%=factsheet.getIdSpeciesLink()%>&amp;URL=<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(legal.getUrl())).replaceAll("#","")%>&amp;Title=<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(legal.getLegalText()))%>&amp;refs=<%=Utilities.treatURLSpecialCharacters(legal.getReference())%>&amp;mapnumber=<%=i%>','','scrollbars=yes,resizable=yes,width=760,height=480')"><img alt="<%=cm.cms("species_factsheet_legalInstruments_03_Title")%>" src="images/mini/globe.gif" border="0" /></a>
              <%=cm.cmsTitle("species_factsheet_legalInstruments_03_Title")%>
<%
              }
              else
              {
%>
              <%=cm.cmsText("species_factsheet_notApplicable")%>
<%
              }
%>
        </td>
        <td align="center">
          <a title="<%=cm.cms("species_factsheet_legalInstruments_04_Title")%>" target="_blank" href="http://rod.eionet.eu.int/rorabrowse.jsv?mode=A&amp;country=-1&amp;GO=GO&amp;env_issue=-1&amp;client=-1"><img alt="<%=cm.cms("species_factsheet_legalInstruments_04_Title")%>" src="images/eea.jpg" border="0" /></a>
          <%=cm.cmsTitle("species_factsheet_legalInstruments_04_Title")%>
        </td>
      </tr>
<%
            }
%>
        </table>
<%
  }
%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet_legalInstruments_01_Sum")%>

<br />
<br />