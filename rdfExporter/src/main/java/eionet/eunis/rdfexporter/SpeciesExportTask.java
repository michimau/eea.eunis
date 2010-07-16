package eionet.eunis.rdfexporter;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.log4j.Logger;
import org.simpleframework.xml.convert.AnnotationStrategy;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;

import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.ResourceDto;
import eionet.eunis.dto.SpeciesFactsheetDto;
import eionet.eunis.dto.SpeciesSynonymDto;
import eionet.eunis.dto.VernacularNameDto;

/**
 * Species export task.
 * 
 */
public class SpeciesExportTask implements Runnable {
	private static final Logger logger = Logger.getLogger(SpeciesExportTask.class);
	
	private static AtomicInteger speciesExported = new AtomicInteger();
	
	private String idspecies;
	private QueuedFileWriter fileWriter;
	

	public SpeciesExportTask(String idspecies, QueuedFileWriter fileWriter) {
		this.idspecies = idspecies;
		this.fileWriter = fileWriter;
	}

	public void run() {
		Integer speciesId = new Integer(idspecies);
		SpeciesFactsheet factsheet = new SpeciesFactsheet(speciesId,speciesId);
		if(factsheet.exists()) {
			Persister persister = new Persister(new AnnotationStrategy(), new Format(4));
			
			ByteArrayOutputStream buffer = new ByteArrayOutputStream();
			SpeciesFactsheetDto dto = new SpeciesFactsheetDto();
			dto.setSpeciesId(factsheet.getSpeciesObject().getIdSpecies());
			dto.setScientificName(factsheet.getSpeciesObject().getScientificName());
			dto.setGenus(factsheet.getSpeciesObject().getGenus());
			dto.setAuthor(factsheet.getSpeciesObject().getAuthor());
			dto.setDwcScientificName(dto.getScientificName() + ' ' + dto.getAuthor());
			dto.setDcmitype(new ResourceDto("","http://purl.org/dc/dcmitype/Text"));
			
			dto.setAttributes(
					DaoFactory.getDaoFactory().getSpeciesFactsheetDao().getAttributesForNatureObject(
							factsheet.getSpeciesObject().getIdNatureObject()));
			
			//setting expectedInLocations
			List<String> expectedLocations = DaoFactory.getDaoFactory().getSpeciesFactsheetDao().getExpectedInSiteIds(
					factsheet.getSpeciesObject().getIdNatureObject(),
					factsheet.getSpeciesObject().getIdSpecies(),
					0);
			if (expectedLocations != null && !expectedLocations.isEmpty()) {
				List<ResourceDto> expectedInSites = new LinkedList<ResourceDto>();
				for(String siteId : expectedLocations) {
					expectedInSites.add(new ResourceDto(siteId, "http://eunis.eea.europa.eu/sites/"));
				}
				dto.setExpectedInLocations(expectedInSites);
			}
			
			List<VernacularNameWrapper> vernacularNames = SpeciesSearchUtility.findVernacularNames(
							factsheet.getSpeciesObject().getIdNatureObject());
			if (factsheet.getIdSpeciesLink() != null 
						&& !factsheet.getIdSpeciesLink().equals(factsheet.getIdSpecies())) {
				dto.setSynonymFor(new SpeciesSynonymDto(factsheet.getIdSpeciesLink()));
			}
			List<Integer> isSynonymFor = DaoFactory.getDaoFactory().getSpeciesFactsheetDao().getSynonyms(factsheet.getIdSpecies());
			List<SpeciesSynonymDto> speciesSynonym = new LinkedList<SpeciesSynonymDto>();
			if (isSynonymFor != null && !isSynonymFor.isEmpty()) {
				for(Integer idSpecies : isSynonymFor) {
					speciesSynonym.add(new SpeciesSynonymDto(idSpecies));
				}
				dto.setHasSynonyms(speciesSynonym);
			}
		
			if (vernacularNames != null) {
				List<VernacularNameDto> vernacularDtos = new LinkedList<VernacularNameDto>();
				for (VernacularNameWrapper wrapper : vernacularNames) {
					vernacularDtos.add(new VernacularNameDto(wrapper));
				}
				dto.setVernacularNames(vernacularDtos);
			}
			
			try {
				persister.write(dto, buffer, "UTF-8");
				buffer.write("\n".getBytes("UTF-8"));
				ByteBuffer writeTask = ByteBuffer.wrap(buffer.toByteArray());
				buffer.close();
				
				fileWriter.addTaskToWrite(writeTask);
				
				speciesExported.incrementAndGet();
				
				if(logger.isDebugEnabled()) {
					logger.debug("Exporting species #" + speciesExported.get() + " (ID_SPECIES = " + idspecies + ")" );
				}
			} catch (Exception e) {
				logger.error(e);
			}
		} else {
			logger.error("Species " + idspecies + " not found");
		}
	}
	
	public static int getNumberOfExportedSpecies() {
		return speciesExported.get();
	}

}
