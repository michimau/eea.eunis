package ro.finsiel.eunis.dataimport.parsers;

import java.util.List;

import junit.framework.Assert;

import org.junit.BeforeClass;
import org.junit.Test;

import eionet.eunis.test.DbHelper;

public class RedListsImportParserTest {

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-redlist-species.xml");
    }

    @Test
    public void gettingSameSpeciesByIucn() throws Exception {
        Integer redlistCatIdDc = new Integer(DbHelper.getAppProperty("redlist.categories.id_dc"));
        RedListsImportParser redlistParser = new RedListsImportParser(DbHelper.getSqlUtilities(), 1, false, redlistCatIdDc);

        // case 1. IUCN number is given and matching sameSpeciesRedlist exists
        List<String> natObjIds = redlistParser.getNatureObjectId("Salmo trutta", "19861");
        Assert.assertEquals("4256", natObjIds.get(0));

        // case 2. IUCN number is not given but matching species with sameSpeciesRedlist attribute exists
        natObjIds = redlistParser.getNatureObjectId("Salmo trutta", null);
        Assert.assertEquals("4256", natObjIds.get(0));

        // case 3. IUCN number is not given and several matching species without sameSpeciesRedlist attributes exist, 2 species in
        // this case
        natObjIds = redlistParser.getNatureObjectId("Cerchysiella laeviscuta", null);
        Assert.assertEquals(2, natObjIds.size());
    }
}
