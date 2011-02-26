package ro.finsiel.eunis.jrfTables.species.glossary;


import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


public class Chm62edtGlossaryDomain extends AbstractDomain {

    /****/
    public PersistentObject newPersistentObject() {
        return new Chm62edtGlossaryPersist();
    }

     /****/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("CHM62EDT_GLOSSARY");
        // this.setReadOnly(true); - Not read-only because is modeified by glossary-editor.jsp.

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new StringColumnSpec("TERM", "getTerm", "setTerm",
                        DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_LANGUAGE", "getIdLanguage",
                        "setIdLanguage", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new StringColumnSpec("SOURCE", "getSource", "setSource",
                        DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(
                new StringColumnSpec("DEFINITION", "getDefinition",
                "setDefinition", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("LINK_DESCRIPTION", "getLinkDescription",
                "setLinkDescription", DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("LINK_URL", "getLinkUrl", "setLinkUrl",
                DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("REFERENCE", "getReference", "setReference",
                DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("TERM_DOMAIN", "getTermDomain",
                "setTermDomain", DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("SEARCH_DOMAIN", "getSearchDomain",
                "setSearchDomain", DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("DATE_CHANGED", "getDateChanged",
                "setDateChanged", DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new ShortColumnSpec("CURRENT", "getCurrent", "setCurrent", null));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_ZERO));
    }
}
