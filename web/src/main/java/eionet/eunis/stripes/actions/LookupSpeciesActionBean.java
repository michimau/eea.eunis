package eionet.eunis.stripes.actions;


import org.apache.commons.lang.StringUtils;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import eionet.eunis.api.LookupSpeciesResult;
import eionet.eunis.api.SpeciesLookupSearchParam;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.util.SimpleFrameworkUtils;


/**
 * API interface to allow species to be fuzzily looked up. 
 *
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
@UrlBinding("/api/lookup-species")
public class LookupSpeciesActionBean extends AbstractStripesAction {
	
    private static final int GENUS_AND_SPECIES_DISTANCE = 4;

    private static final int SEARCH_DISTANCE = 7;

    private String speciesName;
	
    private String author;

    @DefaultHandler
    public Resolution lookupSpecies() {
        if (StringUtils.isBlank(speciesName)) {
            return new ErrorResolution(404);
        }
        SpeciesLookupSearchParam searchParam = new SpeciesLookupSearchParam(StringUtils.lowerCase(speciesName),
                StringUtils.lowerCase(author));

        // if speciesName contains spaces. Will assume
        // that both genus and species parts are looked up.
        // so max distance is lowered
        searchParam.setMaxLevenshteinDistance(StringUtils.contains(speciesName, ' ') ? GENUS_AND_SPECIES_DISTANCE : SEARCH_DISTANCE);
        LookupSpeciesResult lookupSpecies = DaoFactory.getDaoFactory().getSpeciesDao().lookupSpecies(searchParam);

        return new StreamingResolution("text/xml", SimpleFrameworkUtils.convertToString(null, lookupSpecies, null));
    }
	
    public String getSpeciesName() {
        return speciesName;
    }

    public void setSpeciesName(String species) {
        this.speciesName = species;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

}
