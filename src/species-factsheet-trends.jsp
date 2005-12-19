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
  String idNatureObj = FormBean.getIdNatureObject();
  // List of trends information for species.
  Vector list = SpeciesFactsheet.getTrends(idNatureObj);
  if ( list.size() > 0 )
  {
  %>
    <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("species_factsheet-trends_12")%></div>
    <table summary="<%=cm.cms("species_factsheet-trends_12_Sum")%>" width="100%" border="1" cellspacing="1" cellpadding="0" id="trends" class="sortable">
      <tr>
        <th title="<%=cm.cms("sort_results_on_this_column")%>" >
          <%=cm.cmsText("species_factsheet-trends_02")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>" >
          <%=cm.cmsText("species_factsheet-trends_03")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align:right" title="<%=cm.cms("sort_results_on_this_column")%>" >
          <%=cm.cmsText("species_factsheet-trends_04")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th style="text-align:right" title="<%=cm.cms("sort_results_on_this_column")%>" >
          <%=cm.cmsText("species_factsheet-trends_05")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>" >
          <%=cm.cmsText("species_factsheet-trends_06")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>" >
          <%=cm.cmsText("species_factsheet-trends_07")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>" >
          <%=cm.cmsText("species_factsheet-trends_08")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>" >
          <%=cm.cmsText("species_factsheet-trends_09")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
      </tr>
<%
      for (int i = 0; i < list.size(); i++)
      {
        FactSheetTrendsWrapper aRow = (FactSheetTrendsWrapper)list.get(i);
%>
      <tr style="background-color:<%=(0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE"%>">
        <td width="81">
        <%
            if(Utilities.isCountry(aRow.getCountry()))
            {
        %>
          <a href="javascript:goToSpeciesStatistics('<%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%>')" title="<%=cm.cms("open_statistical_data")%> <%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%>"><%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%></a>
          <%=cm.cmsTitle("open_statistical_data")%>
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
    </table>
<%
  }
%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet-trends_12_Sum")%>
<br />
<br />