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
                 ro.finsiel.eunis.search.Utilities,,java.util.Vector,ro.finsiel.eunis.factsheet.species.LegalStatusWrapper"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
	/// Request parameters:
  // idSpecies - ID of species
  // idSpeciesLink - ID of species (Link to species base)
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
  <h2>
    <%=cm.cmsPhrase("Legal Instruments")%>
  </h2>
  <table summary="<%=cm.cms("species_factsheet_legalInstruments_01_Sum")%>" class="listing">
    <thead>
      <tr>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Detailed reference")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("legal text")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Comments")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Url")%>
        </th>
        <th>
          <%=cm.cmsPhrase("Geographical implementation")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
    for (int i = 0; i < legals.size(); i++)
    {
      String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
      LegalStatusWrapper legal = (LegalStatusWrapper)legals.get(i);
%>
      <tr class="<%=cssClass%>">
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
        if(sFormattedURL.length()>50)
        {
          sFormattedURL = sFormattedURL.substring(0,50) + "...";
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
          <%=cm.cmsPhrase("Not applicable. See Bonn Agreement or Memorandum.")%>
<%
      }
%>
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
<%=cm.cmsMsg("species_factsheet_legalInstruments_01_Sum")%>

<br />
<br />
