package eionet.eunis.dao.impl;

import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.IDocumentsDao;
import eionet.eunis.dao.IExternalObjectsDao;
import eionet.eunis.dao.ISitesDao;
import eionet.eunis.dao.ISpeciesDao;
import eionet.eunis.dao.ISpeciesFactsheetDao;

public class MySqlDaoFactory extends DaoFactory {
	
	public MySqlDaoFactory() {
	}

	private IDocumentsDao documentsDao = new DocumentsDaoImpl();
	private IExternalObjectsDao externalObjectsDao = new ExternalObjectsDaoImpl();
	private ISitesDao sitesDao = new SitesDaoImpl();
	private ISpeciesDao speciesDao = new SpeciesDaoImpl();
	private ISpeciesFactsheetDao speciesFactsheetDao = new SpeciesFactsheetDaoImpl();
	
	public IDocumentsDao getDocumentsDao() {
		return documentsDao;
	}
	public void setDocumentsDao(IDocumentsDao documentsDao) {
		this.documentsDao = documentsDao;
	}
	public IExternalObjectsDao getExternalObjectsDao() {
		return externalObjectsDao;
	}
	public void setExternalObjectsDao(IExternalObjectsDao externalObjectsDao) {
		this.externalObjectsDao = externalObjectsDao;
	}
	public ISitesDao getSitesDao() {
		return sitesDao;
	}
	public void setSitesDao(ISitesDao sitesDao) {
		this.sitesDao = sitesDao;
	}
	public ISpeciesDao getSpeciesDao() {
		return speciesDao;
	}
	public void setSpeciesDao(ISpeciesDao speciesDao) {
		this.speciesDao = speciesDao;
	}
	public ISpeciesFactsheetDao getSpeciesFactsheetDao() {
		return speciesFactsheetDao;
	}
	public void setSpeciesFactsheetDao(ISpeciesFactsheetDao speciesFactsheetDao) {
		this.speciesFactsheetDao = speciesFactsheetDao;
	}
}
