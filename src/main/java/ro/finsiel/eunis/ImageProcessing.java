package ro.finsiel.eunis;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageDecoder;
import com.sun.image.codec.jpeg.JPEGImageEncoder;
import com.sun.image.codec.jpeg.JPEGEncodeParam;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.FileInputStream;
import java.io.FileOutputStream;

/**
 * Class which provides image nanipulation.
 * In order to use this class, you instantiate a new ImageProcessing object,
 * call it's init, draw points inside image then call save(). Constructor takes
 * an image as an argument, drawing inside it.
 * This class works only with JPEG images (in and out).
 */
public final class ImageProcessing
{
  private String outputFilename;
  private String inputFilename;
  private Graphics g;
  private BufferedImage img;

  /**
   * Constructs new ImageProcessing object
   * @param inputFilename Input
   * @param outputFilename
   */
  public ImageProcessing( String inputFilename, String outputFilename )
  {
    this.inputFilename = inputFilename;
    this.outputFilename = outputFilename;
  }

  /**
   * Initialization method. Call this method before doing any processing to initialize
   * the JPEG codec.
   */
  public void init()
  {
    try
    {
      JPEGImageDecoder img_europe;
      img_europe = JPEGCodec.createJPEGDecoder( new FileInputStream( inputFilename ) );
      if ( img_europe != null )
      {
        img = img_europe.decodeAsBufferedImage();
        g = img.getGraphics();
        g.drawImage( img, 0, 0, null );
      }
    }
    catch( Exception ex )
    {
      ex.printStackTrace();
    }
  }

  /**
   * Save the image
   */
  public void save()
  {
    try
    {
      JPEGImageEncoder img_out = JPEGCodec.createJPEGEncoder( new FileOutputStream(outputFilename));
      JPEGEncodeParam param = img_out.getDefaultJPEGEncodeParam(img);
      param.setQuality(0.8f,true);
      img_out.setJPEGEncodeParam(param);
      img_out.encode( img );
    }
    catch( Exception ex )
    {
      ex.printStackTrace();
    }
  }

  /**
   * Draw an point
   * @param x X
   * @param y Y
   * @param color Color
   * @param dot_radius Dot size.
   */
  public void drawPoint( int x, int y, Color color, int dot_radius)
  {
    if( g != null )
    {
      g.setColor( color );
      g.fillOval( x + ( dot_radius >> 1 ) - 1, y - ( dot_radius >> 1 ), dot_radius, dot_radius );
      //g.fillRect(x-dot_radius/2,y-dot_radius/2,dot_radius,dot_radius);
    }
  }
}
