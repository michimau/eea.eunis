package eionet.eunis.rdf;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.DatatypeDto;
import eionet.eunis.dto.LinkDTO;
import eionet.eunis.dto.ResourceDto;
import eionet.eunis.dto.SpeciesFactsheetDto;
import eionet.eunis.dto.SpeciesSynonymDto;
import eionet.eunis.dto.TaxonomyTreeDTO;
import eionet.eunis.dto.VernacularNameDto;

public class GenerateSpeciesRDF {

    /** RDF header with namespaces. */
    public static final String HEADER = "<rdf:RDF " + "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
    + "xmlns:dwc=\"http://rs.tdwg.org/dwc/terms/\" \n" + "xmlns:foaf=\"http://xmlns.com/foaf/0.1/\" \n"
    + "xmlns =\"http://eunis.eea.europa.eu/rdf/species-schema.rdf#\">\n";

    private static final String EXPECTED_IN_PREFIX = "http://eunis.eea.europa.eu/sites/";

    private SpeciesFactsheet factsheet;
    private SpeciesFactsheetDto dto;

    public GenerateSpeciesRDF(int idSpecies) {
        this.factsheet = new SpeciesFactsheet(idSpecies, idSpecies);
    }

    public SpeciesFactsheetDto getSpeciesRdf() {
        try {
            if (factsheet != null && factsheet.exists()) {
                dto = new SpeciesFactsheetDto();
                dto.setSpeciesId(factsheet.getSpeciesObject().getIdSpecies());
                dto.setScientificName(factsheet.getSpeciesObject().getScientificName());
                dto.setValidName(new DatatypeDto(factsheet.getSpeciesObject().getValidName(),
                "http://www.w3.org/2001/XMLSchema#boolean"));
                dto.setTypeRelatedSpecies(factsheet.getSpeciesObject().getTypeRelatedSpecies());
                dto.setGenus(factsheet.getSpeciesObject().getGenus());
                dto.setAuthor(factsheet.getSpeciesObject().getAuthor());

                TaxonomyTreeDTO taxonomyTree = factsheet.getTaxonomicTree(factsheet.getSpeciesObject().getIdTaxcode());
                if (taxonomyTree != null) {
                    dto.setKingdom(taxonomyTree.getKingdom());
                    dto.setPhylum(taxonomyTree.getPhylum());
                    dto.setDwcClass(taxonomyTree.getDwcClass());
                    dto.setOrder(taxonomyTree.getOrder());
                    dto.setFamily(taxonomyTree.getFamily());
                }
                if (factsheet.getTaxcodeObject() != null && factsheet.getTaxcodeObject().IdDcTaxcode() != null) {
                    dto.setNameAccordingToID(new ResourceDto(factsheet.getTaxcodeObject().IdDcTaxcode().toString(),
                    "http://eunis.eea.europa.eu/references/"));
                }

                dto.setDwcScientificName(dto.getScientificName() + ' ' + dto.getAuthor());
                dto.setDcmitype(new ResourceDto("", "http://purl.org/dc/dcmitype/Text"));

                if (!StringUtils.isBlank(factsheet.getSpeciesObject().getIdTaxcode())) {
                    dto.setTaxonomy(new ResourceDto(factsheet.getSpeciesObject().getIdTaxcode(),
                    "http://eunis.eea.europa.eu/taxonomy/"));
                }

                dto.setAttributes(DaoFactory.getDaoFactory().getSpeciesFactsheetDao()
                        .getAttributesForNatureObject(factsheet.getSpeciesObject().getIdNatureObject()));

                dto.setHasLegalReferences(DaoFactory.getDaoFactory().getSpeciesFactsheetDao()
                        .getLegalReferences(factsheet.getSpeciesObject().getIdNatureObject()));

                // setting html links
                ArrayList<LinkDTO> linkObjects =
                    DaoFactory.getDaoFactory().getExternalObjectsDao()
                    .getNatureObjectLinks(factsheet.getSpeciesObject().getIdNatureObject());
                if (linkObjects != null && !linkObjects.isEmpty()) {
                    List<ResourceDto> links = new LinkedList<ResourceDto>();

                    for (LinkDTO link : linkObjects) {
                        links.add(new ResourceDto(link.getUrl()));
                    }
                    dto.setLinks(links);
                }

                // setting expectedInLocations
                List<String> expectedLocations =
                    DaoFactory
                    .getDaoFactory()
                    .getSpeciesFactsheetDao()
                    .getExpectedInSiteIds(factsheet.getSpeciesObject().getIdNatureObject(),
                            factsheet.getSpeciesObject().getIdSpecies(), 0);

                if (expectedLocations != null && !expectedLocations.isEmpty()) {
                    List<ResourceDto> expectedInSites = new LinkedList<ResourceDto>();

                    for (String siteId : expectedLocations) {
                        expectedInSites.add(new ResourceDto(siteId, EXPECTED_IN_PREFIX));
                    }
                    dto.setExpectedInLocations(expectedInSites);
                }

                List<VernacularNameWrapper> vernacularNames =
                    SpeciesSearchUtility.findVernacularNames(factsheet.getSpeciesObject().getIdNatureObject());

                if (factsheet.getIdSpeciesLink() != null && !factsheet.getIdSpeciesLink().equals(factsheet.getIdSpecies())) {
                    dto.setSynonymFor(new SpeciesSynonymDto(factsheet.getIdSpeciesLink()));
                }
                List<Integer> isSynonymFor =
                    DaoFactory.getDaoFactory().getSpeciesFactsheetDao().getSynonyms(factsheet.getIdSpecies());
                List<SpeciesSynonymDto> speciesSynonym = new LinkedList<SpeciesSynonymDto>();

                if (isSynonymFor != null && !isSynonymFor.isEmpty()) {
                    for (Integer idSpecies : isSynonymFor) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }
}
