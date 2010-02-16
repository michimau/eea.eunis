<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - trends.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.factsheet.species.FactSheetTrendsWrapper,
                 ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.formBeans.SpeciesFactSheetBean" scope="page">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  // List of trends information for species.
  Integer idNatureObject = new Integer( Utilities.checkedStringToInt( FormBean.getIdNatureObject(), 0 ) );
  Integer idSpecies = new Integer( Utilities.checkedStringToInt( FormBean.getIdSpecies(), 0 ) );
  Vector list = SpeciesFactsheet.getTrends(idNatureObject, idSpecies );
  if ( list.size() > 0 )
  {
  %>
  <h2>
    <%=cm.cmsPhrase("Trends")%>
  </h2>
  <table summary="<%=cm.cms("trends")%>" class="listing" width="100%">
<!--
    <col style="width:81px;"/>
    <col style="width:81px;"/>
    <col style="width:43px;"/>
    <col style="width:39px;"/>
    <col style="width:46px;"/>
    <col style="width:88px;"/>
    <col style="width:204px;"/>
    <col style="width:25%;"/>
-->
    <thead>
      <tr>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Country")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Biogeographic region")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align:right;">
          <%=cm.cmsPhrase("Start Period")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align:right;">
          <%=cm.cmsPhrase("End period")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Status")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Tendency")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Quality")%>
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
      for (int i = 0; i < list.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
        FactSheetTrendsWrapper aRow = (FactSheetTrendsWrapper)list.get(i);
%>
      <tr<%=cssClass%>>
        <td>
        <%
            if(Utilities.isCountry(aRow.getCountry()))
            {
        %>
          <a href="javascript:goToSpeciesStatistics('<%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%>')" title="<%=cm.cms("open_the_statistical_data_for")%> <%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%>"><%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%></a>
          <%=cm.cmsTitle("open_the_statistical_data_for")%>
        <%
            } else {
        %>
             <%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%>
        <%
             }
        %>
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(aRow.getBioregion())%>
        </td>
        <td style="text-align:right">
          <%=aRow.getStartPeriod()%>&nbsp;
        </td>
        <td style="text-align:right">
          <%=aRow.getEndPeriod()%>&nbsp;
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(aRow.getStatus())%>&nbsp;
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(aRow.getTrends())%>&nbsp;
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(aRow.getQuality())%>&nbsp;
        </td>
        <td>
            <a href="documents/<%=aRow.getReference()%>"><%=Utilities.treatURLSpecialCharacters((String)Utilities.getAuthorAndUrlByIdDc(aRow.getReference()).get(0))%></a>
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
<%=cm.cmsMsg("trends")%>
<br />
<br />
