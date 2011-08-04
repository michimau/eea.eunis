package eionet.eunis.rdf;

import java.math.BigDecimal;

import org.apache.commons.lang.StringEscapeUtils;

public class RDFUtil {

    /**
     * Write a reference to another resource.
     *
     * @param tag - the name of the predicate.
     * @param ref - the URL of the other object as a string.
     * @return String
     */
    public static String writeReference(final String tag, final String ref) {
        StringBuffer rdf = new StringBuffer();
        rdf.append("    <").append(tag).append(" rdf:resource=\"").append(ref).append("\"/>\n");
        return rdf.toString();
    }

    /**
     * Write a string literal where the language isn't provided.
     *
     * @param tag - the name of the predicate.
     * @param val - value to write.
     * @return String
     */
    public static String writeLiteral(final String tag, final String val) {
        return writeLiteral(tag, val, null);
    }

    /**
     * Write a string literal where the language is provided.
     *
     * @param tag - the name of the predicate.
     * @param val - value to write.
     * @return String
     */
    public static String writeLiteral(final String tag, final String val, final String langcode) {
        StringBuffer rdf = new StringBuffer();
        if (val != null && val.length() > 0) {
            rdf.append("    <").append(tag);
            if (null != langcode) {
                rdf.append(" xml:lang=\"").append(langcode).append("\"");
            }
            rdf.append(">").append(StringEscapeUtils.escapeXml(val))
            .append("</").append(tag).append(">\n");
        }
        return rdf.toString();
    }

    /**
     * Write a literal of type Boolean.
     *
     * @param tag - the name of the predicate.
     * @param val - value to write.
     * @return String
     */
    public static String writeLiteral(final String tag, final Boolean val) {
        StringBuffer rdf = new StringBuffer();
        if (val != null) {
            rdf.append("    <").append(tag).append(" rdf:datatype=\"http://www.w3.org/2001/XMLSchema#boolean\">")
            .append(val ? "true" : "false").append("</").append(tag).append(">\n");
        }
        return rdf.toString();
    }

    /**
     * Write a literal of type Integer.
     *
     * @param tag - the name of the predicate.
     * @param val - value to write.
     * @return String
     */
    public static String writeLiteral(final String tag, final Integer val) {
        StringBuffer rdf = new StringBuffer();
        if (val != null) {
            rdf.append("    <").append(tag).append(" rdf:datatype=\"http://www.w3.org/2001/XMLSchema#integer\">")
            .append(val).append("</").append(tag).append(">\n");
        }
        return rdf.toString();
    }

    /**
     * Write a literal of type Decimal.
     *
     * @param tag - the name of the predicate.
     * @param val - value to write.
     * @return String
     */
    public static String writeLiteral(final String tag, final BigDecimal val) {
        StringBuffer rdf = new StringBuffer();
        if (val != null) {
            rdf.append("    <").append(tag).append(" rdf:datatype=\"http://www.w3.org/2001/XMLSchema#decimal\">")
            .append(val).append("</").append(tag).append(">\n");
        }
        return rdf.toString();
    }
}
