package ro.finsiel.eunis.reports.species.names;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.species.names.*;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.JavaSorter;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.search.species.names.NameBean;
import ro.finsiel.eunis.search.species.names.NameSearchCriteria;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

/**
 * TSV and XML report generation.
 */
public class TSVNamesReport extends AbstractTSVReport {
  /**
   * Form bean to retrieve data for search etc.
   */
  private NameBean formBean = null;

  /**
   * Form we are coming from.
   */
  private int typeForm;
  /**
   * Specifies if Any Language was selected from the search.
   */
  private boolean isAnyLanguage;

  //private XMLReport xmlreport = null;

  /**
   * Constructor.
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showEUNISInvalidatedSpecies Show invalidated species
   */
  public TSVNamesReport(String sessionID, AbstractFormBean formBean, boolean showEUNISInvalidatedSpecies) {
    super("SpeciesNamesReport_" + sessionID + ".tsv");
    this.formBean = (NameBean) formBean;
    this.filename = "SpeciesNamesReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport("SpeciesNamesReport_" + sessionID + ".xml");
    typeForm = Utilities.checkedStringToInt(this.formBean.getTypeForm(), NameSearchCriteria.CRITERIA_SCIENTIFIC.intValue());
    isAnyLanguage = null != this.formBean.getLanguage() && this.formBean.getLanguage().equalsIgnoreCase("any");
    boolean searchSynonyms = Utilities.checkedStringToBoolean(this.formBean.getSearchSynonyms(), false);

    // Coming from form 1
    if (NameSearchCriteria.CRITERIA_SCIENTIFIC.intValue() == typeForm){
    	if(formBean.getNewName() != null && formBean.getNewName().equals("true")){
    		this.dataFactory = new ro.finsiel.eunis.search.species.names.NamePaginator(new SimilarNameDomain(formBean.toSearchCriteria(),
    				formBean.toSortCriteria(),
    				searchSynonyms,
    				showEUNISInvalidatedSpecies,
    				this.formBean.getSearchVernacular()));
    	} else {
    		this.dataFactory = new ro.finsiel.eunis.search.species.names.NamePaginator(new ScientificNameDomain(formBean.toSearchCriteria(),
    				formBean.toSortCriteria(),
    				searchSynonyms,
    				showEUNISInvalidatedSpecies,
    				this.formBean.getSearchVernacular()));
    	}
    }
    // Coming from form 2
    if (NameSearchCriteria.CRITERIA_VERNACULAR.intValue() == typeForm) {
      if (isAnyLanguage) {
        this.dataFactory = new ro.finsiel.eunis.search.species.names.NamePaginator(new VernacularNameAnyDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies));
      } else {
        this.dataFactory = new ro.finsiel.eunis.search.species.names.NamePaginator(new VernacularNameDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies));
      }
    }

    //xmlreport = new XMLReport("SpeciesNamesReport_" + sessionID + ".xml");
  }

  /**
   * Create the table headers.
   *
   * @return An array with the columns headers of the table
   */
  public List<String> createHeader() {
    if (null == formBean) {
      return new Vector<String>();
    }
    Vector<String> headers = new Vector<String>();
    headers.addElement("Group");
    headers.addElement("Order");
    headers.addElement("Family");
    headers.addElement("Scientific name");
    headers.addElement("Valid name");
    headers.addElement("Common names");
    return headers;
  }

  /**
   * Use this method to write specific data into the file. Implemented in inherited classes
   */
  public void writeData() {
    if (null == dataFactory) {
      return;
    }
    dataFactory.setPageSize(RESULTS_PER_PAGE);
    try {
      int _pagesCount = dataFactory.countPages();
      if (_pagesCount == 0) {
        closeFile();
        return;
      }
      writeRow(createHeader());
      xmlreport.writeRow(createHeader());
      for (int _currPage = 0; _currPage < _pagesCount; _currPage++) {
        List resultSet = dataFactory.getPage(_currPage);
        for (int i = 0; i < resultSet.size(); i++) {
          Vector<String>aRow = new Vector<String>();
          ArrayList<String> xmlRow = new ArrayList<String>();
          String cellGroup = "";
          String cellOrder = "";
          String cellFamily = "";
          String cellScientificName = "";
          String cellValidName = "";
          Integer cellIdVernacularSearch = new Integer(0);
          // Coming from form 1
          if (NameSearchCriteria.CRITERIA_SCIENTIFIC.intValue() == typeForm) {
            ScientificNamePersist specie = (ScientificNamePersist) resultSet.get(i);
            cellGroup = (null == specie.getCommonName()) ? "" : (specie.getCommonName().equalsIgnoreCase("null")) ? "" : specie.getCommonName();
            cellOrder = specie.getTaxonomicNameOrder();
            cellOrder = (null == specie.getTaxonomicNameOrder()) ? "" : (specie.getTaxonomicNameOrder().equalsIgnoreCase("null")) ? "" : cellOrder;
            cellFamily = (specie.getTaxonomyLevel() != null && specie.getTaxonomyLevel().equalsIgnoreCase("family") ? (specie.getTaxonomicNameFamily() != null && !specie.getTaxonomicNameFamily().equalsIgnoreCase("null") ? specie.getTaxonomicNameFamily() : "") : "");
            cellScientificName = specie.getScientificName();
            cellValidName = "" + specie.getValidName();
            cellIdVernacularSearch = specie.getIdNatureObject();
          }
          // Coming from form 2
          if (NameSearchCriteria.CRITERIA_VERNACULAR.intValue() == typeForm) {
            if (isAnyLanguage) {
              VernacularNameAnyPersist specie = (VernacularNameAnyPersist) resultSet.get(i);
              cellGroup = specie.getCommonName();
              cellOrder = specie.getTaxonomicNameOrder();
              cellOrder = (null == specie.getTaxonomicNameOrder()) ? "" : (specie.getTaxonomicNameOrder().equalsIgnoreCase("null")) ? "" : cellOrder;
              cellFamily = specie.getTaxonomicNameFamily();
              cellScientificName = specie.getScientificName();
              cellIdVernacularSearch = specie.getIdNatureObject();
            } else {
              VernacularNamePersist specie = (VernacularNamePersist) resultSet.get(i);
              cellGroup = specie.getCommonName();
              cellOrder = specie.getTaxonomicNameOrder();
              cellOrder = (null == specie.getTaxonomicNameOrder()) ? "" : (specie.getTaxonomicNameOrder().equalsIgnoreCase("null")) ? "" : cellOrder;
              cellFamily = specie.getTaxonomicNameFamily();
              cellScientificName = specie.getScientificName();
              cellIdVernacularSearch = specie.getIdNatureObject();
            }
          }
          aRow.addElement(cellGroup);
          aRow.addElement(cellOrder);
          aRow.addElement(cellFamily);
          aRow.addElement(cellScientificName);
          aRow.addElement(cellValidName);

          xmlRow.add(cellGroup);
          xmlRow.add(cellOrder);
          xmlRow.add(cellFamily);
          xmlRow.add(cellScientificName);
          xmlRow.add(cellValidName);
          // Common names (multiple rows)
          Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(cellIdVernacularSearch);
          String xmlVernacularNames = "";
          if (vernNamesList.size() > 0) {
            Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
            boolean blankLine = false;
            boolean atLeastALine = false;
            for (int v = 0; v < sortVernList.size(); v++) {
              VernacularNameWrapper aVernName = (VernacularNameWrapper) sortVernList.get(v);
              boolean write = false;
              String language = formBean.getLanguage();
              String specieLangName = aVernName.getLanguage();

              if (NameSearchCriteria.CRITERIA_VERNACULAR.intValue() == typeForm && !isAnyLanguage) {
                if (language.toLowerCase().equalsIgnoreCase(specieLangName.toLowerCase()) ||
                        language.toLowerCase().equalsIgnoreCase("english")) {
                  write = true;
                }
              }
              else {
                write = true;
              }
              if (write) {
                atLeastALine = true;
                if (!blankLine) {
                  // Language
                  aRow.addElement(aVernName.getLanguage());
                  // Common name
                  aRow.addElement(aVernName.getName());
                  blankLine = true;
                  writeRow(aRow);
                } else {
                  Vector<String> anotherRow = new Vector<String>();
                  anotherRow.addElement("");
                  anotherRow.addElement("");
                  anotherRow.addElement("");
                  anotherRow.addElement("");
                  anotherRow.addElement("");
                  // Language
                  anotherRow.addElement(aVernName.getLanguage());
                  // Common name
                  anotherRow.addElement(aVernName.getName());
                  writeRow(anotherRow);
                }
              }
              xmlVernacularNames += "<name language=\"" + aVernName.getLanguage() + "\">" + aVernName.getName() + "</name>";
            }
            if (!atLeastALine) {
              writeRow(aRow);
            }
          } else {
            aRow.addElement("-");
            writeRow(aRow);
          }
          xmlRow.add(xmlVernacularNames);
          xmlreport.writeRow(xmlRow);
        }
      }
    } catch (CriteriaMissingException ex) {
      ex.printStackTrace();
    } catch (InitializationException iex) {
      iex.printStackTrace();
    } catch (IOException ioex) {
      ioex.printStackTrace();
    } catch (Exception ex2) {
      ex2.printStackTrace();
    } finally {
      closeFile();
    }
  }
}
