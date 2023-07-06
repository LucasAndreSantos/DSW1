<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Locação de Bicicletas</title>
</head>
<style>
  .welcome {
    text-align: right;
  }

  .left-link {
    float: left;
    margin-right: 20px;
  }

  .top-right {
    position: absolute;
    top: 10px;
    right: 10px;
  }
</style>
<body>
  <h1>Locação de Bicicletas</h1>
  <div class="welcome">
    <% 
      String loggedInUser = (String) session.getAttribute("loggedInUser");
      if (loggedInUser != null) {
    %>
      <h2>Bem-vindo <%= loggedInUser %></h2>
      <a href="admPT.jsp">Administração do Usuário</a>
      <br>
      <a href="ListarAluguelPT.jsp">Meus Aluguéis</a>
    <% } else { %>
      <p>Você precisa <a href="TelaLoginPT.jsp">fazer login</a> para realizar algumas ações.</p>
    <% } %>
  </div>
  <div class="left-link">
    <a href="LocacaoPT.jsp">Alugar Bicicleta</a>
    <br>
    <a href="ListaBicicletariasPT.jsp">Nossos Parceiros Comerciais</a>
    <br>
    <a href="CidadesPT.jsp">Encontre uma Loja em Sua Cidade!</a>
  </div>
  <div class="top-right">
    <form action="index.jsp">
      <button type="submit">English</button>
    </form>
  </div>
</body>
</html>
