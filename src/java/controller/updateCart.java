package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.CartService;

@WebServlet(name = "updateCart", urlPatterns = {"/updateCart"})
public class updateCart extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");

        String cartItemId = request.getParameter("cartItemId"); 
        int currentQty = Integer.parseInt(request.getParameter("quantity"));
        String action = request.getParameter("action");

        int newQty = currentQty;
        if ("increase".equals(action)) {
            newQty++;
        } else if ("decrease".equals(action) && currentQty > 1) {
            newQty--;
        }

        try {
            CartService cartService = new CartService();
            cartService.updateQuantity(cartItemId, newQty); 
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ShoppingCart.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
