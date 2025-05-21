<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Jogo da Memória - 4 Pares</title>
    <link rel="stylesheet" href="css/memoria.css">
    <style>
		.game-board {
		    margin-top: 20px;
		    display: grid;
		    grid-template-columns: repeat(4, 100px);
		    gap: 10px;
		    justify-content: center;
		}

        .card {
            width: 100px;
            height: 100px;
            perspective: 1000px;
        }

        .card-inner {
            position: relative;
            width: 100%;
            height: 100%;
            transition: transform 0.6s ease;
            transform-style: preserve-3d;
        }

        .card-inner.flip {
            transform: rotateY(180deg);
        }

        .card .front, .card .back {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            font-size: 40px;
        }

        .card .front {
            background-color: #A0522D;
            color: white;
        }

        .card .back {
            background-color: white;
            transform: rotateY(180deg);
        }
        
        .info {
            font-size: 18px;
            color: black;
            margin-bottom: 20px;
        }

        #score, #timer {
            display: inline-block;
            min-width: 100px;
            color: black;
            font-weight: bold;
        }

        #mensagemFinal {
            display: none;
            font-size: 20px;
            font-weight: bold;
            margin-top: 20px;
            color: green;
            text-align: center;
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

<div class="main-content">
    <h2>Jogo da Memória - 4 Pares</h2>

        <div class="pontuacao">Pontuação: <span id="score">0</span></div>
        
        <div class="game-board" id="gameBoard"></div>
        <div id="mensagemFinal"></div>


    <button class="exit-button" onclick="window.location.href='pacientejogos.jsp'">Sair do Jogo</button>
</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const symbols = ['🍎', '🚗', '🐶', '🎵'];
    let cards = [...symbols, ...symbols];
    let flippedCards = [];
    let lockBoard = false;
    let score = 0;
    let matches = 0;
    const startTime = Date.now(); // Início do cronómetro

    const scoreElement = document.getElementById('score');
    const board = document.getElementById('gameBoard');
    const mensagemFinal = document.getElementById('mensagemFinal');

    cards.sort(() => 0.5 - Math.random());

    cards.forEach(symbol => {
        const card = document.createElement('div');
        card.className = 'card';

        const cardInner = document.createElement('div');
        cardInner.className = 'card-inner';

        const front = document.createElement('div');
        front.className = 'front';

        const back = document.createElement('div');
        back.className = 'back';
        back.textContent = symbol;

        cardInner.appendChild(front);
        cardInner.appendChild(back);
        card.appendChild(cardInner);
        board.appendChild(card);

        card.addEventListener('click', () => {
            if (lockBoard || cardInner.classList.contains('flip')) return;

            cardInner.classList.add('flip');
            flippedCards.push(card);

            if (flippedCards.length === 2) {
                lockBoard = true;

                const [first, second] = flippedCards;
                const symbol1 = first.querySelector('.back').textContent;
                const symbol2 = second.querySelector('.back').textContent;

                if (symbol1 === symbol2) {
                    score += 10;
                    matches++;
                    scoreElement.textContent = score;
                    flippedCards = [];
                    lockBoard = false;

                    if (matches === symbols.length) {
                        setTimeout(() => {
                            mensagemFinal.textContent = `Parabéns! Terminaste com ${score} pontos.`;
                            mensagemFinal.style.display = 'block';
                            registarPontuacao(score);
                        }, 500);
                    }
                } else {
                    setTimeout(() => {
                        first.querySelector('.card-inner').classList.remove('flip');
                        second.querySelector('.card-inner').classList.remove('flip');
                        flippedCards = [];
                        lockBoard = false;
                    }, 1000);
                }
            }
        });
    });

    function registarPontuacao(pontuacao) {
        const endTime = Date.now();
        const tempoDecorrido = Math.floor((endTime - startTime) / 1000); // em segundos

        fetch('registarPontuacao.jsp', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `pontuacao=${pontuacao}&tempo=${tempoDecorrido}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.sucesso) {
                console.log("Pontuação registada com sucesso!");
            } else {
                console.log("Erro ao registar pontuação: " + (data.erro || "Erro desconhecido"));
            }
        })
        .catch(error => {
            console.error("Erro de rede:", error);
        });
    }

});
</script>

</body>
</html>
