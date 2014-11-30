package ro.finsiel.eunis.utilities;

import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;


public class EmptyLastComparatorTest {

    private EmptyLastComparator c;

    @Before
    public void setUp() {
        c = EmptyLastComparator.getComparator();
    }

    @Test
    public void arg1IsNull() {
        assertEquals(1, c.compare(null, "A"));
    }

    @Test
    public void arg2IsEmpty() {
        assertEquals(-1, c.compare("A", ""));
    }

    @Test
    public void bothArgsAreNull() {
        assertEquals(0, c.compare(null, null));
    }

    @Test
    public void bothArgsAreEmpty() {
        assertEquals(0, c.compare("", ""));
    }

    @Test
    public void compareByCase() {
        assertEquals(-32, c.compare("A", "a"));
    }

    @Test
    public void compareAccents() {
        assertEquals(-131, c.compare("n", "ñ"));
    }
}
