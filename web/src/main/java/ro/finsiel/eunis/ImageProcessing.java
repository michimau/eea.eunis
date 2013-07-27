package ro.finsiel.eunis;


import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;

import javax.imageio.ImageIO;


/**
 * Class which provides image manipulation.
 * In order to use this class, you instantiate a new ImageProcessing object,
 * call its init, draw points inside image then call save(). Constructor takes
 * an image as an argument, drawing inside it.
 * This class works only with JPEG images (in and out).
 */
public final class ImageProcessing {
    private String outputFilename;
    private String inputFilename;
    private Graphics g;
    private BufferedImage img;

    /**
     * Constructs new ImageProcessing object.
     * @param inputFilename Input file name
     * @param outputFilename Name of output file.
     */
    public ImageProcessing(String inputFilename, String outputFilename) {
        this.inputFilename = inputFilename;
        this.outputFilename = outputFilename;
    }

    /**
     * Initialization method. Call this method before doing any processing to initialize
     * the JPEG codec.
     */
    public void init() {
        try {
            img = ImageIO.read(new FileInputStream(inputFilename));
            g = img.getGraphics();
            g.drawImage(img, 0, 0, null);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    /**
     * Save the image.
     */
    public void save() {
        try {
            File outputfile = new File(outputFilename);

            ImageIO.write(img, "jpg", outputfile);

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    /**
     * Draw a point. Is X,Y at the center of the point, or at a corner?
     * @param x X
     * @param y Y
     * @param color Color
     * @param dotRadius Dot size.
     */
    public void drawPoint(int x, int y, Color color, int dotRadius) {
        if (g != null) {
            g.setColor(color);
            g.fillOval(x + (dotRadius >> 1) - 1, y - (dotRadius >> 1), dotRadius, dotRadius);
            // g.fillRect(x-dotRadius/2, y-dotRadius/2, dotRadius, dotRadius);
        }
    }
}
