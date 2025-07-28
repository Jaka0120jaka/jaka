package controller;

import java.io.IOException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/change-language")
public class ChangeLanguageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String lang = request.getParameter("lang");
        String redirect = request.getParameter("redirect");

        // セッションに言語を保存
        if (lang != null && (lang.equals("ja") || lang.equals("en"))) {
            request.getSession().setAttribute("lang", lang);
        }

        // リダイレクト先が指定されていればそこへ、それ以外は login.jsp
        if (redirect != null && !redirect.trim().isEmpty()) {
            response.sendRedirect(redirect);
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
