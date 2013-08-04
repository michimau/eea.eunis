package ro.finsiel.eunis.jrfTables.advanced;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class AdvancedJRFClassesTest {

    /**
     * The AdvancedSearchDomain class has an initialisation problem. The Java initialisation process is:
     * <ul>
     * <li>First all the member variables are set to binary null.</li>
     * <li>Then the base-class is initialised and the base-class constructor is called. It calls <code>setup()</code></li>
     * <li>Then the member variables are initialised to their definition values</li>
     * <li>Finally the constructor of AdvancedSearchDomain is executed.</li>
     * </ul>
     * This means that <code>setup()</code> is called with natureObject set to null.
     * Since the authors have included a constructor in AdvancedSearchDomain, shouldn't it be callable?
     */
    /*
    @Test
    public void test_AdvancedSearchDomain() {
        AdvancedSearchDomain instance = new AdvancedSearchDomain("idSession","sites");
        assertNotNull("Instantiation failed", instance);
    }
    */

    @Test
    public void test_AdvancedSearchPersist() {
        AdvancedSearchPersist instance = new AdvancedSearchPersist();
        assertNotNull("Instantiation failed", instance);
    }

}

