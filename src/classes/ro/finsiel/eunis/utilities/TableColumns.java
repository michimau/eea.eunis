package ro.finsiel.eunis.utilities;

import java.util.List;
import java.util.ArrayList;

/**
 * Created by IntelliJ IDEA.
 * User: aignat
 * Date: 07.04.2005
 * Time: 12:08:53
 * To change this template use File | Settings | File Templates.
 */
public class TableColumns {

 List columnsNames = new ArrayList();
 List columnsValues = new ArrayList();

  public List getColumnsNames() {
    return columnsNames;
  }

  public void setColumnsNames(List columnsNames) {
    this.columnsNames = columnsNames;
  }

  public List getColumnsValues() {
    return columnsValues;
  }

  public void setColumnsValues(List columnsValues) {
    this.columnsValues = columnsValues;
  }


}
