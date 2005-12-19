<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - vernacular names.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtReportsPersist,java.util.*,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.factsheet.species.SpeciesFactsheet"%>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.formBeans.SpeciesFactSheetBean" scope="page">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  Integer idNatureObject = Utilities.checkedStringToInt( request.getParameter( "idNatureObject" ), new Integer( 0 ) );
  // List of vernacular names for a given species
  List results = SpeciesSearchUtility.findVernacularNames( idNatureObject );
  Iterator it = results.iterator();
  if ( !results.isEmpty() )
  {
%>
    <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("species_factsheet-vern_08")%></div>
    <table summary="<%=cm.cms("species_factsheet-vern_08_Sum")%>" width="100%" border="1" cellspacing="1" cellpadding="0"  id="vernNames" class="sortable">
      <tr>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet-vern_02")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet-vern_03")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet-vern_04")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
      </tr>
<%
    int i = 0;
    String bgColor;
    while (it.hasNext())
    {
      bgColor  = ( 0 == ( i++ % 2 ) ) ? "#FFFFFF" : "#EEEEEE";
      VernacularNameWrapper vName = ( ( VernacularNameWrapper ) it.next() );
      String reference = ( vName.getIdDc() == null ? "-1" : vName.getIdDc().toString() );
%>
      <tr style="background-color:<%=bgColor%>">
        <td>
          <%=Utilities.treatURLSpecialCharacters(vName.getName())%>
        </td>
        <td>
          <%=vName.getLanguage()%>
        </td>
<%
        String ref = Utilities.getReferencesByIdDc( reference );
        Vector authorURL = Utilities.getAuthorAndUrlByIdDc( reference );
        if ( !( ( String )authorURL.get( 1 ) ).equalsIgnoreCase( "" ) )
        {
%>
        <td>
          <span onmouseover="return showtooltip('<%=ref%>')" onmouseout="hidetooltip()">
            <span class="boldUnderline">
              <a href="<%=Utilities.treatURLSpecialCharacters((String)authorURL.get( 1 ))%>"><%=Utilities.treatURLSpecialCharacters((String)authorURL.get( 0 ))%></a>
            </span>
          </span>
        </td>
<%
        }
        else
        {
%>
        <td style="text-align:left">
          <span onmouseover="return showtooltip('<%=ref%>')" onmouseout="hidetooltip()">
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
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet-vern_08_Sum")%>
<br />
<br />