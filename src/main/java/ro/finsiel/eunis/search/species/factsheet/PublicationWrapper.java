package ro.finsiel.eunis.search.species.factsheet;

/**
 * This class encapsulates the publication information used to define
 * a book which contains references to a species.
 * @author finsiel
 */
public class PublicationWrapper {
  private String title = "";
  private String author = "";
  private String publisher = "";
  private String date = "";
  private String url = "";

  /**
   * Getter for title property.
   * @return title.
   */
  public String getTitle() {
    if (null == title) return "";
    return title;
  }

  /**
   * Setter for title of the book.
   * @param title Book title
   */
  public void setTitle(String title) {
    this.title = title;
  }

  /**
   * Getter for author property.
   * @return author.
   */
  public String getAuthor() {
    if (null == author) return "";
    return author;
  }

  /**
   * Setter for author of the book.
   * @param author Book author
   */
  public void setAuthor(String author) {
    this.author = author;
  }

  /**
   * Getter for publisher property.
   * @return publisher.
   */
  public String getPublisher() {
    if (null == publisher) return "";
    return publisher;
  }

  /**
   * Setter for book publisher.
   * @param publisher Book publisher
   */
  public void setPublisher(String publisher) {
    this.publisher = publisher;
  }


  /**
   * Getter for date property (Publication date).
   * @return date.
   */
  public String getDate() {
    if (null == date) return "";
    return date;
  }

  /**
   * Setter for publication's date.
   * @param date Published date
   */
  public void setDate(String date) {
    this.date = date;
  }

  /**
   * Getter for url property.
   * @return url.
   */
  public String getURL() {
    if (null == url) return "";
    return url;
  }

  /**
   * Setter for url property.
   * @param url url.
   */
  public void setURL(String url) {
    this.url = url;
  }
}