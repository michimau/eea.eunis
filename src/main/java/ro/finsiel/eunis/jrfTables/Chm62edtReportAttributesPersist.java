package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

public class Chm62edtReportAttributesPersist extends PersistentObject {
  private Integer idReportAttributes = null;
  private String name = null;
  private String type = null;
  private String value = null;

  public Integer getIdReportAttributes() {
    return idReportAttributes;
  }

  public void setIdReportAttributes(Integer idReportAttributes) {
    this.idReportAttributes = idReportAttributes;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public String getValue() {
    if (null == value) {
      return "";
    } else {
      if (value.equalsIgnoreCase("-1")) return "n/a";
      return value;
    }
  }

  public void setValue(String value) {
    this.value = value;
  }
}
