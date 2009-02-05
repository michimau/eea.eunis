package ro.finsiel.eunis.dataimport;

import java.util.List;

/**
 * 
 * @author altnyris
 *
 */
public class ColumnDTO implements java.io.Serializable {
	
	private String columnName;
	private int columnType;
	private int columnSize;
	private int precision;
	private int scale;
	private boolean signed;
	private int nullable;

	/**
	 * 
	 */
	public ColumnDTO(){
	}
	public String getColumnName() {
		return columnName;
	}
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}
	public int getColumnType() {
		return columnType;
	}
	public void setColumnType(int columnType) {
		this.columnType = columnType;
	}
	public int getColumnSize() {
		return columnSize;
	}
	public void setColumnSize(int columnSize) {
		this.columnSize = columnSize;
	}
	public boolean isSigned() {
		return signed;
	}
	public void setSigned(boolean signed) {
		this.signed = signed;
	}
	public int getPrecision() {
		return precision;
	}
	public void setPrecision(int precision) {
		this.precision = precision;
	}
	public int getScale() {
		return scale;
	}
	public void setScale(int scale) {
		this.scale = scale;
	}
	public int getNullable() {
		return nullable;
	}
	public void setNullable(int nullable) {
		this.nullable = nullable;
	}
	
}
