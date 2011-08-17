package ro.finsiel.eunis.reports.habitats.references;

/**
 * Date: Apr 17, 2003
 * Time: 9:10:15 AM
 */

import java.io.IOException;
import java.util.List;
import java.util.Vector;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksDomain;
import ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.habitats.references.ReferencesBean;
import ro.finsiel.eunis.search.habitats.references.ReferencesPaginator;
import ro.finsiel.eunis.utilities.TableColumns;


/**
 * TSV and XML report generation.
 */
public class TSVHabitatReferencesReport extends AbstractTSVReport
{
    /**
     * Form bean used for search.
     */
    private ReferencesBean formBean = null;

    /**
     * Constructor.
     * @param sessionID Session ID got from page
     * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
     */
    public TSVHabitatReferencesReport( String sessionID, AbstractFormBean formBean )
    {
        super( "HabitatReferencesReport_" + sessionID + ".tsv" );
        this.formBean = ( ReferencesBean ) formBean;
        this.filename = "HabitatReferencesReport_" + sessionID + ".tsv";
        xmlreport = new XMLReport( "HabitatReferencesReport_" + sessionID + ".xml" );
        if ( null != formBean )
        {
            Integer database = Utilities.checkedStringToInt( ( ( ReferencesBean ) formBean ).getDatabase(), HabitatsBooksDomain.SEARCH_EUNIS );
            dataFactory = new ReferencesPaginator( new HabitatsBooksDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), database ) );
            this.dataFactory.setSortCriteria( formBean.toSortCriteria() );
        }
        else
        {
            System.out.println( TSVHabitatReferencesReport.class.getName() + "::ctor() - Warning: formBean was null!" );
        }
    }

    /**
     * Create the table headers.
     *
     * @return An array with the columns headers of the table
     */
    public List<String> createHeader()
    {
        if ( null == formBean )
        {
            return new Vector<String>();
        }
        Vector<String> headers = new Vector<String>();
        // Author
        headers.addElement( "Author" );
        // Date
        headers.addElement( "Date" );
        // Title
        headers.addElement( "Title" );
        // Editor
        headers.addElement( "Editor" );
        // Publisher
        headers.addElement( "Publisher" );
        // Source
        headers.addElement( "Source" );
        // Habitats
        headers.addElement( "Habitat types" );


        return headers;
    }

    /**
     * Use this method to write specific data into the file. Implemented in inherited classes
     */
    public void writeData()
    {
        if ( null == dataFactory )
        {
            return;
        }
        dataFactory.setPageSize( RESULTS_PER_PAGE );
        try
        {
            int _pagesCount = dataFactory.countPages();
            if ( _pagesCount == 0 )
            {
                closeFile();
                return;
            }
            Integer database = Utilities.checkedStringToInt( formBean.getDatabase(), HabitatsBooksDomain.SEARCH_EUNIS );
            writeRow( createHeader() );
            xmlreport.writeRow( createHeader() );
            for ( int _currPage = 0; _currPage < _pagesCount; _currPage++ )
            {
                List resultSet = dataFactory.getPage( _currPage );
                for ( int i = 0; i < resultSet.size(); i++ )
                {
                    HabitatsBooksPersist book = ( HabitatsBooksPersist ) resultSet.get( i );

                    HabitatsBooksDomain habitatsBooks = new HabitatsBooksDomain( formBean.toSearchCriteria(), database );
                    List resultsHabitats = habitatsBooks.getHabitatsByReferences( book.getIdDC().toString(), true );
                    if ( resultsHabitats != null && resultsHabitats.size() > 0 )
                    {
                        for (int ii = 0; ii < resultsHabitats.size(); ii++) {
                            TableColumns tableColumns = ( TableColumns ) resultsHabitats.get(ii);
                            String habitatName = (String) tableColumns.getColumnsValues().get(0);

                            if( ii == 0 )
                            {
                                Vector<String> aRow = new Vector<String>();
                                // Author
                                aRow.addElement( Utilities.formatString( book.getSource() ) );
                                // Date
                                aRow.addElement( Utilities.formatReferencesDate( book.getCreated() ) );
                                // Title
                                aRow.addElement( Utilities.formatString( book.getTitle() ) );
                                // Editor
                                aRow.addElement( Utilities.formatString( book.getEditor() ) );
                                // Publisher
                                aRow.addElement( Utilities.formatString( book.getPublisher() ) );
                                // Source
                                aRow.addElement( Utilities.returnSourceValueReferences( book.getHaveSource() ) );
                                // Habitat types
                                aRow.addElement( habitatName );
                                writeRow( aRow );
                            }
                            else
                            {
                                Vector<String> aRow = new Vector<String>();
                                // Author
                                aRow.addElement( "" );
                                // Date
                                aRow.addElement( "" );
                                // Title
                                aRow.addElement( "" );
                                // Editor
                                aRow.addElement( "" );
                                // Publisher
                                aRow.addElement( "" );
                                // Source
                                aRow.addElement( "" );
                                // Habitat types
                                aRow.addElement( habitatName );
                                writeRow( aRow );
                            }
                        }
                    }
                    else
                    {
                        Vector<String> aRow = new Vector<String>();
                        // Author
                        aRow.addElement( Utilities.formatString( book.getSource() ) );
                        // Date
                        aRow.addElement( Utilities.formatReferencesDate( book.getCreated() ) );
                        // Title
                        aRow.addElement( Utilities.formatString( book.getTitle() ) );
                        // Editor
                        aRow.addElement( Utilities.formatString( book.getEditor() ) );
                        // Publisher
                        aRow.addElement( Utilities.formatString( book.getPublisher() ) );
                        // Source
                        aRow.addElement( Utilities.returnSourceValueReferences( book.getHaveSource() ) );
                        // Habitat types
                        aRow.addElement( "-" );
                        writeRow( aRow );
                    }

                    // XML report
                    Vector<String> aRow = new Vector<String>();
                    // Author
                    aRow.addElement( Utilities.formatString( book.getSource() ) );
                    // Date
                    aRow.addElement( Utilities.formatReferencesDate( book.getCreated() ) );
                    // Title
                    aRow.addElement( Utilities.formatString( book.getTitle() ) );
                    // Editor
                    aRow.addElement( Utilities.formatString( book.getEditor() ) );
                    // Publisher
                    aRow.addElement( Utilities.formatString( book.getPublisher() ) );
                    // Source
                    aRow.addElement( Utilities.returnSourceValueReferences( book.getHaveSource() ) );
                    // Habitat types
                    String habitats = "";
                    for (int ii = 0; ii < resultsHabitats.size(); ii++) {
                        TableColumns tableColumns = ( TableColumns ) resultsHabitats.get(ii);
                        habitats += "<habitat>" + tableColumns.getColumnsValues().get(0) + "</habitat>";
                    }
                    System.out.println( "habitats = " + habitats );
                    aRow.addElement( habitats );
                    xmlreport.writeRow( aRow );
                }
            }
        }
        catch ( CriteriaMissingException ex )
        {
            ex.printStackTrace();
        }
        catch ( InitializationException iex )
        {
            iex.printStackTrace();
        }
        catch ( IOException ioex )
        {
            ioex.printStackTrace();
        }
        catch ( Exception ex2 )
        {
            ex2.printStackTrace();
        }
        finally
        {
            closeFile();
        }
    }
}