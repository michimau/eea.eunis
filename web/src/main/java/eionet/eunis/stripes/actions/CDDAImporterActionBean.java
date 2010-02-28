package eionet.eunis.stripes.actions;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.FileBean;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;
import ro.finsiel.eunis.dataimport.CddaImportParser;
import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.util.Constants;

/**
 * Action bean to handle RDF export.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/dataimport/importcdda")
public class CDDAImporterActionBean extends AbstractStripesAction {
	
	private FileBean file;
		
	@DefaultHandler
	public Resolution defaultAction() {
		String forwardPage = "/stripes/cddaimporter.jsp";
		setMetaDescription("Import National CDDA");
		return new ForwardResolution(forwardPage);
	}
	
	public Resolution importCdda() {
		
		String forwardPage = "/stripes/cddaimporter.jsp";
		setMetaDescription("Import National CDDA");
		if(getContext().getSessionManager().isAuthenticated() && getContext().getSessionManager().isImportExportData_RIGHT()){
			Connection con = null;
			InputStream inputStream = null;
			
			try{
				
				SQLUtilities sqlUtil = getContext().getSqlUtilities();
				con = sqlUtil.getConnection();
				
				if (file != null){
					inputStream = file.getInputStream();
				}
				
				CddaImportParser parser = new CddaImportParser(con);
				Map<String,String> sites = parser.execute(inputStream);
				getContext().getSitesDao().deleteSites(sites);
				
				showMessage("Successfully updated!");
				
			} catch(Exception e) {
				e.printStackTrace();
				handleEunisException(e.getMessage(), Constants.SEVERITY_ERROR);
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
		} else {
			handleEunisException("You are not logged in or you do not have enough privileges to view this page!", Constants.SEVERITY_WARNING);
		}
		return new ForwardResolution(forwardPage);
	}
	
	public FileBean getFile() {
	    return file;
	}

	public void setFile(FileBean file) {
	    this.file = file;
	}

}
