package ro.finsiel.eunis.utilities;

import java.net.MalformedURLException;
import java.net.URL;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.util.StringTokenizer;

import eionet.eunis.dto.TaxonomyTreeDTO;

public class EunisUtil {

    /**
     * Encode a string for XML or HTML.
     *
     * @param in - input string
     * @return encoded string.
     */
    public static String replaceTagsExport(String in) {

        in = (in != null ? in : "");
        StringBuilder ret = new StringBuilder();

        for (int i = 0; i < in.length(); i++) {
            char c = in.charAt(i);

            if (c == '&') {
                ret.append("&amp;");
            } else if (c == '<') {
                ret.append("&lt;");
            } else if (c == '>') {
                ret.append("&gt;");
            } else if (c == '"') {
                ret.append("&quot;");
            } else if (c == '\'') {
                ret.append("&#039;");
            } else {
                ret.append(c);
            }
        }

        return ret.toString();
    }

    /**
     * Adds escape characters to quotes
     * @param in
     * @return
     */
    public static String replaceTagsImport(String in) {

        in = (in != null ? in : "");
        StringBuilder ret = new StringBuilder();

        for (int i = 0; i < in.length(); i++) {
            char c = in.charAt(i);

            if (c == '"') {
                ret.append("\\\"");
            } else if (c == '\'') {
                ret.append("\\\'");
            } else {
                ret.append(c);
            }
        }

        return ret.toString();
    }

    public static String replaceTagsAuthor(String in) {

        in = in.trim();

        if (in.startsWith("(")) {
            in = in.substring(1);
        }

        int index = in.indexOf(",");

        if (index != -1) {
            in = in.substring(0, index);
        }

        if (in.endsWith(")")) {
            in = in.substring(0, in.length() - 1);
        }

        return in.trim();
    }

    /**
     * Replace { with [ and } with ]. It is actually replacing braces with brackets.
     *
     * @param in - input string
     * @return - string with replacements.
     */
    public static String replaceBrackets(String in) {

        in = (in != null ? in : "");
        StringBuilder ret = new StringBuilder();

        for (int i = 0; i < in.length(); i++) {
            char c = in.charAt(i);

            if (c == '{') {
                ret.append("[");
            } else if (c == '}') {
                ret.append("]");
            } else {
                ret.append(c);
            }
        }

        return ret.toString();
    }

    /**
     * Replace pattern within source with the replace string.
     * @param source Source string; if null returns empty string
     * @param pattern Pattern to be replaced; if null returns the source
     * @param replace String to replace with
     * @return Replaced string
     */
    public static String replace(String source, String pattern, String replace) {
        if (source != null) {
            if(replace != null){
                if(pattern!=null && pattern.length() != 0){
                    int len = pattern.length();
                    StringBuilder sb = new StringBuilder();
                    int found = -1;
                    int start = 0;

                    while ((found = source.indexOf(pattern, start)) != -1) {
                        sb.append(source.substring(start, found));
                        sb.append(replace);
                        start = found + len;
                    }

                    sb.append(source.substring(start));

                    return sb.toString();
                } else {
                    return source;
                }
            } else {
                return source;
            }
        } else {
            return "";
        }
    }

    /**
     * A method for creating a unique Hexa-Decimal digest of a String message.
     *
     * @param src String to be digested.
     * @param algorithm Digesting algorithm (please see Java documentation for allowable values).
     * @return A unique String-typed Hexa-Decimal digest of the input message.
     */
    public static String digestHexDec(String src, String algorithm) {

        byte[] srcBytes = src.getBytes();
        byte[] dstBytes;
        StringBuilder buf = new StringBuilder();

        try {
            MessageDigest md = MessageDigest.getInstance(algorithm);

            md.update(srcBytes);
            dstBytes = md.digest();
            md.reset();

            for (Byte byteWrapper : dstBytes) {
                String s = Integer.toHexString(byteWrapper.intValue());

                if (s.length() == 1) {
                    s = "0" + s;
                }
                buf.append(s.substring(s.length() - 2));
            }
        } catch (GeneralSecurityException e) {
            e.printStackTrace();
        }

        return buf.toString();
    }

    /**
     * @param in
     * @return new string with replacements.
     */
    public static String replaceTags(String in) {
        return replaceTags(in, false, false);
    }

    /**
     * @param in
     * @param dontCreateHTMLAnchors
     * @return new string with replacements.
     */
    public static String replaceTags(String in, boolean dontCreateHTMLAnchors) {
        return replaceTags(in, dontCreateHTMLAnchors, false);
    }

    /**
     * @param in
     * @param dontCreateHTMLAnchors
     * @param dontCreateHTMLLineBreaks - do not change \n into &lt;br/&gt;
     * @return new string with replacements.
     */
    public static String replaceTags(
            String in, boolean dontCreateHTMLAnchors, boolean dontCreateHTMLLineBreaks) {

        in = (in != null ? in : "");
        StringBuilder ret = new StringBuilder();

        for (int i = 0; i < in.length(); i++) {
            char c = in.charAt(i);

            if (c == '<') {
                ret.append("&lt;");
            } else if (c == '>') {
                ret.append("&gt;");
            } else if (c == '"') {
                ret.append("&quot;");
            } else if (c == '\'') {
                ret.append("&#039;");
            } else if (c == '\\') {
                ret.append("&#092;");
            } else if (c == '&') {
                boolean startsEscapeSequence = false;
                int j = in.indexOf(';', i);

                if (j > 0) {
                    String s = in.substring(i, j + 1);
                    UnicodeEscapes unicodeEscapes = new UnicodeEscapes();

                    if (unicodeEscapes.isXHTMLEntity(s)
                            || unicodeEscapes.isNumericHTMLEscapeCode(s)) {
                        startsEscapeSequence = true;
                    }
                }

                if (startsEscapeSequence) {
                    ret.append(c);
                } else {
                    ret.append("&amp;");
                }
            } else if (c == '\n' && dontCreateHTMLLineBreaks == false) {
                ret.append("<br/>");
            } else if (c == '\r' && in.charAt(i + 1) == '\n'
                && dontCreateHTMLLineBreaks == false) {
                ret.append("<br/>");
                i = i + 1;
            } else {
                ret.append(c);
            }
        }

        String retString = ret.toString();

        if (dontCreateHTMLAnchors == false) {
            retString = setAnchors(retString, false, 50);
        }

        return retString;
    }

    /**
     * Finds all urls in a given string and replaces them with HTML anchors. If boolean newWindow==true then target will be a new
     * window, else no. If boolean cutLink &gt; 0 then cut the displayed link length cutLink.
     */
    public static String setAnchors(String s, boolean newWindow, int cutLink) {

        StringBuilder buf = new StringBuilder();

        StringTokenizer st = new StringTokenizer(s, " \t\n\r\f", true);

        while (st.hasMoreTokens()) {
            String token = st.nextToken();

            if (!isURL(token)) {
                buf.append(token);
            } else {
                StringBuilder _buf = new StringBuilder("<a ");

                if (newWindow) {
                    _buf.append("target=\"_blank\" ");
                }
                _buf.append("href=\"");
                _buf.append(token);
                _buf.append("\">");

                if (cutLink < token.length()) {
                    _buf.append(token.substring(0, cutLink)).append("...");
                } else {
                    _buf.append(token);
                }

                _buf.append("</a>");
                buf.append(_buf.toString());
            }
        }

        return buf.toString();
    }

    /**
     * Finds all urls in a given string and replaces them with HTML anchors. If boolean newWindow==true then target will be a new
     * window, else no.
     */
    public static String setAnchors(String s, boolean newWindow) {

        return setAnchors(s, newWindow, 0);
    }

    /**
     * Finds all urls in a given string and replaces them with HTML anchors with target being a new window.
     */
    public static String setAnchors(String s) {

        return setAnchors(s, true);
    }

    /**
     * Checks if the given string is a well-formed URL
     */
    public static boolean isURL(String s) {
        try {
            URL url = new URL(s);
        } catch (MalformedURLException e) {
            return false;
        }

        return true;
    }

    /**
     * Cut a string to given length and add three dots. If length is negative,
     * then return the full string. If string is already shorter, then don't cut.
     *
     * @param s - string to cut
     * @param len - location to cut in
     * @return new string
     */
    public static String threeDots(String s, int len) {

        if (len <= 0) {
            return s;
        }
        if (s == null || s.length() == 0) {
            return s;
        }

        if (s.length() > len) {
            StringBuilder buf = new StringBuilder(s.substring(0, len));

            buf.append("...");
            return buf.toString();
        } else {
            return s;
        }
    }

    /**
     * Checks if the gven String is an integer
     * @param in String to check
     * @return true if no NumberFormatException is thrown while trying to convert
     */
    public static boolean isNumber(String in) {

        try {

            Integer.parseInt(in);

        } catch (NumberFormatException ex) {
            return false;
        }

        return true;
    }

    public static void writeLogMessage(String msg, boolean cmd, SQLUtilities sql) {
        if (cmd) {
            System.out.println(msg);
        } else {
            sql.addImportLogMessage(msg);
        }
    }

    public static TaxonomyTreeDTO extractTaxonomyTree(String taxonomyTree) {

        TaxonomyTreeDTO ret = new TaxonomyTreeDTO();

        StringTokenizer st = new StringTokenizer(taxonomyTree, ",");

        while (st.hasMoreTokens()) {
            StringTokenizer sts = new StringTokenizer(st.nextToken(), "*");
            String classification_id = sts.nextToken();
            String classification_level = sts.nextToken();
            String classification_name = sts.nextToken();

            if (classification_level.equalsIgnoreCase("Kingdom")) {
                ret.setKingdom(classification_name);
            } else if (classification_level.equalsIgnoreCase("Phylum")) {
                ret.setPhylum(classification_name);
            } else if (classification_level.equalsIgnoreCase("Class")) {
                ret.setDwcClass(classification_name);
            } else if (classification_level.equalsIgnoreCase("Order")) {
                ret.setOrder(classification_name);
            } else if (classification_level.equalsIgnoreCase("Family")) {
                ret.setFamily(classification_name);
            }
        }

        return ret;
    }

    /**
     * Escapes MySQL strings
     * @param text
     * @return The text with MySQL-style escapes, if needed
     */
    public static String mysqlEscapes(String text)
    {
        text = text.replace("'","''");

        return text;
    }

}
