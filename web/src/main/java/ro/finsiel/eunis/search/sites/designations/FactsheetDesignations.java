package ro.finsiel.eunis.search.sites.designations;


import ro.finsiel.eunis.jrfTables.Chm62edtDesignationsDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist;

import java.util.List;


/**
 * Factsheet for designations. Used to retrieve information displayed there (designations-factsheet).
 * @author finsiel
 */
public class FactsheetDesignations {
    private String idDesign = null;
    private String geoscope = null;

    /**
     * Ctor.
     * @param id ID_SITE
     * @param geoscope ID_GEOSCOPE
     */
    public FactsheetDesignations(String id, String geoscope) {
        this.idDesign = id;
        this.geoscope = geoscope;
    }

    /**
     * Find designations persistent object.
     * @return Designation object from database.
     */
    public Chm62edtDesignationsPersist FindDesignationPersist() {
        String sql = "";
        Chm62edtDesignationsPersist result = null;

        try {
            sql = "TRIM(CHM62EDT_DESIGNATIONS.ID_DESIGNATION)=TRIM('" + idDesign + "') "
                    + "AND TRIM(CHM62EDT_DESIGNATIONS.ID_GEOSCOPE)=TRIM('" + geoscope + "')";

            List list = new Chm62edtDesignationsDomain().findWhere(sql);

            if (list != null && list.size() > 0) {
                result = (Chm62edtDesignationsPersist) list.get(0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
