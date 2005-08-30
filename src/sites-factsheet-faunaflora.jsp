<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Fauna and flora' - part of site's factsheet.
--%>
<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtReportAttributesPersist,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.SiteSpeciesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtSitesAttributesPersist,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.SitesSpeciesReportAttributesPersist,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.SQLUtilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String siteid = request.getParameter("idsite");
  SiteFactsheet factsheet = new SiteFactsheet(siteid);
  WebContentManagement contentManagement = SessionManager.getWebContent();
  int type = factsheet.getType();
  String designationDescr = factsheet.getDesignation();

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

  String respondent = factsheet.getSiteObject().getRespondent();
  String author = factsheet.getAuthor();
  String manager = factsheet.getSiteObject().getManager();
  String information = factsheet.getSiteObject().getRespondent();
  String officialContactInternational = factsheet.getOfficialContactInternational();
  String officialContactNational = factsheet.getOfficialContactNational();
  String officialContactRegional = factsheet.getOfficialContactRegional();
  String officialContactLocal = factsheet.getOfficialContactLocal();
  if ((!respondent.equalsIgnoreCase("") || !author.equalsIgnoreCase("") || !manager.equalsIgnoreCase("") ||
          !information.equalsIgnoreCase("") || !officialContactInternational.equalsIgnoreCase("") ||
          !officialContactNational.equalsIgnoreCase("") || !officialContactRegional.equalsIgnoreCase("") ||
          !officialContactLocal.equalsIgnoreCase("")
          ) && (
            SiteFactsheet.TYPE_NATURA2000 == type || SiteFactsheet.TYPE_EMERALD == type ||
            SiteFactsheet.TYPE_CORINE == type || SiteFactsheet.TYPE_BIOGENETIC == type ||
            SiteFactsheet.TYPE_DIPLOMA == type)) // If some attributes are non-null and site is from these dbs
  {
%>
    <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_61")%></div>
    <%-- Site contact authorities --%>
    <table summary="<%=contentManagement.getContent("sites_factsheet_61", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" style="border-collapse:collapse" >
<%
    if (SiteFactsheet.TYPE_NATURA2000 == type ||
              SiteFactsheet.TYPE_EMERALD == type ||
              SiteFactsheet.TYPE_CORINE == type ||
              SiteFactsheet.TYPE_BIOGENETIC == type)
    {
%>
      <tr bgcolor="#EEEEEE">
        <td width="40%">
          <%=contentManagement.getContent("sites_factsheet_62")%>
        </td>
        <td width="60%">
          <%=respondent%>
        </td>
      </tr>
<%
    }
    if (SiteFactsheet.TYPE_BIOGENETIC == type)
    {
%>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=contentManagement.getContent("sites_factsheet_63")%>
        </td>
        <td>
          <%=author%>
        </td>
      </tr>
<%
    }
    if (SiteFactsheet.TYPE_NATURA2000 == type ||
            SiteFactsheet.TYPE_EMERALD == type ||
            SiteFactsheet.TYPE_DIPLOMA == type ||
            SiteFactsheet.TYPE_BIOGENETIC == type)
    {
%>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=contentManagement.getContent("sites_factsheet_64")%>
        </td>
        <td>
          <%=manager%>
        </td>
      </tr>
<%
    }
    if (SiteFactsheet.TYPE_DIPLOMA == type)
    {
%>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=contentManagement.getContent("sites_factsheet_65")%>
        </td>
        <td>
          <%=information%>
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=contentManagement.getContent("sites_factsheet_66")%>
        </td>
        <td>
          <%=officialContactInternational%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=contentManagement.getContent("sites_factsheet_67")%>
        </td>
        <td>
          <%=officialContactNational%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=contentManagement.getContent("sites_factsheet_68")%>
        </td>
        <td>
          <%=officialContactRegional%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=contentManagement.getContent("sites_factsheet_69")%>
        </td>
        <td>
          <%=officialContactLocal%>&nbsp;
        </td>
      </tr>
<%
    }
%>
    </table>
    <br />
<%
  }
  String character = factsheet.getSiteObject().getCharacter();
  String quality = factsheet.getSiteObject().getQuality();
  String vulnerability = factsheet.getSiteObject().getVulnerability();
  String designation = (null != designationDescr) ? designationDescr : "";
  String ownership = factsheet.getSiteObject().getOwnership();
  String documentation = factsheet.getSiteObject().getDocumentation();
  String characterization = factsheet.getHabitatCharacterization();
  String floraCharacterization = factsheet.getFloraCharacterization();
  String faunaCharacterization = factsheet.getFaunaCharacterization();
  String potentialVegetation = factsheet.getPotentialVegetation();
  String geomorphology = factsheet.getGeomorphology();
  String educationalInterest = factsheet.getEducationalInterest();
  String culturalHeritage = factsheet.getCulturalHeritage();
  String justification = factsheet.getJustification();
  String methodology = factsheet.getMethodology();
  String budget = factsheet.getBudget();
  String managementPlan = factsheet.getSiteObject().getManagementPlan();
  String urlOfficial = factsheet.getURLOfficial();
  String urlInteresting = factsheet.getURLInteresting();
  // If one of the attributes is non-empty, display the table.
  // Also if designation is non-empty and DATABASE is NOT CDDA_NATIONAL/CDDA_INTERNATIONAL display the table
  if (!character.equalsIgnoreCase("") || !quality.equalsIgnoreCase("") ||
          !vulnerability.equalsIgnoreCase("") ||
          (
            !designation.equalsIgnoreCase("") &&
            (
              SiteFactsheet.TYPE_CDDA_NATIONAL != type &&
              SiteFactsheet.TYPE_CDDA_INTERNATIONAL != type
            )
          )||
          !ownership.equalsIgnoreCase("") || !documentation.equalsIgnoreCase("") ||
          !characterization.equalsIgnoreCase("") || !floraCharacterization.equalsIgnoreCase("") ||
          !faunaCharacterization.equalsIgnoreCase("") || !potentialVegetation.equalsIgnoreCase("") ||
          !geomorphology.equalsIgnoreCase("") || !educationalInterest.equalsIgnoreCase("") ||
          !culturalHeritage.equalsIgnoreCase("") || !justification.equalsIgnoreCase("") ||
          !methodology.equalsIgnoreCase("") || !budget.equalsIgnoreCase("") ||
          !managementPlan.equalsIgnoreCase("") || !urlOfficial.equalsIgnoreCase("") ||
          !urlInteresting.equalsIgnoreCase(""))
  {
%>
    <%-- Description --%>
    <table border="1" cellpadding="1" cellspacing="1" width="100%" style="border-collapse:collapse" >
      <tr>
        <td colspan="2" bgcolor="#DDDDDD">
          <strong>
            Description
          </strong>
        </td>
      </tr>
<%
  if (SiteFactsheet.TYPE_NATURA2000 == type ||
          SiteFactsheet.TYPE_EMERALD == type ||
          SiteFactsheet.TYPE_DIPLOMA == type ||
          SiteFactsheet.TYPE_CORINE == type)
  {
%>
      <tr bgcolor="#EEEEEE">
        <td width="30%">
          <%=contentManagement.getContent("sites_factsheet_70")%>
        </td>
        <td width="70%">
          <%=character%>&nbsp;
        </td>
      </tr>
<%
  }
  if (SiteFactsheet.TYPE_CDDA_NATIONAL != type && SiteFactsheet.TYPE_CDDA_INTERNATIONAL != type)
  {
%>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=contentManagement.getContent("sites_factsheet_71")%>
        </td>
        <td>
          <%=quality%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=contentManagement.getContent("sites_factsheet_72")%>
        </td>
        <td>
          <%=vulnerability%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=contentManagement.getContent("sites_factsheet_73")%>
        </td>
        <td>
          <%=designation%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=contentManagement.getContent("sites_factsheet_74")%>
        </td>
        <td>
          <%=ownership%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=contentManagement.getContent("sites_factsheet_75")%>
        </td>
        <td>
          <%=documentation%>&nbsp;
        </td>
      </tr>
<%
  }
  if (SiteFactsheet.TYPE_BIOGENETIC == type || SiteFactsheet.TYPE_DIPLOMA == type)
  {
%>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=contentManagement.getContent("sites_factsheet_76")%>
        </td>
        <td>
          <%=characterization%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=contentManagement.getContent("sites_factsheet_77")%>
        </td>
        <td>
          <%=floraCharacterization%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=contentManagement.getContent("sites_factsheet_78")%>
        </td>
        <td>
          <%=faunaCharacterization%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=contentManagement.getContent("sites_factsheet_79")%>
        </td>
        <td>
          <%=potentialVegetation%>&nbsp;
        </td>
      </tr>
<%
  }
  if (SiteFactsheet.TYPE_DIPLOMA == type)
  {
%>
      <tr bgcolor="#EEEEEE">
        <td>
          <%=contentManagement.getContent("sites_factsheet_80")%>
        </td>
        <td>
          <%=geomorphology%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td>
          <%=contentManagement.getContent("sites_factsheet_81")%>
        </td>
        <td>
          <%=educationalInterest%>&nbsp;
        </td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td><%=contentManagement.getContent("sites_factsheet_82")%></td>
        <td><%=culturalHeritage%>&nbsp;</td>
      </tr>
<%
  }
  if (SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_CORINE == type)
  {
%>
      <tr bgcolor="#FFFFFF">
        <td><%=contentManagement.getContent("sites_factsheet_83")%></td>
        <td><%=justification%>&nbsp;</td>
      </tr>
<%
  }
  if (SiteFactsheet.TYPE_DIPLOMA == type)
  {
%>
      <tr bgcolor="#EEEEEE">
        <td><%=contentManagement.getContent("sites_factsheet_84")%></td>
        <td><%=methodology%>&nbsp;</td>
      </tr>
      <tr bgcolor="#FFFFFF">
        <td><%=contentManagement.getContent("sites_factsheet_85")%></td>
        <td><%=budget%>&nbsp;</td>
      </tr>
<%
  }
  if (SiteFactsheet.TYPE_NATURA2000 == type ||
          SiteFactsheet.TYPE_EMERALD == type ||
          SiteFactsheet.TYPE_DIPLOMA == type ||
          SiteFactsheet.TYPE_BIOGENETIC == type)
  {
%>
      <tr bgcolor="#EEEEEE">
        <td><%=contentManagement.getContent("sites_factsheet_86")%></td>
        <td><%=managementPlan%>&nbsp;</td>
      </tr>
<%
  }
  if (SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_CDDA_INTERNATIONAL == type)
  {
%>
      <tr bgcolor="#FFFFFF">
        <td><%=contentManagement.getContent("sites_factsheet_87")%></td>
        <td><a title="Official URL" href="<%=urlOfficial%>"><%=urlOfficial%></a>&nbsp;</td>
      </tr>
      <tr bgcolor="#EEEEEE">
        <td><%=contentManagement.getContent("sites_factsheet_88")%></td>
        <td><a title="URL interesting" href="<%=urlInteresting%>"><%=urlInteresting%></a>&nbsp;</td>
      </tr>
<%
  }
%>
  </table>
  <br />
<%
    }
%>
      <%-- Ecological information: Fauna and Flora --%>
<%
      //1. everything but Natura 2000
      if(SiteFactsheet.TYPE_EMERALD == type ||
          SiteFactsheet.TYPE_DIPLOMA == type ||
          SiteFactsheet.TYPE_BIOGENETIC == type ||
          SiteFactsheet.TYPE_CORINE == type)
      {
        //list of species recognized in EUNIS
        List species = factsheet.findSitesSpeciesByIDNatureObject();
        //list of species not recognized in EUNIS
        List sitesSpecificspecies = factsheet.findSitesSpecificSpecies();
        if (!species.isEmpty() || !sitesSpecificspecies.isEmpty())
        {
          Chm62edtReportAttributesPersist attribute = null;
          if ( species.size() > 0 )
          {
%>

      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_89")%></div>
      <table summary="<%=contentManagement.getContent("sites_factsheet_89", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="species" style="border-collapse:collapse">
        <tr>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 13, 0, 'species', false);"><%=contentManagement.getContent("sites_factsheet_90")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 13, 1, 'species', false);"><%=contentManagement.getContent("sites_factsheet_91")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 13, 2, 'species', false);"><%=contentManagement.getContent("sites_factsheet_92")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 13, 3, 'species', false);"><%=contentManagement.getContent("sites_factsheet_93")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Wintering status.Sort results by this column" href="javascript:sortTable( 13, 4, 'species', false);"><%=contentManagement.getContent("sites_factsheet_94")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Species listed in Annexes of Directives.Sort results by this column" href="javascript:sortTable( 13, 5, 'species', false);"><%=contentManagement.getContent("sites_factsheet_95")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Population status.Sort results by this column" href="javascript:sortTable( 13, 6, 'species', false);"><%=contentManagement.getContent("sites_factsheet_96")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 13, 7, 'species', false);"><%=contentManagement.getContent("sites_factsheet_97")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 13, 8, 'species', false);"><%=contentManagement.getContent("sites_factsheet_98")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Conservation status.Sort results by this column" href="javascript:sortTable( 13, 9, 'species', false);"><%=contentManagement.getContent("sites_factsheet_99")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 13, 10, 'species', false);"><%=contentManagement.getContent("sites_factsheet_100")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 13, 11, 'species', false);"><%=contentManagement.getContent("sites_factsheet_101")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 13, 12, 'species', false);"><%=contentManagement.getContent("sites_factsheet_102")%></a>
          </th>
        </tr>
<%
          for (int i = 0; i < species.size(); i++)
          {
            SiteSpeciesPersist specie = (SiteSpeciesPersist)species.get(i);
%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=specie.getSpeciesScientificName()%></a>
          </td>
          <td align="center">
            <%=specie.getSpeciesCommonName()%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("BREEDING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("RESIDENT",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("WINTERING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("STAGING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("POPULATION", specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("MIGRATION", specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("NESTING", specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("CONSERVATION", specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("ISOLATION",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("GLOBAL", specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("SPECIES_STATUS", specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
        </tr>
<%
          }
%>
      </table>
      <br />
<%
          }
    if (sitesSpecificspecies.size() > 0)
    {
%>
      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_103")%></div>
      <table summary="<%=contentManagement.getContent("sites_factsheet_103", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" name="speciesNonEUNIS" id="speciesNonEUNIS" cols="1" style="border-collapse:collapse">
        <tr>
          <th class="resultHeader">
            <%=contentManagement.getContent("sites_factsheet_104")%>
          </th>
        </tr>
<%
          // Here I get the species which are only specific to site
          for (int i = 0; i < sitesSpecificspecies.size(); i++)
          {
            Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist)sitesSpecificspecies.get(i);
%>
            <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
              <td>
                <a title="<%=contentManagement.getContent("sites_factsheet_105",false)%>" href="javascript:openGooglePics('http://www.google.com/search?q=<%=specie.getValue()%>')"><%=specie.getValue()%></a>
              </td>
            </tr>
<%
          }
%>
      </table>
      <br />
<%
         }
       }
     }
    //2. only for Natura 2000
    if(SiteFactsheet.TYPE_NATURA2000 == type )
    {
       List eunisSpeciesListedAnnexesDirectives = factsheet.findEunisSpeciesListedAnnexesDirectivesForSitesNatura2000();
       List eunisSpeciesOtherMentioned = factsheet.findEunisSpeciesOtherMentionedForSitesNatura2000();
       List notEunisSpeciesListedAnnexesDirectives = factsheet.findNotEunisSpeciesListedAnnexesDirectives();
       List notEunisSpeciesOtherMentioned = factsheet.findNotEunisSpeciesOtherMentioned();

      if (!eunisSpeciesListedAnnexesDirectives.isEmpty() || !eunisSpeciesOtherMentioned.isEmpty()
      || !notEunisSpeciesListedAnnexesDirectives.isEmpty() || !notEunisSpeciesOtherMentioned.isEmpty())
      {
        Chm62edtReportAttributesPersist attribute = null;
%>
      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_106")%></div>
      <%-- species mentioned in annexes and directives --%>
<%
    if (!eunisSpeciesListedAnnexesDirectives.isEmpty() || !notEunisSpeciesListedAnnexesDirectives.isEmpty())
    {
%>
      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_97")%></div>
      <table summary="<%=contentManagement.getContent("sites_factsheet_97", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="species1" style="border-collapse:collapse">
        <tr bgcolor="#DDDDDD">
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 10, 0, 'species1', false);"><%=contentManagement.getContent("sites_factsheet_107")%></a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 10, 1, 'species1', false);"><%=contentManagement.getContent("sites_factsheet_108")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 10, 2, 'species1', false);"><%=contentManagement.getContent("sites_factsheet_92")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 10, 3, 'species1', false);"><%=contentManagement.getContent("sites_factsheet_93")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Wintering.Sort results by this column" href="javascript:sortTable( 10, 4, 'species1', false);"><%=contentManagement.getContent("sites_factsheet_94")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 10, 5, 'species1', false);"><%=contentManagement.getContent("sites_factsheet_95")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Conservation status.Sort results by this column" href="javascript:sortTable( 10, 6, 'species1', false);"><%=contentManagement.getContent("sites_factsheet_99")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Population status.Sort results by this column" href="javascript:sortTable( 10, 7, 'species1', false);"><%=contentManagement.getContent("sites_factsheet_96")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 10, 8, 'species1', false);"><%=contentManagement.getContent("sites_factsheet_100")%></a>
          </th>
          <th class="resultHeader" align="center">
            <a title="Sort results by this column" href="javascript:sortTable( 10, 9, 'species1', false);"><%=contentManagement.getContent("sites_factsheet_101")%></a>
          </th>
        </tr>
<%
    if (!eunisSpeciesListedAnnexesDirectives.isEmpty())
    {
      for (int i = 0; i < eunisSpeciesListedAnnexesDirectives.size(); i++)
      {
        SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist)eunisSpeciesListedAnnexesDirectives.get(i);
%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=specie.getSpeciesScientificName()%></a>
          </td>
          <td>
            <%=specie.getSpeciesCommonName()%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("RESIDENT",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("BREEDING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("WINTERING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute = factsheet.findSiteAttributes("STAGING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <%attribute = factsheet.findSiteAttributes("CONSERVATION", specie.getIdReportAttributes());%>
          <%String conserv = (null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : "";%>
          <td align="center">
<%--                        <span title="<%=factsheet.findConservNatura2000(conserv)%>" alt="<%=factsheet.findConservNatura2000(conserv)%>">--%>
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findConservNatura2000(conserv)%>','Conservation')" onmouseout="hidetooltip()">
            <a href="#" onclick="return false;"><%=conserv%></a>
          </span>
          </td>
          <%attribute = factsheet.findSiteAttributes("POPULATION", specie.getIdReportAttributes());%>
          <%String population = (null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : "";%>
          <td align="center">
<%--                        <span title="<%=factsheet.findPopulation(population)%>" alt="<%=factsheet.findPopulation(population)%>">--%>
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findPopulation(population)%>','Population')" onmouseout="hidetooltip()">
            <a href="#" onclick="return false;"><%=population%></a>
          </span>
          </td>
          <%attribute = factsheet.findSiteAttributes("ISOLATION",specie.getIdReportAttributes());%>
          <%String isolation = (null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : "";%>
          <td align="center">
<%--                        <span title="<%=factsheet.findIsolation(isolation)%>" alt="<%=factsheet.findIsolation(isolation)%>">--%>
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findIsolation(isolation)%>','Isolation')" onmouseout="hidetooltip()">
            <a href="#" onclick="return false;"><%=isolation%></a>
          </span>
          </td>
          <%attribute = factsheet.findSiteAttributes("GLOBAL", specie.getIdReportAttributes());%>
          <%String global = (null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : "";%>
          <td align="center">
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findGlobal(global)%>','Global status')" onmouseout="hidetooltip()">
<%--                        <span title="<%=factsheet.findGlobal(global)%>" alt="<%=factsheet.findGlobal(global)%>">--%>
            <a title="Global status" href="#" onclick="return false;"><%=global%></a>
           </span>
          </td>
        </tr>
<%
        }
         }
         if(!notEunisSpeciesListedAnnexesDirectives.isEmpty())
         {
           Chm62edtSitesAttributesPersist attribute2 = null;

        for (int i = 0; i < notEunisSpeciesListedAnnexesDirectives.size(); i++)
        {
          Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist)notEunisSpeciesListedAnnexesDirectives.get(i);
          String specName = specie.getName();
          specName = (specName == null ? "" : specName.substring(specName.lastIndexOf("_")+1));
          String groupName = specie.getSourceTable();
          groupName = (groupName == null ? "" : (groupName.equalsIgnoreCase("amprep") ? "Amphibians"
              :(groupName.equalsIgnoreCase("bird") ? "Birds"
              :(groupName.equalsIgnoreCase("fishes") ? "Fishes"
              :(groupName.equalsIgnoreCase("invert") ? "Invertebrates"
              :(groupName.equalsIgnoreCase("mammal") ? "Mammals"
              :(groupName.equalsIgnoreCase("plant") ? "Flowering Plants" : "")))))));

%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <%=specName%>
          </td>
          <td align="center">
            <%=groupName%>
          </td>
          <td align="center">
            <%attribute2 = factsheet.findNotEunisSpeciesListedAnnexesDirectivesAttributes("RESIDENT_"+specName);%>
            <%=(null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute2 = factsheet.findNotEunisSpeciesListedAnnexesDirectivesAttributes("BREEDING_"+specName);%>
            <%=(null != attribute2) ? ((null !=attribute2.getValue()) ? attribute2.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute2 = factsheet.findNotEunisSpeciesListedAnnexesDirectivesAttributes("WINTERING_"+specName);%>
            <%=(null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : ""%>
          </td>
          <td align="center">
            <%attribute2 = factsheet.findNotEunisSpeciesListedAnnexesDirectivesAttributes("STAGING_"+specName);%>
            <%=(null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : ""%>
          </td>
          <%attribute2 = factsheet.findNotEunisSpeciesListedAnnexesDirectivesAttributes("CONSERVATION_"+specName);%>
          <%String conserv = (null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : "";%>
          <td align="center">
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findConservNatura2000(conserv)%>','Conservation')" onmouseout="hidetooltip()">
<%--                        <span title="<%=factsheet.findConservNatura2000(conserv)%>" alt="<%=factsheet.findConservNatura2000(conserv)%>">--%>
            <a href="#" onclick="return false;"><%=conserv%></a>
          </span>
          </td>
          <%attribute2 = factsheet.findNotEunisSpeciesListedAnnexesDirectivesAttributes("POPULATION_"+specName);%>
          <%String population = (null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : "";%>
          <td align="center">
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findPopulation(population)%>','Population')" onmouseout="hidetooltip()">
<%--                        <span title="<%=factsheet.findPopulation(population)%>" alt="<%=factsheet.findPopulation(population)%>">--%>
            <a href="#" onclick="return false;"><%=population%></a>
          </span>
          </td>
          <%attribute2 = factsheet.findNotEunisSpeciesListedAnnexesDirectivesAttributes("ISOLATION_"+specName);%>
          <%String isolation = (null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : "";%>
          <td align="center">
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findIsolation(isolation)%>','Isolation')" onmouseout="hidetooltip()">
<%--                        <span title="<%=factsheet.findIsolation(isolation)%>" alt="<%=factsheet.findIsolation(isolation)%>">--%>
            <a href="#" onclick="return false;"><%=isolation%></a>
          </span>
          </td>
          <%attribute2 = factsheet.findNotEunisSpeciesListedAnnexesDirectivesAttributes("GLOBAL_"+specName);%>
          <%String global = (null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : "";%>
          <td align="center">
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findGlobal(global)%>','Global status')" onmouseout="hidetooltip()">
<%--                        <span title="<%=factsheet.findGlobal(global)%>" alt="<%=factsheet.findGlobal(global)%>">--%>
            <a href="#" onclick="return false;"><%=global%></a>
           </span>
          </td>
        </tr>
<%
                  }
                   }
%>
      </table>
      <br />
<%
    }
%>
              <%-- Other species mentioned in site --%>
<%
    if (!eunisSpeciesOtherMentioned.isEmpty() || !notEunisSpeciesOtherMentioned.isEmpty())
    {
%>
      <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_103")%></div>
      <table summary="<%=contentManagement.getContent("sites_factsheet_103", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="species_other" style="border-collapse:collapse">
        <tr>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 0, 'species_other', false);"><%=contentManagement.getContent("sites_factsheet_111")%></a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 1, 'species_other', false);"><%=contentManagement.getContent("sites_factsheet_110")%></a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 2, 'species_other', false);"><%=contentManagement.getContent("sites_factsheet_113")%></a>
          </th>
          <th class="resultHeader">
            <a title="Sort results by this column" href="javascript:sortTable( 4, 3, 'species_other', false);"><%=contentManagement.getContent("sites_factsheet_112")%></a>
          </th>
        </tr>
<%
      if (!eunisSpeciesOtherMentioned.isEmpty())
      {
      for (int i = 0; i < eunisSpeciesOtherMentioned.size(); i++)
      {
        SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist)eunisSpeciesOtherMentioned.get(i);
%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <%=specie.getSpeciesCommonName()%>
          </td>
          <td>
           <a title="Species factsheet" href="species-factsheet.jsp?idSpecies=<%=specie.getIdSpecies()%>&amp;idSpeciesLink=<%=specie.getIdSpeciesLink()%>"><%=specie.getSpeciesScientificName()%></a>
          </td>
          <td>
            <%attribute = factsheet.findSiteAttributes("OTHER_POPULATION",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
          </td>
          <td>
            <%
                attribute = factsheet.findSiteAttributes("OTHER_MOTIVATION",specie.getIdReportAttributes());
                String attVal = "";
                if(!"".equals((null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""))
                  attVal = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_NATURA2000_MOTIVATION_CODE WHERE ID_MOTIVATION_CODE ='"+attribute.getValue()+"'");
            %>
           <span onmouseover="showtooltipWithMsgAndTitle('<%=attVal%>','Motivation for species mention')" onmouseout="hidetooltip()">
             <a href="#" onclick="return false;"><%=(null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""%></a>
           </span>
          </td>
        </tr>
<%
        }
      }
      if (!notEunisSpeciesOtherMentioned.isEmpty())
      {
        Chm62edtSitesAttributesPersist  attribute2 = null;
      for (int i = 0; i < notEunisSpeciesOtherMentioned.size(); i++)
      {
        Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist)notEunisSpeciesOtherMentioned.get(i);
        String specName = specie.getName();
        specName = (specName == null ? "" : specName.substring(specName.lastIndexOf("_")+1));
        attribute2 = factsheet.findNotEunisSpeciesOtherMentionedAttributes("TAXGROUP_"+specName);
        String groupName = (null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : "";
        groupName = (groupName == null ? "" : (groupName.equalsIgnoreCase("P") ? "Plants"
            :(groupName.equalsIgnoreCase("A") ? "Amphibians"
            :(groupName.equalsIgnoreCase("F") ? "Fishes"
            :(groupName.equalsIgnoreCase("I") ? "Invertebrates"
            :(groupName.equalsIgnoreCase("M") ? "Mammals"
            :(groupName.equalsIgnoreCase("B") ? "Birds"
            :(groupName.equalsIgnoreCase("F") ? "Flowering"
            :(groupName.equalsIgnoreCase("R") ? "Reptiles" : "")))))))));
%>
        <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <%=groupName%>
          </td>
          <td>
           <%=specName%>
          </td>
          <td>
            <%attribute2 = factsheet.findNotEunisSpeciesOtherMentionedAttributes("POPULATION_"+specName);%>
            <%=(null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : ""%>
          </td>
          <td>
            <%
                attribute2 = factsheet.findNotEunisSpeciesOtherMentionedAttributes("MOTIVATION_"+specName);
                String attVal = "";
                if(!"".equals((null != attribute2) ? ((null !=attribute2.getValue()) ? attribute2.getValue() : "") : ""))
                  attVal = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_NATURA2000_MOTIVATION_CODE WHERE ID_MOTIVATION_CODE ='"+attribute2.getValue()+"'");
            %>
            <span onmouseover="showtooltipWithMsgAndTitle('<%=attVal%>','Motivation for species mention')" onmouseout="hidetooltip()">
              <a href="#" onclick="return false;"><%=(null != attribute2) ? ((null !=attribute2.getValue()) ? attribute2.getValue() : "") : ""%></a>
            </span>
          </td>
        </tr>
<%
        }
      }
%>
      </table>
      <br />
<%
    }
      }
    }

%>