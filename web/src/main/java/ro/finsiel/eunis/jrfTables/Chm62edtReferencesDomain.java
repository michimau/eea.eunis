package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for CHM62EDT_REFERENCES.
 * @author finsiel
 **/
public class Chm62edtReferencesDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtReferencesPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_REFERENCES");
    this.setReadOnly(true);

    this.addColumnSpec(new IntegerColumnSpec("ID_REFERENCE", "getIdRererence", "setIdReference", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("AUTHOR", "getAuthor", "setAuthor", null));
    this.addColumnSpec(new StringColumnSpec("PUBLICATION_DATE", "getPublicationDate", "setPublicationDate", null));
    this.addColumnSpec(new StringColumnSpec("TITLE", "getTitle", "setTitle", null));
    this.addColumnSpec(new StringColumnSpec("TITLE_ABBREV", "getTitleAbbrev", "setTitleAbbrev", null));
    this.addColumnSpec(new StringColumnSpec("EDITOR", "getEditor", "setEditor", null));
    this.addColumnSpec(new StringColumnSpec("JOURNAL", "getJournal", "setJournal", null));
    this.addColumnSpec(new StringColumnSpec("BOOK", "getBook", "setBook", null));
    this.addColumnSpec(new StringColumnSpec("JOURNAL_ISSUE", "getJournalIssue", "setJournalIssue", null));
    this.addColumnSpec(new StringColumnSpec("PUBLISHER", "getPublisher", "setPublisher", null));
    this.addColumnSpec(new StringColumnSpec("ISBN", "getIsbn", "setIsbn", null));
    this.addColumnSpec(new StringColumnSpec("URL", "getUrl", "setUrl", null));
  }
}