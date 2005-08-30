package ro.finsiel.eunis.jrfTables.users;

import net.sf.jrf.domain.PersistentObject;

/**
 * Date: Sep 9, 2003
 * Time: 11:27:40 AM
 */
public class UsersRightsPersist extends PersistentObject {
  /** This is a database field. */
  private String i_username = null;
  /** This is a database field. */
  private String i_password = null;
  /** This is a database field. */
  private Integer i_fontsize = null;
  /** This is a database field. */
  private String firstName = null;
  private Integer themeIndex = null;
  private String lastName = null;
  private String rightName = null;
  private String EMail = null;


  /** Default constructor */
  public UsersRightsPersist() {
    super();
  }


  /** Getter for a database field. */
  public Integer getFontsize() {
    return i_fontsize;
  }


  /** Getter for a database field. */
  public String getPassword() {
    return i_password;
  }


  /** Getter for a database field. */
  public String getUsername() {
    return i_username;
  }

  /**
   * Setter for a database field.
   * @param fontsize
   **/
  public void setFontsize(Integer fontsize) {
    i_fontsize = fontsize;
    this.markModifiedPersistentState();
  }


  /**
   * Setter for a database field.
   * @param password
   **/
  public void setPassword(String password) {
    i_password = password;
    this.markModifiedPersistentState();
  }


  /**
   * Setter for a database field.
   * @param username
   **/
  public void setUsername(String username) {
    i_username = username;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  public Integer getThemeIndex() {
    return themeIndex;
  }

  public void setThemeIndex(Integer themeIndex) {
    this.themeIndex = themeIndex;
  }

  public String getRightName() {
    return rightName;
  }

  public void setRightName(String rightName) {
    this.rightName = rightName;
  }

  public String getFirstName() {
    return firstName;
  }

  public void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  public String getLastName() {
    return lastName;
  }

  public void setLastName(String lastName) {
    this.lastName = lastName;
  }


  public String getEMail() {
    return EMail;
  }

  public void setEMail(String EMail) {
    this.EMail = EMail;
  }
}
