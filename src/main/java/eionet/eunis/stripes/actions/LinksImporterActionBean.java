package eionet.eunis.stripes.actions;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

import ro.finsiel.eunis.utilities.EunisUtil;
import ro.finsiel.eunis.utilities.SQLUtilities;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.FileBean;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import com.hp.hpl.jena.rdf.arp.ARP;

import eionet.eunis.util.Constants;

/**
 * Action bean to handle RDF export.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/importlinks")
public class LinksImporterActionBean extends AbstractStripesAction {
	
	private FileBean file;
	
	@DefaultHandler
	public Resolution defaultAction() {
		String forwardPage = "/stripes/linkimporter.jsp";
		setMetaDescription("Import Links from GeoSpecies");
		return new ForwardResolution(forwardPage);
	}
	
	public Resolution importLinks() {
		
		String forwardPage = "/stripes/linkimporter.jsp";
		setMetaDescription("Import Links from GeoSpecies");
		
		Connection con = null;
		InputStream inputStream = null;
		
		try{
			SQLUtilities sqlUtil = getContext().getSqlUtilities();
			con = sqlUtil.getConnection();
			RDFHandler rdfHandler = new RDFHandler(con);
			
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
	
	/**
	 * Writes the content of the given InputStream into the given file and closes the file.
	 * The caller is responsible for closing the InputStream!
	 * 
	 * @param inputStream
	 * @param toFile
	 * @throws IOException
	 */
	public static int streamToFile(InputStream inputStream, File toFile) throws IOException{
		
		FileOutputStream fos = null;
		try{
			int i = -1;
			int totalBytes = 0;
			byte[] bytes = new byte[1024];
			fos = new FileOutputStream(toFile);
	        while ((i = inputStream.read(bytes, 0, bytes.length)) != -1){
	        	fos.write(bytes, 0, i);
	        	totalBytes = totalBytes + i;
	        }
	        
	        return totalBytes;
		}
		finally{
			try{
				if (fos!=null) fos.close();
			}
			catch (IOException e){
				logger.error("Failed to close file output stream: " + e.toString(), e);
			}
		}
	}

	public FileBean getFile() {
	    return file;
	}

	public void setFile(FileBean file) {
	    this.file = file;
	}
	

}
