/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.annotation.Resource;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.transaction.UserTransaction;
import model.ProdService;
import model.Product;

/**
 *
 * @author Mei Yen
 */
@WebServlet(name = "DeleteProdServlet", urlPatterns = {"/DeleteProdServlet"})
public class DeleteProdServlet extends HttpServlet {

    @PersistenceContext
    EntityManager em;
    
    @Resource
    UserTransaction utx;
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String prodId=request.getParameter("prodId");
            
        
        ProdService prodService = new ProdService(em);

        //extra - check exist before delete product from db
        //make sure product exist if want to perform delete
        boolean prodExist=prodService.productExists(prodId);
        out.println(prodExist);

        try {
            if(prodExist){
//                utx.begin();
//                Product prod = em.find(Product.class, prodId);
//
//                //testing
//                out.println("alert('find or not! " + prod + "');");
//                em.remove(prod);
//
//                out.println("alert('after remove! " + prod + "');");
                
                //out.println(prodExist);
                utx.begin();
                prodService.deleteProduct(prodId);
                utx.commit();
                //out.println("alert('after remove! " + prodId + "');");
                //window pop box
                
                //set product session
                List<Product> prodList = prodService.findAll();
                HttpSession session = request.getSession();
                session.setAttribute("prodList", prodList);
                
                //redirect to view prod page
                RequestDispatcher rd = request.getRequestDispatcher("AddProdServlet");//
                rd.forward(request, response);

            }
        } catch (Exception ex) {
            out.println(ex.getMessage());
            ex.printStackTrace();
        }
            
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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
