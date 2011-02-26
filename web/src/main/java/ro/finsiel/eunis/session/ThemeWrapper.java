package ro.finsiel.eunis.session;


/**
 * - Author(s)   : The EUNIS Database Team.
 * - Date        :
 * - Copyright   : (c) 2005 EEA - European Environment Agency.
 * - Description : TODO.
 * - Input params : -
 */

/**
 * Wrapper around pre-defined themes.
 * @author finsiel
 */
public class ThemeWrapper implements java.io.Serializable {
    private String headerImageName = "";
    private String darkColor = "";
    private String mediumColor = "";
    private String lightColor = "";
    private String inputFieldColor = "";

    /**
     * Constructor for this theme.
     * @param darkColor Dark shade.
     * @param mediumColor Medium shade.
     * @param lightColor Light shade.
     * @param headerImageName Header image (filename).
     * @param inputFieldColor Color for input field
     */
    public ThemeWrapper(final String darkColor, final String mediumColor, final String lightColor, final String headerImageName, final String inputFieldColor) {
        this.darkColor = darkColor;
        this.mediumColor = mediumColor;
        this.lightColor = lightColor;
        this.headerImageName = headerImageName;
        this.inputFieldColor = inputFieldColor;
    }

    /**
     * Getter for header image filename.
     * @return filename.
     */
    public String getHeaderImageName() {
        return headerImageName;
    }

    /**
     * Getter for dark shade color.
     * @return An HTML compliant color (#RRGGBB).
     */
    public String getDarkColor() {
        return darkColor;
    }

    /**
     * Getter for medium shade color.
     * @return An HTML compliant color (#RRGGBB).
     */
    public String getMediumColor() {
        return mediumColor;
    }

    /**
     * Getter for light shade color.
     * @return An HTML compliant color (#RRGGBB).
     */
    public String getLightColor() {
        return lightColor;
    }

    /**
     * Gette for INPUT text field form element
     * @return color for text elements
     */
    public String getInputFieldColor() {
        return inputFieldColor;
    }

    public String toString() {
        return "dark=" + darkColor + ", medium=" + mediumColor + ", light="
                + lightColor + ",input=" + inputFieldColor;
    }

    public boolean equals(final Object other) {
        boolean ret = false;

        if (other instanceof ThemeWrapper) {
            if (this.getDarkColor().equalsIgnoreCase(
                    ((ThemeWrapper) other).getDarkColor())
                            && this.getMediumColor().equalsIgnoreCase(
                                    ((ThemeWrapper) other).getMediumColor())
                                    && this.getLightColor().equalsIgnoreCase(
                                            ((ThemeWrapper) other).getLightColor())
                                            && this.getHeaderImageName().equalsIgnoreCase(
                                                    ((ThemeWrapper) other).getHeaderImageName())) {
                ret = true;
            }
        }
        return ret;
    }
}
