package ro.finsiel.eunis.session;

import java.io.Serializable;

/**
 * Manage the themes (colors and visual items) from web pages.
 * @author finsiel
 */
public class ThemeManager implements Serializable {
  /**
   * Define theme.
   */
  public static final int THEME_SKY_BLUE = 0;
  /**
   * Define theme.
   */
  public static final int THEME_FRESH_ORANGE = 1;
  /**
   * Define theme.
   */
  public static final int THEME_NATURE_GREEN = 2;
  /**
   * Define theme.
   */
  public static final int THEME_CHERRY = 3;

  /**
   * Define theme.
   */
  public static final int THEME_BLACKWHITE = 4;

  /**
   * Define blue theme.
   */
  public static final ThemeWrapper SKY_BLUE = new ThemeWrapper( "#006CAD", "#6DABD0", "#B8D6E8", "banner_blue.jpg", "#E4F4F4" );
  /**
   * Define orange theme.
   */
  public static final ThemeWrapper FRESH_ORANGE = new ThemeWrapper( "#DC6E02", "#DC8202", "#FFD790", "banner_orange.jpg", "#FFECCB" );
  /**
   * Define green theme.
   */
  public static final ThemeWrapper NATURE_GREEN = new ThemeWrapper( "#066028", "#378253", "#7CD4A9", "banner_green.jpg", "#C8FFE4" );
  /**
   * Define cherry theme.
   */
  public static final ThemeWrapper CHERRY = new ThemeWrapper( "#7F0016", "#AA3247", "#E593AB", "banner_cherry.jpg", "#FFE4EC" );

  /**
   * Define high contrast theme.
   */
  public static final ThemeWrapper BLACKWHITE = new ThemeWrapper( "#000000", "#000000", "#000000", "banner_blue.jpg", "#FFFFFF" );

  private SessionManager sessionManager = null;
  private ThemeWrapper currentTheme = null;

  /**
   * Construct an new object.
   * @param sessionManager Session for which this object is created.
   */
  public ThemeManager( final SessionManager sessionManager) {
    this.sessionManager = sessionManager;
  }

  /**
   * Getter for headerImage.
   * @return Return the image appearing in top of web pages.
   */
  public String getHeaderImageName() {
    return currentTheme.getHeaderImageName();
  }

  /**
   * Retrieve the dark shade color.
   * @return An HTML compliant color (#RRGGBB).
   */
  public String getDarkColor() {
    return currentTheme.getDarkColor();
  }

  /**
   * Retrieve the medium shade color.
   * @return An HTML compliant color (#RRGGBB).
   */
  public String getMediumColor() {
    return currentTheme.getMediumColor();
  }

  /**
   * Retrieve the light shade color.
   * @return An HTML compliant color (#RRGGBB).
   */
  public String getLightColor() {
    return currentTheme.getLightColor();
  }

  public String getInputFieldColor() {
    return currentTheme.getInputFieldColor();
  }

  public ThemeWrapper getCurrentTheme()
  {
    return currentTheme;
  }


  /**
   * Change currently used theme in web page.
   * @param themeIndex Name of the theme (one of the public static int fields of this class).
   */
  public void switchTheme( final int themeIndex)
  {
    switch (themeIndex)
    {
      case THEME_SKY_BLUE:
        currentTheme = SKY_BLUE;
        sessionManager.getUserPrefs().setThemeIndex(new Integer(THEME_SKY_BLUE));
        break;
      case THEME_FRESH_ORANGE:
        currentTheme = FRESH_ORANGE;
        sessionManager.getUserPrefs().setThemeIndex(new Integer(THEME_FRESH_ORANGE));
        break;
      case THEME_NATURE_GREEN:
        currentTheme = NATURE_GREEN;
        sessionManager.getUserPrefs().setThemeIndex(new Integer(THEME_NATURE_GREEN));
        break;
      case THEME_CHERRY:
        currentTheme = CHERRY;
        sessionManager.getUserPrefs().setThemeIndex(new Integer(THEME_CHERRY));
        break;
      case THEME_BLACKWHITE:
        currentTheme = BLACKWHITE;
        sessionManager.getUserPrefs().setThemeIndex(new Integer(THEME_BLACKWHITE));
        break;
      default:
        currentTheme = SKY_BLUE;
    }
    sessionManager.saveUserPreferences();
  }
}