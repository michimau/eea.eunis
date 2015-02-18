<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Fauna and flora' - part of site's factsheet.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
    request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtReportAttributesPersist,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.SiteSpeciesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtSitesAttributesPersist,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.SitesSpeciesReportAttributesPersist,
                 ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.utilities.EunisUtil,
                 ro.finsiel.eunis.utilities.SQLUtilities, ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
    String siteid = request.getParameter("idsite");
    SiteFactsheet factsheet = new SiteFactsheet(siteid);
    WebContentManagement cm = SessionManager.getWebContent();
    int type = factsheet.getType();
    String designationDescr = factsheet.getDesignation();

    SQLUtilities sqlc = new SQLUtilities();

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
        int rowinx = 0;
%>
<h3>
    <%=cm.cmsPhrase("Site contact authorities")%>
</h3>
<%-- Site contact authorities --%>
<table summary="<%=cm.cms("site_contact_authorities")%>" class="datatable fullwidth">
    <col style="width:20%"/>
    <col style="width:80%"/>
    <tbody>
    <%
        if (SiteFactsheet.TYPE_NATURA2000 == type ||
                SiteFactsheet.TYPE_EMERALD == type ||
                SiteFactsheet.TYPE_CORINE == type ||
                SiteFactsheet.TYPE_BIOGENETIC == type)
        {
    %>
    <tr<%=rowinx++ % 2 == 0 ? " class=\"zebraeven\"" : ""%>>
        <th scope="row">
            <%=cm.cmsPhrase("Respondent")%>
        </th>
            <%-- white-space:pre-line can have no whitespace between <td> and value --%>
        <td style="white-space:pre-line"><%=respondent%></td>
    </tr>
    <%
        }
        if (SiteFactsheet.TYPE_BIOGENETIC == type)
        {
    %>
    <tr<%=rowinx++ % 2 == 0 ? " class=\"zebraeven\"" : ""%>>
        <th scope="row">
            <%=cm.cmsPhrase("Author")%>
        </th>
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
    <tr<%=rowinx++ % 2 == 0 ? " class=\"zebraeven\"" : ""%>>
        <th scope="row">
            <%=cm.cmsPhrase("Manager")%>
        </th>
        <td style="white-space:pre-line"><%=manager%></td>
    </tr>
    <%
        }
        if (SiteFactsheet.TYPE_DIPLOMA == type)
        {
    %>
    <tr<%=rowinx++ % 2 == 0 ? " class=\"zebraeven\"" : ""%>>
        <th scope="row">
            <%=cm.cmsPhrase("Information")%>
        </th>
        <td>
            <%=information%>
        </td>
    </tr>
    <tr<%=rowinx++ % 2 == 0 ? " class=\"zebraeven\"" : ""%>>
        <th scope="row">
            <%=cm.cmsPhrase("Official contact international")%>
        </th>
        <td>
            <%=officialContactInternational%>&nbsp;
        </td>
    </tr>
    <tr<%=rowinx++ % 2 == 0 ? " class=\"zebraeven\"" : ""%>>
        <th scope="row">
            <%=cm.cmsPhrase("Official contact national")%>
        </th>
        <td>
            <%=officialContactNational%>&nbsp;
        </td>
    </tr>
    <tr<%=rowinx++ % 2 == 0 ? " class=\"zebraeven\"" : ""%>>
        <th scope="row">
            <%=cm.cmsPhrase("Official contact regional")%>
        </th>
        <td>
            <%=officialContactRegional%>&nbsp;
        </td>
    </tr>
    <tr<%=rowinx++ % 2 == 0 ? " class=\"zebraeven\"" : ""%>>
        <th scope="row">
            <%=cm.cmsPhrase("Official contact local")%>
        </th>
        <td>
            <%=officialContactLocal%>&nbsp;
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<br />
<%
    }
    String character = factsheet.getSiteObject().getCharacter();
    String quality = factsheet.getQuality();
    String vulnerability = factsheet.getVulnerability();
    String designation = (null != designationDescr) ? designationDescr : "";
    String ownership = factsheet.getSiteObject().getOwnership();
    String documentation = factsheet.getDocumentation();
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
<h3>
    <%=cm.cmsPhrase("Description")%>
</h3>
<table class="datatable fullwidth">
    <col style="width:30%"/>
    <col style="width:70%"/>
    <tbody>
    <%
        if (SiteFactsheet.TYPE_NATURA2000 == type ||
                SiteFactsheet.TYPE_EMERALD == type ||
                SiteFactsheet.TYPE_DIPLOMA == type ||
                SiteFactsheet.TYPE_CORINE == type)
        {
    %>
    <tr class="zebraeven">
        <th scope="row">
            <%=cm.cmsPhrase("General character of the site")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(character,false,false)%>&nbsp;
        </td>
    </tr>
    <%
        }
        if (SiteFactsheet.TYPE_CDDA_NATIONAL != type && SiteFactsheet.TYPE_CDDA_INTERNATIONAL != type)
        {
    %>
    <tr>
        <th scope="row">
            <%=cm.cmsPhrase("Quality")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(quality,false,false)%>&nbsp;
        </td>
    </tr>
    <tr class="zebraeven">
        <th scope="row">
            <%=cm.cmsPhrase("Vulnerability")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(vulnerability,false,false)%>&nbsp;
        </td>
    </tr>
    <tr>
        <th scope="row">
            <%=cm.cmsPhrase("Designation")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(designation,false,false)%>&nbsp;
        </td>
    </tr>
    <tr class="zebraeven">
        <th scope="row">
            <%=cm.cmsPhrase("Owner")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(ownership,false,false)%>&nbsp;
        </td>
    </tr>
    <tr>
        <th scope="row">
            <%=cm.cmsPhrase("Documentation")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(documentation,false,false)%>&nbsp;
        </td>
    </tr>
    <%
        }
        if (SiteFactsheet.TYPE_BIOGENETIC == type || SiteFactsheet.TYPE_DIPLOMA == type)
        {
    %>
    <tr class="zebraeven">
        <th scope="row">
            <%=cm.cmsPhrase("Habitat types")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(characterization,false,false)%>&nbsp;
        </td>
    </tr>
    <tr>
        <th scope="row">
            <%=cm.cmsPhrase("Flora")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(floraCharacterization,false,false)%>&nbsp;
        </td>
    </tr>
    <tr class="zebraeven">
        <th scope="row">
            <%=cm.cmsPhrase("Fauna")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(faunaCharacterization,false,false)%>&nbsp;
        </td>
    </tr>
    <tr>
        <th scope="row">
            <%=cm.cmsPhrase("Potential vegetation")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(potentialVegetation,false,false)%>&nbsp;
        </td>
    </tr>
    <%
        }
        if (SiteFactsheet.TYPE_DIPLOMA == type)
        {
    %>
    <tr class="zebraeven">
        <th scope="row">
            <%=cm.cmsPhrase("Geomorphology")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(geomorphology,false,false)%>&nbsp;
        </td>
    </tr>
    <tr>
        <th scope="row">
            <%=cm.cmsPhrase("Educational interest")%>
        </th>
        <td>
            <%=EunisUtil.replaceTags(educationalInterest,false,false)%>&nbsp;
        </td>
    </tr>
    <tr class="zebraeven">
        <th scope="row"><%=cm.cmsPhrase("Cultural heritage")%></th>
        <td><%=EunisUtil.replaceTags(culturalHeritage,false,false)%>&nbsp;</td>
    </tr>
    <%
        }
        if (SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_CORINE == type)
        {
    %>
    <tr>
        <th scope="row"><%=cm.cmsPhrase("Justification")%></th>
        <td><%=EunisUtil.replaceTags(justification,false,false)%>&nbsp;</td>
    </tr>
    <%
        }
        if (SiteFactsheet.TYPE_DIPLOMA == type)
        {
    %>
    <tr class="zebraeven">
        <th scope="row"><%=cm.cmsPhrase("Methodology")%></th>
        <td><%=EunisUtil.replaceTags(methodology,false,false)%>&nbsp;</td>
    </tr>
    <tr>
        <th scope="row"><%=cm.cmsPhrase("Budget")%></th>
        <td><%=EunisUtil.replaceTags(budget,false,false)%>&nbsp;</td>
    </tr>
    <%
        }
        if (SiteFactsheet.TYPE_NATURA2000 == type ||
                SiteFactsheet.TYPE_EMERALD == type ||
                SiteFactsheet.TYPE_DIPLOMA == type ||
                SiteFactsheet.TYPE_BIOGENETIC == type)
        {
    %>
    <tr class="zebraeven">
        <th scope="row"><%=cm.cmsPhrase("Management plan")%></th>
        <td><%=EunisUtil.replaceTags(managementPlan,false,false)%>&nbsp;</td>
    </tr>
    <%
        }
        if (SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_CDDA_INTERNATIONAL == type)
        {
    %>
    <tr>
        <th scope="row"><%=cm.cmsPhrase("URL official")%></th>
        <td><a title="Official URL" href="<%=urlOfficial%>"><%=urlOfficial%></a>&nbsp;</td>
    </tr>
    <tr class="zebraeven">
        <th scope="row"><%=cm.cmsPhrase("URL interesting")%></th>
        <td><a title="URL interesting" href="<%=urlInteresting%>"><%=urlInteresting%></a>&nbsp;</td>
    </tr>
    <%
        }
    %>
    </tbody>
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
        //list of species recognised in EUNIS
        List species = factsheet.findSitesSpeciesByIDNatureObject();
        //list of species not recognised in EUNIS
        List sitesSpecificspecies = factsheet.findSitesSpecificSpecies();
        if (!species.isEmpty() || !sitesSpecificspecies.isEmpty())
        {
            Chm62edtReportAttributesPersist attribute;
            if ( species.size() > 0 )
            {
%>

<h3>
    <%=cm.cmsPhrase("Ecological information: Fauna and Flora")%>
</h3>
<table summary="<%=cm.cms("ecological_information_fauna_flora")%>" class="listing fullwidth">
    <thead>
    <tr>
        <th scope="col">
            <%=cm.cmsPhrase("Species scientific name")%>
        </th>
        <th scope="col">
            <%=cm.cmsPhrase("Species group")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Resident")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Breeding")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Winter.")%>
            <%=cm.cmsTitle("sites_factsheet_faunaflora_wintering")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Staging")%>
            <%=cm.cmsTitle("sites_factsheet_faunaflora_annexesofdirectives")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Popul.")%>
            <%=cm.cmsTitle("sites_factsheet_faunaflora_populationstatus")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Species")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Nesting")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Conserv.")%>
            <%=cm.cmsTitle("sites_factsheet_faunaflora_conservationstatus")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Isolation")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Global status")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Species status")%>
        </th>
    </tr>
    </thead>
    <tbody>
    <%
        for (int i = 0; i < species.size(); i++)
        {
            String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
            SiteSpeciesPersist specie = (SiteSpeciesPersist)species.get(i);
            String attrValue;
    %>
    <tr<%=cssClass%>>
        <td>
            <a class="link-plain" href="species/<%=specie.getIdSpecies()%>"><%=specie.getSpeciesScientificName()%></a>
        </td>
        <td align="center">
            <%=specie.getSpeciesCommonName()%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("BREEDING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("RESIDENT",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("WINTERING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("STAGING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("POPULATION", specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("MIGRATION", specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("NESTING", specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <td align="center">
            <%
                attribute = factsheet.findSiteAttributes("CONSERVATION", specie.getIdReportAttributes());
                if ( attribute != null && attribute.getValue() != null && attribute.getValue().length() > 0 )
                {
                    attrValue = sqlc.ExecuteSQL( "SELECT NAME FROM chm62edt_natura2000_conservation_code WHERE ID_CONSERVATION_CODE='" + attribute.getValue() + "'" );
            %>
            <span class="boldUnderline" title="<%=attrValue%>"><%=attribute.getValue()%></span>
            <%
            } else {
            %>
            &nbsp;
            <%
                }
            %>
        </td>
        <td align="center">
            <%
                attribute = factsheet.findSiteAttributes("ISOLATION",specie.getIdReportAttributes());
                if ( attribute != null && attribute.getValue() != null && attribute.getValue().length() > 0 )
                {
                    attrValue = sqlc.ExecuteSQL( "SELECT NAME FROM chm62edt_isolation WHERE ID_ISOLATION='" + attribute.getValue() + "'" );
            %>
            <span class="boldUnderline" title="<%=attrValue%>"><%=attribute.getValue()%></span>
            <%
            } else {
            %>
            &nbsp;
            <%
                }
            %>
        </td>
        <td align="center">
            <%
                attribute = factsheet.findSiteAttributes("GLOBAL", specie.getIdReportAttributes());
                if ( attribute != null && attribute.getValue() != null && attribute.getValue().length() > 0 )
                {
                    attrValue = sqlc.ExecuteSQL( "SELECT NAME FROM chm62edt_global WHERE ID_GLOBAL='" + attribute.getValue() + "'" );
            %>
            <span class="boldUnderline" title="<%=attrValue%>"><%=attribute.getValue()%></span>
            <%
            } else {
            %>
            &nbsp;
            <%
                }
            %>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("SPECIES_STATUS", specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<br />
<%
    }
    if (sitesSpecificspecies.size() > 0)
    {
%>
<h3>
    <%=cm.cmsPhrase("Other species mentioned in site")%>
</h3>
<table summary="<%=cm.cms("other_species_mentioned_in_site")%>" class="listing fullwidth">
    <thead>
    <tr>
        <th scope="col">
            <%=cm.cmsPhrase("Species scientific name")%>
        </th>
    </tr>
    </thead>
    <tbody>
    <%
        // Here I get the species which are only specific to site
        for (int i = 0; i < sitesSpecificspecies.size(); i++)
        {
            String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
            Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist)sitesSpecificspecies.get(i);
    %>
    <tr<%=cssClass%>>
        <td>
            <a href="http://www.google.com/search?q=<%=specie.getValue()%>"><%=specie.getValue()%></a>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
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
            Chm62edtReportAttributesPersist attribute;
%>
<h3>
    <%=cm.cmsPhrase("Ecological information: Fauna and Flora mentioned in site")%>
</h3>
<%-- species mentioned in annexes and directives --%>
<%
    if (!eunisSpeciesListedAnnexesDirectives.isEmpty() || !notEunisSpeciesListedAnnexesDirectives.isEmpty())
    {
%>
<h3>
    <%=cm.cmsPhrase("Species")%>
</h3>
<table summary="<%=cm.cms("species")%>" class="listing fullwidth">
    <thead>
    <tr>
        <th scope="col">
            <%=cm.cmsPhrase("Species scientific name")%>
        </th>
        <th scope="col">
            <%=cm.cmsPhrase("Species group")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Resident")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Breeding")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Winter.")%>
            <%=cm.cmsTitle("sites_factsheet_faunaflora_wintering")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Staging")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Conserv.")%>
            <%=cm.cmsTitle("sites_factsheet_faunaflora_conservationstatus")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Popul.")%>
            <%=cm.cmsTitle("sites_factsheet_faunaflora_populationstatus")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Isolation")%>
        </th>
        <th>
            <%=cm.cmsPhrase("Global status")%>
        </th>
    </tr>
    </thead>
    <tbody>
    <%
        if (!eunisSpeciesListedAnnexesDirectives.isEmpty())
        {
            for (int i = 0; i < eunisSpeciesListedAnnexesDirectives.size(); i++)
            {
                String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
                SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist)eunisSpeciesListedAnnexesDirectives.get(i);
    %>
    <tr class="<%=cssClass%>">
        <td>
            <a class="link-plain" href="species/<%=specie.getIdSpecies()%>"><%=specie.getSpeciesScientificName()%></a>
        </td>
        <td>
            <%=specie.getSpeciesCommonName()%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("RESIDENT",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("BREEDING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("WINTERING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <td align="center">
            <%attribute = factsheet.findSiteAttributes("STAGING",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;"%>
        </td>
        <%attribute = factsheet.findSiteAttributes("CONSERVATION", specie.getIdReportAttributes());%>
        <%String conserv = ( null != attribute ) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;";%>
        <td align="center">
                <%--                        <span title="<%=factsheet.findConservNatura2000(conserv)%>" alt="<%=factsheet.findConservNatura2000(conserv)%>">--%>
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findConservNatura2000(conserv)%>','Conservation')" onmouseout="hidetooltip()">
          <a href="#" onclick="return false;"><%=conserv%></a>
        </span>
        </td>
        <%attribute = factsheet.findSiteAttributes("POPULATION", specie.getIdReportAttributes());%>
        <%String population = ( null != attribute ) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;";%>
        <td align="center">
                <%--                        <span title="<%=factsheet.findPopulation(population)%>" alt="<%=factsheet.findPopulation(population)%>">--%>
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findPopulation(population)%>','Population')" onmouseout="hidetooltip()">
            <a href="#" onclick="return false;"><%=population%></a>
          </span>
        </td>
        <%attribute = factsheet.findSiteAttributes("ISOLATION",specie.getIdReportAttributes());%>
        <%String isolation = ( null != attribute ) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;";%>
        <td align="center">
                <%--                        <span title="<%=factsheet.findIsolation(isolation)%>" alt="<%=factsheet.findIsolation(isolation)%>">--%>
          <span onmouseover="showtooltipWithMsgAndTitle('<%=factsheet.findIsolation(isolation)%>','Isolation')" onmouseout="hidetooltip()">
            <a href="#" onclick="return false;"><%=isolation%></a>
          </span>
        </td>
        <%attribute = factsheet.findSiteAttributes("GLOBAL", specie.getIdReportAttributes());%>
        <%String global = ( null != attribute ) ? Utilities.formatString( attribute.getValue(), "&nbsp;" ) : "&nbsp;";%>
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
                String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
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
    <tr<%=cssClass%>>
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
    </tbody>
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
<h3>
    <%=cm.cmsPhrase("Other species mentioned in site")%>
</h3>
<table summary="<%=cm.cms("other_species_mentioned_in_site")%>" class="listing fullwidth">
    <thead>
    <tr>
        <th scope="col" title="<%=cm.cmsPhrase("Sort results on this column")%>">
            <%=cm.cmsPhrase("Species group")%>
        </th>
        <th scope="col" title="<%=cm.cmsPhrase("Sort results on this column")%>">
            <%=cm.cmsPhrase("Species name")%>
        </th>
        <th scope="col" title="<%=cm.cmsPhrase("Sort results on this column")%>">
            <%=cm.cmsPhrase("Population size estimations")%>
        </th>
        <th scope="col" title="<%=cm.cmsPhrase("Sort results on this column")%>">
            <%=cm.cmsPhrase("Motivation for species mention")%>
        </th>
    </tr>
    </thead>
    <tbody>
    <%
        if (!eunisSpeciesOtherMentioned.isEmpty())
        {
            for (int i = 0; i < eunisSpeciesOtherMentioned.size(); i++)
            {
                String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
                SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist)eunisSpeciesOtherMentioned.get(i);
    %>
    <tr class="<%=cssClass%>">
        <td>
            <%=specie.getSpeciesCommonName()%>
        </td>
        <td>
            <a class="link-plain" href="species/<%=specie.getIdSpecies()%>"><%=specie.getSpeciesScientificName()%></a>
        </td>
        <td style="text-align: center;">
            <%attribute = factsheet.findSiteAttributes("OTHER_POPULATION",specie.getIdReportAttributes());%>
            <%=(null != attribute) ? ((null != attribute.getValue()) ? attribute.getValue() : "") : ""%>
        </td>
        <td style="text-align: center;">
            <%
                attribute = factsheet.findSiteAttributes("OTHER_MOTIVATION",specie.getIdReportAttributes());
                String attVal = "";
                if(!"".equals((null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""))
                    attVal = sqlc.ExecuteSQL("SELECT NAME FROM chm62edt_natura2000_motivation_code WHERE ID_MOTIVATION_CODE ='"+attribute.getValue()+"'");
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
                String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
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
    <tr class="<%=cssClass%>">
        <td>
            <%=groupName%>
        </td>
        <td>
            <%=specName%>
        </td>
        <td style="text-align: center;">
            <%attribute2 = factsheet.findNotEunisSpeciesOtherMentionedAttributes("POPULATION_"+specName);%>
            <%=(null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : ""%>
        </td>
        <td style="text-align: center;">
            <%
                attribute2 = factsheet.findNotEunisSpeciesOtherMentionedAttributes("MOTIVATION_"+specName);
                String attVal = "";
                if(!"".equals((null != attribute2) ? ((null !=attribute2.getValue()) ? attribute2.getValue() : "") : ""))
                    attVal = sqlc.ExecuteSQL("SELECT NAME FROM chm62edt_natura2000_motivation_code WHERE ID_MOTIVATION_CODE ='"+attribute2.getValue()+"'");
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
    </tbody>
</table>
<%
            }
        }
    }
%>





</stripes:layout-definition>