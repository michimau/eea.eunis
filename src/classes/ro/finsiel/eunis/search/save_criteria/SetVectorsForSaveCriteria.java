package ro.finsiel.eunis.search.save_criteria;

/**
 * Date: Sep 25, 2003
 * Time: 5:45:21 PM
 */

import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import java.util.Vector;

/** This class set vectors used in save criteria for next searches : species-country search, species-threat-international search
 *  species-threat-national search and species-legal search.
 * @author Finsiel.
*/
public class SetVectorsForSaveCriteria {

  // attributesNames vector contains attributes names values witch will be inserts into criteria_attribute table field
  //from eunis_group_search_criteria table
  private Vector attributesNames = new Vector();
  // formFieldAttributes vector contains form field attributes names values witch will be inserts into
  //criteria_form_field_attribute table field from eunis_group_search_criteria table
  private Vector formFieldAttributes = new Vector();
  // formFieldOperators vector contains form field operators names values witch will be inserts into
  //criteria_form_field_operator table field from eunis_group_search_criteria table
  private Vector formFieldOperators = new Vector();
  // booleans vector contains booleans values witch will be inserts into criteria_boolean table field
  //from eunis_group_search_criteria table
  private Vector booleans = new Vector();
  // operators vector contains operators names values witch will be inserts into criteria_operator table field
  //from eunis_group_search_criteria table
  private Vector operators = new Vector();
  // firstValue vector contains first value of attribute names witch will be inserts into
  //criteria_first_value table field from eunis_group_search_criteria table
  private Vector firstValue = new Vector();
  // lastValue vector contains last value of attribute names witch will be inserts into
  //criteria_last_value table field from eunis_group_search_criteria table
  private Vector lastValue = new Vector();

  /**
   * Set vectors for species-country search.
   * @param country id country
   * @param region id region
   * @param countryName country name
   * @param regionName region name
   */

  public void SetVectorsForSaveCriteriaSpeciesCountry(String country,
                                         String region,
                                         String countryName,
                                         String regionName) {

    attributesNames.add("Country name");
    attributesNames.add("");
    attributesNames.add("Region name");
    attributesNames.add("");

    formFieldAttributes.add("countryName");
    formFieldAttributes.add("country");
    formFieldAttributes.add("regionName");
    formFieldAttributes.add("region");

    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");


    booleans.add("and");
    booleans.add("");
    booleans.add("");
    booleans.add("");

    operators.add("is");
    operators.add("");
    operators.add("is");
    operators.add("");

    firstValue.add(countryName);
    firstValue.add(country);
    firstValue.add(regionName);
    firstValue.add(region);

    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");

  }

  /**
   * Set vectors for species-threat-international search.
   * @param idGroup id group species
   * @param idConservation id species conservation status
   * @param indice indice
   * @param nameGroup group species name
   * @param nameStatus species conservation status name
   */
  public void SetVectorsForSaveCriteriaSpeciesThreatInternational(String idGroup,
                                                     String idConservation,
                                                     String idCountry,
                                                     String indice,
                                                     String nameGroup,
                                                     String nameStatus,
                                                     String nameCountry) {

    attributesNames.add("Group name");
    attributesNames.add("");
    attributesNames.add("Area name");
    attributesNames.add("");
    attributesNames.add("Status name");
    attributesNames.add("");
    attributesNames.add("");

    formFieldAttributes.add("groupName");
    formFieldAttributes.add("idGroup");
    formFieldAttributes.add("countryName");
    formFieldAttributes.add("idCountry");
    formFieldAttributes.add("statusName");
    formFieldAttributes.add("idConservation");
    formFieldAttributes.add("indice");

    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");


    booleans.add("and");
    booleans.add("");
    booleans.add("and");
    booleans.add("");
    booleans.add("");
    booleans.add("");
    booleans.add("");

    operators.add("is");
    operators.add("");
    operators.add("is");
    operators.add("");
    operators.add("is");
    operators.add("");
    operators.add("");

    firstValue.add(nameGroup);
    firstValue.add(idGroup);
    firstValue.add(nameCountry);
    firstValue.add(idCountry);
    firstValue.add(nameStatus);
    firstValue.add(idConservation);
    firstValue.add(indice);

    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");

  }


  /**
   * Set vectors for species-threat-national search.
   * @param idGroup id group species
   * @param idConservation id species conservation status
   * @param idCountry id country
   * @param indice indice
   * @param groupName group species name
   * @param statusName species conservation status name
   * @param countryName country name
   */
  public void SetVectorsForSaveCriteriaSpeciesThreatNational(String idGroup,
                                                String idConservation,
                                                String idCountry,
                                                String indice,
                                                String groupName,
                                                String statusName,
                                                String countryName) {

    attributesNames.add("Group name");
    attributesNames.add("");
    attributesNames.add("Status name");
    attributesNames.add("");
    attributesNames.add("Country name");
    attributesNames.add("");
    attributesNames.add("");

    formFieldAttributes.add("groupName");
    formFieldAttributes.add("idGroup");
    formFieldAttributes.add("statusName");
    formFieldAttributes.add("idConservation");
    formFieldAttributes.add("countryName");
    formFieldAttributes.add("idCountry");
    formFieldAttributes.add("indice");

    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");


    booleans.add("and");
    booleans.add("");
    booleans.add("and");
    booleans.add("");
    booleans.add("");
    booleans.add("");
    booleans.add("");

    operators.add("is");
    operators.add("");
    operators.add("is");
    operators.add("");
    operators.add("is");
    operators.add("");
    operators.add("");

    firstValue.add(groupName);
    firstValue.add(idGroup);
    firstValue.add(statusName);
    firstValue.add(idConservation);
    firstValue.add(countryName);
    firstValue.add(idCountry);
    firstValue.add(indice);

    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
  }

  /**
   * Set vectors for species-legal search.
   * @param groupName group species name
   * @param legalText species legal text
   * @param annex annex for species legal text
   * @param scientificName species scientific name
   * @param typeForm type form
   */
  public void SetVectorsForSaveCriteriaSpeciesLegal(String groupName,
                                       String legalText,
                                       String annex,
                                       String scientificName,
                                       String typeForm) {

    attributesNames.add("Group name");
    attributesNames.add("");
    attributesNames.add("Legal instrument is Annex/Appendix " + annex);
    attributesNames.add("");
    attributesNames.add("Species scientific name");
    attributesNames.add("");

    formFieldAttributes.add("");
    formFieldAttributes.add("groupName");
    formFieldAttributes.add("legalText");
    formFieldAttributes.add("annex");
    formFieldAttributes.add("scientificName");
    formFieldAttributes.add("typeForm");

    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");
    formFieldOperators.add("");


    booleans.add("and");
    booleans.add("");
    booleans.add("");
    booleans.add("");
    booleans.add("");
    booleans.add("");

    operators.add("is");
    operators.add("");
    operators.add("");
    operators.add("");
    operators.add("contains");
    operators.add("");

    firstValue.add((SpeciesSearchUtility.findGroupName(groupName) == null ? "" : SpeciesSearchUtility.findGroupName(groupName)));
    firstValue.add((groupName == null ? "" : groupName));
    firstValue.add((legalText == null ? "" : legalText));
    firstValue.add((annex == null ? "" : annex));
    firstValue.add((scientificName == null ? "" : scientificName));
    firstValue.add((typeForm == null ? "" : typeForm));

    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
    lastValue.add("");
  }

  /**
   * Get attributesNames vector.
   * @return attributesNames vector
   */
  public Vector getAttributesNames() {
    return attributesNames;
  }

  /**
   * Get formFieldAttributes vector.
   * @return formFieldAttributes vector
   */
  public Vector getFormFieldAttributes() {
    return formFieldAttributes;
  }

  /**
   * Get formFieldOperators vector.
   * @return formFieldOperators vector
   */
  public Vector getFormFieldOperators() {
    return formFieldOperators;
  }

  /**
   * Get booleans vector.
   * @return booleans vector
   */
  public Vector getBooleans() {
    return booleans;
  }

  /**
   * Get operators vector.
   * @return operators vector
   */
  public Vector getOperators() {
    return operators;
  }

  /**
   * Get firstValue vector.
   * @return firstValue vector
   */
  public Vector getFirstValue() {
    return firstValue;
  }

  /**
   * Get lastValue vector.
   * @return lastValue vector
   */
  public Vector getLastValue() {
    return lastValue;
  }
}
