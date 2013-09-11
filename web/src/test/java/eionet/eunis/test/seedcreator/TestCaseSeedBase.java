package eionet.eunis.test.seedcreator;

import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.database.QueryDataSet;

public abstract class TestCaseSeedBase {
    
    public abstract QueryDataSet prepareCase(IDatabaseConnection dbConnection) throws AmbiguousTableNameException;

}
