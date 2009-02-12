package ro.finsiel.eunis.dataimport;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import ro.finsiel.eunis.session.SessionManager;
import ro.finsiel.eunis.utilities.SQLUtilities;

public class DataExporter extends HttpServlet {
	
	private static List<String> errors = null;
	
	/**	
	* Overrides public method doPost of javax.servlet.http.HttpServlet.
	* @param request Request object
	* @param response Response object.
	*/
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		HttpSession session = request.getSession(false);
		SessionManager sessionManager = (SessionManager) session.getAttribute("SessionManager");
		if (sessionManager.isAuthenticated() && sessionManager.isImportExportData_RIGHT()) {
			errors = new ArrayList<String>();
		
			String SQL_DRV = request.getSession().getServletContext().getInitParameter("JDBC_DRV");
			String SQL_URL = request.getSession().getServletContext().getInitParameter("JDBC_URL");
	        String SQL_USR = request.getSession().getServletContext().getInitParameter("JDBC_USR");
	        String SQL_PWD = request.getSession().getServletContext().getInitParameter("JDBC_PWD");
	        
			String table = request.getParameter("table");
			String nl = "\n";
			
			try {
		    
				SQLUtilities sql = new SQLUtilities();
				sql.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
				String content = sql.getTableContentAsXML(table);
				
				StringBuilder s = new StringBuilder();
				s.append("<?xml version=\"1.0\"?>").append(nl);
				s.append("<ROWSET>").append(nl);
				s.append(content);
				s.append("</ROWSET>").append(nl);
				
				response.setContentType("application/xml;charset=UTF-8"); 
				response.setHeader("Content-Disposition", "attachment; filename="+table+".xml");
			    response.getWriter().write(s.toString());
				
			} catch(Exception e){
				e.printStackTrace();
				errors.add(e.getMessage());
			}
		} else {
			response.sendRedirect("dataimport/data-exporter.jsp");
		}
	}
	
}
