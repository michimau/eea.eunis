package ro.finsiel.eunis.search.species.taxcode;

import ro.finsiel.eunis.search.species.taxcode.TaxonomyDTO;
import junit.framework.TestCase;

public class TaxonomyDTOTest extends TestCase {

	public void test_identity() {
                TaxonomyDTO l1 = new TaxonomyDTO("line",1);
                TaxonomyDTO l2 = new TaxonomyDTO("Line",1);
		assertEquals(0, l1.compareTo(l2));
	}

	// l1 must be lower than l2
	public void test_line1_2() {
                TaxonomyDTO l1 = new TaxonomyDTO("line 1",1);
                TaxonomyDTO l2 = new TaxonomyDTO("Line 2",2);
		assertEquals(-1, l1.compareTo(l2));
	}

        // Expect them to be identical
	public void test_unicode() {
                TaxonomyDTO l1 = new TaxonomyDTO("Ǿ",1);
                TaxonomyDTO l2 = new TaxonomyDTO("Ǿ",2);
		assertEquals(0, l1.compareTo(l2));
	}

}
