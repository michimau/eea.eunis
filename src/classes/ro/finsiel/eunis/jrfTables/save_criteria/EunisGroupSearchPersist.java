package ro.finsiel.eunis.jrfTables.save_criteria;

import net.sf.jrf.domain.PersistentObject;

/**
 * Date: Sep 19, 2003
 * Time: 10:57:27 AM
 */
public class EunisGroupSearchPersist extends PersistentObject {

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


  public EunisGroupSearchPersist() {
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

}