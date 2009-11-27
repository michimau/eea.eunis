package ro.finsiel.eunis.jrfTables;

/**
 * Interface used for object retrieved from habitat dictionaries tables.
 * @author finsiel
 */
public interface HabitatOtherInfo {
  /**
   * Getter for name property (Dictionaries contains NAME = VALUE - or called - DESCRIPTION). This method retrieves the name.
   * @return Name.
   */
  String getName();

  /**
   * Getter for value property (Dictionaries contains NAME = VALUE - or called DESCRIPTION. This method retrieves the value.
   * @return Description.
   */
  String getDescription();
}