package ro.finsiel.eunis.dataimport.legal;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellReference;

/**
 * Factory for Excel objects
 */
public class ExcelRowFactory {

    public SpeciesRow getSpeciesRow(Row row){
        if(row.getLastCellNum()<29){
            return null;
        }

        SpeciesRow r = new SpeciesRow();
        r.setSpeciesName(getCellValue(row, "A"));
        r.setHabitatsD(getCellValue(row, "B"));
        r.setHabitatsIIPriority(getCellValue(row, "C"));
        r.setHabitatsRestrictions(getCellValue(row, "D"));
        r.setHabitatsName(getCellValue(row, "E"));
        r.setBirdsD(getCellValue(row, "F"));
        r.setBirdsName(getCellValue(row, "G"));
        r.setBernConvention(getCellValue(row, "H"));
        r.setBernRestrictions(getCellValue(row, "I"));
        r.setBernName(getCellValue(row, "J"));
        r.setEmeraldR6(getCellValue(row, "K"));
        r.setEmeraldRestrictions(getCellValue(row, "L"));
        r.setEmeraldName(getCellValue(row, "M"));
        r.setBonnConvention(getCellValue(row, "N"));
        r.setBonnRestrictions(getCellValue(row, "O"));
        r.setBonnName(getCellValue(row, "P"));
        r.setCites(getCellValue(row, "Q"));
        r.setEuTrade(getCellValue(row, "R"));
        r.setAewa(getCellValue(row, "S"));
        r.setEurobats(getCellValue(row, "T"));
        r.setAccobams(getCellValue(row, "U"));
        r.setAscobams(getCellValue(row, "V"));
        r.setWadden(getCellValue(row, "W"));
        r.setSpa(getCellValue(row, "X"));
        r.setOspar(getCellValue(row, "Y"));
        r.setHelcom(getCellValue(row, "Z"));
        r.setRedList(getCellValue(row, "AA"));
        r.setRedListName(getCellValue(row, "AB"));

        return r;
    }

    public RestrictionsRow getRestrictionsRow(Row row){
        if(row.getLastCellNum()<3){
            return null;
        }
        RestrictionsRow r = new RestrictionsRow();
        r.setSpecies(getCellValue(row, "A"));
        r.setLegalText(getCellValue(row, "B"));
        r.setRestriction(getCellValue(row, "C"));

        if(r.getLegalText().isEmpty() || r.getLegalText().contains("Legal text"))
            return null;

        return r;
    }

    private String getCellValue(Row row, String column){
        Cell c = row.getCell(CellReference.convertColStringToIndex(column));
        if(c!=null){
            String s = c.getStringCellValue();
            if(s == null) {
                s = "";
            }
            s = s.trim();
            return s;
        } else {
            return "";
        }
    }

}
