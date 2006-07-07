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
    <%=cm.cmsText("trends")%>
  </h2>
  <table summary="<%=cm.cms("trends")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th>
          <%=cm.cmsText("country")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("biogeographic_region")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align:right">
          <%=cm.cmsText("start_period")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align:right">
          <%=cm.cmsText("end_period")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("status")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("species_factsheet-trends_07")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("quality")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("reference")%>
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
        <td width="81">
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
        <td width="81">
          <%=Utilities.treatURLSpecialCharacters(aRow.getBioregion())%>
        </td>
        <td width="43" style="text-align:right">
          <%=aRow.getStartPeriod()%>&nbsp;
        </td>
        <td width="39" style="text-align:right">
          <%=aRow.getEndPeriod()%>&nbsp;
        </td>
        <td width="46">
          <%=Utilities.treatURLSpecialCharacters(aRow.getStatus())%>&nbsp;
        </td>
        <td width="88">
          <%=Utilities.treatURLSpecialCharacters(aRow.getTrends())%>&nbsp;
        </td>
        <td width="204">
          <%=Utilities.treatURLSpecialCharacters(aRow.getQuality())%>&nbsp;
        </td>
<%
        if (!Utilities.getAuthorAndUrlByIdDc(aRow.getReference()).get(1).toString().equalsIgnoreCase(""))
        {
%>
        <td width="25%" style="text-align:left" onmouseover="return showtooltip('<%=Utilities.getReferencesByIdDc(aRow.getReference())%>')" onmouseout="hidetooltip()">
          <span class="boldUnderline">
            <a href="<%=Utilities.treatURLSpecialCharacters((String)Utilities.getAuthorAndUrlByIdDc(aRow.getReference()).get(1))%>"><%=Utilities.treatURLSpecialCharacters((String)Utilities.getAuthorAndUrlByIdDc(aRow.getReference()).get(0))%></a>
          </span>
        </td>
<%
        }
        else
        {
%>
        <td width="25%" style="text-align:left" onmouseover="return showtooltip('<%=Utilities.getReferencesByIdDc(aRow.getReference())%>')" onmouseout="hidetooltip()">
          <span class="boldUnderline">
            <%=Utilities.treatURLSpecialCharacters((String)Utilities.getAuthorAndUrlByIdDc(aRow.getReference()).get(0))%>
          </span>
        </td>
<%
        }
%>

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