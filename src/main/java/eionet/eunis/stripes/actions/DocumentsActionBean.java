package eionet.eunis.stripes.actions;

import java.util.List;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.DontValidate;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;

import eionet.eunis.dto.DcSourceDTO;
import eionet.eunis.dto.DcTitleDTO;

/**
 * Action bean to handle RDF export.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/documents/{iddoc}")
public class DocumentsActionBean extends AbstractStripesAction {
	
	private String iddoc;
	private List<DcTitleDTO> docs;
	private DcTitleDTO dcTitle;
	private DcSourceDTO dcSource;
	
	private String btrail;
	
	@DefaultHandler
	@DontValidate(ignoreBindingErrors = true)
	public Resolution defaultAction() {
		String forwardPage = "/stripes/documents.jsp";
		
		String eeaHome = getContext().getInitParameter("EEA_HOME");
		
		if (!StringUtils.isBlank(iddoc)) {
			dcTitle = getContext().getDocumentsDao().getDcTitle(iddoc);
			dcSource = getContext().getDocumentsDao().getDcSource(iddoc);
			forwardPage = "/stripes/document.jsp";
			btrail = "eea#" + eeaHome + ",home#index.jsp,documents#documents,"+dcTitle.getTitle();
		} else {
			docs = getContext().getDocumentsDao().getDocuments();
			btrail = "eea#" + eeaHome + ",home#index.jsp,documents";
		}
		
				
		return new ForwardResolution(forwardPage);
	}


	public String getIddoc() {
		return iddoc;
	}


	public void setIddoc(String iddoc) {
		this.iddoc = iddoc;
	}


	public List<DcTitleDTO> getDocs() {
		return docs;
	}


	public void setDocs(List<DcTitleDTO> docs) {
		this.docs = docs;
	}


	public String getBtrail() {
		return btrail;
	}


	public void setBtrail(String btrail) {
		this.btrail = btrail;
	}


	public DcTitleDTO getDcTitle() {
		return dcTitle;
	}


	public void setDcTitle(DcTitleDTO dcTitle) {
		this.dcTitle = dcTitle;
	}


	public DcSourceDTO getDcSource() {
		return dcSource;
	}


	public void setDcSource(DcSourceDTO dcSource) {
		this.dcSource = dcSource;
	}


}
