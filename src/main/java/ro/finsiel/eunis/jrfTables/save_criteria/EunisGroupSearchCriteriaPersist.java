package ro.finsiel.eunis.jrfTables.save_criteria;

import net.sf.jrf.domain.PersistentObject;

/**
 * Date: Sep 19, 2003
 * Time: 11:07:38 AM
 */
public class EunisGroupSearchCriteriaPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private String nameCriteria = null;
  /**
   * This is a database field.
   **/
  private String idGroupSearchCriteria = null;
  /**
   * This is a database field.
   **/
  private String attribute = null;
  /**
   * This is a database field.
   **/
  private String formFieldAttribute = null;
  /**
   * This is a database field.
   **/
  private String operator = null;
  /**
   * This is a database field.
   **/
  private String formFieldOperator = null;
  /**
   * This is a database field.
   **/
  private String criteriaBoolean = null;

  /**
   * This is a database field.
   **/
  private String firstValue = null;

  /**
   * This is a database field.
   **/
  private String lastValue = null;


  public EunisGroupSearchCriteriaPersist() {
    super();
  }

  public String getNameCriteria() {
    return nameCriteria;
  }

  public void setNameCriteria(String nameCriteria) {
    this.nameCriteria = nameCriteria;
  }

  public String getIdGroupSearchCriteria() {
    return idGroupSearchCriteria;
  }

  public void setIdGroupSearchCriteria(String idGroupSearchCriteria) {
    this.idGroupSearchCriteria = idGroupSearchCriteria;
  }

  public String getAttribute() {
    return attribute;
  }

  public void setAttribute(String attribute) {
    this.attribute = attribute;
  }

  public String getFormFieldAttribute() {
    return formFieldAttribute;
  }

  public void setFormFieldAttribute(String formFieldAttribute) {
    this.formFieldAttribute = formFieldAttribute;
  }

  public String getOperator() {
    return operator;
  }

  public void setOperator(String operator) {
    this.operator = operator;
  }

  public String getFormFieldOperator() {
    return formFieldOperator;
  }

  public void setFormFieldOperator(String formFieldOperator) {
    this.formFieldOperator = formFieldOperator;
  }

  public String getCriteriaBoolean() {
    return criteriaBoolean;
  }

  public void setCriteriaBoolean(String criteriaBoolean) {
    this.criteriaBoolean = criteriaBoolean;
  }

  public String getFirstValue() {
    return firstValue;
  }

  public void setFirstValue(String firstValue) {
    this.firstValue = firstValue;
  }

  public String getLastValue() {
    return lastValue;
  }

  public void setLastValue(String lastValue) {
    this.lastValue = lastValue;
  }
}