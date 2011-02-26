package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnoptions.NullableColumnOption;
import net.sf.jrf.column.columnoptions.SequencedPrimaryKeyColumnOption;


/**
 * JRF table for EUNIS_FEEDBACK.
 * @author finsiel
 **/
public class FeedbackDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new FeedbackPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        this.setTableName("EUNIS_FEEDBACK");
        this.addColumnSpec(
                new IntegerColumnSpec("ID_FEEDBACK",
                new SequencedPrimaryKeyColumnOption(), "getIDFeedback",
                "setIDFeedback", null));
        this.addColumnSpec(
                new StringColumnSpec("FEEDBACK_TYPE", new NullableColumnOption(),
                "getFeedbackType", "setFeedbackType", null));
        this.addColumnSpec(
                new StringColumnSpec("MODULE", new NullableColumnOption(),
                "getModule", "setModule", null));
        this.addColumnSpec(
                new StringColumnSpec("COMMENT", new NullableColumnOption(),
                "getComment", "setComment", null));
        this.addColumnSpec(
                new StringColumnSpec("NAME", new NullableColumnOption(),
                "getName", "setName", null));
        this.addColumnSpec(
                new StringColumnSpec("EMAIL", new NullableColumnOption(),
                "getEmail", "setEmail", null));
        this.addColumnSpec(
                new StringColumnSpec("COMPANY", new NullableColumnOption(),
                "getCompany", "setCompany", null));
        this.addColumnSpec(
                new StringColumnSpec("ADDRESS", new NullableColumnOption(),
                "getAddress", "setAddress", null));
        this.addColumnSpec(
                new StringColumnSpec("PHONE", new NullableColumnOption(),
                "getPhone", "setPhone", null));
        this.addColumnSpec(
                new StringColumnSpec("FAX", new NullableColumnOption(), "getFax",
                "setFax", null));
        this.addColumnSpec(
                new StringColumnSpec("URL", new NullableColumnOption(), "getURL",
                "setURL", null));
    }
}
