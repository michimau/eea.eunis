<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - general info.
--%>
<%@page contentType="text/html"%>
<%@ page import="ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.List,
                 ro.finsiel.eunis.factsheet.species.NationalThreatWrapper,
                 ro.finsiel.eunis.search.species.factsheet.PublicationWrapper,
                 java.util.Vector,
                 ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodeDomain,
                 ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodePersist,
                 java.util.StringTokenizer"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// Request parameters:
  // idSpecies - ID of specie
  // idSpeciesLink - ID of specie (Link to species base)
  String idSpecies = request.getParameter("idSpecies");
  String idSpeciesLink = request.getParameter("idSpeciesLink");
  SpeciesFactsheet factsheet = new SpeciesFactsheet(Utilities.checkedStringToInt(idSpecies, new Integer(0)),
          Utilities.checkedStringToInt(idSpeciesLink, new Integer(0)));
  SpeciesNatureObjectPersist specie = factsheet.getSpeciesNatureObject();
  String scientificName = specie.getScientificName();
  WebContentManagement contentManagement = SessionManager.getWebContent();

  // Taxonomic information
  /*
  String kingdom = factsheet.getTaxcodeObject().returnName(factsheet.getTaxcodeObject().returnIdKingdom());
  String phylum = factsheet.getTaxcodeObject().returnName(factsheet.getTaxcodeObject().returnIdPhylum());
  String taxClass = factsheet.getTaxcodeObject().returnName(factsheet.getTaxcodeObject().returnIdClass());
  String subClass = factsheet.getTaxcodeObject().returnName(factsheet.getTaxcodeObject().returnIdSubclass());
  String order = factsheet.getTaxcodeObject().returnName(factsheet.getTaxcodeObject().returnIdOrder());
  String family = factsheet.getTaxcodeObject().returnName(factsheet.getTaxcodeObject().returnIdFamily());
  String phylumDivisionTitle = factsheet.getTaxcodeObject().getLevelMax();
  */
  //String genusName = (scientificName.indexOf(" ")>=0? scientificName.substring(0,scientificName.indexOf(" ")) : scientificName);
  String genusName = specie.getGenus();
  String authorDate = SpeciesFactsheet.getBookAuthorDate(factsheet.getTaxcodeObject().IdDcTaxcode());
%>
  <table summary="layout" width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr style="background-color:#CCCCCC">
      <td colspan="2">
        <strong>
          <%=contentManagement.getContent("species_factsheet_taxonomicInformation")%>
        </strong>
      </td>
      <td style="text-align:center">
        <strong>
          <%=contentManagement.getContent("species_factsheet_reference")%>
        </strong>
      </td>
    </tr>
<%
    List list = new Vector();
    try
    {
      list = new Chm62edtTaxcodeDomain().findWhere("ID_TAXONOMY = '" + specie.getIdTaxcode() + "'");
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    if (list != null && list.size() > 0)
    {
      Chm62edtTaxcodePersist t = (Chm62edtTaxcodePersist) list.get(0);
      String str = t.getTaxonomyTree();
      //System.out.println("str = " + str);
      StringTokenizer st = new StringTokenizer(str,",");
      while(st.hasMoreTokens())
      {
        StringTokenizer sts = new StringTokenizer(st.nextToken(),"*");
        String classification_id = sts.nextToken();
        String classification_level = sts.nextToken();
        String classification_name = sts.nextToken();
        %>
        <tr style="background-color:#EEEEEE">
          <td width="20%">
            <%=classification_level%>
          </td>
          <td width="40%">
            <strong>
              <%=classification_name%>
            </strong>
          </td>
          <%
          if(classification_level.equalsIgnoreCase("kingdom")) {
          %>
            <td rowspan="<%=st.countTokens()+2%>" style="text-align:center"><strong><%=Utilities.treatURLSpecialCharacters(authorDate)%></strong></td>
          <%
          }
          %>
        </tr>
        <%
      }
    }
    %>
    <tr style="background-color:#EEEEEE">
      <td width="20%">
        Genus
      </td>
      <td width="40%">
        <strong>
          <%=genusName%>
        </strong>
      </td>
    </tr>
  </table>
  <table summary="layout" width="100%" border="0" cellspacing="5" cellpadding="5">
    <tr>
      <td width="20%" style="text-align : center; vertical-align : middle">
        <a title="Open Google. Link will open a new window." href="javascript:openGooglePics('http://images.google.com/images?q=<%=Utilities.treatURLSpecialCharacters(scientificName)%>')"><%=contentManagement.getContent("species_factsheet_googlePics")%></a>
      </td>
      <td width="20%" style="text-align : center; vertical-align : middle">
<%
      String gbifLink = specie.getScientificName();
      gbifLink = gbifLink.replaceAll( "\\.", "" );
      gbifLink = gbifLink.replaceAll( " ", "\\." );
%>
        <a title="Open GBIF. Link will open a new window." href="javascript:openGBIF('http://<%=gbifLink%>.gbif.name', 600, 600 );">GBIF link</a>
      </td>
      <td width="20%" style="text-align : center; vertical-align : middle">
<%
      String sn = scientificName;
      sn=sn.replaceAll("sp.","").replaceAll("ssp.","");
      String genus="";
      String spname="";
      String kingdomname="";
      String taxonomy = specie.getIdTaxcode().substring( 0, 1 );
      if( taxonomy.equalsIgnoreCase( "1" ) ) kingdomname = "Animals";
      if( taxonomy.equalsIgnoreCase( "2" ) ) kingdomname = "Plants";
      if( taxonomy.equalsIgnoreCase( "3" ) ) kingdomname = "Mushrooms";
      int pos = -1;
      pos = sn.indexOf( " " );
      if( pos >= 0 )
      {
        genus=sn.substring(0, pos);
        spname=sn.substring(pos+1);
%>
        <a title="Open unep-wcmc. Link will open a new window." href="javascript:openunepwcmc('http://sea.unep-wcmc.org/isdb/species.cfm?source=<%=kingdomname%>&amp;genus=<%=genus%>&amp;species=<%=Utilities.treatURLSpecialCharacters(spname)%>')"><%=contentManagement.getContent("species_factsheet_unepWCMC")%></a>
<%
      }
      else
      {
%>
        &nbsp;
<%
      }
%>
      </td>
<%
      // List of species national threat status.
      List consStatus = factsheet.getConservationStatus(factsheet.getSpeciesObject());
      boolean isGood = false;
      if( consStatus != null && consStatus.size() > 0 )
      {
        for (int i=0;i<consStatus.size();i++)
        {
          NationalThreatWrapper threat = (NationalThreatWrapper)consStatus.get(i);
          if(threat.getReference() != null && threat.getReference().indexOf("IUCN")>=0) {isGood = true;break;}
        }
      }
      if( isGood )
      {
        String scientificNameURL = scientificName.replace(' ','+');
%>
      <td width="20%" style="text-align : center; vertical-align : middle">
        <a title="Open Red list. Link will open a new window." href="javascript:openNewPage('http://www.redlist.org/search/search.php?freetext=<%=scientificNameURL%>&amp;modifier=phrase&amp;criteria=wholedb&amp;taxa_species=1&amp;redlistCategory%5B%5D=allex&amp;redlistAssessyear%5B%5D=all&amp;country%5B%5D=all&amp;aquatic%5B%5D=all&amp;regions%5B%5D=all&amp;habitats%5B%5D=all&amp;threats%5B%5D=all');">Redlist link</a>
      </td>
<%
      }
      if( "fishes".equalsIgnoreCase( factsheet.getSpeciesGroup() ) )
      {
        //genusName = (scientificName.indexOf(" ")>=0? scientificName.substring(0,scientificName.indexOf(" ")) : scientificName);
        String speciesName = (scientificName.trim().indexOf(" ")>=0? scientificName.trim().substring(scientificName.indexOf(" ") + 1) : scientificName);
%>
      <td width="20%" style="text-align : center; vertical-align : middle">
        <a title="Open Fishbase. Link will open a new window." href="javascript:openNewPage('http://www.fishbase.org/Summary/SpeciesSummary.cfm?genusname=<%=genusName%>&amp;speciesname=<%=Utilities.treatURLSpecialCharacters(speciesName)%>');">Fishbase link</a>
      </td>
<%
      }
%>

    </tr>
    <tr>
      <td width="20%" style="text-align : center; vertical-align : middle">
        <a title="Open Scirus. Link will open a new window." href="javascript:openNewPage('http://www.scirus.com/srsapp/search?q=%22<%=Utilities.treatURLSpecialCharacters(scientificName)%>%22&amp;ds=web&amp;g=s&amp;t=all')">SCIRUS</a>
      </td>
      <td width="20%" style="text-align : center; vertical-align : middle">
        <a title="Open Biology browser. Link will open a new window." href="javascript:openNewPage('http://www.biologybrowser.org/cgi-bin/search/hyperseek.cgi?Terms=<%=Utilities.treatURLSpecialCharacters(scientificName)%>')">Biology Browser</a>
      </td>
      <td width="20%" style="text-align : center; vertical-align : middle">
        <a title="Open NCBI Taxonomy browser. Link will open a new window." href="javascript:openNewPage('http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?doptcmdl=ExternalLink&amp;cmd=Search&amp;db=taxonomy&amp;term=<%=Utilities.treatURLSpecialCharacters(scientificName)%>')">NCBI Taxonomy browser</a>
      </td>
    </tr>
  </table>
  <table summary="layout" width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr style="background-color:#DDDDDD">
      <td colspan="2">
        <strong>
          <%=contentManagement.getContent("species_factsheet_source")%>
        </strong>
      </td>
    </tr>
<%
    PublicationWrapper book = factsheet.getSpeciesBook();
%>
    <tr style="background-color:#EEEEEE">
      <td width="18%">
        <%=contentManagement.getContent("species_factsheet_srcTitle")%>:
      </td>
      <td width="70%">
        <strong>
          <%=Utilities.treatURLSpecialCharacters(book.getTitle())%>
        </strong>
      </td>
    </tr>
    <tr style="background-color:#EEEEEE">
      <td>
        <%=contentManagement.getContent("species_factsheet_srcAuthor")%>:
      </td>
      <td>
        <strong>
          <%=Utilities.treatURLSpecialCharacters(book.getAuthor())%>
        </strong>
      </td>
    </tr>
    <tr style="background-color:#EEEEEE">
      <td>
        <%=contentManagement.getContent("species_factsheet_srcPublisher")%>:
      </td>
      <td>
        <strong>
          <%=Utilities.treatURLSpecialCharacters(book.getPublisher())%>
        </strong>
      </td>
    </tr>
    <tr style="background-color:#EEEEEE">
      <td>
        <%=contentManagement.getContent("species_factsheet_srcPublication")%>:
      </td>
      <td>
        <strong>
          <%=book.getDate()%>
        </strong>
      </td>
    </tr>
    <tr style="background-color:#EEEEEE">
      <td>
        <%=contentManagement.getContent("species_factsheet_srcURL")%>:
      </td>
      <td>
<%
      if(book.getURL().length()>0)
      {
%>
        <a title="Open URL. Link will open a new window." target="_blank" href="<%=Utilities.treatURLSpecialCharacters(book.getURL().replaceAll("#",""))%>"><%=Utilities.treatURLSpecialCharacters(book.getURL().replaceAll("#",""))%></a>
<%
      }
      else
      {
%>
        &nbsp;
<%
      }
%>
      </td>
    </tr>
  </table>
<%
  // Synonyms list.
  List synonyms = factsheet.getSynonymsIterator();
  if (!synonyms.isEmpty())
  {
%>
  <br />
  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr style="background-color:#CCCCCC">
      <td>
        <strong>
          <%=contentManagement.getContent("species_factsheet_synonyms")%>
        </strong>
      </td>
    </tr>
  </table>
  <table summary="List of synonyms" width="100%" border="1" cellspacing="1" cellpadding="0" id="synTable" style="border-collapse:collapse">
    <tr style="background-color:#DDDDDD">
      <th class="resultHeaderForFactsheet" width="40%" style="text-align:left;background-color:#DDDDDD">
        <strong>
          <a title="Sort by scientific name" href="javascript:sortTable(2,0, 'synTable', false);"><%=contentManagement.getContent("species_factsheet_synScientificName")%></a>
        </strong>
      </th>
      <th class="resultHeaderForFactsheet" width="60%" style="text-align:left;background-color:#DDDDDD">
        <strong>
          <a title="Sort by author" href="javascript:sortTable(2,1, 'synTable', false);"><%=contentManagement.getContent("species_factsheet_synAuthor")%></a>
        </strong>
      </th>
    </tr>
<%
    for ( int i = 0; i < synonyms.size(); i++ )
    {
      SpeciesNatureObjectPersist synonym = (SpeciesNatureObjectPersist)synonyms.get(i);%>
      <tr style="background-color:<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
        <td width="40%">
<%
        if(synonym.getIdSpecies().intValue() == Utilities.checkedStringToInt(factsheet.getIdSpecies().toString(), 0))
        {
%>
          <strong style="color : #C30000; font-style : italic; ">
            <%=Utilities.treatURLSpecialCharacters(synonym.getScientificName())%>
          </strong>
<%
        }
        else
        {
%>
          <%=Utilities.treatURLSpecialCharacters(synonym.getScientificName())%>
<%
        }
%>
        </td>
        <td width="30%">
          <%=Utilities.treatURLSpecialCharacters(synonym.getAuthor())%>
        </td>
      </tr>
<%
    }
%>
 </table>
<%
  }
%>
<%
  // Subspecies list.
  List subSpecies = factsheet.getSubspecies();
  if (!subSpecies.isEmpty())
  {
%>
  <br />
  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr style="background-color:#CCCCCC">
      <td>
        <strong>
          <%=contentManagement.getContent("species_factsheet_validSubspecies")%>
        </strong>
      </td>
    </tr>
  </table>
  <table summary="List of subspecies" width="100%" border="1" cellspacing="1" cellpadding="0"  id="validSubspec" style="border-collapse:collapse">
    <tr style="background-color:#DDDDDD">
      <th class="resultHeaderForFactsheet" width="40%" style="background-color:#DDDDDD">
        <a title="Sort by scientific name" href="javascript:sortTable(2,0, 'validSubspec', false);"><strong><%=contentManagement.getContent("species_factsheet_subspeciesSciName")%></strong></a>
      </th>
      <th class="resultHeaderForFactsheet" width="60%" style="background-color:#DDDDDD">
        <a title="Sort by source" href="javascript:sortTable(2,1, 'validSubspec', false);"><%=contentManagement.getContent("species_factsheet_subspeciesSource")%></a>
      </th>
    </tr>
<%
    for (int i = 0; i < subSpecies.size(); i++)
    {
      SpeciesNatureObjectPersist species = (SpeciesNatureObjectPersist)subSpecies.get(i);
%>
    <tr style="background-color:<%=(0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
      <td>
        <span style="font-style : italic;">
          <%=Utilities.treatURLSpecialCharacters(species.getScientificName())%>
        </span>
        (<%=Utilities.treatURLSpecialCharacters(species.getAuthor())%>)
      </td>
      <td>
        <%=Utilities.treatURLSpecialCharacters(SpeciesFactsheet.getBookAuthorDate(species.getIdDublinCore()))%>
      </td>
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
<%
  // Species pictures
      List listPictures = factsheet.getPicturesForSpecies();
      String urlPic="idobject="+specie.getIdSpecies()+"&amp;natureobjecttype=Species";

      if(null != listPictures && listPictures.size() > 0)
      {
%>
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td style="text-align:left">
              <a title="View pictures. Link will open a new window." href="javascript:openpictures('pictures.jsp?<%=urlPic%>',600,600)"><%=contentManagement.getContent("species_factsheet_viewpics")%></a>
            </td>
          </tr>
        </table>
<%
      }
      else if ( SessionManager.isAuthenticated() )
      {
%>
        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td style="text-align:left">
              <a title="Upload pictures. Link will open a new window." href="javascript:openpictures('pictures-upload.jsp?operation=upload&amp;<%=urlPic%>',600,600)"><%=contentManagement.getContent("species_factsheet_uploadpics")%></a>
            </td>
          </tr>
        </table>
<%
      }
%>
      <br />
      <br />