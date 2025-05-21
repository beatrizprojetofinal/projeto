<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String errorMessage = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        if (email == null || email.isEmpty() || senha == null || senha.isEmpty()) {
            errorMessage = "Credenciais em falta.";
        } else {
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ReabiPlay", "root", "Supermercado00");

                String sql = "SELECT id, tipo, palavra_passe, ativo FROM Utilizadores WHERE email = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, email);
                rs = ps.executeQuery();

                if (rs.next()) {
                    String senhaBD = rs.getString("palavra_passe");
                    String tipo = rs.getString("tipo");
                    int id = rs.getInt("id");
                    boolean ativo = rs.getBoolean("ativo");

                    if (senhaBD.equals(senha)) {
                        if ("Profissional".equals(tipo) && !ativo) {
                            response.sendRedirect("registopendente.jsp");
                            return;
                        }

                        session.setAttribute("userId", id);
                        session.setAttribute("userType", tipo);

                        switch (tipo) {
                            case "Paciente":
                                response.sendRedirect("pacienteprincipal.jsp");
                                break;
                            case "Profissional":
                                response.sendRedirect("profissionalprincipal.jsp");
                                break;
                            case "Familiar":
                                response.sendRedirect("familiarprincipal.jsp");
                                break;
                            case "Administrador":
                                response.sendRedirect("adminprincipal.jsp");
                                break;
                            default:
                                errorMessage = "Tipo de utilizador desconhecido.";
                        }
                        return;
                    } else {
                        errorMessage = "Senha incorreta.";
                    }
                } else {
                    errorMessage = "Email não encontrado.";
                }

            } catch (Exception e) {
                e.printStackTrace();
                errorMessage = "Erro de servidor: " + e.getMessage();
            } finally {
                if (rs != null) try { rs.close(); } catch(Exception ignored) {}
                if (ps != null) try { ps.close(); } catch(Exception ignored) {}
                if (conn != null) try { conn.close(); } catch(Exception ignored) {}
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8" />
    <title>ReabiPlay - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .header {
            background-color: #A0522D;
            color: white;
            padding: 60px 20px;
            text-align: center;
        }

        .header h1 {
            font-size: 48px;
            margin: 0;
        }

        .sub-header {
            font-size: 20px;
            margin-top: 10px;
            opacity: 0.9;
        }

        .form-wrapper {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .form-container {
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
        }

        .form-container h2 {
            margin-top: 0;
            margin-bottom: 30px;
            color: #A0522D;
        }

        .form-container label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #333;
            text-align: left;
        }

        .form-container input,
        .form-container select {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
        }

        .form-container button {
            background-color: #A0522D;
            color: white;
            padding: 14px;
            border: none;
            border-radius: 30px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        .form-container button:hover {
            background-color: #B5651D;
        }

        input[type="number"]::-webkit-outer-spin-button,
        input[type="number"]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        input[type="number"] {
            -moz-appearance: textfield;
        }

        @media (max-width: 480px) {
            .header h1 {
                font-size: 36px;
            }

            .sub-header {
                font-size: 16px;
            }

            .form-container {
                padding: 25px;
            }
        }
    </style>
</head>

<body>
    <div class="header">
        <h1>ReabiPlay</h1>
    </div>

    <div class="form-wrapper">
        <div class="form-container">
        
        	<h2>Login</h2>
        
            <% if (!errorMessage.isEmpty()) { %>
                <div class="error"><%= errorMessage %></div>
            <% } %>

            <form method="post" action="login.jsp">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required />

                <label for="senha">Palavra-passe:</label>
                <input type="password" id="senha" name="senha" required />

                <button type="submit">Entrar</button>
            </form>
        </div>
    </div>
</body>
</html>
