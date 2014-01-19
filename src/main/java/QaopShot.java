import java.awt.Color;
import java.awt.Frame;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Hashtable;

import javax.imageio.ImageIO;

/**
 * 
 */

/**
 * @author Andrew Jackson <Andrew.Jackson@bl.uk>
 *
 */
public class QaopShot {

	/**
	 * Takes a screenshot of the emulator, after waiting a short while.
	 * 
	 * @param args
	 * @throws IOException 
	 */
	public static void main(String[] args) throws IOException {
		Frame f = new Frame("Qaop");
		Qaop q = new Qaop();
		
		Hashtable<String,String> p = new Hashtable<String, String>();
		for(int n=0; n<args.length; n++) {
			String a = args[n];
			if(a.matches("\\w+=.*")) {
				int i = a.indexOf('=');
				p.put(a.substring(0,i), a.substring(i+1));
			} else
				p.put("load", a);
		}
		Qaop.param = p;

		f.setBackground(new Color(0x222222));
		f.add(q);
		f.addWindowListener(q);
		f.addKeyListener(q);
		f.pack();
		q.init();
		f.setVisible(true);
		
		// Wait for three seconds:
		try {
			Thread.sleep(1000*2);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// Save out screenshot:
		int width = q.getWidth();
        int height = q.getHeight();
       
        BufferedImage bi = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics big = bi.getGraphics();
        q.paint(big);
		ImageIO.write(bi, "png",new File("specshot.png"));
		
		// Close:
		f.setVisible(false);
		f.dispose();
		System.exit(0);
	}

}
