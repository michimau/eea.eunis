package ro.finsiel.eunis.search.species.taxcode;

public class TaxonomyDTO implements  Comparable<TaxonomyDTO> {
	
	private String title;
	private int id;
	
	
	public TaxonomyDTO(String title, int id) {
	    this.title = title;
	    this.id = id;
	}
	
	public String toString() {
	    return title;
	}
	
	public int compareTo(TaxonomyDTO tax) {
	    return title.compareTo(((TaxonomyDTO) tax).title);
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
}
