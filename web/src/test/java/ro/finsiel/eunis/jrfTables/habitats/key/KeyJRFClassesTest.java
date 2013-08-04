package ro.finsiel.eunis.jrfTables.habitats.key;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class KeyJRFClassesTest {

    @Test
    public void testChm62edtHabitatKeyNavigationDomain() {
        Chm62edtHabitatKeyNavigationDomain instance = new Chm62edtHabitatKeyNavigationDomain();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void testChm62edtHabitatKeyNavigationPersist() {
        Chm62edtHabitatKeyNavigationPersist instance = new Chm62edtHabitatKeyNavigationPersist();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void testQuestionDomain() {
        QuestionDomain instance = new QuestionDomain();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void testQuestionPersist() {
        QuestionPersist instance = new QuestionPersist();
        assertNotNull("Instantiantion failed", instance);
    }
}
