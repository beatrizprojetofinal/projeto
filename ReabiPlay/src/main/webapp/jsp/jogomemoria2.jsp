<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.util.*" %>
<%@ page session="true" contentType="text/html; charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userType = (String) session.getAttribute("userType");

    if (userId == null || !"Paciente".equals(userType)) {
        response.sendRedirect("html/login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Jogo da Memória - 8 Pares</title>
    <link rel="stylesheet" href="css/memoria2.css">
    <style>
        .pontuacao { font-size: 18px; margin: 10px; }

        .card-inner {
            width: 100%;
            height: 100%;
            position: relative;
            transform-style: preserve-3d;
            transition: transform 0.6s;
        }

        .card.flip .card-inner {
            transform: rotateY(180deg);
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="logo">ReabiPlay</div>
    <a href="pacienteprincipal.jsp">Página Principal</a>
    <a href="pacienteplanoreabilitacao.jsp">Plano de Reabilitação</a>
    <a href="pacientejogos.jsp">Jogos</a>
    <a href="pacientemensagens.jsp">Mensagens</a>
    <a href="pacienteforum.jsp">Fórum</a>
    <a href="pacienteperfil.jsp">Perfil</a>
    <a href="paginainicial.jsp">Sair</a>
</div>

<div class="main">
	<h2>Jogo da Memória - 8 Pares</h2>

    <div class="pontuacao">Pontuação: <span id="score">0</span></div>
    <div class="game-board" id="gameBoard"></div>
    
    
    <button class="exit-button" onclick="window.location.href='pacientejogos.jsp'">Sair do Jogo</button>
    
</div>

<script>
    const symbols = ['🍎', '🚗', '🐶', '🎵', '🌟', '🏀', '📚', '🎲'];
    let cards = [...symbols, ...symbols];
    let flippedCards = [];
    let lockBoard = false;
    let score = 0;
    let matchedPairs = 0;
    let startTime = new Date();

    cards.sort(() => 0.5 - Math.random());

    const board = document.getElementById('gameBoard');
    const scoreDisplay = document.getElementById('score');

    cards.forEach(symbol => {
        const card = document.createElement('div');
        card.classList.add('card');

        const inner = document.createElement('div');
        inner.classList.add('card-inner');

        const front = document.createElement('div');
        front.classList.add('front');

        const back = document.createElement('div');
        back.classList.add('back');
        back.textContent = symbol;

        inner.appendChild(front);
        inner.appendChild(back);
        card.appendChild(inner);

        card.addEventListener('click', () => {
            if (lockBoard || card.classList.contains('flip')) return;

            card.classList.add('flip');
            flippedCards.push(card);

            if (flippedCards.length === 2) {
                lockBoard = true;

                const [first, second] = flippedCards;

                const firstSymbol = first.querySelector('.back').textContent;
                const secondSymbol = second.querySelector('.back').textContent;

                if (firstSymbol === secondSymbol) {
                    score += 10;
                    matchedPairs++;
                    scoreDisplay.textContent = score;

                    flippedCards = [];
                    lockBoard = false;

                    if (matchedPairs === 8) {
                        const endTime = new Date();
                        const executionTime = Math.floor((endTime - startTime) / 1000);
                        saveScore(score, executionTime);
                    }
                } else {
                    setTimeout(() => {
                        first.classList.remove('flip');
                        second.classList.remove('flip');
                        flippedCards = [];
                        lockBoard = false;
                    }, 1000);
                }
            }
        });


        board.appendChild(card);
    });

    function saveScore(score, time) {
        fetch("registarPontuacao2.jsp", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: `pontuacao=${score}&tempo=${time}`
        })
        .then(res => res.text())
        .then(msg => alert(msg))
        .catch(err => alert("Erro ao guardar pontuação: " + err));
    }
</script>

</body>
</html>
