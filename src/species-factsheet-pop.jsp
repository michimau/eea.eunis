<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - populations.
--%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.factsheet.species.FactSheetPopulationWrapper,
                 ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<%// Get form parameters here%>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.formBeans.SpeciesFactSheetBean" scope="page">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String idNatureObj = FormBean.getIdNatureObject();
  // List of population information for species
  Vector list = SpeciesFactsheet.getPopulation(idNatureObj);
  if (list.size() > 0)
  {
%>
    <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">Population</div>
    <table summary="List of populations" width="100%" border="1" cellspacing="1" cellpadding="0" id="populations" style="border-collapse:collapse">
      <tr style="background-color:#DDDDDD">
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Country" href="javascript:sortTable(6,0, 'populations', false);"><%=cm.getContent("species_factsheet-pop_02")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Biogeographic region" href="javascript:sortTable(6,1, 'populations', false);"><%=cm.getContent("species_factsheet-pop_03")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <span style="color:#006CAD">  
          <%=cm.getContent("species_factsheet-pop_04")%>
          </span>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Date" href="javascript:sortTable(6,2, 'populations', false);"><%=cm.getContent("species_factsheet-pop_05")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Status" href="javascript:sortTable(6,3, 'populations', false);"><%=cm.getContent("species_factsheet-pop_06")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Quality" href="javascript:sortTable(6,4, 'populations', false);"><%=cm.getContent("species_factsheet-pop_07")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Reference" href="javascript:sortTable(6,5, 'populations', false);"><%=cm.getContent("species_factsheet-pop_08")%></a>
        </th>
      </tr>
<%
      String bgColor;
      String reference;
      Vector authorURL;
      for (int i = 0; i < list.size(); i++)
      {
        FactSheetPopulationWrapper aRow = (FactSheetPopulationWrapper)list.get(i);
        bgColor = ( 0 == ( i % 2 ) ? "#EEEEEE" : "#FFFFFF" );
        reference = Utilities.getReferencesByIdDc( aRow.getReference() );
        authorURL = Utilities.getAuthorAndUrlByIdDc( aRow.getReference() );
%>
      <tr style="background-color:<%=bgColor%>">
        <td>
            <%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%>&nbsp;
          </td>
          <td>
            <%=Utilities.treatURLSpecialCharacters(aRow.getBioregion())%>&nbsp;
          </td>
          <td>
            <%=aRow.getMin()%>/<%=aRow.getMax()%>(<%=aRow.getUnits()%>)&nbsp;
          </td>
          <td>
            <%=aRow.getDate()%>&nbsp;
          </td>
          <td>
            <%=Utilities.treatURLSpecialCharacters(aRow.getStatus())%>&nbsp;
          </td>
          <td>
            <%=Utilities.treatURLSpecialCharacters(aRow.getQuality())%>&nbsp;
          </td>
<%
          if (!authorURL.get(1).toString().equalsIgnoreCase(""))
          {
%>
          <td width="25%" style="text-align:left">
            <span onmouseover="return showtooltip('<%=reference%>')" onmouseout="hidetooltip()">
              <span class="boldUnderline">
                <a href="<%=Utilities.treatURLSpecialCharacters((String)authorURL.get(1))%>"><%=Utilities.treatURLSpecialCharacters((String)authorURL.get(0))%></a>
              </span>
            </span>
          </td>
<%
          }
          else
          {
%>
          <td width="25%" style="text-align:left">
            <span onmouseover="return showtooltip('<%=reference%>')" onmouseout="hidetooltip()">
            <span class="boldUnderline">
              <%=Utilities.treatURLSpecialCharacters((String)authorURL.get(0))%>
            </span>
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