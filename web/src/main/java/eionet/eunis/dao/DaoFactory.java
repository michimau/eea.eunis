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
     * @return
     */
    public static DaoFactory getDaoFactory() {
        return MYSQL_DAO_FACTORY;
    }

    /**
     * @return
     */
    public abstract IReferencesDao getReferncesDao();

    /**
     * @return
     */
    public abstract IExternalObjectsDao getExternalObjectsDao();

    /**
     * @return
     */
    public abstract ISitesDao getSitesDao();

    /**
     * @return
     */
    public abstract ISpeciesDao getSpeciesDao();

    /**
     * @return
     */
    public abstract ISpeciesFactsheetDao getSpeciesFactsheetDao();

    /**
     * @return
     */
    public abstract INatureObjectAttrDao getNatureObjectAttrDao();
}
