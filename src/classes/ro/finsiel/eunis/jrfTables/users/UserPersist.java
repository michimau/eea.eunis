package ro.finsiel.eunis.jrfTables.users;

import net.sf.jrf.domain.PersistentObject;
import ro.finsiel.eunis.session.ThemeManager;

public class UserPersist extends PersistentObject {
  public static final Integer TEXT_SIZE_NORMAL = new Integer(0);
  public static final Integer TEXT_SIZE_MEDIUM = new Integer(1);
  public static final Integer TEXT_SIZE_LARGE = new Integer(2);

  /** This is a database field. */
  private String i_username = null;
  /** This is a database field. */
  private String i_password = null;
  /** This is a database field. */
  private String firstName = null;
  private Integer themeIndex = new Integer(ThemeManager.THEME_SKY_BLUE);
  private String lastName = null;
  private String EMail = null;
  private String loginDate = null;
  private String lang = null;


  /** Default constructor */
  public UserPersist() {
    super();
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

  public String getLoginDate() {
    return (loginDate != null && loginDate.equalsIgnoreCase("1900-01-01 00:00:00") ? "" : loginDate);
  }

  public void setLoginDate(String loginDate) {
    this.loginDate = loginDate;
  }

  public String getLang() {
    return lang;
  }

  public void setLang( String lang ) {
    this.lang = lang;
  }
}