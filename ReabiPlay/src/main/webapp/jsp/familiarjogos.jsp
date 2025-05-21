<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Verificar se o utilizador está logado e é um Familiar
    Integer userId = (Integer) session.getAttribute("userId");
    String userType = (String) session.getAttribute("userType");

    if (userId == null || !"Familiar".equals(userType)) {
        response.sendRedirect("html/login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>ReabiPlay - Jogos do Familiar</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/familiarprincipal.css"> <!-- Usa o CSS da familiarprincipal para sidebar e estilo geral -->
    <style>
        /* Estilos adicionais para jogos, adaptados do exemplo */
        .game-box {
            background-color: #d3d3d3;
            padding: 25px 30px;
            border-radius: 12px;
            margin-top: 20px;
            font-size: 18px;
            color: #333;
            max-width: 600px;
            width: 100%;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
            text-align: left;
        }

        .game-box strong {
            font-weight: 600;
            font-size: 20px;
        }

        .game-box button.button {
            margin-top: 15px;
            background-color: #A0522D;
            color: white;
            padding: 12px 28px;
            border: none;
            border-radius: 30px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .game-box button.button:hover {
            background-color: #B5651D;
        }

        .main-content button.button {
            margin-top: 30px;
            background-color: #A0522D;
            color: white;
            padding: 12px 28px;
            border: none;
            border-radius: 30px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .main-content button.button:hover {
            background-color: #B5651D;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="logo">ReabiPlay</div>
        <a href="familiarprincipal.jsp">Página Principal</a>
        <a href="familiarjogos.jsp">Jogos</a>
        <a href="familiarperfil.jsp">Perfil</a>
        <a href="paginainicial.jsp">Sair</a>
    </div>

    <div class="main-content">
        <h2>Jogos Disponíveis</h2>
        <p><em>Escolha um dos seguintes jogos para começar a jogar:</em></p>

        <div class="game-box">
            <strong>Jogo da Memória - 4 pares</strong><br><br>
            • Desafie a sua memória com este jogo simples e estimulante<br><br>
            <button class="button" onclick="window.location.href='familiarjogos.jsp'">Jogar</button>
        </div>
        
        <div class="game-box">
            <strong>Jogo da Memória - 8 pares</strong><br><br>
            • Desafie a sua memória com este jogo simples e estimulante<br><br>
            <button class="button" onclick="window.location.href='familiarjogos.jsp'">Jogar</button>
        </div>

        <div class="game-box">
            <strong>Jogo dos Pares</strong><br><br>
            • Teste as suas habilidades com este jogo de pares<br><br>
            <button class="button" onclick="window.location.href='familiarjogos.jsp'">Jogar</button>
        </div>

        <div class="game-box">
            <strong>Jogo das Palavras - Países</strong><br><br>
            • Encontre nomes de países escondidos numa sopa de letras desafiante<br><br>
            <button class="button" onclick="window.location.href='familiarjogos.jsp'">Jogar</button>
        </div>

        <div class="game-box">
            <strong>Jogo das Palavras - Cores</strong><br><br>
            • Identifique nomes de cores ocultos numa sopa de letras desafiante<br><br>
            <button class="button" onclick="window.location.href='familiarjogos.jsp'">Jogar</button>
        </div>

        <button class="button" onclick="window.location.href='familiarprincipal.jsp'">Voltar</button>
    </div>
</body>
</html>
