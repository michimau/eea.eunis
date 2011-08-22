/**
 * 
 */
package eionet.eunis.util;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Risto Alt
 *
 */
public final class DcTermsLabels {

    private static final Map<String, String> dcTermsLabels = new HashMap<String, String>();
    static {
        dcTermsLabels.put("abstract", "Abstract");
        dcTermsLabels.put("accessRights", "Access Rights");
        dcTermsLabels.put("accrualMethod", "Accrual Method");
        dcTermsLabels.put("accrualPeriodicity", "Accrual Periodicity");
        dcTermsLabels.put("accrualPolicy", "Accrual Policy");
        dcTermsLabels.put("alternative", "Alternative Title");
        dcTermsLabels.put("audience", "Audience");
        dcTermsLabels.put("available", "Date Available");
        dcTermsLabels.put("bibliographicCitation", "Bibliographic Citation");
        dcTermsLabels.put("conformsTo", "Conforms To");
        dcTermsLabels.put("contributor", "Contributor");
        dcTermsLabels.put("coverage", "Coverage");
        dcTermsLabels.put("created", "Date Created");
        dcTermsLabels.put("creator", "Creator");
        dcTermsLabels.put("date", "Date");
        dcTermsLabels.put("dateAccepted", "Date Accepted");
        dcTermsLabels.put("dateCopyrighted", "Date Copyrighted");
        dcTermsLabels.put("dateSubmitted", "Date Submitted");
        dcTermsLabels.put("description", "Description");
        dcTermsLabels.put("educationLevel", "Audience Education Level");
        dcTermsLabels.put("extent", "Extent");
        dcTermsLabels.put("format", "Format");
        dcTermsLabels.put("hasFormat", "Has Format");
        dcTermsLabels.put("hasPart", "Has Part");
        dcTermsLabels.put("hasVersion", "Has Version");
        dcTermsLabels.put("identifier", "Identifier");
        dcTermsLabels.put("instructionalMethod", "Instructional Method");
        dcTermsLabels.put("isFormatOf", "Is Format Of");
        dcTermsLabels.put("isPartOf", "Is Part Of");
        dcTermsLabels.put("isReferencedBy", "Is Referenced By");
        dcTermsLabels.put("isReplacedBy", "Is Replaced By");
        dcTermsLabels.put("isRequiredBy", "Is Required By");
        dcTermsLabels.put("issued", "Date Issued");
        dcTermsLabels.put("isVersionOf", "Is Version Of");
        dcTermsLabels.put("language", "Language");
        dcTermsLabels.put("license", "License");
        dcTermsLabels.put("mediator", "Mediator");
        dcTermsLabels.put("medium", "Medium");
        dcTermsLabels.put("modified", "Date Modified");
        dcTermsLabels.put("provenance", "Provenance");
        dcTermsLabels.put("publisher", "Publisher");
        dcTermsLabels.put("references", "References");
        dcTermsLabels.put("relation", "Relation");
        dcTermsLabels.put("replaces", "Replaces");
        dcTermsLabels.put("requires", "Requires");
        dcTermsLabels.put("rights", "Rights");
        dcTermsLabels.put("rightsHolder", "Rights Holder");
        dcTermsLabels.put("source", "Source");
        dcTermsLabels.put("spatial", "Spatial Coverage");
        dcTermsLabels.put("subject", "Subject");
        dcTermsLabels.put("tableOfContents", "Table Of Contents");
        dcTermsLabels.put("temporal", "Temporal Coverage");
        dcTermsLabels.put("title", "Title");
        dcTermsLabels.put("type", "Type");
        dcTermsLabels.put("valid", "Date Valid");
        dcTermsLabels.put("rdf:type", "Type");
    }

    public static Map<String, String> getDctermslabels() {
        return dcTermsLabels;
    }
}
