package eionet.eunis.test.seedcreator.seedimpl;

import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.database.QueryDataSet;

import eionet.eunis.test.seedcreator.TestCaseSeedBase;

/**
 * 
 * Seed file implementation for Redlist Species test case
 * 
 * @author
 */
public class RedlistSpeciesTestCaseSeed extends TestCaseSeedBase {

    @Override
    public QueryDataSet prepareCase(IDatabaseConnection dbConnection) throws AmbiguousTableNameException {
        QueryDataSet partialDataSet = new QueryDataSet(dbConnection);
        partialDataSet.addTable("dc_index");
        partialDataSet.addTable("chm62edt_country");
        partialDataSet.addTable("chm62edt_species",
                "select * from  chm62edt_species where scientific_name IN ('Salmo trutta', 'Cerchysiella laeviscuta');");
        partialDataSet
                .addTable(
                        "chm62edt_nature_object",
                        "select * from chm62edt_nature_object where id_nature_object in "
                                + "(select id_nature_object from chm62edt_species where scientific_name  IN ('Salmo trutta', 'Cerchysiella laeviscuta'))");
        partialDataSet
                .addTable(
                        "chm62edt_nature_object_attributes",
                        "select * from chm62edt_nature_object_attributes where id_nature_object in "
                                + "(select id_nature_object from chm62edt_species where scientific_name  IN ('Salmo trutta', 'Cerchysiella laeviscuta'))");

        return partialDataSet;
    }

}
