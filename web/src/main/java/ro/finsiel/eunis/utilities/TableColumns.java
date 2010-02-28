package ro.finsiel.eunis.utilities;

import java.util.List;
import java.util.ArrayList;

/**
 * Wrapper for table columns resulted from execution of a SQL statement
 */
public class TableColumns {

 List columnsNames = new ArrayList();
 List columnsValues = new ArrayList();

  /**
   * Getter for columnNames property
   * @return columnNames
   */
  public List getColumnsNames() {
    return columnsNames;
  }

  /**
   * Setter for columnNames property
   * @param columnsNames New value
   */
  public void setColumnsNames(List columnsNames) {
    this.columnsNames = columnsNames;
  }

  /**
   * Getter for columnsValues property
   * @return columnsValues
   */
  public List getColumnsValues() {
    return columnsValues;
  }

  /**
   * Setter for columnsValues property
   * @param columnsValues New value
   */
  public void setColumnsValues(List columnsValues) {
    this.columnsValues = columnsValues;
  }
}
