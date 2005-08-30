package ro.finsiel.eunis.search.species.taxcode;


/**
 * Form bean used in species-taxonomic-browser.
 * @author finsiel
 */
public class TaxcodeTreeBean extends Object implements java.io.Serializable {
  private String idTaxonomy, idTaxExpanded, openNode;
  private String startlevel,depth;

  /**
   * Creates new TaxonomicTreeBean.
   */
  public TaxcodeTreeBean() {}

  /**
   * Getter for idTaxonomy property.
   * @return idTaxonomy.
   */
  public String getIdTaxonomy() {
    return idTaxonomy;
  }

  /**
   * Setter for idTaxonomy property.
   * @param idTaxonomy idTaxonomy.
   */
  public void setIdTaxonomy(String idTaxonomy) {
    this.idTaxonomy = idTaxonomy;
  }

  /**
   * Getter for idTaxExpanded property.
   * @return idTaxExpanded.
   */
  public String getIdTaxExpanded() {
    return idTaxExpanded;
  }

  /**
   * Setter for idTaxExpanded property.
   * @param idTaxExpanded idTaxExpanded.
   */
  public void setIdTaxExpanded(String idTaxExpanded) {
    this.idTaxExpanded = idTaxExpanded;
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
   * @param openNode openNode.
   */
  public void setOpenNode(String openNode) {
    this.openNode = openNode;
  }

  /**
   * Getter for startLevel property.
   * @return startLevel.
   */
  public String getStartlevel() {
    return startlevel;
  }

  /**
   * Setter for startlevel property.
   * @param startlevel startlevel.
   */
  public void setStartlevel(String startlevel) {
    this.startlevel = startlevel;
  }

  /**
   * Getter for depth property.
   * @return depth.
   */
  public String getDepth() {
    return depth;
  }

  /**
   * Setter for depth property.
   * @param depth depth.
   */
  public void setDepth(String depth) {
    this.depth = depth;
  }
}
