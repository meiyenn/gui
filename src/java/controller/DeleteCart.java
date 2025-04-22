package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.CartService;

@WebServlet(name = "DeleteCart", urlPatterns = {"/DeleteCart"})
public class DeleteCart extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String cartItemId = request.getParameter("cartItemId"); 
        CartService cartService = new CartService();

        try {
            if (cartItemId != null && !cartItemId.isEmpty()) {
                cartService.removeFromCart(cartItemId); 
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to delete item: " + e.getMessage());
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

    @Override
    public String getServletInfo() {
        return "Handles removal of a cart item";
    }
}
