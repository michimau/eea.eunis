package ro.finsiel.eunis.dataimport;


import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

import ro.finsiel.eunis.dataimport.parsers.CallbackSAXParser;
import ro.finsiel.eunis.dataimport.parsers.Natura2000ImportParser;
import ro.finsiel.eunis.dataimport.parsers.Natura2000ParserCallbackV2;
import ro.finsiel.eunis.utilities.SQLUtilities;


public class Natura2000Importer {

    /**
     * @param args
     */
    public static void main(String[] args) {

        try {
            if (args.length == 0) {
                System.out.println("Missing folderName!");
                System.out.println("Usage: ro.finsiel.eunis.dataimport.Natura2000Importer {folderName}");
            } else {
                File directory = new File(args[0]);

                if(!directory.exists()) {
                    System.out.println("The folder " + directory.getAbsolutePath() + " could not be found");
                    return;
                }

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

                List<Exception> errors = new ArrayList<Exception>();
                int cnt = 1;

                for (File f : files) {
                    fis = new FileInputStream(f);
                    bis = new BufferedInputStream(fis);

                    System.out.print(cnt + ". Importing file: " + f.getName());

                    try{
                        Natura2000ParserCallbackV2 callback = new Natura2000ParserCallbackV2(sqlUtilities);
                        CallbackSAXParser parser = new CallbackSAXParser(callback);
                        parser.setDebug(false);
                        List<Exception> file_errors = parser.execute(bis);
                        for(Exception e : errors) e.printStackTrace();
                        bis.close();

                        if (file_errors != null && file_errors.size() > 0) {
                            System.out.println(" - import failed.");
                            errors.addAll(file_errors);
                        } else {
                            System.out.println();
                        }
                    } catch (Exception e){
                        e.printStackTrace();
                    }

                    cnt++;
                    bis.close();
                }
                if (errors != null && errors.size() > 0) {
                    System.out.println("Error(s) occured during import:");
                    for (Exception error : errors) {
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
