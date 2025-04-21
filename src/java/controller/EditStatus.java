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
import model.ProductDa;

/**
 *
 * @author Mei Yen
 */
@WebServlet(name = "EditStatus", urlPatterns = {"/EditStatus"})
public class EditStatus extends HttpServlet {
    
    @PersistenceContext
    EntityManager em;
    
    @Resource
    UserTransaction utx;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String prodId=request.getParameter("prodId");

        ProdService prodService = new ProdService(em);

        //extra - check exist before delete product from db
        //make sure product exist if want to perform delete
        boolean prodExist=prodService.productExists(prodId);
 

        try {
            if(prodExist){
                //get all the details and store inside object
                Product prod = prodService.findProduct(prodId);
                
                //set the status
                int prodStatus=Integer.parseInt(request.getParameter("prodStatus"));
                if(prodStatus==1){
                    prodStatus=0;
                }else{
                    prodStatus=1;
                }
                
                prod.setStatus(prodStatus);
                
                //update the product status
                utx.begin();
                prodService.updateProduct(prod);
                utx.commit();
                
                ProductDa pda=new ProductDa();
                List<Product> prodList = pda.getAllProd();
                HttpSession session = request.getSession();
                //add admin staff session

                //set the prodlist session
                session.setAttribute("prodList", prodList);
                
                response.sendRedirect("viewProd.jsp");

            }else{
                //show alert - tell user prod not exist
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Product no exist!');");
                out.println("</script>");
                response.sendRedirect("viewProd.jsp");

            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
     
    }

}
