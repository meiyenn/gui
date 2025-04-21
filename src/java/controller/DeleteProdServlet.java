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
import model.ProductDa;
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
        ProductDa pda = new ProductDa();

        //extra - check exist before delete product from db
        //make sure product exist if want to perform delete
        boolean prodExist=prodService.productExists(prodId);

        try {
            if(prodExist){
                //check whether product is in use(already add to cart/checkout by customer)
                boolean checkInUse=pda.isProdInUse(prodId);
                
                if(checkInUse){ //true - product is in use
                    // Show alert and redirect back
                    out.println("<script type='text/javascript'>");
                    out.println("alert('This product is currently in use and cannot be deleted. You may change its status to \"Hide\" instead.');");
                    out.println("window.location.href = 'viewProd.jsp';"); 
                    out.println("</script>");
                    
                }else{ //false - product is not in use

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

            }else{
                // Show alert and redirect back
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Product not found!');");
                    out.println("window.location.href = 'viewProd.jsp';"); // or 'AddProdServlet'
                    out.println("</script>");
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
