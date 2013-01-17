package eionet.eunis;

import org.junit.Test;
import ro.finsiel.eunis.factsheet.species.LegalStatusWrapper;
import junit.framework.TestCase;

/**
 *
 * Type definition ...
 *
 * @author Rait
 */
public class LegalStatusWrapperTest extends TestCase {

    @Test
    public void testEqualsObject() {
        LegalStatusWrapper tester1 = new LegalStatusWrapper();
        LegalStatusWrapper tester2 = new LegalStatusWrapper();

        assertTrue("test 1", tester1.equals(tester2));

        tester1.setLegalText(null);
        tester1.setUrl(null);
        tester1.setDetailedReference(null);
        tester1.setArea(null);
        tester1.setComments(null);
        tester1.setIdDc(null);
        tester1.setRefcd(null);
        tester1.setReference(null);

        tester2.setLegalText(null);
        tester2.setUrl(null);
        tester2.setDetailedReference(null);
        tester2.setArea(null);
        tester2.setComments(null);
        tester2.setIdDc(null);
        tester2.setRefcd(null);
        tester2.setReference(null);

        assertTrue("test 2", tester1.equals(tester2));

        tester1.setLegalText("text");
        assertFalse("test 3", tester1.equals(tester2));
        tester2.setLegalText("text");
        assertTrue("test 3.1", tester1.equals(tester2));

        tester1.setLegalText(null);
        tester2.setLegalText(null);

        tester1.setUrl("url");
        assertFalse("test 4", tester1.equals(tester2));
        tester2.setUrl("url");
        assertTrue("test 4.1", tester1.equals(tester2));

        tester1.setUrl(null);
        tester2.setUrl(null);

        tester1.setDetailedReference("DRef");
        assertFalse("test 5", tester1.equals(tester2));
        tester2.setDetailedReference("DRef");
        assertTrue("test 5.1", tester1.equals(tester2));

        tester1.setDetailedReference(null);
        tester2.setDetailedReference(null);

        tester1.setArea("Area");
        assertFalse("test 6", tester1.equals(tester2));
        tester2.setArea("Area");
        assertTrue("test 6.1", tester1.equals(tester2));

        tester1.setArea(null);
        tester2.setArea(null);

        tester1.setComments("Comment");
        assertFalse("test 7", tester1.equals(tester2));
        tester2.setComments("Comment");
        assertTrue("test 7.1", tester1.equals(tester2));

        tester1.setComments(null);
        tester2.setComments(null);

        tester1.setIdDc(1);
        assertFalse("test 8", tester1.equals(tester2));
        tester2.setIdDc(1);
        assertTrue("test 8.1", tester1.equals(tester2));

        tester1.setIdDc(null);
        tester2.setIdDc(null);

        tester1.setRefcd("Refcd");
        assertFalse("test 9", tester1.equals(tester2));
        tester2.setRefcd("Refcd");
        assertTrue("test 9.1", tester1.equals(tester2));

        tester1.setIdDc(null);
        tester1.setIdDc(null);

        tester1.setReference("Ref");
        assertFalse("test 10", tester1.equals(tester2));
        tester2.setReference("Ref");
        assertTrue("test 10.1", tester1.equals(tester2));

        tester1.setReference(null);
        tester2.setReference(null);

        tester2.setLegalText("Text");
        assertFalse("test 11", tester1.equals(tester2));
        tester2.setUrl("Url");
        assertFalse("test 12", tester1.equals(tester2));
        tester2.setDetailedReference("DRef");
        assertFalse("test 13", tester1.equals(tester2));
        tester2.setArea("Area");
        assertFalse("test 14", tester1.equals(tester2));
        tester2.setComments("Comment");
        assertFalse("test 15", tester1.equals(tester2));
        tester2.setIdDc(1);
        assertFalse("test 16", tester1.equals(tester2));
        tester2.setRefcd("Refcd");
        assertFalse("test 17", tester1.equals(tester2));
        tester2.setReference("Ref");
        assertFalse("test 18", tester1.equals(tester2));

        tester1.setLegalText("Text");
        assertFalse("test 19", tester1.equals(tester2));
        tester1.setUrl("Url");
        assertFalse("test 20", tester1.equals(tester2));
        tester1.setDetailedReference("DRef");
        assertFalse("test 21", tester1.equals(tester2));
        tester1.setArea("Area");
        assertFalse("test 22", tester1.equals(tester2));
        tester1.setComments("Comment");
        assertFalse("test 23", tester1.equals(tester2));
        tester1.setIdDc(1);
        assertFalse("test 24", tester1.equals(tester2));
        tester1.setRefcd("Refcd");
        assertFalse("test 25", tester1.equals(tester2));
        tester1.setReference("Ref");
        assertTrue("test 26", tester1.equals(tester2));

    }
}
