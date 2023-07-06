<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Registro de Clientes</title>
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
</head>
<body>
  <% 
    // Verifica se o usuário está logado e possui uma hierarquia de 1
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String userHierarchy = (String) session.getAttribute("userHierarchy");
    if (loggedInUser != null && "1".equals(userHierarchy)) {
  %>
    <h1>Registro de Clientes</h1>
    <div class="welcome">
      Bem-vindo <%= loggedInUser %> 
    </div>
    <form action="InsertClientePT.jsp" method="post">
      <label for="username">Nome de usuário:</label>
      <input type="text" name="username" id="username" required><br>
      
      <label for="cpf_cnpj">Documento:</label>
      <input type="text" name="cpf_cnpj" id="cpf_cnpj" required><br>
      
      <label for="email">Email:</label>
      <input type="email" name="email" id="email" required><br>

      <label for="data">Data de Nascimento:</label>
      <input type="date" name="datanascimento" id="datanascimento" required><br>

      <label for="telefone">Telefone:</label>
      <input type="number" name="telefone" id="telefone" required><br>
      
      <label for="Sexo">Sexo:</label>
      <select name="Sexo" id="Sexo" required>
        <option value="Masculino">Masculino</option>
        <option value="Feminino">Feminino</option>
      </select><br>

      <label for="hierarquia">Hierarquia:</label>
      <select name="hierarquia" id="hierarquia" required>
        <option value="1">Admin</option>
        <option value="0">Usuário</option>
      </select><br>
      
      <label for="senha">Senha:</label>
      <input type="password" name="senha" id="senha" required><br>
      
      <button type="submit">Registrar</button>
    </form>
  <% 
    } else {
  %>
    <h1>Erro: Acesso Negado</h1>
    <p>Você precisa estar logado como um usuário com hierarquia 1 para visualizar esta página.</p>
    <a href="TelaLoginPT.jsp">Ir para a página de login</a>
  <% 
    }
  %>
  <div class="top-right">
    <form action="CadastroCliente.jsp">
      <button type="submit">English</button>
    </form>
  </div>
  <form action="admPT.jsp">
    <button type="submit">Voltar</button>
  </form>
</body>
</html>
