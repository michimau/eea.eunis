package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:51 $
 **/
public class Chm62edtNatureObjectPicturePersist extends PersistentObject {

  private String i_idObject = null;
  private String i_natureObjectType = null;
  private String i_name = null;
  private String i_fileName = null;
  private String i_description = null;

  public Chm62edtNatureObjectPicturePersist() {
    super();
  }

  public String getIdObject() {
    return i_idObject;
  }

  public void setIdObject(String idObject) {
    i_idObject = idObject;
    this.markModifiedPersistentState();
    this.markModifiedPersistentState();
  }

  public String getNatureObjectType() {
    return i_natureObjectType;
  }

  public void setNatureObjectType(String natureObjectType) {
    i_natureObjectType = natureObjectType;
    this.markModifiedPersistentState();
    this.markModifiedPersistentState();
  }

  public String getName() {
    return i_name;
  }

  public void setName(String name) {
    this.i_name = name;
    this.markModifiedPersistentState();
    this.markModifiedPersistentState();
  }

  public String getFileName() {
    return i_fileName;
  }

  public void setFileName(String fileName) {
    this.i_fileName = fileName;
    this.markModifiedPersistentState();
    this.markModifiedPersistentState();
  }

  public String getDescription() {
    return i_description;
  }

  public void setDescription(String description) {
    i_description = description;
    this.markModifiedPersistentState();
    this.markModifiedPersistentState();
  }

}