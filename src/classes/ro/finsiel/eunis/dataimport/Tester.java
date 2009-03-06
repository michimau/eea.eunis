package ro.finsiel.eunis.dataimport;

import static org.w3c.dom.Node.ELEMENT_NODE;
import static org.w3c.dom.Node.TEXT_NODE;

import java.io.File;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;
import org.xml.sax.SAXException;

import ro.finsiel.eunis.utilities.SQLUtilities;

public class Tester {
	
	public Tester() {
	}
	
	private static List<String> errors = null;
	
	public List<String> test(String filePath, String table, String SQL_DRV, String SQL_URL, String SQL_USR, String SQL_PWD) {
		
		errors = new ArrayList<String>();
		
        try {
			File xmlFile = new File(filePath);
	    	
	    	DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	    	DocumentBuilder db = dbf.newDocumentBuilder();
	    	Document doc = db.parse(xmlFile);
	    	doc.getDocumentElement().normalize();
	    	Node rootElement = doc.getDocumentElement();
	    	String rootName = rootElement.getNodeName();
	    	if(rootName == null || !rootName.equals("ROWSET"))
	    		errors.add("First element has to be ROWSET");
	
	    	NodeList rowNodes = rootElement.getChildNodes();
	    	if(rowNodes.getLength() > 0) {
			    for(int k = 0 ; k<rowNodes.getLength() ; k++) {
			    	Node rowElem = rowNodes.item(k);
			    	if(rowElem.getNodeType() == ELEMENT_NODE){
			    		String rowElemName = rowElem.getNodeName();
			    		if(!rowElemName.equals("") && !rowElemName.equals("ROW"))
			    			errors = addError(errors, "Second level element has to be ROW");
			    	}
			    }
	    	}
	    	
	    	SQLUtilities sql = new SQLUtilities();
	    	sql.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
	    	HashMap<String, ColumnDTO> columns = sql.getTableInfo(table);
	
	    	NodeList nodeLst = doc.getElementsByTagName("ROW");
	    	for (int s = 0; s < nodeLst.getLength(); s++) {
	    		Node rowNode = nodeLst.item(s);
	    		checkNodes(rowNode, columns);
	    	}
        } catch (SAXException _ex) {
    		_ex.printStackTrace();
    		errors.add(_ex.getMessage());
    	} catch (ParserConfigurationException _ex) {
    		_ex.printStackTrace();
    		errors.add(_ex.getMessage());
    	} catch (Exception _ex) {
    		_ex.printStackTrace();
    		errors.add(_ex.getMessage());
    	}
    	
    	return errors;
	}
	
	private static void checkNodes(Node node, HashMap<String, ColumnDTO> columns) {
		
	    String elemName = "";
	    String value = "";
	    List<String> xmlColumnNames = new ArrayList<String>();
	    List<String> mysqlColumnNames = getMysqlColumnNames(columns);
	    NodeList list = node.getChildNodes();       
	    if(list.getLength() > 0) {                  
		    for(int i = 0 ; i<list.getLength() ; i++) {
		    	Node elem = list.item(i);
		    	if(elem.getNodeType() == ELEMENT_NODE){
		    		elemName = elem.getNodeName();
		    		xmlColumnNames.add(elemName);
		    		NodeList childList = elem.getChildNodes();
		    		for(int s = 0 ; s<childList.getLength() ; s++) {
		    			Node elemValue = childList.item(s);
		    			if(elemValue.getNodeType() == TEXT_NODE)
		    				value = ((Text)elemValue).getData();
	    		  	}
		    		ColumnDTO column = columns.get(elemName.toLowerCase());
		    		if(column != null){
		    			if(value != null && !value.equals("NULL")){
			    			String columnName = column.getColumnName();
			    			int columnType = column.getColumnType();
			    			int size = column.getColumnSize();
			    			boolean isSigned = column.isSigned();
			    			
			    			if(columnType == Types.INTEGER || columnType == Types.SMALLINT || columnType == Types.TINYINT || columnType == Types.BIGINT || columnType == Types.NUMERIC){
			    				if(!isInteger(value) && !isLong(value))
			    					errors = addError(errors, "Element '"+elemName+"' value has to be a number between "+getRange(columnType, isSigned)+"!<br/>Current value: "+value);
			    				else
			    					checkIntSize(value, columnType, isSigned, elemName);
			    			} else if (columnType == Types.DOUBLE){
			    				if(!isDouble(value))
			    					errors = addError(errors, "Element '"+elemName+"' value has to be a number!<br/>Current value: "+value);
			    				else
			    					checkDecimalNumber(value, column.getPrecision(), column.getScale(), elemName);
			    			} else if (columnType == Types.FLOAT || columnType == Types.REAL){
			    				if(!isFloat(value))
			    					errors = addError(errors, "Element '"+elemName+"' value has to be a number!<br/>Current value: "+value);
			    				else
			    					checkDecimalNumber(value, column.getPrecision(), column.getScale(), elemName);
			    			} else if (columnType == Types.DECIMAL){
			    				if(!isDouble(value))
			    					errors = addError(errors, "Element '"+elemName+"' value has to be a number!<br/>Current value: "+value);
				    			else
			    					checkDecimalNumber(value, column.getPrecision(), column.getScale(), elemName);
			    			} else if (columnType == Types.VARCHAR || columnType == Types.CHAR || columnType == Types.LONGVARCHAR){
			    				if(value != null && value.length() > size)
			    					errors = addError(errors, "Element '"+elemName+"' value (length: "+value.length()+") is too long for mysql column '"+columnName+"' (length: "+size+")!<br/>Current value: "+threeDots(value,50));
			    			} else if (columnType == Types.DATE){
			    				if(size == 4){
			    					if(!isYear(value))
			    						errors = addError(errors, "Element '"+elemName+"' value has to be in year format (YYYY)!<br/>Current value: "+value);
			    				} else  {
			    					if(!isDate(value))
			    						errors = addError(errors, "Element '"+elemName+"' value has to be in date format (YYYY-MM-DD)!<br/>Current value: "+value);
			    				}
			    			}
		    			}
		    		} else {
		    			errors = addError(errors, "There is no such column in mysql database: "+elemName+"<br/>Columns in mysql table are: "+getColumnNames(columns));
		    		}
		    	}
		    }
		    
		    for(Iterator<String> it2=mysqlColumnNames.iterator(); it2.hasNext();){
		    	  boolean exist = false;  
	    		  String mysqlColumnName = it2.next();
	    		  for(Iterator<String> it3=xmlColumnNames.iterator(); it3.hasNext();){
	    			  String xmlColumnName = it3.next();
	    			  if(mysqlColumnName.equalsIgnoreCase(xmlColumnName))
	    				  exist = true;
	    		  }
	    		  if(!exist){
	    			  ColumnDTO col = columns.get(mysqlColumnName.toLowerCase());
    				  int nullable = col.getNullable();
    				  if(nullable == 0)
    					  errors = addError(errors, "Column '"+mysqlColumnName+"' cannot be null ");
	    		  }
		    }
	    }       
	}
	
	private static List<String> addError(List<String> errors, String error){
		if(!errors.contains(error))
			errors.add(error);
		return errors;
	}
	
	private static boolean isInteger(String s){
    	boolean ret = true;
    	try {    
    		new Integer(s).intValue(); 
    	} catch (NumberFormatException e) { 
    		ret = false;
    	}
    	return ret;
    }
	
	private static boolean isLong(String s){
    	boolean ret = true;
    	try {    
    		new Long(s).longValue(); 
    	} catch (NumberFormatException e) { 
    		ret = false;
    	}
    	return ret;
    }
	
	private static boolean isFloat(String s){
    	boolean ret = true;
    	try {    
    		new Float(s).floatValue(); 
    	} catch (NumberFormatException e) { 
    		ret = false;
    	}
    	return ret;
    }
	
	private static boolean isDouble(String s){
    	boolean ret = true;
    	try {    
    		new Double(s).doubleValue(); 
    	} catch (NumberFormatException e) { 
    		ret = false;
    	}
    	return ret;
    }
	
	private static boolean isDate(String s){
    	boolean ret = true;
    	String formatStr = "yyyy-MM-dd";
    	SimpleDateFormat df = new SimpleDateFormat(formatStr);		
    	Date testDate = null;		
    	try {
    		testDate = df.parse(s);
    	} catch (ParseException e){
    		// invalid date format			
    		ret =  false;		
    	}
    	return ret;
    }
	
	private static boolean isYear(String s){
		if(s.length() > 4)
			return false;
		
    	boolean ret = true;
    	String formatStr = "yyyy";
    	SimpleDateFormat df = new SimpleDateFormat(formatStr);		
    	Date testDate = null;		
    	try {
    		testDate = df.parse(s);
    	} catch (ParseException e){
    		// invalid date format			
    		ret =  false;		
    	}
    	return ret;
    }
	
	private static void checkIntSize(String nr, int columnType, boolean signed, String elemName){
    	
    	if(!signed){
    		if(columnType == Types.TINYINT){
    			int intVal = new Integer(nr).intValue();
    			if(intVal < 0 || intVal > 255)
    				errors = addError(errors, "Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.SMALLINT) {
    			int intVal = new Integer(nr).intValue();
    			if(intVal < 0 || intVal > 65535)
    				errors = addError(errors, "Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.INTEGER){
    			long longVal = new Long(nr).longValue();
    			long max = new Long("4294967295").longValue();
        		if(longVal < 0 || longVal > max)
        			errors = addError(errors, "Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.BIGINT){
    			long longVal = new Long(nr).longValue();
    			long max = new Long("18446744073709551615").longValue();
        		if(longVal < 0 || longVal > max)
        			errors = addError(errors, "Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		}
    	} else {
    		if(columnType == Types.TINYINT){
    			int intVal = new Integer(nr).intValue();
    			if(intVal < -128 || intVal > 127)
    				errors = addError(errors, "Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.SMALLINT) {
    			int intVal = new Integer(nr).intValue();
    			if(intVal < -32768 || intVal > 32767)
    				errors = addError(errors, "Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.INTEGER){
    			long longVal = new Long(nr).longValue();
    			long min = new Long("-2147483648").longValue();
    			long max = new Long("2147483647").longValue();
        		if(longVal < min || longVal > max)
        			errors = addError(errors, "Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.BIGINT){
    			long longVal = new Long(nr).longValue();
    			long min = new Long("-9223372036854775808").longValue();
    			long max = new Long("9223372036854775807").longValue();
        		if(longVal < min || longVal > max)
        			errors = addError(errors, "Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		}
    	}    	
    }
	
	private static String getRange(int type, boolean signed) {
		String ret = "";
		if(!signed){
			if(type == Types.TINYINT)
				ret = "0 and 255";
			else if(type == Types.SMALLINT)
				ret = "0 and 65535";
			else if(type == Types.INTEGER)
				ret = "0 and 4294967295";
			else if(type == Types.INTEGER)
				ret = "0 and 18446744073709551615";
		} else {
			if(type == Types.TINYINT)
				ret = "-128 and 127";
			else if(type == Types.SMALLINT)
				ret = "-32768 and 32767";
			else if(type == Types.INTEGER)
				ret = "-2147483648 and 2147483647";
			else if(type == Types.INTEGER)
				ret = "-9223372036854775808 and 9223372036854775807";
		}
		return ret;
	}
	
	private static void checkDecimalNumber(String nr, int precision, int scale, String elemName){
    	
		String nr_precision = "";
		String nr_scale = "";
		StringTokenizer st = new StringTokenizer(nr,".");
		if(st.hasMoreElements())
			nr_precision = st.nextToken();
		if(st.hasMoreElements())
			nr_scale = st.nextToken();
		
		if(nr_precision.startsWith("-"))
			nr_precision = nr_precision.substring(1);
		
		if(nr_precision.length() > precision)
			errors = addError(errors, "Element '"+elemName+"': Too many digits before decimal point. Has to be less than "+precision+" digits!<br/>Current value: "+nr);
		
		if(nr_scale.length() > scale)
			errors = addError(errors, "Element '"+elemName+"': Too many digits after decimal point. Has to be less than "+scale+" digits!<br/>Current value: "+nr);
		
	}
	
	private static String getColumnNames(HashMap<String, ColumnDTO> columns) {
    	
		String ret = "";
		Collection<ColumnDTO> cols = columns.values();
		int k = 1;
    	for(Iterator<ColumnDTO> it = cols.iterator(); it.hasNext();){
    		ColumnDTO column = it.next();
    		String columnName = column.getColumnName();
    		ret = ret + columnName;
    		if(k != cols.size())
    			ret = ret + ", ";
    		k++;
    	}
    	return ret;
	}
	
	private static List<String> getMysqlColumnNames(HashMap<String, ColumnDTO> columns) {
    	
		List<String> ret = new ArrayList<String>();
		Collection<ColumnDTO> cols = columns.values();
    	for(Iterator<ColumnDTO> it = cols.iterator(); it.hasNext();){
    		ColumnDTO column = it.next();
    		String columnName = column.getColumnName();
    		ret.add(columnName);
    	}
    	return ret;
	}
	
	private static String threeDots(String s, int len){
		
		if (len<=0) return s;
		if (s==null || s.length()==0) return s;
		
		if (s.length()>len){
			StringBuffer buf = new StringBuffer(s.substring(0,len));
			buf.append("...");
			return buf.toString();
		}
		else
			return s;
	}
}
