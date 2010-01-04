package eionet.eunis.stripes.actions;

import java.io.ByteArrayOutputStream;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.DontValidate;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;
import org.dozer.DozerBeanMapperSingletonWrapper;
import org.dozer.Mapper;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;

import ro.finsiel.eunis.factsheet.sites.SiteFactsheet;
import eionet.eunis.dto.SiteFactsheetDto;

/**
 * Action bean to handle RDF export.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/rdf/sites/{idsite}")
public class SitesActionBean extends AbstractStripesAction {
	
	private static final String ACCEPT_RDF_HEADER = "application/rdf+xml";

	private static final String HEADER = "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" 
          + "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n"
          + "xmlns:cr=\"http://cr.eionet.europa.eu/ontologies/contreg.rdf#\"\n"
          + "xmlns=\"http://eunis.eea.europa.eu/rdf/sites-schema.rdf#\">\n";
	
	private static final String FOOTER = "\n</rdf:RDF>";
	
	private String idsite;
	
	
	/**
	 * If 'accept' header is set to 'application/rdf+xml' when RDF document is generated and returned,
	 * otherwise redirect to site-factsheet.jsp is sent.
	 * @return
	 */
	@DefaultHandler
	@DontValidate(ignoreBindingErrors = true)
	public Resolution defaultAction() {
		if (ACCEPT_RDF_HEADER.equals(getContext().getRequest().getHeader("accept")) 
				&& !StringUtils.isBlank(idsite)) {
			return getSiteRdf(idsite);
		} else {
			return new RedirectResolution("/sites-factsheet.jsp?idsite=" + idsite);
		}
	}
	
	private Resolution getSiteRdf(String idsite2) {
		SiteFactsheet factsheet = new SiteFactsheet(idsite2);
		if (factsheet.exists()) {
			Mapper mapper = DozerBeanMapperSingletonWrapper.getInstance();
			SiteFactsheetDto dto = mapper.map(factsheet, SiteFactsheetDto.class);
			Persister persister = new Persister(new Format(4));
			ByteArrayOutputStream buffer = new ByteArrayOutputStream();
			try {
				buffer.write(HEADER.getBytes("UTF-8"));
				persister.write(dto, buffer, "UTF-8");
				buffer.write(FOOTER.getBytes("UTF-8"));
				buffer.flush();
				return new StreamingResolution("text/xml", buffer.toString("UTF-8"));
			} catch (Exception e) {
				logger.error(e);
				throw new RuntimeException(e);
			}
		} else {
			return new ErrorResolution(404); 
		}
			
	}

	/**
	 * @return the idsite
	 */
	public String getIdsite() {
		return idsite;
	}

	/**
	 * @param idsite the idsite to set
	 */
	public void setIdsite(String idsite) {
		this.idsite = idsite;
	}

}
