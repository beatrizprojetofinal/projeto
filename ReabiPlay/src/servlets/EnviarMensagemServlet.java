package servlets;

import dao.MensagemDAO;
import modelo.Mensagem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@WebServlet("/EnviarMensagemServlet")
public class EnviarMensagemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sessao = request.getSession(false);
        if (sessao == null || sessao.getAttribute("userId") == null) {
            response.sendRedirect("paginainicial.jsp");
            return;
        }

        int remetenteId = (Integer) sessao.getAttribute("userId");
        String userType = (String) sessao.getAttribute("userType");

        // Só permitimos envio para Pacientes ou Profissionais, conforme o tipo do user
        if (!"Paciente".equals(userType) && !"Profissional".equals(userType)) {
            response.sendRedirect("paginainicial.jsp");
            return;
        }

        String mensagemTexto = request.getParameter("mensagem");
        String destinatarioIdStr = request.getParameter("destinatarioId");

        if (mensagemTexto == null || mensagemTexto.trim().isEmpty() || destinatarioIdStr == null) {
            response.sendRedirect("paginainicial.jsp");
            return;
        }

        int destinatarioId;
        try {
            destinatarioId = Integer.parseInt(destinatarioIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("paginainicial.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00")) {
                MensagemDAO mensagemDAO = new MensagemDAO(conn);
                Mensagem msg = new Mensagem();
                msg.setRemetenteId(remetenteId);
                msg.setDestinatarioId(destinatarioId);
                msg.setMensagem(mensagemTexto.trim());
                mensagemDAO.enviarMensagem(msg);
            }

            // Redirecionar para a página correta consoante o user
            if ("Paciente".equals(userType)) {
                response.sendRedirect(request.getContextPath() + "jsp/pacientemensagens.jsp?msg=sucesso");
            } else if ("Profissional".equals(userType)) {
                response.sendRedirect(request.getContextPath() + "jsp/profissionalmensagens.jsp?msg=sucesso");
            } else {
                response.sendRedirect(request.getContextPath() + "jsp/paginainicial.jsp");
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/paginainicial.jsp");
        }
    }
}
