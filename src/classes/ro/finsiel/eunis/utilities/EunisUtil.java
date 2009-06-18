package ro.finsiel.eunis.utilities;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;

public class EunisUtil {
	/**
     * 
     * @param in
     * @param inTextarea
     * @return
     */
    public static String replaceTagsExport(String in){
        
        in = (in != null ? in : "");
        StringBuffer ret = new StringBuffer();
        for (int i = 0; i < in.length(); i++) {
          char c = in.charAt(i);
          if (c == '&')
        	  ret.append("&amp;");
          else if (c == '<')
            ret.append("&lt;");
          else if (c == '>')
            ret.append("&gt;");
          else if (c == '"')
              ret.append("&quot;");
          else if (c == '\'')
              ret.append("&#039;");
          else
            ret.append(c);
        }

        return ret.toString();
    }
    
    public static String replaceTagsImport(String in){
        
        in = (in != null ? in : "");
        StringBuffer ret = new StringBuffer();
        for (int i = 0; i < in.length(); i++) {
          char c = in.charAt(i);
          if (c == '"')
              ret.append("\\\"");
          else if (c == '\'')
              ret.append("\\\'");
          else
            ret.append(c);
        }

        return ret.toString();
    }
    
    public static String replace(String source, String pattern, String replace){
        if (source!=null){
	        final int len = pattern.length();
	        StringBuffer sb = new StringBuffer();
	        int found = -1;
	        int start = 0;
	
	        while( (found = source.indexOf(pattern, start) ) != -1) {
	            sb.append(source.substring(start, found));
	            sb.append(replace);
	            start = found + len;
	        }
	
	        sb.append(source.substring(start));
	
	        return sb.toString();
        }
        else return "";
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
        
        try{
        MessageDigest md = MessageDigest.getInstance(algorithm);
        md.update(srcBytes);
        dstBytes = md.digest();
        md.reset();
        
        
        for (int i=0; i<dstBytes.length; i++){
            Byte byteWrapper = new Byte(dstBytes[i]);
            String s = Integer.toHexString(byteWrapper.intValue());
            if (s.length() == 1) s = "0" + s;
            buf.append(s.substring(s.length() - 2));
        }
        } catch (GeneralSecurityException e) {
      	  e.printStackTrace();
        }
        
        return buf.toString();
    }
    
}
