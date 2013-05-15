package eionet.eunis.dao.impl;

import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.IExternalObjectsDao;
import eionet.eunis.dao.INatureObjectAttrDao;
import eionet.eunis.dao.IReferencesDao;
import eionet.eunis.dao.ISitesDao;
import eionet.eunis.dao.ISpeciesDao;
import eionet.eunis.dao.ISpeciesFactsheetDao;

/**
 * Factory of MySQL-specific DAO implementations.
 */
public class MySqlDaoFactory extends DaoFactory {

    /** */
    private IReferencesDao referencesDao = new ReferencesDaoImpl();
    private IExternalObjectsDao externalObjectsDao = new ExternalObjectsDaoImpl();
    private ISitesDao sitesDao = new SitesDaoImpl();
    private ISpeciesDao speciesDao = new SpeciesDaoImpl();
    private ISpeciesFactsheetDao speciesFactsheetDao = new SpeciesFactsheetDaoImpl();
    private INatureObjectAttrDao natureObjectAttrDao = new NatureObjectAttrDaoImpl();

    /**
     * Default constructor.
     */
    public MySqlDaoFactory() {
    }

    /*
     * (non-Javadoc)
     * 
     * @see eionet.eunis.dao.DaoFactory#getReferncesDao()
     */
    @Override
    public IReferencesDao getReferncesDao() {
        return referencesDao;
    }

    /*
     * (non-Javadoc)
     * 
     * @see eionet.eunis.dao.DaoFactory#getExternalObjectsDao()
     */
    @Override
    public IExternalObjectsDao getExternalObjectsDao() {
        return externalObjectsDao;
    }

    /*
     * (non-Javadoc)
     * 
     * @see eionet.eunis.dao.DaoFactory#getSitesDao()
     */
    @Override
    public ISitesDao getSitesDao() {
        return sitesDao;
    }

    /*
     * (non-Javadoc)
     * 
     * @see eionet.eunis.dao.DaoFactory#getSpeciesDao()
     */
    @Override
    public ISpeciesDao getSpeciesDao() {
        return speciesDao;
    }

    /*
     * (non-Javadoc)
     * 
     * @see eionet.eunis.dao.DaoFactory#getSpeciesFactsheetDao()
     */
    @Override
    public ISpeciesFactsheetDao getSpeciesFactsheetDao() {
        return speciesFactsheetDao;
    }

    /*
     * (non-Javadoc)
     * 
     * @see eionet.eunis.dao.DaoFactory#getLinkedDataDao()
     */
    @Override
    public INatureObjectAttrDao getNatureObjectAttrDao() {
        return natureObjectAttrDao;
    }
}
