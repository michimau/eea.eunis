package ro.finsiel.eunis.search.sites.designations;

import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchCriteria;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;

import java.util.Hashtable;

/**
 * Search criteria used for sites->designations search.
 *
 * @author finsiel
 */
public class DesignationsSearchCriteria extends SitesSearchCriteria {
  private String searchString = null;
  private Integer relationOp = null;
  private String category = null;


  /**
   * Mappings from search criteria -> SQL Statement.
   */
  private Hashtable sqlMappings = null;
  /**
   * Mappings from search criteria -> Human language.
   */
  private Hashtable humanMappings = null;

  /**
   * Ctor for main search criteria.
   *
   * @param searchString Searched string.
   * @param relationOp   Relation operator.
   * @param category     Category (A/B/C).
   */
  public DesignationsSearchCriteria( String searchString, Integer relationOp, String category ) {
    _initHumanMappings();
    _initSQLMappings();
    this.searchString = searchString;
    this.relationOp = relationOp;
    this.category = category;
  }

  /**
   * Second constructor used to construct filter search criterias (search in results).
   *
   * @param criteriaSearch Search string.
   * @param criteriaType   What we search for. Can be CRITERIA_GROUP/ORDER/SCIENTIFIC_NAME.
   * @param oper           Type of relation between criteriaSearch & criteriaType. Can be OPERATOR_IS/CONTAINS/STARTS.
   */
  public DesignationsSearchCriteria( String criteriaSearch, Integer criteriaType, Integer oper ) {
    _initHumanMappings();
    _initSQLMappings();
    if ( null != criteriaSearch && null != criteriaType && null != oper )
    {
      this.criteriaSearch = criteriaSearch;
      this.criteriaType = criteriaType;
      this.oper = oper;
    }
  }

  /**
   * Init the mappings used to compose the SQL query.
   */
  private void _initSQLMappings() {
    if ( null != sqlMappings )
    {
      return;
    }
    sqlMappings = new Hashtable();
    sqlMappings.put( CRITERIA_SOURCE, "J.DATA_SOURCE " );
    sqlMappings.put( CRITERIA_SOURCE_DB, "S.SOURCE_DB " );
    sqlMappings.put( CRITERIA_DESIGN, "J.DESCRIPTION" );
    sqlMappings.put( CRITERIA_DESIGN_EN, "J.DESCRIPTION_EN" );
    sqlMappings.put( CRITERIA_DESIGN_FR, "J.DESCRIPTION_FR" );
    sqlMappings.put( CRITERIA_ABREVIATION, "J.ID_DESIGNATION" );
    sqlMappings.put( CRITERIA_ISO, "I.AREA_NAME_EN" );
    sqlMappings.put( CRITERIA_COUNTRY, "I.AREA_NAME_EN" );
  }

  /**
   * Init the human mappings so you can represent this object in human language.
   */
  private void _initHumanMappings() {
    if ( null != humanMappings )
    {
      return;
    }
    humanMappings = new Hashtable();
    humanMappings.put( CRITERIA_SOURCE, "Data source" );
    humanMappings.put( CRITERIA_SOURCE_DB, "Source data set" );
    humanMappings.put( CRITERIA_DESIGN, "Designation names" );
    humanMappings.put( CRITERIA_DESIGN_EN, "English designation names" );
    humanMappings.put( CRITERIA_DESIGN_FR, "French designation names" );
    humanMappings.put( CRITERIA_DESIGNATION_MAIN, "Original/English/French designation name" );
    humanMappings.put( CRITERIA_ABREVIATION, "Abbreviation" );
    humanMappings.put( CRITERIA_ISO, "Country" );
    humanMappings.put( CRITERIA_COUNTRY, "Country" );
  }


  /**
   * This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 2 params: county/region then this method should return:
   * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
   *
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    StringBuffer res = new StringBuffer();
    if ( null != category )
    {
      res.append( Utilities.writeURLParameter( "searchString", searchString ) );
      res.append( Utilities.writeURLParameter( "relationOp", relationOp.toString() ) );
      res.append( Utilities.writeURLParameter( "category", category ) );
    }

    // Search in results
    if ( null != criteriaSearch )
    {
      res.append( Utilities.writeURLParameter( "criteriaSearch", criteriaSearch ) );
    }
    if ( null != criteriaType )
    {
      res.append( Utilities.writeURLParameter( "criteriaType", criteriaType.toString() ) );
    }
    if ( null != oper )
    {
      res.append( Utilities.writeURLParameter( "oper", oper.toString() ) );
    }
    return res.toString();
  }

  /**
   * Transform this object into an SQL representation.
   *
   * @return SQL string representing this object.
   */
  public String toSQL() {
    StringBuffer sql = new StringBuffer();

    if ( null != searchString && null != relationOp && null != category )
    {
      sql.append( " ( " );
      sql.append( Utilities.prepareSQLOperator( "J.DESCRIPTION", searchString, relationOp ) );
      sql.append( " OR " );
      sql.append( Utilities.prepareSQLOperator( "J.DESCRIPTION_EN", searchString, relationOp ) );
      sql.append( " OR " );
      sql.append( Utilities.prepareSQLOperator( "J.DESCRIPTION_FR", searchString, relationOp ) );
      sql.append( " ) " );
      if ( !category.equalsIgnoreCase( "any" ) )
      {
        sql.append( " AND " );
        sql.append( Utilities.prepareSQLOperator( "J.NATIONAL_CATEGORY", category, Utilities.OPERATOR_IS ) );
      }
    }

    // Search in results
    if ( null != criteriaSearch && null != criteriaType && null != oper )
    {
      if ( 0 == criteriaType.compareTo( CRITERIA_SOURCE_DB ) )
      {
        sql.append( Utilities.prepareSQLOperator( ( String ) sqlMappings.get( criteriaType ), SitesSearchUtility.translateSourceDBInvert( criteriaSearch ), oper ) );
      }
      else
      {
        sql.append( Utilities.prepareSQLOperator( ( String ) sqlMappings.get( criteriaType ), criteriaSearch, oper ) );
      }
      if ( criteriaType.intValue() == CRITERIA_COUNTRY.intValue() )
      {
        sql.append( " and (I.ISO_3L is not null AND I.ISO_3L <>'') " );
      }
    }
    return sql.toString();
  }

  /**
   * This method implements a procedure from morphing the object into an web page FORM representation. What I meant
   * to say is that I can say about an object for example:
   * < INPUT type='hidden" name="searchCriteria" value="natrix">
   * < INPUT type='hidden" name="oper" value="1">
   * < INPUT type='hidden" name="searchType" value="1">.
   *
   * @return Web page FORM representation of the object.
   */
  public String toFORMParam() {
    StringBuffer res = new StringBuffer();
    if ( null != category )
    {
      res.append( Utilities.writeFormParameter( "searchString", searchString ) );
      res.append( Utilities.writeFormParameter( "relationOp", relationOp.toString() ) );
      res.append( Utilities.writeFormParameter( "category", category ) );
    }

    // Search in results
    if ( null != criteriaSearch )
    {
      res.append( Utilities.writeFormParameter( "criteriaSearch", criteriaSearch ) );
    }
    if ( null != criteriaType )
    {
      res.append( Utilities.writeFormParameter( "criteriaType", criteriaType.toString() ) );
    }
    if ( null != oper )
    {
      res.append( Utilities.writeFormParameter( "oper", oper.toString() ) );
    }
    return res.toString();
  }

  /**
   * This method supplies a human readable string representation of this object. for example "Country is Romania"...
   * so an representation of this object could be displayed on the page.
   *
   * @return A human readable representation of an object.
   */
  public String toHumanString() {
    StringBuffer ret = new StringBuffer();
    if ( null != searchString && null != relationOp && null != category )
    {
      ret.append( Utilities.prepareHumanString( ( String ) humanMappings.get( CRITERIA_DESIGNATION_MAIN ), searchString, relationOp ) );
      ret.append( " , and " );
      ret.append( category + " category " );
    }
    else
    {
      if ( null != criteriaSearch && null != criteriaType && null != oper )
      {
        ret.append( Utilities.prepareHumanString( ( String ) humanMappings.get( criteriaType ), criteriaSearch, oper ) );
      }
    }
    return ret.toString();
  }

  /**
   * Human readable string representing this search criteria (ex. Designation is 'Annex II' etc).
   *
   * @return String.
   */
  public String toHumanStringMain() {
    StringBuffer ret = new StringBuffer();
    if ( null != searchString && null != relationOp && null != category )
    {
      ret.append( " You search designations with <strong>" );
      ret.append( Utilities.prepareHumanString( ( String ) humanMappings.get( CRITERIA_DESIGNATION_MAIN ), searchString, relationOp ) );
      ret.append( "</strong> AND <strong>" );
      ret.append( category + "</strong> category" );
    }
    else
    {
      ret.append( "You search designations with any designations names and <strong>" + category + "</strong> category" );
    }
    return ret.toString();
  }
}
