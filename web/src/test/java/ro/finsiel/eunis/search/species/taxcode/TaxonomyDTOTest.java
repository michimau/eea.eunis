package ro.finsiel.eunis.search.species.taxcode;

import static junit.framework.Assert.assertEquals;
import org.junit.Test;

public class TaxonomyDTOTest {

    private static final int LOWER = -1;
    private static final int SAME = 0;
    private static final int HIGHER = 1;

    @Test
    public void caseInsensitiveIdentical() {
        TaxonomyDTO l1 = new TaxonomyDTO("line", 1);
        TaxonomyDTO l2 = new TaxonomyDTO("Line", 1);
        assertEquals(SAME, l1.compareTo(l2));
    }

    // l1 must be lower than l2
    @Test
    public void line1LowerThanLine2() {
        TaxonomyDTO l1 = new TaxonomyDTO("line 1", 1);
        TaxonomyDTO l2 = new TaxonomyDTO("Line 2", 2);
        assertEquals(LOWER, l1.compareTo(l2));
    }

    // Expect them to be identical
    @Test
    public void unicodeIdentical() {
        TaxonomyDTO l1 = new TaxonomyDTO("Ǿ", 1);
        TaxonomyDTO l2 = new TaxonomyDTO("Ǿ", 2);
        assertEquals(SAME, l1.compareTo(l2));
    }

}
