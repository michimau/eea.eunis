<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - populations.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
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
  <h2>
    <%=cm.cmsText("population")%>
  </h2>
  <table summary="<%=cm.cms("species_factsheet-pop_12_Sum")%>" class="listing" width="90%">
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
        <th>
          <span style="color:#006CAD">
            <%=cm.cmsText("min_max")%>
          </span>
        </th>
        <th>
          <%=cm.cmsText("date")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsText("status")%>
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
      String reference;
      Vector authorURL;
      for (int i = 0; i < list.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
        FactSheetPopulationWrapper aRow = (FactSheetPopulationWrapper)list.get(i);
        reference = Utilities.getReferencesByIdDc( aRow.getReference() );
        authorURL = Utilities.getAuthorAndUrlByIdDc( aRow.getReference() );
%>
      <tr<%=cssClass%>>
        <td>
<%
        if(Utilities.isCountry(aRow.getCountry()))
        {
%>
          <a href="javascript:goToSpeciesStatistics('<%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%>')"
             title="<%=cm.cms("open_the_statistical_data_for")%> <%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%>"><%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%></a>
          <%=cm.cmsTitle("open_the_statistical_data_for")%>
<%
        }
        else
        {
%>
         <%=Utilities.treatURLSpecialCharacters(aRow.getCountry())%>
<%
        }
%>
          &nbsp;
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
    </tbody>
  </table>
<%
  }
%>

<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet-pop_12_Sum")%>

<br />
<br />
