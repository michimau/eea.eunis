package eionet.eunis.stripes.actions;

import java.util.Iterator;
import java.util.List;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.DontValidate;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.utilities.EunisUtil;

import eionet.eunis.dto.DcContributorDTO;
import eionet.eunis.dto.DcCoverageDTO;
import eionet.eunis.dto.DcCreatorDTO;
import eionet.eunis.dto.DcDateDTO;
import eionet.eunis.dto.DcDescriptionDTO;
import eionet.eunis.dto.DcFormatDTO;
import eionet.eunis.dto.DcIdentifierDTO;
import eionet.eunis.dto.DcIndexDTO;
import eionet.eunis.dto.DcLanguageDTO;
import eionet.eunis.dto.DcObjectDTO;
import eionet.eunis.dto.DcPublisherDTO;
import eionet.eunis.dto.DcRelationDTO;
import eionet.eunis.dto.DcRightsDTO;
import eionet.eunis.dto.DcSourceDTO;
import eionet.eunis.dto.DcSubjectDTO;
import eionet.eunis.dto.DcTitleDTO;
import eionet.eunis.dto.DcTypeDTO;

/**
 * Action bean to handle RDF export.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/documents/{iddoc}")
public class DocumentsActionBean extends AbstractStripesAction {
	
	private static final String HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
		+ "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" 
        + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
		+ "xmlns:dcterms=\"http://purl.org/dc/terms/\"\n"
		+ "xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n";
	
	private static final String FOOTER = "\n</rdf:RDF>";
	
	private static final String doc_url = "http://eunis.eea.europa.eu/documents/";
	
	private String iddoc;
	private List<DcTitleDTO> docs;
	private DcTitleDTO dcTitle;
	private DcSourceDTO dcSource;
	private DcContributorDTO dcContributor;
	private DcCoverageDTO dcCoverage;
	private DcCreatorDTO dcCreator;
	private DcDateDTO dcDate;
	private DcDescriptionDTO dcDescription;
	private DcFormatDTO dcFormat;
	private DcIdentifierDTO dcIdentifier;
	private DcIndexDTO dcIndex;
	private DcLanguageDTO dcLanguage;
	private DcPublisherDTO dcPublisher;
	private DcRelationDTO dcRelation;
	private DcRightsDTO dcRights;
	private DcSubjectDTO dcSubject;
	private DcTypeDTO dcType;
	
	@DefaultHandler
	@DontValidate(ignoreBindingErrors = true)
	public Resolution defaultAction() {
		String forwardPage = "/stripes/documents.jsp";
		
		String eeaHome = getContext().getInitParameter("EEA_HOME");
		String btrail = "";
		if (!StringUtils.isBlank(iddoc)) {
			forwardPage = "/stripes/document.jsp";
			
			String acceptHeader = getContext().getRequest().getHeader("accept");
			String[] accept = null;
			if(acceptHeader != null && acceptHeader.length() > 0)
				accept = acceptHeader.split(",");
			
			if(accept != null && accept.length > 0 && accept[0].equals("application/rdf+xml")){
				return new StreamingResolution("application/rdf+xml",generateRdf(iddoc));
			} else {
				dcTitle = getContext().getDocumentsDao().getDcTitle(iddoc);
				dcSource = getContext().getDocumentsDao().getDcSource(iddoc);
				dcContributor = getContext().getDocumentsDao().getDcContributor(iddoc);
				dcCoverage = getContext().getDocumentsDao().getDcCoverage(iddoc);
				dcCreator = getContext().getDocumentsDao().getDcCreator(iddoc);
				dcDate = getContext().getDocumentsDao().getDcDate(iddoc);
				dcDescription = getContext().getDocumentsDao().getDcDescription(iddoc);
				dcFormat = getContext().getDocumentsDao().getDcFormat(iddoc);
				dcIdentifier = getContext().getDocumentsDao().getDcIdentifier(iddoc);
				dcIndex = getContext().getDocumentsDao().getDcIndex(iddoc);
				dcLanguage = getContext().getDocumentsDao().getDcLanguage(iddoc);
				dcPublisher = getContext().getDocumentsDao().getDcPublisher(iddoc);
				dcRelation = getContext().getDocumentsDao().getDcRelation(iddoc);
				dcRights = getContext().getDocumentsDao().getDcRights(iddoc);
				dcSubject = getContext().getDocumentsDao().getDcSubject(iddoc);
				dcType = getContext().getDocumentsDao().getDcType(iddoc);
				btrail = "eea#" + eeaHome + ",home#index.jsp,documents#documents";
				if(dcTitle != null){
					btrail += "," + dcTitle.getTitle();
				}
				if(dcTitle == null && dcSource == null){
					return new ErrorResolution(404);
				}
			}
			setMetaDescription("document");
		} else {
			btrail = "eea#" + eeaHome + ",home#index.jsp,documents";
			
			String acceptHeader = getContext().getRequest().getHeader("accept");
			String[] accept = acceptHeader.split(",");
			if(accept != null && accept.length > 0 && accept[0].equals("application/rdf+xml")){
				return new StreamingResolution("application/rdf+xml",generateRdfAll());
			} else {
				docs = getContext().getDocumentsDao().getDocuments();
			}
			setMetaDescription("documents");
		}
		setBtrail(btrail);
				
		return new ForwardResolution(forwardPage);
	}
	
	private String generateRdfAll(){
		StringBuffer s = new StringBuffer();
	    s.append(HEADER);
	    
		List<DcObjectDTO> objects = getContext().getDocumentsDao().getDcObjects();
		for(Iterator<DcObjectDTO> it = objects.iterator(); it.hasNext(); ){
			DcObjectDTO object = it.next();
			if(object != null){
				s.append("<rdf:Description rdf:about=\"").append(doc_url).append(object.getId()).append("\">\n");
				if(object.getTitle() != null && !object.getTitle().equals(""))
					s.append("<dc:title>").append(EunisUtil.replaceTags(object.getTitle(), true, true)).append("</dc:title>\n");
				if(object.getSource() != null && !object.getSource().equals(""))
					s.append("<dc:source>").append(EunisUtil.replaceTags(object.getSource(), true, true)).append("</dc:source>\n");
				if(object.getSourceUrl() != null && !object.getSourceUrl().equals(""))
					s.append("<rdfs:seeAlso rdf:resource=\"").append(EunisUtil.replaceTags(object.getSourceUrl(), true, true)).append("\"/>\n");
				if(object.getContributor() != null && !object.getContributor().equals(""))
					s.append("<dc:contributor>").append(EunisUtil.replaceTags(object.getContributor(), true, true)).append("</dc:contributor>\n");
				if(object.getCoverage() != null && !object.getCoverage().equals(""))
					s.append("<dc:coverage>").append(EunisUtil.replaceTags(object.getCoverage(), true, true)).append("</dc:coverage>\n");
				if(object.getCreator() != null && !object.getCreator().equals(""))
					s.append("<dc:creator>").append(EunisUtil.replaceTags(object.getCreator(), true, true)).append("</dc:creator>\n");
				if(object.getDate() != null && !object.getDate().equals(""))
					s.append("<dc:date>").append(object.getDate()).append("</dc:date>\n");
				if(object.getDescription() != null && !object.getDescription().equals(""))
					s.append("<dc:description>").append(EunisUtil.replaceTags(object.getDescription(), true, true)).append("</dc:description>\n");
				if(object.getFormat() != null && !object.getFormat().equals(""))
					s.append("<dc:format>").append(EunisUtil.replaceTags(object.getFormat(), true, true)).append("</dc:format>\n");
				if(object.getIdentifier() != null && !object.getIdentifier().equals(""))
					s.append("<dc:identifier>").append(EunisUtil.replaceTags(object.getIdentifier(), true, true)).append("</dc:identifier>\n");
				if(object.getLanguage() != null && !object.getLanguage().equals(""))
					s.append("<dc:language>").append(EunisUtil.replaceTags(object.getLanguage(), true, true)).append("</dc:language>\n");
				if(object.getPublisher() != null && !object.getPublisher().equals(""))
					s.append("<dc:publisher>").append(EunisUtil.replaceTags(object.getPublisher(), true, true)).append("</dc:publisher>\n");
				if(object.getRelation() != null && !object.getRelation().equals(""))
					s.append("<dc:relation>").append(EunisUtil.replaceTags(object.getRelation(), true, true)).append("</dc:relation>\n");
				if(object.getRights() != null && !object.getRights().equals(""))
					s.append("<dc:rights>").append(EunisUtil.replaceTags(object.getRights(), true, true)).append("</dc:rights>\n");
				if(object.getSubject() != null && !object.getSubject().equals(""))
					s.append("<dc:subject>").append(EunisUtil.replaceTags(object.getSubject(), true, true)).append("</dc:subject>\n");
				if(object.getType() != null && !object.getType().equals(""))
					s.append("<dc:type>").append(EunisUtil.replaceTags(object.getType(), true, true)).append("</dc:type>\n");
				s.append("</rdf:Description>\n");
			}
		}
		s.append(FOOTER);
		
		return s.toString();
	}
	
	private String generateRdf(String id){
		StringBuffer s = new StringBuffer();
	    s.append(HEADER);
	    
		DcObjectDTO object = getContext().getDocumentsDao().getDcObject(id);
		if(object != null){
			s.append("<rdf:Description rdf:about=\"").append(doc_url).append(object.getId()).append("\">\n");
			if(object.getTitle() != null && !object.getTitle().equals(""))
				s.append("<dc:title>").append(EunisUtil.replaceTags(object.getTitle(), true, true)).append("</dc:title>\n");
			if(object.getSource() != null && !object.getSource().equals(""))
				s.append("<dc:source>").append(EunisUtil.replaceTags(object.getSource(), true, true)).append("</dc:source>\n");
			if(object.getSourceUrl() != null && !object.getSourceUrl().equals(""))
				s.append("<rdfs:seeAlso rdf:resource=\"").append(EunisUtil.replaceTags(object.getSourceUrl(), true, true)).append("\"/>\n");
			if(object.getContributor() != null && !object.getContributor().equals(""))
				s.append("<dc:contributor>").append(EunisUtil.replaceTags(object.getContributor(), true, true)).append("</dc:contributor>\n");
			if(object.getCoverage() != null && !object.getCoverage().equals(""))
				s.append("<dc:coverage>").append(EunisUtil.replaceTags(object.getCoverage(), true, true)).append("</dc:coverage>\n");
			if(object.getCreator() != null && !object.getCreator().equals(""))
				s.append("<dc:creator>").append(EunisUtil.replaceTags(object.getCreator(), true, true)).append("</dc:creator>\n");
			if(object.getDate() != null && !object.getDate().equals(""))
				s.append("<dc:date>").append(object.getDate()).append("</dc:date>\n");
			if(object.getDescription() != null && !object.getDescription().equals(""))
				s.append("<dc:description>").append(EunisUtil.replaceTags(object.getDescription(), true, true)).append("</dc:description>\n");
			if(object.getFormat() != null && !object.getFormat().equals(""))
				s.append("<dc:format>").append(EunisUtil.replaceTags(object.getFormat(), true, true)).append("</dc:format>\n");
			if(object.getIdentifier() != null && !object.getIdentifier().equals(""))
				s.append("<dc:identifier>").append(EunisUtil.replaceTags(object.getIdentifier(), true, true)).append("</dc:identifier>\n");
			if(object.getLanguage() != null && !object.getLanguage().equals(""))
				s.append("<dc:language>").append(EunisUtil.replaceTags(object.getLanguage(), true, true)).append("</dc:language>\n");
			if(object.getPublisher() != null && !object.getPublisher().equals(""))
				s.append("<dc:publisher>").append(EunisUtil.replaceTags(object.getPublisher(), true, true)).append("</dc:publisher>\n");
			if(object.getRelation() != null && !object.getRelation().equals(""))
				s.append("<dc:relation>").append(EunisUtil.replaceTags(object.getRelation(), true, true)).append("</dc:relation>\n");
			if(object.getRights() != null && !object.getRights().equals(""))
				s.append("<dc:rights>").append(EunisUtil.replaceTags(object.getRights(), true, true)).append("</dc:rights>\n");
			if(object.getSubject() != null && !object.getSubject().equals(""))
				s.append("<dc:subject>").append(EunisUtil.replaceTags(object.getSubject(), true, true)).append("</dc:subject>\n");
			if(object.getType() != null && !object.getType().equals(""))
				s.append("<dc:type>").append(EunisUtil.replaceTags(object.getType(), true, true)).append("</dc:type>\n");
			s.append("</rdf:Description>\n");
		}
		s.append(FOOTER);
		
		return s.toString();
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

	public DcContributorDTO getDcContributor() {
		return dcContributor;
	}

	public void setDcContributor(DcContributorDTO dcContributor) {
		this.dcContributor = dcContributor;
	}

	public DcCoverageDTO getDcCoverage() {
		return dcCoverage;
	}

	public void setDcCoverage(DcCoverageDTO dcCoverage) {
		this.dcCoverage = dcCoverage;
	}

	public DcCreatorDTO getDcCreator() {
		return dcCreator;
	}

	public void setDcCreator(DcCreatorDTO dcCreator) {
		this.dcCreator = dcCreator;
	}

	public DcDateDTO getDcDate() {
		return dcDate;
	}

	public void setDcDate(DcDateDTO dcDate) {
		this.dcDate = dcDate;
	}

	public DcDescriptionDTO getDcDescription() {
		return dcDescription;
	}

	public void setDcDescription(DcDescriptionDTO dcDescription) {
		this.dcDescription = dcDescription;
	}

	public DcFormatDTO getDcFormat() {
		return dcFormat;
	}

	public void setDcFormat(DcFormatDTO dcFormat) {
		this.dcFormat = dcFormat;
	}

	public DcIdentifierDTO getDcIdentifier() {
		return dcIdentifier;
	}

	public void setDcIdentifier(DcIdentifierDTO dcIdentifier) {
		this.dcIdentifier = dcIdentifier;
	}

	public DcIndexDTO getDcIndex() {
		return dcIndex;
	}

	public void setDcIndex(DcIndexDTO dcIndex) {
		this.dcIndex = dcIndex;
	}

	public DcLanguageDTO getDcLanguage() {
		return dcLanguage;
	}

	public void setDcLanguage(DcLanguageDTO dcLanguage) {
		this.dcLanguage = dcLanguage;
	}

	public DcPublisherDTO getDcPublisher() {
		return dcPublisher;
	}

	public void setDcPublisher(DcPublisherDTO dcPublisher) {
		this.dcPublisher = dcPublisher;
	}

	public DcRelationDTO getDcRelation() {
		return dcRelation;
	}

	public void setDcRelation(DcRelationDTO dcRelation) {
		this.dcRelation = dcRelation;
	}

	public DcRightsDTO getDcRights() {
		return dcRights;
	}

	public void setDcRights(DcRightsDTO dcRights) {
		this.dcRights = dcRights;
	}

	public DcSubjectDTO getDcSubject() {
		return dcSubject;
	}

	public void setDcSubject(DcSubjectDTO dcSubject) {
		this.dcSubject = dcSubject;
	}

	public DcTypeDTO getDcType() {
		return dcType;
	}

	public void setDcType(DcTypeDTO dcType) {
		this.dcType = dcType;
	}


}