package ro.finsiel.eunis.dataimport;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import ro.finsiel.eunis.utilities.TableColumns;

public class ImportParser extends DefaultHandler {
	
	ArrayList<TableColumns> rows;
	ArrayList<String> nameList;
	ArrayList<String> valueList;
	private String tempVal;
	private String filePath;
	
	public ImportParser() {
		rows = new ArrayList<TableColumns>();
	}
	
	private void parseDocument() {
		
		//get a factory
		SAXParserFactory spf = SAXParserFactory.newInstance();
		try {
			
			File xmlFile = new File(filePath);
			//get a new instance of parser
			SAXParser sp = spf.newSAXParser();
			
			//parse the file and also register this class for call backs
			sp.parse(xmlFile, this);
			
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch (IOException ie) {
			ie.printStackTrace();
		}
	}
	
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		tempVal = "";
		if(qName.equalsIgnoreCase("ROW")) {
			nameList = new ArrayList<String>();
			valueList = new ArrayList<String>();
		}
	}
	

	public void characters(char[] ch, int start, int length) throws SAXException {
		tempVal = new String(ch,start,length);
	}
	
	public void endElement(String uri, String localName, String qName) throws SAXException {

		if(qName.equalsIgnoreCase("ROW")) {
			TableColumns tableColumns = new TableColumns();
		    tableColumns.setColumnsNames(nameList);
		    tableColumns.setColumnsValues(valueList);
			rows.add(tableColumns);
		} else if (!qName.equalsIgnoreCase("ROWSET")) {
			nameList.add(qName);
			valueList.add(tempVal);
		}
	}
	
	public List<TableColumns> getTableRows(String filePath) {
		
		this.filePath = filePath;
		
        try {
			parseDocument();
    	} catch (Exception _ex) {
    		_ex.printStackTrace();
    	}
    	
    	return rows;
	}
}
