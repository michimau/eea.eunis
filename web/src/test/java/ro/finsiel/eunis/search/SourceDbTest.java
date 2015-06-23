package ro.finsiel.eunis.search;

import eionet.eunis.test.DbHelper;
import org.junit.BeforeClass;
import org.junit.Test;
import ro.finsiel.eunis.utilities.SQLUtilities;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertTrue;

/**
 * User: miahi
 * Date: 6/18/15
 */
public class SourceDbTest {


    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-sites-search.xml");
    }

    @Test
    public void emptyDatabase() {
        SourceDb sourceDb = SourceDb.noDatabase();
        assertTrue(sourceDb.getDatabases().isEmpty());
        assertTrue(sourceDb.isEmpty());
    }

    @Test
    public void fullDatabase() {
        SourceDb sourceDb = SourceDb.allDatabases();
        assertEquals(SourceDb.Database.class.getEnumConstants().length, sourceDb.getDatabases().size());
    }

    @Test
    public void add(){
        SourceDb sourceDb = SourceDb.noDatabase();
        sourceDb.add(SourceDb.Database.NATURA2000);
        assertEquals(1, sourceDb.getDatabases().size());
        assertTrue(sourceDb.getDatabases().contains(SourceDb.Database.NATURA2000));
        assertTrue(!sourceDb.getDatabases().contains(SourceDb.Database.DIPLOMA));
    }

    @Test
    public void addConditional(){
        SourceDb sourceDb = SourceDb.noDatabase();
        sourceDb.add(SourceDb.Database.NATURA2000, false);
        assertEquals(0, sourceDb.getDatabases().size());
        assertTrue(!sourceDb.getDatabases().contains(SourceDb.Database.NATURA2000));

        sourceDb.add(SourceDb.Database.NATURA2000, true);
        assertEquals(1, sourceDb.getDatabases().size());
        assertTrue(sourceDb.getDatabases().contains(SourceDb.Database.NATURA2000));
    }

    @Test
    public void noDoubles() {
        SourceDb sourceDb = SourceDb.noDatabase();
        sourceDb.add(SourceDb.Database.NATURA2000);
        sourceDb.add(SourceDb.Database.NATURA2000);
        assertEquals(1, sourceDb.getDatabases().size());
        assertTrue(sourceDb.getDatabases().contains(SourceDb.Database.NATURA2000));
    }

    @Test
    public void remove() {
        SourceDb sourceDb = SourceDb.noDatabase();
        sourceDb.add(SourceDb.Database.NATURA2000);
        sourceDb.add(SourceDb.Database.DIPLOMA);
        assertEquals(2, sourceDb.getDatabases().size());
        sourceDb.remove(SourceDb.Database.DIPLOMA);
        assertEquals(1, sourceDb.getDatabases().size());
        assertTrue(sourceDb.getDatabases().contains(SourceDb.Database.NATURA2000));
        assertTrue(!sourceDb.getDatabases().contains(SourceDb.Database.DIPLOMA));
    }

    @Test
    public void removeNonExisting() {
        SourceDb sourceDb = SourceDb.noDatabase();
        assertTrue(sourceDb.isEmpty());
        sourceDb.remove(SourceDb.Database.NATURA2000);
        assertTrue(sourceDb.isEmpty());
    }

    /**
     * Synthetic test for source DB conditions
     */
    @Test
    public void testGetConditionForSourceDb() {
        SourceDb sourceDb = SourceDb.noDatabase();
        StringBuffer stringBuffer = new StringBuffer();
        String alias = "C";
        Utilities.getConditionForSourceDB(stringBuffer, sourceDb, alias);
        assertEquals("", stringBuffer.toString());

        sourceDb.add(SourceDb.Database.NATURA2000);
        stringBuffer = new StringBuffer();
        Utilities.getConditionForSourceDB(stringBuffer, sourceDb, alias);
        assertEquals(alias + ".SOURCE_DB IN ('" + SourceDb.Database.NATURA2000.getDatabaseName() + "' ) ", stringBuffer.toString());

        stringBuffer = new StringBuffer();
        stringBuffer.append("predicate ");
        Utilities.getConditionForSourceDB(stringBuffer, sourceDb, alias);
        assertEquals("predicate  AND " + alias + ".SOURCE_DB IN ('" + SourceDb.Database.NATURA2000.getDatabaseName() + "' ) ", stringBuffer.toString());


        sourceDb.add(SourceDb.Database.DIPLOMA);
        stringBuffer = new StringBuffer();
        Utilities.getConditionForSourceDB(stringBuffer, sourceDb, alias);

        // the order is not guaranteed, so we have to check both ways
        String natura = "'" + SourceDb.Database.NATURA2000.getDatabaseName() + "'";
        String diploma = "'" + SourceDb.Database.DIPLOMA.getDatabaseName() + "'";

        assertTrue((alias + ".SOURCE_DB IN (" + natura + " , " + diploma + " ) ").equals(stringBuffer.toString())
                || (alias + ".SOURCE_DB IN (" + diploma + " , " + natura + " ) ").equals(stringBuffer.toString()));
    }

    /**
     * Real query test for source DB conditions
     */
    @Test
    public void testGetConditionForSourceDbQuery() {
        SQLUtilities sqlUtils = DbHelper.getSqlUtilities();

        // empty list
        SourceDb sourceDb = SourceDb.noDatabase();
        StringBuffer stringBuffer = new StringBuffer();
        String alias = "C";
        String sqlStart = "select count(*) from chm62edt_sites C where ID_SITE='DE5711301' ";
        stringBuffer.append(sqlStart);

        // all sites
        Utilities.getConditionForSourceDB(stringBuffer, sourceDb, alias);
        String result = sqlUtils.ExecuteSQL(stringBuffer.toString());
        assertEquals("1", result);

        // not a cdda site
        sourceDb.add(SourceDb.Database.CDDA_INTERNATIONAL);
        stringBuffer = new StringBuffer();
        stringBuffer.append(sqlStart);
        Utilities.getConditionForSourceDB(stringBuffer, sourceDb, alias);
        result = sqlUtils.ExecuteSQL(stringBuffer.toString());
        assertEquals("0", result);

        // a natura site
        sourceDb.add(SourceDb.Database.NATURA2000);
        stringBuffer = new StringBuffer();
        stringBuffer.append(sqlStart);
        Utilities.getConditionForSourceDB(stringBuffer, sourceDb, alias);
        result = sqlUtils.ExecuteSQL(stringBuffer.toString());
        assertEquals("1", result);

    }
}
