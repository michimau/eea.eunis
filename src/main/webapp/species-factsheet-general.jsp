<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - general info.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.List,
                 ro.finsiel.eunis.factsheet.species.NationalThreatWrapper,
                 ro.finsiel.eunis.search.species.factsheet.PublicationWrapper,
                 java.util.Vector,
                 java.net.URLEncoder,
                 ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodeDomain,
                 ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodePersist,
                 java.util.StringTokenizer"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// Request parameters:
  // idSpecies - ID of specie
  // idSpeciesLink - ID of specie (Link to species base)
  String idSpecies = request.getParameter("idSpecies");
  SpeciesFactsheet factsheet = new SpeciesFactsheet(
		  Utilities.checkedStringToInt(idSpecies, new Integer(0)),
		  Utilities.checkedStringToInt(idSpecies, new Integer(0)));

  SpeciesNatureObjectPersist specie = factsheet.getSpeciesNatureObject();
  String scientificName = specie.getScientificName();
  WebContentManagement cm = SessionManager.getWebContent();

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
  String kingdomname="";
%>
  <table summary="layout" class="datatable" width="90%">
    <thead>
      <tr>
        <th colspan="2">
          <%=cm.cmsPhrase("Taxonomic information")%>
        </th>
        <th>
          <%=cm.cmsPhrase("Reference")%>
        </th>
      </tr>
    </thead>
    <tbody>
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
      int i = 0;
      while(st.hasMoreTokens())
      {
        String cssClass = i++ % 2 == 0 ? "" : " class=\"zebraeven\"";
        StringTokenizer sts = new StringTokenizer(st.nextToken(),"*");
        String classification_id = sts.nextToken();
        String classification_level = sts.nextToken();
        String classification_name = sts.nextToken();
%>
      <tr<%=cssClass%>>
        <td width="20%">
          <%=classification_level%>
        </td>
        <td width="40%">
          <strong>
            <%=classification_name%>
          </strong>
        </td>
<%
        if(classification_level.equalsIgnoreCase("kingdom"))
        {
          kingdomname=classification_name;
%>
        <td rowspan="<%=st.countTokens()+2%>" style="text-align:center; background-color:#EEEEEE; vertical-align:middle;">
          <strong>
            <%=Utilities.treatURLSpecialCharacters(authorDate)%>
          </strong>
        </td>
<%
        }
%>
      </tr>
<%
      }
    }
%>
      <tr class="zebraeven">
        <td width="20%">
          <%=cm.cmsPhrase("Genus")%>
        </td>
        <td width="40%">
          <strong>
            <%=genusName%>
          </strong>
        </td>
      </tr>
    </tbody>
  </table>
  <table summary="layout" width="90%" border="0" cellspacing="5" cellpadding="5">
    <tr>
      <td width="20%" style="text-align : left; vertical-align : middle">
        <a title="<%=cm.cmsPhrase("Pictures of the species on Google")%>" href="http://images.google.com/images?q=<%=Utilities.treatURLSpecialCharacters(scientificName)%>"><%=cm.cmsPhrase("Pictures on Google")%></a>
      </td>
      <td width="20%" style="text-align : left; vertical-align : middle">
<%
      String gbifLink = specie.getScientificName();
      gbifLink = gbifLink.replaceAll( "\\.", "" );
      gbifLink = URLEncoder.encode(gbifLink,"UTF-8");
//      gbifLink = gbifLink.replaceAll( " ", "\\." );
%>
        <a title="<%=cm.cmsPhrase("Search species on GBIF")%>" href="http://data.gbif.org/species/<%=gbifLink%>"><%=cm.cmsPhrase("GBIF link")%></a>
      </td>
      <td width="20%" style="text-align : left; vertical-align : middle">
<%
      String sn = scientificName;
      sn=sn.replaceAll("sp.","").replaceAll("ssp.","");
      String genus="";
      String spname="";

//      String taxonomy = specie.getIdTaxcode().substring( 0, 2 );
//      if( taxonomy.equalsIgnoreCase( "1" ) ) kingdomname = "Animals";
//      if( taxonomy.equalsIgnoreCase( "2" ) ) kingdomname = "Plants";
      //if( taxonomy.equalsIgnoreCase( "3" ) ) kingdomname = "Mushrooms";

    if( kingdomname.equalsIgnoreCase( "Animalia" ) ) kingdomname = "Animals";
    if( kingdomname.equalsIgnoreCase( "Plantae" ) ) kingdomname = "Plants";
    if( kingdomname.equalsIgnoreCase( "Fungi" ) ) kingdomname = "Mushrooms";

      int pos = -1;
      pos = sn.indexOf( " " );
      if( pos >= 0 )
      {
        //System.out.println("taxonomy");
        genus=sn.substring(0, pos);
        spname=sn.substring(pos+1);
%>
        <a title="<%=cm.cmsPhrase("Search species on UNEP-WCMC")%>" href="http://sea.unep-wcmc.org/isdb/species.cfm?source=<%=kingdomname%>&amp;genus=<%=genus%>&amp;species=<%=Utilities.treatURLSpecialCharacters(spname)%>"><%=cm.cmsPhrase("UNEP-WCMC link")%></a>
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
          if(threat.getReference() != null && threat.getReference().indexOf("IUCN")>=0)
          {
            isGood = true;
            break;
          }
        }
      }
      if( isGood )
      {
        String scientificNameURL = scientificName.replace(' ','+');
%>
      <td width="20%" style="text-align : left; vertical-align : middle">
        <a title="<%=cm.cmsPhrase("Search species on Redlist site")%>" href="http://www.redlist.org/apps/redlist/search/external?text=<%=scientificNameURL%>&amp;mode="><%=cm.cmsPhrase("Redlist link")%></a>
      </td>
<%
      }
      if( "fishes".equalsIgnoreCase( factsheet.getSpeciesGroup() ) )
      {
        //genusName = (scientificName.indexOf(" ")>=0? scientificName.substring(0,scientificName.indexOf(" ")) : scientificName);
        String speciesName = (scientificName.trim().indexOf(" ")>=0? scientificName.trim().substring(scientificName.indexOf(" ") + 1) : scientificName);
%>
      <td width="20%" style="text-align : left; vertical-align : middle">
        <a title="<%=cm.cmsPhrase("Search species on Fishbase")%>" href="http://www.fishbase.org/Summary/SpeciesSummary.cfm?genusname=<%=genusName%>&amp;speciesname=<%=Utilities.treatURLSpecialCharacters(speciesName)%>"><%=cm.cmsPhrase("Fishbase link")%></a>
      </td>
<%
      }
%>

    </tr>
    <tr>
      <td width="20%" style="text-align : left; vertical-align : middle">
        <a title="<%=cm.cmsPhrase("Search species on SCIRUS")%>" href="http://www.scirus.com/srsapp/search?q=%22<%=Utilities.treatURLSpecialCharacters(scientificName)%>%22&amp;ds=web&amp;g=s&amp;t=all"><%=cm.cmsPhrase("SCIRUS")%></a>
      </td>
      <td width="20%" style="text-align : left; vertical-align : middle">
        <a title="<%=cm.cmsPhrase("Search species on Biology Browser")%>" href="http://www.biologybrowser.org/search/apachesolr_search/<%=Utilities.treatURLSpecialCharacters(scientificName)%>"><%=cm.cmsPhrase("Biology Browser")%></a>
      </td>
      <td width="20%" style="text-align : left; vertical-align : middle">
        <a title="<%=cm.cmsPhrase("Search species on NCBI Taxonomy browser")%>" href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?doptcmdl=ExternalLink&amp;cmd=Search&amp;db=taxonomy&amp;term=<%=Utilities.treatURLSpecialCharacters(scientificName)%>"><%=cm.cmsPhrase("NCBI Taxonomy browser")%></a>
      </td>
      <td width="20%" style="text-align : left; vertical-align : middle">
<%
if(kingdomname.equalsIgnoreCase("Animals"))
{
      sn = scientificName;
      sn=sn.replaceAll("sp.","").replaceAll("ssp.","");
      pos = -1;
      pos = sn.indexOf( " " );
      if( pos >= 0 )
      {
        genus=sn.substring(0, pos).trim();
        spname=sn.substring(pos+1).trim();
%>
        <a title="<%=cm.cmsPhrase("Search species on Fauna Europaea")%>" href="http://www.faunaeur.org/index.php?show_what=search%20results&amp;genus= <%=genus%> &amp;species= <%=spname%>"><%=cm.cmsPhrase("Fauna Europaea")%></a>
<%
      }
      else
      {
%>
        &nbsp;
<%
      }
    } else {
%>
    &nbsp;
<%
    }
%>
    </td>
    </tr>
  </table>
  <h2>
    <%=cm.cmsPhrase("Source")%>
  </h2>
  <table summary="layout" class="datatable" width="90%">
    <tbody>
<%
    PublicationWrapper book = factsheet.getSpeciesBook();
%>
      <tr>
        <td width="18%">
          <%=cm.cmsPhrase("Title")%>:
        </td>
        <td width="70%">
          <strong>
            <%=Utilities.treatURLSpecialCharacters(book.getTitle())%>
          </strong>
        </td>
      </tr>
      <tr class="zebraeven">
        <td>
          <%=cm.cmsPhrase("Author")%>:
        </td>
        <td>
          <strong>
            <%=Utilities.treatURLSpecialCharacters(book.getAuthor())%>
          </strong>
        </td>
      </tr>
      <tr>
        <td>
          <%=cm.cmsPhrase("Publisher")%>:
        </td>
        <td>
          <strong>
            <%=Utilities.treatURLSpecialCharacters(book.getPublisher())%>
          </strong>
        </td>
      </tr>
      <tr class="zebraeven">
        <td>
          <%=cm.cmsPhrase("Publication date")%>:
        </td>
        <td>
          <strong>
            <%=book.getDate()%>
          </strong>
        </td>
      </tr>
      <tr>
        <td>
          <%=cm.cmsPhrase("Url")%>:
        </td>
        <td>
<%
      if(book.getURL().length()>0)
      {
%>
          <a title="<%=cm.cms("species_factsheet_14_Title")%>" target="_blank" href="<%=Utilities.treatURLSpecialCharacters(book.getURL().replaceAll("#",""))%>"><%=Utilities.treatURLSpecialCharacters(book.getURL().replaceAll("#",""))%></a>
          <%=cm.cmsTitle("species_factsheet_14_Title")%>
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
    </tbody>
  </table>
<%
  // Synonyms list.
  List synonyms = factsheet.getSynonymsIterator();
  if (!synonyms.isEmpty())
  {
%>
  <br />
  <h2>
    <%=cm.cmsPhrase("Synonyms")%>
  </h2>
  <table summary="<%=cm.cms("species_factsheet_10_Sum")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th width="40%" style="text-align:left;">
          <%=cm.cmsPhrase("Scientific name")%>
          <%=cm.cmsTitle("sort_by_column")%>
        </th>
        <th width="60%" style="text-align:left;">
          <%=cm.cmsPhrase("Author")%>
          <%=cm.cmsTitle("sort_by_column")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
    for ( int i = 0; i < synonyms.size(); i++ )
    {
      String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
      SpeciesNatureObjectPersist synonym = (SpeciesNatureObjectPersist)synonyms.get(i);%>
    <tr <%=cssClass%>>
      <td>
<%
      if(synonym.getIdSpecies().intValue() == Utilities.checkedStringToInt(idSpecies, 0))
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
        <td>
          <%=Utilities.treatURLSpecialCharacters(synonym.getAuthor())%>
        </td>
      </tr>
<%
    }
%>
    </tbody>
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
  <h2>
    <%=cm.cmsPhrase("Valid subspecies in Europe")%>
  </h2>
  <table summary="<%=cm.cms("species_factsheet_11_Sum")%>" class="listing" width="90%">
    <col style="width:40%"/>
    <col style="width:60%"/>
    <thead>
      <tr>
        <th>
          <%=cm.cmsPhrase("Scientific name")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th>
          <%=cm.cmsPhrase("Source")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
    for (int i = 0; i < subSpecies.size(); i++)
    {
      String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
      SpeciesNatureObjectPersist species = (SpeciesNatureObjectPersist)subSpecies.get(i);
%>
      <tr class="<%=cssClass%>">
        <td>
          <a style="font-style : italic;" href="species-factsheet.jsp?idSpecies=<%=species.getIdSpecies()%>&amp;idSpeciesLink=<%=species.getIdSpeciesLink()%>"><%=Utilities.treatURLSpecialCharacters(species.getScientificName())%></a>
          <%=Utilities.treatURLSpecialCharacters(species.getAuthor())%>
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(SpeciesFactsheet.getBookAuthorDate(species.getIdDublinCore()))%>
        </td>
      </tr>
<%
    }
%>
    </tbody>
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
  <a title="<%=cm.cms("species_factsheet_12_Title")%>" href="javascript:openpictures('pictures.jsp?<%=urlPic%>',600,600)"><%=cm.cmsPhrase("View pictures")%></a>
  <%=cm.cmsTitle("species_factsheet_12_Title")%>
<%
      }
      else if ( SessionManager.isAuthenticated() )
      {
%>
      <a title="<%=cm.cms("species_factsheet_13_Title")%>" href="javascript:openpictures('pictures-upload.jsp?operation=upload&amp;<%=urlPic%>',600,600)"><%=cm.cmsPhrase("Upload pictures")%></a>
        <%=cm.cmsTitle("species_factsheet_13_Title")%>
<%
      }
%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet_10_Sum")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet_11_Sum")%>
  <br />
  <br />
