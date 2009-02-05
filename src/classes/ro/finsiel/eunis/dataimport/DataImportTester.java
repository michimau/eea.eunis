package ro.finsiel.eunis.dataimport;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.FileUploadException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;
import org.xml.sax.SAXException;

import java.sql.Types;

import ro.finsiel.eunis.utilities.SQLUtilities;

import static org.w3c.dom.Node.ELEMENT_NODE;
import static org.w3c.dom.Node.TEXT_NODE;

public class DataImportTester extends HttpServlet {
	
	/** ROOT of the application (relative to $TOMCAT_HOME env. variable.) */
	private static String BASE_DIR = "webapps/eunis";
	/** The temporary dir where parts of the upload are stored temporary (if file size is bigger than memory buffer). */
	private static String TEMP_DIR = "webapps/eunis/temp";
	/** Maximum file size allowed to be uploaded to the server. */
	private static int MAX_FILE_SIZE = 104857600; // Default value
	/** Files with size smaller than this are written directly to disk, others through TEMP_DIR first. */
	private static int MAX_MEM_TRESHOLD = 4096;// Files smaller than 4k are directly written to disk
	
	/**	
	* Overrides public method doPost of javax.servlet.http.HttpServlet.
	* @param request Request object
	* @param response Response object.
	*/
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		List<String> errors = new ArrayList<String>();
		
		String SQL_DRV = request.getSession().getServletContext().getInitParameter("JDBC_DRV");
		String SQL_URL = request.getSession().getServletContext().getInitParameter("JDBC_URL");
        String SQL_USR = request.getSession().getServletContext().getInitParameter("JDBC_USR");
        String SQL_PWD = request.getSession().getServletContext().getInitParameter("JDBC_PWD");
        
		String table = "";
		// Initilize the default settings
	    try
	    {
	      BASE_DIR = getServletContext().getInitParameter( "TOMCAT_HOME" );
	      TEMP_DIR = BASE_DIR + "/webapps/eunis/temp";
	    } catch (Exception ex) {
	      ex.printStackTrace();
	    }
	    List items = new ArrayList();
	    boolean isMultipart = FileUpload.isMultipartContent(request);
	    DiskFileUpload upload = new DiskFileUpload();
	    upload.setSizeThreshold(MAX_MEM_TRESHOLD);
	    upload.setSizeMax(MAX_FILE_SIZE);
	    upload.setRepositoryPath(TEMP_DIR);
	    
	    try {
	    	items = upload.parseRequest(request);
	    } catch (FileUploadException ex) {
	    	ex.printStackTrace();
	    	errors.add(ex.getMessage());
	    	response.sendRedirect("data-tester.jsp");
	    }
	    
	    if (isMultipart) {
	    	for (int i = 0; i < items.size(); i++) {
	            FileItem item = (FileItem) items.get(i);
	            if(item.isFormField()){
	            	String fieldName = item.getFieldName();
	                String fieldValue = item.getString();
	                if (null != fieldName && fieldName.equals("table")) {
	                	if(null != fieldValue && !fieldValue.equals("")){
	                		table = fieldValue;
	                	}else{
	                		errors.add("Please select table!");
            	    		break;
	                	}
	                }
	            } else {
	                try {
	                	File xmlFile = new File("xmlFile");
	                	item.write(xmlFile);
	                	
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
	        	                		errors.add("Second level element has to be ROW");
	            		    	}
	            		    }
	                	}
	                	
	                	SQLUtilities sql = new SQLUtilities();
	                	sql.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
	                	HashMap<String, ColumnDTO> columns = sql.getTableInfo(table);

	                	NodeList nodeLst = doc.getElementsByTagName("ROW");
	                	for (int s = 0; s < nodeLst.getLength(); s++) {
	                		Node rowNode = nodeLst.item(s);
	                		List<String> testErrors = checkNodes(rowNode, columns);
	                		if(testErrors != null && testErrors.size() > 0)
	                			errors.addAll(testErrors);
	                	}
	                	
	                	//uploadedStream.close();
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
	            }
	    	}
	    }
	    
	    if(errors != null && errors.size() > 0)
	    	session.setAttribute("errors", errors);
	    else
	    	session.setAttribute("success", "Sucessfully tested! No errors found.");
	    
	    response.sendRedirect("data-tester.jsp");
	}
	
	static List<String> checkNodes(Node node, HashMap<String, ColumnDTO> columns) {
		
		List<String> errors = new ArrayList<String>();
		
	    String elemName = "";
	    String value = "";
	    NodeList list = node.getChildNodes();       
	    if(list.getLength() > 0) {                  
		    for(int i = 0 ; i<list.getLength() ; i++) {
		    	Node elem = list.item(i);
		    	if(elem.getNodeType() == ELEMENT_NODE){
		    		elemName = elem.getNodeName();
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
			    				if(!isInteger(value) && !isLong(value)){
			    					errors.add("Element '"+elemName+"' value has to be a number between "+getRange(columnType, isSigned)+"!<br/>Current value: "+value);
			    				} else {
			    					List<String> intErrors = checkIntSize(value, columnType, isSigned, elemName);
			    					if(intErrors != null && intErrors.size() > 0)
				    					errors.addAll(intErrors);
			    				}		    					
			    			} else if (columnType == Types.DOUBLE){
			    				if(!isDouble(value)){
			    					errors.add("Element '"+elemName+"' value has to be a number!<br/>Current value: "+value);
			    				} else {
			    					List<String> decErrors = checkDecimalNumber(value, column.getPrecision(), column.getScale(), elemName);
			    					if(decErrors != null && decErrors.size() > 0)
				    					errors.addAll(decErrors);
			    				}		    				
			    			} else if (columnType == Types.FLOAT || columnType == Types.REAL){
			    				if(!isFloat(value)){
			    					errors.add("Element '"+elemName+"' value has to be a number!<br/>Current value: "+value);
			    				} else {
			    					List<String> decErrors = checkDecimalNumber(value, column.getPrecision(), column.getScale(), elemName);
			    					if(decErrors != null && decErrors.size() > 0)
				    					errors.addAll(decErrors);
			    				}
			    			} else if (columnType == Types.DECIMAL){
			    				if(!isDouble(value)){
			    					errors.add("Element '"+elemName+"' value has to be a number!<br/>Current value: "+value);
				    			} else {
			    					List<String> decErrors = checkDecimalNumber(value, column.getPrecision(), column.getScale(), elemName);
			    					if(decErrors != null && decErrors.size() > 0)
				    					errors.addAll(decErrors);
			    				}
			    			} else if (columnType == Types.VARCHAR || columnType == Types.CHAR || columnType == Types.LONGVARCHAR){
			    				if(value != null && value.length() > size)
			    					errors.add("Element '"+elemName+"' value is too long for mysql column '"+columnName+"'!<br/>Current value: "+value);
			    			} else if (columnType == Types.DATE){
			    				if(!isDate(value))
			    					errors.add("Element '"+elemName+"' value has to be in date format (YYYY-MM-DD)!<br/>Current value: "+value);
			    			}
		    			}
		    		} else {
		    			errors.add("There is no such column in mysql database: "+elemName+"<br/>Columns in mysql table are: "+getColumnNames(columns));
		    		}
		    		//System.out.println("<"+elemName+">"+value+"</"+elemName+">");
		    	}
		    	
		    }
	    }       
	    return errors;
	}
	
	public static boolean isInteger(String s){
    	boolean ret = true;
    	try {    
    		new Integer(s).intValue(); 
    	} catch (NumberFormatException e) { 
    		ret = false;
    	}
    	return ret;
    }
	
	public static boolean isLong(String s){
    	boolean ret = true;
    	try {    
    		new Long(s).longValue(); 
    	} catch (NumberFormatException e) { 
    		ret = false;
    	}
    	return ret;
    }
	
	public static boolean isFloat(String s){
    	boolean ret = true;
    	try {    
    		new Float(s).floatValue(); 
    	} catch (NumberFormatException e) { 
    		ret = false;
    	}
    	return ret;
    }
	
	public static boolean isDouble(String s){
    	boolean ret = true;
    	try {    
    		new Double(s).doubleValue(); 
    	} catch (NumberFormatException e) { 
    		ret = false;
    	}
    	return ret;
    }
	
	public static boolean isDate(String s){
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
	
	public static List<String> checkIntSize(String nr, int columnType, boolean signed, String elemName){
    	
		List<String> errors = new ArrayList<String>();
    	
    	if(!signed){
    		if(columnType == Types.TINYINT){
    			int intVal = new Integer(nr).intValue();
    			if(intVal < 0 || intVal > 255)
    				errors.add("Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.SMALLINT) {
    			int intVal = new Integer(nr).intValue();
    			if(intVal < 0 || intVal > 65535)
    				errors.add("Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.INTEGER){
    			long longVal = new Long(nr).longValue();
    			long max = new Long("4294967295").longValue();
        		if(longVal < 0 || longVal > max)
        			errors.add("Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.BIGINT){
    			long longVal = new Long(nr).longValue();
    			long max = new Long("18446744073709551615").longValue();
        		if(longVal < 0 || longVal > max)
        			errors.add("Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		}
    	} else {
    		if(columnType == Types.TINYINT){
    			int intVal = new Integer(nr).intValue();
    			if(intVal < -128 || intVal > 127)
    				errors.add("Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.SMALLINT) {
    			int intVal = new Integer(nr).intValue();
    			if(intVal < -32768 || intVal > 32767)
    				errors.add("Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.INTEGER){
    			long longVal = new Long(nr).longValue();
    			long min = new Long("-2147483648").longValue();
    			long max = new Long("2147483647").longValue();
        		if(longVal < min || longVal > max)
        			errors.add("Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		} else if(columnType == Types.BIGINT){
    			long longVal = new Long(nr).longValue();
    			long min = new Long("-9223372036854775808").longValue();
    			long max = new Long("9223372036854775807").longValue();
        		if(longVal < min || longVal > max)
        			errors.add("Element '"+elemName+"': number has to be between "+getRange(columnType, signed)+"!<br/>Current value: "+nr);
    		}
    	}    	
    	return errors;
    }
	
	public static String getRange(int type, boolean signed) {
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
	
	public static List<String> checkDecimalNumber(String nr, int precision, int scale, String elemName){
    	
		List<String> errors = new ArrayList<String>();
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
			errors.add("Element '"+elemName+"': Too many digits before decimal point. Has to be less than "+precision+" digits!<br/>Current value: "+nr_precision);
		
		if(nr_scale.length() > scale)
			errors.add("Element '"+elemName+"': Too many digits after decimal point. Has to be less than "+scale+" digits!<br/>Current value: "+nr_scale);
		
		return errors;
		
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

}
