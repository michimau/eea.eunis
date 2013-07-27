package ro.finsiel.eunis.search;

import static junit.framework.Assert.assertEquals;
import org.junit.Test;

public class UniqueVectorTest {

    @Test
    public void simpleAddDublicateElements() {
        UniqueVector v = new UniqueVector();

        v.addElement("EE");
        v.addElement("EE");
        v.addElement("DD");
        v.addElement("XX");
        v.addElement("ZZ");
        v.addElement("ZZ");
        assertEquals("ZZ,XX,DD,EE", v.getElementsSeparatedByComma());
    }

}
