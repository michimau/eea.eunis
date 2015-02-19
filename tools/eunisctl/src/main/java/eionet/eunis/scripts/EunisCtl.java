package eionet.eunis.scripts;

import java.util.Arrays;

public class EunisCtl {

    private static void usage(String msg) {
        System.err.println("Error: " + msg);
        System.err.println("Usage: DBTool deletesites|deletespecies");
        System.exit(2);
    }

    public static void main(String[] args) throws Exception {

        if (args.length == 0) {
            usage("No subcommand argument");
        }
        String subCommand = args[0];
        String[] extraArgs = Arrays.copyOfRange(args, 1, args.length);

        if ("deletesites".equals(subCommand)) {
            DeleteSites.main(extraArgs);
        } else if ("deletespecies".equals(subCommand)) {
            //CSVExport.main(extraArgs);
        } else {
            usage("Unknown subcommand: " + subCommand);
        }
    }
}
