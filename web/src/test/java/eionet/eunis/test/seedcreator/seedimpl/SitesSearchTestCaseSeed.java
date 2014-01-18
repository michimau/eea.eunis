package eionet.eunis.test.seedcreator.seedimpl;

import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.database.QueryDataSet;

import eionet.eunis.test.seedcreator.TestCaseSeedBase;

/**
 * 
 * Seed file implementation for Sites Search test case
 * 
 * @author Jaak Kapten
 */
public class SitesSearchTestCaseSeed extends TestCaseSeedBase {

    @Override
    public QueryDataSet prepareCase(IDatabaseConnection dbConnection) throws AmbiguousTableNameException {
        QueryDataSet partialDataSet = new QueryDataSet(dbConnection);
        // partialDataSet.addTable("dc_index");

        partialDataSet
                .addTable(
                        "chm62edt_nature_object",
                        "SELECT * FROM chm62edt_nature_object WHERE id_nature_object IN (SELECT id_nature_object FROM chm62edt_sites WHERE name LIKE '%lah%')");
        partialDataSet
                .addTable(
                        "chm62edt_country",
                        "SELECT * FROM chm62edt_country WHERE id_geoscope IN (SELECT id_geoscope FROM chm62edt_nature_object_geoscope WHERE id_nature_object IN (SELECT id_nature_object FROM chm62edt_sites WHERE name LIKE '%lah%')) ");
        partialDataSet
                .addTable(
                        "chm62edt_nature_object_geoscope",
                        "SELECT * FROM chm62edt_nature_object_geoscope WHERE id_nature_object IN (SELECT id_nature_object FROM chm62edt_sites WHERE name LIKE '%lah%') ");
        partialDataSet
                .addTable(
                        "chm62edt_sites",
                        "SELECT ID_SITE, ID_NATURE_OBJECT, ID_DESIGNATION, ID_GEOSCOPE, NAME, COMPLEX_NAME, DISTRICT_NAME, IUCNAT, DESIGNATION_DATE,NATIONAL_CODE, NUTS, AREA, LENGTH, ALT_MEAN, ALT_MAX, ALT_MIN, LONGITUDE, LATITUDE, SOURCE_DB FROM chm62edt_sites WHERE name LIKE '%lah%'");
        return partialDataSet;
    }

}
