package eionet.eunis.util;

import org.displaytag.decorator.TableDecorator;

import ro.finsiel.eunis.utilities.EunisUtil;

import eionet.eunis.dto.DcTitleDTO;


/**
 * 
 * @author altnyris
 *
 */
public class DocumentsTableDecorator extends TableDecorator{
	
	/**
	 * 
	 * @return
	 */
	public String getDocTitle(){
		
		StringBuilder ret = new StringBuilder();
		DcTitleDTO doc = (DcTitleDTO) getCurrentRowObject();
		ret.append("<a href='documents/").append(doc.getIdDoc()).append("'>");
		if(doc.getTitle() != null && !doc.getTitle().equals(""))
			ret.append(EunisUtil.replaceTags(doc.getTitle()));
		ret.append("</a>");
		
		return ret.toString();
	}
	
	

}
