package eionet.eunis.dao;


import eionet.eunis.dao.impl.MySqlDaoFactory;


public abstract class DaoFactory {

    private static DaoFactory mySqlDaoFactory = new MySqlDaoFactory();

    public static DaoFactory getDaoFactory() {
        return mySqlDaoFactory;
    }

    public abstract IReferencesDao getReferncesDao();

    public abstract IExternalObjectsDao getExternalObjectsDao();

    public abstract ISitesDao getSitesDao();

    public abstract ISpeciesDao getSpeciesDao();

    public abstract ISpeciesFactsheetDao getSpeciesFactsheetDao();

}
