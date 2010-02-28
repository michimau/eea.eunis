package ro.finsiel.eunis.formBeans;

/**
 * Form bean used for EUNIS habitat browser.
 * @author finsiel
 */
public class HabitatTreeBean implements java.io.Serializable {
  private String habCode;
  private String habID;
  private String openNode;

  /**
   * Creates an new HabitatTreeBean object.
   */
  public HabitatTreeBean() {
  }

  /**
   * Getter for habCode property.
   * @return habCode.
   */
  public String getHabCode() {
    return habCode;
  }

  /**
   * Setter for habCode.
   * @param value habCode.
   */
  public void setHabCode(String value) {
    habCode = value;

  }

  /**
   * Getter for habID property.
   * @return habID.
   */
  public String getHabID() {
    return habID;
  }

  /**
   * Setter for habID property.
   * @param value habID.
   */
  public void setHabID(String value) {
    habID = value;

  }

  /**
   * Getter for openNode property.
   * @return openNode.
   */
  public String getOpenNode() {
    return openNode;
  }

  /**
   * Setter for openNode property.
   * @param value openNode.
   */
  public void setOpenNode(String value) {
    openNode = value;
  }
}
