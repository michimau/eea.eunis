package ro.finsiel.eunis.dataimport;

/**
 * 
 * @author altnyris
 *
 */
public class FieldDTO implements java.io.Serializable {
	
	private String columnName;
	private String columnValue;

	/**
	 * 
	 */
	public FieldDTO(){
	}
	public String getColumnName() {
		return columnName;
	}
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}
	public String getColumnValue() {
		return columnValue;
	}
	public void setColumnValue(String columnValue) {
		this.columnValue = columnValue;
	}	
}
