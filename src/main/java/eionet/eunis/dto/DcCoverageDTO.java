package eionet.eunis.dto;

import java.io.Serializable;

import org.simpleframework.xml.Root;

/**
 * Document dto object.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@Root
public class DcCoverageDTO implements Serializable {
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	private String idDc;
	private String idCoverage;
	private String coverage;
	private String spatial;
	private String temporal;
	
	public String getIdDc() {
		return idDc;
	}
	public void setIdDc(String idDc) {
		this.idDc = idDc;
	}
	public String getIdCoverage() {
		return idCoverage;
	}
	public void setIdCoverage(String idCoverage) {
		this.idCoverage = idCoverage;
	}
	public String getCoverage() {
		return coverage;
	}
	public void setCoverage(String coverage) {
		this.coverage = coverage;
	}
	public String getSpatial() {
		return spatial;
	}
	public void setSpatial(String spatial) {
		this.spatial = spatial;
	}
	public String getTemporal() {
		return temporal;
	}
	public void setTemporal(String temporal) {
		this.temporal = temporal;
	}
}
