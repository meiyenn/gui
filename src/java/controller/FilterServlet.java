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
@WebServlet(name = "FilterServlet", urlPatterns = {"/FilterServlet"})
public class FilterServlet extends HttpServlet {

    @PersistenceContext
    EntityManager em;
    
    @Resource
    UserTransaction utx;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
//        int column=0;
//        column=Integer.parseInt(request.getParameter("filter"));
//        
//        
////testing
//        out.println("<script type=\"text/javascript\">");
//        out.println("alert('testing2! (" + column + ")');");
//        out.println("</script>");
//        
//        String value=request.getParameter("searchText");
//        
////testing
//        out.println("<script type=\"text/javascript\">");
//        out.println("alert('testing! (" + value + ")');");
//        out.println("</script>");

        String filterParam = request.getParameter("filter");
        String value = request.getParameter("searchText");
        int column = 0;

        if (filterParam != null && !filterParam.isEmpty())  {
            try {
                column = Integer.parseInt(filterParam);
            } catch (NumberFormatException e) {
                column = 0; // default to no filter
            }
        }

        List<Product> filteredList = null;
        ProductDa pda = new ProductDa();

        try {
            if(filterParam != null && !filterParam.trim().isEmpty()){
                if(column==1){
                    filteredList=pda.filterProd("productid", value);
                }else if(column==2){
                    filteredList=pda.filterProd("productname", value);
                }else if(column==3){
                    filteredList=pda.filterProd("category", value);
                }else if(column==4){
                    
                    filteredList=pda.filterProd("status", value);
                }else{
                    filteredList=pda.getAllProd();
                }

                //set the prodlist session
                HttpSession session = request.getSession();
                session.setAttribute("filterList", filteredList);
                
                RequestDispatcher rd = request.getRequestDispatcher("viewProd.jsp");
                rd.forward(request, response);
            }else if(column==0){
                filteredList=pda.getAllProd();
                
                //set the prodlist session
                HttpSession session = request.getSession();
                session.setAttribute("filterList", filteredList);
                
                RequestDispatcher rd = request.getRequestDispatcher("AddProdServlet");
                rd.forward(request, response);       
                        
            }else{
                filteredList=pda.getAllProd();
                
                //set the prodlist session
                HttpSession session = request.getSession();
                session.setAttribute("filterList", filteredList);
                
                RequestDispatcher rd = request.getRequestDispatcher("AddProdServlet");
                rd.forward(request, response);

            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        
    }

}

