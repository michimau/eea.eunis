package ro.finsiel.eunis.factsheet.species;

import org.apache.log4j.Logger;
import ro.finsiel.eunis.jrfTables.*;
import ro.finsiel.eunis.jrfTables.species.VernacularNamesDomain;
import ro.finsiel.eunis.jrfTables.species.VernacularNamesPersist;
import ro.finsiel.eunis.jrfTables.species.factsheet.*;
import ro.finsiel.eunis.jrfTables.species.habitats.HabitatsNatureObjectReportTypeSpeciesDomain;
import ro.finsiel.eunis.jrfTables.species.habitats.HabitatsNatureObjectReportTypeSpeciesPersist;
import ro.finsiel.eunis.search.CountryUtil;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.factsheet.PublicationWrapper;

import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

/**
 * This is the factsheet generator for the species's factsheet.
 *
 * @author finsiel
 */
public class SpeciesFactsheet {
  // ID_SPECIES from CHM62EDT_SPECIES
  private Integer idSpecies = null;
  // ID_SPECIES_LINK from CHM62EDT_SPECIES
  private Integer idSpeciesLink = null;
  // Species object from database
  private Chm62edtSpeciesPersist speciesObject = null;
  // Taxonomic information for this species
  private FactsheetTaxcode taxcodeObject = null;
  // Species' nature object
  private SpeciesNatureObjectPersist speciesNatureObject = null;

  // Specifies if this factsheet exists or is invalid (species does not exists within DB)
  private boolean exists = false;

  // Log4J logger used for logging system
  private static Logger logger = Logger.getLogger( SpeciesFactsheet.class );

  /**
   * Creates a new SpeciesFactsheet object.
   *
   * @param idSpecies     ID_SPECIES from CHM62EDT_SPECIES.
   * @param idSpeciesLink ID_SPECIES_LINK from CHM62EDT_SPECIES.
   */
  public SpeciesFactsheet( Integer idSpecies, Integer idSpeciesLink ) {
    this.idSpecies = idSpecies;
    this.idSpeciesLink = idSpeciesLink;
    // Species object
    List species;
    try
    {
      species = new Chm62edtSpeciesDomain().findWhere( "ID_SPECIES = " + idSpeciesLink );
      if ( null != species && species.size() > 0 )
      {
        speciesObject = ( ( Chm62edtSpeciesPersist ) species.get( 0 ) );
        this.idSpecies = speciesObject.getIdSpecies();
        this.idSpeciesLink = speciesObject.getIdSpeciesLink();
        exists = true;
      }
      else
      {
        if ( idSpecies != idSpeciesLink )
        {// Search again only if idSpecies != idSpeciesLink
          species = new Chm62edtSpeciesDomain().findWhere( "ID_SPECIES = " + idSpecies );
          if ( null != species && species.size() > 0 )
          {
            speciesObject = ( ( Chm62edtSpeciesPersist ) species.get( 0 ) );
            this.idSpecies = speciesObject.getIdSpecies();
            this.idSpeciesLink = speciesObject.getIdSpeciesLink();
            exists = true;
          }
          else
          {
            logger.info( "Warning " + SpeciesFactsheet.class.getName() + "::ctor() - speciesObject not found: speciesObject is null" );
          }
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    // Taxcode object
    if ( exists() )
    {
      taxcodeObject = new FactsheetTaxcode( getSpeciesObject().getIdTaxcode() );
      // NatureObject
      try
      {
        species = new SpeciesNatureObjectDomain().findWhere( "ID_SPECIES='" + idSpeciesLink + "'" );
        if ( null != species && species.size() > 0 )
        {
          speciesNatureObject = ( SpeciesNatureObjectPersist ) species.get( 0 );
        }
        else
        {
          species = new SpeciesNatureObjectDomain().findWhere( "ID_SPECIES='" + idSpecies + "'" );
          if ( null != species && species.size() > 0 )
          {
            speciesNatureObject = ( SpeciesNatureObjectPersist ) species.get( 0 );
          }
        }
      }
      catch ( Exception _ex )
      {
        _ex.printStackTrace( System.err );
      }
    }
  }

  /**
   * Species description as a human readable string in englihs language.
   * @return Description of species scientific an vernacular name and localization
   * within Europe.
   */
  public String getSpeciesDescription() {
    String ret = "";
    String group = getSpeciesGroup();
    String vernacularName;
    String countries = "";
    List<FactSheetPopulationWrapper>countriesList = null;

    SpeciesNatureObjectPersist species = getSpeciesNatureObject();
    try
    {
      ret = species.getScientificName();
    }
    catch( Exception ex )
    {
      ex.printStackTrace();
    }

    // Vernacular name in English
    try
    {
      //search also on synonyms
      Vector<Integer> synonyms = new Vector<Integer>();
      Integer IdSpecie = null;
      synonyms.add( species.getIdNatureObject() );
      List<Chm62edtSpeciesPersist>lstSpeciesIDs = new Chm62edtSpeciesDomain().findWhere( "ID_NATURE_OBJECT=" + species.getIdNatureObject() );
      if ( lstSpeciesIDs.size() > 0 )
      {
        for ( Chm62edtSpeciesPersist lstSpeciesID : lstSpeciesIDs )
        {
          IdSpecie = lstSpeciesID.getIdSpecies();
        }
      }

      List<Chm62edtSpeciesPersist> lstSynonyms = new Chm62edtSpeciesDomain().findWhere( "TYPE_RELATED_SPECIES = 'Syn' and ID_SPECIES_LINK=" + IdSpecie );
      if ( lstSynonyms.size() > 0 )
      {
        for ( Chm62edtSpeciesPersist lstSynonym : lstSynonyms )
        {
          synonyms.add( lstSynonym.getIdNatureObject() );
        }
      }
      String IDs = "";
      for ( int k = 0; k < synonyms.size(); k++ )
      {
        IDs += synonyms.get( k ).toString();
        if ( k != ( synonyms.size() - 1 ) )
        {
          IDs += ",";
        }
      }
      List<VernacularNamesPersist> verNameList = new VernacularNamesDomain().findWhere( "NAME_EN='English' AND LOOKUP_TYPE='language' AND ID_NATURE_OBJECT IN (" + IDs + ") AND F.NAME='vernacular_name' GROUP BY F.VALUE, NAME_EN" );
      if ( !verNameList.isEmpty() )
      {
        vernacularName = verNameList.get( 0 ).getValue() + ", ";
        ret += " with the vernacular name " + vernacularName;
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }

    // Group
    if ( !group.equalsIgnoreCase( "" ) )
    {
      ret += " belongs to the " + group + " group";
    }

    try
    {
      countriesList = SpeciesFactsheet.getPopulation( getSpeciesObject().getIdNatureObject().toString() );
      int c = 1;
      for( FactSheetPopulationWrapper pop : countriesList )
      {
        countries += pop.getCountry();
        if(c != countriesList.size()) countries += ", ";
        c++;
      }
    }
    catch( Exception ex )
    {
      ex.printStackTrace();
    }

    if ( !countriesList.isEmpty() )
    {
      ret += " it is geographically distrubuted among the following countries/areas: " + countries;
    }
    return ret;
  }
  
  /**
   * Returns link to outside sources if one exists
   * @param nauture object ID, outside source name
   * @return link URL
   */
  public String getLink(Integer nature_object_id, String link_name){
	  String link = null;
	  List links = new Chm62edtNatureObjectAttributesDomain().findWhere("ID_NATURE_OBJECT="+nature_object_id+" AND NAME='"+link_name+"'");
	  if(links != null){
		  for(Object link1 : links){
			  Chm62edtNatureObjectAttributesPersist linkob = (Chm62edtNatureObjectAttributesPersist) link1;
			  if(linkob != null)
				  link = linkob.getObject();
		  }
	  }
	  return link;
  }

  /**
   * Get all the habitats where this species is found .
   *
   * @return A List of SpeciesHabitatWrapper objects.
   */
  public List getHabitatsForSpecies() {
    Vector<SpeciesHabitatWrapper> results = new Vector<SpeciesHabitatWrapper>();
    List habitats;
    try
    {
      String synonymsIDs = getSpeciesSynonymsCommaSeparated( getSpeciesNatureObject().getIdNatureObject(), getSpeciesNatureObject().getIdSpecies() );
      //System.out.println("synonymsIDs = " + synonymsIDs);

      //habitats = new HabitatsNatureObjectReportTypeSpeciesDomain().findWhere( "H.ID_HABITAT<>'-1' AND H.ID_HABITAT<>'10000' AND C.ID_NATURE_OBJECT = " + getSpeciesNatureObject().getIdNatureObject() + " GROUP BY H.ID_NATURE_OBJECT" );
      habitats = new HabitatsNatureObjectReportTypeSpeciesDomain().findWhere( "H.ID_HABITAT<>'-1' AND H.ID_HABITAT<>'10000' AND C.ID_NATURE_OBJECT IN ( " + synonymsIDs + " ) GROUP BY H.ID_NATURE_OBJECT" );
      if ( habitats != null )
      {
        for ( Object habitat1 : habitats )
        {
          HabitatsNatureObjectReportTypeSpeciesPersist habitat = ( HabitatsNatureObjectReportTypeSpeciesPersist )habitat1;

          String code = null;
          int type = 0;
          String abundance = findReportTypeValue( habitat.getIdReportType(), "abundance" );
          String frequencies = findReportTypeValue( habitat.getIdReportType(), "frequencies" );
          String faithfulness = findReportTypeValue( habitat.getIdReportType(), "faithfulness" );
          String speciesStatus = findReportTypeValue( habitat.getIdReportType(), "species_status" );
          String comment = findReportAttributesValue( habitat.getIdReportAttributes(), "comment" );
          String geoscope = CountryUtil.findBiogeoregionByIDGeoscope( habitat.getIdGeoscope() );

          int idHabitat = Utilities.checkedStringToInt( habitat.getIdHabitat(), -100 );
          if ( idHabitat != -100 )
          {
            if ( idHabitat >= 1 && idHabitat < 10000 )
            {
              code = habitat.getEunisHabitatCode();
              type = SpeciesHabitatWrapper.HABITAT_EUNIS;
            }
            if ( idHabitat > 10000 )
            {
              code = habitat.getCode2000();
              type = SpeciesHabitatWrapper.HABITAT_ANNEX_I;
            }
          }
          results.addElement( new SpeciesHabitatWrapper( habitat.getHabitatScientificName(),
                                                         code, habitat.getIdHabitat(),
                                                         type,
                                                         geoscope,
                                                         abundance,
                                                         frequencies,
                                                         faithfulness,
                                                         speciesStatus,
                                                         comment ) );
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return results;
  }

  /**
   * Get sites related with this species.
   *
   * @return A list of SitesByNatureObjectPersist objects.
   */
  public List getSitesForSpecies()
  {
    String synonymsIDs = getSpeciesSynonymsCommaSeparated( getSpeciesNatureObject().getIdNatureObject(), getSpeciesNatureObject().getIdSpecies() );
    //System.out.println("synonymsIDs = " + synonymsIDs);

    List results = new Vector();
    String sql = "SELECT C.ID_SITE, C.NAME, C.SOURCE_DB, C.LATITUDE, C.LONGITUDE, E.AREA_NAME_EN " +
      " FROM CHM62EDT_SPECIES AS A " +
      " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK " +
      " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_COUNTRY AS E ON D.ID_GEOSCOPE = E.ID_GEOSCOPE " +
      " WHERE A.ID_NATURE_OBJECT IN ( " + synonymsIDs + " )" +
      " AND C.SOURCE_DB <> 'EMERALD'" +
      " GROUP BY C.ID_NATURE_OBJECT";
    try
    {
      results = new SitesByNatureObjectDomain().findCustom( sql );
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return results;
  }

  /**
   * Get sites related with this species subspecies.
   *
   * @return A list of SitesByNatureObjectPersist objects.
   */
  public List getSitesForSubpecies() {
    List results = new Vector();
    String sql = "SELECT C.ID_SITE, C.NAME, C.SOURCE_DB, C.LATITUDE, C.LONGITUDE, E.AREA_NAME_EN " +
      " FROM CHM62EDT_SPECIES AS A " +
      " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS B ON A.ID_NATURE_OBJECT = B.ID_NATURE_OBJECT_LINK " +
      " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT " +
      " LEFT JOIN CHM62EDT_COUNTRY AS E ON D.ID_GEOSCOPE = E.ID_GEOSCOPE " +
      " WHERE (A.ID_SPECIES_LINK = '" + getSpeciesObject().getIdSpecies() + "'" +
      " AND A.TYPE_RELATED_SPECIES='subspecies'" +
      " AND A.ID_SPECIES <> '" + getSpeciesObject().getIdSpecies() + "')" +
      " OR (A.SCIENTIFIC_NAME LIKE '" + getSpeciesObject().getScientificName() + " %')" +
//            " AND C.SOURCE_DB <> 'EMERALD'" +
      " GROUP BY C.ID_NATURE_OBJECT";
    try
    {
      results = new SitesByNatureObjectDomain().findCustom( sql );
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return results;
  }

  private static String getSpeciesSynonymsCommaSeparated(Integer idNatureObject, Integer idSpecies )
  {
    Vector<Integer> synonyms = new Vector<Integer>();
    synonyms.add( idNatureObject );

    List<Chm62edtSpeciesPersist> lstSynonyms = new Chm62edtSpeciesDomain().findWhere("TYPE_RELATED_SPECIES = 'Synonym' and ID_SPECIES_LINK="+idSpecies);
    if(lstSynonyms.size()>0)
    {
      for ( Chm62edtSpeciesPersist lstSynonym : lstSynonyms )
      {
        synonyms.add( lstSynonym.getIdNatureObject() );
      }
    }
    String IDs = "";
    for ( int k = 0; k < synonyms.size(); k++ )
    {
      IDs += synonyms.get( k ).toString();
      if ( k != ( synonyms.size() - 1 ) )
      {
        IDs += ",";
      }
    }
    return IDs;
  }

  /**
   * Retrieve national threat status for a species.
   *
   * @param specie Species JRF object from database.
   * @return Vector of NationalThreatWrapper objects.
   */
  public Vector getNationalThreatStatus( Chm62edtSpeciesPersist specie ) {
    Vector<NationalThreatWrapper> results = new Vector<NationalThreatWrapper>();
    try
    {

      //List list = new Chm62edtReportsDomain().findWhere("LOOKUP_TYPE='CONSERVATION_STATUS' AND ID_NATURE_OBJECT='" + specie.getIdNatureObject() + "'");
      //search also on synonyms
      String synonymsIDs = getSpeciesSynonymsCommaSeparated( specie.getIdNatureObject(), specie.getIdSpecies() );
      //System.out.println("synonymsIDs = " + synonymsIDs);

      List<Chm62edtReportsPersist> list = new Chm62edtReportsDomain().findWhere( "LOOKUP_TYPE='CONSERVATION_STATUS' AND ID_NATURE_OBJECT IN (" + synonymsIDs + ")" );

      for ( Chm62edtReportsPersist report : list )
      {
        NationalThreatWrapper threat = new NationalThreatWrapper();

        List list1 = new Chm62edtConservationStatusDomain().findWhere( "ID_CONSERVATION_STATUS = '" + report.getIDLookup() + "'" );
        List list2 = new Chm62edtCountryDomain().findWhere( "AREA_NAME_EN not like 'ospar%' and ID_GEOSCOPE='" + report.getIdGeoscope() + "'" );
        if ( list1.size() > 0 && list2.size() > 0 )
        {
          Chm62edtConservationStatusPersist consS = ( Chm62edtConservationStatusPersist )list1.get( 0 );
          threat.setStatus( consS.getName() );
          Chm62edtCountryPersist country = ( Chm62edtCountryPersist )list2.get( 0 );
          if ( country.getIso2l() != null && country.getIso2l().length() > 0 && country.getSelection().intValue() != 0 )
          {
            threat.setCountry( country.getAreaNameEnglish() );
            threat.setIso2L( country.getIso2l() );
            threat.setReference( getBookAuthorDate( report.getIdDc() ) );
            threat.setSelection( country.getSelection() );
            threat.setThreatCode( consS.getCode() );
            int year = Utilities.checkedStringToInt( getBookDate( report.getIdDc() ), 0 );
            threat.setReferenceYear( year );
            threat.setIdDc(report.getIdDc());
            results.addElement( threat );
          }
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace();
    }
    return results;
  }

  /**
   * Conservation status for an species.
   *
   * @param specie Species object
   * @return List of conservation statuses associated with this species
   */
  public List getConservationStatus( Chm62edtSpeciesPersist specie ) {
    Vector<NationalThreatWrapper> results = new Vector<NationalThreatWrapper>();
    try
    {
      //List list = new Chm62edtReportsDomain().findWhere("LOOKUP_TYPE='CONSERVATION_STATUS' AND ID_NATURE_OBJECT='" + specie.getIdNatureObject() + "'");
      //search also on synonyms
      String synonymsIDs = getSpeciesSynonymsCommaSeparated( specie.getIdNatureObject(), specie.getIdSpecies() );
      //System.out.println("synonymsIDs = " + synonymsIDs);
      List<Chm62edtReportsPersist> list = new Chm62edtReportsDomain().findWhere( "LOOKUP_TYPE='CONSERVATION_STATUS' AND ID_NATURE_OBJECT IN (" + synonymsIDs + ")" );
      for ( Chm62edtReportsPersist report : list )
      {
        NationalThreatWrapper threat = new NationalThreatWrapper();

        List list1 = new Chm62edtConservationStatusDomain().findWhere( "ID_CONSERVATION_STATUS = '" + report.getIDLookup() + "'" );
        List list2 = new Chm62edtCountryDomain().findWhere( "AREA_NAME_EN not like 'ospar%' and ID_GEOSCOPE='" + report.getIdGeoscope() + "'" );
        if ( list1.size() > 0 && list2.size() > 0 )
        {
          Chm62edtConservationStatusPersist consS = ( Chm62edtConservationStatusPersist )list1.get( 0 );
          threat.setStatus( consS.getName() );
          Chm62edtCountryPersist country = ( Chm62edtCountryPersist )list2.get( 0 );
          if ( country.getIso2l() == null || ( country.getIso2l() != null && country.getIso2l().equals( "" ) ) )
          {
            if ( !( country.getAreaNameEnglish() == null || country.getAreaNameEnglish().trim().indexOf( "ospar" ) == 0 ) )
            {
              threat.setCountry( country.getAreaNameEnglish() );
              threat.setReference( getBookAuthorDate( report.getIdDc() ) );
              threat.setSelection( country.getSelection() );
              threat.setThreatCode( consS.getCode() );
              threat.setIdDc(report.getIdDc());
              int year = Utilities.checkedStringToInt( getBookDate( report.getIdDc() ), 0 );
              threat.setReferenceYear( year );
              results.addElement( threat );
            }
          }
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace();
    }
    return results;
  }

  /**
   * Gets an String(author + (date)) for a given ID_DC.
   *
   * @param ID_DC ID_DC.
   * @return String containing book's author and date of the publication.
   */
  public static String getBookAuthorDate( Integer ID_DC ) {
    String author = "";
    try
    {
      List list = new DcSourceDomain().findWhere( "ID_DC='" + ID_DC + "'" );
      if ( list.size() > 0 )
      {
        author = ( ( DcSourcePersist ) list.get( 0 ) ).getSource();
      }
      List list1 = new DcDateDomain().findWhere( "ID_DC='" + ID_DC + "'" );
      if ( list1.size() > 0 )
      {
        DcDatePersist date = ( DcDatePersist ) list1.get( 0 );
        String dateStr = Utilities.formatReferencesDate( date.getCreated() );
        if ( !dateStr.equalsIgnoreCase( "" ) )
        {
          author += " (" + dateStr + ")";
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return author;
  }

  /**
   * Gets the author of a book for a given ID_DC.
   *
   * @param ID_DC ID_DC.
   * @return author.
   */
  public static String getBookAuthor( Integer ID_DC ) {
    String ret = "";
    try
    {
      List list = new DcSourceDomain().findWhere( "ID_DC='" + ID_DC + "'" );
      if ( list.size() > 0 )
      {
        ret = ( ( DcSourcePersist ) list.get( 0 ) ).getSource();
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return ret;
  }

  /**
   * Gets the publication date for a book.
   *
   * @param ID_DC ID_DC.
   * @return date of the publication.
   */
  public static String getBookDate( Integer ID_DC ) {
    String ret = "";
    try
    {
      List list1 = new DcDateDomain().findWhere( "ID_DC='" + ID_DC + "'" );
      if ( list1.size() > 0 )
      {
        DcDatePersist date = ( DcDatePersist ) list1.get( 0 );
        if ( null != date.getCreated() )
        {
          ret = new SimpleDateFormat( "yyyy" ).format( date.getCreated() );
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return ret;
  }

  /**
   * Find the book where species is mentioned.
   *
   * @return Wrapper object with requested info.
   */
  public PublicationWrapper getSpeciesBook() {
    PublicationWrapper publication = new PublicationWrapper();
    try
    {
      List sources = new DcSourceDomain().findWhere( "ID_DC='" + getSpeciesNatureObject().getIdDublinCore() + "'" );
      if ( sources.size() > 0 )
      {
        DcSourcePersist source = ( DcSourcePersist ) sources.get( 0 );
        publication.setAuthor( source.getSource() );
        publication.setURL( source.getUrl() );
      }
      List titles = new DcTitleDomain().findWhere( "ID_DC='" + getSpeciesNatureObject().getIdDublinCore() + "'" );
      if ( titles.size() > 0 )
      {
        DcTitlePersist title = ( DcTitlePersist ) titles.get( 0 );
        publication.setTitle( title.getTitle() );
      }
      List publishers = new DcPublisherDomain().findWhere( "ID_DC='" + getSpeciesNatureObject().getIdDublinCore() + "'" );
      if ( publishers.size() > 0 )
      {
        DcPublisherPersist publisher = ( DcPublisherPersist ) publishers.get( 0 );
        publication.setPublisher( publisher.getPublisher() );
      }
      List dates = new DcDateDomain().findWhere( "ID_DC='" + getSpeciesNatureObject().getIdDublinCore() + "'" );
      if ( dates.size() > 0 )
      {
        DcDatePersist date = ( DcDatePersist ) dates.get( 0 );
        if ( date.getCreated() != null )
        {
          publication.setDate( new SimpleDateFormat( "yyyy" ).format( date.getCreated() ) );
        }
        else
        {
          System.out.println( "Warning: " + SpeciesFactsheet.class.getName() + "::getSpeciesBook() - date.getCreated returned null" );
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return publication;
  }


  /**
   * List of SpeciesNatureObjectPersist's.
   *
   * @return A list of SpeciesNatureObjectPersist with all subspecies of this species.
   */
  public List getSubspecies() {
    List result = new Vector();
    String sql;
    sql = " (ID_SPECIES_LINK = '" + getSpeciesNatureObject().getIdSpecies() + "'";
    sql += " AND TYPE_RELATED_SPECIES='subspecies'";
    sql += " AND ID_SPECIES <> '" + getSpeciesNatureObject().getIdSpecies() + "')";
    sql += " OR (SCIENTIFIC_NAME LIKE '" + getSpeciesNatureObject().getScientificName() + " %')";
    try
    {
      //System.out.println("sql = " + sql);
      result = new SpeciesNatureObjectDomain().findWhere( sql );
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    if ( null == result )
    {
      return result;
    }
    return result;
  }

  /**
   * Threat status at european level.
   *
   * @return A vector with EuropeanThreatWrapper objects.
   */
  public Vector getThreatEuro() {
    Vector<EuropeanThreatWrapper> v = new Vector<EuropeanThreatWrapper>();
    try
    {
      List<Chm62edtCountryPersist> countries = new Chm62edtCountryDomain().findWhere( "AREA_NAME_EN LIKE 'Europe%' OR AREA_NAME_EN = 'World'" );
      for ( Chm62edtCountryPersist country : countries )
      {
        //String sql = "LOOKUP_TYPE='CONSERVATION_STATUS' AND ID_GEOSCOPE='" + country.getIdGeoscope() + "' AND ID_NATURE_OBJECT='" + getSpeciesNatureObject().getIdNatureObject() + "'";
        String synonymsIDs = getSpeciesSynonymsCommaSeparated( getSpeciesNatureObject().getIdNatureObject(), getSpeciesNatureObject().getIdSpecies() );
        //System.out.println("synonymsIDs = " + synonymsIDs);

        String sql = "LOOKUP_TYPE='CONSERVATION_STATUS' AND ID_GEOSCOPE='" + country.getIdGeoscope() + "' AND ID_NATURE_OBJECT IN (" + synonymsIDs + ")";
        List<Chm62edtReportsPersist> reports = new Chm62edtReportsDomain().findWhere( sql );
        if ( reports.size() > 0 )
        {
          for ( Chm62edtReportsPersist report : reports )
          {
            EuropeanThreatWrapper threat = new EuropeanThreatWrapper();
            threat.setArea( country.getAreaNameEnglish() );
            List conservations = new Chm62edtConservationStatusDomain().findWhere( "ID_CONSERVATION_STATUS='" + report.getIDLookup() + "'" );
            if ( conservations.size() > 0 )
            {
              threat.setStatus( ( ( Chm62edtConservationStatusPersist )conservations.get( 0 ) ).getName() );
            }
            threat.setReference( getBookAuthorDate( report.getIdDc() ) );/// Reference
            v.addElement( threat );
          }
        }
      }
    }
    catch ( Exception e )
    {
      e.printStackTrace();
    }
    return v;
  }

  /**
   * Returns the legal status information for this species.
   *
   * @return An vector of LegalStatusWrapper objects one for each legal status.
   */
  public Vector getLegalStatus() {
    Vector<LegalStatusWrapper> results = new Vector<LegalStatusWrapper>();
    try
    {
      //List list = new Chm62edtReportsDomain().findWhere("LOOKUP_TYPE='legal_status' AND ID_NATURE_OBJECT='" + getSpeciesNatureObject().getIdNatureObject() + "'");
      //here we are findind also the synonyms....
      Integer IdNatureObjectSpecie = getSpeciesNatureObject().getIdNatureObject();
      Integer IdSpecie = getSpeciesNatureObject().getIdSpecies();

      String synonymsIDs = getSpeciesSynonymsCommaSeparated( IdNatureObjectSpecie, IdSpecie );
      //System.out.println("synonymsIDs = " + synonymsIDs);

      List<Chm62edtReportsPersist> list = new Chm62edtReportsDomain().findWhere( "LOOKUP_TYPE='LEGAL_STATUS' AND ID_NATURE_OBJECT IN (" + synonymsIDs + ")" );
      if ( list.size() > 0 )
      {
        for ( Chm62edtReportsPersist report : list )
        {
          LegalStatusWrapper legalStatus = new LegalStatusWrapper();
          if ( report.getIdDc() != null )
          {
            legalStatus.setReference( report.getReference().toString() );
            legalStatus.setRefcd( report.getRefcd().toString() );
            legalStatus.setIdDc(report.getIdDc());
          }
          else
          {
            legalStatus.setReference( "-1" );
            legalStatus.setRefcd( "-1" );
          }
          List list2 = new Chm62edtCountryDomain().findWhere( "ID_GEOSCOPE='" + report.getIdGeoscope() + "'" );
          if ( list2.size() > 0 )
          {
            Chm62edtCountryPersist country = ( Chm62edtCountryPersist )list2.get( 0 );
            legalStatus.setArea( country.getAreaNameEnglish() );
          }
          // Legal text
          List l2 = new DcTitleDomain().findWhere( "ID_DC='" + report.getIdDc() + "'" );
          if ( l2.size() > 0 )
          {
            DcTitlePersist title = ( DcTitlePersist )l2.get( 0 );
            legalStatus.setDetailedReference( title.getTitle() );
            legalStatus.setLegalText( title.getAlternative() );
          }
          /// URL
          List l3 = new DcSourceDomain().findWhere( "ID_DC='" + report.getIdDc() + "'" );
          if ( l3.size() > 0 )
          {
            DcSourcePersist source = ( DcSourcePersist )l3.get( 0 );
            legalStatus.setUrl( source.getUrl() );
          }

          legalStatus.setComments( "" );

          List list_lg = new Chm62edtLegalStatusDomain().findWhere( "ID_LEGAL_STATUS=" + report.getIDLookup() );
          if ( list_lg.size() > 0 )
          {
            Iterator it_lg = list_lg.iterator();
            if ( it_lg.hasNext() )
            {
              Chm62edtLegalStatusPersist legal_status = ( Chm62edtLegalStatusPersist )it_lg.next();
              legalStatus.setComments( legal_status.getComment() );
            }
          }

          results.addElement( legalStatus );
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    if ( null == results )
    {
      results = new Vector<LegalStatusWrapper>();
    }
    return results;
  }

  /**
   * Find information about legal area status.
   *
   * @param idGeoscope ID_GEOSCOPE for a country / region.
   * @return A vector of Chm62edtAreaLegalTextPersist objects.
   */
  public Vector findAreaLegalEvent( Integer idGeoscope ) {
    Vector<Chm62edtAreaLegalTextPersist> results = new Vector<Chm62edtAreaLegalTextPersist>();
    try
    {
      List<Chm62edtAreaLegalTextPersist> events = new Chm62edtAreaLegalTextDomain().findWhere( "ID_GEOSCOPE='" + idGeoscope + "' ORDER BY LEGAL_DATE " );
      if ( null != events && !events.isEmpty() )
      {
        for ( Chm62edtAreaLegalTextPersist event : events )
        {
          results.addElement( event );
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace();
    }
    return results;
  }

  /**
   * Get the regions where an nature objects is located.
   *
   * @param idNatureObject ID_NATURE_OBJECT from CHM62EDT_REPORTS.
   * @param idSpecies ID_SPECIES from CHM62EDT_SPECIES
   * @return A vector of GeographicalStatusWrapper objects.
   */
  public static Vector getBioRegionIterator( Integer idNatureObject, Integer idSpecies ) {
    Vector<GeographicalStatusWrapper> aList = new Vector<GeographicalStatusWrapper>();
    try
    {
      String synonymsIDs = getSpeciesSynonymsCommaSeparated( idNatureObject, idSpecies );
      //System.out.println("synonymsIDs = " + synonymsIDs);

      //String sql = " (LOOKUP_TYPE IN ('SPECIES_STATUS')) AND  (ID_NATURE_OBJECT='" + idNatureObject + "') ORDER BY ID_REPORT_TYPE, ID_LOOKUP DESC";
      String sql = " (LOOKUP_TYPE IN ('SPECIES_STATUS')) AND  (ID_NATURE_OBJECT IN ( " + synonymsIDs + " ) ) ORDER BY ID_REPORT_TYPE, ID_LOOKUP DESC";

      List<Chm62edtReportsPersist> list = new Chm62edtReportsDomain().findWhere( sql );
      for ( Chm62edtReportsPersist report : list )
      {
        GeographicalStatusWrapper geoObject = new GeographicalStatusWrapper();
        List countries = new Chm62edtCountryDomain().findWhere( "AREA_NAME_EN not like 'ospar%' and ID_GEOSCOPE='" + report.getIdGeoscope() + "'" );
        List regions = new Chm62edtBiogeoregionDomain().findWhere( "ID_GEOSCOPE='" + report.getIdGeoscopeLink() + "'" );
        List statuses = new Chm62edtSpeciesStatusDomain().findWhere( "ID_SPECIES_STATUS='" + report.getIDLookup() + "'" );

        if ( countries.size() > 0 && regions.size() > 0 && statuses.size() > 0 )
        {
          // Set the country
          if ( countries.size() > 0 )
          {
            geoObject.setCountry( ( Chm62edtCountryPersist )countries.get( 0 ) );
          }
          // Set the region
          if ( regions.size() > 0 )
          {
            geoObject.setRegion( ( ( Chm62edtBiogeoregionPersist )regions.get( 0 ) ).getBiogeoregionName() );
          }
          // Set the status
          if ( statuses.size() > 0 )
          {
            Chm62edtSpeciesStatusPersist status = ( Chm62edtSpeciesStatusPersist )statuses.get( 0 );
            geoObject.setStatus( status.getDescription() );
          }
          geoObject.setReference( ( report.getIdDc() == null ? "-1" : report.getIdDc().toString() ) );
          aList.addElement( geoObject );
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return aList;
  }

  /**
   * Retrieve population information for species.
   *
   * @param idNatureObject ID_NATURE_OBJECT from CHM62EDT_REPORTS.
   * @return A vector of FactSheetPopulationWrapper objects.
   */
  public static Vector<FactSheetPopulationWrapper> getPopulation( String idNatureObject ) {
    Vector<FactSheetPopulationWrapper> results = new Vector<FactSheetPopulationWrapper>();
    try
    {
      //List list = new Chm62edtReportsDomain().findWhere("ID_NATURE_OBJECT='" + idNatureObject + "' AND LOOKUP_TYPE='POPULATION_UNIT'");

      //search also on synonyms
      Vector<Integer> synonyms = new Vector<Integer>();
      Integer IdNatureObjectSpecie = new Integer( idNatureObject );

      Integer IdSpecie = null;
      List lstSpeciesIDs = new Chm62edtSpeciesDomain().findWhere( "ID_NATURE_OBJECT=" + idNatureObject );
      if ( lstSpeciesIDs.size() > 0 )
      {
        for ( Object lstSpeciesID : lstSpeciesIDs )
        {
          Chm62edtSpeciesPersist sp = ( Chm62edtSpeciesPersist ) lstSpeciesID;
          IdSpecie = sp.getIdSpecies();
        }
      }

      synonyms.add( IdNatureObjectSpecie );
      String synonymsIDs = getSpeciesSynonymsCommaSeparated( IdNatureObjectSpecie, IdSpecie );
      //System.out.println("synonymsIDs = " + synonymsIDs);

      List list = new Chm62edtReportsDomain().findWhere( "ID_NATURE_OBJECT IN (" + synonymsIDs + ") AND LOOKUP_TYPE='POPULATION_UNIT'" );

      FactSheetPopulationWrapper popW;
      for ( int i = 0; null != list && i < list.size(); i++ )
      {
        Chm62edtReportsPersist report = ( Chm62edtReportsPersist ) list.get( i );
        popW = new FactSheetPopulationWrapper();
        // Country
        popW.setCountry( CountryUtil.findCountryByIDGeoscope( report.getIdGeoscope() ) );
        // Biogeoregion
        popW.setBioregion( CountryUtil.findBiogeoregionByIDGeoscope( report.getIdGeoscopeLink() ) );
        // Min
        popW.setMin( findPopulationMin( report.getIdReportAttributes() ) );
        // Max
        popW.setMax( findPopulationMax( report.getIdReportAttributes() ) );
        // Units
        popW.setUnits( findPopulationUnits( report.getIDLookup() ) );
        // Date
        popW.setDate( findPopulationDate( report.getIdReportAttributes() ) );
        // Status
        popW.setStatus( findPopulationStatus( report.getIdReportType() ) );
        // Quality
        popW.setQuality( findPopulationQuality( report.getIdReportType() ) );
        // Reference
        popW.setReference( ( report.getIdDc() == null ? "-1" : report.getIdDc().toString() ) );
        results.addElement( popW );
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace();
    }
    return results;
  }

  /**
   * Retrieve trends information for species.
   *
   * @param idNatureObject ID_NATURE_OBJECT from CHM62EDT_REPORTS
   * @param idSpecies ID_SPECIES from CHM62EDT_SPECIES
   * @return A vector of FactSheetTrendsWrapper objects.
   */
  public static Vector getTrends( Integer idNatureObject, Integer idSpecies ) {
    Vector<FactSheetTrendsWrapper> results = new Vector<FactSheetTrendsWrapper>();
    try
    {
      String synonymsIDs = getSpeciesSynonymsCommaSeparated( idNatureObject, idSpecies );
      //System.out.println("synonymsIDs = " + synonymsIDs);

      //List<Chm62edtReportsPersist> list = new Chm62edtReportsDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND LOOKUP_TYPE='TREND'" );
      List<Chm62edtReportsPersist> list = new Chm62edtReportsDomain().findWhere( "ID_NATURE_OBJECT IN ( " + synonymsIDs + " ) AND LOOKUP_TYPE='TREND'" );
      for ( Chm62edtReportsPersist report : list )
      {
        FactSheetTrendsWrapper trendsW = new FactSheetTrendsWrapper();
        // Country
        trendsW.setCountry( CountryUtil.findCountryByIDGeoscope( report.getIdGeoscope() ) );
        // Biogeoregion
        trendsW.setBioregion( CountryUtil.findBiogeoregionByIDGeoscope( report.getIdGeoscopeLink() ) );
        // Start period
        trendsW.setStartPeriod( findStartPeriod( report.getIdReportAttributes() ) );
        // End period
        trendsW.setEndPeriod( findEndPeriod( report.getIdReportAttributes() ) );
        // Status
        trendsW.setStatus( findPopulationStatus( report.getIdReportType() ) );
        // Trend
        trendsW.setTrends( findTrends( report.getIDLookup() ) );
        // Quality
        trendsW.setQuality( findPopulationQuality( report.getIdReportType() ) );
        // Reference
        trendsW.setReference( ( report.getIdDc() == null ? "-1" : report.getIdDc().toString() ) );
        results.addElement( trendsW );
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace();
    }
    return results;
  }

  /**
   * Retrieve the author of the taxonomic information.
   *
   * @param idTaxCode ID_TAXONOMY from CHM62EDT_TAXONOMY.
   * @return String with author.
   */
  public String getTaxCodeAuthorDate( String idTaxCode ) {
    String ret = "";
    try
    {
      List list = new Chm62edtTaxonomyDomain().findWhere( "ID_TAXONOMY='" + idTaxCode + "'" );
      if ( list.size() > 0 )
      {
        Chm62edtTaxonomyPersist taxCode = ( Chm62edtTaxonomyPersist ) list.get( 0 );
        ret = getBookAuthorDate( taxCode.getIdDc() );
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace();
      ret = "";
    }
    return ret;
  }

  /**
   * This methods gets all the references for a givent species.
   *
   * @param idNatureObject ID nature object of that species.
   * @return A vector of Chm62edtReportsDcSourcePersist objects.
   */
  public static Vector getSpeciesReferences( Integer idNatureObject ) {
    Vector results = new Vector();
    String sql = "";
    //List list = new NatureObjectDcSourceDomain().findWhere("CHM62EDT_NATURE_OBJECT.ID_NATURE_OBJECT=" + idNatureObject + " GROUP BY DC_SOURCE.SOURCE,DC_SOURCE.EDITOR,DC_TITLE.TITLE,DC_PUBLISHER.PUBLISHER");
    sql += "    SELECT";
    sql += "      `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`,";
    sql += "      `DC_INDEX`.`ID_DC`,";
    sql += "      `CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` AS `TYPE`,";
    sql += "      `DC_SOURCE`.`SOURCE`,";
    sql += "      `DC_SOURCE`.`EDITOR`,";
    sql += "      `DC_DATE`.`CREATED`,";
    sql += "      `DC_TITLE`.`TITLE`,";
    sql += "      `DC_PUBLISHER`.`PUBLISHER`";
    sql += "    FROM";
    sql += "      `CHM62EDT_SPECIES`";
    sql += "      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
    sql += "      INNER JOIN `CHM62EDT_REPORTS` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_REPORTS`.`ID_NATURE_OBJECT`)";
    sql += "      INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_REPORTS`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
    sql += "      INNER JOIN `DC_INDEX` ON (`CHM62EDT_REPORTS`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
    sql += "      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
    sql += "      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
    sql += "      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
    sql += "      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
    sql += "    WHERE";
    sql += "      (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` IN ('DISTRIBUTION_STATUS','LANGUAGE','CONSERVATION_STATUS','SPECIES_GEO','LEGAL_STATUS','SPECIES_STATUS','POPULATION_UNIT','TREND'))";
    sql += "    AND (`CHM62EDT_SPECIES`.`ID_SPECIES` = " + idNatureObject + ")";
    sql += "    UNION";
    sql += "    SELECT";
    sql += "      `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`,";
    sql += "      `DC_INDEX`.`ID_DC`,";
    sql += "      'Synonyms' AS `TYPE`,";
    sql += "      `DC_SOURCE`.`SOURCE`,";
    sql += "      `DC_SOURCE`.`EDITOR`,";
    sql += "      `DC_DATE`.`CREATED`,";
    sql += "      `DC_TITLE`.`TITLE`,";
    sql += "      `DC_PUBLISHER`.`PUBLISHER`";
    sql += "    FROM";
    sql += "      `CHM62EDT_SPECIES`";
    sql += "      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
    sql += "      INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
    sql += "      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
    sql += "      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
    sql += "      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
    sql += "      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
    sql += "    WHERE `CHM62EDT_SPECIES`.`ID_SPECIES_LINK` = " + idNatureObject;
    sql += "    AND `CHM62EDT_SPECIES`.`ID_SPECIES` <> " + idNatureObject;
    sql += "    UNION";
    sql += "    SELECT";
    sql += "      `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`,";
    sql += "      `DC_INDEX`.`ID_DC`,";
    sql += "      'Species' AS `TYPE`,";
    sql += "      `DC_SOURCE`.`SOURCE`,";
    sql += "      `DC_SOURCE`.`EDITOR`,";
    sql += "      `DC_DATE`.`CREATED`,";
    sql += "      `DC_TITLE`.`TITLE`,";
    sql += "      `DC_PUBLISHER`.`PUBLISHER`";
    sql += "    FROM";
    sql += "      `CHM62EDT_SPECIES`";
    sql += "      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
    sql += "      INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
    sql += "      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
    sql += "      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
    sql += "      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
    sql += "      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
    sql += "    WHERE `CHM62EDT_SPECIES`.`ID_SPECIES` = " + idNatureObject;
    sql += "    UNION";
    sql += "    SELECT";
    sql += "      `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`,";
    sql += "      `DC_INDEX`.`ID_DC`,";
    sql += "      'Taxonomy' AS `TYPE`,";
    sql += "      `DC_SOURCE`.`SOURCE`,";
    sql += "      `DC_SOURCE`.`EDITOR`,";
    sql += "      `DC_DATE`.`CREATED`,";
    sql += "      `DC_TITLE`.`TITLE`,";
    sql += "      `DC_PUBLISHER`.`PUBLISHER`";
    sql += "    FROM";
    sql += "      `CHM62EDT_SPECIES`";
    sql += "      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
    sql += "      INNER JOIN `CHM62EDT_TAXONOMY` ON (`CHM62EDT_SPECIES`.`ID_TAXONOMY` = `CHM62EDT_TAXONOMY`.`ID_TAXONOMY`)";
    sql += "      INNER JOIN `DC_INDEX` ON (`CHM62EDT_TAXONOMY`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
    sql += "      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
    sql += "      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
    sql += "      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
    sql += "      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
    sql += "    WHERE `CHM62EDT_SPECIES`.`ID_SPECIES` = " + idNatureObject;
    sql += "    GROUP BY CHM62EDT_SPECIES.ID_NATURE_OBJECT,DC_INDEX.ID_DC,DC_SOURCE.SOURCE,DC_SOURCE.EDITOR,DC_TITLE.TITLE,DC_PUBLISHER.PUBLISHER,DC_DATE.CREATED";
    try
    {
      List list = new NatureObjectDcSourceDomain().findCustom( sql, 1000 );
      if ( null != list && list.size() > 0 )
      {
        Iterator it = list.iterator();
        while ( it.hasNext() )
        {
          results.addElement( it.next() );
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace();
    }
    return results;
  }

  /**
   * Retrieve the synonyms for species.
   *
   * @return A list of SpeciesNatureObjectPersist objects.
   */
  public List getSynonymsIterator() {
    List synonyms = new Vector();
    try
    {
      String sql = "ID_SPECIES_LINK='" + idSpeciesLink + "' AND ID_SPECIES<>'" + idSpecies + "' AND ID_SPECIES_LINK <> 0";
      synonyms = new SpeciesNatureObjectDomain().findWhere( sql );
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    if ( null == synonyms )
    {
      synonyms = new Vector();
    }
    return synonyms;
  }

  /**
   * Retrieve family name for species.
   *
   * @param taxcodeID ID_TAXONOMY from CHM62EDT_TAXONOMY.
   * @return Family.
   */
  public String getFamilyName( String taxcodeID ) {
    return getTaxonomicName( taxcodeID, 0 );
  }

  /**
   * Retrieve order name for species.
   *
   * @param taxcodeID ID_TAXONOMY from CHM62EDT_TAXONOMY.
   * @return Order.
   */
  public String getOrderName( String taxcodeID ) {
    return getTaxonomicName( taxcodeID, 1 );
  }

  /**
   * Retrieve class name for species.
   *
   * @param taxcodeID ID_TAXONOMY from CHM62EDT_TAXONOMY.
   * @return Class.
   */
  public String getClassName( String taxcodeID ) {
    return getTaxonomicName( taxcodeID, 2 );
  }

  /**
   * Retrieve phylum name for species.
   *
   * @param taxcodeID ID_TAXONOMY from CHM62EDT_TAXONOMY.
   * @return Phylum.
   */
  public String getPhylumName( String taxcodeID ) {
    return getTaxonomicName( taxcodeID, 3 );
  }

  /**
   * Retrieve taxonomic information about a species.
   *
   * @param taxcodeID ID_TAXONOMY from CHM62EDT_TAXONOMY.
   * @param level     Level (0, 1, 2 etc. for family, order, class, phylum etc.)
   * @return Name.
   */
  public String getTaxonomicName( String taxcodeID, int level ) {
    String tName = "";
    Chm62edtTaxonomyDomain tDomain = new Chm62edtTaxonomyDomain();
    Chm62edtTaxonomyPersist t;
    try
    {
      List ltaxcode = tDomain.findWhere( "CHM62EDT_TAXONOMY.ID_TAXONOMY='" + taxcodeID + "'" );
      if ( !ltaxcode.isEmpty() && level < 3 )
      {
        t = ( Chm62edtTaxonomyPersist ) ltaxcode.get( 0 );
        switch ( level )
        {
          case 0:
            tName = t.getName();
            break;
          case 1:
            tName = t.getParentLevelName();
            break;
          case 2:
            tName = getTaxonomicName( t.getClassID().toString(), 0 );
            break;
          case 3:
            tName = getTaxonomicName( t.getClassID().toString(), 1 );
            break;
          default:
            tName = "bad taxionomic level";
        }
      }
      else
      {
        if ( 3 == level )
        {
          Chm62edtTaxcodeLeftDomain tLDomain = new Chm62edtTaxcodeLeftDomain();
          List list = tLDomain.findWhere( "CHM62EDT_TAXONOMY.ID_TAXONOMY='" + taxcodeID + "'" );
          Chm62edtTaxcodeLeftPersist tL;
          if ( !list.isEmpty() )
          {
            tL = ( Chm62edtTaxcodeLeftPersist ) list.get( 0 );
            tName = tL.getTaxonomicName();
          }
          else
          {
            tName = "na";
          }
        }
        else
        {
          tName = "na";
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    if ( null == tName )
    {
      tName = "";
    }
    return tName;
  }

  /**
   * Retrieve minumum population for a given species.
   *
   * @param idReportAttribute ID_REPORT_ATTRIBUTES from CHM62EDT_REPORT_ATTRIBUTES
   * @return Minimum population.
   */
  private static int findPopulationMin( Integer idReportAttribute ) {
    int result = 0;
    try
    {
      List results = new Chm62edtReportAttributesDomain().findWhere( "ID_REPORT_ATTRIBUTES='" + idReportAttribute + "' AND NAME='POP_MIN'" );
      if ( null != results && results.size() > 0 )
      {
        result = Utilities.checkedStringToInt( ( ( Chm62edtReportAttributesPersist ) results.get( 0 ) ).getValue(), 0 );
      }
      else
      {
        result = 0;
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Retrieve maximum population for a given species.
   *
   * @param idReportAttribute ID_REPORT_ATTRIBUTES from CHM62EDT_REPORT_ATTRIBUTES
   * @return Maximum population.
   */
  private static int findPopulationMax( Integer idReportAttribute ) {
    int result = 0;
    try
    {
      List results = new Chm62edtReportAttributesDomain().findWhere( "ID_REPORT_ATTRIBUTES='" + idReportAttribute + "' AND NAME='POP_MAX'" );
      if ( null != results && results.size() > 0 )
      {
        result = Utilities.checkedStringToInt( ( ( Chm62edtReportAttributesPersist ) results.get( 0 ) ).getValue(), 0 );
      }
      else
      {
        result = 0;
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Retrieve unit of measurement for population for a given species.
   *
   * @param idPopulationUnit ID_POPULATION_UNIT from CHM62EDT_POPULATION_UNIT
   * @return Unit of measurement (unit, pairs etc.).
   */
  private static String findPopulationUnits( String idPopulationUnit ) {
    String result = "";
    try
    {
      List results = new Chm62edtPopulationUnitDomain().findWhere( "ID_POPULATION_UNIT='" + idPopulationUnit + "'" );
      if ( null != results && results.size() > 0 )
      {
        result = ( ( Chm62edtPopulationUnitPersist ) results.get( 0 ) ).getName();
      }
      else
      {
        result = "";
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Population information (date of reference).
   *
   * @param idReportAttribute ID_REPORT_ATTRIBUTES from CHM62EDT_REPORT_ATTRIBUTES
   * @return reference date.
   */
  private static String findPopulationDate( Integer idReportAttribute ) {
    String result = "";
    try
    {
//      List results = new Chm62edtReportAttributesDomain().findWhere("ID_REPORT_ATTRIBUTES='" + idReportAttribute + "' AND NAME='REFERENCE_DATE'");
      List results = new Chm62edtReportAttributesDomain().findWhere( "ID_REPORT_ATTRIBUTES='" + idReportAttribute + "' AND NAME='REFERENCE_PERIOD'" );
      if ( null != results && results.size() > 0 )
      {
        result = ( ( Chm62edtReportAttributesPersist ) results.get( 0 ) ).getValue();
      }
      else
      {
        result = "";
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Population information (status of species).
   *
   * @param idReportType ID_REPORT_TYPE from CHM62EDT_REPORT_TYPE
   * @return population status.
   */
  private static String findPopulationStatus( Integer idReportType ) {
    String result = "";
    try
    {
      List results = new SpeciesStatusReportTypeDomain().findWhere( "ID_REPORT_TYPE='" + idReportType + "' AND LOOKUP_TYPE='SPECIES_STATUS'" );
      if ( null != results && results.size() > 0 )
      {
        result = ( ( SpeciesStatusReportTypePersist ) results.get( 0 ) ).getDescription();
      }
      else
      {
        result = "";
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Population information (quality of information).
   *
   * @param idReportType ID_REPORT_TYPE from CHM62EDT_REPORT_TYPE
   * @return quality of information.
   */
  private static String findPopulationQuality( Integer idReportType ) {
    String result = "";
    try
    {
      List results = new InfoQualityReportTypeDomain().findWhere( "ID_REPORT_TYPE='" + idReportType + "' AND LOOKUP_TYPE='INFO_QUALITY'" );
      if ( null != results && results.size() > 0 )
      {
        result = ( ( InfoQualityReportTypePersist ) results.get( 0 ) ).getDescription();
      }
      else
      {
        result = "";
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Population information (start period).
   *
   * @param idReportAttribute ID_REPORT_ATTRIBUTES from CHM62EDT_REPORT_ATTRIBUTES.
   * @return start of period.
   */
  private static String findStartPeriod( Integer idReportAttribute ) {
    String result = "";
    try
    {
      List results = new Chm62edtReportAttributesDomain().findWhere( "ID_REPORT_ATTRIBUTES='" + idReportAttribute + "' AND NAME='START_PERIOD'" );
      if ( null != results && results.size() > 0 )
      {
        result = ( ( Chm62edtReportAttributesPersist ) results.get( 0 ) ).getValue();
      }
      else
      {
        result = "";
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Population information (end period).
   *
   * @param idReportAttribute ID_REPORT_ATTRIBUTES from CHM62EDT_REPORT_ATTRIBUTES.
   * @return end of period.
   */
  private static String findEndPeriod( Integer idReportAttribute ) {
    String result = "";
    try
    {
      List results = new Chm62edtReportAttributesDomain().findWhere( "ID_REPORT_ATTRIBUTES='" + idReportAttribute + "' AND NAME='END_PERIOD'" );
      if ( null != results && results.size() > 0 )
      {
        result = ( ( Chm62edtReportAttributesPersist ) results.get( 0 ) ).getValue();
      }
      else
      {
        result = "";
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Retrieve trends information.
   *
   * @param idTrend ID_TREND from CHM62EDT_TREND.
   * @return Trend information.
   */
  private static String findTrends( String idTrend ) {
    String result = "";
    try
    {
      List results = new Chm62edtTrendDomain().findWhere( "ID_TREND='" + idTrend + "'" );
      if ( null != results && results.size() > 0 )
      {
        result = ( ( Chm62edtTrendPersist ) results.get( 0 ) ).getDescription();
      }
      else
      {
        result = "";
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Get the pictures available in database for this species. It queries the CHM62EDT_NATURE_OBJECT_PICTURE
   * with ID_SPECIES ant NATURE_OBJECT_TYPE='Species'.
   *
   * @return A list of Chm62edtNatureObjectPicturePersist objects, one for each picture.
   */
  public List getPicturesForSpecies() {
    List results = new Vector();
    String where = "";
    Chm62edtNatureObjectPictureDomain nop = new Chm62edtNatureObjectPictureDomain();
    where += " ID_OBJECT='" + getSpeciesObject().getIdSpecies() + "'";
    where += " AND NATURE_OBJECT_TYPE='Species'";
    try
    {
      results = nop.findWhere( where );
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return results;
  }

  /**
   * Find the value of an attribute for species, from CHM62EDT_REPORT_ATTRIBUTES.
   *
   * @param idReportAttribute ID_REPORT_ATTRIBUTES from CHM62EDT_REPORT_ATTRIBUTES.
   * @param name              NAME from CHM62EDT_REPORT_ATTRIBUTES.
   * @return VALUE from CHM62EDT_REPORT_ATTRIBUTES.
   */
  private static String findReportAttributesValue( Integer idReportAttribute, String name ) {
    String result = "";
    try
    {
      List results = new Chm62edtReportAttributesDomain().findWhere( "ID_REPORT_ATTRIBUTES='" + idReportAttribute + "' AND NAME='" + name + "'" );
      if ( null != results && results.size() > 0 )
      {
        result = ( ( Chm62edtReportAttributesPersist ) results.get( 0 ) ).getValue();
      }
      else
      {
        result = "";
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Find the value of an attribute for species, from CHM62EDT_REPORT_TYPE.
   *
   * @param idReportType ID_REPORT_TYPE from CHM62EDT_REPORT_TYPE.
   * @param lookup_type  Name of the attribute (implemented: abundance, frequencies, faithfulness, species_status).
   * @return value associated with the given attribute.
   */
  private static String findReportTypeValue( Integer idReportType, String lookup_type ) {
    String result = "";
    String idLookup;
    try
    {
      List results = new Chm62edtReportTypeDomain().findWhere( "ID_REPORT_TYPE='" + idReportType + "' AND LOOKUP_TYPE='" + lookup_type + "'" );
      if ( null != results && results.size() > 0 )
      {
        idLookup = ( ( Chm62edtReportTypePersist ) results.get( 0 ) ).getIdLookup();
      }
      else
      {
        idLookup = "";
      }
      if ( lookup_type.equalsIgnoreCase( "abundance" ) )
      {
        results = new Chm62edtAbundanceDomain().findWhere( "ID_ABUNDANCE='" + idLookup + "'" );
        if ( null != results && results.size() > 0 )
        {
          result = ( ( Chm62edtAbundancePersist ) results.get( 0 ) ).getDescription();
        }
        else
        {
          result = "";
        }
      }
      if ( lookup_type.equalsIgnoreCase( "frequencies" ) )
      {
        results = new Chm62edtFrequenciesDomain().findWhere( "ID_FREQUENCIES='" + idLookup + "'" );
        if ( null != results && results.size() > 0 )
        {
          result = ( ( Chm62edtFrequenciesPersist ) results.get( 0 ) ).getName();
        }
        else
        {
          result = "";
        }
      }
      if ( lookup_type.equalsIgnoreCase( "faithfulness" ) )
      {
        results = new Chm62edtFaithfulnessDomain().findWhere( "ID_FAITHFULNESS='" + idLookup + "'" );
        if ( null != results && results.size() > 0 )
        {
          result = ( ( Chm62edtFaithfulnessPersist ) results.get( 0 ) ).getName();
        }
        else
        {
          result = "";
        }
      }
      if ( lookup_type.equalsIgnoreCase( "species_status" ) )
      {
        results = new Chm62edtSpeciesStatusDomain().findWhere( "ID_SPECIES_STATUS='" + idLookup + "'" );
        if ( null != results && results.size() > 0 )
        {
          result = ( ( Chm62edtSpeciesStatusPersist ) results.get( 0 ) ).getDescription();
        }
        else
        {
          result = "";
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return result;
  }

  /**
   * Get the taxonomic code associated with this species (ID_TAXCODE from CHM62EDT_SPECIES).
   *
   * @return ID taxonomic code.
   */
  public String getIDTaxCode() {
    return getSpeciesObject().getIdTaxcode();
  }

  /**
   * Getter for speciesObject.
   *
   * @return Species object if species does exists, null otherwise (not normal for a factsheet).
   */
  public Chm62edtSpeciesPersist getSpeciesObject() {
    return speciesObject;
  }

  /**
   * Retrieve taxonomic object with such information.
   *
   * @return taxonomy information.
   */
  public FactsheetTaxcode getTaxcodeObject() {
    return taxcodeObject;
  }

  /**
   * Nature object of this species.
   *
   * @return nature object of this species.
   */
  public SpeciesNatureObjectPersist getSpeciesNatureObject() {
    return speciesNatureObject;
  }

  /**
   * ID_SPECIES associated with this species.
   *
   * @return ID_SPECIES.
   */
  public Integer getIdSpecies() {
    return idSpecies;
  }

  /**
   * ID_SPECIES_LINK associated with this species.
   *
   * @return ID_SPECIES_LINK.
   */
  public Integer getIdSpeciesLink() {
    return idSpeciesLink;
  }

  /**
   * Check if this species exists.
   *
   * @return true if species exists in database.
   */
  public boolean exists() {
    return exists;
  }

  /**
   * Retrive group classification for an species.
   *
   * @return Group name
   */
  public String getSpeciesGroup() {
    String result = "";
    List groups = new Chm62edtGroupspeciesDomain().findWhere( "ID_GROUP_SPECIES = " + getSpeciesNatureObject().getIdGroupspecies() );
    if ( groups != null && groups.size() > 0 )
    {
      result = ( ( Chm62edtGroupspeciesPersist ) groups.get( 0 ) ).getCommonName();
    }
    return result;
  }

  /**
   * Retrieve conservation description.
   *
   * @param code Conservation code
   * @return Description
   */
  public String getConservationStatusDescriptionByCode( String code ) {
    if ( code == null || code.trim().equals( "" ) )
    {
      return "";
    }
    String result = "";
    List conservations = new Chm62edtConservationStatusDomain().findWhere( "CODE = '" + code + "'" );
    if ( conservations != null && conservations.size() > 0 )
    {
      result = ( ( Chm62edtConservationStatusPersist ) conservations.get( 0 ) ).getDescription();
    }
    return ( result == null ? "" : result );
  }
}