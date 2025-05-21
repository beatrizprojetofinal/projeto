<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Jogo de Pares - Países e Capitais</title>
  <link rel="stylesheet" href="/css/jogopares.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    /* Estilos adicionais para pontuação */
    .score-container {
      font-size: 18px;
      font-weight: 700;
      margin: 15px 0;
      color: #333;
      text-align: center;
    }

    .result {
      font-size: 18px;
      font-weight: 600;
      color: #006400;
      text-align: center;
      margin-top: 10px;
      height: 24px;
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
  <h2>Jogo de Pares - Países e Capitais</h2>

  <p class="description">Escolha um país e depois a sua capital.</p>

  <div class="score-container">Pontuação: <span id="score">0</span></div>

  <div class="container">
    <div class="column" id="leftColumn">
      <div class="item" data-match="1">França</div>
      <div class="item" data-match="2">Brasil</div>
      <div class="item" data-match="3">Portugal</div>
      <div class="item" data-match="4">Japão</div>
      <div class="item" data-match="5">Canadá</div>
      <div class="item" data-match="6">Espanha</div>
      <div class="item" data-match="7">Itália</div>
      <div class="item" data-match="8">Alemanha</div>
      <div class="item" data-match="9">Argentina</div>
      <div class="item" data-match="10">México</div>
    </div>

    <div class="column" id="rightColumn">
      <div class="item" data-match="2">Brasília</div>
      <div class="item" data-match="3">Lisboa</div>
      <div class="item" data-match="1">Paris</div>
      <div class="item" data-match="4">Tóquio</div>
      <div class="item" data-match="5">Ottawa</div>
      <div class="item" data-match="6">Madrid</div>
      <div class="item" data-match="7">Roma</div>
      <div class="item" data-match="8">Berlim</div>
      <div class="item" data-match="9">Buenos Aires</div>
      <div class="item" data-match="10">Cidade do México</div>
    </div>
  </div>

  <p id="result" class="result"></p>

  <div class="footer-button" style="text-align:center; margin-top: 20px;">
    <button class="button" onclick="window.location.href='pacientejogos.jsp'">Voltar</button>
  </div>
</div>

<script>
  let firstSelection = null;
  let secondSelection = null;
  let score = 0;
  const items = document.querySelectorAll('.item');
  const result = document.getElementById('result');
  const scoreElement = document.getElementById('score');

  items.forEach(item => {
    item.addEventListener('click', () => {
      if (item.classList.contains('matched') || item === firstSelection) return;
      item.classList.add('selected');

      if (!firstSelection) {
        firstSelection = item;
      } else {
        secondSelection = item;

        const match1 = firstSelection.dataset.match;
        const match2 = secondSelection.dataset.match;

        if (match1 === match2) {
          firstSelection.classList.add('matched');
          secondSelection.classList.add('matched');
          score += 10;
          scoreElement.textContent = score;
          result.textContent = 'Par correto!';
        } else {
          result.textContent = 'Tente novamente!';
          setTimeout(() => {
            firstSelection.classList.remove('selected');
            secondSelection.classList.remove('selected');
            result.textContent = '';
          }, 1000);
        }

        firstSelection = null;
        secondSelection = null;
      }
    });
  });
</script>

</body>
</html>
