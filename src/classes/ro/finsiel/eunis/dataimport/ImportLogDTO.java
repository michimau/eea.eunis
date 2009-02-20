package ro.finsiel.eunis.dataimport;

/**
 * 
 * @author altnyris
 *
 */
public class ImportLogDTO implements java.io.Serializable {
	
	private String id;
	private String message;
	private String timestamp;

	/**
	 * 
	 */
	public ImportLogDTO(){
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}	
}
