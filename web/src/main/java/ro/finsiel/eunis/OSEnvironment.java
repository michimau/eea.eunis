package ro.finsiel.eunis;


import java.util.Properties;


/**
 * Access the environment variables of the Operating System.
 * @author finsiel
 */
public class OSEnvironment {

    /**
     * Retrieve the environment variables.
     * @return Properties object with variable values mapped to variable names.
     * @throws Exception Exception if variables could not be retrieved.
     */
    public static Properties getEnvVars() throws Exception {
        // Process p = null;
        Properties envVars = new Properties();

        envVars.put("TOMCAT_HOME", Settings.getSetting("TOMCAT_HOME"));
        envVars.put("INSTANCE_HOME", Settings.getSetting("INSTANCE_HOME"));
        // Runtime r = Runtime.getRuntime();
        // String OS = System.getProperty("os.name").toLowerCase();
        // System.out.println(OS);

        // if (OS.indexOf("windows 9") > -1) {
        // p = r.exec("command.com /c set");
        // } else {
        // if ((OS.indexOf("nt") > -1) || (OS.indexOf("windows 2000") > -1 || (OS.indexOf("windows xp") > -1))) {
        // p = r.exec("cmd.exe /c set");
        // } else {
        // p = r.exec("env");
        // }
        // }

        // BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
        // String line;
        //
        // line = br.readLine();
        // while (line != null && line.length() > 0) {
        // int idx = line.indexOf('=');
        // String key = line.substring(0, idx);
        // String value = line.substring(idx + 1);
        // //      System.out.println("key = " + key);
        // //      System.out.println("value = " + value);
        // envVars.setProperty(key, value);
        // line = br.readLine();
        // }

        return envVars;
    }
}
