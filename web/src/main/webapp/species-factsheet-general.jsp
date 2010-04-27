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
                 java.util.StringTokenizer,
                 java.util.ArrayList,
                 eionet.eunis.util.Constants"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// Request parameters:
  // idSpecies - ID of specie
  String mainIdSpecies = request.getParameter("mainIdSpecies");
  String mainPictureFilename = request.getParameter("mainPictureFilename");
  String mainPictureDescription = request.getParameter("mainPictureDescription");
  String mainPictureMaxWidth = request.getParameter("mainPictureMaxWidth");
  String mainPictureMaxHeight = request.getParameter("mainPictureMaxHeight");
  Integer mainPictureMaxWidthInt = Utilities.checkedStringToInt(mainPictureMaxWidth, new Integer(0));
  Integer mainPictureMaxHeightInt = Utilities.checkedStringToInt(mainPictureMaxHeight, new Integer(0));
  String pictureSource = request.getParameter("pictureSource");
  SpeciesFactsheet factsheet = new SpeciesFactsheet(
		  Utilities.checkedStringToInt(mainIdSpecies, new Integer(0)),
		  Utilities.checkedStringToInt(mainIdSpecies, new Integer(0)));

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
  String urlPic="idobject="+specie.getIdSpecies()+"&amp;natureobjecttype=Species";
  String picturePath = application.getInitParameter("UPLOAD_DIR_PICTURES_SPECIES");
  
  //List of species international threat status.
  List consStatus = new ArrayList();
  try
  {
    consStatus = factsheet.getConservationStatus(factsheet.getSpeciesObject());
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }
  
%>
  <% if (mainPictureFilename != null && mainPictureFilename.length() > 0)  { %>
  <div class="naturepic-plus-container naturepic-right">
	  <div class="naturepic-plus">
	    <div class="naturepic-image">
	    	<%
	    		if(mainPictureDescription == null){
	    			mainPictureDescription = scientificName;
	    		}
	    			
	    		String styleAttr = "max-width:300px; max-height:400px;";
	    		if(mainPictureMaxWidthInt != null && mainPictureMaxWidthInt.intValue() > 0 && mainPictureMaxHeightInt != null && mainPictureMaxHeightInt.intValue() > 0){
		    		styleAttr = "max-width: "+mainPictureMaxWidthInt.intValue()+"px; max-height: "+mainPictureMaxHeightInt.intValue()+"px";
	    		}
	    	%>
		    <a href="javascript:openpictures('pictures.jsp?<%=urlPic%>',600,600)"">
		    	<img src="<%=picturePath + "/"+ mainPictureFilename %>" alt="<%=mainPictureDescription%>" class="scaled" style="<%=styleAttr%>"/>
		    </a>
	    </div>
	    <div class="naturepic-note">
              <%=mainPictureDescription %>
	    </div>
	    <% if(pictureSource != null && pictureSource.length() > 0){%>
		<div class="naturepic-source-copyright">
		<%=cm.cmsPhrase("Source")%>: <%=pictureSource%>
		</div>
	    <%}%>
	  </div>
  </div>
  <% } %>
  <div class="allow-naturepic">
  <table class="datatable fullwidth">
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
        String cssClass = i++ % 2 == 0 ? "zebraodd" : "zebraeven";
        StringTokenizer sts = new StringTokenizer(st.nextToken(),"*");
        String classification_id = sts.nextToken();
        String classification_level = sts.nextToken();
        String classification_name = sts.nextToken();
%>
      <tr class="<%=cssClass%>">
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

  
  <h2><%=cm.cmsPhrase("External links")%></h2>
  <div id="linkcollection">
      <div>
        <a title="<%=cm.cmsPhrase("Pictures of the species on Google")%>" href="http://images.google.com/images?q=<%=Utilities.treatURLSpecialCharacters(scientificName)%>"><%=cm.cmsPhrase("Pictures on Google")%></a>
      </div>
<%
      String gbifLink = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SYNONYM_GBIF);//specie.getScientificName();
      //gbifLink = gbifLink.replaceAll( "\\.", "" );
      if(gbifLink != null && gbifLink.length() > 0){
//      gbifLink = gbifLink.replaceAll( " ", "\\." );
%>
      <div>
        <a href="http://data.gbif.org/species/<%=gbifLink%>"><%=cm.cmsPhrase("GBIF page")%></a>
      </div>
      <% } else {
    	  	String gbifLink2 = specie.getScientificName();
	      	gbifLink2 = gbifLink2.replaceAll( "\\.", "" );
	      	gbifLink2 = URLEncoder.encode(gbifLink2,"UTF-8");
			//gbifLink2 = gbifLink2.replaceAll( " ", "\\." );
	  %>
	  <div>
        <a href="http://data.gbif.org/species/<%=gbifLink2%>"><%=cm.cmsPhrase("GBIF search")%></a>
      </div>

<%
	  }
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
      <div>
        <a title="<%=cm.cmsPhrase("Search species on UNEP-WCMC")%>" href="http://sea.unep-wcmc.org/isdb/species.cfm?source=<%=kingdomname%>&amp;genus=<%=genus%>&amp;species=<%=Utilities.treatURLSpecialCharacters(spname)%>"><%=cm.cmsPhrase("UNEP-WCMC search")%></a>
      </div>
<%
      }
      String rl_id = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SPECIES_REDLIST);
      if(rl_id != null && rl_id.length() > 0){
    		%>
		<div>
        		<a href="http://www.iucnredlist.org/apps/redlist/details/<%=rl_id%>/0"><%=cm.cmsPhrase("IUCN Red List page")%></a>
		</div>
		<%
      } else {
	// List of species national threat status.
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
		  <div>
		  <a href="http://www.iucnredlist.org/apps/redlist/search/external?text=<%=scientificNameURL%>&amp;mode="><%=cm.cmsPhrase("IUCN Red List search")%></a>
		  </div>
  <%
	}
      }
      if( "fishes".equalsIgnoreCase( factsheet.getSpeciesGroup() ) )
      {
        //genusName = (scientificName.indexOf(" ")>=0? scientificName.substring(0,scientificName.indexOf(" ")) : scientificName);
        String speciesName = (scientificName.trim().indexOf(" ")>=0? scientificName.trim().substring(scientificName.indexOf(" ") + 1) : scientificName);
%>
	<div>
		<a title="<%=cm.cmsPhrase("Search species on Fishbase")%>" href="http://www.fishbase.de/Summary/SpeciesSummary.php?genusname=<%=genusName%>&amp;speciesname=<%=Utilities.treatURLSpecialCharacters(speciesName)%>"><%=cm.cmsPhrase("Fishbase search")%></a>
	</div>
<%
      }

	// World Register of Marine Species - also has seals etc.
	String wormsid = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SYNONYM_WORMS);
	if(wormsid != null && wormsid.length() > 0){
	%>
	<div>
		<a href="http://www.marinespecies.org/aphia.php?p=taxdetails&amp;id=<%=wormsid%>" title="World Register of Marine Species page"><%=cm.cmsPhrase("WorMS page")%></a>
	</div>
	<%
	}
	%>

	<div>
        <a title="<%=cm.cmsPhrase("Search species on SCIRUS")%>" href="http://www.scirus.com/srsapp/search?q=%22<%=Utilities.treatURLSpecialCharacters(scientificName)%>%22&amp;ds=web&amp;g=s&amp;t=all"><%=cm.cmsPhrase("SCIRUS search")%></a>
	</div>
<%
if(kingdomname.equalsIgnoreCase("Animals"))
{
	String faeu = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SYNONYM_FAEU);
	if(faeu != null && faeu.length() > 0){
    		%>
		<div>
        		<a href="http://www.faunaeur.org/full_results.php?id=<%=faeu%>"><%=cm.cmsPhrase("Fauna Europaea page")%></a>
		</div>
		<%
	} else {
		sn = scientificName;
		sn=sn.replaceAll("sp.","").replaceAll("ssp.","");
		pos = -1;
		pos = sn.indexOf( " " );
		if( pos >= 0 )
		{
			genus=sn.substring(0, pos).trim();
			spname=sn.substring(pos+1).trim();
%>
	<div>
		<a title="<%=cm.cmsPhrase("Search species on Fauna Europaea")%>" href="http://www.faunaeur.org/index.php?show_what=search%20results&amp;genus=<%=genus%>&amp;species=<%=spname%>"><%=cm.cmsPhrase("Fauna Europaea")%></a>
	</div>
<%
		}
	}
}
%>
    		<%
    		String biolibLink = factsheet.getLink(specie.getIdNatureObject(),Constants.BIOLIB_PAGE);
			if(biolibLink != null && biolibLink.length() > 0){
    		%>
		<div>
        		<a href="<%=biolibLink%>"><%=cm.cmsPhrase("Biolib page")%></a>
		</div>
        	<%
    		}
        	%>
    		<%
    		String itisTSN = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SYNONYM_ITIS);
			if(itisTSN != null && itisTSN.length() > 0){
    		%>
		<div>
        		<a href="http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&amp;search_value=<%=itisTSN%>"><%=cm.cmsPhrase("ITIS TSN:")%><%=itisTSN%></a>
		</div>
		<%
    		}
        	%>
    		<%
    		String ncbi = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SYNONYM_NCBI);
			if(ncbi != null && ncbi.length() > 0){
    		%>
		<div>
        		<a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=<%=ncbi%>&amp;lvl=0"><%=cm.cmsPhrase("NCBI:")%><%=ncbi%></a>
		</div>
        	<%
    		} else {
		%>
		<div>
			<a title="<%=cm.cmsPhrase("Search species on NCBI Taxonomy browser")%>" href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?doptcmdl=ExternalLink&amp;cmd=Search&amp;db=taxonomy&amp;term=<%=Utilities.treatURLSpecialCharacters(scientificName)%>"><%=cm.cmsPhrase("NCBI Taxonomy search")%></a>
		</div>
    		<%
		}
    		String bbcLink = factsheet.getLink(specie.getIdNatureObject(),Constants.BBC_PAGE);
			if(bbcLink != null && bbcLink.length() > 0){
    		%>
		<div>
        		<a href="<%=bbcLink%>"><%=cm.cmsPhrase("BBC page")%></a>
		</div>
        	<%
    		}
        	%>
    		<%
    		String wikiLink = factsheet.getLink(specie.getIdNatureObject(),Constants.WIKIPEDIA_ARTICLE);
			if(wikiLink != null && wikiLink.length() > 0){
    		%>
		<div>
        		<a href="<%=wikiLink%>"><%=cm.cmsPhrase("Wikipedia article")%></a>
		</div>
        	<%
    		}
        	%>
    		<%
    		String wikispeciesLink = factsheet.getLink(specie.getIdNatureObject(),Constants.WIKISPECIES_ARTICLE);
			if(wikispeciesLink != null && wikispeciesLink.length() > 0){
    		%>
		<div>
        		<a href="<%=wikispeciesLink%>"><%=cm.cmsPhrase("Wikispecies article")%></a>
		</div>
        	<%
    		}
        	%>
        	<%
    		String bugGuideLink = factsheet.getLink(specie.getIdNatureObject(),Constants.BUG_GUIDE);
			if(bugGuideLink != null && bugGuideLink.length() > 0){
    		%>
		<div>
        		<a href="<%=bugGuideLink%>"><%=cm.cmsPhrase("Bug Guide page")%></a>
		</div>
        	<%
    		}
        	%>
  </div> <!-- linkcollection -->
</div> <!-- allow-naturepic -->
	<%
	    // International threat status
	    if( consStatus.size() > 0 )
	    {
	%>
	  <br/><br/><br/>
	  <h2 style="clear: both">
	    <%=cm.cmsPhrase("International Threat Status")%>
	  </h2>
	  <table summary="<%=cm.cms("international_threat_status")%>" class="listing fullwidth">
	    <col style="width: 20%"/>
	    <col style="width: 20%"/>
	    <col style="width: 20%"/>
	    <col style="width: 40%"/>
	    <thead>
	      <tr>
	        <th scope="col">
	          <%=cm.cmsPhrase("Area")%>
	          <%=cm.cmsTitle("sort_results_on_this_column")%>
	        </th>
	        <th scope="col">
	          <%=cm.cmsPhrase("Status")%>
	          <%=cm.cmsTitle("sort_results_on_this_column")%>
	        </th>
	        <th scope="col">
	          <%=cm.cmsPhrase("International threat code")%>
	          <%=cm.cmsTitle("sort_results_on_this_column")%>
	        </th>
	        <th scope="col">
	          <%=cm.cmsPhrase("Reference")%>
	          <%=cm.cmsTitle("sort_results_on_this_column")%>
	        </th>
	      </tr>
	    </thead>
	    <tbody>
	<%
	       // Display results.
	      for (int i = 0; i < consStatus.size(); i++)
	      {
	        String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
	        NationalThreatWrapper threat = (NationalThreatWrapper)consStatus.get(i);
	%>
	      <tr class="<%=cssClass%>">
	        <td>
	          <%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>
	        </td>
	        <td>
	          <%=Utilities.treatURLSpecialCharacters(threat.getStatus())%>
	        </td>
	        <td>
	        <span class="boldUnderline" title="<%=factsheet.getConservationStatusDescriptionByCode(threat.getThreatCode()).replaceAll("'"," ").replaceAll("\""," ")%>">
	          <%=threat.getThreatCode()%>
	        </span>
	        </td>
	        <td>
	          <a href="documents/<%=threat.getIdDc()%>"><%=Utilities.treatURLSpecialCharacters(threat.getReference())%></a>
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
  <%=cm.br()%>
  <%=cm.cmsMsg("national_threat_status")%>
  <%=cm.br()%>
  <%=cm.cmsMsg("international_threat_status")%>
  <br />
  <h2 style="clear: both">
    <%=cm.cmsPhrase("Source")%>
  </h2>
  <table summary="layout" class="datatable fullwidth">
    <col style="width:20%"/>
    <col style="width:80%"/>
    <tbody>
<%
    PublicationWrapper book = factsheet.getSpeciesBook();
%>
      <tr>
        <td>
          <%=cm.cmsPhrase("Title")%>:
        </td>
        <td>
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
          <a href="<%=Utilities.treatURLSpecialCharacters(book.getURL().replaceAll("#",""))%>"><%=Utilities.treatURLSpecialCharacters(book.getURL().replaceAll("#",""))%></a>
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
  <table summary="<%=cm.cms("species_factsheet_10_Sum")%>" class="listing fullwidth">
    <col style="width:40%"/>
    <col style="width:60%"/>
    <thead>
      <tr>
        <th scope="col">
          <%=cm.cmsPhrase("Scientific name")%>
          <%=cm.cmsTitle("sort_by_column")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Author")%>
          <%=cm.cmsTitle("sort_by_column")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
    for ( int i = 0; i < synonyms.size(); i++ )
    {
      String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
      SpeciesNatureObjectPersist synonym = (SpeciesNatureObjectPersist)synonyms.get(i);%>
    <tr class="<%=cssClass%>">
      <td>
        <%=Utilities.treatURLSpecialCharacters(synonym.getScientificName())%>
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
  <table summary="<%=cm.cms("species_factsheet_11_Sum")%>" class="listing fullwidth">
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
          <a style="font-style : italic;" href="species/<%=species.getIdSpecies()%>"><%=Utilities.treatURLSpecialCharacters(species.getScientificName())%></a>
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

      if(null != listPictures && listPictures.size() > 0)
      {
%>
  <a href="javascript:openpictures('pictures.jsp?<%=urlPic%>',600,600)"><%=cm.cmsPhrase("View pictures")%></a>
<%
      }
      else if(SessionManager.isAuthenticated() && SessionManager.isUpload_pictures_RIGHT())
      {
%>
      <a href="javascript:openpictures('pictures-upload.jsp?operation=upload&amp;<%=urlPic%>',600,600)"><%=cm.cmsPhrase("Upload pictures")%></a>
<%
      }
%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet_10_Sum")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet_11_Sum")%>
  <br />
  <br />
