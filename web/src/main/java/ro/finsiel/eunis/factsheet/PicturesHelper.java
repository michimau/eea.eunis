package ro.finsiel.eunis.factsheet;


import ro.finsiel.eunis.jrfTables.*;

import java.util.List;
import java.util.Vector;

import org.apache.log4j.Logger;


/**
 * Class used for picture handling in factsheets.
 * @author finsiel
 */
public class PicturesHelper {
    private static Logger logger = Logger.getLogger(PicturesHelper.class);

    /**
     * Find species by their ID_SPECIES (from CHM62EDT_SPECIES).
     * @param IDObject ID_SPECIES.
     * @return Scientific name.
     */
    public static String findSpeciesByIDObject(String IDObject) {
        String ret = "";
        List species = null;
        // Species object from database
        Chm62edtSpeciesPersist speciesObject = null;

        try {
            species = new Chm62edtSpeciesDomain().findWhere(
                    "ID_SPECIES = " + IDObject);
            if (null != species && species.size() > 0) {
                speciesObject = ((Chm62edtSpeciesPersist) species.get(0));
                if (null != speciesObject) {
                    ret = speciesObject.getScientificName();
                }
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return ret;
    }

    /**
     * Find sites by their ID_SITE (from CHM62EDT_SITES).
     * @param IDObject ID_SITE.
     * @return Site name.
     */
    public static String findSitesByIDObject(String IDObject) {
        String ret = "";
        List species = null;
        // Site object from database
        Chm62edtSitesPersist sitesObject = null;

        try {
            species = new Chm62edtSitesDomain().findWhere(
                    "ID_SITE = '" + IDObject + "'");
            if (null != species && species.size() > 0) {
                sitesObject = ((Chm62edtSitesPersist) species.get(0));
                if (null != sitesObject) {
                    ret = sitesObject.getName();
                }
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return ret;
    }

    /**
     * Find habitats by their ID_HABITAT (from CHM62EDT_HABITAT).
     * @param IDObject ID_HABITAT.
     * @return Name.
     */
    public static String findHabitatsByIDObject(String IDObject) {
        String ret = "";
        List species = null;
        // Habitat object from database
        Chm62edtHabitatPersist habitat = null;

        try {
            species = new Chm62edtHabitatDomain().findWhere(
                    "ID_HABITAT = " + IDObject);
            if (null != species && species.size() > 0) {
                habitat = ((Chm62edtHabitatPersist) species.get(0));
                if (null != habitat) {
                    ret = habitat.getScientificName();
                }
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return ret;
    }

    /**
     * Delete a picture for an nature object (species, site or habitat).
     * @param idObject ID_ of the object.
     * @param natureObjectType Type of object (species, site, habitat).
     * @param name Name or scientific name.
     * @param filename File to be deleted.
     * @return true if deletion succeed.
     */
    public static boolean deletePicture(String idObject, String natureObjectType, String name, String filename) {
        boolean ret = false;

        if (null != idObject && null != natureObjectType && null != name
                && null != filename) {
            try {
                Chm62edtNatureObjectPicturePersist picture = null;

                // First we find the object in database...
                name = name.replaceAll("'", "''");
                filename = filename.replaceAll("'", "''");
                String sql = " ID_OBJECT='" + idObject
                        + "' AND NATURE_OBJECT_TYPE='" + natureObjectType
                        + "' AND " + " NAME='" + name + "' AND FILE_NAME='"
                        + filename + "'";
                List pictures = new Chm62edtNatureObjectPictureDomain().findWhere(
                        sql);

                if (null != pictures && pictures.size() > 0) {
                    // remove it from table.
                    picture = (Chm62edtNatureObjectPicturePersist) pictures.get(
                            0);
                    int retValue = new Chm62edtNatureObjectPictureDomain().delete(
                            picture);

                    ret = (1 == retValue) ? true : false;
                }
            } catch (Exception _ex) {
                _ex.printStackTrace(System.err);
            }
        } else {
            logger.warn(
                    "deletePicture(" + idObject + ", " + natureObjectType + ", "
                    + name + ", " + filename
                    + ") : One of the parameters was null!");
        }
        return ret;
    }

    /**
     * Find the picture available for a specified species (in CHM62EDT_NATURE_OBJECT_PICTURE).
     * @param idObject ID_SPECIES
     * @param natureObjectType 'Species'
     * @return A List of Chm62edtNatureObjectPicturePersist objects.
     */
    public static List findPicturesForSpecies(String idObject, String natureObjectType) {
        List results = new Vector();

        if (null != idObject && null != natureObjectType) {
            String sql = " ID_OBJECT='" + idObject
                    + "' AND NATURE_OBJECT_TYPE='" + natureObjectType
                    + "' AND MAIN_PIC = 0";

            try {
                Chm62edtNatureObjectPictureDomain nop = new Chm62edtNatureObjectPictureDomain();

                results = nop.findWhere(sql);
            } catch (Exception _ex) {
                _ex.printStackTrace(System.err);
                results = new Vector();
            }
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }
}
