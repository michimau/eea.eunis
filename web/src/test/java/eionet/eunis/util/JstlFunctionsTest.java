package eionet.eunis.util;

import static junit.framework.Assert.assertEquals;
import org.junit.Test;

public class JstlFunctionsTest {

    @Test
    public void bracketsToItalics() {
        assertEquals("XX <i>Canis</i> sp.", JstlFunctions.bracketsToItalics("XX [Canis] sp."));
        // Note the accent over the 'n'
        assertEquals("Cańis sp.", JstlFunctions.bracketsToItalics("Cańis sp."));
        assertEquals("<i>XX</i> <i>Canis</i> <i>sp.</i>", JstlFunctions.bracketsToItalics("[XX] [Canis] [sp.]"));
    }
}
