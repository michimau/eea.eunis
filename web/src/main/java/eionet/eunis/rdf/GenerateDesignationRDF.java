package eionet.eunis.rdf;

import ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.designations.FactsheetDesignations;

public class GenerateDesignationRDF {

    public static final String HEADER = "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
        + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
        + "xmlns:geo=\"http://www.w3.org/2003/01/geo/wgs84_pos#\"\n"
        + "xmlns=\"http://eunis.eea.europa.eu/rdf/designations-schema.rdf#\">\n";

    private Chm62edtDesignationsPersist factsheet;
    private String idGeo;
    private String idDesig;
    private StringBuffer rdf;

    public GenerateDesignationRDF(String idDesig, String idGeo) {
        if (idDesig != null && idGeo != null) {
            FactsheetDesignations design = new FactsheetDesignations(idDesig, idGeo);
            this.factsheet = design.FindDesignationPersist();
        }
        this.idDesig = idDesig;
        this.idGeo = idGeo;
        this.rdf = new StringBuffer();
    }

    public StringBuffer getDesignationRdf() {
        try {
            if (factsheet != null) {
                rdf.append("<Designation rdf:about=\"http://eunis.eea.europa.eu/designations/")
                .append(idGeo).append(":").append(idDesig).append("\">\n");
                rdf.append(RDFUtil.writeLiteral("code", idDesig));
                rdf.append(RDFUtil.writeLiteral("name", factsheet.getDescriptionEn(),"en"));
                rdf.append(RDFUtil.writeLiteral("sourceDataSet", factsheet.getOriginalDataSource()));

                String coverage = Utilities.formatString(Utilities.findCountryByIdGeoscope(factsheet.getIdGeoscope()), "");
                if (coverage.equalsIgnoreCase("Europe")) {
                    coverage = "European Community";
                }
                rdf.append(RDFUtil.writeLiteral("geoCoverage", coverage));

                // Are CDDA sites or not
                if (factsheet.getCddaSites() != null) {
                    String cddacount = factsheet.getCddaSites();
                    Boolean val = Boolean.FALSE;
                    if (!cddacount.equalsIgnoreCase("Y")) {
                        val = Boolean.TRUE;
                    }
                    rdf.append(RDFUtil.writeLiteral("hasCDDASites", val));
                }

                rdf.append(RDFUtil.writeLiteral("areaReference", factsheet.getReferenceArea()));
                rdf.append(RDFUtil.writeLiteral("totalArea", factsheet.getTotalArea()));
                rdf.append(RDFUtil.writeLiteral("nationalLaw", factsheet.getNationalLaw()));
                rdf.append(RDFUtil.writeLiteral("nationalCategory", factsheet.getNationalCategory()));
                rdf.append(RDFUtil.writeLiteral("nationalLawReference", factsheet.getNationalLawReference()));
                rdf.append(RDFUtil.writeLiteral("nationalLawAgency", factsheet.getNationalLawAgency()));
                rdf.append(RDFUtil.writeLiteral("source", factsheet.getDataSource()));
                rdf.append(RDFUtil.writeLiteral("referenceNumber", factsheet.getReferenceNumber()));
                rdf.append(RDFUtil.writeLiteral("referenceDate", factsheet.getReferenceDate()));
                rdf.append(RDFUtil.writeLiteral("remark", factsheet.getRemark()));
                rdf.append(RDFUtil.writeLiteral("remarkSource", factsheet.getRemarkSource()));

                if (factsheet.getIdDc() != null && factsheet.getIdDc() != -1) {
                    rdf.append(RDFUtil.writeReference("reference", "http://eunis.eea.europa.eu/references/" + factsheet.getIdDc()));
                }

                rdf.append("</Designation>\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rdf;
    }
}
