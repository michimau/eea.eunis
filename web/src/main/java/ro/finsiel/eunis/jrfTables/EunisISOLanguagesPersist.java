package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * Created by IntelliJ IDEA.
 * User: cromanescu
 * Date: Sep 29, 2005
 * Time: 3:09:58 PM
 * To change this template use File | Settings | File Templates.
 */
public class EunisISOLanguagesPersist extends PersistentObject {
  private String name = "";
  private String code = "";

  public String getCode() {
    return code;
  }

  public void setCode( String code ) {
    this.code = code;
  }

  public String getName() {
    return name;
  }

  public void setName( String name ) {
    this.name = name;
  }
}
