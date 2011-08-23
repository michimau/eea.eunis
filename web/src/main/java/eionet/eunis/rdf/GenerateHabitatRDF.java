package eionet.eunis.rdf;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.factsheet.habitats.DescriptionWrapper;
import ro.finsiel.eunis.factsheet.habitats.HabitatFactsheetRelWrapper;
import ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet;
import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import ro.finsiel.eunis.jrfTables.Chm62edtHabitatInternationalNamePersist;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.factsheet.HabitatsSpeciesWrapper;

public class GenerateHabitatRDF {

    /** RDF header with namespaces. */
    public static final String HEADER = "<rdf:RDF xmlns=\"http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#\"\n"
        + "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n" + "xmlns:dct=\"http://purl.org/dc/terms/\">\n";

    private HabitatsFactsheet factsheet;
    private String idHabitat;
    private StringBuffer rdf;

    public GenerateHabitatRDF(String idHabitat) {
        this.factsheet = new HabitatsFactsheet(idHabitat);
        this.idHabitat = idHabitat;
        this.rdf = new StringBuffer();
    }

    public StringBuffer getHabitatRdf() {
        try {
            if (factsheet != null) {
                rdf.append("<Habitat rdf:about=\"http://eunis.eea.europa.eu/habitats/").append(idHabitat).append("\">\n");
                rdf.append(RDFUtil.writeLiteral("code", idHabitat));
                rdf.append(RDFUtil.writeLiteral("name", factsheet.getHabitatScientificName()));
                if (factsheet.getCode2000() != "na") {
                    rdf.append(RDFUtil.writeLiteral("natura2000Code", factsheet.getCode2000()));
                }
                rdf.append(RDFUtil.writeLiteral("level", factsheet.getHabitatLevel()));
                rdf.append(RDFUtil.writeLiteral("priority", (factsheet.getPriority() != null
                        && 1 == factsheet.getPriority().shortValue()) ? Boolean.TRUE : Boolean.FALSE));

                // Add source
                Vector<DescriptionWrapper> descriptions = factsheet.getDescrOwner();
                if (descriptions != null) {
                    for (DescriptionWrapper description : descriptions) {
                        if (description.getLanguage().equalsIgnoreCase("english") && description.getIdDc() != null) {
                            String textSource =
                                Utilities.formatString(SpeciesFactsheet.getBookAuthorDate(description.getIdDc()), "");
                            if (textSource != null && textSource.length() > 0) {
                                rdf.append(RDFUtil.writeReference("dct:source", "http://eunis.eea.europa.eu/references/" + description.getIdDc()));
                            }
                        }
                    }
                }

                // List of habitats inernationals names.
                List<Chm62edtHabitatInternationalNamePersist> names = factsheet.getInternationalNames();
                if (!names.isEmpty()) {
                    for (Chm62edtHabitatInternationalNamePersist name : names) {
                        rdf.append(RDFUtil.writeLiteral("nationalName", name.getName(), name.getCode()));
                    }
                }

                // Add Parent and Anchestor habitats info
                List<String> parents = new ArrayList<String>();
                List<String> anchestors = new ArrayList<String>();
                Vector<HabitatFactsheetRelWrapper> vec = factsheet.getOtherHabitatsRelations();
                if (vec != null && vec.size() > 0) {
                    for (HabitatFactsheetRelWrapper wrapper : vec) {
                        if (wrapper != null && wrapper.getRelation() != null) {
                            if (wrapper.getRelation().equals("Parent")) {
                                parents.add(wrapper.getIdHabitat());
                            } else if (wrapper.getRelation().equals("Ancestor")) {
                                anchestors.add(wrapper.getIdHabitat());
                            }
                        }
                    }
                }

                if (parents != null && parents.size() > 0) {
                    for (String id : parents) {
                        rdf.append(RDFUtil.writeReference("hasParent", "http://eunis.eea.europa.eu/habitats/" + id));
                    }
                }

                if (anchestors != null && anchestors.size() > 0) {
                    for (String id : anchestors) {
                        rdf.append(RDFUtil.writeReference("hasAncestor", "http://eunis.eea.europa.eu/habitats/" + id));
                    }
                }

                // List of species related to habitat.
                List<HabitatsSpeciesWrapper> speciesList = factsheet.getSpeciesForHabitats();
                if (!speciesList.isEmpty()) {
                    for (HabitatsSpeciesWrapper species : speciesList) {
                        rdf.append(RDFUtil.writeReference("typicalSpecies", "http://eunis.eea.europa.eu/species/" + species.getIdSpecies()));
                    }
                }
                rdf.append("</Habitat>\n");
            }
        } catch (InitializationException e) {
            e.printStackTrace();
        }
        return rdf;
    }
}
