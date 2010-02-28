package ro.finsiel.eunis.jrfTables.save_criteria;

import net.sf.jrf.domain.PersistentObject;

/**
 * Date: Sep 22, 2003
 * Time: 1:03:13 PM
 */
public class CriteriasForUsersPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private String nameCriteria = null;
  /**
   * This is a database field.
   **/
  private String description = null;
  /**
   * This is a database field.
   **/
  private String users = null;
  /**
   * This is a database field.
   **/
  private java.sql.Timestamp data = null;
  /**
   * This is a database field.
   **/
  private String fromWhere = null;
  private String criteriaAttribute = null;
  private String criteriaFormFieldAttribute = null;
  private String criteriaFormFieldOperator = null;
  private String criteriaOperator = null;
  private String criteriaFirstValue = null;
  private String criteriaLastValue = null;


  public CriteriasForUsersPersist() {
    super();
  }

  public String getNameCriteria() {
    return nameCriteria;
  }

  public void setNameCriteria(String nameCriteria) {
    this.nameCriteria = nameCriteria;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getUsers() {
    return users;
  }

  public void setUsers(String users) {
    this.users = users;
  }

  public java.sql.Timestamp getData() {
    return data;
  }

  public void setData(java.sql.Timestamp data) {
    this.data = data;
  }

  public String getFromWhere() {
    return fromWhere;
  }

  public void setFromWhere(String fromWhere) {
    this.fromWhere = fromWhere;
  }

  public String getCriteriaAttribute() {
    return criteriaAttribute;
  }

  public void setCriteriaAttribute(String criteriaAttribute) {
    this.criteriaAttribute = criteriaAttribute;
  }

  public String getCriteriaFormFieldAttribute() {
    return criteriaFormFieldAttribute;
  }

  public void setCriteriaFormFieldAttribute(String criteriaFormFieldAttribute) {
    this.criteriaFormFieldAttribute = criteriaFormFieldAttribute;
  }

  public String getCriteriaFormFieldOperator() {
    return criteriaFormFieldOperator;
  }

  public void setCriteriaFormFieldOperator(String criteriaFormFieldOperator) {
    this.criteriaFormFieldOperator = criteriaFormFieldOperator;
  }

  public String getCriteriaOperator() {
    return criteriaOperator;
  }

  public void setCriteriaOperator(String criteriaOperator) {
    this.criteriaOperator = criteriaOperator;
  }

  public String getCriteriaFirstValue() {
    return criteriaFirstValue;
  }

  public void setCriteriaFirstValue(String criteriaFirstValue) {
    this.criteriaFirstValue = criteriaFirstValue;
  }

  public String getCriteriaLastValue() {
    return criteriaLastValue;
  }

  public void setCriteriaLastValue(String criteriaLastValue) {
    this.criteriaLastValue = criteriaLastValue;
  }

}