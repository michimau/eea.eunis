package ro.finsiel.eunis.utilities;


import java.net.MalformedURLException;
import java.net.URL;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.util.StringTokenizer;


public class EunisUtil {

    /**
     * 
     * @param in
     * @param inTextarea
     * @return
     */
    public static String replaceTagsExport(String in) {
        
        in = (in != null ? in : "");
        StringBuffer ret = new StringBuffer();

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
    
    public static String replaceTagsImport(String in) {
        
        in = (in != null ? in : "");
        StringBuffer ret = new StringBuffer();

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
    
    public static String replaceBrackets(String in) {
        
        in = (in != null ? in : "");
        StringBuffer ret = new StringBuffer();

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
    
    public static String replace(String source, String pattern, String replace) {
        if (source != null) {
            final int len = pattern.length();
            StringBuffer sb = new StringBuffer();
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
            return "";
        }
    }
    
    /**
     * A method for creating a unique Hexa-Decimal digest of a String message.
     *
     * @param   src         String to be digested.
     * @param   algosrithm  Digesting algorithm (please see Java
     *                      documentation for allowable values).
     * @return              A unique String-typed Hexa-Decimal digest of the input message.
     */
    public static String digestHexDec(String src, String algorithm) {
        
        byte[] srcBytes = src.getBytes();
        byte[] dstBytes = new byte[16];
        StringBuffer buf = new StringBuffer();
        
        try {
            MessageDigest md = MessageDigest.getInstance(algorithm);

            md.update(srcBytes);
            dstBytes = md.digest();
            md.reset();
        
            for (int i = 0; i < dstBytes.length; i++) {
                Byte byteWrapper = new Byte(dstBytes[i]);
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
     * 
     * @param in
     * @return
     */
    public static String replaceTags(String in) {
        return replaceTags(in, false, false);
    }
    
    /**
     * 
     * @param in
     * @param dontCreateHTMLAnchors
     * @return
     */
    public static String replaceTags(String in, boolean dontCreateHTMLAnchors) {
        return replaceTags(in, dontCreateHTMLAnchors, false);
    }
    
    /**
     * 
     * @param in
     * @param inTextarea
     * @return
     */
    public static String replaceTags(
            String in, boolean dontCreateHTMLAnchors, boolean dontCreateHTMLLineBreaks) {
        
        in = (in != null ? in : "");
        StringBuffer ret = new StringBuffer();

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

                    if (unicodeEscapes.isXHTMLEntity(s) || unicodeEscapes.isNumericHTMLEscapeCode(s)) {
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
            } else if (c == '\r' && in.charAt(i + 1) == '\n' && dontCreateHTMLLineBreaks == false) {
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
     * Finds all urls in a given string and replaces them with HTML anchors.
     * If boolean newWindow==true then target will be a new window, else no.
     * If boolean cutLink>0 then cut the displayed link lenght cutLink.
     */
    public static String setAnchors(String s, boolean newWindow, int cutLink) {

        StringBuffer buf = new StringBuffer();
         
        StringTokenizer st = new StringTokenizer(s, " \t\n\r\f", true);

        while (st.hasMoreTokens()) {
            String token = st.nextToken();

            if (!isURL(token)) {
                buf.append(token);
            } else {
                StringBuffer _buf = new StringBuffer("<a ");

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
     * Finds all urls in a given string and replaces them with HTML anchors.
     * If boolean newWindow==true then target will be a new window, else no.
     */
    public static String setAnchors(String s, boolean newWindow) {
          
        return setAnchors(s, newWindow, 0);
    }
    
    /**
     * Finds all urls in a given string and replaces them with HTML anchors
     * with target being a new window.
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
      
    public static String threeDots(String s, int len) {
  
        if (len <= 0) {
            return s;
        }
        if (s == null || s.length() == 0) {
            return s;
        }
  
        if (s.length() > len) {
            StringBuffer buf = new StringBuffer(s.substring(0, len));

            buf.append("...");
            return buf.toString();
        } else {
            return s;
        }
    }
      
    public static boolean isNumber(String in) {
          
        try {

            Integer.parseInt(in); 
          
        } catch (NumberFormatException ex) {
            return false;
        }
          
        return true;
    }
    
}
