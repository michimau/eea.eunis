package eionet.eunis.stripes.actions;

import java.io.InputStream;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.FileBean;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;
import ro.finsiel.eunis.dataimport.parsers.RedListsAmphibiansImportParser;
import ro.finsiel.eunis.dataimport.parsers.RedListsMammalsImportParser;
import ro.finsiel.eunis.dataimport.parsers.RedListsReptilesImportParser;
import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.util.Constants;

/**
 * Action bean to handle RDF export.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/dataimport/importredlist")
public class RedListImporterActionBean extends AbstractStripesAction {
	
	private FileBean fileMammals;
	private FileBean fileAmphibians;
	private FileBean fileReptiles;
		
	@DefaultHandler
	public Resolution defaultAction() {
		String forwardPage = "/stripes/redlistimporter.jsp";
		setMetaDescription("Import Red List");
		return new ForwardResolution(forwardPage);
	}
	
	public Resolution importRedList() {
		
		String forwardPage = "/stripes/redlistimporter.jsp";
		setMetaDescription("Import Red List");
		if(getContext().getSessionManager().isAuthenticated() && getContext().getSessionManager().isImportExportData_RIGHT()){
			InputStream inputStreamMammals = null;
			InputStream inputStreamAmphibians = null;
			InputStream inputStreamReptiles = null;
			
			try{
				
				SQLUtilities sqlUtil = getContext().getSqlUtilities();
				
				if (fileMammals != null){
					inputStreamMammals = fileMammals.getInputStream();
					
					RedListsMammalsImportParser parser = new RedListsMammalsImportParser(sqlUtil);
					parser.execute(inputStreamMammals);
					fileMammals.delete();
					if(inputStreamMammals!=null)
						inputStreamMammals.close();
				}
				
				if (fileAmphibians != null){
					inputStreamAmphibians = fileAmphibians.getInputStream();
					
					RedListsAmphibiansImportParser parser = new RedListsAmphibiansImportParser(sqlUtil);
					parser.execute(inputStreamAmphibians);
					fileAmphibians.delete();
					if(inputStreamAmphibians!=null)
						inputStreamAmphibians.close();
				}
				
				if (fileReptiles != null){
					inputStreamReptiles = fileReptiles.getInputStream();
					
					RedListsReptilesImportParser parser = new RedListsReptilesImportParser(sqlUtil);
					parser.execute(inputStreamReptiles);
					fileReptiles.delete();
					if(inputStreamReptiles!=null)
						inputStreamReptiles.close();
				}
				
				showMessage("Successfully imported!");
				
			} catch(Exception e) {
				e.printStackTrace();
				handleEunisException(e.getMessage(), Constants.SEVERITY_ERROR);
			}
		} else {
			handleEunisException("You are not logged in or you do not have enough privileges to view this page!", Constants.SEVERITY_WARNING);
		}
		return new ForwardResolution(forwardPage);
	}

	public FileBean getFileMammals() {
		return fileMammals;
	}

	public void setFileMammals(FileBean fileMammals) {
		this.fileMammals = fileMammals;
	}

	public FileBean getFileAmphibians() {
		return fileAmphibians;
	}

	public void setFileAmphibians(FileBean fileAmphibians) {
		this.fileAmphibians = fileAmphibians;
	}

	public FileBean getFileReptiles() {
		return fileReptiles;
	}

	public void setFileReptiles(FileBean fileReptiles) {
		this.fileReptiles = fileReptiles;
	}
	
}
