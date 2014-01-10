package eionet.eunis.dao;


import eionet.eunis.dao.impl.MySqlDaoFactory;

/**
 * Base class for DAO factories.
 */
public abstract class DaoFactory {

    /** */
    private static final DaoFactory MYSQL_DAO_FACTORY = new MySqlDaoFactory();

    /**
     * Returns default implementation of {@link DaoFactory}.
     * @return default implementation
     */
    public static DaoFactory getDaoFactory() {
        return MYSQL_DAO_FACTORY;
    }

    /**
     * @return references DAO
     */
    public abstract IReferencesDao getReferncesDao();

    /**
     * @return external objects DAO
     */
    public abstract IExternalObjectsDao getExternalObjectsDao();

    /**
     * @return sites DAO
     */
    public abstract ISitesDao getSitesDao();

    /**
     * @return species DAO
     */
    public abstract ISpeciesDao getSpeciesDao();

    /**
     * @return species factsheet DAO
     */
    public abstract ISpeciesFactsheetDao getSpeciesFactsheetDao();

    /**
     * @return nature object DAO
     */
    public abstract INatureObjectAttrDao getNatureObjectAttrDao();
}
