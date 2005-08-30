<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - trends.
--%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.factsheet.species.FactSheetTrendsWrapper,
                 ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<%// Get form parameters here%>
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
    <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">Trends</div>
    <table summary="Trends" width="100%" border="1" cellspacing="1" cellpadding="0" id="trends" style="border-collapse:collapse">
      <tr style="background-color:#DDDDDD">
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Country" href="javascript:sortTable(8,0, 'trends', false);"><%=cm.getContent("species_factsheet-trends_02")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Biogeographic region" href="javascript:sortTable(8,1, 'trends', false);"><%=cm.getContent("species_factsheet-trends_03")%></a>
        </th>
        <th class="resultHeaderForFactsheet" style="text-align:right">
          <a title="Sort by Start period" href="javascript:sortTable(8,2, 'trends', false);"><%=cm.getContent("species_factsheet-trends_04")%></a>
        </th>
        <th class="resultHeaderForFactsheet" style="text-align:right">
          <a title="Sort by End period" href="javascript:sortTable(8,3, 'trends', false);"><%=cm.getContent("species_factsheet-trends_05")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Status" href="javascript:sortTable(8,4, 'trends', false);"><%=cm.getContent("species_factsheet-trends_06")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Tendance" href="javascript:sortTable(8,5, 'trends', false);"><%=cm.getContent("species_factsheet-trends_07")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Quality" href="javascript:sortTable(8,6, 'trends', false);"><%=cm.getContent("species_factsheet-trends_08")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Reference" href="javascript:sortTable(8,7, 'trends', false);"><%=cm.getContent("species_factsheet-trends_09")%></a>
        </th>
      </tr>
<%
      for (int i = 0; i < list.size(); i++)
      {
        FactSheetTrendsWrapper aRow = (FactSheetTrendsWrapper)list.get(i);
%>
      <tr style="background-color:<%=(0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE"%>">
        <td width="81">
          <%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%>
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
<br />
<br />