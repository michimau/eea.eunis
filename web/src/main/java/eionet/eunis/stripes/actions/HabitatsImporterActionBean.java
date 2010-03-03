package eionet.eunis.stripes.actions;

import java.io.IOException;
import java.io.InputStream;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.FileBean;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;
import ro.finsiel.eunis.dataimport.HabitatImportParser;
import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.util.Constants;

/**
 * Action bean to handle RDF export.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/dataimport/importhabitats")
public class HabitatsImporterActionBean extends AbstractStripesAction {
	
	private FileBean file;
		
	@DefaultHandler
	public Resolution defaultAction() {
		String forwardPage = "/stripes/habitatsimporter.jsp";
		setMetaDescription("Import Habitats");
		return new ForwardResolution(forwardPage);
	}
	
	public Resolution importHabitats() {
		
		String forwardPage = "/stripes/habitatsimporter.jsp";
		setMetaDescription("Import Habitats");
		if(getContext().getSessionManager().isAuthenticated() && getContext().getSessionManager().isImportExportData_RIGHT()){
			InputStream inputStream = null;
			
			try{
				
				SQLUtilities sqlUtil = getContext().getSqlUtilities();
				
				if (file != null){
					inputStream = file.getInputStream();
				}
				
				HabitatImportParser parser = new HabitatImportParser(sqlUtil);
				parser.execute(inputStream);
				
				showMessage("Successfully imported!");
				
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
