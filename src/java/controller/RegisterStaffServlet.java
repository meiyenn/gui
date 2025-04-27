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
import model.StaffDA;
import model.Staff;

/**
 *
 * @author Huay
 */
@WebServlet(name = "RegisterStaffServlet", urlPatterns = {"/RegisterStaffServlet"})
public class RegisterStaffServlet extends HttpServlet {

    private StaffDA stfDA;

    @Override
    public void init() throws ServletException {
        stfDA = new StaffDA();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String lastId = stfDA.getLastStaffId();
        String stfId = stfDA.generateNextStaffId(lastId);

        String stfName = request.getParameter("stfName");
        String stfEmail = request.getParameter("stfEmail");
        String stfContactNo = request.getParameter("stfContactNo");
        String stfPosition = request.getParameter("stfPosition");
        String stfUserName = request.getParameter("stfUserName");
        String stfPswd = request.getParameter("stfPswd");

        try {

            Staff stf = new Staff(stfId, stfName, stfEmail, stfContactNo, stfPosition, stfUserName, stfPswd);
            stfDA.addStaff(stf);
            out.println("Staff <b>" + stfId + "</b> has been added to the database<br>");
            Staff s = stfDA.getStaffById(stfId);
            out.println("The staff " + s.getStfname() + " is now added to the database.");
            
            response.sendRedirect("StaffManagement.jsp");
        } catch (Exception ex) {
            out.println(ex.getMessage());
        } finally {
            out.close();
        }
    }
}
