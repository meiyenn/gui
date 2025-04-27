/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.time.LocalDate;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;
import model.ProductDa;

/**
 *
 * @author Mei Yen
 */
@WebServlet(name = "ReportServlet", urlPatterns = {"/ReportServlet"})
public class ReportServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
        
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            if (startDate == null || endDate == null || startDate.isEmpty() || endDate.isEmpty()) {
                response.sendRedirect("ReportServlet"); // redirect to default
            }

            String startDateTime = startDate + " 00:00:00.000";
            String endDateTime = endDate + " 23:59:59.999";

            ProductDa pda = new ProductDa();
            ResultSet rs_salesRecord = pda.salesRecord(startDateTime, endDateTime);

            HttpSession session = request.getSession();
            session.setAttribute("rs_salesRecord", rs_salesRecord);
            session.setAttribute("startDate", startDate);
            session.setAttribute("endDate", endDate);

            response.sendRedirect("salesReport.jsp"); 
            
        }catch(Exception ex){
            out.println("ERROR: " + ex.getMessage());
            ex.printStackTrace();
        }
    }
    
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
        //default show yearly report
        LocalDate now = LocalDate.now();
        String startDate = now.getYear() + "-01-01";
        String endDate = now.getYear() + "-12-31";

        //manually add the time - 00:00 / 23:59
        String startDateTime = startDate + " 00:00:00.000";
        String endDateTime = endDate + " 23:59:59.999";

        ProductDa pda = new ProductDa();
        ResultSet rs_salesRecord = pda.salesRecord(startDateTime, endDateTime);

        //perform query report action
        HttpSession session = request.getSession();
        session.setAttribute("rs_salesRecord", rs_salesRecord);
        session.setAttribute("startDate", startDate);
        session.setAttribute("endDate", endDate);

        response.sendRedirect("salesReport.jsp"); 
}

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
