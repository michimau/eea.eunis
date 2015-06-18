package ro.finsiel.eunis.search;

import org.junit.Test;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertTrue;

/**
 * User: miahi
 * Date: 6/18/15
 */
public class SourceDbTest {

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
}
