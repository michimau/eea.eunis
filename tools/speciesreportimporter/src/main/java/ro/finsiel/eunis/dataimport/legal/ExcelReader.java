package ro.finsiel.eunis.dataimport.legal;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

/**
 * Reads an Excel file and parses the content into objects
 */
public class ExcelReader {

    private List<SpeciesRow> speciesRows;
    private List<RestrictionsRow> restrictionsRows;

    /**
     * The file type, identified by the column A1
     */
    public static enum FileType { VERTEBRATES, UNKNOWN, INVERTEBRATES }

    private FileType fileType = FileType.UNKNOWN ;

    /**
     * Reads an Excel file
     * @param filename The file name (and path)
     * @throws IOException
     */
    public ExcelReader(String filename) throws IOException {

        speciesRows = new ArrayList<SpeciesRow>();
        restrictionsRows = new ArrayList<RestrictionsRow>();

        FileInputStream file = new FileInputStream(new File(filename));

        XSSFWorkbook workbook = new XSSFWorkbook (file);

        // Species sheet
        XSSFSheet sheet = workbook.getSheetAt(0);

        Iterator<Row> rowIterator = sheet.iterator();

        ExcelRowFactory erf = new ExcelRowFactory();

        String type = sheet.getRow(0).getCell(0).getStringCellValue();
        if(type.equalsIgnoreCase("VERTEBRATES")){
            fileType = FileType.VERTEBRATES;
        } else if(type.equalsIgnoreCase("INVERTEBRATES")){
            fileType = FileType.INVERTEBRATES;
        } else {
            System.out.println("Unknown file type '" + type + "'! Please fill the cell A1 with 'Vertebrates' or 'Invertebrates'");
            return;
        }

        while(rowIterator.hasNext()) {
            Row row = rowIterator.next();
            SpeciesRow sr;

            if(fileType == FileType.VERTEBRATES){
                sr = erf.getVertebratesRow(row);
            } else {
                sr = erf.getInvertebratesRow(row);
            }

            if(sr != null && sr.isSpecies()) {
//                System.out.println(sr);
                speciesRows.add(sr);
            }
        }

        // Geographic sheet

        if(fileType == FileType.VERTEBRATES){
            sheet = workbook.getSheetAt(2);
        } else {
            sheet = workbook.getSheetAt(1);
        }

        rowIterator = sheet.iterator();

        while(rowIterator.hasNext()) {
            Row row = rowIterator.next();
            RestrictionsRow restrictionsRow = erf.getRestrictionsRow(row);

            if(restrictionsRow != null) {
//                System.out.println(restrictionsRow);
                restrictionsRows.add(restrictionsRow);
            }
        }

        populateRestrictions();
        file.close();
    }

    /**
     * Populate the restriction maps of the species with the data read from the Geographic and other Restrictions tab
     * Also populates the priority data (Habitats "Priority in Annex II")
     */
    private void populateRestrictions(){


        for(SpeciesRow sr : speciesRows){
            for(RestrictionsRow r : restrictionsRows){
                if(sr.getSpeciesName().equalsIgnoreCase(r.getSpecies())){
                    sr.getRestrictionsMap().put(r.getLegalText(), r);
                }
            }

            // "priority in II" for habitats
            if(!sr.getHabitatsIIPriority().isEmpty()){
                RestrictionsRow rr = sr.getRestrictionsMap().get("HD II");
                if(rr == null) {
                    rr = new RestrictionsRow();
                    sr.getRestrictionsMap().put("HD II", rr);
                }
                rr.setPriority(1);
            }
        }

    }

    /**
     * Returns the list of species
     * @return
     */
    public List<SpeciesRow> getSpeciesRows() {
        return speciesRows;
    }

    /**
     * Returns the list of restrictions
     * @return
     */
    public List<RestrictionsRow> getRestrictionsRows() {
        return restrictionsRows;
    }
}
