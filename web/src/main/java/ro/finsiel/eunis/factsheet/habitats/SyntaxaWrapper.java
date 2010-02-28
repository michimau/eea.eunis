package ro.finsiel.eunis.factsheet.habitats;

/**
 * Wrapper object for syntaxa information for a habitat.
 * @author finsiel
 */
public class SyntaxaWrapper {

  private String source = "";
  private String relation = "";
  private String sourceAbbrev = "";
  private Integer IdDc = null;
  private String name = "";
  private String author = "";

  /**
   * Getter for idDc property.
   * @return ID_DC.
   */
  public Integer getIdDc() {
    if (null == IdDc) return new Integer(0);
    return IdDc;
  }

  /**
   * Setter for idDc property.
   * @param idDc ID_DC.
   */
  public void setIdDc(Integer idDc) {
    IdDc = idDc;
  }

  /**
   * Getter for name property.
   * @return Name.
   */
  public String getName() {
    return name;
  }

  /**
   * Setter for name property.
   * @param name Name.
   */
  public void setName(String name) {
    this.name = name;
  }

  /**
   * Getter for author property.
   * @return Author.
   */
  public String getAuthor() {
    return author;
  }

  /**
   * Setter for author property.
   * @param author New value
   */
  public void setAuthor(String author) {
    this.author = author;
  }

  /**
   * Getter for source property.
   * @return Source.
   */
  public String getSource() {
    return source;
  }

  /**
   * Setter for source property.
   * @param source Source.
   */
  public void setSource(String source) {
    this.source = source;
  }

  /**
   * Getter for relation property.
   * @return Relation.
   */
  public String getRelation() {
    return relation;
  }

  /**
   * Setter for relation property.
   * @param relation Relation.
   */
  public void setRelation(String relation) {
    this.relation = relation;
  }

  /**
   * Getter for sourceAbbrev property.
   * @return Source abbrev.
   */
  public String getSourceAbbrev() {
    return sourceAbbrev;
  }

  /**
   * Setter for sourceAbbrev property.
   * @param sourceAbbrev Source abbrev.
   */
  public void setSourceAbbrev(String sourceAbbrev) {
    this.sourceAbbrev = sourceAbbrev;
  }
}
