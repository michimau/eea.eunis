<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - vernacular names.
--%>
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
    <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">Vernacular names</div>
    <table summary="Vernacular names" width="100%" border="1" cellspacing="1" cellpadding="0"  id="vernNames" style="border-collapse:collapse">
      <tr style="background-color:#DDDDDD">
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Vernacular name" href="javascript:sortTable(3,0, 'vernNames', false);"><%=cm.getContent("species_factsheet-vern_02")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Language" href="javascript:sortTable(3,1, 'vernNames', false);"><%=cm.getContent("species_factsheet-vern_03")%></a>
        </th>
        <th class="resultHeaderForFactsheet">
          <a title="Sort by Reference" href="javascript:sortTable(3,2, 'vernNames', false);"><%=cm.getContent("species_factsheet-vern_04")%></a>
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
<br />
<br />