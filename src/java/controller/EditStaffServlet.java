/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Staff;
import model.StaffDA;

/**
 *
 * @author Mei Yen
 */
@WebServlet(name = "EditStaffServlet", urlPatterns = {"/EditStaffServlet"})
public class EditStaffServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String staffId = request.getParameter("staffId");
        
        try {
            StaffDA staffDa = new StaffDA();
            Staff staff = staffDa.getStaffById(staffId);
            
            if (staff != null) {
                HttpSession session = request.getSession();
                session.setAttribute("editStf", staff); //data before edit(ori data)
                RequestDispatcher rd = request.getRequestDispatcher("editStf.jsp");
                rd.forward(request, response);
                
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('Staff not found!');");
                out.println("window.location.href = 'StaffManagement.jsp';");
                out.println("</script>");
            }

        } catch (Exception ex) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Error occur! Unable to load staff details');");
                out.println("window.location.href = 'StaffManagement.jsp';");
                out.println("</script>");

        }
    
        
        
        
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String staffId = request.getParameter("staffId");
            String stfName = request.getParameter("stfName");
            String stfContactNo = request.getParameter("stfContactNo");
            String stfEmail = request.getParameter("stfEmail");
            String stfUserName = request.getParameter("stfUserName");
            String stfPswd = request.getParameter("stfPswd");
            String stfPosition = request.getParameter("stfPosition");

            StaffDA stfda = new StaffDA();

            Staff updatedStaff = new Staff();
            updatedStaff.setStaffid(staffId);
            updatedStaff.setStfname(stfName);
            updatedStaff.setStfcontactno(stfContactNo);
            updatedStaff.setStfemail(stfEmail);
            updatedStaff.setStfusername(stfUserName);
            updatedStaff.setStfpswd(stfPswd);
            updatedStaff.setStfposition(stfPosition);

            stfda.updateStaff(updatedStaff);
            
            out.println("<script type='text/javascript'>");
            out.println("alert('Staff updated successfully!');");
            out.println("window.location.href = 'StaffManagement.jsp';");
            out.println("</script>");


        } catch (Exception ex) {
            out.println("<script type='text/javascript'>");
            out.println("alert('Update failed!);");
            out.println("window.location.href = 'StaffManagement.jsp';");
            out.println("</script>");

        }
        
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
