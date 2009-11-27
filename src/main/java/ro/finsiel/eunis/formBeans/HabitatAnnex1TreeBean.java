package ro.finsiel.eunis.formBeans;

/**
 * Form bean used for habitat Annex I browser.
 * @author finsiel
 */
public class HabitatAnnex1TreeBean extends Object implements java.io.Serializable {
  private String habCode2000;
  private String habID;
  private String openNode;

  /**
   * Creates an new HabitatAnnex1TreeBean object.
   */
  public HabitatAnnex1TreeBean() {
  }

  /**
   * Getter for habCode2000 property.
   * @return habCode2000.
   */
  public String getHabCode2000() {
    return habCode2000;
  }

  /**
   * Setter for habCode2000 property.
   * @param value habCode2000.
   */
  public void setHabCode2000(String value) {
    habCode2000 = value;

  }

  /**
   * Getter for habID property.
   * @return ID_HABITAT.
   */
  public String getHabID() {
    return habID;
  }

  /**
   * Setter for habID property.
   * @param value ID_HABITAT.
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
