package ro.finsiel.eunis.dataimport;

import static org.w3c.dom.Node.ELEMENT_NODE;
import static org.w3c.dom.Node.TEXT_NODE;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;
import org.xml.sax.SAXException;

import ro.finsiel.eunis.utilities.EunisUtil;
import ro.finsiel.eunis.utilities.SQLUtilities;
import ro.finsiel.eunis.utilities.TableColumns;

public class ImportJob implements Job {
	
	public ImportJob() {
		
	}
	
	public void execute(JobExecutionContext context) throws JobExecutionException {
		
		String instName = context.getJobDetail().getName();
		String instGroup = context.getJobDetail().getGroup();

		JobDataMap dataMap = context.getJobDetail().getJobDataMap();
		
		String sqlDrv = dataMap.getString("sqlDrv");
		String sqlUrl = dataMap.getString("sqlUrl");
		String sqlUsr = dataMap.getString("sqlUsr");
		String sqlPwd = dataMap.getString("sqlPwd");
		
		SQLUtilities sql = new SQLUtilities();
    	sql.Init(sqlDrv, sqlUrl, sqlUsr, sqlPwd);
		
		String tmpDir = dataMap.getString("tmpDir");

		String table = dataMap.getString("table");
		boolean emptyTable = dataMap.getBoolean("emptyTable");
		try {
			File xmlFile = new File(tmpDir + "/importXmlFile");
			
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	    	DocumentBuilder db = dbf.newDocumentBuilder();
	    	Document doc = db.parse(xmlFile);
	    	doc.getDocumentElement().normalize();
	    	
	    	List<TableColumns> tableRows = new ArrayList<TableColumns>();
	    	NodeList nodeLst = doc.getElementsByTagName("ROW");
	    	for (int s = 0; s < nodeLst.getLength(); s++) {
	    		Node node = nodeLst.item(s);
	    		String elemName = "";
	    	    String value = "";
	    	    List<String> nameList = new ArrayList<String>();
	    	    List<String> valueList = new ArrayList<String>();
	    		
	    		NodeList list = node.getChildNodes();       
	    	    if(list.getLength() > 0) {                  
	    		    for(int k = 0 ; k<list.getLength() ; k++) {
	    		    	Node elem = list.item(k);
	    		    	if(elem.getNodeType() == ELEMENT_NODE){
	    		    		elemName = elem.getNodeName();
	    		    		NodeList childList = elem.getChildNodes();
	    		    		for(int c = 0 ; c<childList.getLength() ; c++) {
	    		    			Node elemValue = childList.item(c);
	    		    			if(elemValue.getNodeType() == TEXT_NODE)
	    		    				value = ((Text)elemValue).getData();
	    	    		  	}
	    	    			if(value != null){
	    		    			nameList.add(elemName);
	    		    			valueList.add(EunisUtil.replaceTagsImport(value));
	    	    			}
	    		    	}
	    		    }
	    	    }
	    	    TableColumns tableColumns = new TableColumns();
			    tableColumns.setColumnsNames(nameList);
			    tableColumns.setColumnsValues(valueList);
			    
			    tableRows.add(tableColumns);
	    	}
	    	
	    	if(emptyTable)
	    		sql.ExecuteDelete(table, null);
	    	sql.ExecuteMultipleInsert(table, tableRows);
	    	
	    	//uploadedStream.close();
		} catch (SAXException _ex) {
			_ex.printStackTrace();
			sql.addImportLogMessage("Import error: "+_ex.getMessage());
			throw new JobExecutionException(_ex.toString(), _ex);
		} catch (ParserConfigurationException _ex) {
			_ex.printStackTrace();
			sql.addImportLogMessage("Import error: "+_ex.getMessage());
			throw new JobExecutionException(_ex.toString(), _ex);
		} catch (Exception _ex) {
			_ex.printStackTrace();
			sql.addImportLogMessage("Import error: "+_ex.getMessage());
			throw new JobExecutionException(_ex.toString(), _ex);
		}
	}


}
