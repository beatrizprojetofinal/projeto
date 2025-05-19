<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ReabiPlay - Jogos</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/pacientejogos.css">
</head>
<body>

  <!-- Sidebar -->
  <div class="sidebar">
    <div class="logo">ReabiPlay</div>
    <a href="pacienteprincipal.jsp">Página Principal</a>
    <a href="pacienteplanoreabilitacao.jsp">Plano de Reabilitação</a>
    <a href="pacientejogos.jsp">Jogos</a>
    <a href="pacienteestatisticas.jsp">Estatísticas</a>
    <a href="pacientemensagens.jsp">Mensagens</a>
    <a href="pacienteforum.jsp">Fórum</a>
    <a href="pacienteperfil.jsp">Perfil</a>
    <a href="paginainicial.jsp">Sair</a>
  </div>

  <!-- Main Content -->
  <div class="main-content">
    <h2>Jogos Disponíveis</h2>
    <p><em>Escolha um dos jogos abaixo para começar a jogar:</em></p>

    <!-- Jogos -->
    <div class="game-box">
      <strong>Jogo da Memória - 4 pares</strong><br><br>
      • Desafie a sua memória com este jogo simples e estimulante<br><br>
      <button class="button" onclick="window.location.href='jogomemoria.jsp'">Jogar</button>
    </div>
    
    <div class="game-box">
      <strong>Jogo da Memória - 8 pares</strong><br><br>
      • Desafie a sua memória com este jogo simples e estimulante<br><br>
      <button class="button" onclick="window.location.href='jogomemoria2.jsp'">Jogar</button>
    </div>

    <div class="game-box">
      <strong>Jogo dos Pares</strong><br><br>
      • Teste os seus reflexos e habilidades com este jogo de pares<br><br>
      <button class="button" onclick="window.location.href='jogopares.jsp'">Jogar</button>
    </div>

    <div class="game-box">
      <strong>Jogo das Palavras</strong><br><br>
      • Encontre diversos países numa sopa de palavras<br><br>
      <button class="button" onclick="window.location.href='jogopalavras.jsp'">Jogar</button>
    </div>

    <!-- Botão para voltar -->
    <button class="button" onclick="window.location.href='paginainicial.jsp'">Voltar</button>
  </div>

</body>
</html>
