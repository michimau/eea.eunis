package ro.finsiel.eunis.dataimport.legal;

import ro.finsiel.eunis.utilities.SQLUtilities;
import ro.finsiel.eunis.utilities.TableColumns;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Main class for importer
 */
public class VertebratesImporter {

    private ExcelReader excelReader;
    private SQLUtilities sqlUtilities;

    public static void main(String[] args){

        ResourceBundle props = ResourceBundle.getBundle("jrf");
        String dbDriver = props.getString("mysql.driver");
        String dbUrl = props.getString("mysql.url");
        String dbUser = props.getString("mysql.user");
        String dbPass = props.getString("mysql.password");

        SQLUtilities sqlUtilities = new SQLUtilities();

        sqlUtilities.Init(dbDriver, dbUrl, dbUser, dbPass);

        VertebratesImporter vi = new VertebratesImporter();
        vi.importExcelFile("C:\\eunis\\20140415 Vertebrates with whole red list.xlsx", sqlUtilities);
    }



    public void importExcelFile(String excelFile, SQLUtilities sqlUtilities){
        this.sqlUtilities = sqlUtilities;
        try {
            excelReader = new ExcelReader(excelFile);
            System.out.println("File read, found " + excelReader.getSpeciesRows().size() + " species and " + excelReader.getRestrictionsRows().size() + " restrictions");
            notFoundCount = 0;
            importAllSpecies();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void importAllSpecies(){
        for(SpeciesRow sr : excelReader.getSpeciesRows()){
            if(sr.getSpeciesName().equals("Canis lupus"))
                importSpecies(sr);
        }
    }

    private int notFoundCount;
    private void importSpecies(SpeciesRow speciesRow){
        identifySpecies(speciesRow);

        if(speciesRow.getIdSpecies() == null) {
            notFoundCount++;
            System.out.println("WARNING: Species '" + speciesRow.getSpeciesName() + "' not found! (" + notFoundCount + " not found)");
        } else {
            cleanExistingData(speciesRow);
            importNewData(speciesRow);
        }
    }

    private void identifySpecies(SpeciesRow speciesRow){
        String idLink = null;

        List speciesList = sqlUtilities.ExecuteSQLReturnList("select id_species, id_nature_object, valid_name, id_species_link from chm62edt_species where scientific_name='"+ speciesRow.getSpeciesName() + "'", 4);

        idLink = populateSpeciesIds(speciesRow, speciesList);

        if(speciesRow.getIdSpecies() == null && idLink != null) {
            // extract the parent species
            List speciesFullList = sqlUtilities.ExecuteSQLReturnList("select id_species, id_nature_object, valid_name, id_species_link from chm62edt_species where id_species='"+ idLink + "'", 4);
            populateSpeciesIds(speciesRow, speciesFullList);
        }
    }

    private String populateSpeciesIds(SpeciesRow speciesRow, List queryResults){
        String idLink = null;

        for(Object o : queryResults){
            TableColumns l2 = (TableColumns)o;

            if(l2.getColumnsValues().get(2).toString().equals("1")){
                // is valid name
                speciesRow.setIdSpecies(l2.getColumnsValues().get(0).toString());
                speciesRow.setIdNatureObject(l2.getColumnsValues().get(1).toString());
            } else {
                // extract the valid species link
                idLink = l2.getColumnsValues().get(3).toString();
            }
        }
        return idLink;
    }

    private void cleanExistingData(SpeciesRow speciesRow){
        // todo deletes
        System.out.println("Cleaning the species '" + speciesRow.getSpeciesName() + "' (id_species=" + speciesRow.getIdSpecies() + ", id_nature_object=" + speciesRow.getIdNatureObject() + ")");
        // delete from
        System.out.println("");
    }

    private void importNewData(SpeciesRow speciesRow){
        // todo inserts
    }


}
