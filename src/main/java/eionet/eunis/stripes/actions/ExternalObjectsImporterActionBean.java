package eionet.eunis.stripes.actions;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import ro.finsiel.eunis.utilities.EunisUtil;
import ro.finsiel.eunis.utilities.SQLUtilities;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.FileBean;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import com.hp.hpl.jena.rdf.arp.ARP;

import eionet.eunis.dto.ExternalObjectDTO;
import eionet.eunis.util.Constants;

/**
 * Action bean to handle RDF export.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/dataimporter/matchgeospecies")
public class ExternalObjectsImporterActionBean extends AbstractStripesAction {
	
	private FileBean file;
	private List<ExternalObjectDTO> objects;
	private Map<String,String> issame;

	
	@DefaultHandler
	public Resolution defaultAction() {
		String forwardPage = "/stripes/matchgeospecies.jsp";
		setMetaDescription("Match geospecies");
		objects = getContext().getExternalObjectsDao().getMaybeSameObjects();
		return new ForwardResolution(forwardPage);
	}
	
	public Resolution importObjects() {
		
		String forwardPage = "/stripes/matchgeospecies.jsp";
		setMetaDescription("Match geospecies");
		
		Connection con = null;
		InputStream inputStream = null;
		
		try{
			SQLUtilities sqlUtil = getContext().getSqlUtilities();
			con = sqlUtil.getConnection();
			RDFHandlerObjects rdfHandler = new RDFHandlerObjects(con);
			
			if (file != null){
				inputStream = file.getInputStream();
			}
			
			ARP arp = new ARP();
	        arp.getHandlers().setStatementHandler(rdfHandler);
	        arp.getHandlers().setErrorHandler(rdfHandler);
	        arp.load(inputStream);
			
			rdfHandler.endOfFile();
			
			List<String> errors = rdfHandler.getErrors();
			if(errors != null && errors.size() > 0){
				for(Iterator<String> it = errors.iterator(); it.hasNext(); ){
					String error = EunisUtil.replaceTagsExport(EunisUtil.replaceBrackets(it.next()));
					handleEunisException(error, Constants.SEVERITY_WARNING);
				}
			}
			else
				showMessage("Successfully imported!");
			
			objects = getContext().getExternalObjectsDao().getMaybeSameObjects();
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(file != null){
				try{
					file.delete();
				} catch(IOException ie){
					ie.printStackTrace();
				}
			}
			// close input stream
			if (inputStream!=null){
				try{ inputStream.close(); } catch (Exception e){ e.printStackTrace();}
			}
			// close connection
			try{ con.close(); } catch (SQLException se) { se.printStackTrace(); }
		}
		return new ForwardResolution(forwardPage);
	}
	
	public Resolution save() {
		String forwardPage = "/stripes/matchgeospecies.jsp";
		setMetaDescription("Match geospecies");
		if(issame != null){
			for(Iterator<String> it = issame.keySet().iterator(); it.hasNext();){
				String key = it.next();
				String value = issame.get(key);
				if(key != null && value != null){
					String val = "";
					if(value.equals("yes"))
						val = "issame";
					else if(value.equals("no"))
						val = "notsame";
					
					getContext().getExternalObjectsDao().updateExternalObject(key, val);
				}
			}
		}
		showMessage("Successfully updated!");
		objects = getContext().getExternalObjectsDao().getMaybeSameObjects();			
		
		return new ForwardResolution(forwardPage);
	}
	
	

	public FileBean getFile() {
	    return file;
	}

	public void setFile(FileBean file) {
	    this.file = file;
	}

	public List<ExternalObjectDTO> getObjects() {
		return objects;
	}

	public void setObjects(List<ExternalObjectDTO> objects) {
		this.objects = objects;
	}

	public Map<String, String> getIssame() {
		return issame;
	}

	public void setIssame(Map<String, String> issame) {
		this.issame = issame;
	}

}