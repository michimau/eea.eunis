package ro.finsiel.eunis.utilities;

public class EunisUtil {
	/**
     * 
     * @param in
     * @param inTextarea
     * @return
     */
    public static String replaceTags(String in){
        
        in = (in != null ? in : "");
        StringBuffer ret = new StringBuffer();
        for (int i = 0; i < in.length(); i++) {
          char c = in.charAt(i);
          if (c == '<')
            ret.append("&lt;");
          else if (c == '>')
            ret.append("&gt;");
          else if (c == '"')
              ret.append("&quot;");
          else if (c == '\'')
              ret.append("&#039;");
          else if (c == '\\')
              ret.append("&#092;");
          else if (c == '&'){
              boolean startsEscapeSequence = false;
              int j = in.indexOf(';', i);
              if (j>0){
                  String s = in.substring(i,j+1);
                  UnicodeEscapes unicodeEscapes = new UnicodeEscapes();
                  if (unicodeEscapes.isXHTMLEntity(s) || unicodeEscapes.isNumericHTMLEscapeCode(s))
                      startsEscapeSequence = true;
              }
              
              if (startsEscapeSequence)
                  ret.append(c);
              else
                  ret.append("&amp;");
          }
          else
            ret.append(c);
        }
        
        String retString = ret.toString();

        return retString;
    }
    
    public static String replaceLtGt(String in){
        
        in = (in != null ? in : "");
        StringBuffer ret = new StringBuffer();
        for (int i = 0; i < in.length(); i++) {
          char c = in.charAt(i);
          if (c == '<')
            ret.append("&lt;");
          else if (c == '>')
            ret.append("&gt;");
          else
            ret.append(c);
        }

        return ret.toString();
    }
}
