package ro.finsiel.eunis.dataimport;


import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

import ro.finsiel.eunis.dataimport.parsers.Natura2000ImportParser;
import ro.finsiel.eunis.utilities.SQLUtilities;


public class Natura2000Importer {

    /**
     * @param args
     */
    public static void main(String[] args) {

        try {
            if (args.length == 0) {
                System.out.println("Missing folderName!");
                System.out.println(
                        "Usage: ro.finsiel.eunis.dataimport.Natura2000Importer {folderName}");
            } else {
                File directory = new File(args[0]);
                File files[] = directory.listFiles();

                FileInputStream fis = null;
                BufferedInputStream bis = null;

                ResourceBundle props = ResourceBundle.getBundle("jrf");
                String dbDriver = props.getString("mysql.driver");
                String dbUrl = props.getString("mysql.url");
                String dbUser = props.getString("mysql.user");
                String dbPass = props.getString("mysql.password");

                SQLUtilities sqlUtilities = new SQLUtilities();

                sqlUtilities.Init(dbDriver, dbUrl, dbUser, dbPass);

                List<String> errors = new ArrayList<String>();
                int cnt = 1;

                for (File f : files) {
                    Natura2000ImportParser parser = new Natura2000ImportParser(
                            sqlUtilities);

                    fis = new FileInputStream(f);
                    bis = new BufferedInputStream(fis);

                    System.out.print(cnt + ". Importing file: " + f.getName());
                    List<String> file_errors = parser.execute(bis);

                    if (file_errors != null && file_errors.size() > 0) {
                        System.out.println(" - import failed.");
                        errors.addAll(file_errors);
                    } else {
                        System.out.println();
                    }

                    cnt++;
                    fis.close();
                    bis.close();
                }
                if (errors != null && errors.size() > 0) {
                    System.out.println("Error(s) occured during import:");
                    for (String error : errors) {
                        System.out.println(error);
                    }
                } else {
                    System.out.println("Successfully imported!");
                }
            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
