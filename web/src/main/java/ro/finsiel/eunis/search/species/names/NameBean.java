package ro.finsiel.eunis.search.species.names;

import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;

/**
 * Form bean for species->names.
 * @author finsiel
 */
public class NameBean extends AbstractFormBean {
  /** First/Second form operator (starts with, is, contains). */
  private String relationOp = null;
  /** First form - Scientific name. */
  private String scientificName = null;
  /** Second form - Vernacular name. */
  private String vernacularName = null;
  /** Second form - Language ID. */
  private String language = null;

  /** Type of search (Scientific or Vernacular names).*/
  private String typeForm = null;
  /** Expand collapse vernacular names. */
  private String expand = null;

  // Columns that will be displayed in the result window
  /** Display / Hide Group column. */
  private String showGroup = null;
  /** Display / Hide Order column. */
  private String showOrder = null;
  /** Display / Hide Family column. */
  private String showFamily = null;
  /** Display / Hide Scientific name column. */
  private String showScientificName = null;
  /** Display / Hide Vernacular names column. */
  private String showVernacularNames = null;
  /** Display / Hide Valid name column. */
  private String showValidName = null;

  /** Search also in synonyms. */
  private String searchSynonyms = null;

  private Boolean searchVernacular = false;

  /** name was choosen from soundex data. */
  private String newName = null;
  /** searched name if name was choosen from soundex data. */
  private String oldName = null;

  private String noSoundex = null;

  private String comeFromQuickSearch = null;

  /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
   * in order to use them in searches.
   * @return A list of AbstractSearchCriteria objects used to do the search.
   */
  public AbstractSearchCriteria[] toSearchCriteria()
  {
    Vector criterias = new Vector();
    // Coming from form 1
    if (null != scientificName && null != relationOp) {
      Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);
      criterias.addElement(new NameSearchCriteria(scientificName, relationOp));
    }
    // Coming from form 2
    if (null != vernacularName && null != relationOp && null != language) {
      Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);
      criterias.addElement(new NameSearchCriteria(vernacularName, language, relationOp));
    }
    // Search in results
    if (null != criteriaSearch && null != criteriaType && null != oper & null != typeForm) {
      for (int i = 0; i < criteriaSearch.length; i++) {
        Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], NameSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
        Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);
        criterias.addElement(new NameSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
      }
    }

    NameSearchCriteria[] ret = new NameSearchCriteria[criterias.size()];
    for ( int i = 0; i < ret.length; i++ )
    {
      ret[ i ] = ( NameSearchCriteria ) criterias.get( i );
    }
    return ret;
  }

  /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
   * in order to use them in sorting, again.
   * @return A list of AbstractSearchCriteria objects used to do the sorting
   */
  public AbstractSortCriteria[] toSortCriteria() {
    if ( null == sort || null == ascendency )
    {
      return new AbstractSortCriteria[0];
    }
    AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
    for (int i = 0; i < sort.length; i++) {
      NameSortCriteria criteria = new NameSortCriteria(
              Utilities.checkedStringToInt(sort[i], NameSortCriteria.ASCENDENCY_NONE),
              Utilities.checkedStringToInt(ascendency[i], NameSortCriteria.ASCENDENCY_NONE),
              searchVernacular);
      criterias[i] = criteria;
    }
    return criterias; //Note the upcast done here.
  }

  /**
   * This method will transform the request parameters, back to an URL compatible type of request so that
   * one should not manually write the URL.
   * @param classFields Fields to be included in parameters.
   * @return An URL compatible type of representation(i.e.: param1=val1&param2=val2&param3=val3 etc..
   */
  public String toURLParam(Vector classFields) {
    StringBuffer url = new StringBuffer();
    url.append(toURLParamSuper(classFields));// Add fields of the superclass (DO NOT FORGET!)
    AbstractSearchCriteria[] searchCriterias = toSearchCriteria();
    for (int i = 0; i < searchCriterias.length; i++) {
      AbstractSearchCriteria aSearch = searchCriterias[i];
      url.append(aSearch.toURLParam());
    }
    if ( null != typeForm )
    {
      url.append( Utilities.writeURLParameter( "typeForm", typeForm ) );
    }
    if ( null != expand )
    {
      url.append( Utilities.writeURLParameter( "expand", expand ) );
    }
    // Write columns to be displayed
    if ( null != showGroup && showGroup.equalsIgnoreCase( "true" ) )
    {
      url.append( Utilities.writeURLParameter( "showGroup", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != showOrder && showOrder.equalsIgnoreCase( "true" ) )
    {
      url.append( Utilities.writeURLParameter( "showOrder", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != showFamily && showFamily.equalsIgnoreCase( "true" ) )
    {
      url.append( Utilities.writeURLParameter( "showFamily", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != showScientificName && showScientificName.equalsIgnoreCase( "true" ) )
    {
      url.append( Utilities.writeURLParameter( "showScientificName", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != showVernacularNames && showVernacularNames.equalsIgnoreCase( "true" ) )
    {
      url.append( Utilities.writeURLParameter( "showVernacularNames", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != showValidName && showValidName.equalsIgnoreCase( "true" ) )
    {
      url.append( Utilities.writeURLParameter( "showValidName", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != searchSynonyms && searchSynonyms.equalsIgnoreCase( "true" ) )
    {
      url.append( Utilities.writeURLParameter( "searchSynonyms", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != searchVernacular && searchVernacular.booleanValue() )
    {
      url.append( Utilities.writeURLParameter( "searchVernacular", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != comeFromQuickSearch && comeFromQuickSearch.equalsIgnoreCase( "true" ) )
    {
      url.append( Utilities.writeURLParameter( "comeFromQuickSearch", AbstractFormBean.SHOW.toString() ) );
    }
    return url.toString();
  }

  /**
   * This method will transform the request parameters into a form compatible hidden input parameters, for example.
   * &ltINPUT type="hidden" name="paramName" value="paramValue"&gt.
   * @param classFields Fields to be included in parameters.
   * @return An form compatible type of representation of request parameters.
   */
  public String toFORMParam(Vector classFields) {
    StringBuffer form = new StringBuffer();
    form.append(toFORMParamSuper(classFields));
    if (classFields.contains("criteriaSearch")) {
      AbstractSearchCriteria[] searchCriterias = toSearchCriteria();
      for (int i = 0; i < searchCriterias.length; i++) {
        AbstractSearchCriteria aSearch = searchCriterias[i];
        form.append(aSearch.toFORMParam());
      }
    }
    if ( null != typeForm )
    {
      form.append( Utilities.writeFormParameter( "typeForm", typeForm ) );
    }
    if ( null != expand )
    {
      form.append( Utilities.writeFormParameter( "expand", expand ) );
    }
    // Column to be displayed
    if ( null != showGroup && showGroup.equalsIgnoreCase( "true" ) )
    {
      form.append( Utilities.writeFormParameter( "showGroup", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != showOrder && showOrder.equalsIgnoreCase( "true" ) )
    {
      form.append( Utilities.writeFormParameter( "showOrder", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != showFamily && showFamily.equalsIgnoreCase( "true" ) )
    {
      form.append( Utilities.writeFormParameter( "showFamily", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != showScientificName && showScientificName.equalsIgnoreCase( "true" ) )
    {
      form.append( Utilities.writeFormParameter( "showScientificName", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != showVernacularNames && showVernacularNames.equalsIgnoreCase( "true" ) )
    {
      form.append( Utilities.writeFormParameter( "showVernacularNames", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != showValidName && showValidName.equalsIgnoreCase( "true" ) )
    {
      form.append( Utilities.writeFormParameter( "showValidName", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != searchSynonyms && searchSynonyms.equalsIgnoreCase( "true" ) )
    {
      form.append( Utilities.writeFormParameter( "searchSynonyms", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != searchVernacular && searchVernacular.booleanValue() )
    {
      form.append( Utilities.writeFormParameter( "searchVernacular", AbstractFormBean.SHOW.toString() ) );
    }
    if ( null != comeFromQuickSearch && comeFromQuickSearch.equalsIgnoreCase( "true" ) )
    {
      form.append( Utilities.writeFormParameter( "comeFromQuickSearch", AbstractFormBean.SHOW.toString() ) );
    }
    return form.toString();
  }

  /**
   * Getter for relationOp property - Relation between searched string (is, contains, starts).
   * @return value of relationOp
   */
  public String getRelationOp()
  {
    return relationOp;
  }

  /**
   * Setter for relationOp property - Relation between searched string (is, contains, starts).
   * @param relationOp new value for relationOp
   */
  public void setRelationOp(String relationOp)
  {
    this.relationOp = relationOp;
  }

  /**
   * Getter for scientificName property - Scientific name of the searched specie.
   * @return value of scientificName
   */
  public String getScientificName() {
    return scientificName;
  }

  /**
   * Setter for scientificName property - Scientific name of the searched specie.
   * @param scientificName new value for scientificName
   */
  public void setScientificName(String scientificName) {
    this.scientificName = scientificName;
  }

  /**
   * Getter for vernacularName property - Popular name of that specie (used in second input form).
   * @return value of vernacularName
   */
  public String getVernacularName() {
    return vernacularName;
  }

  /**
   * Setter for vernacularName property - Popular name of that specie (used in second input form).
   * @param vernacularName new value for vernacularName
   */
  public void setVernacularName(String vernacularName) {
    this.vernacularName = vernacularName;
  }

  /**
   * Getter for language property - Language search was done in.
   * @return value of language
   */
  public String getLanguage() {
    return language;
  }

  /**
   * Setter for language property - Language search was done in.
   * @param language new value for language
   */
  public void setLanguage(String language) {
    this.language = language;
  }

  /**
   * Getter for typeForm property - The form used for search  (form 1 or 2).
   * @return value of typeForm
   */
  public String getTypeForm() {
    return typeForm;
  }

  /**
   * Setter for typeForm property - The form used for search  (form 1 or 2).
   * @param typeForm new value for typeForm
   */
  public void setTypeForm(String typeForm) {
    this.typeForm = typeForm;
  }

  /**
   * Getter for expand property - Expand or collapse vernacualar names column in results.
   * @return valuue of expand
   */
  public String getExpand() {
    return expand;
  }

  /**
   * Setter for expand property - Expand or collapse vernacualar names column in results.
   * @param expand new value for expand
   */
  public void setExpand(String expand) {
    this.expand = expand;
  }

  /**
   * Getter for showGroup property - Specifies if Group column will be displayed in resulted table.
   * @return value of showGroup
   */
  public String getShowGroup() {
    return showGroup;
  }

  /**
   * Setter for showGroup property - Specifies if Group column will be displayed in resulted table.
   * @param showGroup new value for showGroup
   */
  public void setShowGroup(String showGroup) {
    this.showGroup = showGroup;
  }

  /**
   * Getter for showOrder property - Specifies if Order column will be displayed in resulted table.
   * @return value of showOrder
   */
  public String getShowOrder() {
    return showOrder;
  }

  /**
   * Setter for showOrder property - Specifies if Order column will be displayed in resulted table.
   * @param showOrder new value for showOrder
   */
  public void setShowOrder(String showOrder) {
    this.showOrder = showOrder;
  }

  /**
   * Getter for showFamily property - Specifies if Family column will be displayed in resulted table.
   * @return value of showFamily
   */
  public String getShowFamily() {
    return showFamily;
  }

  /**
   * Setter for showFamily property - Specifies if Family column will be displayed in resulted table.
   * @param showFamily new value for showFamily
   */
  public void setShowFamily(String showFamily) {
    this.showFamily = showFamily;
  }

  /**
   * Getter for showScientificName property - Specifies if Scientific Name column will be displayed in resulted table.
   * @return value of showScientificName
   */
  public String getShowScientificName() {
    return showScientificName;
  }

  /**
   * Setter for showScientificName property - Specifies if Scientific Name column will be displayed in resulted table.
   * @param showScientificName value of showScientificName
   */
  public void setShowScientificName(String showScientificName) {
    this.showScientificName = showScientificName;
  }

  /**
   * Getter for showVernacularNames property - Specifies if Vernacular Names column will be displayed in resulted table.
   * Note that if this is true, then expand/collapse will be available in page
   * @return value of showVernacularNames
   */
  public String getShowVernacularNames() {
    return showVernacularNames;
  }

  /**
   * Setter for showVernacularNames property - Specifies if Vernacular Names column will be displayed in resulted table.
   * Note that if this is true, then expand/collapse will be available in page
   * @param showVernacularNames new value for showVernacularNames
   */
  public void setShowVernacularNames(String showVernacularNames) {
    this.showVernacularNames = showVernacularNames;
  }

  /**
   * Getter for searchSynonyms property - Specifies if search would also take place in synonyms column.
   * @return value of searchSynonyms property.
   */
  public String getSearchSynonyms()
  {
    return searchSynonyms;
  }

  /**
   * Setter for searchSynonyms property - Specifies if search would also take place in synonyms column.
   * @param searchSynonyms new value for searchSynonyms
   */
  public void setSearchSynonyms( String searchSynonyms )
  {
    this.searchSynonyms = searchSynonyms;
  }

  /**
   * Getter for showValidName property - Specifies if Valid name column will be displayed in resulted table.
   * @return value of showValidName property.
   */
  public String getShowValidName()
  {
    return showValidName;
  }

  /**
   * Setter for showValidName property - Specifies if Valid name column will be displayed in resulted table.
   * @param showValidName New value
   */
  public void setShowValidName( String showValidName )
  {
    this.showValidName = showValidName;
  }

  /**
   * Getter.
   * @return searchVernacular
   */
  public Boolean getSearchVernacular()
  {
    return searchVernacular;
  }

  /**
   * Setter.
   * @param searchVernacular new value
   */
  public void setSearchVernacular( Boolean searchVernacular )
  {
    this.searchVernacular = searchVernacular;
  }

  /**
   * Getter for oldName property - Specifies searched name if name was chossen from soundex table.
   * @return value of oldName property.
   */
  public String getOldName()
  {
    return oldName;
  }

  /**
   * Setter for oldName property - Specifies searched name if name was chossen from soundex table.
   * @param oldName New value
   */
  public void setOldName( String oldName )
  {
    this.oldName = oldName;
  }

  /**
   * Getter.
   * @return noSoundex
   */
  public String getNoSoundex()
  {
    return noSoundex;
  }

  /**
   * Setter.
   * @param noSoundex New value
   */
  public void setNoSoundex( String noSoundex )
  {
    this.noSoundex = noSoundex;
  }

  /**
   * Getter.
   * @return comeFromQuickSearch
   */
  public String getComeFromQuickSearch() {
    return comeFromQuickSearch;
  }

  /**
   * Setter.
   * @param comeFromQuickSearch New value
   */
  public void setComeFromQuickSearch( String comeFromQuickSearch ) {
    this.comeFromQuickSearch = comeFromQuickSearch;
  }
}