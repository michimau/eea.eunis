package ro.finsiel.eunis.search.sites;

import junit.framework.Assert;
import org.junit.Test;
import ro.finsiel.eunis.jrfTables.sites.coordinates.CoordinatesPersist;

/**
 * Test for SitesSearchUtility
 */
public class SitesSearchUtilityTest {

    @Test
    public void testFormatLatitude(){
        Assert.assertEquals("-10.23200", SitesSearchUtility.formatLatitude("-10.23200"));
        Assert.assertEquals("10.232", SitesSearchUtility.formatLatitude("10.232"));
    }

    @Test
    public void testFormatLongitude(){
        Assert.assertEquals("-10.23200", SitesSearchUtility.formatLongitude("-10.23200"));
        Assert.assertEquals("10.232", SitesSearchUtility.formatLongitude("10.232"));
    }

    @Test
    public void testGetCoordinateForSite(){
        CoordinatesPersist site = new CoordinatesPersist();
        site.setLongitude("-3.927272000");
        site.setLatitude("55.716221400");
        String result = SitesSearchUtility.getCoordinateForSite(site);
        Assert.assertEquals("-3.92:55.71", result);
    }

    @Test
    public void testFormatPDFLatitude(){
        Assert.assertEquals("-10.23200", SitesSearchUtility.formatPDFLatitude("-10.23200"));
        Assert.assertEquals("10.232", SitesSearchUtility.formatPDFLatitude("10.232"));
    }

    @Test
    public void testFormatPDFLongitude(){
        Assert.assertEquals("-10.23200", SitesSearchUtility.formatPDFLongitude("-10.23200"));
        Assert.assertEquals("10.232", SitesSearchUtility.formatPDFLongitude("10.232"));
    }

}
