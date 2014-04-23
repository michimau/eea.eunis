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


public class ExcelReader {

    private List<SpeciesRow> speciesRows;
    private List<RestrictionsRow> restrictionsRows;
    private HashMap<String, RestrictionsRow> goRowMap;

    public ExcelReader(String filename) throws IOException {

        speciesRows = new ArrayList<SpeciesRow>();
        restrictionsRows = new ArrayList<RestrictionsRow>();

        FileInputStream file = new FileInputStream(new File(filename));

        XSSFWorkbook workbook = new XSSFWorkbook (file);

        // Species sheet
        XSSFSheet sheet = workbook.getSheetAt(0);

        Iterator<Row> rowIterator = sheet.iterator();

        ExcelRowFactory erf = new ExcelRowFactory();

        while(rowIterator.hasNext()) {
            Row row = rowIterator.next();
            SpeciesRow sr = erf.getSpeciesRow(row);

            if(sr != null && sr.isSpecies()) {
//                System.out.println(sr);
                speciesRows.add(sr);
            }
        }

        // Geographic sheet
        sheet = workbook.getSheetAt(2);
        rowIterator = sheet.iterator();

        while(rowIterator.hasNext()) {
            Row row = rowIterator.next();
            RestrictionsRow restrictionsRow = erf.getRestrictionsRow(row);

            if(restrictionsRow != null) {
//                System.out.println(restrictionsRow);
                restrictionsRows.add(restrictionsRow);
            }
        }

        buildGoRowMap();
        file.close();
    }

    private void buildGoRowMap(){
        goRowMap = new HashMap<String, RestrictionsRow>();
        for(RestrictionsRow restrictionsRow : restrictionsRows){
            goRowMap.put(restrictionsRow.getSpecies() + "|" + restrictionsRow.getLegalText(), restrictionsRow);
        }
    }

    public List<SpeciesRow> getSpeciesRows() {
        return speciesRows;
    }

    public List<RestrictionsRow> getRestrictionsRows() {
        return restrictionsRows;
    }

    public HashMap<String, RestrictionsRow> getGoRowMap() {
        return goRowMap;
    }
}
