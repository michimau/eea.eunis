package ro.finsiel.eunis.search.sites;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.SourceDb;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;


/**
 * This is the base class for all form beans from EUNIS SITES Module.
 * @author finsiel
 */
public abstract class SitesFormBean extends AbstractFormBean {

    /** Minimum year value. */
    protected String yearMin = null;

    /** Maximum year value. */
    protected String yearMax = null;

    /** String containig comma-separated values for all countries where search is done. */
    protected String country = null;

    /** NATURA 2000. */
    protected String DB_NATURA2000 = null;

    /** CDDA  National. */
    protected String DB_CDDA_NATIONAL = null;

    /** NatureNet. */
    protected String DB_NATURE_NET = null;

    /** Corine Biotopes. */
    protected String DB_CORINE = null;

    /** CDDA International. */
    protected String DB_CDDA_INTERNATIONAL = null;

    /** European Diploma. */
    protected String DB_DIPLOMA = null;

    /** Biogenetic Reserve. */
    protected String DB_BIOGENETIC = null;

    /** Emerald. */
    protected String DB_EMERALD = null;

    /**
     * This method is because I cannot implement here the toURLParam(Vector).The inheriting class would like to override
     * toURLParam() so would never get called. Take the example below, which would not work correcly:<br />
     * <CODE>
     * CountryBean aBean = new CountryBean();// This is an derived object from AbstractFormBean (this)<br />
     * AbstractFormBean anotherBean = (AbstractFormBean)aBean; // Correct due to the inheritance.<br />
     * anotherBean.toURLParam(new Vector());<br />
     * The above line contains the issue. If I implement in AbstractFormBean, the toURLParam(Vector) method, then<br />
     * method toURLParam(Vector) overriden in CountryBean never gets called, so all the effort is useless. So<br />
     * I rather prefer that from the toURLParam(Vector) from CountryBean, you will call the<br />
     * toURLParamSuper(Vector) - this method. If you forget to call, then the params would not be wrote, for this <br />
     * reason you must pay attention when inherit from AbstractFormBean class.<br />
     * </CODE>
     * @param classFields The fields you want returned as HTML FORM fields.
     * @return An representation of this object, as HTML FORM fields.
     */
    protected StringBuffer toURLParamSuper(Vector classFields) {
        StringBuffer ret = super.toURLParamSuper(classFields);

        if (null != DB_NATURA2000) {
            ret.append(Utilities.writeURLParameter("DB_NATURA2000", DB_NATURA2000));
        }
        if (null != DB_CDDA_NATIONAL) {
            ret.append(Utilities.writeURLParameter("DB_CDDA_NATIONAL", DB_CDDA_NATIONAL));
        }
        if (null != DB_NATURE_NET) {
            ret.append(Utilities.writeURLParameter("DB_NATURE_NET", DB_NATURE_NET));
        }
        if (null != DB_CORINE) {
            ret.append(Utilities.writeURLParameter("DB_CORINE", DB_CORINE));
        }
        if (null != DB_CDDA_INTERNATIONAL) {
            ret.append(Utilities.writeURLParameter("DB_CDDA_INTERNATIONAL", DB_CDDA_INTERNATIONAL));
        }
        if (null != DB_DIPLOMA) {
            ret.append(Utilities.writeURLParameter("DB_DIPLOMA", DB_DIPLOMA));
        }
        if (null != DB_BIOGENETIC) {
            ret.append(Utilities.writeURLParameter("DB_BIOGENETIC", DB_BIOGENETIC));
        }
        if (null != DB_EMERALD) {
            ret.append(Utilities.writeURLParameter("DB_EMERALD", DB_EMERALD));
        }
        return ret;
    }

    /**
     * This method is because I cannot implement here the toFORMParam(Vector).The inheriting class would like to override
     * toFORMParam() so would never get called. Take the example below, which would not work correcly:<br />
     * <CODE>
     * CountryBean aBean = new CountryBean();// This is an derived object from AbstractFormBean (this)<br />
     * AbstractFormBean anotherBean = (AbstractFormBean)aBean; // Correct due to the inheritance.<br />
     * anotherBean.toFORMParam(new Vector());<br />
     * The above line contains the issue. If I implement in AbstractFormBean, the toFORMParam(Vector) method, then<br />
     * method toFORMParam(Vector) overriden in CountryBean never gets called, so all the effort is useless. So<br />
     * I rather prefer that from the toFORMParam(Vector) from CountryBean, you will call the<br />
     * toFORMParamSuper(Vector) - this method. If you forget to call, then the params would not be wrote, for this <br />
     * reason you must pay attention when inherit from AbstractFormBean class.<br />
     * </CODE>
     * @param classFields The fields you want returned as HTML FORM fields.
     * @return An representation of this object, as HTML FORM fields.
     */
    protected StringBuffer toFORMParamSuper(Vector classFields) {
        StringBuffer ret = super.toFORMParamSuper(classFields);

        if (null != DB_NATURA2000) {
            ret.append(Utilities.writeFormParameter("DB_NATURA2000", DB_NATURA2000));
        }
        if (null != DB_CDDA_NATIONAL) {
            ret.append(Utilities.writeFormParameter("DB_CDDA_NATIONAL", DB_CDDA_NATIONAL));
        }
        if (null != DB_NATURE_NET) {
            ret.append(Utilities.writeFormParameter("DB_NATURE_NET", DB_NATURE_NET));
        }
        if (null != DB_CORINE) {
            ret.append(Utilities.writeFormParameter("DB_CORINE", DB_CORINE));
        }
        if (null != DB_CDDA_INTERNATIONAL) {
            ret.append(Utilities.writeFormParameter("DB_CDDA_INTERNATIONAL", DB_CDDA_INTERNATIONAL));
        }
        if (null != DB_DIPLOMA) {
            ret.append(Utilities.writeFormParameter("DB_DIPLOMA", DB_DIPLOMA));
        }
        if (null != DB_BIOGENETIC) {
            ret.append(Utilities.writeFormParameter("DB_BIOGENETIC", DB_BIOGENETIC));
        }
        if (null != DB_EMERALD) {
            ret.append(Utilities.writeFormParameter("DB_EMERALD", DB_EMERALD));
        }
        return ret;
    }

    /**
     * Getter for yearMin property.
     * @return yearMin.
     */
    public String getYearMin() {
        return yearMin;
    }

    /**
     * Setter for yearMin property.
     * @param yearMin yearMin.
     */
    public void setYearMin(String yearMin) {
        this.yearMin = (null != yearMin ? yearMin.trim() : yearMin);
    }

    /**
     * Getter for yearMax property.
     * @return yearMax.
     */
    public String getYearMax() {
        return yearMax;
    }

    /**
     * Setter for yearMax property.
     * @param yearMax yearMax.
     */
    public void setYearMax(String yearMax) {
        this.yearMax = (null != yearMax ? yearMax.trim() : yearMax);
    }

    /**
     * Getter for country property.
     * @return country.
     */
    public String getCountry() {
        return country;
    }

    /**
     * Setter for country property.
     * @param country country.
     */
    public void setCountry(String country) {
        this.country = (null != country ? country.trim() : country);
    }

    /**
     * Getter for DB_NATURA2000 property.
     * @return DB_NATURA2000.
     */
    public String getDB_NATURA2000() {
        return DB_NATURA2000;
    }

    /**
     * Setter for DB_NATURA2000 property.
     * @param DB_NATURA2000 DB_NATURA2000.
     */
    public void setDB_NATURA2000(String DB_NATURA2000) {
        this.DB_NATURA2000 = DB_NATURA2000;
    }

    /**
     * Getter for DB_CDDA_NATIONAL property.
     * @return DB_CDDA_NATIONAL.
     */
    public String getDB_CDDA_NATIONAL() {
        return DB_CDDA_NATIONAL;
    }

    /**
     * Setter for DB_CDDA_NATIONAL property.
     * @param DB_CDDA_NATIONAL DB_CDDA_NATIONAL.
     */
    public void setDB_CDDA_NATIONAL(String DB_CDDA_NATIONAL) {
        this.DB_CDDA_NATIONAL = DB_CDDA_NATIONAL;
    }

    /**
     * Getter for DB_NATURE_NET property.
     * @return DB_NATURE_NET.
     */
    public String getDB_NATURE_NET() {
        return DB_NATURE_NET;
    }

    /**
     * Setter for DB_NATURE_NET property.
     * @param DB_NATURE_NET DB_NATURE_NET.
     */
    public void setDB_NATURE_NET(String DB_NATURE_NET) {
        this.DB_NATURE_NET = DB_NATURE_NET;
    }

    /**
     * Getter for DB_CORINE property.
     * @return DB_CORINE.
     */
    public String getDB_CORINE() {
        return DB_CORINE;
    }

    /**
     * Setter for DB_CORINE property.
     * @param DB_CORINE DB_CORINE.
     */
    public void setDB_CORINE(String DB_CORINE) {
        this.DB_CORINE = DB_CORINE;
    }

    /**
     * Getter for DB_CDDA_INTERNATIONAL property.
     * @return DB_CDDA_INTERNATIONAL.
     */
    public String getDB_CDDA_INTERNATIONAL() {
        return DB_CDDA_INTERNATIONAL;
    }

    /**
     * Setter for DB_CDDA_INTERNATIONAL property.
     * @param DB_CDDA_INTERNATIONAL DB_CDDA_INTERNATIONAL.
     */
    public void setDB_CDDA_INTERNATIONAL(String DB_CDDA_INTERNATIONAL) {
        this.DB_CDDA_INTERNATIONAL = DB_CDDA_INTERNATIONAL;
    }

    /**
     * Getter for DB_DIPLOMA property.
     * @return DB_DIPLOMA.
     */
    public String getDB_DIPLOMA() {
        return DB_DIPLOMA;
    }

    /**
     * Setter for DB_DIPLOMA property.
     * @param DB_DIPLOMA DB_DIPLOMA.
     */
    public void setDB_DIPLOMA(String DB_DIPLOMA) {
        this.DB_DIPLOMA = DB_DIPLOMA;
    }

    /**
     * Getter for DB_BIOGENETIC property.
     * @return DB_BIOGENETIC.
     */
    public String getDB_BIOGENETIC() {
        return DB_BIOGENETIC;
    }

    /**
     * Setter for DB_BIOGENETIC property.
     * @param DB_BIOGENETIC DB_BIOGENETIC.
     */
    public void setDB_BIOGENETIC(String DB_BIOGENETIC) {
        this.DB_BIOGENETIC = DB_BIOGENETIC;
    }

    /**
     * Getter for DB_EMERALD property.
     * @return DB_EMERALD.
     */
    public String getDB_EMERALD() {
        return DB_EMERALD;
    }

    /**
     * Setter for DB_EMERALD property.
     * @param DB_EMERALD DB_EMERALD.
     */
    public void setDB_EMERALD(String DB_EMERALD) {
        this.DB_EMERALD = DB_EMERALD;
    }

    public SourceDb getSourceDb(){
        SourceDb source = SourceDb.noDatabase();
        if(getDB_NATURA2000() != null) source.add(SourceDb.Database.NATURA2000);
        if(getDB_CORINE() != null) source.add(SourceDb.Database.CORINE);
        if(getDB_DIPLOMA() != null) source.add(SourceDb.Database.DIPLOMA);
        if(getDB_CDDA_NATIONAL() != null) source.add(SourceDb.Database.CDDA_NATIONAL);
        if(getDB_CDDA_INTERNATIONAL() != null) source.add(SourceDb.Database.CDDA_INTERNATIONAL);
        if(getDB_BIOGENETIC() != null) source.add(SourceDb.Database.BIOGENETIC);
        if(getDB_EMERALD() != null) source.add(SourceDb.Database.EMERALD);
        return source;
    }
}

