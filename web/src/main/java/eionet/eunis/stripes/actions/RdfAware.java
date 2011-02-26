package eionet.eunis.stripes.actions;


import net.sourceforge.stripes.action.Resolution;


/**
 * Interface to mark that ActionBean is able to generate RDF.
 *
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public interface RdfAware {

    public static final String RDF_GENERATING_METHOD = "generateRdf";

    /**
     * generates RDF.
     * @return
     */
    Resolution generateRdf();

}
