package eionet.eunis.rdf;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import org.apache.commons.lang.StringEscapeUtils;

import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.factsheet.habitats.DescriptionWrapper;
import ro.finsiel.eunis.factsheet.habitats.HabitatFactsheetRelWrapper;
import ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet;
import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import ro.finsiel.eunis.jrfTables.Chm62edtHabitatInternationalNamePersist;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.factsheet.HabitatsSpeciesWrapper;

public class GenerateHabitatRDF {

    public static final String HEADER = "<rdf:RDF xmlns=\"http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#\"\n"
        + "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n" + "xmlns:dcterms=\"http://purl.org/dc/terms/\">\n";

    public static final String FOOTER = "\n</rdf:RDF>";

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
                writeLine("code", idHabitat);
                writeLine("name", StringEscapeUtils.escapeXml(factsheet.getHabitatScientificName()));
                if (factsheet.getCode2000() != "na") {
                    writeLine("natura2000Code", factsheet.getCode2000());
                }
                if (factsheet.getHabitatLevel() != null) {
                    rdf.append("    <level rdf:datatype=\"http://www.w3.org/2001/XMLSchema#integer\">")
                    .append(factsheet.getHabitatLevel()).append("</level>\n");
                }
                writeLine("priority", factsheet.getPriority() != null && 1 == factsheet.getPriority().shortValue() ? "Yes" : "No");

                // Add source
                Vector<DescriptionWrapper> descriptions = factsheet.getDescrOwner();
                if (descriptions != null) {
                    for (DescriptionWrapper description : descriptions) {
                        if (description.getLanguage().equalsIgnoreCase("english") && description.getIdDc() != null) {
                            String textSource =
                                Utilities.formatString(SpeciesFactsheet.getBookAuthorDate(description.getIdDc()), "");
                            if (textSource != null && textSource.length() > 0) {
                                rdf.append("    <dcterms:source rdf:resource=\"http://eunis.eea.europa.eu/documents/")
                                .append(description.getIdDc()).append("\"/>\n");
                            }
                        }
                    }
                }

                // List of habitats inernationals names.
                List<Chm62edtHabitatInternationalNamePersist> names = factsheet.getInternationalNames();
                if (!names.isEmpty()) {
                    for (Chm62edtHabitatInternationalNamePersist name : names) {
                        if (name.getName() != null && name.getName().length() > 0) {
                            rdf.append("    <nationalName xml:lang=\"").append(name.getCode()).append("\">")
                            .append(StringEscapeUtils.escapeXml(name.getName())).append("</nationalName>\n");
                        }
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
                        rdf.append("    <hasParent rdf:resource=\"http://eunis.eea.europa.eu/habitats/").append(id)
                        .append("\"/>\n");
                    }
                }

                if (anchestors != null && anchestors.size() > 0) {
                    for (String id : anchestors) {
                        rdf.append("    <hasAncestor rdf:resource=\"http://eunis.eea.europa.eu/habitats/").append(id)
                        .append("\"/>\n");
                    }
                }

                // List of species related to habitat.
                List<HabitatsSpeciesWrapper> speciesList = factsheet.getSpeciesForHabitats();
                if (!speciesList.isEmpty()) {
                    for (HabitatsSpeciesWrapper species : speciesList) {
                        rdf.append("    <typicalSpecies rdf:resource=\"http://eunis.eea.europa.eu/species/")
                        .append(species.getIdSpecies()).append("\"/>\n");
                    }
                }
                rdf.append("</Habitat>\n");
            }
        } catch (InitializationException e) {
            e.printStackTrace();
        }
        return rdf;
    }

    private void writeLine(String tag, String val) {
        if (val != null && val.length() > 0) {
            // escapeXml should have been used here - not on the call argument
            rdf.append("    <").append(tag).append(">").append(val).append("</").append(tag).append(">\n");
        }
    }

}
