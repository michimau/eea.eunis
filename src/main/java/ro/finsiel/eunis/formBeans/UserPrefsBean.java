package ro.finsiel.eunis.formBeans;

/**
 * Bean used within user preferences page.
 * @author finsiel
 */
public class UserPrefsBean implements java.io.Serializable {
  private String action = "";
  private String username = "";
  private String textSize = "";
  private String themeIndex = "";

  /**
   * Getter for action property.
   * @return action.
   */
  public String getAction() {
    return action;
  }

  /**
   * Setter for action property.
   * @param newAction action.
   */
  public void setAction(String newAction) {
    this.action = newAction;
  }

  /**
   * Getter for textSize.
   * @return textSize.
   */
  public String getTextSize() {
    return textSize;
  }

  /**
   * Setter for textSize property.
   * @param textSize textSize.
   */
  public void setTextSize(String textSize) {
    this.textSize = textSize;
  }

  /**
   * Getter for username property.
   * @return username.
   */
  public String getUsername() {
    return username;
  }

  /**
   * Setter for username property.
   * @param username username.
   */
  public void setUsername(String username) {
    this.username = username;
  }

  /**
   * Getter for themeIndex property.
   * @return themeIndex.
   */
  public String getThemeIndex() {
    return themeIndex;
  }

  /**
   * Setter for themeIndex property.
   * @param themeIndex themeIndex.
   */
  public void setThemeIndex(String themeIndex) {
    this.themeIndex = themeIndex;
  }
}