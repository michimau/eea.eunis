package ro.finsiel.eunis.jrfTables.species.taxonomy;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class TaxonomyJRFClassesTest {

    @Test
    public void test_Chm62edtTaxcodeAllJoinsDomain() {
        Chm62edtTaxcodeAllJoinsDomain instance = new Chm62edtTaxcodeAllJoinsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_Chm62edtTaxcodeAllJoinsPersist() {
        Chm62edtTaxcodeAllJoinsPersist instance = new Chm62edtTaxcodeAllJoinsPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_Chm62edtTaxcodeDomain() {
        Chm62edtTaxcodeDomain instance = new Chm62edtTaxcodeDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_Chm62edtTaxcodePersist() {
        Chm62edtTaxcodePersist instance = new Chm62edtTaxcodePersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SpeciesGroupSpeciesDomain() {
        SpeciesGroupSpeciesDomain instance = new SpeciesGroupSpeciesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SpeciesGroupSpeciesPersist() {
        SpeciesGroupSpeciesPersist instance = new SpeciesGroupSpeciesPersist();
        assertNotNull("Instantiation failed", instance);
    }
}
